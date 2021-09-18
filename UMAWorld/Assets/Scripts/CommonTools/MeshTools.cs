using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld {
    public static class MeshTools {

        // 添加楼梯
        public static void AddStatirs(Vector3 start, int step, List<Vector3> vertices, List<int> triangles, List<Vector3> normals, List<Vector2> uv, System.Random rand = null) {
            for (int i = 0; i < step; i++) {
                MeshTools.AddCube(start, start + ((step - 1) == i ? new Vector3(2, 0.2f, 0.4f) : new Vector3(2, 0.2f, 0.7f)), vertices, triangles, normals, uv);
                start += new Vector3(0, 0.2f, 0.4f);
            }
        }

        //添加方块
        public static void AddCube(Vector3 start, Vector3 end, List<Vector3> vertices, List<int> triangles, List<Vector3> normals, List<Vector2> uv, System.Random rand = null) {
            Vector2 uvRandomStart;
            if (rand != null) {
                uvRandomStart = new Vector2(rand.Next(0, 10000), rand.Next(0, 10000)) * 0.0001f;
            } else {
                uvRandomStart = new Vector2(CommonTools.Random(0.0f, 1f), CommonTools.Random(0.0f, 1f));
            }
            int p = vertices.Count;

            float width = end.x - start.x;
            float height = end.y - start.y;
            float length = end.z - start.z;

            // 前面
            vertices.Add(start + new Vector3(0, 0, 0));// 顶点
            vertices.Add(start + new Vector3(width, 0, 0));
            vertices.Add(start + new Vector3(0, height, 0));
            vertices.Add(start + new Vector3(width, height, 0));
            uv.Add(new Vector2(0, 0) + uvRandomStart); // uv
            uv.Add(new Vector2(width, 0) + uvRandomStart);
            uv.Add(new Vector2(0, height) + uvRandomStart);
            uv.Add(new Vector2(width, height) + uvRandomStart);
            normals.Add(new Vector3(0, 0, -1)); // 法线
            normals.Add(new Vector3(0, 0, -1));
            normals.Add(new Vector3(0, 0, -1));
            normals.Add(new Vector3(0, 0, -1));
            triangles.Add(p); // 三角面
            triangles.Add(p + 2);
            triangles.Add(p + 3);
            triangles.Add(p);
            triangles.Add(p + 3);
            triangles.Add(p + 1);
            p += 4;

            // 上面
            vertices.Add(start + new Vector3(0, height, 0));// 顶点
            vertices.Add(start + new Vector3(width, height, 0));
            vertices.Add(start + new Vector3(0, height, length));
            vertices.Add(start + new Vector3(width, height, length));
            uv.Add(new Vector2(0, height) + uvRandomStart); // uv
            uv.Add(new Vector2(width, height) + uvRandomStart);
            uv.Add(new Vector2(0, height + length) + uvRandomStart);
            uv.Add(new Vector2(width, height + length) + uvRandomStart);
            normals.Add(new Vector3(0, 1, 0)); // 法线
            normals.Add(new Vector3(0, 1, 0)); // 法线
            normals.Add(new Vector3(0, 1, 0)); // 法线
            normals.Add(new Vector3(0, 1, 0)); // 法线
            triangles.Add(p); // 三角面
            triangles.Add(p + 2);
            triangles.Add(p + 3);
            triangles.Add(p);
            triangles.Add(p + 3);
            triangles.Add(p + 1);
            p += 4;

            // 后面
            vertices.Add(start + new Vector3(0, height, length));
            vertices.Add(start + new Vector3(width, height, length));
            vertices.Add(start + new Vector3(0, 0, length));// 顶点
            vertices.Add(start + new Vector3(width, 0, length));
            uv.Add(new Vector2(0, height + length) + uvRandomStart);
            uv.Add(new Vector2(width, height + length) + uvRandomStart);
            uv.Add(new Vector2(0, height + length + height) + uvRandomStart); // uv
            uv.Add(new Vector2(width, height + length + height) + uvRandomStart);
            normals.Add(new Vector3(0, 0, -1)); // 法线
            normals.Add(new Vector3(0, 0, -1)); // 法线
            normals.Add(new Vector3(0, 0, -1)); // 法线
            normals.Add(new Vector3(0, 0, -1)); // 法线
            triangles.Add(p); // 三角面
            triangles.Add(p + 2);
            triangles.Add(p + 3);
            triangles.Add(p);
            triangles.Add(p + 3);
            triangles.Add(p + 1);
            p += 4;

            // 下面
            vertices.Add(start + new Vector3(0, 0, length));// 顶点
            vertices.Add(start + new Vector3(width, 0, length));
            vertices.Add(start + new Vector3(0, 0, 0));
            vertices.Add(start + new Vector3(width, 0, 0));
            uv.Add(new Vector2(0, height + length + length) + uvRandomStart);
            uv.Add(new Vector2(width, height + length + length) + uvRandomStart);
            uv.Add(new Vector2(0, height + length + height + length) + uvRandomStart); // uv
            uv.Add(new Vector2(width, height + length + height + length) + uvRandomStart);
            normals.Add(new Vector3(0, -1, 0)); // 法线
            normals.Add(new Vector3(0, -1, 0)); // 法线
            normals.Add(new Vector3(0, -1, 0)); // 法线
            normals.Add(new Vector3(0, -1, 0)); // 法线
            triangles.Add(p); // 三角面
            triangles.Add(p + 2);
            triangles.Add(p + 3);
            triangles.Add(p);
            triangles.Add(p + 3);
            triangles.Add(p + 1);
            p += 4;

            // 左面
            vertices.Add(start + new Vector3(0, height, 0));// 顶点
            vertices.Add(start + new Vector3(0, height, length));
            vertices.Add(start + new Vector3(0, 0, 0));
            vertices.Add(start + new Vector3(0, 0, length));
            uv.Add(new Vector2(uvRandomStart.x, uvRandomStart.y) + uvRandomStart);
            uv.Add(new Vector2(uvRandomStart.x, uvRandomStart.y + length * 2) + uvRandomStart);
            uv.Add(new Vector2(uvRandomStart.x + height * 2, uvRandomStart.y) + uvRandomStart); // uv
            uv.Add(new Vector2(uvRandomStart.x + height * 2, uvRandomStart.y + length * 2) + uvRandomStart);
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            triangles.Add(p); // 三角面
            triangles.Add(p + 2);
            triangles.Add(p + 3);
            triangles.Add(p);
            triangles.Add(p + 3);
            triangles.Add(p + 1);
            p += 4;

            // 右面
            vertices.Add(start + new Vector3(width, 0, 0));
            vertices.Add(start + new Vector3(width, 0, length));
            vertices.Add(start + new Vector3(width, height, 0));// 顶点
            vertices.Add(start + new Vector3(width, height, length));
            uv.Add(new Vector2(uvRandomStart.x * 2, uvRandomStart.y) + uvRandomStart);
            uv.Add(new Vector2(uvRandomStart.x * 2, uvRandomStart.y + length * 2) + uvRandomStart);
            uv.Add(new Vector2(uvRandomStart.x * 2 + height * 2, uvRandomStart.y) + uvRandomStart); // uv
            uv.Add(new Vector2(uvRandomStart.x * 2 + height * 2, uvRandomStart.y + length * 2) + uvRandomStart);
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            normals.Add(new Vector3(-1, 0, 0)); // 法线
            triangles.Add(p); // 三角面
            triangles.Add(p + 2);
            triangles.Add(p + 3);
            triangles.Add(p);
            triangles.Add(p + 3);
            triangles.Add(p + 1);
            p += 4;

        }
    }


}