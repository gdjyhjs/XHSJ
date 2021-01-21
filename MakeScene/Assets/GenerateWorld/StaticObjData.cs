using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace GenerateWorld {
    [System.Serializable]
    public class StaticObjsData : StaticData {
        public StaticObj[] objs;
        public void Init() {
            for (int i = 0; i < objs.Length; i++) {
                CalculateSize(objs[i].prefab, out objs[i].size, out objs[i].scale);
            }
        }
    }


    [System.Serializable]
    public class StaticObjData : StaticData {
        public StaticObj obj;
        public void Init() {
             CalculateSize(obj.prefab, out obj.size,out obj.scale);
        }
    }


    [System.Serializable]
    public class StaticData {
        public float count;
        public string name;
        protected void CalculateSize(GameObject obj, out Vector3 size, out Vector3 scale) {
            MeshFilter mesh = obj.GetComponent<MeshFilter>();
            if (mesh == null) {
                size = Vector3.one;
                scale = Vector3.one;
            } else {
                size = mesh.mesh.bounds.size;
                scale = new Vector3(1 / size.x, 1 / size.y, 1 / size.z);
            }
        }
    }

    [System.Serializable]
    public class StaticObj {
        public GameObject prefab;
        [HideInInspector]
        public Vector3 scale;
        public Vector3 size;
    }
}