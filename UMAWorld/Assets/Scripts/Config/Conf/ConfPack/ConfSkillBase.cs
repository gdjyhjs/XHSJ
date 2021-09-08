namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSkillItem : ConfBaseItem
{
	public string name;				//技能名称
	public string className;				//技能类名称
	public string spriteName;				//技能图标
	public int skillQuale;				//魔法性质
	public int skillType;				//魔法类型
	public string instruction;				//说明
	public string prefab;				//技能预制件
	public float duration;				//持续时间
	public float speed;				//移动速度
	public int magic;				//消耗MP
	public float might;				//技能威力
	public int cool;				//冷却时间
	public int through ;				//穿透次数

	public ConfSkillItem()
	{
	}

	public ConfSkillItem(int id, string name, string className, string spriteName, int skillQuale, int skillType, string instruction, string prefab, float duration, float speed, int magic, float might, int cool, int through )
	{
		this.id = id;
		this.name = name;
		this.className = className;
		this.spriteName = spriteName;
		this.skillQuale = skillQuale;
		this.skillType = skillType;
		this.instruction = instruction;
		this.prefab = prefab;
		this.duration = duration;
		this.speed = speed;
		this.magic = magic;
		this.might = might;
		this.cool = cool;
		this.through  = through ;
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
		allConfBase.Add(new ConfSkillItem(1, "fireBall", "SkillLine", "xxx", 1, 100000, "xxx", "Prefab/Bullet/FireBall", 3f, 8f, 5, 1f, 1, 0));
		allConfBase.Add(new ConfSkillItem(2, "soilBall", "SkillLine", "xxx", 0, 100000, "xxx", "Prefab/Bullet/SoilBall", 5f, 10f, 20, 1.2f, 3, 0));
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
	

}