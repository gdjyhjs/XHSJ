using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RoleModelUI : MonoBehaviour {
    public Transform roleCamera;
    public RectTransform rawimage;

    private void Awake() {
        rawimage.anchoredPosition = new Vector2(0, 0);
        rawimage.localEulerAngles = Vector3.one;
    }

    private void OnEnable() {
        RoleShow mainRole = RoleShow.mainRole;
        if (mainRole) {
            Transform target = mainRole.playerAnim.transform;
            roleCamera.position = target.position + target.forward * 4 + new Vector3(0,1,0) + target.right * 3;
            roleCamera.LookAt(target.position);
        } else {
        }
    }
}
