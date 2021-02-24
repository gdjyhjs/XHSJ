using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RoleModelUI : MonoBehaviour {
    public Transform roleCamera;
    public RectTransform rawimage;

    private void Awake() {
        //rawimage.anchoredPosition = new Vector2(0, 0);
        //rawimage.localEulerAngles = Vector3.one;
    }

    Vector3 last_pos;
    private void UpdateCamera(object param = null) {
        RoleShow mainRole = RoleShow.mainRole;
        if (mainRole) {
            Transform target = mainRole.playerAnim.transform;
            if (last_pos != target.position) {
                if (mainRole.rideAnim) {
                    roleCamera.position = target.position + target.forward * 5 + target.right * 2f;
                    roleCamera.LookAt(target.position);
                } else {
                    roleCamera.position = target.position + target.forward * 10f + target.right * 1f + new Vector3(0, 4f, 0);
                    roleCamera.LookAt(target.position + new Vector3(0, 4f, 0));
                }
            }
        }
    }

    private void OnEnable() {
        UpdateCamera();
        EventManager.AddEvent(EventTyp.ChangePos, UpdateCamera);
    }

    private void OnDisable() {
        EventManager.RemoveEvent(EventTyp.ChangePos, UpdateCamera);
    }
}
