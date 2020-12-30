using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using UnityEngine.UI;

public class ExprotLanguageFlie :Editor 
{
	//UIPrefab文件夹目录
	private static string UIPrefabPath = "Assets/CustomerResource/UI";
	//脚本的文件夹目录
	private static string ScriptPath = "Assets/Lua";
	//导出的中文KEY路径
	private static string OutPath = "Assets/CustomerResource/Localization/Chinese.json";

	private static List<string>Localization = null;
	private static string staticWriteText = "";
	[MenuItem("Tools/导出多语言")]
	static void ExportChinese()
	{
		Localization = new List<string>();
		staticWriteText ="";

		//提取Prefab上的中文
		staticWriteText +="{\n";
		LoadDiectoryPrefab(new DirectoryInfo(UIPrefabPath));

		//提取Lua中的中文
		LoadDiectoryCS(new DirectoryInfo(ScriptPath));

		staticWriteText +="}\n";

		//最终把提取的中文生成出来
		string textPath = OutPath;
		if (System.IO.File.Exists (textPath)) 
		{
			File.Delete (textPath);
		}
		using(StreamWriter writer = new StreamWriter(textPath, false, Encoding.UTF8))
		{
			writer.Write(staticWriteText);
		}
		AssetDatabase.Refresh();
	}

	//递归所有UI Prefab
	static public  void  LoadDiectoryPrefab(DirectoryInfo dictoryInfo)
	{
		if(!dictoryInfo.Exists)   return;
		FileInfo[] fileInfos = dictoryInfo.GetFiles("*.prefab", SearchOption.AllDirectories);
		foreach (FileInfo files in fileInfos)
		{
			string path = files.FullName;
			string assetPath =  path.Substring(path.IndexOf("Assets/"));
			GameObject prefab = AssetDatabase.LoadAssetAtPath(assetPath, typeof(GameObject)) as GameObject;
			GameObject instance = GameObject.Instantiate(prefab) as GameObject;
			SearchPrefabString(instance.transform);
			GameObject.DestroyImmediate(instance);
		}
	}

	//递归所有Lua代码
	static public  void  LoadDiectoryCS(DirectoryInfo dictoryInfo)
	{

		if(!dictoryInfo.Exists)   return;
		FileInfo[] fileInfos = dictoryInfo.GetFiles("*.lua", SearchOption.AllDirectories);
		foreach (FileInfo files in fileInfos)
		{
			string path = files.FullName;
			string assetPath =  path.Substring(path.IndexOf("Assets/"));
			string text = File.ReadAllText(path);
			//用正则表达式把代码里面两种字符串中间的字符串提取出来。
			Regex reg = new Regex("(?<=gf_localize_string\\s*\\(\\s*\"\\s*)[\\s\\S]*?(?=\\s*\")");
			MatchCollection mc = reg.Matches(text);
			foreach(Match m in mc)
			{
				string format = m.Value;
				if(!Localization.Contains(format) && !string.IsNullOrEmpty(format)){
					Localization.Add(format);
					staticWriteText+= "\""+format + "\": " + "\"" + format + "\",\n";
				}
			}
		}
	}

	//提取Prefab上的中文
	static public void SearchPrefabString(Transform root)
	{
		foreach(Transform chind in root)
		{
			//因为这里是写例子，所以我用的是UILabel 
			//这里应该是写你用于图文混排的脚本。
			Text label = chind.GetComponent<Text>();
			if(label != null)
			{
				string text = label.text;
				if(!Localization.Contains(text) && !string.IsNullOrEmpty(text)){
					Localization.Add(text);
					staticWriteText+= "\""+text + "\": " + "\"" + text + "\",\n";
				}
			}
			if(chind.childCount >0)
				SearchPrefabString(chind);
		}
	}
}
