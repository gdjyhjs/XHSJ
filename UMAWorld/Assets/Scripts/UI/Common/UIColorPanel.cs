using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class UIColorPanel : MonoBehaviour {

    [SerializeField]
    Color rawColor;
    [SerializeField]
    RawImage colorSV, colorH, colorR, colorG, colorB;
    [SerializeField]
    InputField InputR, InputG, InputB;
    Texture2D texSV, texH, texR, texG, texB;
    [SerializeField]
   float  m_h, s, v, r, g, b;
    float h
    {
        get { return m_h; }
        set { m_h = value; if(h < 0 || h == 300)Debug.Log(h); }
    }

    [SerializeField]
    Slider sliderR, sliderG, sliderB;
    [SerializeField]
    RectTransform rtfH, rtfSV, rtfHLeftDown, rtfHRightUp, rtfSVLeftDown, rtfSVRightUp;
    [SerializeField]
    Image imgSV;

    System.Action<Color> changeCall;

    private void Start() {
        InitColor();

        SetColor(rawColor);

        sliderR.onValueChanged.AddListener(OnChangeR);
        sliderG.onValueChanged.AddListener(OnChangeG);
        sliderB.onValueChanged.AddListener(OnChangeB);

        InputR.onValueChanged.AddListener((value) => {
            int.TryParse(value, out int r);
            r = Mathf.Clamp(r, 0, 255);
            OnChangeR(r / 255f);
        });

        InputG.onValueChanged.AddListener((value) => {
            int.TryParse(value, out int g);
            g = Mathf.Clamp(g, 0, 255);
            OnChangeG(g / 255f);
        });

        InputB.onValueChanged.AddListener((value) => {
            int.TryParse(value, out int b);
            b = Mathf.Clamp(b, 0, 255);
            OnChangeB(b / 255f);
        });

        EventTrigger triggerSV = colorSV.gameObject.AddComponent<EventTrigger>();

        EventTrigger.Entry clickSV = new EventTrigger.Entry();
        clickSV.eventID = EventTriggerType.PointerDown;
        clickSV.callback.AddListener(OnClickSV);

        EventTrigger.Entry dragSV = new EventTrigger.Entry();
        dragSV.eventID = EventTriggerType.Drag;
        dragSV.callback.AddListener(OnClickSV);

        triggerSV.triggers.Add(clickSV);
        triggerSV.triggers.Add(dragSV);

        EventTrigger triggerH = colorH.gameObject.AddComponent<EventTrigger>();

        EventTrigger.Entry clickH = new EventTrigger.Entry();
        clickH.eventID = EventTriggerType.PointerDown;
        clickH.callback.AddListener(OnClickH);

        EventTrigger.Entry dragH = new EventTrigger.Entry();
        dragH.eventID = EventTriggerType.Drag;
        dragH.callback.AddListener(OnClickH);

        triggerH.triggers.Add(clickH);
        triggerH.triggers.Add(dragH);
    }

    private void OnDisable() {
        changeCall = null;
    }

    private void OnClickSV(BaseEventData data) {
        rtfSV.position = Input.mousePosition;
        OnColorChange(h, Mathf.Clamp(rtfSV.anchoredPosition.x, 0, 80) / 80, Mathf.Clamp(rtfSV.anchoredPosition.y, 0, 80) / 80);
    }
    private void OnClickH(BaseEventData data) {
        rtfH.position = Input.mousePosition;
        float angle = Vector2.Angle(rtfH.anchoredPosition, new Vector2(1, 0));
        if (rtfH.anchoredPosition.y < 0)
            angle = 360 - angle;
        OnColorChange(angle, s, v);
    }

    private void OnChangeR(float r) {
        rawColor = new Color(r, rawColor.g, rawColor.b);
        OnColorChange();
    }

    private void OnChangeG(float g) {
        rawColor = new Color(rawColor.r, g, rawColor.b);
        OnColorChange();
    }

    private void OnChangeB(float b) {
        rawColor = new Color(rawColor.r, rawColor.g, b);
        OnColorChange();
    }

    private void InitColor() {
        texSV = new Texture2D(80, 80);
        texH = new Texture2D(360, 360);
        texR = new Texture2D(160, 1);
        texG = new Texture2D(160, 1);
        texB = new Texture2D(160, 1);
        colorSV.texture = texSV;
        colorH.texture = texH;
        colorR.texture = texR;
        colorG.texture = texG;
        colorB.texture = texB;

        Vector2 center = new Vector2(180, 180);
        Vector2 start = new Vector2(1, 0);
        float max = 179, min = 139;
        for (int x = 0; x < 360; x++) {
            for (int y = 0; y < 360; y++) {
                Vector2 pos = new Vector2(x, y);
                float dis = Vector2.Distance(center, pos);
                if (dis < min || dis > max) {
                    texH.SetPixel(x, y, new Color(0, 0, 0, 0));
                } else {
                    Vector2 dir = pos - center;
                    float angle = Vector2.Angle(start, dir);
                    angle = y < 180 ? 360 - angle : angle;
                    Color c = StaticTools.ColorFromHSV(angle, 1, 1);
                    texH.SetPixel(x, y, c);
                }
            }
        }
        texH.Apply();
    }

    public void SetColor(Color c, System.Action<Color> changeCall = null) {
        onColorChange = true;
        rawColor = c;
        sliderR.value = c.r;
        sliderG.value = c.g;
        sliderB.value = c.b;

        this.changeCall = changeCall;


        onColorChange = false;
        OnColorChange();
    }

    bool onColorChange = false;

    public void OnColorChange(float h, float s, float v) {
        if (onColorChange)
            return;
        onColorChange = true;

        this.h = h;
        this.s = s;
        this.v = v;

        rawColor = StaticTools.ColorFromHSV(h, s, v);
        r = rawColor.r;
        g = rawColor.g;
        b = rawColor.b;

        for (int x = 0; x < 80; x++) {
            for (int y = 0; y < 80; y++) {
                Color c = StaticTools.ColorFromHSV(h, Mathf.Lerp(0, 1, x / 79f), Mathf.Lerp(0, 1, y / 79f));
                texSV.SetPixel(x, y, c);
            }
        }
        texSV.Apply();

        for (int x = 0; x < 160; x++) {
            for (int y = 0; y < 1; y++) {
                texR.SetPixel(x, y, new Color(Mathf.Lerp(0, 1, x / 159f), g, b, 1));
                texG.SetPixel(x, y, new Color(r, Mathf.Lerp(0, 1, x / 159f), b, 1));
                texB.SetPixel(x, y, new Color(r, g, Mathf.Lerp(0, 1, x / 159f), 1));
            }
        }
        texR.Apply();
        texG.Apply();
        texB.Apply();
        
        sliderR.value = r;
        sliderG.value = g;
        sliderB.value = b;
        
        rtfH.anchoredPosition = Quaternion.AngleAxis(h, Vector3.forward) * new Vector3(159, 0);
        
        rtfSV.anchoredPosition = new Vector2(s, v) * 80;
        imgSV.color = (s < .5f && v > .5f) ? Color.black : Color.white;

        InputR.text = Mathf.RoundToInt(r * 255).ToString();
        InputG.text = Mathf.RoundToInt(g * 255).ToString();
        InputB.text = Mathf.RoundToInt(b * 255).ToString();

        changeCall?.Invoke(rawColor);

        onColorChange = false;
    }

    public void OnColorChange() {
        if (onColorChange)
            return;

        float h, s, v;
        StaticTools.ColorToHSV(rawColor, out h, out s, out v);
        OnColorChange(h, s, v);
    }
}
