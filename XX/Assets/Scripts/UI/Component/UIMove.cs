using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIMove : MonoBehaviour
{
    RectTransform rtf;
    public float speed = 100;

    Vector2 _def;
    Vector2 _target;
    public Vector2 target
    {
        set
        {
            _target = value;
            if (!enabled) {
                enabled = true;
            }
        }
    }
    public Vector2 def
    {
        get
        {
            return _def;
        }
    }

    private void Awake() {
        rtf = (RectTransform)transform;
        _def = rtf.anchoredPosition;
        _target = _def;
    }

    private void Update() {
        Vector2 dir = _target - rtf.anchoredPosition;
        Vector2 move = dir.normalized * speed * Time.deltaTime;
        Vector3 tar;
        if (move.magnitude > dir.magnitude) {
            tar = rtf.anchoredPosition += dir;
        } else {
            tar = rtf.anchoredPosition += move;
        }
        if (Vector3.Distance(rtf.anchoredPosition, _target) < 0.01f) {
            enabled = false;
        }
    }
}
