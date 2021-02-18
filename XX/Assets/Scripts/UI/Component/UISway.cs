using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Ò¡°Ú
public class UISway : MonoBehaviour
{
    public float speed = 2;
    public float range = 5;
    private float value;
    private bool dir;
    Transform tf;
    private void Awake() {
        tf = transform;
    }
    void Update()
    {
        if (dir) {
            value += speed * Time.deltaTime;
            if (value > range) {
                dir = false;
            }
        } else {
            value -= speed * Time.deltaTime;
            if (value < -range) {
                dir = true;
            }
        }
        tf.eulerAngles = new Vector3(0, 0, value);
    }
}
