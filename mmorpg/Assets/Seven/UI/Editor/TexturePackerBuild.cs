//#if UNITY_EDITOR
using UnityEngine;
using System;
using System.IO;
using UnityEditor;
using System.Text;
using System.Diagnostics;
using System.Xml;
using System.Collections.Generic;
using Hugula.Editor;

namespace Seven
{
	public class TexturePackerBuild : EditorWindow
	{	

		// #if UNITY_STANDALONE_OSX
		public static string textureCmd = "/Applications/TexturePacker.app/Contents/MacOS/TexturePacker";//TexturePacker安装目录
		// #else
		// 		public static string textureCmd = "D:\\Program Files\\CodeAndWeb\\TexturePacker\\bin\\TexturePacker.exe";
		// #endif

		static int winType = 0;

		static string folder;

		#region EditorWindow
		[MenuItem("Tools/SpritesPacker/合成UI大图")]
		public static void OpenWindow()
		{
			winType = 1;
			EditorWindow.GetWindow(typeof(TexturePackerBuild));
		}

		[MenuItem("Tools/SpritesPacker/拷贝9宫格信息")]
		public static void ModifyMeta()
		{
			winType = 2;
			EditorWindow.GetWindow(typeof(TexturePackerBuild));
		}

		[MenuItem("Tools/SpritesPacker/合成UI特效图片")]
		public static void PackerEffectImg()
		{
			winType = 3;
			EditorWindow.GetWindow(typeof(TexturePackerBuild));
		}

		void OnEnable()
		{
			folder = "";
		}

		void OnGUI()
		{
			if (winType == 1) {
				GUILayout.Label ("合成大图", EditorStyles.boldLabel);
				folder = EditorGUILayout.TextField ("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					BuildTextruePT (GetInputPath(), folder);
				}

			} else if (winType == 2) {
				GUILayout.Label ("拷贝9宫格信息", EditorStyles.boldLabel);
				folder = EditorGUILayout.TextField ("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")) {
					BuildImgIpt (folder);
				}
			}
			else if (winType == 3) {
				GUILayout.Label ("合成UI特效图片", EditorStyles.boldLabel);
//				folder = EditorGUILayout.TextField ("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")) {
					BuildTextruePT (GetEffectImgInputPath(),folder);
				}
			}
		}
		#endregion EditorWindow

		public static string s_inputPath = "";
		public static void BuildTextruePT(string inputPath, string folder = "")
		{
			s_inputPath = inputPath;
			UnityEngine.Debug.Log ("开始合成大图..."+folder);
			if (inputPath.Equals (GetEffectImgInputPath ())) {
				folder = "effect_ui_tex";
				PackageTexture (Path.Combine(inputPath, folder));
			} else {
				if (folder.Equals ("")) {
					string[] paths = Directory.GetDirectories (inputPath);
					for (int i = 0; i < paths.Length; i++) {
						PackageTexture (paths [i]);
					}
				} else {
					PackageTexture (inputPath + folder);
				}
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();
			BuildImgIpt (folder);
			UnityEngine.Debug.Log ("合成大图完成！");
		}

		//打包某些文件夹
		public static void BuildTextruePTFolders()
		{
			foreach (string arg in System.Environment.GetCommandLineArgs())
			{
				if (arg.StartsWith("var"))
				{
					string[] folders = arg.Split (':') [1].Split (',');
					foreach (string folder in folders) {
						if (!folder.Equals ("")) {
							BuildTextruePT (folder);
						}
					}
				}
			}
		}

		public static void PackageTexture(string path)
		{
			if (IsIgnore (path)) {
				ProjectBuild.CopyDirectory (path, path.Replace ("TTexture/", "Texture/"), true);
				return;
			}

			//清空要生成的文件夹
			if (s_inputPath.Equals (GetInputPath ())) {
				EditorUtils.DirectoryDelete (path.Replace ("TTexture/", "OutPut/"));
				EditorUtils.DirectoryDelete (path.Replace ("TTexture/", "Texture/"));
			}

			//可以限制图集最大尺寸，这里是2048x2048，如果超过了就自动拆分成多个图集
			//生成RGB888的图集
			string arguments = "--sheet {0}.png " +
				"--data {1}.xml " +
				"--format sparrow " +
				"--trim-mode None " +
				"--pack-mode Best  " +
				"--algorithm MaxRects " +
				"--max-size 2048 " +
				"--force-squared " +
				"--size-constraints POT " +
				"--disable-rotation " +
				"--scale 1 {2}";

			string arguments_multi = "--max-size 2048 " +
				"--force-squared " +
				"--multipack " +
				"--format sparrow " +
				"--trim-mode None " +
				"--pack-mode Best  " +
				"--algorithm MaxRects " +
				"--size-constraints POT " +
				"--disable-rotation " +
				"--sheet {0}_{3}.png " +
				"--data {1}_{4}.xml " +
				"--scale 1 {2}";

			string[] fileName = Directory.GetFiles (path);
			StringBuilder sb = new StringBuilder("");
			for (int j = 0; j < fileName.Length; j++)
			{
				string extenstion = Path.GetExtension(fileName[j]);
				if (Path.GetFileName (fileName [j]).Contains(" ")){
					UnityEngine.Debug.LogError ("图片名字有空格：" + fileName [j]);
					continue;
				}
				if (extenstion == ".png" || extenstion == ".jpg")
				{
					sb.Append(fileName[j]);
					sb.Append("  ");
				}
			}
			string[] list = path.Split ('/');
			string parentName = list [list.Length - 2];//父文件夹
			bool isChild = !parentName.Equals("TTexture");//是否是递归
			string name = Path.GetFileName(path);
			string opath = GetOutputPath();
			string oname = "big_"+name;
//			if (isChild) {
//				opath = opath + parentName;
//				oname = oname + "_" + parentName;
//			}

			string sheetName = string.Format("{0}/{1}/{2}", opath, name, oname);
			string n = "{n}";
			//执行命令行
			if (!processCommand (textureCmd, string.Format (arguments, sheetName, sheetName, sb.ToString ()))) {
				processCommand (textureCmd, string.Format (arguments_multi, sheetName, sheetName, sb.ToString (),n,n));
			}

			// 递归所有子文件夹
			string[] paths = Directory.GetDirectories (path);
			for (int i = 0; i < paths.Length; i++) {
				PackageTexture (paths [i]);
			}
		}

		private static bool processCommand(string command, string argument)
		{
			ProcessStartInfo start = new ProcessStartInfo(command);
			start.Arguments = argument;
			start.CreateNoWindow = false;
			start.ErrorDialog = true;
			start.UseShellExecute = false;

			if(start.UseShellExecute){
				start.RedirectStandardOutput = false;
				start.RedirectStandardError = false;
				start.RedirectStandardInput = false;
			} else{
				start.RedirectStandardOutput = true;
				start.RedirectStandardError = true;
				start.RedirectStandardInput = true;
				start.StandardOutputEncoding = System.Text.UTF8Encoding.UTF8;
				start.StandardErrorEncoding = System.Text.UTF8Encoding.UTF8;
			}

			Process p = Process.Start(start);
			if(!start.UseShellExecute)
			{
				UnityEngine.Debug.Log(p.StandardOutput.ReadToEnd());
				string err = p.StandardError.ReadToEnd ();
				if (!err.Equals ("")) {
					p.Close ();
					UnityEngine.Debug.Log(err);
					return false;
				}
			}

			p.WaitForExit();
			p.Close();
			return true;
		}

		// 拷贝图片信息
		public static void BuildImgIpt(string folder)
		{
			if (IsIgnore (folder)) {
				return;
			}
			UnityEngine.Debug.Log ("开始拷贝图片9宫格信息...");
			string[] paths = Directory.GetFiles(GetOutputPath()+folder, "*.png", SearchOption.AllDirectories);
			foreach (string path in paths) {
				if (path.Contains ("_rgb.") || path.Contains ("_a.")) {
					continue;
				}
				ModifyImgIpt (path);
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();
			UnityEngine.Debug.Log ("拷贝图片9宫格信息完成！");
		}

		public static void ModifyImgIpt(string pngPath)
		{
			string xmlPath = pngPath.Replace (".png", ".xml");
			string pngName = Path.GetFileName (pngPath);
			string[] list = pngPath.Split ('/');
			string folderName = list [list.Length - 2];
			string parentName = list [list.Length - 3];
			bool isChild = !parentName.Equals ("OutPut");
			if (isChild) {
				folderName = parentName + "/" + folderName;
			}
			string smallPngPath = s_inputPath + folderName;//小图文件路径

			if (!File.Exists (xmlPath)) {
				UnityEngine.Debug.LogError ("找不到图片xml：" + xmlPath);
				return;
			}
			ModifyPNGMeta (pngPath, xmlPath, smallPngPath);
			AssetDatabase.DeleteAsset (GetAssetPath (xmlPath));
		}

		//修改图片属性设置（包括把小图的一些9宫格信息拷贝过来
		public static void ModifyPNGMeta(string pngPath, string xmlPath, string smallPngPath)
		{
			if (Path.GetExtension(pngPath) == ".png" || Path.GetExtension(pngPath) == ".PNG")
			{
				string sheetPath = GetAssetPath(pngPath);

				TextureImporter asetImp = null;
				Dictionary<string, Vector4> tIpterMap = new Dictionary<string,Vector4>();

				if (Directory.Exists (smallPngPath)) {
					string[] fileName = Directory.GetFiles (smallPngPath);// 获取小图文件夹下的所有文件
					for (int j = 0; j < fileName.Length; j++) {
						string extenstion = Path.GetExtension (fileName [j]);
						if (extenstion == ".png") {
							Texture2D textureOrg = AssetDatabase.LoadAssetAtPath<Texture2D> (GetAssetPath (fileName [j]));
							string impPath = AssetDatabase.GetAssetPath (textureOrg);
							TextureImporter textureIpter = TextureImporter.GetAtPath (impPath) as TextureImporter;
							tIpterMap.Add (textureOrg.name, textureIpter.spriteBorder);
						}
					}
				} else {
					UnityEngine.Debug.LogError ("不存在小图路径:" + smallPngPath);
				}

				FileStream fs = new FileStream(xmlPath, FileMode.Open);
				StreamReader sr = new StreamReader(fs);
				string jText = sr.ReadToEnd();
				fs.Close();
				sr.Close();
				XmlDocument xml = new XmlDocument();
				xml.LoadXml(jText);
				XmlNodeList elemList = xml.GetElementsByTagName("SubTexture");

				int height = AssetDatabase.LoadAssetAtPath<Texture2D>(sheetPath).height;
				WriteMeta(elemList, tIpterMap, sheetPath, height);
			}
		}

		//如果这张图集已经拉好了9宫格，需要先保存起来
		static void SaveBoreder(Dictionary<string,Vector4> tIpterMap,TextureImporter tIpter, string name)
		{
			for(int i = 0,size = tIpter.spritesheet.Length; i < size; i++)
			{
				tIpterMap.Add(tIpter.spritesheet[i].name, tIpter.spritesheet[i].border);
			}
		}

		static TextureImporter GetTextureIpter(Texture2D texture)
		{
			TextureImporter textureIpter = null;
			string impPath = AssetDatabase.GetAssetPath(texture);
			textureIpter = TextureImporter.GetAtPath(impPath) as TextureImporter;
			return textureIpter;
		}

		static TextureImporter GetTextureIpter(string path)
		{
			TextureImporter textureIpter = null;
			Texture2D textureOrg = AssetDatabase.LoadAssetAtPath<Texture2D>(GetAssetPath(path));
			string impPath = AssetDatabase.GetAssetPath(textureOrg);
			textureIpter =  TextureImporter.GetAtPath(impPath) as TextureImporter;
			return textureIpter;
		}
		//写信息到SpritesSheet里
		static void WriteMeta(XmlNodeList elemList, Dictionary<string,Vector4> borders, string path, int imgHeigh)
		{
			TextureImporter asetImp = TextureImporter.GetAtPath(path) as TextureImporter;
			SpriteMetaData[] metaData = new SpriteMetaData[elemList.Count];
			for (int i = 0, size = elemList.Count; i < size; i++)
			{
				XmlElement node = (XmlElement)elemList.Item(i);
				Rect rect = new Rect();
				rect.x = int.Parse(node.GetAttribute("x"));
				rect.y = imgHeigh - int.Parse(node.GetAttribute("y")) - int.Parse(node.GetAttribute("height"));
				rect.width = int.Parse(node.GetAttribute("width"));
				rect.height = int.Parse(node.GetAttribute("height"));
				metaData[i].rect = rect;
				metaData[i].pivot = new Vector2(0.5f, 0.5f);
				metaData[i].name = node.GetAttribute("name");
				if (borders.ContainsKey(metaData[i].name))
				{
					metaData[i].border = borders[metaData[i].name];
				}
			}
			asetImp.spritesheet = metaData;
			asetImp.textureType = TextureImporterType.Sprite;
			asetImp.spriteImportMode = SpriteImportMode.Multiple;
			asetImp.mipmapEnabled = false;
			asetImp.SaveAndReimport();
		}

		static string GetAssetPath(string path)
		{
			string[] seperator = { "Assets" };
			string p = "Assets" + path.Split(seperator, StringSplitOptions.RemoveEmptyEntries)[1];
			return p;
		}

		static string GetOutputPath()
		{
			return Application.dataPath + "/CustomerResource/OutPut/";
		}

		public static string GetInputPath()
		{
			return Application.dataPath + "/CustomerResource/TTexture/";
		}

		public static string GetEffectImgInputPath()
		{
			return Application.dataPath + "/GameEffect/EffectResources/EffectTexture/";
		}

		public static bool IsIgnore(string path)
		{
			return path.Contains ("hcFonts") || path.Contains ("emoji");
		}
	}

}
//#endif