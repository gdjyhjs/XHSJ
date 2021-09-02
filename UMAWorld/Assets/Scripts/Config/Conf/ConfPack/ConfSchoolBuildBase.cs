using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfSchoolBuildItem : ConfBaseItem
{
	public int[] minPos;				//最小位置
	public int[] maxPos;				//最大位置
	public int minDis;				//距离其他宗门最小距离
	public int minRadius;				//最小半径
	public int maxRadius;				//最大半径
	public int minVertexCount;				//最少顶点数量
	public int maxVertexCount;				//最多顶点数量

	public ConfSchoolBuildItem()
	{
	}

	public ConfSchoolBuildItem(int id, int[] minPos, int[] maxPos, int minDis, int minRadius, int maxRadius, int minVertexCount, int maxVertexCount)
	{
		this.id = id;
		this.minPos = minPos;
		this.maxPos = maxPos;
		this.minDis = minDis;
		this.minRadius = minRadius;
		this.maxRadius = maxRadius;
		this.minVertexCount = minVertexCount;
		this.maxVertexCount = maxVertexCount;
	}	

	public ConfSchoolBuildItem Clone()
	{
	    return base.CloneBase() as ConfSchoolBuildItem;
	}
}
public class ConfSchoolBuildBase : ConfBase
{
	private List<ConfSchoolBuildItem> _allConfList = new List<ConfSchoolBuildItem>();
	public IReadOnlyList<ConfSchoolBuildItem> allConfList {
		get { return _allConfList; }
	}

    public override void Init()
    {
		confName = "SchoolBuild";
 		allConfBase = new List<ConfBaseItem>();
		Init1();

	}

	private void Init1()
	{
		allConfBase.Add(new ConfSchoolBuildItem(0, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(1, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(2, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(3, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(4, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(5, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(6, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(7, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
		allConfBase.Add(new ConfSchoolBuildItem(8, new int[]{ -5000, -5000 }, new int[]{ 5000, 5000 }, 1000, 200, 300, 5, 9));
	}

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfSchoolBuildItem);
	}

	public ConfSchoolBuildItem GetItem(int id)
	{
		return GetItemObject<ConfSchoolBuildItem>(id);
	}
	
}
	
