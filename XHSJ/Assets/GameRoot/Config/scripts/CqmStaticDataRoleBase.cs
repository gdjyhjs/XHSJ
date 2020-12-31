using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class CqmStaticDataRoleBaseEle : cqmStaticIDData<string>
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
}

public class CqmStaticDataRoleBase : cqmStaticIDDataTable<CqmStaticDataRoleBaseEle, string>
{

}

