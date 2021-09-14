using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld {
    public class AutoSun : MonoBehaviour
    {
        private void Update() {
            System.DateTime date = g.date.Time;
            float angle = Mathf.Lerp(-90, 270, (date.Hour * 3600 + date.Minute * 60 + date.Second) / 86400f);
            transform.eulerAngles = new Vector3(angle, -30, 0);
        }
    }
}