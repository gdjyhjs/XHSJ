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
		allConfBase.Add(new ConfSchoolFloorItem(7, 15.9f, 18f, 11.85f, "Prefab/Build/House/SchoolOutHouse"));
		allConfBase.Add(new ConfSchoolFloorItem(8, 15f, 15f, 15f, "Prefab/Build/Tree/SchoolOutTree"));
		allConfBase.Add(new ConfSchoolFloorItem(9, 3.3f, 3.3f, 3.3f, "Prefab/Build/Decorate/Flowerbed"));
		allConfBase.Add(new ConfSchoolFloorItem(10, 2.94f, 6.24f, 4.12f, "Prefab/Build/Decorate/LionStatue"));
		allConfBase.Add(new ConfSchoolFloorItem(11, 15.7f, 10.8f, 12.4f, "Prefab/Build/House/SchoolInHouse"));
		allConfBase.Add(new ConfSchoolFloorItem(12, 12f, 12.3f, 15.8f, "Prefab/Build/House/SchoolInTrueHouse"));
		allConfBase.Add(new ConfSchoolFloorItem(13, 10f, 5f, 1f, "Prefab/Build/Wall/SchoolWall1"));
		allConfBase.Add(new ConfSchoolFloorItem(14, 2f, 5f, 2f, "Prefab/Build/Wall/SchoolWallCorner1"));
		allConfBase.Add(new ConfSchoolFloorItem(15, 4f, 2.5f, 0.39f, "Prefab/Build/Wall/SchoolWall2"));
		allConfBase.Add(new ConfSchoolFloorItem(16, 0.58f, 2.75f, 0.58f, "Prefab/Build/Wall/SchoolWallCorner2"));
		allConfBase.Add(new ConfSchoolFloorItem(17, 10f, 5f, 1f, "Prefab/Build/Wall/SchoolWall3"));
		allConfBase.Add(new ConfSchoolFloorItem(18, 2f, 5f, 2f, "Prefab/Build/Wall/SchoolWallCorner3"));
		allConfBase.Add(new ConfSchoolFloorItem(19, 12.1f, 10.5f, 13.2f, "Prefab/Build/House/SchoolStore"));
		allConfBase.Add(new ConfSchoolFloorItem(20, 9.8f, 11.5f, 6.4f, "Prefab/Build/House/SchoolUpLevelPlatform"));
		allConfBase.Add(new ConfSchoolFloorItem(21, 22.7f, 16.5f, 13.3f, "Prefab/Build/House/SchoolTask"));
		allConfBase.Add(new ConfSchoolFloorItem(22, 16.1f, 9f, 10.5f, "Prefab/Build/House/SchoolHospital"));
		allConfBase.Add(new ConfSchoolFloorItem(23, 43.1f, 15f, 23.9f, "Prefab/Build/House/SchoolMeeting"));
		allConfBase.Add(new ConfSchoolFloorItem(24, 10.1f, 8.2f, 10.6f, "Prefab/Build/House/SchoolDepot"));
		allConfBase.Add(new ConfSchoolFloorItem(25, 26.5f, 17f, 22f, "Prefab/Build/House/SchoolBookShop"));
		allConfBase.Add(new ConfSchoolFloorItem(26, 10f, 12f, 10f, "Prefab/Build/House/SchoolTransmit"));
		allConfBase.Add(new ConfSchoolFloorItem(27, 6.79f, 20.9f, 6.17f, "Prefab/Build/Tree/SchoolBambooA"));
		allConfBase.Add(new ConfSchoolFloorItem(28, 10.63f, 23.25f, 10.05f, "Prefab/Build/Tree/SchoolBambooB"));
		allConfBase.Add(new ConfSchoolFloorItem(29, 6.31f, 10.1f, 6.73f, "Prefab/Build/Tree/SchoolBambooC"));
		allConfBase.Add(new ConfSchoolFloorItem(30, 29.1f, 26.85f, 30.7f, "Prefab/Build/House/SchoolElderHouse"));
		allConfBase.Add(new ConfSchoolFloorItem(31, 29.1f, 26.85f, 30.7f, "Prefab/Build/House/SchoolBigElderHouse"));
		allConfBase.Add(new ConfSchoolFloorItem(32, 31.7f, 35.5f, 32f, "Prefab/Build/House/SchoolInTrueHouse"));
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