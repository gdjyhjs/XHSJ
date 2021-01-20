using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace GenerateWorld {
    [System.Serializable]
    public class StaticObjsData : StaticData {
        public StaticObj[] objs;
        public void Init() {
            for (int i = 0; i < objs.Length; i++) {
                objs[i].size = CalculateSize(objs[i].prefab);
            }
        }
    }


    [System.Serializable]
    public class StaticObjData : StaticData {
        public StaticObj obj;
        public void Init() {
            obj.size = CalculateSize(obj.prefab);
        }
    }


    [System.Serializable]
    public class StaticData {
        public float count;
        public string name;
        protected Vector3 CalculateSize(GameObject obj) {
            MeshFilter mesh = obj.GetComponent<MeshFilter>();
            if (mesh == null) {
                return Vector3.one;
            }
            var size = mesh.mesh.bounds.size;
            return new Vector3(1 / size.x, 1 / size.y, 1 / size.z);
        }
    }

    [System.Serializable]
    public class StaticObj {
        public GameObject prefab;
        [HideInInspector]
        public Vector3 size;
    }
}