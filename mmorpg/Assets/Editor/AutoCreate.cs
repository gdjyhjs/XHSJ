using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;
using Hugula.Pool;
using Seven.Effect;

                        //&& typ != typeof(Seven.UGUISpriteAnimation)
                        //&& typ != typeof(Hugula.Pool.ReferenceCount)
                        //&& typ != typeof(Seven.RenderTextureCtr)
public class AutoCreate
{
    static void GetChildrenComponents<T>(Transform tf, List<T> list) {
        var com = tf.GetComponent<T>();
        if (null != com) {
            list.Add(com);
        }
        for (int i = 0; i < tf.childCount; i++) {
            var child = tf.GetChild(i);
            GetChildrenComponents<T>(child, list);
        }   
    }

    [MenuItem("auto/Remove")]
    static void RemovePrefabComponent() {
        string[] files = Directory.GetFiles("Assets/GameEffect/GameEffects", "*.prefab", SearchOption.AllDirectories);
        foreach (var path in files) {
            GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(path);
            var com1 = new List<Seven.RenderTextureCtr>();
            GetChildrenComponents(obj.transform, com1);
            if (null!=com1 && com1.Count > 0) {
                GameObject twoCube = PrefabUtility.InstantiatePrefab(obj) as GameObject;
                var coms = new List<Seven.RenderTextureCtr>();
                GetChildrenComponents(twoCube.transform, coms);
                foreach (var com in coms) {
                    GameObject.DestroyImmediate(com);
                }
                PrefabUtility.SaveAsPrefabAsset(twoCube, path);
            }
        }
    }

    [MenuItem("auto/createModel")]
    static void CreateModelPrefab() {
        CreatePrefab("Assets/Model");
    }

    [MenuItem("auto/createEffect")]
    static void CreateEffectPrefab() {
        CreatePrefab("Assets/GameEffect/GameEffects", true);
    }

    [MenuItem("auto/PlayEffect")]
    static void PlayEffectPrefab() {
        PlayPrefab("Assets/GameEffect/GameEffects");
    }

    static void CreatePrefab(string dir,bool one = false) {
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
                tf.position = one ? default : new Vector3(x * 5, 5, z * 5);
            }
        }
    }

    static void PlayPrefab(string dir) {
        var go = new GameObject("auaoCreate");
        var auto = go.AddComponent<CoroutineAutoCreate>();
        auto.StartCoroutine(auto.PlayCreate(dir));
    }

    class CoroutineAutoCreate : MonoBehaviour
    {
        public IEnumerator PlayCreate(string dir) {
            string[] files = Directory.GetFiles(dir, "*.prefab", SearchOption.AllDirectories);
            int count = (int)Mathf.Ceil(Mathf.Sqrt(files.Length));
            for (int x = 0; x < count; x++) {
                for (int z = 0; z < count; z++) {
                    var idx = count * x + z;
                    if (idx >= files.Length)
                        yield break;
                    GameObject obj = AssetDatabase.LoadAssetAtPath<GameObject>(files[idx]);
                    GameObject target = GameObject.Instantiate<GameObject>(obj);
                    Transform tf = target.transform;
                    tf.position = default;
                    target.SetActive(true);
                    float nextTime = Time.time + 5;
                    while (Time.time < nextTime) {
                        yield return new WaitForEndOfFrame();
                        if (!target.activeSelf) {
                            break;
                        }
                    }
                    target.SetActive(false);
                    tf.position = new Vector3(x * 5, 5, z * 5);
                }
            }
        }
    }


}
