namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSchoolFloorItem : ConfBaseItem
{
	public float areaWidth;				//占地宽度(cm)
	public float areaHeight;				//占地高度cm)
	public float areaLong;				//占地长度cm)
	public string prefab;				//预制件

	public ConfSchoolFloorItem()
	{
	}

	public ConfSchoolFloorItem(int id, float areaWidth, float areaHeight, float areaLong, string prefab)
	{
		this.id = id;
		this.areaWidth = areaWidth;
		this.areaHeight = areaHeight;
		this.areaLong = areaLong;
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
		allConfBase.Add(new ConfSchoolFloorItem(0, 8f, 0.06f, 8f, "Prefab/Build/Floor/SchoolTile"));
		allConfBase.Add(new ConfSchoolFloorItem(1, 4.1f, 1.85f, 2.9f, "Prefab/Build/Floor/SchoolStairs"));
		allConfBase.Add(new ConfSchoolFloorItem(2, 10.48f, 11f, 16.08f, "Prefab/Build/Floor/SchoolFloor"));
		allConfBase.Add(new ConfSchoolFloorItem(3, 30.85f, 17.8f, 6.5f, "Prefab/Build/House/SchoolMainGate"));
		allConfBase.Add(new ConfSchoolFloorItem(4, 15f, 5f, 1f, "Prefab/Build/Wall/SchoolWallGate"));
		allConfBase.Add(new ConfSchoolFloorItem(5, 10f, 5f, 1f, "Prefab/Build/Wall/SchoolWall"));
		allConfBase.Add(new ConfSchoolFloorItem(6, 2f, 5f, 2f, "Prefab/Build/Wall/SchoolWallCorner"));
		allConfBase.Add(new ConfSchoolFloorItem(7, 12f, 8f, 16f, "Prefab/Build/House/SchoolOutHouse"));
		allConfBase.Add(new ConfSchoolFloorItem(8, 15f, 15f, 15f, "Prefab/Build/Tree/SchoolOutTree"));
		allConfBase.Add(new ConfSchoolFloorItem(9, 3.3f, 3.3f, 3.3f, "Prefab/Build/Decorate/Flowerbed"));
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