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
    }

    private void Start() {
        UnityEngine.SceneManagement.SceneManager.LoadScene("login");
    }

    public static void ChangeUI(string name, string sub_show = null) {
        if (!instance.uiList.ContainsKey(name)) {
            MessageTips.Message(1);
            return;
        }
        var obj = instance.uiList[name];
        if ((instance.sub_show == sub_show) && obj.activeSelf && (obj.transform.GetSiblingIndex() == (instance.transform.childCount - 1))) {
            HideUI(name);
        } else {
            ShowUI(name, sub_show);
        }
    }

    public static void ShowUI(string name, string sub_show = null) {
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
    }

    public static void HideUI(string name) {
        instance.sub_show = null;
        if (!instance.uiList.ContainsKey(name)) {
            Debug.LogError(name+" hide UI err");
            return;
        }

        var obj = instance.uiList[name];
        obj.SetActive(false);
    }

    public static void HideAll() {
        foreach (KeyValuePair<string, GameObject> obj in instance.uiList) {
            if (obj.Value.activeSelf)
                obj.Value.SetActive(false);
        }
    }

    private void Update() {
        if (Input.GetKeyDown(KeyCode.Escape)) {
            OnEsc();
        }
        if (Input.GetMouseButtonDown(1)) {
            OnEsc(true);
        }

        if (UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "world") {
            foreach (UIShortcutKey item in GameConst.uIShortcutKeys) {
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
        int child_count = transform.childCount;
        for (int i = child_count - 1; i >= 0; i--) {
            Transform child = transform.GetChild(i);
            if (child.name != "MainWindows" && child.name != "LoginMenu") {
                if (child.gameObject.activeSelf) {
                    HideUI(child.name);
                    return;
                }
            }
        }
        if (onlyHide)
            return;
        if (UnityEngine.SceneManagement.SceneManager.GetActiveScene().name == "world") {
            ShowUI("MenuWindow");
        }
    }
}

[System.Serializable]
public struct UIWindow {
    public GameObject obj;
    public bool active;
    public bool show;
}


[System.Serializable]
public struct UIShortcutKey {
    public string type;
    public string param1;
    public string param2;
    public KeyCode keyCode;
}