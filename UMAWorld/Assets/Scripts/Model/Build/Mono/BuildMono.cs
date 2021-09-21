using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = System.Random;

namespace UMAWorld {
    /// <summary>
    /// 建筑基础
    /// </summary>
    public class BuildMono : BuildMonoBase {
        BuildSchool buildData;

        public void Init(BuildSchool data) {
            buildData = data;
            gameObject.name = buildData.data.id;
            Random rand = new Random(buildData.data.seed);
            StartCoroutine(Build(rand));
        }

        private bool yieldWait = false;
        // 创建宗门建筑
        private IEnumerator Build(Random rand) {
            BuildSchool schoolData = (BuildSchool)buildData;

            ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(buildData.data.confId);

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

            ConfSchoolFloorItem fenceCornerConf = g.conf.schoolFloor.GetItem(conf.fenceCorner); // 墙柱
            GameObject fenceCornerPrefab = CommonTools.LoadResources<GameObject>(fenceCornerConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem fenceConf = g.conf.schoolFloor.GetItem(conf.fence); // 墙壁
            GameObject fencePrefab = CommonTools.LoadResources<GameObject>(fenceConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem outHouseConf = g.conf.schoolFloor.GetItem(conf.outHouse); // 外门弟子方
            GameObject outHousePrefab = CommonTools.LoadResources<GameObject>(outHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem inHouseConf = g.conf.schoolFloor.GetItem(conf.inHouse); // 内门弟子方
            GameObject oinHousePrefab = CommonTools.LoadResources<GameObject>(inHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem inTrueHouseConf = g.conf.schoolFloor.GetItem(conf.inTrueHouse); // 真传弟子方
            GameObject inTrueHousePrefab = CommonTools.LoadResources<GameObject>(inTrueHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem elderHouseConf = g.conf.schoolFloor.GetItem(conf.elderHouse); // 长老房子
            GameObject elderHousePrefab = CommonTools.LoadResources<GameObject>(elderHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem bigElderHouseConf = g.conf.schoolFloor.GetItem(conf.bigElderHouse); // 大长老房子
            GameObject bigElderHousePrefab = CommonTools.LoadResources<GameObject>(bigElderHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem mainHouseConf = g.conf.schoolFloor.GetItem(conf.mainHouse); // 宗主房子
            GameObject mainHousePrefab = CommonTools.LoadResources<GameObject>(mainHouseConf.prefab);
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


            ConfSchoolFloorItem storeHouseConf = g.conf.schoolFloor.GetItem(conf.storeHouse); // 聚宝仙阁
            GameObject storeHousePrefab = CommonTools.LoadResources<GameObject>(storeHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolFloorItem upLevelHouseConf = g.conf.schoolFloor.GetItem(conf.upLevelHouse); // 聚灵阵
            GameObject upLevelHousePrefab = CommonTools.LoadResources<GameObject>(upLevelHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolFloorItem taskHouseConf = g.conf.schoolFloor.GetItem(conf.taskHouse); // 任务大厅
            GameObject taskHousePrefab = CommonTools.LoadResources<GameObject>(taskHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolFloorItem hospiltalHouseConf = g.conf.schoolFloor.GetItem(conf.hospiltalHouse); // 疗伤院
            GameObject hospiltalHousePrefab = CommonTools.LoadResources<GameObject>(hospiltalHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolFloorItem meetingHouseConf = g.conf.schoolFloor.GetItem(conf.meetingHouse); // 议事大厅
            GameObject meetingHousePrefab = CommonTools.LoadResources<GameObject>(meetingHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolFloorItem depotHouseConf = g.conf.schoolFloor.GetItem(conf.depotHouse); // 建木
            GameObject depotHousePrefab = CommonTools.LoadResources<GameObject>(depotHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolFloorItem bookShopHouseConf = g.conf.schoolFloor.GetItem(conf.bookShopHouse); // 藏经阁
            GameObject bookShopHousePrefab = CommonTools.LoadResources<GameObject>(bookShopHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolFloorItem transmitHouseConf = g.conf.schoolFloor.GetItem(conf.transmitHouse); // 传送阵
            GameObject transmitHousePrefab = CommonTools.LoadResources<GameObject>(transmitHouseConf.prefab);
            if (yieldWait)
                yield return CheckWait();

            ConfSchoolFloorItem[] bambooConf = new ConfSchoolFloorItem[conf.bamboo.Length];
            GameObject[] bambooPrefab = new GameObject[conf.bamboo.Length];
            for (int i = 0; i < conf.bamboo.Length; i++) {
                bambooConf[i] = g.conf.schoolFloor.GetItem(conf.bamboo[i]); // 竹林
                bambooPrefab[i] = CommonTools.LoadResources<GameObject>(bambooConf[i].prefab);
            }
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolColorItem floorMatConf = g.conf.schoolColor.GetItem(conf.floorColor); // 地板材质
            Material floorMat = Instantiate(CommonTools.LoadResources<Material>(floorMatConf.material));
            //floorMat.SetTextureScale("Normalmap", new Vector2(floorMatConf.tilingX, floorMatConf.tilingY));
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolColorItem statirsMatConf = g.conf.schoolColor.GetItem(conf.stairwayColor); // 楼梯材质
            Material statirsMat = Instantiate(CommonTools.LoadResources<Material>(statirsMatConf.material));
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolColorItem grassMatConf = g.conf.schoolColor.GetItem(conf.grassColor); // 楼梯材质
            Material grassMat = Instantiate(CommonTools.LoadResources<Material>(grassMatConf.material));
            if (yieldWait)
                yield return CheckWait();


            ConfSchoolColorItem stoneMatConf = g.conf.schoolColor.GetItem(conf.stoneColor); // 石头材质
            Material stoneMat = Instantiate(CommonTools.LoadResources<Material>(stoneMatConf.material));
            if (yieldWait)
                yield return CheckWait();




            int tmpH;
            int tmpV;
            float tmpW;
            float tmpL;
            float tmpS;
            float tmpStart;
            float tmpEnd;
            float tmpF;
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
            for (int x = 0; x <= 5; x++) {
                for (int z = 0; z <= 3; z++) {
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
            foreach (var item in names) {
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

            float floorHeight = 200;
            MeshTools.NewMeshObj("上山楼梯", (vertices, triangles, normals, uv) => {
                for (int i = 0; i < schoolData.statirsSlopeArea.Length; i++) {
                    MeshTools.AddStatirs(schoolData.statirsSlopeArea[i][0], schoolData.statirsStep[i], vertices, triangles, normals, uv, rand, width: schoolData.statirsWidth);
                }
                MeshTools.AddStatirs(schoolData.transmitStatirs[0], schoolData.transmitStatirsStep, vertices, triangles, normals, uv, rand, width: schoolData.statirsWidth, dir: 1);

            }, statirsMat).transform.SetParent(transform, false);
            MeshTools.NewMeshObj("上山平路", (vertices, triangles, normals, uv) => {
                for (int i = 0; i < schoolData.statirsSpaceArea.Length; i++) {
                    MeshTools.AddCube(schoolData.statirsSpaceArea[i][0], schoolData.statirsSpaceArea[i][1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand, dir: 1);
                }
                MeshTools.AddCube(schoolData.transmitArea[0], schoolData.transmitArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand);
            }, floorMat).transform.SetParent(transform, false);
            MeshTools.NewMeshObj("外殿_中殿_内殿_地皮", (vertices, triangles, normals, uv) => {
                //MeshTools.AddCube(schoolData.outsideArea[0], schoolData.outsideArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                //MeshTools.AddCube(schoolData.centerArea[0], schoolData.centerArea[1] + Vector3.down * 0.2f, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideCenterArea[0], schoolData.outsideCenterArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.outsideLeftArea[0], schoolData.outsideLeftArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand, dir: 1);
                MeshTools.AddCube(schoolData.outsideRightArea[0], schoolData.outsideRightArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand, dir: 1);
                MeshTools.AddCube(schoolData.centerCenterArea[0], schoolData.centerCenterArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.centerLeftArea[0], schoolData.centerLeftArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand, dir: 1);
                MeshTools.AddCube(schoolData.centerRightArea[0], schoolData.centerRightArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand, dir: 1);
                MeshTools.AddCube(schoolData.insideArea[0], schoolData.insideArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand);
                MeshTools.AddCube(schoolData.insideArea[0], schoolData.insideArea[1] + Vector3.down * floorHeight, vertices, triangles, normals, uv, rand);
            }, floorMat).transform.SetParent(transform, false);
            MeshTools.NewMeshObj("楼梯", (vertices, triangles, normals, uv) => {
                MeshTools.AddStatirs(schoolData.outsideLeftStatirsArea[0], schoolData.statirsOutStep, vertices, triangles, normals, uv, rand, 1, width: schoolData.outsideLeftStatirsWidth);
                MeshTools.AddStatirs(schoolData.outsideRightStatirsArea[0], schoolData.statirsOutStep, vertices, triangles, normals, uv, rand, 2, width: schoolData.outsideRightStatirsWidth);
                MeshTools.AddStatirs(schoolData.statirsToCenterSlopeArea[0], schoolData.statirsToCenterStep, vertices, triangles, normals, uv, rand, width: schoolData.statirsToCenterWidth);
                MeshTools.AddStatirs(schoolData.centerLeftStatirsArea[0], schoolData.statirsCenterStep, vertices, triangles, normals, uv, rand, 1, width: schoolData.centerLeftStatirsWidth);
                MeshTools.AddStatirs(schoolData.centerRightStatirsArea[0], schoolData.statirsCenterStep, vertices, triangles, normals, uv, rand, 2, width: schoolData.centerRightStatirsWidth);
                MeshTools.AddStatirs(schoolData.statirsToInsideSlopeArea[0], schoolData.statirsToInsideStep, vertices, triangles, normals, uv, rand, width: schoolData.statirsToInsideWidth);
            }, statirsMat).transform.SetParent(transform, false);






















            #region 外殿左 围墙
            {
                tmpPosStart = startPoint + new Vector3(schoolData.outsideLeftArea[1].x + wallCornerConf.areaWidth, schoolData.outsideLeftArea[1].y, schoolData.outsideLeftArea[0].z + wallCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.outsideLeftArea[0].x - wallCornerConf.areaWidth, schoolData.outsideLeftArea[1].y, schoolData.outsideLeftArea[1].z - wallCornerConf.areaWidth);

                Transform outsideLeftWall = new GameObject("outsideLeftWall").transform;
                outsideLeftWall.SetParent(transform);
                outsideLeftWall.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / wallConf.areaWidth);
                tmpV = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / wallConf.areaWidth);
                if (tmpV % 2 == 1)
                    tmpV++;
                float hWidth = Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / tmpH;
                float vWidth = Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / tmpV;
                float hScale = hWidth / wallConf.areaWidth;
                float vScale = vWidth / wallConf.areaWidth;
                for (float i = 0; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * i, tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideLeftWall); // 柱
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * i, tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideLeftWall); // 柱
                }
                for (int i = 1; i < tmpV; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideLeftWall); // 柱
                    if ((tmpV / 2) == i) {

                    } else {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideLeftWall); // 柱
                    }
                }
                for (int i = 1; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * (i - 0.5f), tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideLeftWall)
                        .transform.localScale = new Vector3(hScale, 1, 1); // 墙
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * (i - 0.5f), tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideLeftWall)
                        .transform.localScale = new Vector3(hScale, 1, 1); // 墙
                }

                for (int i = 1; i <= tmpV; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideLeftWall)
                        .transform.localScale = new Vector3(vScale, 1, 1); // 墙
                    if ((tmpV / 2) == i) {
                        float gScale = vWidth * 2 / wallGateConf.areaWidth;
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallGatePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideLeftWall)
                        .transform.localScale = new Vector3(gScale, 1, 1); // 门
                    } else if ((tmpV / 2 + 1) == i) {
                    } else {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                        Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideLeftWall)
                        .transform.localScale = new Vector3(vScale, 1, 1); // 墙
                    }
                }
            }
            #endregion


            #region 外殿右 围墙
            {
                tmpPosStart = startPoint + new Vector3(schoolData.outsideRightArea[0].x + wallCornerConf.areaWidth, schoolData.outsideRightArea[0].y, schoolData.outsideRightArea[0].z + wallCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.outsideRightArea[1].x - wallCornerConf.areaWidth, schoolData.outsideRightArea[1].y, schoolData.outsideRightArea[1].z - wallCornerConf.areaWidth);

                Transform outsideRightWall = new GameObject("outsideRightWall").transform;
                outsideRightWall.SetParent(transform);
                outsideRightWall.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / wallConf.areaWidth);
                tmpV = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / wallConf.areaWidth);
                if (tmpV % 2 == 1)
                    tmpV++;
                float hWidth = Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / tmpH;
                float vWidth = Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / tmpV;
                float hScale = hWidth / wallConf.areaWidth;
                float vScale = vWidth / wallConf.areaWidth;
                for (float i = 0; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * i, tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideRightWall); // 柱
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * i, tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideRightWall); // 柱
                }
                for (int i = 1; i < tmpV; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideRightWall); // 柱
                    if ((tmpV / 2) == i) {

                    } else {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideRightWall); // 柱
                    }
                }
                for (int i = 1; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * (i - 0.5f), tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideRightWall)
                        .transform.localScale = new Vector3(hScale, 1, 1); // 墙
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * (i - 0.5f), tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideRightWall)
                        .transform.localScale = new Vector3(hScale, 1, 1); // 墙
                }

                for (int i = 1; i <= tmpV; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideRightWall)
                        .transform.localScale = new Vector3(vScale, 1, 1); // 墙
                    if ((tmpV / 2) == i) {
                        float gScale = vWidth * 2 / wallGateConf.areaWidth;
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallGatePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideRightWall)
                            .transform.localScale = new Vector3(gScale, 1, 1);// 门
                    } else if ((tmpV / 2 + 1) == i) {
                    } else {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                        Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideRightWall)
                            .transform.localScale = new Vector3(vScale, 1, 1);// 墙
                    }
                }
            }
            #endregion




            #region 中殿左 围墙
            {
                tmpPosStart = startPoint + new Vector3(schoolData.centerLeftArea[1].x + wallCornerConf.areaWidth, schoolData.centerLeftArea[1].y, schoolData.centerLeftArea[0].z + wallCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.centerLeftArea[0].x - wallCornerConf.areaWidth, schoolData.centerLeftArea[1].y, schoolData.centerLeftArea[1].z - wallCornerConf.areaWidth);

                Transform centerLeftWall = new GameObject("centerLeftWall").transform;
                centerLeftWall.SetParent(transform);
                centerLeftWall.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / wallConf.areaWidth);
                tmpV = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / wallConf.areaWidth);
                if (tmpV % 2 == 1)
                    tmpV++;
                float hWidth = Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / tmpH;
                float vWidth = Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / tmpV;
                float hScale = hWidth / wallConf.areaWidth;
                float vScale = vWidth / wallConf.areaWidth;
                for (float i = 0; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * i, tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerLeftWall); // 柱
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * i, tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerLeftWall); // 柱
                }
                for (int i = 1; i < tmpV; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerLeftWall); // 柱
                    if ((tmpV / 2) == i) {

                    } else {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerLeftWall); // 柱
                    }
                }
                for (int i = 1; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * (i - 0.5f), tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerLeftWall)
                        .transform.localScale = new Vector3(hScale, 1, 1);// 墙
                    tmpPos = new Vector3(tmpPosStart.x + hWidth * (i - 0.5f), tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerLeftWall)
                        .transform.localScale = new Vector3(hScale, 1, 1);// 墙
                }

                for (int i = 1; i <= tmpV; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerLeftWall)
                        .transform.localScale = new Vector3(vScale, 1, 1); // 墙
                    if ((tmpV / 2) == i) {
                        float gScale = vWidth * 2 / wallGateConf.areaWidth;
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallGatePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerLeftWall)
                        .transform.localScale = new Vector3(gScale, 1, 1); // 门
                    } else if ((tmpV / 2 + 1) == i) {
                    } else {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                        Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerLeftWall)
                        .transform.localScale = new Vector3(vScale, 1, 1); // 墙
                    }
                }
            }
            #endregion


            #region 中殿右 围墙
            {
                tmpPosStart = startPoint + new Vector3(schoolData.centerRightArea[0].x + wallCornerConf.areaWidth, schoolData.centerRightArea[0].y, schoolData.centerRightArea[0].z + wallCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.centerRightArea[1].x - wallCornerConf.areaWidth, schoolData.centerRightArea[1].y, schoolData.centerRightArea[1].z - wallCornerConf.areaWidth);

                Transform centerRightWall = new GameObject("centerRightWall").transform;
                centerRightWall.SetParent(transform);
                centerRightWall.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / wallConf.areaWidth);
                tmpV = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / wallConf.areaWidth);
                if (tmpV % 2 == 1)
                    tmpV++;
                float hWidth = Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / tmpH;
                float vWidth = Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / tmpV;
                float hScale = hWidth / wallConf.areaWidth;
                float vScale = vWidth / wallConf.areaWidth;
                for (float i = 0; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * i, tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerRightWall); // 柱
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * i, tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerRightWall); // 柱
                }
                for (int i = 1; i < tmpV; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerRightWall); // 柱
                    if ((tmpV / 2) == i) {

                    } else {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerRightWall); // 柱
                    }
                }
                for (int i = 1; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * (i - 0.5f), tmpPosStart.y, tmpPosStart.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerRightWall)
                        .transform.localScale = new Vector3(hScale, 1, 1); // 墙
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * (i - 0.5f), tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerRightWall)
                        .transform.localScale = new Vector3(hScale, 1, 1); // 墙
                }

                for (int i = 1; i <= tmpV; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerRightWall)
                        .transform.localScale = new Vector3(vScale, 1, 1);// 墙
                    if ((tmpV / 2) == i) {
                        float gScale = vWidth * 2 / wallGateConf.areaWidth;
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                        Instantiate(wallGatePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerRightWall)
                        .transform.localScale = new Vector3(gScale, 1, 1);// 门
                    } else if ((tmpV / 2 + 1) == i) {
                    } else {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                        Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerRightWall)
                        .transform.localScale = new Vector3(vScale, 1, 1); // 墙
                    }
                }
            }
            #endregion


            #region 内殿 围墙
            {
                tmpPosStart = startPoint + new Vector3(schoolData.insideArea[0].x + wallCornerConf.areaWidth, schoolData.insideArea[0].y, schoolData.insideArea[0].z + wallCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.insideArea[1].x - wallCornerConf.areaWidth, schoolData.insideArea[1].y, schoolData.insideArea[1].z - wallCornerConf.areaWidth);

                Transform insideWall = new GameObject("insideWall").transform;
                insideWall.SetParent(transform);
                insideWall.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / wallConf.areaWidth);
                tmpV = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / wallConf.areaWidth);
                if (tmpH % 2 == 1)
                    tmpH++;
                float hWidth = Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / tmpH;
                float vWidth = Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / tmpV;
                float hScale = hWidth / wallConf.areaWidth;
                float vScale = vWidth / wallConf.areaWidth;
                for (float i = 0; i <= tmpH; i++) {
                    if ((tmpH / 2) == i) {

                    } else {
                        tmpPos = new Vector3(tmpPosEnd.x - hWidth * i, tmpPosStart.y, tmpPosStart.z);
                        Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), insideWall); // 柱
                    }
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * i, tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), insideWall); // 柱
                }
                for (int i = 1; i < tmpV; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), insideWall); // 柱
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * i);
                    Instantiate(wallCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), insideWall); // 柱
                }
                for (int i = 1; i <= tmpH; i++) {
                    if ((tmpH / 2) == i) {
                        float gScale = hWidth * 2 / wallGateConf.areaWidth;
                        tmpPos = new Vector3(tmpPosEnd.x - hWidth * i, tmpPosStart.y, tmpPosStart.z);
                        Instantiate(wallGatePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), insideWall)
                            .transform.localScale = new Vector3(gScale, 1, 1);// 门
                    } else if ((tmpH / 2 + 1) == i) {
                    } else {
                        tmpPos = new Vector3(tmpPosEnd.x - hWidth * (i - 0.5f), tmpPosStart.y, tmpPosStart.z);
                        Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), insideWall)
                            .transform.localScale = new Vector3(hScale, 1, 1);// 墙
                    }
                    tmpPos = new Vector3(tmpPosEnd.x - hWidth * (i - 0.5f), tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), insideWall)
                        .transform.localScale = new Vector3(hScale, 1, 1);// 墙
                }

                for (int i = 1; i <= tmpV; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), insideWall)
                        .transform.localScale = new Vector3(vScale, 1, 1);// 墙
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + vWidth * (i - 0.5f));
                    Instantiate(wallPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), insideWall)
                        .transform.localScale = new Vector3(vScale, 1, 1);// 墙
                }
            }
            #endregion



            #region 外殿 围墙
            {
                // 外殿区域
                tmpPosStart = startPoint + new Vector3(schoolData.outsideCenterArea[0].x + fenceCornerConf.areaWidth, schoolData.outsideCenterArea[0].y, schoolData.outsideCenterArea[0].z + fenceCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.outsideCenterArea[1].x - fenceCornerConf.areaWidth, schoolData.outsideCenterArea[1].y, schoolData.outsideCenterArea[1].z - fenceCornerConf.areaWidth);

                Transform outsideFence = new GameObject("outsideFence").transform;
                outsideFence.SetParent(transform);
                outsideFence.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                // 前面那面墙
                {
                    Vector3[] intoSpace = schoolData.statirsSpaceArea[schoolData.statirsSpaceArea.Length - 1];
                    // 左边
                    tmpStart = tmpPosStart.x;
                    tmpEnd = startPoint.x + Mathf.Min(intoSpace[0].x, intoSpace[1].x) + fenceCornerConf.areaWidth;
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    tmpF = tmpEnd;


                    // 入宗道路左边
                    tmpStart = tmpPosStart.z;
                    tmpEnd = startPoint.z + Mathf.Min(intoSpace[0].z, intoSpace[1].z) + fenceCornerConf.areaWidth;
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 1; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpF, tmpPosStart.y, tmpPosStart.z - tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpF, tmpPosStart.y, tmpPosStart.z - tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }

                    float doorWidth = schoolData.statirsWidth - fenceCornerConf.areaWidth - fenceCornerConf.areaWidth;

                    //// 入宗前面道路那一节
                    //tmpS = doorWidth / fenceConf.areaWidth;
                    //tmpPos = new Vector3(tmpF + doorWidth, tmpPosStart.y, tmpPosStart.z - tmpW * tmpH);
                    //Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    //tmpPos = new Vector3(tmpF + doorWidth * 0.5f, tmpPosStart.y, tmpPosStart.z - tmpW * tmpH);
                    //Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideFence)
                    //.transform.localScale = new Vector3(tmpS, 1, 1); // 墙


                    //// 入宗前面道路那一节
                    //tmpPos = new Vector3(tmpF + doorWidth, tmpPosStart.y, tmpPosStart.z - tmpW * tmpH);
                    //Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    //tmpPos = new Vector3(tmpF - doorWidth * 0.5f, tmpPosStart.y, tmpPosStart.z - tmpW * tmpH);
                    //Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideFence)
                    //.transform.localScale = new Vector3(tmpS, 1, 1); // 墙



                    // 右边
                    tmpStart = startPoint.x + Mathf.Max(intoSpace[0].x, intoSpace[1].x) - fenceCornerConf.areaWidth;
                    tmpEnd = tmpPosEnd.x;
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    tmpF = tmpStart;



                    // 入宗道路右边 传送上
                    tmpStart = tmpPosStart.z;
                    tmpEnd = startPoint.z + schoolData.transmitStatirs[1].z;
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 1; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpF, tmpPosStart.y, tmpPosStart.z - tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpF, tmpPosStart.y, tmpPosStart.z - tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }


                    // 入宗道路右边 传送下
                    tmpStart = startPoint.z + schoolData.transmitStatirs[0].z;
                    tmpEnd = startPoint.z + Mathf.Min(intoSpace[0].z, intoSpace[1].z) + fenceCornerConf.areaWidth;
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpF, tmpPosStart.y, tmpStart - tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpF, tmpPosStart.y, tmpStart - tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                }
                // 后面那面墙
                {
                    // 左边
                    tmpStart = tmpPosStart.x;
                    tmpEnd = startPoint.x + Mathf.Min(schoolData.statirsToCenterSlopeArea[0].x, schoolData.statirsToCenterSlopeArea[1].x);

                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }

                    // 楼梯斜墙
                    tmpStart = startPoint.z + schoolData.statirsToCenterSlopeArea[0].z - fenceCornerConf.areaWidth;
                    tmpEnd = startPoint.z + schoolData.statirsToCenterSlopeArea[1].z + fenceCornerConf.areaWidth;
                    tmpF = tmpPosStart.y + (schoolData.statirsToCenterSlopeArea[1].y - schoolData.statirsToCenterSlopeArea[0].y) * 0.5f; // 斜墙高度
                    // 创建楼梯围墙 坐斜墙
                    tmpPos = new Vector3(startPoint.x + schoolData.statirsToCenterSlopeArea[0].x, tmpF, tmpStart + (tmpEnd - tmpStart) * 0.5f);
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(-90, Vector3.up), outsideFence);// 墙
                    tmpGo.transform.localScale = new Vector3(tmpS, 1, 1);
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, schoolData.statirsToCenterSlopeArea[1].y - schoolData.statirsToCenterSlopeArea[0].y, tmpEnd - tmpStart);
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }
                    // 创建楼梯围墙 左上斜墙
                    tmpPos.x += schoolData.statirsToCenterWidth;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(-90, Vector3.up), outsideFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, schoolData.statirsToCenterSlopeArea[1].y - schoolData.statirsToCenterSlopeArea[0].y, tmpEnd - tmpStart);
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }








                    // 右边
                    tmpStart = startPoint.x + Mathf.Max(schoolData.statirsToCenterSlopeArea[0].x, schoolData.statirsToCenterSlopeArea[1].x);
                    tmpEnd = tmpPosEnd.x;

                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                }


                // 左右围墙
                {
                    // 上边
                    tmpStart = tmpPosStart.z;
                    tmpEnd = startPoint.z + Mathf.Min(schoolData.outsideLeftStatirsArea[0].z, schoolData.outsideLeftStatirsArea[1].z);
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;


                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 1; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 1; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }





                    Vector3 start = tmpPos;
                    Vector3 end = startPoint + new Vector3(schoolData.outsideLeftStatirsArea[1].x, schoolData.outsideLeftStatirsArea[1].y, schoolData.outsideLeftStatirsArea[0].z);
                    end.x -= fenceCornerConf.areaWidth;
                    tmpF = start.y + (end.y - start.y) * 0.5f; // 斜墙高度
                    // 创建楼梯围墙 左下斜墙
                    tmpPos = new Vector3(start.x + (end.x - start.x) * 0.5f, tmpF, start.z);
                    tmpPos.x -= fenceCornerConf.areaWidth * 0.25f;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), outsideFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }
                    // 创建楼梯围墙 左上斜墙
                    tmpPos.z += schoolData.outsideLeftStatirsWidth;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), outsideFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }

                    // 创建楼梯围墙 右下斜墙
                    tmpPos = new Vector3(tmpPosEnd.x - (end.x - start.x) * 0.5f, tmpF, start.z);
                    tmpPos.x += fenceCornerConf.areaWidth * 0.25f;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(0, Vector3.up), outsideFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }
                    // 创建楼梯围墙 右上斜墙
                    tmpPos.z += schoolData.outsideLeftStatirsWidth;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(0, Vector3.up), outsideFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }

                    tmpPos = new Vector3(end.x, end.y, start.z);
                    tmpPos.x -= fenceCornerConf.areaWidth * 0.5f;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    tmpPos.z += schoolData.outsideLeftStatirsWidth;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱

                    tmpPos = startPoint + schoolData.outsideRightStatirsArea[1];
                    tmpPos.x += fenceCornerConf.areaWidth * 0.5f;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    tmpPos.z += schoolData.outsideLeftStatirsWidth;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱


                    // 下边
                    tmpStart = startPoint.z + Mathf.Max(schoolData.outsideLeftStatirsArea[0].z, schoolData.outsideLeftStatirsArea[1].z);
                    tmpEnd = tmpPosEnd.z;

                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), outsideFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), outsideFence); // 柱
                    }
                }

            }
            #endregion

            #region 内殿 围墙
            {
                // 内殿区域
                tmpPosStart = startPoint + new Vector3(schoolData.centerCenterArea[0].x + fenceCornerConf.areaWidth, schoolData.centerCenterArea[0].y, schoolData.centerCenterArea[0].z + fenceCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.centerCenterArea[1].x - fenceCornerConf.areaWidth, schoolData.centerCenterArea[1].y, schoolData.centerCenterArea[1].z - fenceCornerConf.areaWidth);

                Transform centerFence = new GameObject("centerFence").transform;
                centerFence.SetParent(transform);
                centerFence.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                // 前面那面墙
                {
                    Vector3[] intoSpace = schoolData.statirsToCenterSlopeArea;
                    // 左边
                    tmpStart = tmpPosStart.x;
                    tmpEnd = startPoint.x + Mathf.Min(intoSpace[0].x, intoSpace[1].x);
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }

                    // 右边
                    tmpStart = startPoint.x + Mathf.Max(intoSpace[0].x, intoSpace[1].x);
                    tmpEnd = tmpPosEnd.x;
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosStart.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                }
                // 后面那面墙
                {
                    // 左边
                    tmpStart = tmpPosStart.x;
                    tmpEnd = startPoint.x + Mathf.Min(schoolData.statirsToInsideSlopeArea[0].x, schoolData.statirsToInsideSlopeArea[1].x);

                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }

                    // 楼梯斜墙
                    tmpStart = startPoint.z + schoolData.statirsToInsideSlopeArea[0].z - fenceCornerConf.areaWidth;
                    tmpEnd = startPoint.z + schoolData.statirsToInsideSlopeArea[1].z + fenceCornerConf.areaWidth;
                    tmpF = tmpPosStart.y + (schoolData.statirsToInsideSlopeArea[1].y - schoolData.statirsToInsideSlopeArea[0].y) * 0.5f; // 斜墙高度
                    // 创建楼梯围墙 左上斜墙
                    tmpPos = new Vector3(startPoint.x + schoolData.statirsToInsideSlopeArea[0].x, tmpF, tmpStart + (tmpEnd - tmpStart) * 0.5f);
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(-90, Vector3.up), centerFence);// 墙
                    tmpGo.transform.localScale = new Vector3(tmpS, 1, 1);
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, schoolData.statirsToInsideSlopeArea[1].y - schoolData.statirsToInsideSlopeArea[0].y, tmpEnd - tmpStart);
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }



                    // 创建楼梯围墙 右上斜墙
                    tmpPos.x += schoolData.statirsToInsideWidth;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(-90, Vector3.up), centerFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, schoolData.statirsToInsideSlopeArea[1].y - schoolData.statirsToInsideSlopeArea[0].y, tmpEnd - tmpStart);
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }


                    tmpPos.y += +(schoolData.statirsToInsideSlopeArea[1].y - schoolData.statirsToInsideSlopeArea[0].y) * 0.5f;
                    tmpPos.z += (tmpEnd - tmpStart) * 0.5f;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    tmpPos.x -= schoolData.statirsToInsideWidth;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱








                    // 右边
                    tmpStart = startPoint.x + Mathf.Max(schoolData.statirsToInsideSlopeArea[0].x, schoolData.statirsToInsideSlopeArea[1].x);
                    tmpEnd = tmpPosEnd.x;

                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (float i = 0; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * i, tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpStart + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosEnd.z);
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                }


                // 左右围墙
                {
                    // 上边
                    tmpStart = tmpPosStart.z;
                    tmpEnd = startPoint.z + Mathf.Min(schoolData.centerLeftStatirsArea[0].z, schoolData.centerLeftStatirsArea[1].z);
                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;


                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 1; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 1; i <= tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }





                    Vector3 start = tmpPos;
                    Vector3 end = startPoint + new Vector3(schoolData.centerLeftStatirsArea[1].x, schoolData.centerLeftStatirsArea[1].y, schoolData.centerLeftStatirsArea[0].z);
                    end.x -= fenceCornerConf.areaWidth;
                    tmpF = start.y + (end.y - start.y) * 0.5f; // 斜墙高度
                    // 创建楼梯围墙 左下斜墙
                    tmpPos = new Vector3(start.x + (end.x - start.x) * 0.5f, tmpF, start.z);
                    tmpPos.x -= fenceCornerConf.areaWidth * 0.25f;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), centerFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }
                    // 创建楼梯围墙 左上斜墙
                    tmpPos.z += schoolData.centerLeftStatirsWidth;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), centerFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }

                    // 创建楼梯围墙 右下斜墙
                    tmpPos = new Vector3(tmpPosEnd.x - (end.x - start.x) * 0.5f, tmpF, start.z);
                    tmpPos.x += fenceCornerConf.areaWidth * 0.25f;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(0, Vector3.up), centerFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }
                    // 创建楼梯围墙 右上斜墙
                    tmpPos.z += schoolData.centerLeftStatirsWidth;
                    tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(0, Vector3.up), centerFence);// 墙
                    {
                        MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                        for (int i = 0; i < list.Length; i++) {
                            list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                            Destroy(list[i].GetComponent<BoxCollider>());
                            list[i].gameObject.AddComponent<MeshCollider>();
                        }
                    }

                    tmpPos = new Vector3(end.x, end.y, start.z);
                    tmpPos.x -= fenceCornerConf.areaWidth * 0.5f;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    tmpPos.z += schoolData.centerLeftStatirsWidth;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱

                    tmpPos = startPoint + schoolData.centerRightStatirsArea[1];
                    tmpPos.x += fenceCornerConf.areaWidth * 0.5f;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    tmpPos.z += schoolData.centerLeftStatirsWidth;
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱


                    // 下边
                    tmpStart = startPoint.z + Mathf.Max(schoolData.centerLeftStatirsArea[0].z, schoolData.centerLeftStatirsArea[1].z);
                    tmpEnd = tmpPosEnd.z;

                    tmpH = Mathf.CeilToInt(Mathf.Abs(tmpEnd - tmpStart) / fenceConf.areaWidth); // 数量
                    tmpW = Mathf.Abs(tmpEnd - tmpStart) / tmpH; // 单位宽度
                    tmpS = tmpW / fenceConf.areaWidth;
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }
                    for (int i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * (i + 0.5f));
                        Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), centerFence)
                        .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    }
                    for (float i = 0; i < tmpH; i++) {
                        tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpStart + tmpW * i);
                        Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), centerFence); // 柱
                    }
                }

            }
            #endregion

            #region 传送阵 围墙
            {
                Transform transmitArea = new GameObject("transmitArea").transform;
                transmitArea.SetParent(transform);
                transmitArea.position = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z);

                tmpPosStart = startPoint + new Vector3(schoolData.transmitArea[1].x + fenceCornerConf.areaWidth, schoolData.transmitArea[0].y, schoolData.transmitArea[0].z + fenceCornerConf.areaWidth);
                tmpPosEnd = startPoint + new Vector3(schoolData.transmitArea[0].x - fenceCornerConf.areaWidth, schoolData.transmitArea[1].y, schoolData.transmitArea[1].z - fenceCornerConf.areaWidth);

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / fenceConf.areaWidth); // 数量
                tmpW = Mathf.Abs(tmpPosEnd.x - tmpPosStart.x) / tmpH; // 单位宽度
                tmpS = tmpW / fenceConf.areaWidth;
                // 上下墙柱
                for (int i = 0; i < tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosStart.z);
                    Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), transmitArea)
                    .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                    tmpPos = new Vector3(tmpPosStart.x + tmpW * (i + 0.5f), tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180, Vector3.up), transmitArea)
                    .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                }
                for (float i = 0; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x + tmpW * i, tmpPosStart.y, tmpPosStart.z);
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), transmitArea); // 柱
                    tmpPos = new Vector3(tmpPosStart.x + tmpW * i, tmpPosStart.y, tmpPosEnd.z);
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), transmitArea); // 柱
                }

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / fenceConf.areaWidth); // 数量
                tmpW = Mathf.Abs(tmpPosEnd.z - tmpPosStart.z) / tmpH; // 单位宽度
                tmpS = tmpW / fenceConf.areaWidth;
                // 右墙柱
                for (int i = 0; i < tmpH; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + tmpW * (i + 0.5f));
                    Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), transmitArea)
                    .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                }
                for (float i = 1; i < tmpH; i++) {
                    tmpPos = new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z + tmpW * i);
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), transmitArea); // 柱
                }

                //  startPoint + new Vector3(schoolData.transmitArea[1].x

                tmpH = Mathf.CeilToInt(Mathf.Abs(tmpPosEnd.z - (startPoint.z + schoolData.transmitStatirs[1].z)) / fenceConf.areaWidth); // 数量
                tmpW = Mathf.Abs(tmpPosEnd.z - (startPoint.z + schoolData.transmitStatirs[1].z)) / tmpH; // 单位宽度
                tmpS = tmpW / fenceConf.areaWidth;
                // 右墙柱
                for (int i = 0; i < tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + tmpW * (i + 0.5f));
                    Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), transmitArea)
                    .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                }
                for (float i = 1; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + tmpW * i);
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), transmitArea); // 柱
                }


                tmpH = Mathf.CeilToInt(Mathf.Abs((startPoint.z + schoolData.transmitStatirs[0].z) - tmpPosStart.z) / fenceConf.areaWidth); // 数量
                tmpW = Mathf.Abs((startPoint.z + schoolData.transmitStatirs[0].z) - tmpPosStart.z) / tmpH; // 单位宽度
                tmpS = tmpW / fenceConf.areaWidth;
                // 右墙柱
                for (int i = 0; i < tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosEnd.z - tmpW * (i + 0.5f));
                    Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 2) * 180 + 90, Vector3.up), transmitArea)
                    .transform.localScale = new Vector3(tmpS, 1, 1); // 墙
                }
                for (float i = 1; i <= tmpH; i++) {
                    tmpPos = new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosEnd.z - tmpW * i);
                    Instantiate(fenceCornerPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 4) * 90, Vector3.up), transmitArea); // 柱
                }




                Vector3 start = startPoint + schoolData.transmitStatirs[0];
                start.x += fenceCornerConf.areaWidth;
                Vector3 end = startPoint + schoolData.transmitStatirs[1];
                end.x -= fenceCornerConf.areaWidth;
                tmpPos = new Vector3(start.x + (end.x - start.x) * 0.5f, start.y + (end.y - start.y) * 0.5f, start.z); // 斜墙位置
                tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), transmitArea);// 墙
                {
                    MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                    for (int i = 0; i < list.Length; i++) {
                        list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                        Destroy(list[i].GetComponent<BoxCollider>());
                        list[i].gameObject.AddComponent<MeshCollider>();
                    }
                }

                tmpPos.z += end.z - start.z;
                tmpGo = Instantiate(fencePrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), transmitArea);// 墙
                {
                    MeshFilter[] list = tmpGo.GetComponentsInChildren<MeshFilter>();
                    for (int i = 0; i < list.Length; i++) {
                        list[i].mesh = MeshTools.ModifyMeshToStairway(list[i].mesh, Mathf.Abs(end.y - start.y), Mathf.Abs(end.x - start.x));
                        Destroy(list[i].GetComponent<BoxCollider>());
                        list[i].gameObject.AddComponent<MeshCollider>();
                    }
                }

            }
            #endregion


            //#region 中殿宗主模型
            //{
            //    Mesh playerMesh = Instantiate(g.units.player.mono.gameObject.transform.Find("UMARenderer").GetComponent<SkinnedMeshRenderer>().sharedMesh);
            //    //Mesh playerMesh = Instantiate(g.units.player.mono.gameObject.transform.Find("UMARenderer").GetComponent<SkinnedMeshRenderer>().BakeMesh);
            //    GameObject go = new GameObject();
            //    go.name = "playerMesh";
            //    go.transform.SetParent(transform);
            //    //playerMesh.RecalculateBounds();
            //    go.AddComponent<MeshFilter>().mesh = playerMesh; //得到meshfilter组件
            //    go.AddComponent<MeshRenderer>().material = CommonTools.LoadResources<Material>("Material/StandardGray");
            //    go.AddComponent<MeshCollider>();
            //    go.transform.position = startPoint + (schoolData.outsideCenterArea[0] + (schoolData.outsideCenterArea[1] - schoolData.outsideCenterArea[0]) * 0.5f);
            //}
            //#endregion



            Transform schoolHouse = new GameObject("schoolHouse").transform;
            schoolHouse.SetParent(transform);
            Transform schoolTree = new GameObject("schoolTree").transform;
            schoolTree.SetParent(transform);

            #region 传送阵建筑
            // 外门建筑区域
            tmpPosStart = startPoint + schoolData.transmitArea[0];
            tmpPosEnd = startPoint + schoolData.transmitArea[1];
            tmpPos = tmpPosStart + (tmpPosEnd - tmpPosStart) * 0.5f;
            tmpGo = Instantiate(transmitHousePrefab, tmpPos, Quaternion.AngleAxis(-90, Vector3.up), schoolHouse);// 传送阵

            #endregion

            #region 外门弟子建筑
            tmpPosStart = startPoint + new Vector3(schoolData.outsideLeftArea[0].x - wallCornerConf.areaWidth * 1.5f, schoolData.outsideLeftArea[0].y, schoolData.outsideLeftArea[0].z + wallCornerConf.areaWidth * 1.5f);
            tmpPosEnd = startPoint + new Vector3(schoolData.outsideLeftArea[1].x + wallCornerConf.areaWidth * 1.5f, schoolData.outsideLeftArea[0].y, schoolData.outsideLeftArea[1].z - wallCornerConf.areaWidth * 1.5f);

            tmpF = tmpPosStart.x + (tmpPosEnd.x - tmpPosStart.x) * 0.65f;
            for (float x = tmpPosStart.x; ;) {
                if (x == tmpPosStart.x) {
                    // 第一盆树
                    x -= flowerbedConf.areaWidth;
                    tmpPos = new Vector3(x, tmpPosStart.y, tmpPosStart.z + flowerbedConf.areaWidth * 1.5f);
                    // 花盆下
                    Object.Instantiate(flowerbedPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);
                    // 树下
                    tmpPos = tmpPos + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                    Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);


                    tmpPos = new Vector3(x, tmpPosStart.y, tmpPosEnd.z - flowerbedConf.areaWidth * 1.5f);
                    // 花盆上
                    Object.Instantiate(flowerbedPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);
                    // 树上
                    tmpPos = tmpPos + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                    Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);
                    x -= flowerbedConf.areaWidth;
                }
                x -= outHouseConf.areaWidth * 0.5f;
                // 房子下
                tmpPos = new Vector3(x, tmpPosStart.y, tmpPosStart.z + outHouseConf.areaLong * 0.5f);
                Object.Instantiate(outHousePrefab, tmpPos, Quaternion.AngleAxis(180, Vector3.up), schoolHouse);

                // 房子上
                tmpPos = new Vector3(x, tmpPosStart.y, tmpPosEnd.z - outHouseConf.areaLong * 0.5f);
                Object.Instantiate(outHousePrefab, tmpPos, Quaternion.AngleAxis(0, Vector3.up), schoolHouse);
                x -= outHouseConf.areaWidth * 0.5f;

                x -= flowerbedConf.areaWidth;
                tmpPos = new Vector3(x, tmpPosStart.y, tmpPosStart.z + flowerbedConf.areaWidth * 1.5f);
                // 花盆下
                Object.Instantiate(flowerbedPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);
                // 树下
                tmpPos = tmpPos + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);


                tmpPos = new Vector3(x, tmpPosStart.y, tmpPosEnd.z - flowerbedConf.areaWidth * 1.5f);
                // 花盆上
                Object.Instantiate(flowerbedPrefab, tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);
                // 树上
                tmpPos = tmpPos + new Vector3(rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth, 0, rand.Next(-100, 100) * 0.002f * flowerbedConf.areaWidth);
                Instantiate<GameObject>(treePrefabs[rand.Next(0, treePrefabs.Length)], tmpPos, Quaternion.AngleAxis(rand.Next(0, 360), Vector3.up), schoolTree);
                x -= flowerbedConf.areaWidth;

                yield return CheckWait();
                if (x < tmpF) {
                    tmpF = x;
                    break;
                }

            }
            #endregion

            #region 外门小树林
            {
                tmpL = 0.2f;
                tmpGo = MeshTools.NewMeshObj("外门小树林围栏", (vertices, triangles, normals, uv) => {
                    MeshTools.AddCube(new Vector3(tmpF - tmpL, tmpPosStart.y - tmpL, tmpPosStart.z + tmpL), new Vector3(tmpPosEnd.x + tmpL, tmpPosStart.y + tmpL, tmpPosStart.z + tmpL + tmpL), vertices, triangles, normals, uv, rand);
                    MeshTools.AddCube(new Vector3(tmpF - tmpL, tmpPosStart.y - tmpL, tmpPosEnd.z - tmpL), new Vector3(tmpPosEnd.x + tmpL, tmpPosStart.y + tmpL, tmpPosEnd.z - tmpL - tmpL), vertices, triangles, normals, uv, rand);
                    MeshTools.AddCube(new Vector3(tmpF - tmpL, tmpPosStart.y - tmpL, tmpPosStart.z + tmpL + tmpL), new Vector3(tmpF - tmpL - tmpL, tmpPosStart.y + tmpL, tmpPosEnd.z - tmpL - tmpL), vertices, triangles, normals, uv, rand);
                    MeshTools.AddCube(new Vector3(tmpPosEnd.x + tmpL, tmpPosStart.y - tmpL, tmpPosStart.z + tmpL + tmpL), new Vector3(tmpPosEnd.x + tmpL + tmpL, tmpPosStart.y + tmpL, tmpPosEnd.z - tmpL - tmpL), vertices, triangles, normals, uv, rand);
                }, stoneMat);
                tmpGo.transform.SetParent(transform, false);
                tmpGo.transform.position = default;

                tmpW = 0.15f;
                tmpGo = MeshTools.NewMeshObj("外门小树林草地", (vertices, triangles, normals, uv) => {
                    MeshTools.AddCube(new Vector3(tmpF - tmpL - tmpW, tmpPosStart.y - tmpW, tmpPosStart.z + tmpL + tmpW), new Vector3(tmpPosEnd.x + tmpL + tmpW, tmpPosStart.y + tmpW, tmpPosEnd.z - tmpL - tmpW), vertices, triangles, normals, uv, rand);
                }, grassMat);
                tmpGo.transform.SetParent(transform, false);
                tmpGo.transform.position = default;

                // 计算竹林区域
                tmpPos = new Vector3(tmpF - tmpL - tmpW, tmpPosStart.y, tmpPosStart.z + tmpL + tmpW);
                tmpPosEnd = new Vector3(tmpPosEnd.x + tmpL + tmpW, tmpPosStart.y + tmpW, tmpPosEnd.z - tmpL - tmpW);
                tmpPosStart = tmpPos;



                List<Vector3[]> ways = new List<Vector3[]>();
                // 计算竹林道路
                /*
                                                 * * * * * * * * *
                                                   * * * * * * * *
                                                     * * * * * * *
                                               *       * * * * * *
                                               * *       * * * * *
                                               * * *       * * * *
                                               * * * *       * * *
                 * * * * * * * * * * * * * * * * * * * *       * *
                 * * * * * * * * * * * * * * * * * * * * *       *
                 * * * * * * * * * * * * * * * * * * * * * *   
                 * * * * * * * * * * * * * * * * * * * * * * * 
                 * * * * * * * * * * * * * * * * * * * * * *       
                 * * * * * * * * * * * * * * * * * * * * *       * 
                 * * * * * * * * * * * * * * * * * * * *       * * 
                 * * * * * * * * * * * * * * * * * * *       * * * 
                 * * * * * * * * * * * * * * * * * *       * * * *
                 * * * * * * * * * * * * * * * * *       * * * * * 
                 * * * * * * * * * * * * * * * *       * * * * * * 
                 * * * * * * * * * * * * * * *       * * * * * * *
                 * * * * * * * * * * * * * *       * * * * * * * *
                 * * * * * * * * * * * * *       * * * * * * * * *
                 */
                int treeWitdh = 10;
                int treeSize = 10;
                int placeSize = 20;
                List<Vector3> way = new List<Vector3>();
                way.Add(new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z + (tmpPosEnd.z - tmpPosStart.z) * rand.Next(40, 60) * 0.01f)); // 起点
                way.Add(way[0] + new Vector3(0, 0, treeWitdh));
                way.Add(new Vector3(tmpPosEnd.x - (tmpPosEnd.x - tmpPosStart.x) * rand.Next(40, 60) * 0.01f, tmpPosEnd.y, tmpPosEnd.z) + new Vector3(0, 0, -treeSize)); // 转点
                way.Add(way[2] + new Vector3(-treeWitdh, 0, 0));
                ways.Add(way.ToArray());

                way[0] = new Vector3(tmpPosEnd.x, tmpPosEnd.y, tmpPosEnd.z - (tmpPosEnd.z - tmpPosStart.z) * rand.Next(45, 55) * 0.01f) + new Vector3(treeSize, 0, 0); // 终点
                way[1] = way[0] + new Vector3(0, 0, -treeWitdh);
                ways.Add(way.ToArray());

                float wayZ = tmpPosStart.z + treeSize + placeSize;
                float wayX = tmpPosEnd.x + treeSize + placeSize;
                ways.Add(new Vector3[]{
                    new Vector3(tmpPosEnd.x + treeSize,tmpPosStart.y,  tmpPosStart.z + treeSize),
                    new Vector3(tmpPosEnd.x + treeSize,tmpPosStart.y,  wayZ),
                    new Vector3(wayX, tmpPosStart.y,  wayZ),
                    new Vector3(wayX, tmpPosStart.y,  tmpPosStart.z + treeSize),
                });

                way.Clear();
                way.Add(new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosStart.z));
                way.Add(new Vector3(tmpPosStart.x, tmpPosStart.y, tmpPosEnd.z));
                way.Add(new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosEnd.z));
                way.Add(new Vector3(tmpPosEnd.x, tmpPosStart.y, tmpPosStart.z));
                Vector3[] treeArea = way.ToArray(); // 竹林范围
                Vector2 treeAreaSize = new Vector2(Mathf.Abs(tmpPosStart.x - tmpPosEnd.x), Mathf.Abs(tmpPosStart.z - tmpPosEnd.z));
                // 创建竹林
                tmpW = treeAreaSize.x * treeAreaSize.y * 4; // 大概要创建多大面积的竹林
                tmpGo = new GameObject();
                while (tmpW > 0) {
                    float x = rand.Next(0, int.MaxValue) % 10000 * 0.0001f;
                    float z = rand.Next(0, int.MaxValue) % 10000 * 0.0001f;
                    Debug.Log(x + " , " + z);
                    tmpPos = new Vector3(tmpPosStart.x + (tmpPosEnd.x - tmpPosStart.x) * x, tmpPosStart.y, tmpPosStart.z + (tmpPosEnd.z - tmpPosStart.z) * z);
                    tmpGo.transform.position = tmpPos;
                    tmpGo.transform.eulerAngles = new Vector3(0, rand.Next(0, 360), 0);
                    int randIdx = rand.Next(0, bambooPrefab.Length);
                    ConfSchoolFloorItem randConf = bambooConf[randIdx];
                    if ((MathTools.PointIsInPolygon(treeArea, tmpPos + tmpGo.transform.forward * randConf.areaLong * 0.5f))
                        && (MathTools.PointIsInPolygon(treeArea, tmpPos + tmpGo.transform.forward * randConf.areaLong * -0.5f))
                        && (MathTools.PointIsInPolygon(treeArea, tmpPos + tmpGo.transform.right * randConf.areaWidth * 0.5f))
                        && (MathTools.PointIsInPolygon(treeArea, tmpPos + tmpGo.transform.right * randConf.areaWidth * -0.5f))) {
                        // 在竹林内

                        bool onWay = false;

                        for (int i = 0; i < ways.Count; i++) {
                            if (MathTools.PointIsInPolygon(ways[i], tmpPos)) {
                                onWay = true;
                                break;
                            }
                        }

                        if (onWay) {
                            // 创建卵石

                        } else {
                            for (int i = 0; i < ways.Count; i++) {
                                if (MathTools.PointIsInPolygon(ways[i], tmpPos + tmpGo.transform.forward * randConf.areaLong * 0.5f)) {
                                    onWay = true;
                                    break;
                                }
                                if (MathTools.PointIsInPolygon(ways[i], tmpPos + tmpGo.transform.forward * randConf.areaLong * -0.5f)) {
                                    onWay = true;
                                    break;
                                }
                                if (MathTools.PointIsInPolygon(ways[i], tmpPos + tmpGo.transform.right * randConf.areaWidth * 0.5f)) {
                                    onWay = true;
                                    break;
                                }
                                if (MathTools.PointIsInPolygon(ways[i], tmpPos + tmpGo.transform.right * randConf.areaWidth * -0.5f)) {
                                    onWay = true;
                                    break;
                                }
                            }
                            if (!onWay) {
                                float y = rand.Next(0, int.MaxValue) % 10000 * 0.0001f;
                                tmpPos.y -= randConf.areaHeight * Mathf.Lerp(0, 0.3f, y);
                                Instantiate<GameObject>(bambooPrefab[randIdx], tmpPos, tmpGo.transform.rotation, schoolTree);
                                tmpW -= randConf.areaLong * randConf.areaWidth; // 减去创建的面积的竹林
                            }
                        }
                    }
                }
                Destroy(tmpGo);


                // 测试玩家位置
                tmpPos = ways[ways.Count - 1][0];
                g.units.player.mono.transform.position = tmpPos;
            }

            #endregion




        }


        private GameObject Instantiate(GameObject prefab, Vector3 pos, Quaternion q, Transform parent) {
            return GameObject.Instantiate<GameObject>(prefab, pos, q, parent);
        }

        private void DrawLine(Vector3[] pos) {
            List<Vector3> v = new List<Vector3>(pos);
            v.Add(v[0]);
            var r = new GameObject().AddComponent<LineRenderer>();
            r.positionCount = v.Count;
            r.SetPositions(v.ToArray());

        }
    }
}