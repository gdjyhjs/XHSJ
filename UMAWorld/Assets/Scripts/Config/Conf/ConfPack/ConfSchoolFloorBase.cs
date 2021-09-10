namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSchoolFloorItem : ConfBaseItem
{
	public float areaWidth;				//占地宽度(cm)
	public float areaLong;				//占地长度cm)
	public float areaHeight;				//占地高度cm)
	public string prefab;				//预制件

	public ConfSchoolFloorItem()
	{
	}

	public ConfSchoolFloorItem(int id, float areaWidth, float areaLong, float areaHeight, string prefab)
	{
		this.id = id;
		this.areaWidth = areaWidth;
		this.areaLong = areaLong;
		this.areaHeight = areaHeight;
		this.prefab = prefab;
	}	

	public ConfSchoolFloorItem Clone()
	{
	    return base.CloneBase() as ConfSchoolFloorItem;
	}
}
public class ConfSchoolFloorBase : ConfBase
{
	private List<ConfSchoolFloorItem> _allConfList = new List<ConfSchoolFloorItem>();
	public IReadOnlyList<ConfSchoolFloorItem> allConfList {
		get { return _allConfList; }
	}

    public override void Init()
    {
		confName = "SchoolFloor";
 		allConfBase = new List<ConfBaseItem>();
		Init1();

	}

	private void Init1()
	{
		allConfBase.Add(new ConfSchoolFloorItem(0, 4f, 4f, 0.06f, "Prefab/Build/Floor/Ground_Brick1"));
		allConfBase.Add(new ConfSchoolFloorItem(1, 2.37f, 1.55f, 0.92f, "Prefab/Build/Floor/Stairs1"));
		allConfBase.Add(new ConfSchoolFloorItem(2, 9.95f, 10.67f, 0.9f, "Prefab/Build/Floor/Floor"));
		allConfBase.Add(new ConfSchoolFloorItem(3, 30.85f, 6.5f, 17.8f, "Prefab/Build/House/MainGate"));
	}

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfSchoolFloorItem);
	}

	public ConfSchoolFloorItem GetItem(int id)
	{
		return GetItemObject<ConfSchoolFloorItem>(id);
	}
	
}
	

}