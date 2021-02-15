using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LoginLoad : MonoBehaviour
{
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
            if (has_save) {
                info.Find("btnDelete").GetComponent<Button>().onClick.AddListener(() => {
                    // É¾³ý´æµµ
                    if (Tools.HasSave(id)) {
                        Tools.DeleteSave(id);
                    }
                    OnUpdate();
                });
            } else {
                create.Find("TextNew").GetComponent<Button>().onClick.AddListener(() => {
                    // ´´½¨´æµµ
                    GameData.save_id = id;
                    ClickClose();
                    MainUI.ShowUI("CreateRole");
                });
            }
        }
    }

    private void Start() {
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
                GameData.save_id = id;
                // ¶ÁÈ¡´æµµÊý¾ÝÏÔÊ¾
                string main_role_path = Tools.SavePath("main_role.data");
                byte[] byt = Tools.ReadAllBytes(main_role_path);
                RoleData roleData = Tools.DeserializeObject<RoleData>(byt);
                info.Find("grilHead").gameObject.SetActive(roleData.sex == Sex.Girl);
                info.Find("boyHead").gameObject.SetActive(roleData.sex == Sex.Boy);
                info.Find("TextName").GetComponent<Text>().text = roleData.name;

                string game_path = Tools.SavePath("game.data");
                byte[] byt2 = Tools.ReadAllBytes(game_path);
                GameData.instance = Tools.DeserializeObject<GameData>(byt2);
                long time = GameData.globalAttr[(int)GlobalAttribute.time];
                info.Find("TextTime").GetComponent<Text>().text = Tools.ShowTime(new System.DateTime(time));
                info.Find("TextLevel").GetComponent<Text>().text = LevelConfigData.GetName(roleData.attribute[(int)RoleAttribute.level]);
            }
        }
    }

    public void ClickClose() {
        MainUI.HideUI("LoginLoad");
    }
}
