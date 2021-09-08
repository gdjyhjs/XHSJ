namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSchoolFloorItem : ConfBaseItem
{
	public int areaWidth;				//占地宽度(cm)
	public int areaLong;				//占地长度cm)
	public int areaHeight;				//占地高度cm)
	public int type;				//类型
	public string prefab;				//预制件

	public ConfSchoolFloorItem()
	{
	}

	public ConfSchoolFloorItem(int id, int areaWidth, int areaLong, int areaHeight, int type, string prefab)
	{
		this.id = id;
		this.areaWidth = areaWidth;
		this.areaLong = areaLong;
		this.areaHeight = areaHeight;
		this.type = type;
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
		allConfBase.Add(new ConfSchoolFloorItem(0, 400, 400, 6, 1, "Prefab/Build/Floor/Ground_Brick1"));
		allConfBase.Add(new ConfSchoolFloorItem(1, 237, 162, 100, 2, "Prefab/Build/Floor/Stairs1"));
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