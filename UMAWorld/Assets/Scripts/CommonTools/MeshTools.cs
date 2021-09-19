using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
// 修仙世界
namespace UMAWorld {
    public static class MeshTools {

        public static GameObject NewMeshObj(string name, Action<List<Vector3>, List<int>, List<Vector3>, List<Vector2>> action, Material material = null) {
            GameObject go = new GameObject();
            go.name = name;
            List<Vector3> vertices = new List<Vector3>(); // 顶点
            List<int> triangles = new List<int>(); // 面
            List<Vector3> normals = new List<Vector3>(); // 法线
            List<Vector2> uv = new List<Vector2>(); // uv
            action(vertices, triangles, normals, uv);
            Mesh mesh = new Mesh(); //new 一个mesh
            mesh.vertices = vertices.ToArray(); //把顶点列表 放到mesh中
            mesh.triangles = triangles.ToArray(); //把三角序列 放到mesh中
            mesh.normals = normals.ToArray(); //把三角序列 放到mesh中
            mesh.uv = uv.ToArray(); //新增 把UV列表 放到mesh中
            go.AddComponent<MeshFilter>().mesh = mesh; //得到meshfilter组件
            go.AddComponent<MeshRenderer>().material = material == null ? CommonTools.LoadResources<Material>("Material/testStone") : material;
            go.AddComponent<MeshCollider>();
            return go;
        }

        // 添加楼梯 dir 0前 1左 2右 3后
        public static void AddStatirs(Vector3 start, int step, List<Vector3> vertices, List<int> triangles, List<Vector3> normals, List<Vector2> uv,
            System.Random rand = null, int dir = 0, float width = 3, float height = 0.2f, float length = 0.4f) {
            Vector3 add1, add2, add3;
            switch (dir)
            {
                case 1:
                    add1 = new Vector3(-length, height, width);
                    add2 = new Vector3(-length * 1.7f, height, width);
                    add3 = new Vector3(-length, height, 0);
                    break;
                case 2:
                    add1 = new Vector3(length, height, -width);
                    add2 = new Vector3(length * 1.7f, height, -width);
                    add3 = new Vector3(length, height, 0);
                    break;
                case 3:
                    add1 = new Vector3(-width, height, -length);
                    add2 = new Vector3(-width, height, -length * 1.7f);
                    add3 = new Vector3(0, height, -length);
                    break;
                default:
                    add1 = new Vector3(width, height, length);
                    add2 = new Vector3(width, height, length * 1.7f);
                    add3 = new Vector3(0, height, length);
                    break;
            }
            for (int i = 0; i < step; i++) {
                MeshTools.AddCube(start, start + ((step - 1) == i ? add1 : add2), vertices, triangles, normals, uv);
                start += add3;
            }
        }

        //添加方块
        public static void AddCube(Vector3 originalStart, Vector3 originalEnd, List<Vector3> vertices, List<int> triangles, List<Vector3> normals, List<Vector2> uv, System.Random rand = null) {
            Vector2 uvRandomStart;
            if (rand != null) {
                uvRandomStart = new Vector2(rand.Next(0, 10000), rand.Next(0, 10000)) * 0.0001f;
            } else {
                uvRandomStart = new Vector2(CommonTools.Random(0.0f, 1f), CommonTools.Random(0.0f, 1f));
            }
            int p = vertices.Count;

            Vector3 start = new Vector3(), end = new Vector3();
            start.x = Mathf.Min(originalStart.x, originalEnd.x);
            start.y = Mathf.Min(originalStart.y, originalEnd.y);
            start.z = Mathf.Min(originalStart.z, originalEnd.z);
            end.x = Mathf.Max(originalStart.x, originalEnd.x);
            end.y = Mathf.Max(originalStart.y, originalEnd.y);
            end.z = Mathf.Max(originalStart.z, originalEnd.z);

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
            normals.Add(new Vector3(0, 0, 1)); // 法线
            normals.Add(new Vector3(0, 0, 1)); // 法线
            normals.Add(new Vector3(0, 0, 1)); // 法线
            normals.Add(new Vector3(0, 0, 1)); // 法线
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
            normals.Add(new Vector3(1, 0, 0)); // 法线
            normals.Add(new Vector3(1, 0, 0)); // 法线
            normals.Add(new Vector3(1, 0, 0)); // 法线
            normals.Add(new Vector3(1, 0, 0)); // 法线
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