using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using static UnityEngine.UI.Dropdown;

public class SettingWindow : BaseWindow {
    public Dropdown dropdown;
    public Toggle windowType;
    public Toggle mouseType;
    public GameObject[] pages;

    public Slider s_volume;
    public Slider s_music;
    public Slider s_sound_effect;

    public Text t_volume;
    public Text t_music;
    public Text t_sound_effect;

    public Transform battleRoot;
    public Transform worldRoot;

    public PageUI page;

    private void Awake() {
        var v = SettingData.instance;
        for (int i = 0; i < battleRoot.childCount; i++) {
            var child = battleRoot.GetChild(i);
            int idx = i;
            child.Find("tKeyCode").GetComponent<Button>().onClick.AddListener(() => {
                ClickKeyChange(idx);
            });
        }
        for (int i = 0; i < worldRoot.childCount; i++) {
            var child = worldRoot.GetChild(i);
            int idx = i + 10000;
            child.Find("tKeyCode").GetComponent<Button>().onClick.AddListener(() => {
                ClickKeyChange(idx);
            });
        }
    }

    bool ischange = false;
    bool initok = false;
    private void Start() {
        OnOpen();
    }

    private void OnEnable() {
        if (!initok)
            return;
        OnOpen();
    }

    private void OnDisable() {
        wait_key = -1;
    }

    private void OnOpen() {
        int idx = GetResolutionOptions();
        string sub_show = string.IsNullOrWhiteSpace(MainUI.instance.sub_show) ? "system" : MainUI.instance.sub_show;
        pages[0].SetActive(sub_show == "system");
        pages[1].SetActive(sub_show == "key");
        page.SetPack(sub_show == "system" ? 0 : 1);

        initok = false;
        dropdown.value = idx;
        windowType.isOn = !SettingData.instance.fullScreen;
        mouseType.isOn = Cursor.lockState == CursorLockMode.Confined;
        s_volume.value = SettingData.instance.volume;
        s_music.value = SettingData.instance.music;
        s_sound_effect.value = SettingData.instance.sound_effect;
        t_volume.text = SettingData.instance.volume.ToString();
        t_music.text = SettingData.instance.music.ToString();
        t_sound_effect.text = SettingData.instance.sound_effect.ToString();
        SetKeyShow();



        initok = true;

        ischange = false;
    }
    
    readonly Color waitColor = new Color(0xA6 / 255f, 0x93 / 255f, 0x85 / 255f);
    readonly Color codeColor = new Color(0x60 / 255f, 0x49 / 255f, 0x42 / 255f);

    void SetKeyShow() {
        for (int i = 0; i < battleRoot.childCount; i++) {
            var child = battleRoot.GetChild(i);
            int idx = i;

            if (i >= SettingData.instance.battleShortcutKeys.Length) {
                Debug.LogError("i = " + i + " but battleShortcutKeys len = " + SettingData.instance.battleShortcutKeys.Length);
            }

            child.Find("tKeyName").GetComponent<Text>().text = MessageData.GetMessage(SettingData.instance.battleShortcutKeys[i].name_id);
            Text tKeyCode = child.Find("tKeyCode").GetComponent<Text>();
            tKeyCode.text = SettingData.instance.battleShortcutKeys[i].keyCode.ToString();
            tKeyCode.color = codeColor;
        }
        for (int i = 0; i < worldRoot.childCount; i++) {
            var child = worldRoot.GetChild(i);
            int idx = i + 10000;

            if (i >= SettingData.instance.worldShortcutKeys.Length) {
                Debug.LogError("i = " + i + " but worldShortcutKeys len = " + SettingData.instance.worldShortcutKeys.Length);
            }

            child.Find("tKeyName").GetComponent<Text>().text = MessageData.GetMessage(SettingData.instance.worldShortcutKeys[i].name_id);
            Text tKeyCode = child.Find("tKeyCode").GetComponent<Text>();
            tKeyCode.text = SettingData.instance.worldShortcutKeys[i].keyCode.ToString();
            tKeyCode.color = codeColor;
        }
        wait_key = -1;
    }

    public static int wait_key = -1;
    // 点击了要修改快捷键 idx0开始是战斗 10000开始的是大世界
    void ClickKeyChange(int idx) {
        ischange = true;
        if (wait_key > -1) {
            if (wait_key < 10000) {
                Text tKeyCode = battleRoot.GetChild(wait_key).Find("tKeyCode").GetComponent<Text>();
                tKeyCode.text = SettingData.instance.battleShortcutKeys[wait_key].keyCode.ToString();
                tKeyCode.color = codeColor;
            } else {
                Text tKeyCode = worldRoot.GetChild(wait_key - 10000).Find("tKeyCode").GetComponent<Text>();
                tKeyCode.text = SettingData.instance.worldShortcutKeys[wait_key - 10000].keyCode.ToString();
                tKeyCode.color = codeColor;
            }
        }
        StartCoroutine(SetWaitClick(idx));
        if (idx < 10000) {
            if (IsCanChangeKey(SettingData.instance.battleShortcutKeys[idx])) {
                Text tKeyCode = battleRoot.GetChild(idx).Find("tKeyCode").GetComponent<Text>();
                tKeyCode.text = MessageData.GetMessage(103);
                tKeyCode.color = waitColor;
            } else {
                return;
            }
        } else {
            if (IsCanChangeKey(SettingData.instance.worldShortcutKeys[idx - 10000])) {
                Text tKeyCode = worldRoot.GetChild(idx - 10000).Find("tKeyCode").GetComponent<Text>();
                tKeyCode.text = MessageData.GetMessage(103);
                tKeyCode.color = waitColor;
            } else {
                return;
            }
        }
    }

    bool IsCanChangeKey(SettingStruct data) {
        if (!data.canChange) {
            MessageWindow.Message(51, 107, values: MessageData.GetMessage(data.name_id));
        }
        return data.canChange;
    }

    bool onMsg = false;
    void OnKeyChange(KeyCode key) {
        if (onMsg)
            return;
        if (wait_key > -1) {
            if (wait_key < 10000) {
                for (int i = 0; i < SettingData.instance.battleShortcutKeys.Length; i++) {
                    if (i != wait_key && SettingData.instance.battleShortcutKeys[i].keyCode == key) {
                        onMsg = true;
                        MessageWindow.Message(51, 104, values: MessageData.GetMessage(SettingData.instance.battleShortcutKeys[i].name_id), ok_func:()=> {
                            onMsg = false;
                        });
                        return;
                    }
                }

                SettingData.instance.battleShortcutKeys[wait_key].keyCode = key;
                Text tKeyCode = battleRoot.GetChild(wait_key).Find("tKeyCode").GetComponent<Text>();
                tKeyCode.text = SettingData.instance.battleShortcutKeys[wait_key].keyCode.ToString();
                tKeyCode.color = codeColor;
            } else {
                for (int i = 0; i < SettingData.instance.worldShortcutKeys.Length; i++) {
                    if (i != (wait_key-10000) && SettingData.instance.worldShortcutKeys[i].keyCode == key) {
                        onMsg = true;
                        MessageWindow.Message(51, 104, values: MessageData.GetMessage(SettingData.instance.worldShortcutKeys[i].name_id), ok_func: () => {
                            onMsg = false;
                        });
                        return;
                    }
                }

                SettingData.instance.worldShortcutKeys[wait_key - 10000].keyCode = key;
                Text tKeyCode = worldRoot.GetChild(wait_key - 10000).Find("tKeyCode").GetComponent<Text>();
                tKeyCode.text = SettingData.instance.worldShortcutKeys[wait_key - 10000].keyCode.ToString();
                tKeyCode.color = codeColor;
            }
        }
        wait_key = -1;
    }

    // 延迟一帧设置，点击要设置快捷键马上检测到点击了左键
    private IEnumerator SetWaitClick(int wait) {
        yield return 0;
        wait_key = wait;
    }

    private void OnGUI() {
        if (wait_key > -1) {
            Event fee = Event.current; //获取GUI正在处理的事件。
            if (fee != null && fee.isKey) //当为按键事件
            {
                KeyCode currentkey = fee.keyCode;//获取按键
                if (currentkey != KeyCode.None) //当按键不为空时 设置
                {
                    OnKeyChange(currentkey);
                }
            }
        }
    }

    public void OnRecoverBattleKey() {
        ischange = true;
        SettingData.instance.battleShortcutKeys = new SettingData().battleShortcutKeys;
        SetKeyShow();
    }
    public void OnRecoverWorldKey() {
        ischange = true;
        SettingData.instance.worldShortcutKeys = new SettingData().worldShortcutKeys;
        SetKeyShow();
    }

    public void OnVolumeChange() {
        if (!initok)
            return;

        ischange = true;
        SettingData.instance.volume = s_volume.value;
        t_volume.text = s_volume.value.ToString();
        SoundManager.SetVolume();
    }

    public void OnMusicChange() {
        if (!initok)
            return;

        ischange = true;
        SettingData.instance.music = s_music.value;
        t_music.text = s_music.value.ToString();
        SoundManager.SetVolume();
    }

    public void OnSoundEffectChange() {
        if (!initok)
            return;

        ischange = true;
        SettingData.instance.sound_effect = s_sound_effect.value;
        t_sound_effect.text = s_sound_effect.value.ToString();
        SoundManager.SetVolume();
    }

    public void SetResolution() {
        if (!initok)
            return;

        ischange = true;


        int width = ResolutionList[dropdown.value].x;
        int height = ResolutionList[dropdown.value].y;
        var r = Screen.currentResolution;
        if (width != r.width || height != r.height) {
            Screen.SetResolution(width, height, SettingData.instance.fullScreen);

        }

        MessageWindow.CheckMessage(51, 80, () => { // 是否保存设置
            SettingData.instance.resolutionl_width = width;
            SettingData.instance.resolutionl_height = height;
        }, () => {
            Screen.SetResolution(SettingData.instance.resolutionl_width, SettingData.instance.resolutionl_height, SettingData.instance.fullScreen);
            initok = false;
            int idx = GetResolutionOptions();
            dropdown.value = idx;
            initok = true;
        }, 5, 0);

    }

    Vector2Int[] ResolutionList;
    public void SetResolutionOptions() {
        GetResolutionOptions();
    }
    /// <summary>
    /// 设置分辨率选项
    /// </summary>
    public int GetResolutionOptions() {
        initok = false;
        int idx = dropdown.value;
        List<Vector2Int> list = new List<Vector2Int>();
        List<OptionData> options = new List<OptionData>();
        Resolution[] resolutions = Screen.resolutions;
        Vector2Int cur_resolution = new Vector2Int(SettingData.instance.resolutionl_width, SettingData.instance.resolutionl_height);
        for (int i = resolutions.Length - 1; i >= 0; i--) {
            Resolution item = resolutions[i];
            if (item.width >= 1024 && item.height >= 768) {
                Vector2Int resolution = new Vector2Int(item.width, item.height);
                if (!list.Contains(resolution)) {
                    if (item.width == cur_resolution.x && item.height == cur_resolution.y) {
                        idx = list.Count;
                    }
                    options.Add(new OptionData(item.width + "×" + item.height));
                    list.Add(resolution);
                }
            }
        }

        if (!list.Contains(cur_resolution)) {
            idx = list.Count;
            options.Add(new OptionData(cur_resolution.x + "×" + cur_resolution.y));
            list.Add(cur_resolution);
        }

        ResolutionList = list.ToArray();
        dropdown.ClearOptions();
        dropdown.AddOptions(options);
        dropdown.value = idx;
        initok = true;
        return idx;
    }

    public void SetWindowType() {
        if (!initok)
            return;

        ischange = true;

        SettingData.instance.fullScreen = !windowType.isOn;
        Screen.SetResolution(SettingData.instance.resolutionl_width, SettingData.instance.resolutionl_height, SettingData.instance.fullScreen);
    }

    public void SetMouseType() {
        if (!initok)
            return;

        ischange = true;

        if (mouseType.isOn) {
            SettingData.instance.cursorLockMode = CursorLockMode.Confined;
        } else {
            SettingData.instance.cursorLockMode = CursorLockMode.None;
        }
        Cursor.lockState = SettingData.instance.cursorLockMode;
    }

    public override void ClickClose() {
        if (wait_key >= 0) {
            return;
        }

        if (ischange) {
            MessageWindow.CheckMessage(51, 81, () => {
                base.ClickClose();
                SettingData.SaveSetting();
            }, () => {
                base.ClickClose();
                SettingData.Rest();
            });
        } else {
            base.ClickClose();
        }
    }

}

[System.Serializable]
public class SettingData {
    static string data_path = "config/setting.data";
    public static SettingData _instance;
    public static SettingData instance
    {
        get
        {
            if (_instance == null) {
                Rest();
            }
            return _instance;
        }
    }

    public static void Rest() {
        bool has_data = Tools.FileExists(data_path);
        if (!has_data) {
            _instance = new SettingData();
        } else {
            byte[] byt = Tools.ReadAllBytes(data_path);
            SettingData setting_data = Tools.DeserializeObject<SettingData>(byt);
            _instance = setting_data;
        }
        if (_instance.resolutionl_width == 0 || _instance.resolutionl_height == 0) {
            Resolution resolutionl = Screen.resolutions[Screen.resolutions.Length - 1];
            _instance.resolutionl_width = resolutionl.width;
            _instance.resolutionl_height = resolutionl.height;
            _instance.fullScreen = true;
            _instance.cursorLockMode = CursorLockMode.None;
            SaveSetting();
        }

        Screen.SetResolution(_instance.resolutionl_width, _instance.resolutionl_height, _instance.fullScreen);
        Cursor.lockState = _instance.cursorLockMode;

        SoundManager.SetVolume();
    }

    public static void SaveSetting() {
        byte[] byt = Tools.SerializeObject(_instance);
        Tools.WriteAllBytes(data_path, byt);
    }


    public int resolutionl_width;
    public int resolutionl_height;
    public bool fullScreen;
    public CursorLockMode cursorLockMode;
    public float volume = 100;
    public float sound_effect = 50;
    public float music = 50;


    // 大世界快捷键
    public SettingStruct[] worldShortcutKeys = new SettingStruct[]{
        // 上 W
        new SettingStruct(){
            type = "move",
            param1 = "up",
            param2 = "",
            keyCode = KeyCode.W,
            name_id = 82,
            canChange = true,
        },
        // 下 S
        new SettingStruct(){
            type = "move",
            param1 = "down",
            param2 = "",
            keyCode = KeyCode.S,
            name_id = 83,
            canChange = true,
        },
        // 左 A
        new SettingStruct(){
            type = "move",
            param1 = "left",
            param2 = "",
            keyCode = KeyCode.A,
            name_id = 84,
            canChange = true,
        },
        // 右 D
        new SettingStruct(){
            type = "move",
            param1 = "right",
            param2 = "",
            keyCode = KeyCode.D,
            name_id = 85,
            canChange = true,
        },

        // 人物属性 I
        new SettingStruct(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "role",
            keyCode = KeyCode.I,
            name_id = 18,
            canChange = true,
        },

        // 技能 X
        new SettingStruct(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "skill",
            keyCode = KeyCode.X,
            name_id = 7,
            canChange = true,
        },

        // 背包 B
        new SettingStruct(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "bag",
            keyCode = KeyCode.B,
            name_id = 8,
            canChange = true,
        },
        // 任务 L
        new SettingStruct(){
            type = "uiwindow",
            param1 = "XXXXX",
            param2 = "",
            keyCode = KeyCode.L,
            name_id = 6,
            canChange = true,
        },
        // 信件 H
        new SettingStruct(){
            type = "uiwindow",
            param1 = "XXXXX",
            param2 = "",
            keyCode = KeyCode.H,
            name_id = 96,
            canChange = true,
        },
        // 大事件 N
        new SettingStruct(){
            type = "uiwindow",
            param1 = "XXXXX",
            param2 = "",
            keyCode = KeyCode.N,
            name_id = 97,
            canChange = true,
        },
        // 小地图 M
        new SettingStruct(){
            type = "uiwindow",
            param1 = "XXXXX",
            param2 = "",
            keyCode = KeyCode.M,
            name_id = 98,
            canChange = true,
        },
        // 技艺 O
        new SettingStruct(){
            type = "uiwindow",
            param1 = "RoleWindow",
            param2 = "artistry",
            keyCode = KeyCode.O,
            name_id = 9,
            canChange = true,
        },
        // 跳过本月 Z
        new SettingStruct(){
            type = "uiwindow",
            param1 = "XXXXX",
            param2 = "",
            keyCode = KeyCode.Z,
            name_id = 99,
            canChange = true,
        },
        // 逆天改命 J
        new SettingStruct(){
            type = "uiwindow",
            param1 = "XXXXX",
            param2 = "",
            keyCode = KeyCode.J,
            name_id = 100,
            canChange = true,
        },
        // 关闭/菜单
        new SettingStruct(){
            type = "exitui",
            param1 = "",
            param2 = "",
            keyCode = KeyCode.Escape,
            name_id = 106,
            canChange = false,
        },
        // 关闭
        new SettingStruct(){
            type = "exitui",
            param1 = "",
            param2 = "",
            keyCode = KeyCode.J,
            name_id = 105,
            canChange = false,
        },
    };

    // 战斗快捷键
    public SettingStruct[] battleShortcutKeys = new SettingStruct[]{
        // 上 W
        new SettingStruct(){
            type = "move",
            param1 = "up",
            param2 = "",
            keyCode = KeyCode.W,
            name_id = 82,
            canChange = true,
        },
        // 下 S
        new SettingStruct(){
            type = "move",
            param1 = "down",
            param2 = "",
            keyCode = KeyCode.S,
            name_id = 83,
            canChange = true,
        },
        // 左 A
        new SettingStruct(){
            type = "move",
            param1 = "left",
            param2 = "",
            keyCode = KeyCode.A,
            name_id = 84,
            canChange = true,
        },
        // 右 D
        new SettingStruct(){
            type = "move",
            param1 = "right",
            param2 = "",
            keyCode = KeyCode.D,
            name_id = 85,
            canChange = true,
        },
        // 武技/灵技 左键
        new SettingStruct(){
            type = "battle",
            param1 = "attack",
            param2 = "",
            keyCode = KeyCode.Mouse0,
            name_id = 101,
            canChange = false,
        },
        // 绝技 右键
        new SettingStruct(){
            type = "battle",
            param1 = "skill",
            param2 = "",
            keyCode = KeyCode.Mouse1,
            name_id = 102,
            canChange = false,
        },
        // 身法 空格
        new SettingStruct(){
            type = "battle",
            param1 = "body",
            param2 = "",
            keyCode = KeyCode.Space,
            name_id = 88,
            canChange = true,
        },
        // 神通 R
        new SettingStruct(){
            type = "battle",
            param1 = "magic",
            param2 = "",
            keyCode = KeyCode.R,
            name_id = 89,
            canChange = true,
        },
        // 道具1 1
        new SettingStruct(){
            type = "item",
            param1 = "1",
            param2 = "",
            keyCode = KeyCode.Alpha1,
            name_id = 90,
            canChange = true,
        },
        // 道具2 2
        new SettingStruct(){
            type = "item",
            param1 = "2",
            param2 = "",
            keyCode = KeyCode.Alpha2,
            name_id = 91,
            canChange = true,
        },
        // 道具3 3
        new SettingStruct(){
            type = "item",
            param1 = "3",
            param2 = "",
            keyCode = KeyCode.Alpha3,
            name_id = 92,
            canChange = true,
        },
        // 道具4 4
        new SettingStruct(){
            type = "item",
            param1 = "4",
            param2 = "",
            keyCode = KeyCode.Alpha4,
            name_id = 93,
            canChange = true,
        },
        // 道具5 5
        new SettingStruct(){
            type = "item",
            param1 = "5",
            param2 = "",
            keyCode = KeyCode.Alpha5,
            name_id = 94,
            canChange = true,
        },
        // 互动 E
        new SettingStruct(){
            type = "action",
            param1 = "talk",
            param2 = "",
            keyCode = KeyCode.E,
            name_id = 95,
            canChange = true,
        },
        // 关闭/菜单
        new SettingStruct(){
            type = "exitui",
            param1 = "",
            param2 = "",
            keyCode = KeyCode.Escape,
            name_id = 106,
            canChange = false,
        },
        // 关闭
        new SettingStruct(){
            type = "exitui",
            param1 = "",
            param2 = "",
            keyCode = KeyCode.J,
            name_id = 105,
            canChange = false,
        },
    };
}


[System.Serializable]
public struct SettingStruct {
    public string type;
    public string param1;
    public string param2;
    public KeyCode keyCode;
    public int name_id;
    public bool canChange;
}