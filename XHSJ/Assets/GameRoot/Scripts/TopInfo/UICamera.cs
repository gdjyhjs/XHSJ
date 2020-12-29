using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UICamera:MonoBehaviour
{
    public static Camera uiCamera;
    private void Awake() {
        uiCamera = GetComponent<Camera>();
    }
}