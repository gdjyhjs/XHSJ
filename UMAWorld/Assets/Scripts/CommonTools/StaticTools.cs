using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class StaticTools
{
    public static string GetString(string key, string defValue = null) {
        return PlayerPrefs.GetString(key, defValue);
    }
    public static bool HasString(string key) {
        return PlayerPrefs.HasKey(key);
    }
    public static void SetString(string key, string value) {
        PlayerPrefs.SetString(key, value);
    }

    public static string LS(string text) {
        if (ConfLanguage.config.ContainsKey(text))
            return ConfLanguage.config[text].ch;
        return text;
    }


    public static void DestoryChilds(Transform parent) {
        while (parent.childCount > 0)
            GameObject.Destroy(parent.GetChild(0));
    }
}
