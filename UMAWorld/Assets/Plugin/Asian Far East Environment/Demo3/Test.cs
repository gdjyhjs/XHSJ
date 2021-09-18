using System.Collections;
using System.Collections.Generic;
using UnityEngine;
namespace UMAWorld {
    public class Test : MonoBehaviour {
        public int stepCount = 10;
        public Material gray;
        void Start() {
            List<Vector3> vertices = new List<Vector3>(); // 顶点
            List<int> triangles = new List<int>(); // 面
            List<Vector3> normals = new List<Vector3>(); // 法线
            List<Vector2> uv = new List<Vector2>(); // uv
            Vector3 pos = new Vector3(-1, 0, 0);
            int p = 0;
            for (int i = 0; i < stepCount; i++) // 循环绘制台阶
            {
                MeshTools.AddCube(pos, pos + ((stepCount - 1) == i ? new Vector3(2, 0.2f, 0.4f): new Vector3(2, 0.2f, 0.7f)), vertices,triangles,normals,uv);
                pos += new Vector3(0, 0.2f, 0.4f);
            }

            Mesh mesh = new Mesh(); //new 一个mesh
            mesh.vertices = vertices.ToArray(); //把顶点列表 放到mesh中
            mesh.triangles = triangles.ToArray(); //把三角序列 放到mesh中
            mesh.normals = normals.ToArray(); //把三角序列 放到mesh中
            mesh.uv = uv.ToArray(); //新增 把UV列表 放到mesh中


            gameObject.AddComponent<MeshFilter>().mesh = mesh; //得到meshfilter组件
            gameObject.AddComponent<MeshRenderer>().material = gray;
        }
    }
}