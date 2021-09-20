using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld {
    public class AutoHideOnSchool : MonoBehaviour
    {
        private void Start() {
            // 判断宗门区域
            foreach (BuildSchool item in g.builds.allSchool.Values) {
                if (MathTools.PointIsInPolygon(item.points, new Vector3(transform.position. x, 0, transform.position.z))){
                    gameObject.SetActive(false);
                    return;
                }
            }
        }
    }
}