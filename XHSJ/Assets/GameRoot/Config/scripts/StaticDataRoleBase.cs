using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class  StaticDataRoleBaseEle :  StaticIDData<string>
{
    public string des;
    public double hp;
    public double sp;
    public double strength;
    public double magic;
    public double speed;
    public double defence;
    public double fireResistance;
    public double iceResistance;
    public double electricityResistance;
    public double poisonResistance;
    public double fireDamage;
    public double iceDamage;
    public double electricityDamage;
    public double poisonDamage;
    public double fireAppend;
    public double iceAppend;
    public double electricityAppend;
    public double poisonAppend;
}

public class  StaticDataRoleBase :  StaticIDDataTable< StaticDataRoleBaseEle, string>
{

}

