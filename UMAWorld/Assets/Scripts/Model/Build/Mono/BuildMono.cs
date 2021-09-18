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

        private bool yieldWait = false;
        // 创建宗门建筑
        private IEnumerator Build(Random rand) {
            BuildSchool schoolData = (BuildSchool)buildData;

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

            
            // 从大门创建楼梯到外殿
            Vector3 startPoint = CommonTools.GetGroundPoint(buildData.mainGatePos);
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
            float schoolHeight = mainGatePos.y;


            {
                List<Vector3> vertices = new List<Vector3>(); // 顶点
                List<int> triangles = new List<int>(); // 面
                List<Vector3> normals = new List<Vector3>(); // 法线
                List<Vector2> uv = new List<Vector2>(); // uv

                if (schoolData.statirsSlopeArea1.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea1[0], schoolData.statirsStep1, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea1.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea1[0], schoolData.statirsSpaceArea1[1], vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea2.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea2[0], schoolData.statirsStep2, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea2.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea2[0], schoolData.statirsSpaceArea2[1], vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea3.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea3[0], schoolData.statirsStep3, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea3.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea3[0], schoolData.statirsSpaceArea3[1], vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea4.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea4[0], schoolData.statirsStep4, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea4.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea4[0], schoolData.statirsSpaceArea4[1], vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea5.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea5[0], schoolData.statirsStep5, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea5.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea5[0], schoolData.statirsSpaceArea5[1], vertices, triangles, normals, uv, rand);
                }

                Mesh mesh = new Mesh(); //new 一个mesh
                mesh.vertices = vertices.ToArray(); //把顶点列表 放到mesh中
                mesh.triangles = triangles.ToArray(); //把三角序列 放到mesh中
                mesh.normals = normals.ToArray(); //把三角序列 放到mesh中
                mesh.uv = uv.ToArray(); //新增 把UV列表 放到mesh中


                gameObject.AddComponent<MeshFilter>().mesh = mesh; //得到meshfilter组件
                gameObject.AddComponent<MeshRenderer>().material = CommonTools.LoadResources<Material>("Material/StandardRed");
            }
        }

        private GameObject Instantiate(GameObject prefab, Vector3 pos, Quaternion q, Transform parent) {
            return GameObject.Instantiate<GameObject>(prefab, pos, q, parent);
        }
    }
}