namespace UMAWorld {
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfMgr
{
    public class Data
    {
		public ConfLanguage language = new ConfLanguage();
		public ConfSchoolBuild schoolBuild = new ConfSchoolBuild();
		public ConfSchoolFloor schoolFloor = new ConfSchoolFloor();
		public ConfSkill skill = new ConfSkill();
		public ConfCreateRoleAttribute createRoleAttribute = new ConfCreateRoleAttribute();
		public ConfCharLevel charLevel = new ConfCharLevel();

    }

    public Data data = new Data();
    public List<ConfBase> allConfBase = new List<ConfBase>();

    public System.Action onInitCall;
	
	public ConfLanguage language { get { data.language.onGetItemObjectHandler = null; return data.language; } }		//多语言表.xlsx
	public ConfSchoolBuild schoolBuild { get { data.schoolBuild.onGetItemObjectHandler = null; return data.schoolBuild; } }		//建筑生成.xlsx
	public ConfSchoolFloor schoolFloor { get { data.schoolFloor.onGetItemObjectHandler = null; return data.schoolFloor; } }		//建筑生成.xlsx
	public ConfSkill skill { get { data.skill.onGetItemObjectHandler = null; return data.skill; } }		//技能表.xlsx
	public ConfCreateRoleAttribute createRoleAttribute { get { data.createRoleAttribute.onGetItemObjectHandler = null; return data.createRoleAttribute; } }		//角色属性.xlsx
	public ConfCharLevel charLevel { get { data.charLevel.onGetItemObjectHandler = null; return data.charLevel; } }		//角色属性.xlsx

    public void Init(System.Action call)
    {
		g.game.timer.Thread(()=> {
			Init();
			onInitCall?.Invoke();
			InitEnd();
		}, ()=> {
			OnInit();
			call();
		});
    }
	
	public void Init()
    {
		allConfBase.Add(language);
		allConfBase.Add(schoolBuild);
		allConfBase.Add(schoolFloor);
		allConfBase.Add(skill);
		allConfBase.Add(createRoleAttribute);
		allConfBase.Add(charLevel);


        for (int i = 0; i < allConfBase.Count; i++)
        {
            allConfBase[i].Init();
        }
    }
	
    public void InitEnd()
    {
        for (int i = 0; i < allConfBase.Count; i++)
        {
            allConfBase[i].InitEnd();
        }
    }
	
	public void OnInit()
	{
		for (int i = 0; i < allConfBase.Count; i++)
		{
			allConfBase[i].OnInit();
		}
	}
}

}