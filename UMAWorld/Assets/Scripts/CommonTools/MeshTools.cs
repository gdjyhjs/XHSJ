using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using System.Text;


// 修仙世界
namespace UMAWorld {
    public static class MeshTools {

        // 新建自定义网格对象
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
            mesh.RecalculateBounds();
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
                var add = (step - 1) == i ? add1 : add2;
                MeshTools.AddCube(start, start + add, vertices, triangles, normals, uv, rand, dir);
                start += add3;
            }
        }

        //添加方块
        public static void AddCube(Vector3 originalStart, Vector3 originalEnd, List<Vector3> vertices, List<int> triangles, List<Vector3> normals, List<Vector2> uv, System.Random rand = null, int dir = 0) {
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
            float uv_width = width;
            float uv_height = height;
            float uv_length = length;

            // 前面
            vertices.Add(start + new Vector3(0, 0, 0));// 顶点
            vertices.Add(start + new Vector3(width, 0, 0));
            vertices.Add(start + new Vector3(0, height, 0));
            vertices.Add(start + new Vector3(width, height, 0));
            uv.Add(new Vector2(0, 0) + uvRandomStart); // uv
            uv.Add(new Vector2(uv_width, 0) + uvRandomStart);
            uv.Add(new Vector2(0, uv_height) + uvRandomStart);
            uv.Add(new Vector2(uv_width, uv_height) + uvRandomStart);
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
            uv.Add(new Vector2(0, uv_height) + uvRandomStart); // uv
            uv.Add(new Vector2(uv_width, uv_height) + uvRandomStart);
            uv.Add(new Vector2(0, uv_height + uv_length) + uvRandomStart);
            uv.Add(new Vector2(uv_width, uv_height + uv_length) + uvRandomStart);
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
            uv.Add(new Vector2(0, uv_height + uv_length) + uvRandomStart);
            uv.Add(new Vector2(uv_width, uv_height + uv_length) + uvRandomStart);
            uv.Add(new Vector2(0, uv_height + uv_length + uv_height) + uvRandomStart); // uv
            uv.Add(new Vector2(uv_width, uv_height + uv_length + uv_height) + uvRandomStart);
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
            uv.Add(new Vector2(0, uv_height + uv_length + uv_length) + uvRandomStart);
            uv.Add(new Vector2(uv_width, uv_height + uv_length + uv_length) + uvRandomStart);
            uv.Add(new Vector2(0, uv_height + uv_length + uv_height + uv_length) + uvRandomStart); // uv
            uv.Add(new Vector2(uv_width, uv_height + uv_length + uv_height + uv_length) + uvRandomStart);
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
            uv.Add(new Vector2(uvRandomStart.x, uvRandomStart.y + uv_length * 2) + uvRandomStart);
            uv.Add(new Vector2(uvRandomStart.x + uv_height * 2, uvRandomStart.y) + uvRandomStart); // uv
            uv.Add(new Vector2(uvRandomStart.x + uv_height * 2, uvRandomStart.y + uv_length * 2) + uvRandomStart);
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
            uv.Add(new Vector2(uvRandomStart.x * 2, uvRandomStart.y + uv_length * 2) + uvRandomStart);
            uv.Add(new Vector2(uvRandomStart.x * 2 + uv_height * 2, uvRandomStart.y) + uvRandomStart); // uv
            uv.Add(new Vector2(uvRandomStart.x * 2 + uv_height * 2, uvRandomStart.y + uv_length * 2) + uvRandomStart);
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

            if (dir == 1 || dir == 2) {
                for (int i = 1; i < 25; i++) {
                    int idx = uv.Count - i;
                    uv[idx] = new Vector2(uv[idx].y, uv[idx].x);
                }
            }
        }


        // 网格围墙修改 使其适合楼梯使用
        public static Mesh ModifyMeshToStairway(Mesh mesh, float height, float length) {
            height *= 0.5f;
            length *= 0.5f;

            List<Vector3> vertices = new List<Vector3>(mesh.vertices);
            float max_x= 0;
            for (int i = 0; i < vertices.Count; i++) {
                if (max_x < vertices[i].x) {
                    max_x = vertices[i].x;
                }
            }

            for (int i = 0; i < vertices.Count; i++) {
                Vector3 p = vertices[i];
                //根据x 决定y的高度
                float pos = max_x == 0 ? 0 : (p.x / max_x);
                p.x = length * pos;
                p.y += pos * height;
                vertices[i] = p;
            }
            Mesh result = GameObject.Instantiate(mesh);
            result.vertices = vertices.ToArray();
            result.RecalculateBounds();
            return result;
        }













        // 网格到文件
        public static void MeshToFile(MeshFilter mf, string filename, float scale) {
            using (StreamWriter streamWriter = new StreamWriter(filename)) {
                streamWriter.Write(MeshToString(mf, scale));
            }
        }

        // 网格到字符串
        public static string MeshToString(MeshFilter mf, float scale) {
            Mesh mesh = mf.mesh;
            Material[] sharedMaterials = mf.GetComponent<Renderer>().sharedMaterials;
            Vector2 textureOffset = mf.GetComponent<Renderer>().material.GetTextureOffset("_MainTex");
            Vector2 textureScale = mf.GetComponent<Renderer>().material.GetTextureScale("_MainTex");
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("mtllib design.mtl").Append("\n");
            stringBuilder.Append("g ").Append(mf.name).Append("\n");
            Vector3[] vertices = mesh.vertices;
            for (int i = 0; i < vertices.Length; i++) {
                Vector3 vector = vertices[i];
                stringBuilder.Append(string.Format("v {0} {1} {2}\n", vector.x * scale, vector.z * scale, vector.y * scale));
            }
            stringBuilder.Append("\n");
            Dictionary<int, int> dictionary = new Dictionary<int, int>();
            if (mesh.subMeshCount > 1) {
                int[] triangles = mesh.GetTriangles(1);
                for (int j = 0; j < triangles.Length; j += 3) {
                    if (!dictionary.ContainsKey(triangles[j])) {
                        dictionary.Add(triangles[j], 1);
                    }
                    if (!dictionary.ContainsKey(triangles[j + 1])) {
                        dictionary.Add(triangles[j + 1], 1);
                    }
                    if (!dictionary.ContainsKey(triangles[j + 2])) {
                        dictionary.Add(triangles[j + 2], 1);
                    }
                }
            }
            for (int num = 0; num != mesh.uv.Length; num++) {
                Vector2 vector2 = Vector2.Scale(mesh.uv[num], textureScale) + textureOffset;
                if (dictionary.ContainsKey(num)) {
                    stringBuilder.Append(string.Format("vt {0} {1}\n", mesh.uv[num].x, mesh.uv[num].y));
                } else {
                    stringBuilder.Append(string.Format("vt {0} {1}\n", vector2.x, vector2.y));
                }
            }
            for (int k = 0; k < mesh.subMeshCount; k++) {
                stringBuilder.Append("\n");
                if (k == 0) {
                    stringBuilder.Append("usemtl ").Append("Material_design").Append("\n");
                }
                if (k == 1) {
                    stringBuilder.Append("usemtl ").Append("Material_logo").Append("\n");
                }
                int[] triangles2 = mesh.GetTriangles(k);
                for (int l = 0; l < triangles2.Length; l += 3) {
                    stringBuilder.Append(string.Format("f {0}/{0} {1}/{1} {2}/{2}\n", triangles2[l] + 1, triangles2[l + 1] + 1, triangles2[l + 2] + 1));
                }
            }
            return stringBuilder.ToString();
        }




    }
}