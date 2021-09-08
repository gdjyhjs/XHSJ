namespace UMAWorld {
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfCharLevelItem : ConfBaseItem
{
	public int nextExp;				//晋级经验
	public int[] needProp;				//突破材料
	public string namefront;				//境界名称(前)
	public string nameback;				//境界名称(后)

	public ConfCharLevelItem()
	{
	}

	public ConfCharLevelItem(int id, int nextExp, int[] needProp, string namefront, string nameback)
	{
		this.id = id;
		this.nextExp = nextExp;
		this.needProp = needProp;
		this.namefront = namefront;
		this.nameback = nameback;
	}	

	public ConfCharLevelItem Clone()
	{
	    return base.CloneBase() as ConfCharLevelItem;
	}
}
public class ConfCharLevelBase : ConfBase
{
	private List<ConfCharLevelItem> _allConfList = new List<ConfCharLevelItem>();
	public IReadOnlyList<ConfCharLevelItem> allConfList {
		get { return _allConfList; }
	}

    public override void Init()
    {
		confName = "CharLevel";
 		allConfBase = new List<ConfBaseItem>();
		Init1();

	}

	private void Init1()
	{
		allConfBase.Add(new ConfCharLevelItem(0, 100, new int[]{ }, "BigLevel1", "SmallLevel1"));
		allConfBase.Add(new ConfCharLevelItem(1, 200, new int[]{ }, "BigLevel1", "SmallLevel2"));
		allConfBase.Add(new ConfCharLevelItem(2, 300, new int[]{ }, "BigLevel1", "SmallLevel3"));
		allConfBase.Add(new ConfCharLevelItem(3, 400, new int[]{ }, "BigLevel1", "SmallLevel4"));
		allConfBase.Add(new ConfCharLevelItem(4, 500, new int[]{ }, "BigLevel1", "SmallLevel5"));
		allConfBase.Add(new ConfCharLevelItem(5, 600, new int[]{ }, "BigLevel2", "SmallLevel1"));
		allConfBase.Add(new ConfCharLevelItem(6, 700, new int[]{ }, "BigLevel2", "SmallLevel2"));
		allConfBase.Add(new ConfCharLevelItem(7, 800, new int[]{ }, "BigLevel2", "SmallLevel3"));
		allConfBase.Add(new ConfCharLevelItem(8, 900, new int[]{ }, "BigLevel2", "SmallLevel4"));
		allConfBase.Add(new ConfCharLevelItem(9, 1000, new int[]{ }, "BigLevel2", "SmallLevel5"));
		allConfBase.Add(new ConfCharLevelItem(10, 1100, new int[]{ }, "BigLevel3", "SmallLevel1"));
		allConfBase.Add(new ConfCharLevelItem(11, 1200, new int[]{ }, "BigLevel3", "SmallLevel2"));
		allConfBase.Add(new ConfCharLevelItem(12, 1300, new int[]{ }, "BigLevel3", "SmallLevel3"));
		allConfBase.Add(new ConfCharLevelItem(13, 1400, new int[]{ }, "BigLevel3", "SmallLevel4"));
		allConfBase.Add(new ConfCharLevelItem(14, 1500, new int[]{ }, "BigLevel3", "SmallLevel5"));
	}

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfCharLevelItem);
	}

	public ConfCharLevelItem GetItem(int id)
	{
		return GetItemObject<ConfCharLevelItem>(id);
	}
	
}
	

}