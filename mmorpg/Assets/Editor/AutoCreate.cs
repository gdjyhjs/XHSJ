using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;

public class AutoCreate
{
    [MenuItem("auto/createModel")]
    static void CreateModelPrefab() {
        CreatePrefab("Assets/Model");
    }

    [MenuItem("auto/createEffect")]
    static void CreateEffectPrefab() {
        CreatePrefab("Assets/GameEffect");
    }

    static void CreatePrefab(string dir) {
        string[] files = Directory.GetFiles(dir, "*.prefab", SearchOption.AllDirectories);
        int count = (int)Mathf.Ceil(Mathf.Sqrt(files.Length));
        for (int x = 0; x < count; x++) {
            for (int z = 0; z < count; z++) {
                var idx = count * x + z;
                if (idx >= files.Length)
                    return;
                GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(files[idx]);
                GameObject target = GameObject.Instantiate<GameObject>(obj);
                Transform tf = target.transform;
                tf.position = new Vector3(x * 5, 5, z * 5);
            }
        }
    }
}
