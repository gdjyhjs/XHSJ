using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CreateRole : MonoBehaviour {
    public InputField inputField;
    public Image boy, gril;
    public Image[] intrinsic_disposition;
    public Image[] external_disposition;

    public GameObject boyObj;
    public GameObject grilObj;
    public UIMove show1;
    public UIMove show2;

    public AttributeUI attributeUI;

    /// <summary>
    /// 六个随机先天气运
    /// </summary>
    int[] rand_xiantian;
    Image[] img_xiantian;

    /// <summary>
    /// 属性
    /// </summary>
    public int[] attribute;

    /// <summary>
    /// 最大属性
    /// </summary>
    public int[] max_attribute;

    /// <summary>
    /// 属性配置
    /// </summary>
    RoleAttrConfig[] attribute_config;

    private void Start() {
        RandInit();
        RandomAttr();
    }

    /// <summary>
    /// 选择的内在性格
    /// </summary>
    int intrinsic;
    /// <summary>
    /// 选择的外在性格
    /// </summary>
    List<int> external;
    /// <summary>
    /// 选择的性别
    /// </summary>
    Sex sex;
    /// <summary>
    /// 选择的三个先天气运
    /// </summary>
    List<int> sel_xiantian;

    public void RandInit() {
        NameRand(Sex.Both);
        if (intrinsic_disposition.Length < 1) {
            throw (new System.Exception("intrinsic_disposition len less than 1"));
        }
        intrinsic = -1;
        for (int i = 0; i < intrinsic_disposition.Length; i++) {
            intrinsic_disposition[i].enabled = false;
        }
        if (external_disposition.Length < 1) {
            throw (new System.Exception("external_disposition len less than 2"));
        }
        external = new List<int>() { };
        for (int i = 0; i < external_disposition.Length; i++) {
            external_disposition[i].enabled = false;
        }
    }

    public void NameRand(Sex sex) {
        RandName.GetRandRoleName(ref sex, out string surn, out string name);
        this.sex = sex;
        inputField.text = surn + name;
        boy.enabled = sex == Sex.Boy;
        gril.enabled = sex == Sex.Girl;
        boyObj.SetActive(sex == Sex.Boy);
        grilObj.SetActive(sex == Sex.Girl);
    }

    /// <summary>
    /// 点击性别 重新随机名字
    /// </summary>
    /// <param name="sex"></param>
    public void NameRand(int sex) {
        if (sex == 0) {
            NameRand(Sex.Boy);
        } else {
            NameRand(Sex.Girl);
        }
        ShowAttr();
    }

    /// <summary>
    /// 点击内在性格
    /// </summary>
    /// <param name="id"></param>
    public void ClickIntrinsicDisposition(int id) {
        if (intrinsic == id) {
            intrinsic = -1;
        } else {
            intrinsic = id;
        }
        for (int i = 0; i < intrinsic_disposition.Length; i++) {
            intrinsic_disposition[i].enabled = i == intrinsic;
        }
    }

    /// <summary>
    /// 点击外在性格
    /// </summary>
    /// <param name="id"></param>
    public void ClickExternalDisposition(int id) {
        for (int j = 0; j < external.Count; j++) {
            if (external[j] == id) {
                external.RemoveAt(j);
                external_disposition[id].enabled = false;
                return;
            }
        }

        if (external.Count > 1) {
            external_disposition[external[0]].enabled = false;
            external.RemoveAt(0);
        }
        external.Add(id);
        external_disposition[id].enabled = true;
    }

    public void Show1(Toggle tog) {
        if (tog.isOn) {
            show1.target = new Vector2(37, 0);
            show2.target = new Vector2(-2000, 0);
        }
    }

    public void Show2(Toggle tog) {
        if (tog.isOn) {
            show2.target = new Vector2(37, 0);
            show1.target = new Vector2(-2000, 0);
        }
    }

    public void RandomAttr() {
        // 先天气运
        InitXiantian();
        // 随机属性
        RoleAttrConfigData.GetRandomAttr(out attribute, out max_attribute, out attribute_config);
        ShowAttr();
    }

    void ShowAttr() {
        // 显示属性
        attributeUI.ShowAttr(attribute, max_attribute, attribute_config, sex);
    }


    /// <summary>
    /// 先天气运
    /// </summary>
    void InitXiantian() {
        if (XiantianQiyunData.dataList.Length < 8) {
            throw (new System.Exception("XiantianQiyunData len less than 6"));
        }
        HashSet<int> xiantians = new HashSet<int>();
        img_xiantian = new Image[8];
        Transform root = transform.Find("show2/qiyun");
        for (int i = 0; i < 8; i++) {
            int rand_id;
            do {
                rand_id = Random.Range(0, XiantianQiyunData.dataList.Length);
            } while (xiantians.Contains(rand_id));
            xiantians.Add(rand_id);

            XiantianQiyun data = XiantianQiyunData.dataList[rand_id];
            Transform item = root.GetChild(i);
            img_xiantian[i] = item.GetComponent<Image>();
            item.GetChild(0).GetComponent<Image>().sprite = UIAssets.instance.itemColor[data.color];
            item.GetChild(1).GetComponent<Text>().text = data.name;
        }
        var list = new List<int>();
        list.AddRange(xiantians);
        this.rand_xiantian = list.ToArray();

        sel_xiantian = new List<int>();
        UpdateXiantian();
    }

    void UpdateXiantian() {
        for (int i = 0; i < img_xiantian.Length; i++) {
            img_xiantian[i].enabled = sel_xiantian.Contains(i);
        }
    }

    /// <summary>
    /// 点击先天气运
    /// </summary>
    /// <param name="idx"></param>
    public void ClickXiantian(int idx) {
        XiantianQiyun data = XiantianQiyunData.dataList[rand_xiantian[idx]];
        if (sel_xiantian.Contains(idx)) {
            img_xiantian[idx].enabled = false;
            sel_xiantian.Remove(idx);
            XiantianQiyunData.RemoveXiantianQiyun(rand_xiantian[idx], attribute, max_attribute);
        } else {
            while (sel_xiantian.Count >= 3) {
                img_xiantian[sel_xiantian[0]].enabled = false;
                sel_xiantian.RemoveAt(0);
                XiantianQiyunData.RemoveXiantianQiyun(rand_xiantian[idx], attribute, max_attribute);
            }
            img_xiantian[idx].enabled = true;
            sel_xiantian.Add(idx);
            XiantianQiyunData.AddXiantianQiyun(rand_xiantian[idx], attribute, max_attribute);
        }
        ShowAttr();
    }

    public void EnterXiantian(int idx) {
        XiantianQiyun data = XiantianQiyunData.dataList[rand_xiantian[idx]];
        EnterPointTips.instance.ShowTips(data.des, (RectTransform)img_xiantian[idx].transform);
    }

    public void ExitXiantian(int idx) {
        EnterPointTips.instance.HideTips();
    }

    public void ClickClose() {
        MainUI.HideUI("CreateRole");
    }

    public void NewGame() {
        string name = inputField.text;
        if (string.IsNullOrWhiteSpace(name)) {
            MessageTips.Message(5);
            show2.target = new Vector2(37, 0);
            show1.target = new Vector2(-2000, 0);
            return;
        }
        if (intrinsic < 0) {
            MessageTips.Message(2);
            show1.target = new Vector2(37, 0);
            show2.target = new Vector2(-2000, 0);
            return;
        }
        if (external.Count < 2) {
            MessageTips.Message(3);
            show1.target = new Vector2(37, 0);
            show2.target = new Vector2(-2000, 0);
            return;
        }
        if (sel_xiantian.Count < 3) {
            MessageTips.Message(4);
            show2.target = new Vector2(37, 0);
            show1.target = new Vector2(-2000, 0);
            return;
        }

        RoleData roleData = new RoleData();
        roleData.intrinsic_disposition = new int[] { intrinsic };
        roleData.external_disposition = external.ToArray();
        roleData.xiantianqiyun = new int[] { rand_xiantian[sel_xiantian[0]], rand_xiantian[sel_xiantian[1]], rand_xiantian[sel_xiantian[2]] };
        roleData.sex = sex;
        roleData.name = inputField.text;
        roleData.attribute = attribute;
        roleData.max_attribute = max_attribute;

        SaveData.NewGame(roleData);

        ClickClose();
        MainUI.HideUI("LoginMenu");
        //MainUI.ShowUI("MainUI");
        UnityEngine.SceneManagement.SceneManager.LoadScene("world");
    }
}