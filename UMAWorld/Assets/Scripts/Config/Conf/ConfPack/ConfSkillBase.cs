using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSkillItem : ConfBaseItem
{
	public string name;				//技能名称
	public string className;				//技能类名称
	public string spriteName;				//技能图标
	public int skillQuale;				//魔法性质
	public string skillType;				//魔法类型
	public string instruction;				//说明
	public string prerab;				//技能预制件
	public int speed;				//移动速度
	public int magic;				//消耗MP
	public int might;				//技能威力

	public ConfSkillItem()
	{
	}

	public ConfSkillItem(int id, string name, string className, string spriteName, int skillQuale, string skillType, string instruction, string prerab, int speed, int magic, int might)
	{
		this.id = id;
		this.name = name;
		this.className = className;
		this.spriteName = spriteName;
		this.skillQuale = skillQuale;
		this.skillType = skillType;
		this.instruction = instruction;
		this.prerab = prerab;
		this.speed = speed;
		this.magic = magic;
		this.might = might;
	}	

	public ConfSkillItem Clone()
	{
	    return base.CloneBase() as ConfSkillItem;
	}
}
public class ConfSkillBase : ConfBase
{
	private List<ConfSkillItem> _allConfList = new List<ConfSkillItem>();
	public IReadOnlyList<ConfSkillItem> allConfList {
		get { return _allConfList; }
	}

    public override void Init()
    {
		confName = "Skill";
 		allConfBase = new List<ConfBaseItem>();
		Init1();

	}

	private void Init1()
	{
		allConfBase.Add(new ConfSkillItem(1, "fireBall", "FireBall", "xxx", 1, "3", "xxx", "fireBall", 5, 5, 6));
	}

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfSkillItem);
	}

	public ConfSkillItem GetItem(int id)
	{
		return GetItemObject<ConfSkillItem>(id);
	}
	
}
	
