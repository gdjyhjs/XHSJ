using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class  StaticDataAttrDesEle :  StaticIDData<string>
{
    public string attr;
    public string name;
    public string des;
    public double minValue;
    public double maxValue;
}

public class  StaticDataAttrDes :  StaticIDDataTable< StaticDataAttrDesEle, string>
{

}

