namespace UMAWorld {
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
	public int[] turnCount;				//上山转折数
	public int tile;				//地砖
	public int stairs;				//楼梯
	public int floor;				//地板
	public int mainGate;				//正门
	public int wallGate;				//墙门
	public int wall;				//墙壁
	public int wallCorner;				//墙柱
	public int outHouse;				//外门弟子房
	public int outTree;				//外门树木
	public int flowerbed;				//花盆

	public ConfSchoolBuildItem()
	{
	}

	public ConfSchoolBuildItem(int id, int[] minPos, int[] maxPos, int minDis, int minRadius, int maxRadius, int minVertexCount, int maxVertexCount, int[] turnCount, int tile, int stairs, int floor, int mainGate, int wallGate, int wall, int wallCorner, int outHouse, int outTree, int flowerbed)
	{
		this.id = id;
		this.minPos = minPos;
		this.maxPos = maxPos;
		this.minDis = minDis;
		this.minRadius = minRadius;
		this.maxRadius = maxRadius;
		this.minVertexCount = minVertexCount;
		this.maxVertexCount = maxVertexCount;
		this.turnCount = turnCount;
		this.tile = tile;
		this.stairs = stairs;
		this.floor = floor;
		this.mainGate = mainGate;
		this.wallGate = wallGate;
		this.wall = wall;
		this.wallCorner = wallCorner;
		this.outHouse = outHouse;
		this.outTree = outTree;
		this.flowerbed = flowerbed;
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
		allConfBase.Add(new ConfSchoolBuildItem(0, new int[]{ 0, 1 }, new int[]{ 200, 201 }, 1000, 200, 300, 5, 9, new int[]{ 2, 4 }, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9));
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
	

}