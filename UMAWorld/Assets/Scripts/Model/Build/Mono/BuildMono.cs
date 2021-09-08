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
            // 从大门创建楼梯到外殿
            Vector3 startPoint = CommonTools.GetGroundPoint(buildData.doorPosition);
            Vector3 endPoint = CommonTools.GetGroundPoint(buildData.outHallPosition) + Vector3.up * rand.Next(conf.height[1], conf.height[1]);
            // 高度
            float height = endPoint.y - startPoint.y;
            // 距离
            float dis = endPoint.z - startPoint.z;
            // 偏移
            float offset = startPoint.x - endPoint.x;
            // 转弯数
            int trunCount = rand.Next(conf.turnCount[0], conf.turnCount[1] + 1);


            ConfSchoolFloorItem floor0 = g.conf.schoolFloor.GetItem(0); // 地板
            ConfSchoolFloorItem floor1 = g.conf.schoolFloor.GetItem(1); // 楼梯
            GameObject floorPrefab0 = CommonTools.LoadResources<GameObject>(floor0.prefab);
            GameObject floorPrefab1 = CommonTools.LoadResources<GameObject>(floor1.prefab);

            // 测试起点终点
            GameObject.Instantiate<GameObject>(floorPrefab0, startPoint, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up)).name = "起点";
            GameObject.Instantiate<GameObject>(floorPrefab0, endPoint, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up)).name = "终点";

            Debug.Log("startPoint = " + startPoint + "      endPoint=" + endPoint);
            Debug.Log("高度 = " + height + "      距离=" + dis + "      偏移=" + dis + "      转弯=" + trunCount);

            Vector3 pos = startPoint;
            bool onTrun = false; // 正在转弯
            while (true) {
                if (pos.y - startPoint.y > height / (trunCount + 1) && startPoint.x - pos.x < offset / (trunCount + 1)) {
                    Debug.Log((pos.y - startPoint.y)+" > "+(height / (trunCount + 1))+"  >>>  "+(startPoint.x - pos.x) + " < "+(offset / (trunCount + 1)));
                    if (!onTrun) {
                        pos += new Vector3(0, 0, floor0.areaLong / 100f / 2);
                    }
                    Debug.Log("创建转弯地板 " + pos);
                    GameObject.Instantiate<GameObject>(floorPrefab0, pos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up));
                    pos += new Vector3(floor0.areaWidth / 100f * (offset > 0 ? -1 : 1), 0, 0);
                    onTrun = true;
                }
                else if (pos.y < startPoint.y + height) {
                    if (onTrun) {
                        pos += new Vector3(-floor0.areaWidth / 100f * (offset > 0 ? -1 : 1), 0, floor0.areaLong / 100f / 2);
                        trunCount--;
                    }
                    Debug.Log("创建楼梯 " + pos);
                    GameObject.Instantiate<GameObject>(floorPrefab1, pos, Quaternion.AngleAxis(180, Vector3.up));
                    pos += new Vector3(0, floor1.areaHeight/100f, floor1.areaLong / 100f);
                    onTrun = false;
                } else if (pos.z < startPoint.z + dis) {
                    if (onTrun) {
                        pos += new Vector3(-floor0.areaWidth / 100f * (offset > 0 ? -1 : 1), 0, floor0.areaLong / 100f / 2);
                        trunCount--;
                    }
                    Debug.Log("创建地板 " + pos);
                    GameObject.Instantiate<GameObject>(floorPrefab0, pos, Quaternion.AngleAxis(rand.Next(0, 3) * 90, Vector3.up));
                    pos += new Vector3(0, 0, floor0.areaLong / 100f);
                    onTrun = false;
                } else {
                    Debug.Log("退出创建 " + pos);
                    break;
                }
                yield return 0;
            }

        }
    }
}