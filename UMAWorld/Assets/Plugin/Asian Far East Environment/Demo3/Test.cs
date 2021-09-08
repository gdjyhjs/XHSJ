using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace UMAWorld {
    public class Test : MonoBehaviour {

        public GameObject prefab;
        LineRenderer line;
        public Transform[] list;
        public int length = 50;
        private void Awake() {
            list = new Transform[length];
            line = gameObject.AddComponent<LineRenderer>();
            for (int i = 0; i < list.Length; i++) {
                list[i] = Instantiate(prefab).transform;
                list[i].position = new Vector3(100 * i, (i % 2 == 0 ? 1 : -1) * 100, 0);
            }

            
        }

        void Update() {
            Draw();
        }

        private void Draw() {
            Vector3[] pos = new Vector3[length * 5];
            Vector3[] data = new Vector3[list.Length];
            for (int i = 0; i < list.Length; i++) {
                data[i] = list[i].position;
            }
            for (float i = 0; i < pos.Length; i++) {
                pos[(int)i] = MathTools.BezierCurve(data, i / pos.Length);
            }

            line.positionCount = pos.Length;
            line.SetPositions(pos);
        }
    }
}