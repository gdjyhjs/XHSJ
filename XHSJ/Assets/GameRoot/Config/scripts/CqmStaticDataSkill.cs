using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[System.Serializable]
public class CqmStaticDataSkillEle : cqmStaticIDData<string>
{
    public string cn;
    public string twcn;
}

public class CqmStaticDataSkill : cqmStaticIDDataTable<CqmStaticDataSkillEle, string>
{

}

