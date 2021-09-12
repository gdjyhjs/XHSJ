using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld {
    public class AutoHideOnSchool : MonoBehaviour
    {
        private void Start() {
            // 判断宗门区域
            foreach (BuildBase item in g.builds.allBuild.Values) {
                if (MathTools.PointIsInPolygon(item.points, new Vector2(transform.position. x, transform.position.z))){
                    gameObject.SetActive(false);
                    return;
                }
            }
        }
    }
}