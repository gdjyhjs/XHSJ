namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSchoolHouseItem : ConfBaseItem
{
	public int areaWidth;				//占地宽度
	public int areaLong;				//占地长度
	public int areaHeight;				//占地高度
	public string prefab;				//预制件

	public ConfSchoolHouseItem()
	{
	}

	public ConfSchoolHouseItem(int id, int areaWidth, int areaLong, int areaHeight, string prefab)
	{
		this.id = id;
		this.areaWidth = areaWidth;
		this.areaLong = areaLong;
		this.areaHeight = areaHeight;
		this.prefab = prefab;
	}	

	public ConfSchoolHouseItem Clone()
	{
	    return base.CloneBase() as ConfSchoolHouseItem;
	}
}
public class ConfSchoolHouseBase : ConfBase
{
	private List<ConfSchoolHouseItem> _allConfList = new List<ConfSchoolHouseItem>();
	public IReadOnlyList<ConfSchoolHouseItem> allConfList {
		get { return _allConfList; }
	}

    public override void Init()
    {
		confName = "SchoolHouse";
 		allConfBase = new List<ConfBaseItem>();
		Init1();

	}

	private void Init1()
	{
		allConfBase.Add(new ConfSchoolHouseItem(0, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(1, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(2, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(3, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(4, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(5, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(6, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(7, 10, 10, 10, "xxx"));
		allConfBase.Add(new ConfSchoolHouseItem(8, 10, 10, 10, "xxx"));
	}

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfSchoolHouseItem);
	}

	public ConfSchoolHouseItem GetItem(int id)
	{
		return GetItemObject<ConfSchoolHouseItem>(id);
	}
	
}
	

}