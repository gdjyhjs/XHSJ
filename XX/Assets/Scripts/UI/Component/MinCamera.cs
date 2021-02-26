using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MinCamera : MonoBehaviour
{
    public static MinCamera instance;
    private void Awake() {
        if (instance == null) {
            instance = this;
        }
    }

    public static void SetPos(Vector3 pos) {
        Tools.SetCameraPos(instance.transform, pos);
    }
}
