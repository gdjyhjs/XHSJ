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
            Vector3 startPoint = CommonTools.GetGroundPoint(buildData.doorPosition);

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
            TextMesh[] names =GameObject.Instantiate<GameObject>(mainGatePrefab, mainGatePos, Quaternion.identity).transform.Find("Name").GetComponentsInChildren<TextMesh>();
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
            bool onTrun = false; // 正在转弯
            while (true) {
                if (statirsStartPos.y - startPoint.y > statirsHeight / (trunCount + 1) && startPoint.x - statirsStartPos.x < statirsOffset / (trunCount + 1)) {
                    Debug.Log((statirsStartPos.y - startPoint.y)+" > "+(statirsHeight / (trunCount + 1))+"  >>>  "+(startPoint.x - statirsStartPos.x) + " < "+(statirsOffset / (trunCount + 1)));
                    if (!onTrun) {
                        statirsStartPos += new Vector3(0, 0, tileConf.areaLong / 2);
                    }
                    GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up));
                    statirsStartPos += new Vector3(tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, 0);
                    onTrun = true;
                }
                else if (statirsStartPos.y < startPoint.y + statirsHeight) {
                    if (onTrun) {
                        statirsStartPos += new Vector3(-tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, tileConf.areaLong / 2);
                        trunCount--;
                    }
                    GameObject.Instantiate<GameObject>(statirsPrefab, statirsStartPos, Quaternion.AngleAxis(180, Vector3.up));
                    statirsStartPos += new Vector3(0, statirsConf.areaHeight, statirsConf.areaLong);
                    onTrun = false;
                } else if (statirsStartPos.z < startPoint.z + statirsDis) {
                    if (onTrun) {
                        statirsStartPos += new Vector3(-tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, tileConf.areaLong / 2);
                        trunCount--;
                    }
                    GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up));
                    statirsStartPos += new Vector3(0, 0, tileConf.areaLong);
                    onTrun = false;
                } else {
                    break;
                }
                yield return 0;
            }
            int intoCount = rand.Next(3, 6);
            for (int i = 0; i < intoCount; i++) {
                if (onTrun) {
                    statirsStartPos += new Vector3(-tileConf.areaWidth * (statirsOffset > 0 ? -1 : 1), 0, tileConf.areaLong / 2);
                    trunCount--;
                }
                GameObject.Instantiate<GameObject>(tilePrefab, statirsStartPos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up));
                statirsStartPos += new Vector3(0, 0, tileConf.areaLong);
                onTrun = false;
            }

            Vector3 outStartPoint = statirsStartPos;
            Vector3 centerPoint = CommonTools.GetGroundPoint(buildData.position); // 中心广场位置
            Vector3 forbiddenPoint = CommonTools.GetGroundPoint(buildData.forbiddenPosition); // 禁地位置
            // 计算外殿大小
            Vector2 outSize = new Vector2((forbiddenPoint.z - startPoint.z) * rand.Next(80, 100) * 0.01f, (forbiddenPoint.z - startPoint.z) * rand.Next(60, 80) * 0.01f);

            // 创建外殿地板





        }
    }
}