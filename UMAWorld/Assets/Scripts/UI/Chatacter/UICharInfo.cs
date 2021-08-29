using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UICharInfo : UIBase {
    public Transform m_attrRoot;
    public UnitBase unit;

    private void Awake() {
        unit = g.units.player;
        string[] attr = new string[]{
            "name",
            "race",
            "gender",
            "level",
            "health",
            "magic",
            "health_restore",
            "magic_restore",
            "attack",
            "defend",
            "move_speed",
            "resist_fire",
            "resist_forzen",
            "resist_lighting",
            "resist_poison",
        };
        for (int i = 0; i < attr.Length; i++) {
            m_attrRoot.GetChild(i * 2).GetComponent<LanguageText>().text = attr[i];
        }
    }

    private void OnEnable() {
        UpdateUI();
    }

    private void UpdateUI() {
        Debug.Log("unit = "+ unit);

        int[] attr = new int[]{
            0,
           0,
           0,
           0,
           0,
         0,
            Mathf.CeilToInt( unit.attribute.health_restore),
            Mathf.CeilToInt(  unit.attribute.magic_restore),
           Mathf.CeilToInt(  unit.attribute.attack),
        Mathf.CeilToInt(   unit.attribute.defence),
        Mathf.CeilToInt(    unit.attribute.speed),
         unit.attribute.resist_fire,
            unit.attribute.resist_forzen,
           unit.attribute.resist_lighting,
         unit.attribute.resist_poison
        };

        for (int i = 0; i < attr.Length; i++) {
            if (i == 0) { // 名字
                m_attrRoot.GetChild(i * 2 + 1).GetComponent<LanguageText>().Text(unit.id, false);
            } else if (i == 3) { // 等级
                g.conf.charLevel.SetName(m_attrRoot.GetChild(i * 2 + 1).GetComponent<LanguageText>(), unit.attribute.level);
            } else if (i == 4) { // 生命
                m_attrRoot.GetChild(i * 2 + 1).GetComponent<LanguageText>().Text("{0}/{1}",
                    false, unit.attribute.hp, unit.attribute.maxHp);
            } else if (i == 5) { // 法力
                m_attrRoot.GetChild(i * 2 + 1).GetComponent<LanguageText>().Text("{0}/{1}",
                    false, unit.attribute.mp, unit.attribute.maxMp);
            } else if (i == 1) { // 种族
                m_attrRoot.GetChild(i * 2 + 1).GetComponent<LanguageText>().text = unit.appearance.race.ToString();
            } else if (i == 2) { // 性别
                m_attrRoot.GetChild(i * 2 + 1).GetComponent<LanguageText>().text = unit.appearance.sex.ToString();
            } else { // 纯数字
                m_attrRoot.GetChild(i * 2 + 1).GetComponent<LanguageText>().Text(attr[i].ToString(), false);
            }
        }
    }


}
