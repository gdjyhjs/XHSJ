using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MainUI : MonoBehaviour
{
    public static MainUI instance;
    Dictionary<string, GameObject> uiList;
    public UIWindow[] all;
    public string sub_show;
    private void Awake() {
        if (instance == null) {
            instance = this;
            DontDestroyOnLoad(gameObject);
        } else {
            Destroy(gameObject);
        }
    }



    private IEnumerator Init() {
        string[] files = new string[]
        { "boyname", "cityname", "globalAttr", "grilname",
            "level", "MessageData", "popename", "popesuffix",
            "roleAttr", "roleAttrDes", "surn", "xiantianqiyun",
        "gongfaAttrConfig","itemConfig"};

#if UNITY_EDITOR
        if (true) {
            Debug.Log("编辑器复制配置 " + string.Join(",", files));
#else
        if (!Tools.FileExists("config/" + files[files.Length - 1] + ".txt")) {
#endif
            foreach (var item in files) {
                yield return StartCoroutine(MoveConfig("config/" + item + ".txt"));
            }
        }

        uiList = new Dictionary<string, GameObject>();

        foreach (var item in all) {
            if (item.active) {
                GameObject obj = Instantiate(item.obj);
                obj.name = item.obj.name;
                uiList.Add(item.obj.name, obj.gameObject);
                obj.transform.SetParent(transform, false);
                ShowUI(item.obj.name);
                if (!item.show) {
                    HideUI(item.obj.name);
                }
            }
        }



        UnityEngine.SceneManagement.SceneManager.LoadScene("login");
        ShowUI("LoginMenu");

        SoundManager.SetUIMute(false);
    }

    public static bool IsOpen(string uiname, string sub_name = null) {
        if (instance.uiList == null) {
            return false;
        }
        var obj = instance.uiList[uiname];
        return ((instance.sub_show == sub_name)||(string.IsNullOrWhiteSpace(sub_name)))
            && obj.activeSelf && (obj.transform.GetSiblingIndex() == (instance.transform.childCount - 1));
    }

    private IEnumerator MoveConfig(string file_path) {
        string //path = Application.dataPath + "/StreamingAssets/" + file_path;
        path = Application.streamingAssetsPath +"/"+ file_path;
        var url = new System.Uri(path);
        Debug.LogError(url);
        UnityEngine.Networking.UnityWebRequest www = UnityEngine.Networking.UnityWebRequest.Get(url);
        www.SendWebRequest();
        while (!www.isDone) {
            yield return 0;
        }
        if (string.IsNullOrWhiteSpace(www.error)) {
            string result = www.downloadHandler.text;
            Tools.WriteAllText(file_path, result);
        } else {
            Debug.LogError(url);
            Debug.LogError(www.error);
        }
        
        yield return 0;
    }

    private void Start() {
        StartCoroutine(Init());
    }
    
    /// <summary>
    /// UI是显示的（并且是最前的）就隐藏，否则就显示（到最前）
    /// </summary>
    public static void ChangeUI(string name, string sub_show = null) {
        if (instance.uiList == null) {
            return;
        }
        if (!instance.uiList.ContainsKey(name)) {
            MessageTips.Message(1);
            return;
        }
        if (IsOpen(name, sub_show)) {
            HideUI(name);
        } else {
            ShowUI(name, sub_show);
        }
    }

    public static void ShowUI(string name, string sub_show = null) {
        if (instance.uiList == null) {
            return;
        }
        if (!instance.uiList.ContainsKey(name)) {
            MessageTips.Message(1);
            return;
        }
        instance.sub_show = sub_show;
        var obj = instance.uiList[name];
        if (obj.activeSelf) {
            obj.SetActive(false);
        }
        obj.SetActive(true);
        obj.transform.SetAsLastSibling();

        SoundManager.PlayUIClip(SoundManager.UIClipType.bag_open);
    }

    public static void HideUI(string name) {
        if (instance.uiList == null) {
            return;
        }
        instance.sub_show = null;
        if (!instance.uiList.ContainsKey(name)) {
            Debug.LogError(" hide UI err: "+ name);
            return;
        }

        var obj = instance.uiList[name];
        obj.SetActive(false);
        SoundManager.PlayUIClip(SoundManager.UIClipType.button_close);
    }

    public static void HideAll() {
        if (instance.uiList == null) {
            return;
        }
        SoundManager.SetUIMute(true);
        foreach (KeyValuePair<string, GameObject> obj in instance.uiList) {
            if (obj.Value.activeSelf)
                obj.Value.SetActive(false);
        }
        SoundManager.SetUIMute(false);
    }

    private void Update() {

        if (Input.GetKeyDown(KeyCode.Escape)) {
            OnEsc();
        }
        if (Input.GetMouseButtonDown(1)) {
            OnEsc(true);
        }

        if (IsOpen("SettingWindow") || IsOpen("MenuWindow")) {
            return;
        }

        if (UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "world") {
            foreach (SettingStruct item in SettingData.instance.worldShortcutKeys) {
                switch (item.type) {
                    case "uiwindow":
                        if (Input.GetKeyDown(item.keyCode)) {
                            ChangeUI(item.param1, item.param2);
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }

    public void OnEsc(bool onlyHide = false) {
        if (instance.uiList == null) {
            return;
        }
        int child_count = transform.childCount;
        for (int i = child_count - 1; i >= 0; i--) {
            Transform child = transform.GetChild(i);
            if (child.name != "MainWindows" && child.name != "LoginMenu" && child.name != "BattleMainWindow") {
                if (child.gameObject.activeSelf) {
                    if (instance.uiList.ContainsKey(child.gameObject.name)) {
                        //HideUI(child.name);
                        var win = child.GetComponent<BaseWindow>();
                        if (win) {
                            win.ClickClose();
                            return;
                        }
                    }
                }
            }
        }
        if (onlyHide)
            return;

        ShowUI("MenuWindow");
    }
}

[System.Serializable]
public struct UIWindow {
    public GameObject obj;
    public bool active;
    public bool show;
}