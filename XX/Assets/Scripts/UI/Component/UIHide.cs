using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIHide : MonoBehaviour {
    RectTransform rtf;
    public float speed = 1;
    UnityEngine.UI.Graphic graphic;
    float a;
    private void Awake() {
        rtf = (RectTransform)transform;
        graphic = GetComponent<UnityEngine.UI.Graphic>();
    }

    private void Update() {
        a -= speed * Time.deltaTime;
        if (a <= 0) {
            a = 0;
            enabled = false;
        }
        graphic.color = new Color(graphic.color.r, graphic.color.g, graphic.color.b, a);
    }

    public void Rest() {
        a = 1;
        if (!enabled) {
            enabled = true;
        }
    }
}
