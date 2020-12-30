using UnityEngine;
using System.Collections;
using System.Text;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using System;

namespace Seven
{
	public class MonsterExport : MonoBehaviour
	{
		#region Public Attributes
		public string mapID = "";

		private string outputPath = "../Map/Tmp/";
		private string filePath = "";
		#endregion

		#region Unity Messages
		void OnGUI()
		{
			if (GUILayout.Button("Export"))
			{
				
			}
		}
		#endregion

		#region Public Methods
		public void Exp()
		{
			if (mapID == "") {
				Debug.LogError ("请输入:mapId");
				return;
			}
			filePath = outputPath + mapID+".lua";

			StringBuilder str = new StringBuilder();

			List<Transform> monsterList = new List<Transform> ();
			List<Transform> npcList = new List<Transform> ();
			List<Transform> transferList = new List<Transform> ();
			List<Transform> stopList = new List<Transform> ();
			List<Transform> monsterCenterList = new List<Transform> ();
			List<Transform> dynamicMonsterList = new List<Transform> ();
			List<Transform> sceneObjList = new List<Transform> ();
			List<Transform> sceneEffectList = new List<Transform> ();

			foreach (Transform c in transform) {
				string name = c.name;
				string[] nl = name.Split ('_');
				if(nl[0] == "1") //怪物
				{
					monsterList.Add (c);
				}
				else if(nl[0] == "2") //npc
				{
					npcList.Add (c);
				}
				else if(nl[0] == "3") //传送阵
				{
					transferList.Add (c);
				}
				else if(nl[0] == "4") //阻挡
				{
					stopList.Add (c);
				}
				else if(nl[0] == "5") //怪物中心点
				{
					monsterCenterList.Add (c);
				}
				else if(nl[0] == "7") //动态刷怪表，对应boss_refresh
				{
					dynamicMonsterList.Add (c);
				}
				else if(nl[0] == "8") //场景的某些模型可被破坏：木箱，酒缸之类的 
				{
					sceneObjList.Add (c);
				}
				else if(nl[0] == "9") //场景特效 
				{
					sceneEffectList.Add (c);
				}
			}

			str.Append("\t[").Append(mapID).Append ("] = {\n");
			str.Append (ToString (monsterList));
			str.Append (ToString (npcList));
			str.Append (ToString (transferList));
			str.Append (ToString (stopList));
			str.Append (ToString (monsterCenterList));
			str.Append (ToString (dynamicMonsterList));
			str.Append (ToString (sceneObjList));
			str.Append (ToString (sceneEffectList));
			str.Append ("\t},\n");

			OutPutFile (filePath, str.ToString ());
			OutPutEnd ();
			Debug.Log ("输出成功！");
		}

		public string ToString(List<Transform> list)
		{
			if (list.Count <= 0)
				return "";
			string[] nl = list[0].name.Split ('_');
			string str = "\t\t["+nl[0]+"] = {\n";
			for (int i = 0; i < list.Count; i++) 
			{
				Transform t = list [i];
				string name = t.name;
				nl = name.Split ('_');
				str += "\t\t\t{";
				str += "code = "+nl [1]+", uid = "+(i+1)+", dir = "+t.eulerAngles.y+", pos = {x = "+Mathf.Floor(t.position.x*10)+", z = "+Mathf.Floor(t.position.y*10)+", y = "+Mathf.Floor(t.position.z*10)+"}, ";
				str += "big_type = " + nl [0] + ", ";
				if (nl.Length > 3 && nl [3] != null) {
					str += "wave = " + nl [3] + ", ";
				}
				str += "small_type = " + nl [2] + "},\n";
			}
			str += "\t\t},\n";
			return str;
		}

		public void Refresh()
		{
			List<GameObject> children = new List<GameObject> ();
			foreach (Transform c in transform) {
				children.Add (c.gameObject);
			}
			foreach (GameObject c in children) {
				DestroyImmediate (c);
			}

			filePath = outputPath + mapID+".lua";
			string text = File.ReadAllText(filePath);
			Regex reg = new Regex("big_type = (.+?),");
			MatchCollection mc = reg.Matches(text);
			List<GameObject> list = new List<GameObject>();
			foreach(Match m in mc)
			{
//				Debug.Log (m.Groups[1].Value);
				GameObject obj = new GameObject (m.Groups[1].Value);
				obj.transform.parent = transform;
				GameObject cube = GameObject.CreatePrimitive(PrimitiveType.Cube);
				cube.transform.parent = obj.transform;
				list.Add(obj);
			}
			reg = new Regex("code = (.+?),");
			mc = reg.Matches(text);
			int idx = 0;
			foreach(Match m in mc)
			{
				GameObject obj = list [idx];
				string name = obj.name+"_"+m.Groups[1].Value;
				obj.name = name;
				idx++;
			}
			reg = new Regex("small_type = (.+?)}");
			mc = reg.Matches(text);
			idx = 0;
			foreach(Match m in mc)
			{
				GameObject obj = list [idx];
				string name = obj.name+"_"+m.Groups[1].Value;
				obj.name = name;
				idx++;
			}

			reg = new Regex("wave = (.+?),");
			mc = reg.Matches(text);
			idx = 0;
			foreach(Match m in mc)
			{
				GameObject obj = list [idx];
				string name = obj.name+"_"+m.Groups[1].Value;
				obj.name = name;
				idx++;
			}

			reg = new Regex("dir = (.+?),");
			mc = reg.Matches(text);
			idx = 0;
			foreach(Match m in mc)
			{
				list[idx].transform.eulerAngles = new Vector3(0, float.Parse(m.Groups[1].Value), 0);
				idx++;
			}

			reg = new Regex("x = (.+?),");
			mc = reg.Matches(text);
			idx = 0;
			foreach(Match m in mc)
			{
//				Debug.Log (m.Groups[1].Value);
				GameObject obj = list [idx];
				Vector3 pos	= obj.transform.position;
				pos.x = (float)(int.Parse(m.Groups[1].Value)*0.1);
				obj.transform.position = pos;
				idx++;
			}

			reg = new Regex("z = (.+?),");
			mc = reg.Matches(text);
			idx = 0;
			foreach(Match m in mc)
			{
				//				Debug.Log (m.Groups[1].Value);
				GameObject obj = list [idx];
				Vector3 pos	= obj.transform.position;
				pos.y = (float)(int.Parse(m.Groups[1].Value)*0.1);
				obj.transform.position = pos;
				idx++;
			}

			reg = new Regex("y = (.+?)},");
			mc = reg.Matches(text);
			idx = 0;
			foreach(Match m in mc)
			{
//				Debug.Log (m.Groups[1].Value);
				GameObject obj = list [idx];
				Vector3 pos	= obj.transform.position;
				pos.z = (float)(int.Parse(m.Groups[1].Value)*0.1);
				obj.transform.position = pos;
				idx++;
			}

			Debug.Log ("刷新成功！");
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

		void OutPutEnd()
		{
			DirectoryInfo dictoryInfo = new DirectoryInfo (outputPath);
			if(!dictoryInfo.Exists)   return;
			string pt = "../Map/mapMonsters.lua";

			string tmp = "return {\n";
			FileInfo[] fileInfos = dictoryInfo.GetFiles("*.lua", SearchOption.AllDirectories);
			foreach (FileInfo files in fileInfos)
			{
				string path = files.FullName;
				string text = File.ReadAllText(path);
				tmp += text + "\n";
			}
			tmp += "}";
			OutPutFile (pt, tmp);
		}

		#endregion
	}
}

