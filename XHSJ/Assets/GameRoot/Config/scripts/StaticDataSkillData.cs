using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
public class  StaticDataSkillDataEle :  StaticIDData<string>
{
    public string name;
    public string des;
    public double cool;
    public double cost;
    public double distance;
    public double attackAngle;
    public double type;
    public double Recovery;
    public double damage;
    public double fireDamage;
    public double iceDamage;
    public double electricityDamage;
    public double poisonDamage;
    public double durationTime;
    public double damageInterval;
    public double nextSkillId;
    public GameObject originalPrefab;
    public Sprite icon;
    public string animationName;
    public GameObject hitFxName;
    public string attackType;
    public string damageMode;
    public double SummonId;
    public double buffID;
}

public class  StaticDataSkillData :  StaticIDDataTable< StaticDataSkillDataEle, string>
{

}

