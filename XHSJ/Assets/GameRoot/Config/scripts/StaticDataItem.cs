using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class  StaticDataItemEle :  StaticIDData<string>
{
    public string name;
    public string des;
    public ItemType type;
    public float min_hp;
    public float max_hp;
    public float min_sp;
    public float max_sp;
    public float min_strength;
    public float max_strength;
    public float min_magic;
    public float max_magic;
    public float min_speed;
    public float max_speed;
    public float min_defence;
    public float max_defence;
    public float min_fireResistance;
    public float max_fireResistance;
    public float min_iceResistance;
    public float max_iceResistance;
    public float min_electricityResistance;
    public float max_electricityResistance;
    public float min_poisonResistance;
    public float max_poisonResistance;
    public float min_attackDistance;
    public float max_attackDistance;
    public float min_energy;
    public float max_energy;
    public float min_weight;
    public float max_weight;
    public float min_fireDamage;
    public float max_fireDamage;
    public float min_iceDamage;
    public float max_iceDamage;
    public float min_electricityDamage;
    public float max_electricityDamage;
    public float min_poisonDamage;
    public float max_poisonDamage;
    public float min_fireAppend;
    public float max_fireAppend;
    public float min_iceAppend;
    public float max_iceAppend;
    public float min_electricityAppend;
    public float max_electricityAppend;
    public float min_poisonAppend;
    public float max_poisonAppend;
    public bool universal;
}

public class  StaticDataItem :  StaticIDDataTable< StaticDataItemEle, string>
{

}

