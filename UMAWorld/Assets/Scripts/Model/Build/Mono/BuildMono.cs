using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = System.Random;

namespace UMAWorld {
    /// <summary>
    /// 建筑基础
    /// </summary>
    public class BuildMono : MonoBehaviour {
        BuildBase buildData;

        public void Init(BuildBase data) {
            buildData = data;

            Random rand = new Random(buildData.seed);
            BuildObject(rand);
        }

        // 创建宗门建筑
        private void BuildObject(Random rand) {
           StartCoroutine( BuildDoor1(rand));
        }

        private IEnumerator BuildDoor1(Random rand) {
            ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(buildData.confId);
            ConfSchoolFloorItem tileConf = g.conf.schoolFloor.GetItem(conf.tile); // 地砖
            ConfSchoolFloorItem statirsConf = g.conf.schoolFloor.GetItem(conf.stairs); // 楼梯
            ConfSchoolFloorItem floorConf = g.conf.schoolFloor.GetItem(conf.floor); // 地板
            ConfSchoolFloorItem mainGateConf = g.conf.schoolFloor.GetItem(conf.mainGate); // 山门
            GameObject tilePrefab = CommonTools.LoadResources<GameObject>(tileConf.prefab);
            GameObject statirsPrefab = CommonTools.LoadResources<GameObject>(statirsConf.prefab);
            GameObject floorPrefab = CommonTools.LoadResources<GameObject>(floorConf.prefab);
            GameObject mainGatePrefab = CommonTools.LoadResources<GameObject>(mainGateConf.prefab);


            // 从大门创建楼梯到外殿
            Vector3 startPoint = CommonTools.GetGroundPoint(buildData.doorPosition + new Point2(0, 1) * mainGateConf.areaLong * 5);

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
            TextMesh[] names = GameObject.Instantiate<GameObject>(mainGatePrefab, mainGatePos, Quaternion.identity, transform).transform.Find("Name").GetComponentsInChildren<TextMesh>();
            foreach (var item in names) {
                item.text = buildData.id;
            }
            yield return 0;

            // 转弯数
            int trunCount = rand.Next(conf.turnCount[0], conf.turnCount[1] + 1);
            // 计算楼梯终点（外殿）
            Vector3 statirsEndPoint = CommonTools.GetGroundPoint(buildData.outHallPosition);
            // 楼梯距离
            float statirsDis = statirsEndPoint.z - startPoint.z;
            // 计算外殿高度
            float statirsEndHeight = (Mathf.Ceil(statirsDis / (statirsConf.areaLong)) + 5 + trunCount) * (statirsConf.areaHeight);
            statirsEndPoint = new Vector3(statirsEndPoint.x, startPoint.y + statirsEndHeight, statirsEndPoint.z);
            // 高度
            float statirsHeight = statirsEndPoint.y - startPoint.y;
            // 偏移
            float statirsOffset = startPoint.x - statirsEndPoint.x;
            CommonTools.Log("起点：" + startPoint + "   终点：" + statirsEndPoint + "   距离：" + statirsDis + "   高度：" + statirsHeight + "   偏移：" + statirsOffset + "   转弯数：" + trunCount);


            Vector3 statirsStartPos = startPoint;
            int onTrun = 0; // 正在转弯
            while (true) {
                if (statirsStartPos.y - startPoint.y > statirsHeight / (trunCount + 1) && startPoint.x - statirsStartPos.x < statirsOffset / (trunCount + 1)) {
                    Debug.Log((statirsStartPos.y - startPoint.y) + " > " + (statirsHeight / (trunCount + 1)) + "  >>>  " + (startPoint.x - statirsStartPos.x) + " < " + (statirsOffset / (trunCount + 1)));
                    if (onTrun == 0) {
                        statirsStartPos += new Vector3(0, 0, tileConf.areaLong / 2);
                    }
                    GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up), transform);
                    statirsStartPos += new Vector3(tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, 0);
                    onTrun ++;
                } else if (statirsStartPos.y < startPoint.y + statirsHeight) {
                    if (onTrun > 0) {
                        statirsStartPos += new Vector3(-tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, tileConf.areaLong / 2);
                        trunCount--;
                    }
                    GameObject.Instantiate<GameObject>(statirsPrefab, statirsStartPos, Quaternion.AngleAxis(180, Vector3.up), transform);
                    statirsStartPos += new Vector3(0, statirsConf.areaHeight, statirsConf.areaLong);
                    onTrun = 0;
                } else if (statirsStartPos.z < startPoint.z + statirsDis) {
                    if (onTrun > 0) {
                        statirsStartPos += new Vector3(-tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, tileConf.areaLong / 2);
                        trunCount--;
                    }
                    GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up), transform);
                    statirsStartPos += new Vector3(0, 0, tileConf.areaLong);
                    onTrun = 0;
                } else {
                    break;
                }
                yield return 0;
            }
            int intoCount = rand.Next(3, 6);
            for (int i = 0; i < intoCount; i++) {
                if (onTrun > 0) {
                    statirsStartPos += new Vector3(-tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, tileConf.areaLong / 2);
                    trunCount--;
                }
                GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up), transform);
                statirsStartPos += new Vector3(0, 0, tileConf.areaLong);
                onTrun = 0;
                yield return 0;
            }

            Vector3 outStartPoint = statirsStartPos; // 外殿开始位置
            Vector3 centerPoint = CommonTools.GetGroundPoint(buildData.position); // 中心广场位置
            Vector3 outEndPoint = statirsStartPos + Vector3.forward * ((centerPoint.z - startPoint.z) * rand.Next(35, 45) * 0.01f); // 外殿结束位置

            Vector2[] schoolArea = new Vector2[buildData.points.Length];
            for (int i = 0; i < buildData.points.Length; i++) {
                schoolArea[i] = new Vector2(buildData.points[i].x, buildData.points[i].y);
            }
            // 计算外殿区域
            Vector2 outAreaLeftDown, outAreaLeftUp, outAreaRightDown, outAreaRightUp;
            MathTools.LineSegmentCross(new Vector2(outStartPoint.x - 1000, outStartPoint.z), new Vector2(outStartPoint.x, outStartPoint.z), schoolArea, out outAreaLeftDown);
            MathTools.LineSegmentCross(new Vector2(outStartPoint.x, outStartPoint.z), new Vector2(outStartPoint.x + 1000, outStartPoint.z), schoolArea, out outAreaRightDown);
            MathTools.LineSegmentCross(new Vector2(outEndPoint.x - 1000, outEndPoint.z), new Vector2(outEndPoint.x, outEndPoint.z), schoolArea, out outAreaLeftUp);
            MathTools.LineSegmentCross(new Vector2(outEndPoint.x, outEndPoint.z), new Vector2(outEndPoint.x + 1000, outEndPoint.z), schoolArea, out outAreaRightUp);
            Debug.Log(outAreaLeftDown + " , " + outAreaLeftUp + " , " + outAreaRightDown + " , " + outAreaRightUp);
            Vector2 ourAreaStart = new Vector2(Mathf.Max(outAreaLeftDown.x, outAreaLeftUp.x), outAreaLeftDown.y);
            Vector2 ourAreaEnd = new Vector2(Mathf.Min(outAreaRightDown.x, outAreaRightUp.x), outAreaRightUp.y);
            Debug.Log(ourAreaStart + " >> " + ourAreaEnd);
            // 创建外殿地板
            for (float i = ourAreaStart.x + floorConf.areaWidth * 3; i < ourAreaEnd.x - floorConf.areaWidth * 3; i += floorConf.areaWidth) {
                for (float j = ourAreaStart.y; j < ourAreaEnd.y; j += floorConf.areaLong) {
                    Vector3 pos = new Vector3(i, outStartPoint.y, j);
                    GameObject.Instantiate<GameObject>(floorPrefab, pos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up), transform);
                    yield return 0;
                }
            }

        }
    }
}