using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 宗门建筑基础
/// </summary>
public class BuildSchool:BuildBase {

    public BuildSchool() {
        // 找一个合适的位置来生成建筑
        ConfSchoolBuildItem conf = g.conf.schoolBuild.GetItem(g.builds.allBuild.Count);
        bool ok;
        do {
            position = new Vector2(StaticTools.Random(conf.minPos[0], conf.maxPos[0]), StaticTools.Random(conf.minPos[1], conf.maxPos[1]));
            ok = true;
            foreach (BuildBase build in g.builds.allBuild.Values) {
                if (Vector2.Distance(position, build.position) < conf.minDis) {
                    ok = false;
                    break;
                }
            }
        } while (!ok);

        int vertexCount = StaticTools.Random(conf.minVertexCount, conf.maxVertexCount + 1);
        points_x = new float[vertexCount];
        points_y = new float[vertexCount];
        for (int i = 0; i < vertexCount; i++) {
            int radius = StaticTools.Random(conf.minRadius, conf.maxRadius);
            float x = radius * Mathf.Sin(2 * Mathf.PI * (i + 1) / vertexCount);
            float y = radius * Mathf.Cos(2 * Mathf.PI * (i + 1) / vertexCount);
            points_x[i] = position.x + x;
            points_y[i] = position.y + y;
        }
    }
}
