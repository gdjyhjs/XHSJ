using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 宗门建筑基础
/// </summary>
public class BuildSchool:BuildBase {

    public BuildSchool() {
        // 生成一个新宗门的数据，纯逻辑
        // 找一个合适的位置来生成建筑
        ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(g.builds.allBuild.Count);
        bool ok;
        do {
            position = new Vector2(CommonTools.Random(conf.minPos[0], conf.maxPos[0]), CommonTools.Random(conf.minPos[1], conf.maxPos[1]));
            ok = true;
            foreach (BuildBase build in g.builds.allBuild.Values) {
                if (Vector2.Distance(position, build.position) < conf.minDis) {
                    ok = false;
                    break;
                }
            }
        } while (!ok);
        // 随机区域顶点数
        int vertexCount = CommonTools.Random(conf.minVertexCount, conf.maxVertexCount + 1);
        points_x = new float[vertexCount];
        points_y = new float[vertexCount];
        Vector2[] southWall = new Vector2[2]; // 记录南墙 即y坐标最小
        // 计算每一个顶点 
        for (int i = 0; i < vertexCount; i++) {
            int radius = CommonTools.Random(conf.minRadius, conf.maxRadius);
            float x = radius * Mathf.Cos(2 * Mathf.PI * (i + 1) / vertexCount);
            float y = radius * Mathf.Sin(2 * Mathf.PI * (i + 1) / vertexCount);
            points_x[i] = position.x + x;
            points_y[i] = position.y + y;
            Vector2 pos = new Vector2(x, y);
            if (southWall[0] == default) {
                southWall[0] = pos;
            } else if (southWall[1] == default) {
                southWall[1] = pos;
            } else {
                int idx = southWall[0].y > southWall[1].y ? 0:1;
                if (pos.y < southWall[idx].y) {
                    southWall[idx] = pos;
                }
            }
        }

        List<Vector2> wayPoints = new List<Vector2>();
        // 生成宗门道路
        // 1.坐北朝南 从最南面的墙取一个点作为大门
        doorPosition = southWall[0] + (southWall[1] - southWall[0]) * CommonTools.Random(0.4f, 0.6f);
        wayPoints.Add(doorPosition);
        // 在中心点下方创建两个路点
        // 在中心点上方创建两个路点



        // 生成宗门建筑


    }
}
