using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestActive : MonoBehaviour
{
    private void OnEnable() {
        Debug.Log("OnEnable " + gameObject);
    }
    private void OnDisable() {
        Debug.Log("OnDisable " + gameObject);
    }
}
