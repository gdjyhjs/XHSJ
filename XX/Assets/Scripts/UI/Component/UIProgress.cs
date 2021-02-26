using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIProgress : MonoBehaviour {
    RectTransform rtf;
    public float speed = 100;
    float size;
    float _target;
    public float target
    {
        set
        {
            size = 0;
            _target = value;
            speed = Mathf.Abs(speed);
            if (!enabled) {
                enabled = true;
            }
        }
    }

    public void SetMove(float start, float end) {
        if (start > end) {
            speed = -Mathf.Abs(speed);
        } else {
            speed = Mathf.Abs(speed);
        }
        size = start;
        _target = end;
        if (!enabled) {
            enabled = true;
        }
    }


    private void Awake() {
        rtf = (RectTransform)transform;
    }

    private void Update() {
        size += speed * Time.deltaTime;
        if ((speed > 0 && size >= _target)|| (speed < 0 && size <= _target)) {
            size = _target;
            enabled = false;
        }
        rtf.sizeDelta = new Vector2(size, rtf.sizeDelta.y);
    }
}
