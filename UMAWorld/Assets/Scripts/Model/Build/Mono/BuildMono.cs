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
            Vector3 tmpPosStart;
            Vector3 tmpPosEnd;
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

            // 确定设置宗门高度位置
            startPoint.y = mainGatePos.y;
            transform.position = startPoint;


            // 创建大门模型
            TextMesh[] names = GameObject.Instantiate<GameObject>(mainGatePrefab, mainGatePos, Quaternion.identity, schoolStartFloor).transform.Find("Name").GetComponentsInChildren<TextMesh>();
            Material textMaterial = names[0].GetComponent<MeshRenderer>().material;
            Material forwardMaterial = Instantiate(textMaterial);
            Material backwardMaterial = Instantiate(textMaterial);
            foreach (var item in names)
            {
                item.text = buildData.data.id;
                if (item.name == "Name") {
                    forwardMaterial.color = item.color;
                    item.GetComponent<MeshRenderer>().material = forwardMaterial;
                } else {
                    backwardMaterial.color = item.color;
                    item.GetComponent<MeshRenderer>().material = backwardMaterial;
                }
            }
            if (yieldWait)
                yield return (CheckWait());
            float schoolHeight = mainGatePos.y;


            MeshTools.NewMeshObj("上山楼梯", (vertices, triangles, normals, uv) => {
                if (schoolData.statirsSlopeArea1.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea1[0], schoolData.statirsStep1, vertices, triangles, normals, uv, rand, width: schoolData.statirsWidth);
                }
                if (schoolData.statirsSlopeArea2.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea2[0], schoolData.statirsStep2, vertices, triangles, normals, uv, rand, width: schoolData.statirsWidth);
                }
                if (schoolData.statirsSlopeArea3.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea3[0], schoolData.statirsStep3, vertices, triangles, normals, uv, rand, width: schoolData.statirsWidth);
                }
                if (schoolData.statirsSlopeArea4.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea4[0], schoolData.statirsStep4, vertices, triangles, normals, uv, rand, width: schoolData.statirsWidth);
                }
                if (schoolData.statirsSlopeArea5.Length > 0) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea5[0], schoolData.statirsStep5, vertices, triangles, normals, uv, rand, width: schoolData.statirsWidth);
                }
            }).transform.SetParent(transform, false);
            MeshTools.NewMeshObj("上山平路", (vertices, triangles, normals, uv) => {
                if (schoolData.statirsSpaceArea1.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea1[0], schoolData.statirsSpaceArea1[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea2.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea2[0], schoolData.statirsSpaceArea2[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea3.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea3[0], schoolData.statirsSpaceArea3[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea4.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea4[0], schoolData.statirsSpaceArea4[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
                if (schoolData.statirsSpaceArea5.Length > 0) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea5[0], schoolData.statirsSpaceArea5[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                }
            }).transform.SetParent(transform, false);
            MeshTools.NewMeshObj("外殿_中殿_内殿_地皮", (vertices, triangles, normals, uv) => {
                //MeshTools.AddCube(schoolData.outsideArea[0], schoolData.outsideArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                //MeshTools.AddCube(schoolData.centerArea[0], schoolData.centerArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideCenterArea[0], schoolData.outsideCenterArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideLeftArea[0], schoolData.outsideLeftArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideRightArea[0], schoolData.outsideRightArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.centerCenterArea[0], schoolData.centerCenterArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.centerLeftArea[0], schoolData.centerLeftArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.centerRightArea[0], schoolData.centerRightArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.insideArea[0], schoolData.insideArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.insideArea[0], schoolData.insideArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
            }).transform.SetParent(transform, false);
            MeshTools.NewMeshObj("楼梯", (vertices, triangles, normals, uv) => {
                MeshTools.AddStatirs(schoolData.outsideLeftStatirsArea[0], 5, vertices, triangles, normals, uv, rand, 1, width: schoolData.outsideLeftStatirsWidth);
                MeshTools.AddStatirs(schoolData.outsideRightStatirsArea[0], 5, vertices, triangles, normals, uv, rand, 2, width: schoolData.outsideRightStatirsWidth);
                MeshTools.AddStatirs(schoolData.statirsToCenterSlopeArea[0], schoolData.statirsToCenterStep, vertices, triangles, normals, uv, rand, width: schoolData.statirsToCenterWidth);
                MeshTools.AddStatirs(schoolData.centerLeftStatirsArea[0], 7, vertices, triangles, normals, uv, rand, 1, width: schoolData.centerLeftStatirsWidth);
                MeshTools.AddStatirs(schoolData.centerRightStatirsArea[0], 7, vertices, triangles, normals, uv, rand, 2, width: schoolData.centerRightStatirsWidth);
                MeshTools.AddStatirs(schoolData.statirsToInsideSlopeArea[0], schoolData.statirsToInsideStep, vertices, triangles, normals, uv, rand, width: schoolData.statirsToInsideWidth);
            }).transform.SetParent(transform, false);

            g.units.player.mono.transform.position = startPoint + schoolData.statirsToCenterSlopeArea[0] + Vector3.right + Vector3.up;




















            #region 外殿左 围墙
            {
                tmpPosStart = startPoint + new Vector3(schoolData.outsideLeftArea[1].x + wallCornerConf.areaWidth, schoolData.outsideLeftArea[1].y, schoolData.outsideLeftArea[0].z + wallCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.outsideLeftArea[0].x - wallCornerConf.areaWidth, schoolData.outsideLeftArea[1].y, schoolData.outsideLeftArea[1].z - wallCornerConf.areaWidth);

                Transform outLeftWall = new GameObject("outLeftWall").transform;
                outLeftWall.SetParent(transform);
                outLeftWall.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                int hCount = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / wallConf.areaWidth);
                int vCount = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / wallConf.areaWidth);
                if (vCount % 2 == 0)
                    vCount++;
                float hWidth = Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / hCount;
                float vWidth = Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / vCount;
                for (float i = 0; i <= hCount; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * i, tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall); // 柱
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * i, tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall); // 柱
                }
                for (int i = 1; i < vCount; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall); // 柱
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outLeftWall); // 柱
                }
                for (int i = 0; i < hCount; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * (i + 0.5f), tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outLeftWall); // 墙
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * (i + 0.5f), tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outLeftWall); // 墙
                }
                for (int i = 0; i < vCount; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth  * (i + 0.5f));
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall); // 墙
                    if (vCount / 2 == i) {
                    } else if (vCount / 2 == i + 1) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth);
                        Instantiate(wallGatePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall); // 墙
                    } else
                    {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i + 0.5f));
                        Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outLeftWall); // 墙
                    }

                }
            }
            #endregion



            #region 外殿左 房子，树木
            {
                tmpPosStart = startPoint + schoolData.outsideLeftArea[1];
                tmpPosEnd = startPoint + schoolData.outsideLeftArea[0];




                //Transform outLeftHouse = new GameObject("outLeftHouse").transform;
                //outLeftHouse.SetParent(transform);
                //outLeftHouse.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);
                //float outTreeY1 = tmpPosEnd.z - wallCornerConf.areaWidth - flowerbedConf.areaWidth * 1.5f;
                //float outTreeY2 = tmpPosStart.z + wallCornerConf.areaWidth + flowerbedConf.areaWidth * 1.5f;
                //float outHouseY = tmpPosEnd.z - wallCornerConf.areaWidth - outHouseConf.areaLong * 0.5f;
                //for (float i = tmpPosStart.x; i < tmpPosEnd.x;) {
                //    // 创建树木
                //    float x = i + wallCornerConf.areaWidth + flowerbedConf.areaWidth * 1.5f;
                //    i = x + flowerbedConf.areaWidth * 0.5f;
                //    if (i > tmpPosEnd.x)
                //        break;
                //    // 花盆1
                //    tmpPosStart = new Vector3(x, tmpPosStart.y, outTreeY1);
                //    GameObject flowerbed1 = Object.Instantiate(flowerbedPrefab, (Vector3)tmpPosStart, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftHouse);
                //    // 树1
                //    tmpPosStart = tmpPosStart + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                //    GameObject tree1 = Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPosStart, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftHouse);
                //    // 花盆2
                //    tmpPosStart = new Vector3(x, tmpPosStart.y, outTreeY2);
                //    GameObject flowerbed2 = Object.Instantiate(flowerbedPrefab, (Vector3)tmpPosStart, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftHouse);
                //    // 树2
                //    tmpPosStart = tmpPosStart + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                //    GameObject tree2 = Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPosStart, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), outLeftHouse);
                //    // 创建房屋
                //    x += flowerbedConf.areaWidth * 1.5f + outHouseConf.areaWidth * 0.5f;
                //    i = x + outHouseConf.areaWidth * 0.5f;
                //    if (i > tmpPosEnd.x)
                //        break;
                //    tmpPosStart = new Vector3(x, tmpPosStart.y, outHouseY);
                //    GameObject house = Object.Instantiate(outHousePrefab, (Vector3)tmpPosStart, Quaternion.identity, outLeftHouse);
                //    //GameObject treeTest = Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPos, Quaternion.identity, outLeftHouse);
                //    yield return 0;
                //}
            }
            #endregion
        }

        private GameObject Instantiate(GameObject prefab, Vector3 pos, Quaternion q, Transform parent)
        {
            return GameObject.Instantiate<GameObject>(prefab, pos, q, parent);
        }
    }
}