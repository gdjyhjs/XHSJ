using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using GuiBaseUI;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using UnityEngine.PlayerLoop;
using UnityEditor.VersionControl;

public class RoleUI : MonoBehaviour
{
    public Text t_name;
    public Text t_pope;
    public Text t_race;
    public Text t_identity;
    public Text t_sex;
    public Text t_level;
    public Text t_interest;


    /// <summary>
    /// 内在性格
    /// </summary>
    public Text t_intrinsic;
    /// <summary>
    /// 外在性格
    /// </summary>
    public Text[] t_external;

    /// <summary>
    /// 先天气运
    /// </summary>
    public Text[] t_xiantian;

    /// <summary>
    /// 后天气运
    /// </summary>
    public Text[] t_houtian;


    bool initok;
    RoleData roleData;

    private void Start() {
        initok = true;
        UpdateUI();
    }

    private void OnEnable() {
        if (roleData == null) {
            roleData = RoleData.mainRole;
        }
        if (!initok)
            return;
        UpdateUI();
    }

    private void OnDisable() {
        roleData = null;
    }

    void UpdateUI() {
        t_name.text = roleData.name;
        t_pope.text = MessageData.GetMessage(108); // 无
        t_race.text = MessageData.GetMessage(109); // 人族
        t_identity.text = MessageData.GetMessage(163); // 身份
        t_sex.text = MessageData.GetMessage(160 + (int)roleData.sex); // 性别
        t_level.text = LevelConfigData.GetName(roleData.GetAttr(RoleAttribute.level));
        t_interest.text = "笛子、萧";

        t_intrinsic.text = MessageData.GetMessage(110 + roleData.intrinsic_disposition[0]); // 内在性格
        t_intrinsic.GetComponent<BtnScale>().show_id = 56 + roleData.intrinsic_disposition[0];

        for (int i = 0; i < 2; i++) {
            t_external[i].text = MessageData.GetMessage(130 + roleData.external_disposition[i]); // 外在性格
            t_external[i].GetComponent<BtnScale>().show_id = 63 + roleData.external_disposition[i];
        }

        for (int i = 0; i < t_xiantian.Length; i++) {
            XiantianQiyun data = XiantianQiyunData.dataList[roleData.xiantianqiyun[i]];
            t_xiantian[i].text = data.name;
            t_xiantian[i].transform.parent.GetChild(0).GetComponent<Image>().sprite = UIAssets.instance.itemColor[data.color];
            t_xiantian[i].GetComponent<BtnScale>().show_str = data.des;
        }

        for (int i = 0; i < t_houtian.Length; i++) {
            Tools.SetActive(t_houtian[i].transform.parent.gameObject, false);
        }
    }
}
