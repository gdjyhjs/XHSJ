using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class LoginMenu : BaseWindow {
    public void ClickStart() {
        MainUI.ShowUI("LoginLoad");
    }

    /// <summary>
    /// 点击成就
    /// </summary>
    public void ClickAchievement() {
        MessageTips.Message(1);
    }

    /// <summary>
    /// 点击设置
    /// </summary>
    public void ClickSetting() {
        MainUI.ShowUI("SettingWindow");
    }

    /// <summary>
    /// 点击退出
    /// </summary>
    public void ClickExit() {
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    public CanvasGroup canvasGroup;
    public bool is_init;
    private void Start() {
        canvasGroup.gameObject.SetActive(false);
        if (is_init) {
            StartCoroutine(Show());
        } else {
            StartCoroutine(Init());
        }
    }

    private IEnumerator Init() {
        string[] files = new string[] 
        { "boyname", "cityname", "globalAttr", "grilname",
            "level", "MessageData", "popename", "popesuffix",
            "roleAttr", "roleAttrDes", "surn", "xiantianqiyun",
        "gongfaAttrConfig","itemConfig"};

#if UNITY_EDITOR
        if(true){
            Debug.Log("编辑器复制配置 " + string.Join(",", files));
#else
        if (!Tools.FileExists("config/" + files[files.Length - 1] + ".txt")) {
#endif
            foreach (var item in files) {
                yield return StartCoroutine(MoveConfig("config/" + item + ".txt"));
            }
        }
        is_init = true;
        StartCoroutine(Show());
    }

    private IEnumerator Show() {
        canvasGroup.alpha = 0;
        canvasGroup.gameObject.SetActive(true);
        while (canvasGroup.alpha < 1) {
            canvasGroup.alpha += Time.deltaTime;
            yield return 0;
        }
    }
    
    private IEnumerator MoveConfig(string file_path) {
        string path =   Application.dataPath + "/StreamingAssets/" + file_path;
        var url = new System.Uri(path);
        UnityEngine.Networking.UnityWebRequest www = UnityEngine.Networking.UnityWebRequest.Get(url);
        www.SendWebRequest();
        while (!www.isDone) {
            yield return 0;
        }
        if (string.IsNullOrWhiteSpace(www.error)) {
            string result = www.downloadHandler.text;
            Tools.WriteAllText(file_path, result);
        } else {
            Debug.LogError(file_path);
            Debug.LogError(www.error);
        }
        yield return 0;
    }
}
