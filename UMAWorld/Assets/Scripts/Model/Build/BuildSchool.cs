using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace UMAWorld {
    /// <summary>
    /// 宗门建筑基础
    /// </summary>
    public class BuildSchool : BuildBase {

        public BuildSchool() {
            // 生成一个新宗门的数据，纯逻辑
            // 找一个合适的位置来生成建筑
            ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(g.builds.allBuild.Count);
            bool ok;
            do {
                position = new Point2(CommonTools.Random(conf.minPos[0], conf.maxPos[0]), CommonTools.Random(conf.minPos[1], conf.maxPos[1]));
                ok = true;
                foreach (BuildBase build in g.builds.allBuild.Values) {
                    if (Point2.Distance(position, build.position) < conf.minDis) {
                        ok = false;
                        break;
                    }
                }
            } while (!ok);
            // 随机区域顶点数
            int vertexCount = CommonTools.Random(conf.minVertexCount, conf.maxVertexCount + 1);
            points = new Point2[vertexCount];
            Point2[] northWall = new Point2[2]; // 记录北墙 即y坐标最大
            Point2[] southWall = new Point2[2]; // 记录南墙 即y坐标最小
                                                  // 计算每一个顶点 
            for (int i = 0; i < vertexCount; i++) {
                int radius = CommonTools.Random(conf.minRadius, conf.maxRadius);
                float x = radius * Mathf.Cos(2 * Mathf.PI * (i + 1) / vertexCount);
                float y = radius * Mathf.Sin(2 * Mathf.PI * (i + 1) / vertexCount);
                points[i].x = position.x + x;
                points[i].y = position.y + y;

                Point2 pos = new Point2(x, y);

                if (southWall[0] == default) {
                    southWall[0] = pos;
                } else if (southWall[1] == default) {
                    southWall[1] = pos;
                } else {
                    int idx = southWall[0].y > southWall[1].y ? 0 : 1;
                    if (pos.y < southWall[idx].y) {
                        southWall[idx] = pos;
                    }
                }

                if (northWall[0] == default) {
                    northWall[0] = pos;
                } else if (northWall[1] == default) {
                    northWall[1] = pos;
                } else {
                    int idx = northWall[0].y < northWall[1].y ? 0 : 1;
                    if (pos.y > northWall[idx].y) {
                        northWall[idx] = pos;
                    }
                }
            }

            List<Point2> wayPoints = new List<Point2>();
            // 生成宗门道路
            // 1.坐北朝南 从最南面的墙取一个点作为大门
            doorPosition = southWall[0] + (southWall[1] - southWall[0]) * CommonTools.Random(0.4f, 0.6f);
            wayPoints.Add(doorPosition);
            // 在中心点下方创建路点 设为外殿坐标


            // 在中心点上方创建路点 设为内殿坐标



            // 生成宗门建筑


        }
    }
}