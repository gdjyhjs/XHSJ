using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class  StaticDataLocazationEle :  StaticIDData<string>
{
    public string cn;
    public string twcn;
}

public class  StaticDataLocazation :  StaticIDDataTable< StaticDataLocazationEle, string>
{

}

