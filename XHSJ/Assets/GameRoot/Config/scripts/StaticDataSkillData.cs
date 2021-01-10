using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

[System.Serializable]
public class  StaticDataSkillDataEle :  StaticIDData<string>
{
    public string name;
    public string des;
    public float cool;
    public float cost;
    public float distance;
    public float attackAngle;
    public float type;
    public float Recovery;
    public float damage;
    public float fireDamage;
    public float iceDamage;
    public float electricityDamage;
    public float poisonDamage;
    public float durationTime;
    public float damageInterval;
    public float nextSkillId;
    public GameObject originalPrefab;
    public Sprite icon;
    public string animationName;
    public GameObject hitFxName;
    public string attackType;
    public string damageMode;
    public float SummonId;
    public float buffID;
}

public class  StaticDataSkillData :  StaticIDDataTable< StaticDataSkillDataEle, string>
{

}

