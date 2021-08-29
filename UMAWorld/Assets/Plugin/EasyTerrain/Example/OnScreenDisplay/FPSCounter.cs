using UnityEngine;
using UnityEngine.UI;

public class FPSCounter : MonoBehaviour
{
    [Range(0, 120)]
    [SerializeField]
    private int frameRange = 60;
    private int fps_average;
    private int fps_highest;
    private int fps_lowest;

    private int[] fpsBuffer;
    private int fpsBufferIndex;

    //[Range(0, 1000)]
    //[SerializeField]
    private int maxValue = 400;
    [SerializeField]
    private Text FPSLabel_average = null;
    [SerializeField]
    private Text FPSLabel_highest = null;
    [SerializeField]
    private Text FPSLabel_lowest = null;

    static string[] FPStextStrings;

    [System.Serializable]
    public struct FPSColor
    {
        public Color color;
        public int minimumFPS;
    }
    [SerializeField]
    private FPSColor[] labelColor;

    //================================================================================

    void Awake()
    {
        FPStextStrings = new string[maxValue + 1];
        for (int i = 0; i <= maxValue; i++)
        {
            FPStextStrings[i] = i.ToString("000");
        }

        labelColor = new FPSColor[5];
        labelColor[0].minimumFPS = 60;
        labelColor[0].color = new Color(1f, 1f, 1f);
        labelColor[1].minimumFPS = 45;
        labelColor[1].color = new Color(0.5f, 1f, 0f);
        labelColor[2].minimumFPS = 30;
        labelColor[2].color = new Color(1f, 1f, 0f);
        labelColor[3].minimumFPS = 15;
        labelColor[3].color = new Color(1f, 0.5f, 0f);
        labelColor[4].minimumFPS = 0;
        labelColor[4].color = new Color(1f, 0f, 0f);
    }

    //================================================================================

    void Update()
    {
        if (fpsBuffer == null || fpsBuffer.Length != frameRange)
        {
            InitializeBuffer();
        }
        UpdateBuffer();
        CalculateFPS();

        if (FPSLabel_average != null)
        {
            DisplayFPS(FPSLabel_average, fps_average);
        }

        if (FPSLabel_lowest != null)
        {
            DisplayFPS(FPSLabel_lowest, fps_lowest);
        }

        if (FPSLabel_highest != null)
        {
            DisplayFPS(FPSLabel_highest, fps_highest);
        }
    }

    //================================================================================

    void InitializeBuffer()
    {
        if (frameRange <= 0)
        {
            frameRange = 1;
        }
        fpsBuffer = new int[frameRange];
        fpsBufferIndex = 0;
    }

    //================================================================================

    void UpdateBuffer()
    {
        fpsBuffer[fpsBufferIndex++] = (int)(1f / Time.unscaledDeltaTime);
        if (fpsBufferIndex >= frameRange)
        {
            fpsBufferIndex = 0;
        }
    }

    //================================================================================

    void CalculateFPS()
    {
        int sum = 0;
        int highest = 0;
        int lowest = int.MaxValue;
        for (int i = 0; i < frameRange; i++)
        {
            int fps = fpsBuffer[i];
            sum += fps;
            if (fps > highest)
            {
                highest = fps;
            }
            if (fps < lowest)
            {
                lowest = fps;
            }
        }
        fps_average = (int)((float)sum / frameRange);
        fps_highest = highest;
        fps_lowest = lowest;
    }

    //================================================================================

    void DisplayFPS(Text label, int fps)
    {
        label.text = FPStextStrings[Mathf.Clamp(fps, 0, maxValue)];
        for (int i = 0; i < labelColor.Length; i++)
        {
            if (fps >= labelColor[i].minimumFPS)
            {
                label.color = labelColor[i].color;
                break;
            }
        }
    }

    //================================================================================

}