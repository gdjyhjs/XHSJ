using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace UMAWorld {
    public class UIWorldLoading : UIBase {
        public Slider slider;
        public Text text;

        private void Awake() {
            g.uiWorldLoading = this;
            GetComponent<CanvasGroup>().alpha = 1;
        }

        public void Open() {
            gameObject.SetActive(true);
        }

        public void Close() {
            gameObject.SetActive(false);
        }

        public void Update() {
            float statusPercentage = MouseSoftware.EasyTerrain.GetUpdateStatusPercentage();
            slider.value = statusPercentage;
            text.text = System.String.Format("{0:F0}%)", statusPercentage);
        }
    }
}