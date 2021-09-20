using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace UMAWorld
{
    /// <summary>
    /// 宗门建筑基础
    /// </summary>
    public class BuildSchool
    {
        public SchoolBuildData data;
        
        /// <summary>
        /// 配置ID
        /// </summary>
        /// 
        // 随机生成器
        public System.Random rand;

        /// <summary>
        /// mono对象
        /// </summary>
        public BuildMono mono;

        // 宗门区域
        public Vector3[] points;
        // 区域用两个坐标表示，起点的左边和终点的右边
        // 楼梯斜面区域
        public Vector3[][] statirsSlopeArea;
        // 楼梯平台区域
        public Vector3[][] statirsSpaceArea;
        // 楼梯级数
        public int[] statirsStep;

        // 外殿区域
        public Vector3[] outsideArea;
        // 外殿中间区域
        public Vector3[] outsideCenterArea;
        // 外殿左楼梯
        public Vector3[] outsideLeftStatirsArea;
        // 外殿右楼梯
        public Vector3[] outsideRightStatirsArea;
        // 外殿左区域
        public Vector3[] outsideLeftArea;
        // 外殿右区域
        public Vector3[] outsideRightArea;

        // 通往中殿楼梯
        public Vector3[] statirsToCenterSlopeArea;

        // 中殿区域
        public Vector3[] centerArea;
        // 中殿中间区域
        public Vector3[] centerCenterArea;
        // 外殿左楼梯
        public Vector3[] centerLeftStatirsArea;
        // 外殿右楼梯
        public Vector3[] centerRightStatirsArea;
        // 中殿左区域
        public Vector3[] centerLeftArea;
        // 中殿右区域
        public Vector3[] centerRightArea;

        // 通往内殿楼梯
        public Vector3[] statirsToInsideSlopeArea;

        // 内殿区域
        public Vector3[] insideArea;

        // 从传送阵走出来的楼梯
        public Vector3[] transmitStatirs;
        // 传送阵区域
        public Vector3[] transmitArea;


        // 楼梯宽度
        public float statirsWidth = 4;
        public float outsideLeftStatirsWidth = 6;
        public float outsideRightStatirsWidth = 6;
        public float statirsToCenterWidth = 9;
        public float centerLeftStatirsWidth = 6;
        public float centerRightStatirsWidth = 6;
        public float statirsToInsideWidth = 6;
        public float transmitStatirsWidth = 4;


        // 楼梯级数
        public int statirsOutStep = 5;
        public int statirsCenterStep = 5;
        public int statirsToCenterStep = 9;
        public int statirsToInsideStep = 15;
        public int transmitStatirsStep = 9;

        /// <summary>
        /// 初始化宗门位置获得生成的坐标
        /// </summary>
        public SchoolBuildData InitBuild(string schoolName)
        {
            Debug.Log("初始化宗门位置获得生成的坐标 开始");
            data = new SchoolBuildData();
            data.id = schoolName;
            // 生成宗门构建建筑的随机种子
            data.seed = CommonTools.Random(int.MinValue, int.MaxValue);

            // 生成一个新宗门的数据，纯逻辑
            data.confId = g.builds.allSchool.Count - 1;
            // 找一个合适的位置来生成建筑
            ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(data.confId);
            bool ok;
            do
            { // TODO 要避免死循环
                data.mainGatePosX = CommonTools.Random(conf.minPos[0], conf.maxPos[0]);
                data.mainGatePosZ = CommonTools.Random(conf.minPos[1], conf.maxPos[1]);
                ok = true;
                foreach (BuildSchool build in g.builds.allSchool.Values)
                {
                    if (build == this)
                        continue;
                    if (Vector2.Distance(new Vector2(data.mainGatePosX, data.mainGatePosZ), new Vector2(build.data.mainGatePosX, build.data.mainGatePosZ)) < conf.minDis)
                    {
                        ok = false;
                        break;
                    }
                }
            } while (!ok);
            Debug.Log("初始化宗门位置获得生成的坐标 完成 =>"+ new Vector3(data.mainGatePosX, 0, data.mainGatePosZ));
            return data;
        }

        public float Random(float a, float b)
        {
            return Mathf.Lerp(a, b, rand.Next(10000) * 0.0001f);
        }

        public int Random(int a, int b)
        {
            return rand.Next(a, b);
        }

        public bool isOnArea(Vector3 point)
        {
            if (this is BuildSchool)
            {
                return MathTools.PointIsInPolygon((this as BuildSchool).points, point);
            }
            else
            {
                return false;
            }
        }

        public void InitData(SchoolBuildData data) {
            this.data = data;
            rand = new System.Random(data.seed);
            // 楼梯一阶20CM高，长度40CM，一共99阶，随机楼梯段数3-5
            // 随机段数
            int statirsCount = Random(3, 6);
            // 楼梯总长度 = 40 * 99
            int statirsStepCount = 199;
            // 预估每段台阶的级数
            int oneStatirs = statirsStepCount / statirsCount;
            statirsSlopeArea = new Vector3[statirsCount][];
            statirsStep = new int[statirsCount];
            statirsSpaceArea = new Vector3[statirsCount][];
            // 已知大门坐标 mainGatePos 大门往前5米开始楼梯, 楼梯宽度200
            Vector3 curPoint = new Vector3(-statirsWidth * 0.5f, 0, 1.5f);
            Vector3 tmpPoint = default;
            #region 上山楼梯
            {
                for (int i = 0; i < statirsCount; i++) {
                    statirsStep[i] = (int)(oneStatirs * Random(0.5f, 1.5f));
                    if (statirsStep[i] > statirsStepCount || statirsCount == (i + 1))
                        statirsStep[i] = statirsStepCount;
                    statirsStepCount -= statirsStep[i];
                    statirsSlopeArea[i] = new Vector3[2];
                    statirsSlopeArea[i][0] = curPoint; // 楼梯起点
                    curPoint = new Vector3(curPoint.x + statirsWidth, curPoint.y + statirsStep[i] * 0.2f, curPoint.z + statirsStep[i] * 0.4f);
                    statirsSlopeArea[i][1] = curPoint; // 楼梯终点

                    int spaceLong = (int)(oneStatirs * Random(1.25f, 1.75f));
                    statirsSpaceArea[i] = new Vector3[2];
                    if (statirsCount == (i + 1)) {
                        spaceLong /= 2;
                        statirsSpaceArea[i][0] = new Vector3(curPoint.x + statirsWidth, curPoint.y, curPoint.z); // 通往宗门
                        curPoint = new Vector3(curPoint.x - statirsWidth * 2, curPoint.y, curPoint.z + spaceLong);

                        tmpPoint = statirsSpaceArea[i][0];
                        tmpPoint.z += spaceLong * 0.5f;
                    } else {
                        statirsSpaceArea[i][0] = curPoint; // 平面起点
                        curPoint = new Vector3(curPoint.x - spaceLong, curPoint.y, curPoint.z + statirsWidth);
                    }
                    statirsSpaceArea[i][1] = curPoint; // 平面终点
                }
            }
            #endregion

            #region 传送阵
            tmpPoint.z -= transmitStatirsWidth * 0.5f;
            transmitStatirs = new Vector3[2]{
                new Vector3(tmpPoint.x + transmitStatirsStep * 0.4f, tmpPoint.y - transmitStatirsStep * 0.2f, tmpPoint.z),
                new Vector3(tmpPoint.x, tmpPoint.y, tmpPoint.z + transmitStatirsWidth),
            };

            float transmitSize = transmitStatirsWidth * 4;
            transmitArea = new Vector3[2]{
                new Vector3(transmitStatirs[0].x + transmitSize, transmitStatirs[0].y, transmitStatirs[0].z + transmitStatirsWidth * 0.5f - transmitSize * 0.5f),
                new Vector3(transmitStatirs[0].x,transmitStatirs[0].y, transmitStatirs[0].z + transmitStatirsWidth * 0.5f + transmitSize * 0.5f),
            };

            #endregion

            curPoint.x += statirsWidth * 1.5f;

            {
                #region 外殿
                // 设置外殿区域 // 占地面积 长度 130m + 50m + 130m = 310,  宽度50
                int outLong = Random(65, 80); // 有随机
                int outWidth = (int)(outLong * 8 * Random(0.85f, 1.15f));


                outsideArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - outWidth * Random(0.45f, 0.55f)), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + outWidth * Random(0.45f, 0.55f)), curPoint.y, curPoint.z + outLong),
                };
                // 设置外殿中
                outsideCenterArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - outLong * 0.5f), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + outLong * 0.5f), curPoint.y, curPoint.z + outLong),
                };

                // 短楼梯固定阶数 5;
                // 临时左楼梯起点
                tmpPoint = new Vector3(outsideCenterArea[0].x, curPoint.y, curPoint.z + (outsideCenterArea[1].z - outsideCenterArea[0].z) * 0.5f - outsideLeftStatirsWidth * 0.5f);
                // 左楼梯
                outsideLeftStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x - statirsOutStep * 0.4f, tmpPoint.y + statirsOutStep * 0.2f, tmpPoint.z + outsideLeftStatirsWidth),
                };
                tmpPoint = outsideLeftStatirsArea[1];
                // 设置外殿左
                outsideLeftArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, outsideCenterArea[0].z),
                    new Vector3(outsideArea[0].x, tmpPoint.y, outsideCenterArea[1].z),
                };

                // 临时右楼梯起点
                tmpPoint = new Vector3(outsideCenterArea[1].x, curPoint.y, curPoint.z + (outsideCenterArea[1].z - outsideCenterArea[0].z) * 0.5f + outsideRightStatirsWidth * 0.5f);
                // 右楼梯
                outsideRightStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x + statirsOutStep * 0.4f, tmpPoint.y + statirsOutStep * 0.2f, tmpPoint.z - outsideRightStatirsWidth),
                };
                tmpPoint = outsideRightStatirsArea[1];
                // 设置外殿右
                outsideRightArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, outsideArea[0].z),
                    new Vector3(outsideArea[1].x, tmpPoint.y, outsideArea[1].z),
                };

                curPoint.z += outLong;

                // 通往中殿的楼梯 7个台阶
                statirsToCenterSlopeArea = new Vector3[]{
                    new Vector3(curPoint.x - statirsToCenterWidth * 0.5f, curPoint.y, curPoint.z),
                    new Vector3(curPoint.x + statirsToCenterWidth * 0.5f, curPoint.y + statirsToCenterStep * 0.2f , curPoint.z + statirsToCenterStep * 0.4f),
                };
                curPoint = new Vector3(curPoint.x, curPoint.y + statirsToCenterStep * 0.2f, curPoint.z + statirsToCenterStep * 0.4f);
                #endregion
            }


            {
                #region 中殿
                // 设置中殿区域 // 
                int centerLong = Random(65, 80); // 有随机
                int centerWidth = (int)(centerLong * 3.2 * Random(0.85f, 1.15f));

                centerArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - centerWidth * Random(0.45f, 0.55f)), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + centerWidth * Random(0.45f, 0.55f)), curPoint.y, curPoint.z + centerLong),
                };
                // 设置中殿中
                centerCenterArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - centerLong * 0.5f), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + centerLong * 0.5f), curPoint.y, curPoint.z + centerLong),
                };

                // 短楼梯固定阶数 5;
                // 临时左楼梯起点
                tmpPoint = new Vector3(centerCenterArea[0].x, curPoint.y, curPoint.z + (centerCenterArea[1].z - centerCenterArea[0].z) * 0.5f - centerLeftStatirsWidth * 0.5f);
                // 左楼梯
                centerLeftStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x - statirsOutStep * 0.4f, tmpPoint.y + statirsOutStep * 0.2f, tmpPoint.z + centerLeftStatirsWidth),
                };
                tmpPoint = centerLeftStatirsArea[1];
                // 设置中殿左
                centerLeftArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, centerCenterArea[0].z),
                    new Vector3(centerArea[0].x, tmpPoint.y, centerCenterArea[1].z),
                };

                // 临时右楼梯起点
                tmpPoint = new Vector3(centerCenterArea[1].x, curPoint.y, curPoint.z + (centerCenterArea[1].z - centerCenterArea[0].z) * 0.5f + centerRightStatirsWidth * 0.5f);
                // 右楼梯
                centerRightStatirsArea = new Vector3[]{
                    tmpPoint,
                    new Vector3(tmpPoint.x + statirsOutStep * 0.4f, tmpPoint.y + statirsOutStep * 0.2f, tmpPoint.z - centerRightStatirsWidth),
                };
                tmpPoint = centerRightStatirsArea[1];
                // 设置中殿右
                centerRightArea = new Vector3[]{
                    new Vector3(tmpPoint.x, tmpPoint.y, centerArea[0].z),
                    new Vector3(centerArea[1].x, tmpPoint.y, centerArea[1].z),
                };

                curPoint.z += centerLong;

                // 通往内殿的楼梯 9个台阶
                statirsToInsideSlopeArea = new Vector3[]{
                    new Vector3(curPoint.x - statirsToInsideWidth * 0.5f, curPoint.y, curPoint.z),
                    new Vector3(curPoint.x + statirsToInsideWidth * 0.5f, curPoint.y + statirsToInsideStep * 0.2f , curPoint.z + statirsToInsideStep * 0.4f),
                };
                curPoint = new Vector3(curPoint.x, curPoint.y + statirsToInsideStep * 0.2f, curPoint.z + statirsToInsideStep * 0.4f);
                #endregion
            }

            // 内殿
            {
                int insideLong = Random(80, 100); // 有随机
                int insideWidth = (int)(insideLong * Random(0.85f, 1.15f));

                insideArea = new Vector3[]{
                    new Vector3((int)(curPoint.x - insideWidth * 0.5f), curPoint.y, curPoint.z),
                    new Vector3((int)(curPoint.x + insideWidth * 0.5f), curPoint.y, curPoint.z + insideLong),
                };
            }

            Vector3 gatePos = new Vector3(data.mainGatePosX, 0, data.mainGatePosZ);
            List<Vector3> list = new List<Vector3>();
            list.Add(new Vector3());
            for (int i = 0; i < statirsSlopeArea.Length; i++) {
                list.AddRange(statirsSlopeArea[i]);
            }
            for (int i = 0; i < statirsSpaceArea.Length; i++) {
                list.AddRange(statirsSpaceArea[i]);
            }
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
            foreach (Vector3 pos in list)
            {
                Vector3 p = pos + gatePos;
                minX = minX < p.x ? minX : p.x;
                minZ = minZ < p.z ? minZ : p.z;
                maxX = maxX > p.x ? maxX : p.x;
                maxZ = maxZ > p.z ? maxZ : p.z;
            }
            points = new Vector3[] { new Vector3(minX, 0, minZ), new Vector3(minX, 0, maxZ), new Vector3(maxX, 0, maxZ), new Vector3(maxX, 0, minZ) };
        }
    }
}