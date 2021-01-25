using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace GenerateWorld {
    public class AreaTrriger : MonoBehaviour {
        public string trigger_tag = "Player";

        /// <summary>
        /// 区域id
        /// </summary>
        public int area_id;
        private void OnTriggerEnter(Collider other) {
            if (other.tag == trigger_tag) {
                //Debug.Log(other + " 进入 " + area_id);
                GenerateMap.instance.EnterArea(area_id);
            }
        }

        private void OnTriggerExit(Collider other) {
            if (other.tag == trigger_tag) {
                //Debug.Log(other + " 离开 " + area_id);
                GenerateMap.instance.ExitArea(area_id);
            }
        }
    }
}