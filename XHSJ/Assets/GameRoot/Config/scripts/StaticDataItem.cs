using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class  StaticDataItemEle :  StaticIDData<string>
{
    public string name;
    public string des;
    public ItemType type;
    public double min_hp;
    public double max_hp;
    public double min_sp;
    public double max_sp;
    public double min_strength;
    public double max_strength;
    public double min_magic;
    public double max_magic;
    public double min_speed;
    public double max_speed;
    public double min_defence;
    public double max_defence;
    public double min_fireResistance;
    public double max_fireResistance;
    public double min_iceResistance;
    public double max_iceResistance;
    public double min_electricityResistance;
    public double max_electricityResistance;
    public double min_poisonResistance;
    public double max_poisonResistance;
    public double min_attackDistance;
    public double max_attackDistance;
    public double min_energy;
    public double max_energy;
    public double min_weight;
    public double max_weight;
    public double min_fireDamage;
    public double max_fireDamage;
    public double min_iceDamage;
    public double max_iceDamage;
    public double min_electricityDamage;
    public double max_electricityDamage;
    public double min_poisonDamage;
    public double max_poisonDamage;
    public double min_fireAppend;
    public double max_fireAppend;
    public double min_iceAppend;
    public double max_iceAppend;
    public double min_electricityAppend;
    public double max_electricityAppend;
    public double min_poisonAppend;
    public double max_poisonAppend;
    public bool universal;
}

public class  StaticDataItem :  StaticIDDataTable< StaticDataItemEle, string>
{

}

