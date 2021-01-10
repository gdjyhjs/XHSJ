using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class StaticDataBuffEle : StaticIDData<string> {
    public string name;
    public string des;
    public float maxLayer;
    public float damage;
    public float fireDamage;
    public float iceDamage;
    public float electricityDamage;
    public float poisonDamage;
    public float durationTime;
    public float damageInterval;
    public float updamage;
    public float upspeed;
    public float backMove;
    public string lockAnim;
    public float hp;
    public string type;

}

public class StaticDataBuff : StaticIDDataTable<StaticDataBuffEle, string> {

}

