using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AreaTrriger : MonoBehaviour
{
    public string trigger_tag = "Player";
    /// <summary>
    /// 区域id
    /// </summary>
    public int area_id;
    private void OnTriggerEnter(Collider other) {
        Debug.Log(other + " " + (other.tag == trigger_tag) + "进入" + other.tag + " " + this);
        if (other.tag == trigger_tag) {
        }
    }

    private void OnTriggerExit(Collider other) {
        Debug.Log(other + " " + (other.tag == trigger_tag) + "离开" + other.tag + " " + this);
        if (other.tag == trigger_tag) {
        }
    }
}
