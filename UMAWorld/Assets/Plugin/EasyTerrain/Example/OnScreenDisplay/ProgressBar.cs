//using System.Collections;
//using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace MouseSoftware
{
    [ExecuteInEditMode]
    public class ProgressBar : MonoBehaviour
    {
        public Slider progressBar;
        public Text progressText;
        [Range(0f,10f)]
        public float fadeOutTime = 5f;
        private float prevTime;
        private Canvas canvas;

        //==================================================================

        void OnEnable()
        {
            if (progressBar == null)
            {
                progressBar = gameObject.GetComponentInChildren<Slider>();
            }
            progressBar.minValue = 0f;
            progressBar.maxValue = 100f;
            if (progressText == null)
            {
                progressText = gameObject.GetComponentInChildren<Text>();
            }
            canvas = gameObject.GetComponent<Canvas>();
            prevTime = Time.fixedUnscaledTime;
        } // void OnEnable()

        //==================================================================

        void Update()
        {
            float statusPercentage = MouseSoftware.EasyTerrain.GetUpdateStatusPercentage();
            progressBar.value = statusPercentage;
            progressText.text = System.String.Format("{0:F0}% ({1:F2} s)", progressBar.value, MouseSoftware.EasyTerrain.GetStopwatchElapsedSeconds());
			if (statusPercentage >= 100f && Application.isPlaying)
            {
                if (Time.unscaledTime - prevTime > fadeOutTime)
                {
                    canvas.enabled = false;
                }
            } else {
                prevTime = Time.fixedUnscaledTime;
                canvas.enabled = true;
            }
        } // void Update()

        //==================================================================

    }   
}

