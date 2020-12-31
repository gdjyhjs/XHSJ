using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class CqmStaticDataRoleBaseEle : cqmStaticIDData<string>
{
    public string des;
}

public class CqmStaticDataRoleBase : cqmStaticIDDataTable<CqmStaticDataRoleBaseEle, string>
{

}

