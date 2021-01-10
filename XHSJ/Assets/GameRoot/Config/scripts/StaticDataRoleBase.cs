using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class  StaticDataRoleBaseEle :  StaticIDData<string>
{
    public string des;
    public float hp;
    public float sp;
    public float strength;
    public float magic;
    public float speed;
    public float defence;
    public float fireResistance;
    public float iceResistance;
    public float electricityResistance;
    public float poisonResistance;
    public float fireDamage;
    public float iceDamage;
    public float electricityDamage;
    public float poisonDamage;
    public float fireAppend;
    public float iceAppend;
    public float electricityAppend;
    public float poisonAppend;
}

public class  StaticDataRoleBase :  StaticIDDataTable< StaticDataRoleBaseEle, string>
{

}

