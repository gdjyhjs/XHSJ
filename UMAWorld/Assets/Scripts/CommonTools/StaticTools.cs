using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class StaticTools
{
    public static void Init() {
        language = GetString("language", "cn");
    }

    public static string GetString(string key, string defValue = null) {
        return PlayerPrefs.GetString(key, defValue);
    }

    public static bool HasString(string key) {
        return PlayerPrefs.HasKey(key);
    }

    public static void SetString(string key, string value) {
        PlayerPrefs.SetString(key, value);
    }

    public static void ChangeLanguage(string l) {
        SetString("language", l);
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



    static string language = "ch";
    static List<string> list = new List<string>();
    public static string LS(string key) {
        if (string.IsNullOrWhiteSpace(key))
            return key;
        if (ConfLanguage.config.ContainsKey(key)) {
            switch (language) {
                case "en":
                    return ConfLanguage.config[key].en;
                case "ch":
                default:
                    return ConfLanguage.config[key].ch;
            }
        }
        if (!list.Contains(key)) {
            list.Add(key);
            Debug.LogWarning(string.Join("\n", list.ToArray()));
        }

        return "?"+ key;
    }


}
