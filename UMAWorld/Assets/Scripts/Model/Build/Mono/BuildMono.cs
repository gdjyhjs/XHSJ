using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = System.Random;

namespace UMAWorld
{
    /// <summary>
    /// 建筑基础
    /// </summary>
    public class BuildMono : BuildMonoBase
    {
        BuildSchool buildData;

        public void Init(BuildSchool data)
        {
            buildData = data;
            gameObject.name = buildData.data.id;
            Random rand = new Random(buildData.data.seed);
            StartCoroutine(Build(rand));
        }

        private bool yieldWait = false;
        // 创建宗门建筑
        private IEnumerator Build(Random rand)
        {
            BuildSchool schoolData = (BuildSchool)buildData;

            ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(buildData.data.confId);

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
            for (int i = 0; i < 10; i++)
            {
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
            Vector3 startPoint = CommonTools.GetGroundPoint(new Vector3(buildData.data.mainGatePosX, 0, buildData.data.mainGatePosZ));
            Transform schoolStartFloor = new GameObject("schoolStartFloor").transform;
            schoolStartFloor.SetParent(transform);
            schoolStartFloor.position = startPoint;
            // 创建大门
            Vector3 mainGatePos = CommonTools.GetGroundPoint(new Vector3(startPoint.x, startPoint.y, startPoint.z - mainGateConf.areaLong));
            float mainGateHeight = float.PositiveInfinity;
            for (int x = 0; x <= 5; x++)
            {
                for (int z = 0; z <= 3; z++)
                {
                    Vector3 point = CommonTools.GetGroundPoint(new Vector3(mainGatePos.x - mainGateConf.areaWidth * 0.5f + mainGateConf.areaWidth * x / 5,
                        0, mainGatePos.z - mainGateConf.areaLong * 0.5f + mainGateConf.areaLong * z / 3));
                    if (point.y < mainGateHeight)
                        mainGateHeight = point.y;
                }
            }
            mainGatePos = new Vector3(mainGatePos.x, mainGateHeight, mainGatePos.z);
            transform.position = mainGatePos; // 设置宗门位置
            TextMesh[] names = GameObject.Instantiate<GameObject>(mainGatePrefab, mainGatePos, Quaternion.identity, schoolStartFloor).transform.Find("Name").GetComponentsInChildren<TextMesh>();
            foreach (var item in names)
            {
                item.text = buildData.data.id;
            }
            if (yieldWait)
                yield return (CheckWait());
            float schoolHeight = mainGatePos.y;


            {
                List<Vector3> vertices = new List<Vector3>(); // 顶点
                List<int> triangles = new List<int>(); // 面
                List<Vector3> normals = new List<Vector3>(); // 法线
                List<Vector2> uv = new List<Vector2>(); // uv

                if (schoolData.statirsSlopeArea1.Length > 0)
                {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea1[0], schoolData.statirsStep1, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea1.Length > 0)
                {
                    MeshTools.AddCube(schoolData.statirsSpaceArea1[0], schoolData.statirsSpaceArea1[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea2.Length > 0)
                {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea2[0], schoolData.statirsStep2, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea2.Length > 0)
                {
                    MeshTools.AddCube(schoolData.statirsSpaceArea2[0], schoolData.statirsSpaceArea2[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea3.Length > 0)
                {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea3[0], schoolData.statirsStep3, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea3.Length > 0)
                {
                    MeshTools.AddCube(schoolData.statirsSpaceArea3[0], schoolData.statirsSpaceArea3[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea4.Length > 0)
                {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea4[0], schoolData.statirsStep4, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea4.Length > 0)
                {
                    MeshTools.AddCube(schoolData.statirsSpaceArea4[0], schoolData.statirsSpaceArea4[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSlopeArea5.Length > 0)
                {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea5[0], schoolData.statirsStep5, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea5.Length > 0)
                {
                    MeshTools.AddCube(schoolData.statirsSpaceArea5[0], schoolData.statirsSpaceArea5[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                //MeshTools.AddCube(schoolData.outsideArea[0], schoolData.outsideArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideCenterArea[0], schoolData.outsideCenterArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideLeftArea[0], schoolData.outsideLeftArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideRightArea[0], schoolData.outsideRightArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                //MeshTools.AddCube(schoolData.centerArea[0], schoolData.centerArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.centerCenterArea[0], schoolData.centerCenterArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.centerLeftArea[0], schoolData.centerLeftArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.centerRightArea[0], schoolData.centerRightArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.insideArea[0], schoolData.insideArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                
                MeshTools.AddStatirs(schoolData.outsideLeftStatirsArea[0], 5, vertices, triangles, normals, uv, rand, 1);
                MeshTools.AddStatirs(schoolData.outsideRightStatirsArea[0], 5, vertices, triangles, normals, uv, rand, 2);
                MeshTools.AddStatirs(schoolData.statirsToCenterSlopeArea[0], schoolData.statirsToCenterStep, vertices, triangles, normals, uv, rand);
                MeshTools.AddStatirs(schoolData.centerLeftStatirsArea[0], 7, vertices, triangles, normals, uv, rand, 1);
                MeshTools.AddStatirs(schoolData.centerRightStatirsArea[0], 7, vertices, triangles, normals, uv, rand, 2);
                MeshTools.AddStatirs(schoolData.statirsToInsideSlopeArea[0], schoolData.statirsToInsideStep, vertices, triangles, normals, uv, rand);


                Mesh mesh = new Mesh(); //new 一个mesh
                mesh.vertices = vertices.ToArray(); //把顶点列表 放到mesh中
                mesh.triangles = triangles.ToArray(); //把三角序列 放到mesh中
                mesh.normals = normals.ToArray(); //把三角序列 放到mesh中
                mesh.uv = uv.ToArray(); //新增 把UV列表 放到mesh中


                Debug.Log(schoolData.statirsSpaceArea1[0]); Debug.Log(schoolData.statirsSpaceArea1[1] + Vector3.down * 0.2f);
                gameObject.AddComponent<MeshFilter>().mesh = mesh; //得到meshfilter组件
                gameObject.AddComponent<MeshRenderer>().material = CommonTools.LoadResources<Material>("Material/testStone");





            }
        }

        private GameObject Instantiate(GameObject prefab, Vector3 pos, Quaternion q, Transform parent)
        {
            return GameObject.Instantiate<GameObject>(prefab, pos, q, parent);
        }
    }
}