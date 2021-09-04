using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEngine;
using Newtonsoft.Json;
using System;
using System.Reflection;


namespace UMAWorld {
    public static class CommonTools {
        public static void Init() {
        }

        public static string GetString(string key, string defValue = null) {
            return PlayerPrefs.GetString(key, defValue);
        }

        public static int GetInt(string key, int defValue = 0) {
            if (int.TryParse(PlayerPrefs.GetString(key), out int value))
                return value;
            else
                return defValue;
        }

        public static bool HasKey(string key) {
            return PlayerPrefs.HasKey(key);
        }

        public static void SetString(string key, string value) {
            PlayerPrefs.SetString(key, value);
        }

        public static void SetString(string key, int value) {
            PlayerPrefs.SetString(key, value.ToString());
        }

        public static void ChangeLanguage(string l) {
            SetString(DataKey.Language, l);
            language = l;
            LanguageText[] v = GameObject.FindObjectsOfType<LanguageText>();
            foreach (LanguageText item in v) {
                item.Rest();
            }
        }

        public static void DestoryChilds(Transform parent) {
            while (parent.childCount > 0) {
                Transform child = parent.GetChild(0);
                child.SetParent(null);
                GameObject.Destroy(child.gameObject);
            }
        }

        public static T GetOrAddComponent<T>(GameObject go) where T : Component {
            T t = go.GetComponent<T>();
            if (t == null) {
                t = go.AddComponent<T>();
            }
            return t;
        }

        public static int Random(int min, int max) {
            return UnityEngine.Random.Range(min, max);
        }


        public static float Random(float min, float max) {
            return UnityEngine.Random.Range(min, max);
        }

        //HSV->RGB
        public static Color ColorFromHSV(float h, float s, float v, float a = 1) {
            if (s == 0)
                return new Color(v, v, v, a);

            float sector = h / 60;

            int i = (int)sector;
            float f = sector - i;

            float p = v * (1 - s);
            float q = v * (1 - s * f);
            float t = v * (1 - s * (1 - f));

            Color color = new Color(0, 0, 0, a);

            switch (i) {
                case 0:
                    color.r = v;
                    color.g = t;
                    color.b = p;
                    break;

                case 1:
                    color.r = q;
                    color.g = v;
                    color.b = p;
                    break;

                case 2:
                    color.r = p;
                    color.g = v;
                    color.b = t;
                    break;

                case 3:
                    color.r = p;
                    color.g = q;
                    color.b = v;
                    break;

                case 4:
                    color.r = t;
                    color.g = p;
                    color.b = v;
                    break;

                default:
                    color.r = v;
                    color.g = p;
                    color.b = q;
                    break;
            }

            return color;
        }

        //RGB->HSV
        public static void ColorToHSV(Color color, out float h, out float s, out float v) {
            float min = Mathf.Min(Mathf.Min(color.r, color.g), color.b);
            float max = Mathf.Max(Mathf.Max(color.r, color.g), color.b);
            float delta = max - min;

            v = max;


            if (!Mathf.Approximately(max, 0))
                s = delta / max;
            else {
                s = 0;
                h = -1;
                return;
            }


            if (Mathf.Approximately(min, max)) {
                v = max;
                s = 0;
                h = -1;
                return;
            }

            if (color.r == max)
                h = (color.g - color.b) / delta;
            else if (color.g == max)
                h = 2 + (color.b - color.r) / delta;
            else
                h = 4 + (color.r - color.g) / delta;

            h *= 60;
            if (h < 0)
                h += 360;
        }

        public static void LoadScene(string sceneName) {
            UnityEngine.SceneManagement.SceneManager.LoadScene(sceneName);
        }

        private class Pack<T> {
            public T data;
        }

        public static string ToJson<T>(T obj) {
            string json = JsonConvert.SerializeObject(obj);
            Debug.Log(json);
            return json;
        }

        public static T FromJson<T>(string json) {
            return JsonConvert.DeserializeObject<T>(json);
        }

        /// <summary> 
        /// 将一个object对象序列化，返回一个byte[]         
        /// </summary> 
        /// <param name="obj">能序列化的对象</param>         
        /// <returns></returns> 
        public static byte[] ObjectToBytes<T>(T obj) {
            using (MemoryStream ms = new MemoryStream()) {
                IFormatter formatter = new BinaryFormatter(); formatter.Serialize(ms, obj);
                return ms.GetBuffer();
            }
        }

        /// <summary> 
        /// 将一个序列化后的byte[]数组还原         
        /// </summary>
        /// <param name="Bytes"></param>         
        /// <returns></returns> 
        public static T BytesToObject<T>(byte[] Bytes) {
            using (MemoryStream ms = new MemoryStream(Bytes)) {
                IFormatter formatter = new BinaryFormatter();
                return (T)formatter.Deserialize(ms);
            }
        }


        public static T LoadResources<T>(string path) where T : UnityEngine.Object {
            return Resources.Load<T>(path);
        }

        //public static void LoadAsyncResources<T>(string path) where T : UnityEngine.Object{
        //    ResourceRequest  request = Resources.LoadAsync<T>(path);
        //}




        //根据字符串创建类
        public static T CreateClass<T>(string className) {
            return (T)CreateClass(className);
        }

        //根据字符串创建类
        public static object CreateClass(string className) {
            Type t = Type.GetType(className);
            if (t != null) {
                return Activator.CreateInstance(t);
            }

            return null;
        }

        public static Vector3 GetGroundPoint(Vector3 point) {
            if (Physics.Raycast(point + Vector3.up * 1000, Vector3.down, out RaycastHit hit, 2000)) {
                return hit.point;
            }
            return point;
        }



























        static string language = "ch";
#if UNITY_EDITOR
        static List<string> list = new List<string>();
#endif
        public static string LS(string key) {
            language = GetString(DataKey.Language, "cn");
            if (key == null)
                return key;
            ConfLanguageItem item = g.conf.language.GetItem(key);
            if (item != null) {
                switch (language) {
                    case "en":
                        return item.en;
                    case "ch":
                    default:
                        return item.ch;
                }
            }

#if UNITY_EDITOR
            if (!list.Contains(key)) {
                list.Add(key);
                Debug.LogWarning(string.Join("\n", list.ToArray()));
            }
            return "?" + key;
#else
        return key;
#endif

        }


    }
}