namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSchoolColorItem : ConfBaseItem
{
	public float tilingX;				//平铺X
	public float tilingY;				//平铺Y
	public string material;				//预制件

	public ConfSchoolColorItem()
	{
	}

	public ConfSchoolColorItem(int id, float tilingX, float tilingY, string material)
	{
		this.id = id;
		this.tilingX = tilingX;
		this.tilingY = tilingY;
		this.material = material;
	}	

	public ConfSchoolColorItem Clone()
	{
	    return base.CloneBase() as ConfSchoolColorItem;
	}
}
public class ConfSchoolColorBase : ConfBase
{
	private List<ConfSchoolColorItem> _allConfList = new List<ConfSchoolColorItem>();
	public IReadOnlyList<ConfSchoolColorItem> allConfList {
		get { return _allConfList; }
	}

    public override void Init()
    {
		confName = "SchoolColor";
 		allConfBase = new List<ConfBaseItem>();
		Init1();

	}

	private void Init1()
	{
		allConfBase.Add(new ConfSchoolColorItem(1, 0.2f, 0.2f, "Material/SchoolBigStone"));
		allConfBase.Add(new ConfSchoolColorItem(2, 0.2f, 0.2f, "Material/SchoolStone"));
		allConfBase.Add(new ConfSchoolColorItem(3, 0.2f, 0.2f, "Material/SchoolGround1"));
		allConfBase.Add(new ConfSchoolColorItem(4, 0.2f, 0.2f, "Material/SchoolGround2"));
		allConfBase.Add(new ConfSchoolColorItem(5, 0.2f, 0.2f, "Material/SchoolGround3"));
		allConfBase.Add(new ConfSchoolColorItem(6, 0.2f, 0.2f, "Material/SchoolGround4"));
	}

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfSchoolColorItem);
	}

	public ConfSchoolColorItem GetItem(int id)
	{
		return GetItemObject<ConfSchoolColorItem>(id);
	}
	
}
	

}