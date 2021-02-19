using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LoginLoad : BaseWindow {
    public Transform view;
    public GameObject item;

    private void Awake() {
        InitUI();
    }

    void InitUI() {
        for (int i = 0; i < 9; i++) {
            int id = i;
            GameObject go = Instantiate(item);
            go.SetActive(true);
            Transform tf = go.transform;
            tf.SetParent(view, false);
            bool has_save = Tools.HasSave(id);
            Transform info =  tf.Find("Info");
            Transform create = tf.Find("BtnCreate");
            info.Find("btnDelete").GetComponent<Button>().onClick.AddListener(() => {
                // 删除存档
                if (Tools.HasSave(id)) {
                    Tools.DeleteSave(id);
                }
                OnUpdate();
            });
            info.Find("btnEnter").GetComponent<Button>().onClick.AddListener(() => {
                // 读取存档
                if (Tools.HasSave(id)) {
                    SaveData.ReadGame(id);
                }
            });
            create.Find("TextNew").GetComponent<Button>().onClick.AddListener(() => {
                // 创建存档
                GameData.instance.save_id = id;
                ClickClose();
                MainUI.ShowUI("CreateRole");
            });
        }
    }

    private void OnEnable() {
        OnUpdate();
    }

    public void OnUpdate() {
        for (int i = 0; i < view.childCount; i++) {
            int id = i;
            Transform tf = view.GetChild(id);
            tf.SetParent(view, false);
            tf.Find("idx").GetComponent<Text>().text = id.ToString();
            bool has_save = Tools.HasSave(id);
            Transform info = tf.Find("Info");
            Transform create = tf.Find("BtnCreate");
            info.gameObject.SetActive(has_save);
            create.gameObject.SetActive(!has_save);
            if (has_save) {
                GameData.instance.save_id = id;
                // 读取存档数据显示
                string main_role_path = Tools.SavePath("main_role.data");
                byte[] byt = Tools.ReadAllBytes(main_role_path);
                RoleData roleData = Tools.DeserializeObject<RoleData>(byt);
                info.Find("grilHead").gameObject.SetActive(roleData.sex == Sex.Girl);
                info.Find("boyHead").gameObject.SetActive(roleData.sex == Sex.Boy);
                info.Find("TextName").GetComponent<Text>().text = roleData.name;

                string game_path = Tools.SavePath("game.data");
                byte[] byt2 = Tools.ReadAllBytes(game_path);
                GameData.instance = Tools.DeserializeObject<GameData>(byt2);
                long time = GameData.instance.globalAttr[(int)GlobalAttribute.time];
                info.Find("TextTime").GetComponent<Text>().text = Tools.ShowTime(new System.DateTime(time));
                info.Find("TextLevel").GetComponent<Text>().text = LevelConfigData.GetName(roleData.GetAttr(RoleAttribute.level));
            }
        }
    }
}
