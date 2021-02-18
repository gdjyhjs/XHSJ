using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RoleWindow : BaseWindow {
    public Text title_text;
    public GameObject roleSel, skillSel, artistrySel, bagSel, experienceSel, relationSel;
    public GameObject attrUI;
    public GameObject rolemodelUI;
    public GameObject bagUI;
    public int[] packParamID;
    public Text[] packText;
    public string packPName;
    public string[] packParams;

    private void Awake() {
    }

    private void OnEnable() {

        for (int i = 0; i < packText.Length; i++) {
            string ex = "";
            foreach (UIShortcutKey item in GameConst.uIShortcutKeys) {
                if (item.type == "uiwindow") {
                    if ((packPName == item.param1) && (string.IsNullOrWhiteSpace(packParams[i]) || packParams[i] == item.param2)) {
                        ex = string.Format("({0})", item.keyCode);
                    }
                }
            }
            packText[i].text = MessageData.GetMessage(packParamID[i]) + ex;
        }


        string sub_show = MainUI.instance.sub_show;
        bool show_role = sub_show == "role";
        bool show_skill = sub_show == "skill";
        bool show_artistry = sub_show == "artistry";
        bool show_bag = sub_show == "bag";
        bool show_experience = sub_show == "experience";
        bool show_relation = sub_show == "relation";
        roleSel.SetActive(show_role);
        skillSel.SetActive(show_skill);
        artistrySel.SetActive(show_artistry);
        bagSel.SetActive(show_bag);
        experienceSel.SetActive(show_experience);
        relationSel.SetActive(show_relation);
        attrUI.SetActive(show_role || show_skill || show_artistry || show_bag);
        rolemodelUI.SetActive(show_role || show_skill || show_artistry);
        bagUI.SetActive(show_bag);


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
