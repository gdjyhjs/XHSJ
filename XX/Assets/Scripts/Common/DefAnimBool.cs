using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DefAnimBool : MonoBehaviour
{
    public string animName;

    private void OnEnable() {
        var anim = GetComponent<Animator>();
        anim.SetBool(animName, true);
    }
}
