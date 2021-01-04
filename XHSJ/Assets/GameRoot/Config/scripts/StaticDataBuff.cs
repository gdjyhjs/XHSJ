using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class  StaticDataBuffEle :  StaticIDData<string>
{
    public string name;
    public string des;
    public double maxLayer;
    public double damage;
    public double fireDamage;
    public double iceDamage;
    public double electricityDamage;
    public double poisonDamage;
    public double durationTime;
    public double damageInterval;
    public double updamage;
    public double upspeed;
    public double backMove;
    public string lockAnim;
    public double hp;
    public string type;

}

public class  StaticDataBuff :  StaticIDDataTable< StaticDataBuffEle, string>
{

}

