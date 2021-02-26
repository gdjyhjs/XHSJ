using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RoleWindow : BaseWindow {
    public Text title_text;
    public GameObject roleSel, skillSel, artistrySel, bagSel, experienceSel, relationSel;
    public GameObject attrUI;
    public GameObject rolemodelUI;
    public GameObject roleUI;
    public GameObject bagUI;
    public GameObject GongfaUI;
    public int[] packParamID;
    public Text[] packText;
    public string packPName;
    public string[] packParams;

    private void Awake() {
    }

    private void OnEnable() {

        for (int i = 0; i < packText.Length; i++) {
            string ex = "";
            foreach (SettingStruct item in SettingData.instance.worldShortcutKeys) {
                if (item.type == "uiwindow") {
                    if ((packPName == item.param1) && (string.IsNullOrWhiteSpace(packParams[i]) || packParams[i] == item.param2)) {
                        ex = string.Format("({0})", item.keyCode);
                    }
                }
            }
            packText[i].text = MessageData.GetMessage(packParamID[i]) + ex;
        }


        string sub_show = string.IsNullOrWhiteSpace(MainUI.instance.sub_show) ? "role" : MainUI.instance.sub_show;
        bool show_role = sub_show == "role";
        bool show_skill = sub_show == "skill";
        bool show_artistry = sub_show == "artistry";
        bool show_bag = sub_show == "bag";
        bool show_experience = sub_show == "experience";
        bool show_relation = sub_show == "relation";

        Tools.SetActive(roleSel, show_role);
        Tools.SetActive(skillSel, show_skill);
        Tools.SetActive(artistrySel, show_artistry);
        Tools.SetActive(bagSel, show_bag);
        Tools.SetActive(experienceSel, show_experience);
        Tools.SetActive(relationSel, show_relation);
        Tools.SetActive(attrUI, show_role || show_skill || show_artistry || show_bag);
        Tools.SetActive(rolemodelUI, show_role || show_artistry);
        Tools.SetActive(roleUI, show_role);
        Tools.SetActive(bagUI, show_bag);
        Tools.SetActive(GongfaUI, show_skill);

        if (show_role) {
            title_text.text = MessageData.GetMessage(packParamID[0]);
        } else if (show_bag) {
            title_text.text = MessageData.GetMessage(packParamID[1]);
        } else if (show_skill) {
            title_text.text = MessageData.GetMessage(packParamID[2]);
        } else if (show_artistry) {
            title_text.text = MessageData.GetMessage(packParamID[3]);
        } else if (show_experience) {
            title_text.text = MessageData.GetMessage(packParamID[4]);
        } else if (show_relation) {
            title_text.text = MessageData.GetMessage(packParamID[5]);
        }
    }




    public void ClickRole() {
        // 人物
        MainUI.ShowUI("RoleWindow", "role");
    }
    public void ClickSkill() {
        // 技能
        MainUI.ShowUI("RoleWindow", "skill");
    }
    public void ClickArtistry() {
        // 技艺
        MainUI.ShowUI("RoleWindow", "artistry");
    }
    public void ClickBag() {
        // 背包
        MainUI.ShowUI("RoleWindow", "bag");
    }
    public void ClickExperience() {
        // 经历
        MainUI.ShowUI("RoleWindow", "experience");
    }
    public void ClickRelation() {
        // 关系
        MainUI.ShowUI("RoleWindow", "relation");
    }
}
