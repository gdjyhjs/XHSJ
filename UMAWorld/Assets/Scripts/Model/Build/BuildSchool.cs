using Newtonsoft.Json;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace UMAWorld {
    /// <summary>
    /// 宗门建筑基础
    /// </summary>
    public class BuildSchool : BuildBase {

        #region 在线字段

        // 区域用两个坐标表示，起点的左边和终点的右边
        // 楼梯斜面区域
        [JsonIgnore]
        public Vector3[] statirsSlopeArea1;
        [JsonIgnore]
        public Vector3[] statirsSlopeArea2;
        [JsonIgnore]
        public Vector3[] statirsSlopeArea3;
        [JsonIgnore]
        public Vector3[] statirsSlopeArea4;
        [JsonIgnore]
        public Vector3[] statirsSlopeArea5;
        // 楼梯平台区域
        [JsonIgnore]
        public Vector3[] statirsSpaceArea1;
        [JsonIgnore]
        public Vector3[] statirsSpaceArea2;
        [JsonIgnore]
        public Vector3[] statirsSpaceArea3;
        [JsonIgnore]
        public Vector3[] statirsSpaceArea4;
        [JsonIgnore]
        public Vector3[] statirsSpaceArea5;

        // 外殿区域
        [JsonIgnore]
        public Vector3[] outsideArea;
        // 外殿中间区域
        [JsonIgnore]
        public Vector3[] outsideCenterArea;
        // 外殿左楼梯
        [JsonIgnore]
        public Vector3[] outsideLeftStatirsArea;
        // 外殿右楼梯
        [JsonIgnore]
        public Vector3[] outsideRightStatirsArea;
        // 外殿左区域
        [JsonIgnore]
        public Vector3[] outsideLeftArea;
        // 外殿右区域
        [JsonIgnore]
        public Vector3[] outsideRightArea;

        // 通往中殿楼梯
        [JsonIgnore]
        public Vector3[] statirsToCenterSlopeArea;

        // 中殿区域
        [JsonIgnore]
        public Vector3[] centerArea;
        // 中殿中间区域
        [JsonIgnore]
        public Vector3[] centerCenterArea;
        // 外殿左楼梯
        [JsonIgnore]
        public Vector3[] centerLeftStatirsArea;
        // 外殿右楼梯
        [JsonIgnore]
        public Vector3[] centerRightStatirsArea;
        // 中殿左区域
        [JsonIgnore]
        public Vector3[] centerLeftArea;
        // 中殿右区域
        [JsonIgnore]
        public Vector3[] centerRightArea;

        // 通往内殿楼梯
        [JsonIgnore]
        public Vector3[] statirsToInsideSlopeArea;

        // 内殿区域
        [JsonIgnore]
        public Vector3[] insideArea;
        #endregion



        #region 离线字段
        // 大门坐标
        [JsonProperty(PropertyName = "q")]
        public float[] f_mainGatePos;

        // 区域用两个坐标表示，起点的左边和终点的右边
        // 楼梯斜面区域
        [JsonProperty(PropertyName = "w")]
        public float[] f_statirsSlopeArea1;
        [JsonProperty(PropertyName = "e")]
        public float[] f_statirsSlopeArea2;
        [JsonProperty(PropertyName = "r")]
        public float[] f_statirsSlopeArea3;
        [JsonProperty(PropertyName = "t")]
        public float[] f_statirsSlopeArea4;
        [JsonProperty(PropertyName = "y")]
        public float[] f_statirsSlopeArea5;
        // 楼梯平台区域
        [JsonProperty(PropertyName = "u")]
        public float[] f_statirsSpaceArea1;
        [JsonProperty(PropertyName = "i")]
        public float[] f_statirsSpaceArea2;
        [JsonProperty(PropertyName = "o")]
        public float[] f_statirsSpaceArea3;
        [JsonProperty(PropertyName = "p")]
        public float[] f_statirsSpaceArea4;
        [JsonProperty(PropertyName = "a")]
        public float[] f_statirsSpaceArea5;

        // 外殿区域
        [JsonProperty(PropertyName = "s")]
        public float[] f_outsideArea;
        // 外殿中间区域
        [JsonProperty(PropertyName = "d")]
        public float[] f_outsideCenterArea;
        // 外殿左楼梯
        [JsonProperty(PropertyName = "f")]
        public float[] f_outsideLeftStatirsArea;
        // 外殿右楼梯
        [JsonProperty(PropertyName = "g")]
        public float[] f_outsideRightStatirsArea;
        // 外殿左区域
        [JsonProperty(PropertyName = "h")]
        public float[] f_outsideLeftArea;
        // 外殿右区域
        [JsonProperty(PropertyName = "j")]
        public float[] f_outsideRightArea;

        // 通往中殿楼梯
        [JsonProperty(PropertyName = "k")]
        public float[] f_statirsToCenterSlopeArea;

        // 中殿区域
        [JsonProperty(PropertyName = "l")]
        public float[] f_centerArea;
        // 中殿中间区域
        [JsonProperty(PropertyName = "z")]
        public float[] f_centerCenterArea;
        // 外殿左楼梯
        [JsonProperty(PropertyName = "x")]
        public float[] f_centerLeftStatirsArea;
        // 外殿右楼梯
        [JsonProperty(PropertyName = "c")]
        public float[] f_centerRightStatirsArea;
        // 中殿左区域
        [JsonProperty(PropertyName = "v")]
        public float[] f_centerLeftArea;
        // 中殿右区域
        [JsonProperty(PropertyName = "b")]
        public float[] f_centerRightArea;

        // 通往内殿楼梯
        [JsonProperty(PropertyName = "n")]
        public float[] f_statirsToInsideSlopeArea;

        // 内殿区域
        [JsonProperty(PropertyName = "m")]
        public float[] f_insideArea;

        // 宗门区域
        [JsonProperty(PropertyName = "0")]
        public float[] f_points;


        // 楼梯级数
        [JsonProperty(PropertyName = "1")]
        public int statirsStep1;
        [JsonProperty(PropertyName = "2")]
        public int statirsStep2;
        [JsonProperty(PropertyName = "3")]
        public int statirsStep3;
        [JsonProperty(PropertyName = "4")]
        public int statirsStep4;
        [JsonProperty(PropertyName = "5")]
        public int statirsStep5;
        // 通往中殿楼梯级数
        [JsonProperty(PropertyName = "6")]
        public int statirsToCenterStep;
        // 通往内殿楼梯级数
        [JsonProperty(PropertyName = "7")]
        public int statirsToInsideStep;

        #endregion


        public BuildSchool() {

            // 生成宗门构建建筑的随机种子
            seed = CommonTools.Random(int.MinValue, int.MaxValue);

            // 生成一个新宗门的数据，纯逻辑
            confId = g.builds.allBuild.Count;
            // 找一个合适的位置来生成建筑
            ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(confId);
            bool ok;
            do { // TODO 要避免死循环
                mainGatePos = new Vector3(CommonTools.Random(conf.minPos[0], conf.maxPos[0]), 0, CommonTools.Random(conf.minPos[1], conf.maxPos[1]));
                ok = true;
                foreach (BuildBase build in g.builds.allBuild.Values) {
                    if (Vector3.Distance(mainGatePos, new Vector3(build.mainGatePos[0], build.mainGatePos[1], build.mainGatePos[2])) < conf.minDis) {
                        ok = false;
                        break;
                    }
                }
            } while (!ok);


            // 楼梯一阶20CM高，长度40CM，一共99阶，随机楼梯段数3-5
            // 随机段数
            int statirsCount = CommonTools.Random(3, 6);
            // 楼梯总长度 = 40 * 99
            int statirsStepCount = 99;
            // 预估每段台阶的级数
            int oneStatirs = statirsStepCount / statirsCount;

            // 已知大门坐标 mainGatePos 大门往前5米开始楼梯, 楼梯宽度200
            Vector3 curPoint = mainGatePos + new Vector3(-1, 0, 5);
            Vector3 tmpPoint;
            {
                #region 上山楼梯
                if (0 < statirsCount) {
                    statirsStep1 = (int)(oneStatirs * CommonTools.Random(0.5f, 1.5f));
                    if (statirsStep1 > statirsStepCount || statirsCount == 1)
                        statirsStep1 = statirsStepCount;
                    statirsStepCount -= statirsStep1;
                    statirsSlopeArea1 = new Vector3[2];
                    statirsSlopeArea1[0] = curPoint; // 楼梯起点
                    curPoint = new Vector3(curPoint.x + 2, curPoint.z + statirsStep1 * 0.2f, curPoint.z + statirsStep1 * 0.4f);
                    statirsSlopeArea1[1] = curPoint; // 楼梯终点

                    int spaceLong = (int)(oneStatirs * 0.4f * CommonTools.Random(0.5f, 1.5f));
                    statirsSpaceArea1 = new Vector3[2];
                    statirsSpaceArea1[0] = curPoint; // 平面起点
                    if (statirsCount == 1)
                        curPoint = new Vector3(curPoint.x - 2, curPoint.y, curPoint.z + spaceLong);
                    else
                        curPoint = new Vector3(curPoint.x - spaceLong, curPoint.y, curPoint.z + 2);
                    statirsSpaceArea1[1] = curPoint; // 平面终点
                } else {
                    statirsSlopeArea1 = new Vector3[0];
                    statirsSpaceArea1 = new Vector3[0];
                }
                if (1 < statirsCount) {
                    statirsStep2 = (int)(oneStatirs * CommonTools.Random(0.5f, 1.5f));
                    if (statirsStep2 > statirsStepCount || statirsCount == 2)
                        statirsStep2 = statirsStepCount;
                    statirsStepCount -= statirsStep2;
                    statirsSlopeArea2 = new Vector3[2];
                    statirsSlopeArea2[0] = curPoint; // 楼梯起点
                    curPoint = new Vector3(curPoint.x + 2, curPoint.z + statirsStep2 * 0.2f, curPoint.z + statirsStep2 * 0.4f);
                    statirsSlopeArea2[1] = curPoint; // 楼梯终点

                    int spaceLong = (int)(oneStatirs * 0.4f * CommonTools.Random(0.5f, 1.5f));
                    statirsSpaceArea2 = new Vector3[2];
                    statirsSpaceArea2[0] = curPoint; // 平面起点
                    if (statirsCount == 2)
                        curPoint = new Vector3(curPoint.x - 2, curPoint.y, curPoint.z + spaceLong);
                    else
                        curPoint = new Vector3(curPoint.x - spaceLong, curPoint.y, curPoint.z + 2);
                    statirsSpaceArea2[1] = curPoint; // 平面终点
                } else {
                    statirsSlopeArea2 = new Vector3[0];
                    statirsSpaceArea2 = new Vector3[0];
                }
                if (2 < statirsCount) {
                    statirsStep3 = (int)(oneStatirs * CommonTools.Random(0.5f, 1.5f));
                    if (statirsStep3 > statirsStepCount || statirsCount == 3)
                        statirsStep3 = statirsStepCount;
                    statirsStepCount -= statirsStep3;
                    statirsSlopeArea3 = new Vector3[2];
                    statirsSlopeArea3[0] = curPoint; // 楼梯起点
                    curPoint = new Vector3(curPoint.x + 2, curPoint.z + statirsStep3 * 0.2f, curPoint.z + statirsStep3 * 0.4f);
                    statirsSlopeArea3[1] = curPoint; // 楼梯终点

                    int spaceLong = (int)(oneStatirs * 0.4f * CommonTools.Random(0.5f, 1.5f));
                    statirsSpaceArea3 = new Vector3[2];
                    statirsSpaceArea3[0] = curPoint; // 平面起点
                    if (statirsCount == 3)
                        curPoint = new Vector3(curPoint.x - 2, curPoint.y, curPoint.z + spaceLong);
                    else
                        curPoint = new Vector3(curPoint.x - spaceLong, curPoint.y, curPoint.z + 2);
                    statirsSpaceArea3[1] = curPoint; // 平面终点
                } else {
                    statirsSlopeArea3 = new Vector3[0];
                    statirsSpaceArea3 = new Vector3[0];
                }
                if (3 < statirsCount) {
                    statirsStep4 = (int)(oneStatirs * CommonTools.Random(0.5f, 1.5f));
                    if (statirsStep4 > statirsStepCount || statirsCount == 4)
                        statirsStep4 = statirsStepCount;
                    statirsStepCount -= statirsStep4;
                    statirsSlopeArea4 = new Vector3[2];
                    statirsSlopeArea4[0] = curPoint; // 楼梯起点
                    curPoint = new Vector3(curPoint.x + 2, curPoint.z + statirsStep4 * 0.2f, curPoint.z + statirsStep4 * 0.4f);
                    statirsSlopeArea4[1] = curPoint; // 楼梯终点

                    int spaceLong = (int)(oneStatirs * 0.4f * CommonTools.Random(0.5f, 1.5f));
                    statirsSpaceArea4 = new Vector3[2];
                    statirsSpaceArea4[0] = curPoint; // 平面起点
                    if (statirsCount == 4)
                        curPoint = new Vector3(curPoint.x - 2, curPoint.y, curPoint.z + spaceLong);
                    else
                        curPoint = new Vector3(curPoint.x - spaceLong, curPoint.y, curPoint.z + 2);
                    statirsSpaceArea4[1] = curPoint; // 平面终点
                } else {
                    statirsSlopeArea4 = new Vector3[0];
                    statirsSpaceArea4 = new Vector3[0];
                }
                if (4 < statirsCount) {
                    statirsStep5 = (int)(oneStatirs * CommonTools.Random(0.5f, 1.5f));
                    if (statirsStep5 > statirsStepCount || statirsCount == 5)
                        statirsStep5 = statirsStepCount;
                    statirsStepCount -= statirsStep5;
                    statirsSlopeArea5 = new Vector3[2];
                    statirsSlopeArea5[0] = curPoint; // 楼梯起点
                    curPoint = new Vector3(curPoint.x + 2, curPoint.z + statirsStep5 * 0.2f, curPoint.z + statirsStep5 * 0.4f);
                    statirsSlopeArea5[1] = curPoint; // 楼梯终点

                    int spaceLong = (int)(oneStatirs * 0.4f * CommonTools.Random(0.5f, 1.5f));
                    statirsSpaceArea5 = new Vector3[2];
                    statirsSpaceArea5[0] = curPoint; // 平面起点
                    if (statirsCount == 5)
                        curPoint = new Vector3(curPoint.x - 2, curPoint.y, curPoint.z + spaceLong);
                    else
                        curPoint = new Vector3(curPoint.x - 2, curPoint.y, curPoint.z + spaceLong);
                    statirsSpaceArea5[1] = curPoint; // 平面终点
                } else {
                    statirsSlopeArea5 = new Vector3[0];
                    statirsSpaceArea5 = new Vector3[0];
                }
                #endregion
            }
            curPoint.x += 1;

            {
                #region 外殿
                // 设置外殿区域 // 占地面积 长度 130m + 50m + 130m = 310,  宽度50
                int outLong = CommonTools.Random(45, 60); // 有随机
                int outWidth = (int)(outLong * 4 * CommonTools.Random(0.85f, 1.15f));

                outsideArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - outWidth * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + outWidth * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z + outLong),
                };
                // 设置外殿中
                outsideCenterArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - outLong * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + outLong * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z + outLong),
                };

                // 短楼梯固定阶数 5;
                // 临时左楼梯起点
                tmpPoint = new Vector3(outsideCenterArea[0].x, curPoint.y, curPoint.z + (outsideCenterArea[1].z - outsideCenterArea[0].z) * 0.5f - 1);
                // 左楼梯
                outsideLeftStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x - 5 * 0.4f, tmpPoint.y + 5 * 0.2f, tmpPoint.z + 2),
                };
                tmpPoint = outsideLeftStatirsArea[1];
                // 设置外殿左
                outsideLeftArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, outsideCenterArea[0].z),
                    new Vector3(outsideArea[0].x, tmpPoint.y, outsideCenterArea[1].z),
                };

                // 临时右楼梯起点
                tmpPoint = new Vector3(outsideCenterArea[1].x, curPoint.y, curPoint.z + (outsideCenterArea[1].z - outsideCenterArea[0].z) * 0.5f + 1);
                // 右楼梯
                outsideRightStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x + 5 * 0.4f, tmpPoint.y + 5 * 0.2f, tmpPoint.z - 2),
                };
                tmpPoint = outsideRightStatirsArea[1];
                // 设置外殿右
                outsideRightArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, outsideCenterArea[1].z),
                    new Vector3(outsideArea[1].x, tmpPoint.y, outsideArea[1].z),
                };

                curPoint.z += outLong;

                // 通往中殿的楼梯 7个台阶
                statirsToCenterStep = 7;
                statirsToCenterSlopeArea = new Vector3[]{
                    new Vector3(curPoint.x - 1.5f, curPoint.y, curPoint.z),
                    new Vector3(curPoint.x + 1.5f, curPoint.y + statirsToCenterStep * 0.2f , curPoint.z + statirsToCenterStep * 0.4f),
                };
                curPoint += new Vector3(curPoint.x, curPoint.y + statirsToCenterStep * 0.2f, curPoint.z + statirsToCenterStep * 0.4f);
                #endregion
            }


            {
                #region 中殿
                // 设置中殿区域 // 
                int centerLong = CommonTools.Random(65, 80); // 有随机
                int centerWidth = (int)(centerLong * 3.2 * CommonTools.Random(0.85f, 1.15f));

                centerArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - centerWidth * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + centerWidth * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z + centerLong),
                };
                // 设置中殿中
                centerCenterArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - centerLong * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + centerLong * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z + centerLong),
                };

                // 短楼梯固定阶数 5;
                // 临时左楼梯起点
                tmpPoint = new Vector3(centerCenterArea[0].x, curPoint.y, curPoint.z + (centerCenterArea[1].z - centerCenterArea[0].z) * 0.5f - 1);
                // 左楼梯
                centerLeftStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x - 5 * 0.4f, tmpPoint.y + 5 * 0.2f, tmpPoint.z + 2),
                };
                tmpPoint = centerLeftStatirsArea[1];
                // 设置中殿左
                centerLeftArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, centerCenterArea[0].z),
                    new Vector3(centerArea[0].x, tmpPoint.y, centerCenterArea[1].z),
                };

                // 临时右楼梯起点
                tmpPoint = new Vector3(centerCenterArea[1].x, curPoint.y, curPoint.z + (centerCenterArea[1].z - centerCenterArea[0].z) * 0.5f + 1);
                // 右楼梯
                centerRightStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x + 5 * 0.4f, tmpPoint.y + 5 * 0.2f, tmpPoint.z - 2),
                };
                tmpPoint = centerRightStatirsArea[1];
                // 设置中殿右
                centerRightArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, centerCenterArea[1].z),
                    new Vector3(centerArea[1].x, tmpPoint.y, centerArea[1].z),
                };

                curPoint.z += centerLong;

                // 通往内殿的楼梯 9个台阶
                statirsToInsideStep = 9;
                statirsToInsideSlopeArea = new Vector3[]{
                    new Vector3(curPoint.x - 2, curPoint.y, curPoint.z),
                    new Vector3(curPoint.x + 2, curPoint.y + statirsToInsideStep * 0.2f , curPoint.z + statirsToInsideStep * 0.4f),
                };
                curPoint += new Vector3(curPoint.x, curPoint.y + statirsToInsideStep * 0.2f, curPoint.z + statirsToInsideStep * 0.4f);
                #endregion
            }

            // 内殿
            {
                int insideLong = CommonTools.Random(80, 100); // 有随机
                int insideWidth = (int)(insideLong * CommonTools.Random(0.85f, 1.15f));

                insideArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - insideWidth * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + insideWidth * CommonTools.Random(0.45f, 0.55f)), curPoint.y, curPoint.z + insideLong),
                };
            }

            List<Vector3> list = new List<Vector3>();
            list.Add(mainGatePos);
            list.AddRange(statirsSlopeArea1);
            list.AddRange(statirsSlopeArea2);
            list.AddRange(statirsSlopeArea3);
            list.AddRange(statirsSlopeArea4);
            list.AddRange(statirsSlopeArea5);
            list.AddRange(statirsSpaceArea1);
            list.AddRange(statirsSpaceArea2);
            list.AddRange(statirsSpaceArea3);
            list.AddRange(statirsSpaceArea4);
            list.AddRange(statirsSpaceArea5);
            list.AddRange(outsideArea);
            list.AddRange(outsideCenterArea);
            list.AddRange(outsideLeftStatirsArea);
            list.AddRange(outsideRightStatirsArea);
            list.AddRange(outsideLeftArea);
            list.AddRange(outsideRightArea);
            list.AddRange(statirsToCenterSlopeArea);
            list.AddRange(centerArea);
            list.AddRange(centerCenterArea);
            list.AddRange(centerLeftStatirsArea);
            list.AddRange(centerRightStatirsArea);
            list.AddRange(centerLeftArea);
            list.AddRange(centerRightArea);
            list.AddRange(statirsToInsideSlopeArea);
            list.AddRange(insideArea);
            // 储存保存字段 计算宗门区域
            float minX = int.MaxValue, minZ = int.MaxValue, maxX = int.MinValue, maxZ = int.MinValue;
            foreach (Vector3 p in list) {
                minX = minX < p.x ? minX : p.x;
                minZ = minZ< p.z ? minZ : p.z;
                maxX = maxX > p.x ? maxX : p.x;
                maxZ = maxZ > p.z ? maxZ : p.z;
            }
            points = new Vector3[] { new Vector3(minX, 0, minZ), new Vector3(minX, 0, maxZ), new Vector3(maxX, 0, maxZ), new Vector3(maxX, 0, minZ) };
            
            CommonTools.Vector3ToFloat(mainGatePos, out f_mainGatePos);
            CommonTools.Vector3ToFloat(statirsSlopeArea1, out f_statirsSlopeArea1);
            CommonTools.Vector3ToFloat(statirsSlopeArea2, out f_statirsSlopeArea2);
            CommonTools.Vector3ToFloat(statirsSlopeArea3, out f_statirsSlopeArea3);
            CommonTools.Vector3ToFloat(statirsSlopeArea4, out f_statirsSlopeArea4);
            CommonTools.Vector3ToFloat(statirsSlopeArea5, out f_statirsSlopeArea5);
            CommonTools.Vector3ToFloat(statirsSpaceArea1, out f_statirsSpaceArea1);
            CommonTools.Vector3ToFloat(statirsSpaceArea2, out f_statirsSpaceArea2);
            CommonTools.Vector3ToFloat(statirsSpaceArea3, out f_statirsSpaceArea3);
            CommonTools.Vector3ToFloat(statirsSpaceArea4, out f_statirsSpaceArea4);
            CommonTools.Vector3ToFloat(statirsSpaceArea5, out f_statirsSpaceArea5);
            CommonTools.Vector3ToFloat(outsideArea, out f_outsideArea);
            CommonTools.Vector3ToFloat(outsideCenterArea, out f_outsideCenterArea);
            CommonTools.Vector3ToFloat(outsideLeftStatirsArea, out f_outsideLeftStatirsArea);
            CommonTools.Vector3ToFloat(outsideRightStatirsArea, out f_outsideRightStatirsArea);
            CommonTools.Vector3ToFloat(outsideLeftArea, out f_outsideLeftArea);
            CommonTools.Vector3ToFloat(outsideRightArea, out f_outsideRightArea);
            CommonTools.Vector3ToFloat(statirsToCenterSlopeArea, out f_statirsToCenterSlopeArea);
            CommonTools.Vector3ToFloat(centerArea, out f_centerArea);
            CommonTools.Vector3ToFloat(centerCenterArea, out f_centerCenterArea);
            CommonTools.Vector3ToFloat(centerLeftStatirsArea, out f_centerLeftStatirsArea);
            CommonTools.Vector3ToFloat(centerRightStatirsArea, out f_centerRightStatirsArea);
            CommonTools.Vector3ToFloat(centerLeftArea, out f_centerLeftArea);
            CommonTools.Vector3ToFloat(centerRightArea, out f_centerRightArea);
            CommonTools.Vector3ToFloat(statirsToInsideSlopeArea, out f_statirsToInsideSlopeArea);
            CommonTools.Vector3ToFloat(insideArea, out f_insideArea);
            CommonTools.Vector3ToFloat(points, out f_points);
        }

        public override void InitData() {
            base.InitData();

            CommonTools.FloatToVector3(f_mainGatePos, out mainGatePos);
            CommonTools.FloatToVector3(f_statirsSlopeArea1, out statirsSlopeArea1);
            CommonTools.FloatToVector3(f_statirsSlopeArea2, out statirsSlopeArea2);
            CommonTools.FloatToVector3(f_statirsSlopeArea3, out statirsSlopeArea3);
            CommonTools.FloatToVector3(f_statirsSlopeArea4, out statirsSlopeArea4);
            CommonTools.FloatToVector3(f_statirsSlopeArea5, out statirsSlopeArea5);
            CommonTools.FloatToVector3(f_statirsSpaceArea1, out statirsSpaceArea1);
            CommonTools.FloatToVector3(f_statirsSpaceArea2, out statirsSpaceArea2);
            CommonTools.FloatToVector3(f_statirsSpaceArea3, out statirsSpaceArea3);
            CommonTools.FloatToVector3(f_statirsSpaceArea4, out statirsSpaceArea4);
            CommonTools.FloatToVector3(f_statirsSpaceArea5, out statirsSpaceArea5);
            CommonTools.FloatToVector3(f_outsideArea, out outsideArea);
            CommonTools.FloatToVector3(f_outsideCenterArea, out outsideCenterArea);
            CommonTools.FloatToVector3(f_outsideLeftStatirsArea, out outsideLeftStatirsArea);
            CommonTools.FloatToVector3(f_outsideRightStatirsArea, out outsideRightStatirsArea);
            CommonTools.FloatToVector3(f_outsideLeftArea, out outsideLeftArea);
            CommonTools.FloatToVector3(f_outsideRightArea, out outsideRightArea);
            CommonTools.FloatToVector3(f_statirsToCenterSlopeArea, out statirsToCenterSlopeArea);
            CommonTools.FloatToVector3(f_centerArea, out centerArea);
            CommonTools.FloatToVector3(f_centerCenterArea, out centerCenterArea);
            CommonTools.FloatToVector3(f_centerLeftStatirsArea, out centerLeftStatirsArea);
            CommonTools.FloatToVector3(f_centerRightStatirsArea, out centerRightStatirsArea);
            CommonTools.FloatToVector3(f_centerLeftArea, out centerLeftArea);
            CommonTools.FloatToVector3(f_centerRightArea, out centerRightArea);
            CommonTools.FloatToVector3(f_statirsToInsideSlopeArea, out statirsToInsideSlopeArea);
            CommonTools.FloatToVector3(f_insideArea, out insideArea);
            CommonTools.FloatToVector3(f_points, out points);
            Debug.Log("初始化宗门 " + id + " => " + points);
            Debug.Log("初始化宗门 " + id + " => " + points.Length);
        }

        
    }
}