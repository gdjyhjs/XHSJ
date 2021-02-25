using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
public struct QuickSave {
    public long time;
    public string name;
    public int level;
    public Sex sex;
}

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
                    StartCoroutine(ReadGame(id));
                }
            });
            create.Find("TextNew").GetComponent<Button>().onClick.AddListener(() => {
                // 创建存档
                GameData.instance.save_id = id;
                MainUI.ShowUI("CreateRole");
            });
        }
    }

    IEnumerator ReadGame(int id) {
        LoadingUI.instance.Show(55);
        yield return 0;
        SaveData.ReadGame(id);
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
                string quick_save_path = Tools.SavePath("quick_save.data");
                byte[] byt = Tools.ReadAllBytes(quick_save_path);
                QuickSave quick_data = Tools.DeserializeObject<QuickSave>(byt);
                
                info.Find("grilHead").gameObject.SetActive(quick_data.sex == Sex.Girl);
                info.Find("boyHead").gameObject.SetActive(quick_data.sex == Sex.Boy);
                info.Find("TextName").GetComponent<Text>().text = quick_data.name;
                
                info.Find("TextTime").GetComponent<Text>().text = Tools.ShowTime(new System.DateTime(quick_data.time));
                info.Find("TextLevel").GetComponent<Text>().text = LevelConfigData.GetName(quick_data.level);
            }
        }
    }
}
