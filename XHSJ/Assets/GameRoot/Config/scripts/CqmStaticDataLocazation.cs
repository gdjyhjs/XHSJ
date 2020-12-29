using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class CqmStaticDataLocazationEle : cqmStaticIDData<string>
{
    public string cn;
    public string twcn;
}

public class CqmStaticDataLocazation : cqmStaticIDDataTable<CqmStaticDataLocazationEle, string>
{

}

