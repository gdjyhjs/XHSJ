using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace UMAWorld {
    public class AnimEvent : MonoBehaviour {
        public UnitMono unitMono;

        public void OnAttack(string key) {
            if (unitMono == null) {
                Debug.Log("mono�����ڣ�");
                return;
            }
            switch (key) {
                case "L3":
                    unitMono.UseSkill(0, 1);
                    break;
                case "R2":
                    unitMono.UseSkill(1, 2);
                    break;
                default:
                    Debug.Log("����δʵ�֣�" + key);
                    break;
            }
        }
    }
}