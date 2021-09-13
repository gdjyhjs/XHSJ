using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = System.Random;

namespace UMAWorld {
    /// <summary>
    /// 建筑基础
    /// </summary>
    public class BuildMono : BuildMonoBase {
        BuildBase buildData;

        public void Init(BuildBase data) {
            buildData = data;

            Random rand = new Random(buildData.seed);
            StartCoroutine(Build(rand));
        }

        private bool yieldWait = true;
        // 创建宗门建筑
        private IEnumerator Build(Random rand) {
            ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(buildData.confId);

            ConfSchoolFloorItem tileConf = g.conf.schoolFloor.GetItem(conf.tile); // 地砖
            GameObject tilePrefab = CommonTools.LoadResources<GameObject>(tileConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem statirsConf = g.conf.schoolFloor.GetItem(conf.stairs); // 楼梯
            GameObject statirsPrefab = CommonTools.LoadResources<GameObject>(statirsConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem floorConf = g.conf.schoolFloor.GetItem(conf.floor); // 地板
            GameObject floorPrefab = CommonTools.LoadResources<GameObject>(floorConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem mainGateConf = g.conf.schoolFloor.GetItem(conf.mainGate); // 山门
            GameObject mainGatePrefab = CommonTools.LoadResources<GameObject>(mainGateConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem wallGateConf = g.conf.schoolFloor.GetItem(conf.wallGate); // 墙门
            GameObject wallGatePrefab = CommonTools.LoadResources<GameObject>(wallGateConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem wallCornerConf = g.conf.schoolFloor.GetItem(conf.wallCorner); // 墙柱
            GameObject wallCornerPrefab = CommonTools.LoadResources<GameObject>(wallCornerConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem wallConf = g.conf.schoolFloor.GetItem(conf.wall); // 墙壁
            GameObject wallPrefab = CommonTools.LoadResources<GameObject>(wallConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem outHouseConf = g.conf.schoolFloor.GetItem(conf.outHouse); // 外门弟子方
            GameObject outHousePrefab = CommonTools.LoadResources<GameObject>(outHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            

            ConfSchoolFloorItem treeConf = g.conf.schoolFloor.GetItem(conf.outTree); // 树木
            GameObject[] treePrefabs = new GameObject[10];
            for (int i = 0; i < 10; i++) {
                treePrefabs[i] = CommonTools.LoadResources<GameObject>(treeConf.prefab + i);
                if (yieldWait)
                    yield return CheckWait();
            }

            ConfSchoolFloorItem flowerbedConf = g.conf.schoolFloor.GetItem(conf.flowerbed); // 花盆
            GameObject flowerbedPrefab = CommonTools.LoadResources<GameObject>(flowerbedConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            
            Vector3 tmpPos;
            GameObject tmpGo;


            // 宗门区域 建筑应该都在区域内
            Vector2[] schoolArea = new Vector2[buildData.points.Length];
            for (int i = 0; i < buildData.points.Length; i++) {
                schoolArea[i] = new Vector2(buildData.points[i].x, buildData.points[i].y);
            }

            #region 楼梯
            // 从大门创建楼梯到外殿
            Vector3 startPoint = CommonTools.GetGroundPoint(buildData.doorPosition + new Point2(0, 1) * mainGateConf.areaLong * 5);
            Transform schoolStartFloor = new GameObject("schoolStartFloor").transform;
            schoolStartFloor.SetParent(transform);
            schoolStartFloor.position = startPoint;

            // 创建大门
            Vector3 mainGatePos = CommonTools.GetGroundPoint(new Vector3(startPoint.x, startPoint.y, startPoint.z - mainGateConf.areaLong));
            float mainGateHeight = float.PositiveInfinity;
            for (int x = 0; x <= 5; x++) {
                for (int z = 0; z <= 3; z++) {
                    Vector3 point = CommonTools.GetGroundPoint(new Vector3(mainGatePos.x - mainGateConf.areaWidth * 0.5f + mainGateConf.areaWidth * x / 5,
                        0, mainGatePos.z - mainGateConf.areaLong * 0.5f + mainGateConf.areaLong * z / 3));
                    if (point.y < mainGateHeight)
                        mainGateHeight = point.y;
                }
            }
            mainGatePos = new Vector3(mainGatePos.x, mainGateHeight, mainGatePos.z);
            TextMesh[] names = GameObject.Instantiate<GameObject>(mainGatePrefab, mainGatePos, Quaternion.identity, schoolStartFloor).transform.Find("Name").GetComponentsInChildren<TextMesh>();
            foreach (var item in names) {
                item.text = buildData.id;
            }
            if (yieldWait)
                yield return (CheckWait());

            // 大门楼梯
            // 转弯数
            int trunCount = rand.Next(conf.turnCount[0], conf.turnCount[1]);
            // 计算楼梯终点（外殿）
            Vector3 statirsEndPoint = CommonTools.GetGroundPoint(buildData.outHallPosition);
            // 楼梯距离
            float statirsDis = statirsEndPoint.z - startPoint.z;
            // 计算外殿终点
            statirsEndPoint = new Vector3(statirsEndPoint.x, statirsEndPoint.y, statirsEndPoint.z);
            CommonTools.Log("起点：" + startPoint + "   终点：" + statirsEndPoint + "   距离：" + statirsDis  + "   转弯数：" + trunCount);

            
            int curTrun = 1;
            Vector3 statirsStartPos = startPoint;
            while (true) {
                if ((statirsStartPos.z - startPoint.z) >( statirsDis / trunCount) * curTrun) {
                    statirsStartPos += new Vector3(0, 0, tileConf.areaLong / 2);

                    GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.identity, schoolStartFloor);
                    Vector3 dir3D;
                    Vector2 dir2D;
                    if (statirsStartPos.x < statirsEndPoint.x) {
                        // 往右
                        dir3D = Vector3.right * tileConf.areaWidth;
                        dir2D = Vector2.right * tileConf.areaWidth;
                    } else {
                        // 往左
                        dir3D = Vector3.left * tileConf.areaWidth;
                        dir2D = Vector2.left * tileConf.areaWidth;
                    }

                    // 获取横向楼梯创建的终点
                    Vector2 endPoint;
                    if (trunCount <= 1) {
                        endPoint = new Vector2(statirsEndPoint.x, statirsStartPos.z+ rand.Next(-10, 10));
                    } else {
                        MathTools.LineSegmentCross(new Vector2(statirsStartPos.x, statirsStartPos.z), new Vector2(statirsStartPos.x, statirsStartPos.z) + dir2D * 1000, schoolArea, out endPoint);
                    }
                    endPoint += (new Vector2(statirsStartPos.x, endPoint.y) - endPoint) * 0.6f;


                    if (statirsStartPos.x < endPoint.x) {
                        // 往右
                        for (float i = statirsStartPos.x; i < endPoint.x; i += statirsConf.areaLong) {
                            statirsStartPos += new Vector3(statirsConf.areaLong, 0, 0);
                            tmpPos = new Vector3(statirsStartPos.x + statirsConf.areaLong * 0.5f, statirsStartPos.y, statirsStartPos.z);
                            Transform statirs = GameObject.Instantiate<GameObject>(statirsPrefab, tmpPos, Quaternion.AngleAxis(-90, Vector3.up), schoolStartFloor).transform;
                            statirs.localScale = new Vector3(rand.Next(0, 100) < 50 ? 1 : -1, 1, 1);
                            statirsStartPos += new Vector3(0, statirsConf.areaHeight, 0);
                            if (yieldWait)
                                yield return (CheckWait());
                        }
                        statirsStartPos += Vector3.right * tileConf.areaWidth;
                    } else {
                        // 往左
                        for (float i = statirsStartPos.x; i > endPoint.x; i -= statirsConf.areaLong) {
                            statirsStartPos -= new Vector3(statirsConf.areaLong, 0, 0);
                            tmpPos = new Vector3(statirsStartPos.x - statirsConf.areaLong * 0.5f, statirsStartPos.y, statirsStartPos.z);
                            Transform statirs = GameObject.Instantiate<GameObject>(statirsPrefab, tmpPos, Quaternion.AngleAxis(90, Vector3.up), schoolStartFloor).transform;
                            statirs.localScale = new Vector3(rand.Next(0, 100) < 50 ? 1 : -1, 1, 1);
                            statirsStartPos += new Vector3(0, statirsConf.areaHeight, 0);
                            if (yieldWait)
                                yield return (CheckWait());
                        }
                        statirsStartPos += Vector3.left * tileConf.areaWidth;
                    }
                    GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.identity, schoolStartFloor);
                    // 调整位置
                    statirsStartPos += Vector3.forward * tileConf.areaLong * 0.5f;
                    curTrun++;
                } else if (statirsStartPos.z < statirsEndPoint.z) {
                    Transform statirs = GameObject.Instantiate<GameObject>(statirsPrefab, statirsStartPos, Quaternion.AngleAxis(180, Vector3.up), schoolStartFloor).transform;
                    statirs.localScale = new Vector3(rand.Next(0, 100) < 50 ? 1 : -1, 1, 1);
                    statirsStartPos += new Vector3(0, statirsConf.areaHeight, statirsConf.areaLong);
                } else {
                    break;
                }
                if (yieldWait)
                    yield return (CheckWait());
            }
            int intoCount = rand.Next(3, 6);
            for (int i = 0; i < intoCount; i++) {
                GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.identity, schoolStartFloor);
                statirsStartPos += new Vector3(0, 0, tileConf.areaLong);
                if (yieldWait)
                    yield return (CheckWait());
            }
            #endregion



            #region 外殿
            // 创建外殿
            Vector3 outStartPoint = statirsStartPos + Vector3.back * tileConf.areaLong * 0.5f; // 外殿开始位置
            Transform outFloor = new GameObject("outFloor").transform;
            outFloor.SetParent(transform);
            outFloor.position = outStartPoint;

            Vector3 centerPoint = CommonTools.GetGroundPoint(buildData.position); // 中心广场位置
            Vector3 outEndPoint = statirsStartPos + Vector3.forward * ((centerPoint.z - startPoint.z) * rand.Next(35, 45) * 0.01f); // 外殿结束位置

            // 计算外殿区域
            Vector2 outAreaLeftDown, outAreaLeftUp, outAreaRightDown, outAreaRightUp;
            MathTools.LineSegmentCross(new Vector2(outStartPoint.x - 1000, outStartPoint.z), new Vector2(outStartPoint.x, outStartPoint.z), schoolArea, out outAreaLeftDown);
            MathTools.LineSegmentCross(new Vector2(outStartPoint.x, outStartPoint.z), new Vector2(outStartPoint.x + 1000, outStartPoint.z), schoolArea, out outAreaRightDown);
            MathTools.LineSegmentCross(new Vector2(outEndPoint.x - 1000, outEndPoint.z), new Vector2(outEndPoint.x, outEndPoint.z), schoolArea, out outAreaLeftUp);
            MathTools.LineSegmentCross(new Vector2(outEndPoint.x, outEndPoint.z), new Vector2(outEndPoint.x + 1000, outEndPoint.z), schoolArea, out outAreaRightUp);

            Vector2 outAreaStart = new Vector2(Mathf.Max(outAreaLeftDown.x, outAreaLeftUp.x), outAreaLeftDown.y);
            Vector2 outAreaEnd = new Vector2(Mathf.Min(outAreaRightDown.x, outAreaRightUp.x), outAreaRightUp.y);

            Vector2 outFloorStart = new Vector2(outAreaStart.x + floorConf.areaWidth * 2.5f, outAreaStart.y);
            Vector2 outFloorEnd = outAreaEnd;
            // 创建外殿地板
            for (float i = outAreaStart.x + floorConf.areaWidth * 3; i < outAreaEnd.x - floorConf.areaWidth * 3; i += floorConf.areaWidth) {
                for (float j = outAreaStart.y + floorConf.areaLong * 0.5f; j < outAreaEnd.y; j += floorConf.areaLong) {
                    tmpPos = new Vector3(i, outStartPoint.y, j);
                    GameObject.Instantiate<GameObject>(floorPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outFloor);
                    outEndPoint = new Vector3(outStartPoint.x, outStartPoint.y, tmpPos.z + floorConf.areaLong * 0.5f);
                    outFloorEnd = new Vector2(tmpPos.x + floorConf.areaWidth * 0.5f, tmpPos.z + floorConf.areaLong * 0.5f);
                    if (yieldWait)
                        yield return (CheckWait());
                }
            }
            #endregion
            #region 中殿
            int outStatirsCount = 5; // 楼梯层数
            // 创建中殿
            Vector3 centerStartPoint = new Vector3(outEndPoint.x, outEndPoint.y + statirsConf.areaHeight * outStatirsCount, outEndPoint.z + statirsConf.areaLong * outStatirsCount);
            Vector3 innerPoint = CommonTools.GetGroundPoint(buildData.innerHallPosition); // 内殿位置
            Transform centerFloor = new GameObject("centerFloor").transform;
            centerFloor.SetParent(transform);
            centerFloor.position = centerStartPoint;
            Vector3 centerEndPoint = centerStartPoint + Vector3.forward * ((innerPoint.z - centerStartPoint.z) * rand.Next(70, 90) * 0.01f); // 中殿结束位置

            // 计算中殿区域
            Vector2 centerAreaLeftDown, centerAreaLeftUp, centerAreaRightDown, centerAreaRightUp;
            MathTools.LineSegmentCross(new Vector2(centerStartPoint.x - 1000, centerStartPoint.z), new Vector2(centerStartPoint.x, centerStartPoint.z), schoolArea, out centerAreaLeftDown);
            MathTools.LineSegmentCross(new Vector2(centerStartPoint.x, centerStartPoint.z), new Vector2(centerStartPoint.x + 1000, centerStartPoint.z), schoolArea, out centerAreaRightDown);
            MathTools.LineSegmentCross(new Vector2(centerEndPoint.x - 1000, centerEndPoint.z), new Vector2(centerEndPoint.x, centerEndPoint.z), schoolArea, out centerAreaLeftUp);
            MathTools.LineSegmentCross(new Vector2(centerEndPoint.x, centerEndPoint.z), new Vector2(centerEndPoint.x + 1000, centerEndPoint.z), schoolArea, out centerAreaRightUp);

            Vector2 centerAreaStart = new Vector2(Mathf.Max(centerAreaLeftDown.x, centerAreaLeftUp.x), centerAreaLeftDown.y);
            Vector2 centerAreaEnd = new Vector2(Mathf.Min(centerAreaRightDown.x, centerAreaRightUp.x), centerAreaRightUp.y);


            // 创建外殿通往中殿楼梯
            float outStatirsX = centerAreaStart.x + (centerAreaEnd.x - centerAreaStart.x) * 0.5f;
            for (int i = 0; i < outStatirsCount + 2; i++) {
                for (int j = 0; j < outStatirsCount; j++) {
                    tmpPos = new Vector3(outStatirsX + (i - (outStatirsCount + 2) * 0.5f) * statirsConf.areaWidth, outEndPoint.y + j * statirsConf.areaHeight, outEndPoint.z + j * statirsConf.areaLong);
                    Transform statirs = GameObject.Instantiate<GameObject>(statirsPrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), centerFloor).transform;
                    statirs.localScale = new Vector3(i % 2 == 0 ? 1 : -1, 1, 1);
                    if (yieldWait)
                        yield return CheckWait();
                }
            }

            // 创建中殿地板
            for (float i = centerAreaStart.x + floorConf.areaWidth * 3; i < centerAreaEnd.x - floorConf.areaWidth * 3; i += floorConf.areaWidth) {
                for (float j = centerAreaStart.y + floorConf.areaLong * 0.5f; j < centerAreaEnd.y; j += floorConf.areaLong) {
                    tmpPos = new Vector3(i, centerStartPoint.y, j);
                    GameObject.Instantiate<GameObject>(floorPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerFloor);
                    centerEndPoint = new Vector3(centerStartPoint.x, centerStartPoint.y, tmpPos.z + floorConf.areaLong * 0.5f);
                    if (yieldWait)
                        yield return CheckWait();
                }
            }
            #endregion



            #region 内殿
            int centerStatirsCount = 7;
            // 创建内殿
            Vector3 innerStartPoint = new Vector3(centerEndPoint.x, centerEndPoint.y + statirsConf.areaHeight * centerStatirsCount, centerEndPoint.z + statirsConf.areaLong * centerStatirsCount);
            Transform innerFloor = new GameObject("innerFloor").transform;
            innerFloor.SetParent(transform);
            innerFloor.position = innerStartPoint;

            Vector3 forbiddenPoint = CommonTools.GetGroundPoint(buildData.forbiddenPosition); // 禁地位置
            Vector3 innerEndPoint = innerStartPoint + Vector3.forward * (forbiddenPoint.z - innerStartPoint.z); // 内殿结束位置

            // 计算内殿区域
            Vector2 innerAreaLeftDown, innerAreaLeftUp, innerAreaRightDown, innerAreaRightUp;
            MathTools.LineSegmentCross(new Vector2(innerStartPoint.x - 1000, innerStartPoint.z), new Vector2(innerStartPoint.x, innerStartPoint.z), schoolArea, out innerAreaLeftDown);
            MathTools.LineSegmentCross(new Vector2(innerStartPoint.x, innerStartPoint.z), new Vector2(innerStartPoint.x + 1000, innerStartPoint.z), schoolArea, out innerAreaRightDown);
            MathTools.LineSegmentCross(new Vector2(innerEndPoint.x - 1000, innerEndPoint.z), new Vector2(innerEndPoint.x, innerEndPoint.z), schoolArea, out innerAreaLeftUp);
            MathTools.LineSegmentCross(new Vector2(innerEndPoint.x, innerEndPoint.z), new Vector2(innerEndPoint.x + 1000, innerEndPoint.z), schoolArea, out innerAreaRightUp);

            Vector2 innerAreaStart = new Vector2(Mathf.Max(innerAreaLeftDown.x, innerAreaLeftUp.x), innerAreaLeftDown.y);
            Vector2 innerAreaEnd = new Vector2(Mathf.Min(innerAreaRightDown.x, innerAreaRightUp.x), innerAreaRightUp.y);

            // 创建中殿通往内殿楼梯
            float centerStatirsX = innerAreaStart.x + (innerAreaEnd.x - innerAreaStart.x) * 0.5f;
            for (int i = 0; i < centerStatirsCount + 2; i++) {
                for (int j = 0; j < centerStatirsCount; j++) {
                    tmpPos = new Vector3(centerStatirsX + (i - (centerStatirsCount + 2) * 0.5f) * statirsConf.areaWidth, centerEndPoint.y + j * statirsConf.areaHeight, centerEndPoint.z + j * statirsConf.areaLong);
                    Transform statirs = GameObject.Instantiate<GameObject>(statirsPrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), innerFloor).transform;
                    statirs.localScale = new Vector3(i % 2 == 0 ? 1 : -1, 1, 1);
                    if (yieldWait)
                        yield return (CheckWait());
                }
            }

            // 创建内殿地板
            for (float i = innerAreaStart.x + floorConf.areaWidth * 3; i < innerAreaEnd.x - floorConf.areaWidth * 3; i += floorConf.areaWidth) {
                for (float j = innerAreaStart.y + floorConf.areaLong * 0.5f; j < innerAreaEnd.y; j += floorConf.areaLong) {
                    tmpPos = new Vector3(i, innerStartPoint.y, j);
                    GameObject.Instantiate<GameObject>(floorPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), innerFloor);
                    if (yieldWait)
                        yield return (CheckWait());
                }
            }
            #endregion



            


            // 构建墙壁

            //// Debug Draw Line 外殿区域
            //var bbb = outFloor.gameObject.AddComponent<LineRenderer>();
            //bbb.material = CommonTools.LoadResources<Material>("Material/StandardBlue");
            //bbb.positionCount = 5;
            //bbb.SetPositions(new Vector3[]{
            //    new Vector3(outFloorStart.x, outStartPoint.y + 1, outFloorStart.y),
            //    new Vector3(outFloorStart.x, outStartPoint.y + 1, outFloorEnd.y),
            //    new Vector3(outFloorEnd.x, outStartPoint.y + 1, outFloorEnd.y),
            //    new Vector3(outFloorEnd.x, outStartPoint.y + 1, outFloorStart.y),
            //    new Vector3(outFloorStart.x, outStartPoint.y + 1, outFloorStart.y),
            //});

            // 计算外殿空地
            Vector2 outSpaceStart = new Vector2(Mathf.Min(outStartPoint.x, outStatirsX - (outStatirsCount + 2) * 0.5f * statirsConf.areaWidth), outFloorStart.y);
            Vector2 outSpaceEnd = new Vector2(Mathf.Max(outStartPoint.x, outStatirsX + (outStatirsCount + 2) * 0.5f * statirsConf.areaWidth), outEndPoint.z);
            float spaceOffset = wallConf.areaWidth * 1.5f;
            if (Mathf.Abs(outSpaceStart.x - outSpaceEnd.x) < Mathf.Abs(outSpaceStart.x - outSpaceEnd.x)) {
                spaceOffset += Mathf.Abs(Mathf.Abs(outSpaceStart.x - outSpaceEnd.x) - Mathf.Abs(outSpaceStart.x - outSpaceEnd.x)) * 0.5f;
            }
            outSpaceStart += new Vector2(outSpaceStart.x - outSpaceEnd.x, 0).normalized * spaceOffset;
            outSpaceEnd += new Vector2(outSpaceEnd.x - outSpaceStart.x, 0).normalized * spaceOffset;



            //// Debug Draw Line  外殿中央
            //var test = new GameObject("test").transform;
            //test.SetParent(transform);
            //var ccc = test.gameObject.AddComponent<LineRenderer>();
            //ccc.positionCount = 5;
            //ccc.SetPositions(new Vector3[]{
            //    new Vector3(outSpaceStart.x, outStartPoint.y + 2, outSpaceStart.y),
            //    new Vector3(outSpaceStart.x, outStartPoint.y + 2, outSpaceEnd.y),
            //    new Vector3(outSpaceEnd.x, outStartPoint.y + 2, outSpaceEnd.y),
            //    new Vector3(outSpaceEnd.x, outStartPoint.y + 2, outSpaceStart.y),
            //    new Vector3(outSpaceStart.x, outStartPoint.y + 2, outSpaceStart.y),
            //});


            #region 外殿左 围墙
            Vector2 outLeftStart = new Vector2(outFloorStart.x + wallCornerConf.areaWidth, outFloorStart.y + wallCornerConf.areaWidth);
            Vector2 outLeftEnd = new Vector2(outSpaceStart.x, outSpaceEnd.y - wallCornerConf.areaWidth);
            int hCount = Mathf.CeilToInt((outLeftEnd.x - outLeftStart.x) / wallConf.areaWidth); // 水平数量
            int vCount = Mathf.CeilToInt((outLeftEnd.y - outLeftStart.y) / wallConf.areaWidth); // 垂直数量
            if (vCount % 2 == 0)
                vCount++;

            Transform outLeftWall = new GameObject("outLeftWall").transform;
            outLeftWall.SetParent(transform);
            outLeftWall.position = new Vector3(outLeftStart.x, outFloorStart.y, outLeftStart.y);

            //// Debug Draw Line 外殿左侧
            //var aaa = outLeftWall.gameObject.AddComponent<LineRenderer>();
            //aaa.material = CommonTools.LoadResources<Material>("Material/StandardYellow");
            //aaa.positionCount = 5;
            //aaa.SetPositions(new Vector3[]{
            //    new Vector3(outLeftStart.x, outStartPoint.y + 10, outLeftStart.y),
            //    new Vector3(outLeftStart.x, outStartPoint.y + 10, outLeftEnd.y),
            //    new Vector3(outLeftEnd.x, outStartPoint.y + 10, outLeftEnd.y),
            //    new Vector3(outLeftEnd.x, outStartPoint.y + 10, outLeftStart.y),
            //    new Vector3(outLeftStart.x, outStartPoint.y + 10, outLeftStart.y),
            //});

            float outLeftWallWidthDis = (outLeftEnd.x - outLeftStart.x) / (hCount - 1);
            float outLeftWallWidthScale = outLeftWallWidthDis / wallConf.areaWidth;
            for (int i = 0; i < hCount; i++) {
                tmpPos = new Vector3(outLeftStart.x + outLeftWallWidthDis * i, outStartPoint.y, outLeftStart.y);
                GameObject.Instantiate<GameObject>(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall);
                if (i > 0) {
                    tmpPos.x -= outLeftWallWidthDis * 0.5f;
                    tmpGo = GameObject.Instantiate<GameObject>(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outLeftWall);
                    tmpGo.transform.localScale = new Vector3(outLeftWallWidthScale, 1, 1);
                }

                tmpPos = new Vector3(outLeftStart.x + outLeftWallWidthDis * i, outStartPoint.y, outLeftEnd.y);
                GameObject.Instantiate<GameObject>(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall);
                if (i > 0) {
                    tmpPos.x -= outLeftWallWidthDis * 0.5f;
                    tmpGo = GameObject.Instantiate<GameObject>(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outLeftWall);
                    tmpGo.transform.localScale = new Vector3(outLeftWallWidthScale, 1, 1);
                }
            }

            float outLeftWallHeightDis = (outLeftEnd.y - outLeftStart.y) / (vCount - 1);
            float outLeftWallHeightScale = outLeftWallHeightDis / wallConf.areaWidth;
            for (int i = 1; i < vCount - 1; i++) {
                tmpPos = new Vector3(outLeftStart.x, outStartPoint.y, outLeftStart.y + outLeftWallHeightDis * i);
                GameObject.Instantiate<GameObject>(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall);
                if (i == 1) {
                    tmpPos.z -= outLeftWallHeightDis * 0.5f;
                    tmpGo = GameObject.Instantiate<GameObject>(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall);
                    tmpGo.transform.localScale = new Vector3(outLeftWallWidthScale, 1, 1);
                    tmpPos.z += outLeftWallHeightDis * 0.5f;
                }
                tmpPos.z += outLeftWallHeightDis * 0.5f;
                tmpGo = GameObject.Instantiate<GameObject>(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall);
                tmpGo.transform.localScale = new Vector3(outLeftWallWidthScale, 1, 1);


                tmpPos = new Vector3(outLeftEnd.x, outStartPoint.y, outLeftStart.y + outLeftWallHeightDis * i);
                if (i == vCount / 2 || (i + 1) == vCount / 2) {
                    if (i == vCount / 2) {
                        tmpGo = GameObject.Instantiate<GameObject>(wallGatePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall);
                        float scale = outLeftWallHeightDis * 2 / wallGateConf.areaWidth;
                        tmpGo.transform.localScale = new Vector3(scale, 1, 1);
                    } else {
                        GameObject.Instantiate<GameObject>(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall);
                    }
                } else {
                    GameObject.Instantiate<GameObject>(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall);
                    if (i == 1) {
                        tmpPos.z -= outLeftWallHeightDis * 0.5f;
                        tmpGo = GameObject.Instantiate<GameObject>(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall);
                        tmpGo.transform.localScale = new Vector3(outLeftWallWidthScale, 1, 1);
                        tmpPos.z += outLeftWallHeightDis * 0.5f;
                    }
                    tmpPos.z += outLeftWallHeightDis * 0.5f;
                    tmpGo = GameObject.Instantiate<GameObject>(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall);
                    tmpGo.transform.localScale = new Vector3(outLeftWallWidthScale, 1, 1);
                }
            }



            #endregion

            #region 外殿左 房子，树木
            Transform outLeftHouse = new GameObject("outLeftHouse").transform;
            outLeftHouse.SetParent(transform);
            outLeftHouse.position = new Vector3(outLeftStart.x, outFloorStart.y, outLeftStart.y);

            float outTreeY1 = outLeftEnd.y - wallCornerConf.areaWidth - flowerbedConf.areaWidth * 1.5f;
            float outTreeY2 = outLeftStart.y + wallCornerConf.areaWidth + flowerbedConf.areaWidth * 1.5f;
            float outHouseY = outLeftEnd.y - wallCornerConf.areaWidth - outHouseConf.areaLong * 0.5f;
            for (float i = outLeftStart.x; i < outLeftEnd.x;) {
                // 创建树木
                float x = i + wallCornerConf.areaWidth + flowerbedConf.areaWidth * 1.5f;
                i = x + flowerbedConf.areaWidth * 0.5f;
                if (i > outLeftEnd.x)
                    break;
                // 花盆1
                tmpPos = new Vector3(x, outStartPoint.y, outTreeY1);
                GameObject flowerbed1 = Instantiate<GameObject>(flowerbedPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftHouse);
                if (yieldWait)
                    yield return (CheckWait());

                // 树1
                tmpPos = tmpPos + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                GameObject tree1 = Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftWall);
                if (yieldWait)
                    yield return (CheckWait());

                // 花盆2
                tmpPos = new Vector3(x, outStartPoint.y, outTreeY2);
                GameObject flowerbed2 = Instantiate<GameObject>(flowerbedPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftHouse);
                if (yieldWait)
                    yield return (CheckWait());

                // 树2
                tmpPos = tmpPos + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                GameObject tree2 = Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftWall);
                if (yieldWait)
                    yield return (CheckWait());

                // 创建房屋
                x += flowerbedConf.areaWidth * 1.5f + outHouseConf.areaWidth * 0.5f;
                i = x + outHouseConf.areaWidth * 0.5f;
                if (i > outLeftEnd.x)
                    break;
                tmpPos = new Vector3(x, outStartPoint.y, outHouseY);
                GameObject house = Instantiate<GameObject>(outHousePrefab, tmpPos, Quaternion.identity, outLeftHouse);

                if (yieldWait)
                    yield return (CheckWait());
            }
            #endregion



        }

        private GameObject Instantiate(GameObject prefab, Vector3 pos, Quaternion q, Transform parent) {
            return GameObject.Instantiate<GameObject>(prefab, pos, q, parent);
        }
    }
}