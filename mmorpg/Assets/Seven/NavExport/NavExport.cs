using UnityEngine;
using System.Collections;
using System.Text;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
namespace Seven
{
	public class NavExport : MonoBehaviour
	{
		#region Public Attributes
		public Vector3 leftUpStart = Vector3.zero;
		public float accuracy = 1;
		public int height = 30;
		public int wide = 30;
		public int originalHeight = 0;//原始高度
		public string outPutFileName = "";

		private string outputPath = "Assets/Lua/config/walkable/";
		private string mapPath = "";
		private string mapPosPath = "";
		private Vector3 tp;

		#endregion

		#region Unity Messages

		void OnGUI()
		{
			if (GUILayout.Button("Export"))
			{
				exportPoint(leftUpStart, height, wide, accuracy);
			}
		}

		#endregion

		#region Public Methods

		public void Exp()
		{
			exportPoint(leftUpStart, wide, height, accuracy);
		}

		public void exportPoint(Vector3 startPos, int x, int y, float accuracy)
		{
			if (outPutFileName == "") {
				Debug.LogError ("请输入文件名！outPutFileName");
				return;
			}
			mapPath = outputPath + outPutFileName+".lua";
			mapPosPath = outputPath + outPutFileName+"Pos.lua";

			StringBuilder str = new StringBuilder();
			StringBuilder posStr = new StringBuilder();

			int[,] list = new int[x, y];
//			str.Append("return{\n");
//			str.Append("local tbl = {}\n");
//			str.Append ("local start_x = ").Append(startPos.x).Append("\n");
//			str.Append ("local start_y = ").Append(startPos.z).Append("\n");
//			str.Append ("local width = ").Append(x).Append("\n");
//			str.Append ("local height = ").Append(y).Append("\n");
//			str.Append ("function tbl:getValue( x, y )\n\tx = math.abs(x*0.1 - start_x)\n\ty = math.abs(y*0.1 - start_y)\n\tif x > width or y > height then\n\t\treturn 0\n\tend\n\t\n\treturn tbl.map[x][y]\nend\n");
//			str.Append("startpos=").Append(startPos).Append("\r\n");
//			str.Append("height=").Append(y).Append("\r\nwide=").Append(x).Append("\r\naccuracy=").Append(accuracy).Append("\r\n");

			str.Append ("tbl = {\n");

			for (int i = 0; i < y; ++i)
			{
				str.Append("{");
				for (int j = 0; j < x; ++j)
				{
					int res = list[j, i];
//					UnityEngine.AI.NavMeshHit hit;
//
//					for (int k = -30+originalHeight; k < 30+originalHeight; ++k)
//					{
//						tp = startPos + new Vector3 (j * accuracy, k, i * accuracy);
//						if (UnityEngine.AI.NavMesh.SamplePosition(tp, out hit, 0.5f, UnityEngine.AI.NavMesh.AllAreas))
//						{
//							res = 1;
////							posStr.Append("[\"").Append(tp.x).Append(",").Append(tp.z).Append("\"] = ").Append ("Vector3(").Append (hit.position.x).Append(", ").Append (hit.position.y).Append(", ").Append (hit.position.z).Append ("),\n");
//							break;
//						}
//					}
					tp	= startPos + new Vector3 (j * accuracy, 200, i * accuracy);
					RaycastHit hit;
					bool isWall = false;
					for (float k = -0.5f; k < 0.5f; k += 0.1f) 
					{
						for (float z = -0.5f; z < 0.5f; z += 0.1f){
							Vector3 pos = new Vector3 (tp.x + k, tp.y, tp.z+z);
							Ray ray = new Ray (pos, Vector3.down);
							if (Physics.Raycast(ray, out hit, 300, 1<<13))//Wall layer
							{
								isWall = true;
								break;
//								break;
							}
						}
					}

					if (!isWall)
					{
						Ray ray = new Ray (tp, Vector3.down);
						if (Physics.Raycast(ray, out hit, 300, 1<<12))//Floor layer
						{
							res = 1;
						}
					}
					tp.y = originalHeight;
					Debug.DrawRay(tp, Vector3.up, res == 1 ? Color.green : Color.red, 5);
					str.Append(res).Append(",");
				}
				str.Append("},\n");
			}
			str.Append("}\n");
			str.Append("return tbl");
//			posStr.Append ("}\n");
			OutPutFile (mapPath, str.ToString());
//			OutPutFile (mapPosPath, posStr.ToString());
			Debug.Log ("输出成功！");
		}

		void OutPutFile(string path, string str)
		{
			//最终把提取的中文生成出来
			if (System.IO.File.Exists (path)) 
			{
				File.Delete (path);
			}
			FileStream fs = new FileStream(path, FileMode.Create);
			StreamWriter sw = new StreamWriter(fs);
			//开始写入
			sw.Write(str);
			//清空缓冲区
			sw.Flush();
			//关闭流
			sw.Close();
			fs.Close();
		}
		#endregion

	}
}