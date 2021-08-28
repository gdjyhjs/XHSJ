using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UIWorldMain : UIBase {
    public UnitBase unit;
    public Image hpFill;
    public Image mpFill;
    public Text hpText;
    public Text mpText;


    private void Awake() {
        g.uiWorldMain = this;
    }

    public void UpdateUI() {
        UpdateHP();
        UpdateMP();
    }

    public void UpdateHP() {
        hpText.text = unit.attribute.hp + "/" + unit.attribute.maxHp;
        hpFill.fillAmount = unit.attribute.health_cur / unit.attribute.health_max;
    }

    public void UpdateMP() {
        mpText.text = unit.attribute.mp + "/" + unit.attribute.maxMp;
        mpFill.fillAmount = unit.attribute.magic_cur / unit.attribute.magic_max;
    }
}
