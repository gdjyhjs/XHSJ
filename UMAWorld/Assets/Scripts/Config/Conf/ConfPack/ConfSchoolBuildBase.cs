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
	public int stairsStep;				//楼梯级数
	public int mainGate;				//正门
	public int wallGate;				//墙门
	public int wall;				//墙壁
	public int wallCorner;				//墙柱
	public int outTree;				//外门树木
	public int flowerbed;				//花盆
	public int fence;				//围栏
	public int fenceCorner;				//围栏柱
	public int outHouse;				//外门弟子房
	public int inHouse;				//内门弟子房间
	public int inTrueHouse;				//真传弟子房间
	public int elderHouse;				//长老房间
	public int bigElderHouse;				//大长老房间
	public int mainHouse;				//宗主房间
	public int storeHouse;				//聚宝仙楼
	public int upLevelHouse;				//聚灵阵
	public int taskHouse;				//任务大厅
	public int hospiltalHouse;				//疗伤院
	public int meetingHouse;				//议事大厅
	public int depotHouse;				//建木
	public int bookShopHouse;				//藏经阁
	public int transmitHouse;				//传送阵
	public int[] bamboo;				//竹林
	public int floorColor;				//地板颜色
	public int stairwayColor;				//楼梯颜色
	public int grassColor;				//草地颜色
	public int stoneColor;				//石头颜色

	public ConfSchoolBuildItem()
	{
	}

	public ConfSchoolBuildItem(int id, int[] minPos, int[] maxPos, int minDis, int minRadius, int maxRadius, int minVertexCount, int maxVertexCount, int[] turnCount, int stairsStep, int mainGate, int wallGate, int wall, int wallCorner, int outTree, int flowerbed, int fence, int fenceCorner, int outHouse, int inHouse, int inTrueHouse, int elderHouse, int bigElderHouse, int mainHouse, int storeHouse, int upLevelHouse, int taskHouse, int hospiltalHouse, int meetingHouse, int depotHouse, int bookShopHouse, int transmitHouse, int[] bamboo, int floorColor, int stairwayColor, int grassColor, int stoneColor)
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
		this.stairsStep = stairsStep;
		this.mainGate = mainGate;
		this.wallGate = wallGate;
		this.wall = wall;
		this.wallCorner = wallCorner;
		this.outTree = outTree;
		this.flowerbed = flowerbed;
		this.fence = fence;
		this.fenceCorner = fenceCorner;
		this.outHouse = outHouse;
		this.inHouse = inHouse;
		this.inTrueHouse = inTrueHouse;
		this.elderHouse = elderHouse;
		this.bigElderHouse = bigElderHouse;
		this.mainHouse = mainHouse;
		this.storeHouse = storeHouse;
		this.upLevelHouse = upLevelHouse;
		this.taskHouse = taskHouse;
		this.hospiltalHouse = hospiltalHouse;
		this.meetingHouse = meetingHouse;
		this.depotHouse = depotHouse;
		this.bookShopHouse = bookShopHouse;
		this.transmitHouse = transmitHouse;
		this.bamboo = bamboo;
		this.floorColor = floorColor;
		this.stairwayColor = stairwayColor;
		this.grassColor = grassColor;
		this.stoneColor = stoneColor;
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
		allConfBase.Add(new ConfSchoolBuildItem(0, new int[]{ 0, 1 }, new int[]{ 200, 201 }, 1000, 200, 300, 5, 9, new int[]{ 3, 8 }, 199, 3, 4, 5, 6, 8, 9, 15, 16, 7, 11, 12, 30, 31, 32, 19, 20, 21, 22, 23, 24, 25, 26, new int[]{ 27, 28, 29 }, 1, 2, 3, 6));
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