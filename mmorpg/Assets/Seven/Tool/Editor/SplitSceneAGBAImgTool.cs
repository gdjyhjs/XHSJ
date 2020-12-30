using UnityEngine;    
using System.Collections;    
using System.Collections.Generic;    
using UnityEditor;    
using System.IO;    
using System.Reflection; 
using UnityEngine.UI;

namespace Seven
{

	public class SplitSceneAGBAImgTool : EditorWindow
	{  
		static int winType = 0;
		static string folder;

		#region EditorWindow
		[MenuItem("Tools/场景/分离场景图片通道")]
		public static void OpenWindow()
		{
			winType = 1;
			EditorWindow.GetWindow(typeof(SplitSceneAGBAImgTool));
		}

		[MenuItem("Tools/场景/修改模型动画压缩模式")]
		public static void OpenCompress()
		{
			winType = 2;
			EditorWindow.GetWindow(typeof(SplitSceneAGBAImgTool));
		}

		void OnEnable()
		{
			folder = "";
		}

		void OnGUI()
		{
			if (winType == 1) {
				GUILayout.Label ("分离场景图片通道", EditorStyles.boldLabel);
				folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					SplitRgbAndAlphaChannel (folder);
				}

			}else if (winType == 2) {
				GUILayout.Label ("修改模型动画压缩模式", EditorStyles.boldLabel);
				if (GUILayout.Button ("开始")){
					ModifyCompress ();
				}

			}
		}
		#endregion EditorWindow


		static string GetTexturePath()
		{
			return Application.dataPath+"/Scene/";
		}


		//分离rgb和alpha通道
		static void SplitRgbAndAlphaChannel(string folder)  
		{  
			Debug.Log("开始分离");    
			string[] paths = Directory.GetFiles(GetTexturePath()+folder, "*_rgba.png", SearchOption.AllDirectories);
			if (paths.Length == 0) {
				Debug.Log("没有任何东西需要修改"); 
				return;
			}
			foreach (string path in paths)  
			{  
				if (!string.IsNullOrEmpty(path) && !IsIgnorePath(path) && IsTextureFile(path) && !IsTextureConverted(path))   //full name  
				{  
					SplitOneTextureChannel(path);  
				}  
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();
			ModifyMat (folder);
			ModifyIpt (folder);
			Debug.Log("分离结束");    
		}  

		static void SplitOneTextureChannel(string texPath)  
		{  
			//获得相对路径  
			string assetRelativePath = GetRelativeAssetPath(texPath);
			SetTextureReadable (assetRelativePath);
			Texture2D sourcetex = AssetDatabase.LoadAssetAtPath(assetRelativePath, typeof(Texture2D)) as Texture2D;  //not just the textures under Resources file  
			if (!sourcetex)  
			{  
				Debug.Log("读取图片失败 : " + assetRelativePath);  
				return;  
			}  

			string fileName = Path.GetFileName (texPath);
			string outputPath = texPath;
			if (Directory.Exists(outputPath.Replace(fileName,"")) == false)//如果不存在就创建file文件夹
			{
				Directory.CreateDirectory(outputPath.Replace(fileName,""));
			}
			Color[] colors = sourcetex.GetPixels();  
			Texture2D rgbTex2 = new Texture2D(sourcetex.width, sourcetex.height, TextureFormat.RGB24, false);  
			rgbTex2.SetPixels(colors);  
			rgbTex2.Apply();  
			string strPath_RGB = GetRGBTexPath(outputPath); 
			if (File.Exists (strPath_RGB)) {
				File.Delete (strPath_RGB);
			}
			File.WriteAllBytes(strPath_RGB, rgbTex2.EncodeToPNG());  


			Texture2D alphaTex2 = new Texture2D(sourcetex.width , sourcetex.height, TextureFormat.RGB24, false);  
			Color[] alphacolors = new Color[colors.Length];  
			for (int i = 0; i < colors.Length; ++i)  
			{  
				float value = colors[i].a / 3;
				alphacolors[i].r = value;  
				alphacolors[i].g = value;  
				alphacolors[i].b = value;  
			}  
			alphaTex2.SetPixels(alphacolors);  
			alphaTex2.Apply();  
			string strPath_Alpha = GetAlphaTexPath(outputPath);  
			if (File.Exists (strPath_Alpha)) {
				File.Delete (strPath_Alpha);
			}
			File.WriteAllBytes(strPath_Alpha, alphaTex2.EncodeToPNG());  

		}  

		//更换材质球图片
		static void ModifyMat(string folder)
		{
			string[] paths = Directory.GetFiles(GetTexturePath()+folder, "*_rgba.mat", SearchOption.AllDirectories);  
			foreach (string path in paths)  
			{  
				Material mat = AssetDatabase.LoadAssetAtPath(GetRelativeAssetPath(path), typeof(Material)) as Material;
				if (mat.shader.name == "Legacy Shaders/Transparent/Cutout/Diffuse") {
					Texture orgTex = mat.mainTexture;
					string texPath = AssetDatabase.GetAssetPath (orgTex);
					mat.shader = Shader.Find ("Legacy Shaders/Transparent/Cutout/Diffuse(rgb and a)");

					Texture mainTex = AssetDatabase.LoadAssetAtPath (texPath.Replace (".png", "_etc_rgb.png"), typeof(Texture)) as Texture;
					Texture alphaTex = AssetDatabase.LoadAssetAtPath (texPath.Replace (".png", "_etc_a.png"), typeof(Texture)) as Texture;
					mat.SetTexture ("_MainTex", mainTex);
					mat.SetTexture ("_AlphaTex", alphaTex);
//				mat.SetFloat ("_Cutoff", mat.GetFloat ("_Cutoff")*0.25f);
					AssetDatabase.DeleteAsset (texPath);
				} else if (mat.shader.name == "T4MShaders/ShaderModel2/Diffuse/T4M 4 Textures") {
					Texture controlTex = mat.GetTexture ("_Control");
					string texPath = AssetDatabase.GetAssetPath (controlTex);
					mat.shader = Shader.Find ("T4MShaders/ShaderModel2/Diffuse/T4M 4 Textures(rgb and a)");

					Texture mainTex = AssetDatabase.LoadAssetAtPath (texPath.Replace (".png", "_etc_rgb.png"), typeof(Texture)) as Texture;
					Texture alphaTex = AssetDatabase.LoadAssetAtPath (texPath.Replace (".png", "_etc_a.png"), typeof(Texture)) as Texture;
					mat.SetTexture ("_Control", mainTex);
					mat.SetTexture ("_ControlATex", alphaTex);
					AssetDatabase.DeleteAsset (texPath);
				}
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();
		}

		// 修改图片压缩格式
		static void ModifyIpt(string folder)
		{
			string[] paths = Directory.GetFiles (GetTexturePath()+folder, "*.*", SearchOption.AllDirectories);
			foreach (string path in paths) {
				string ext = Path.GetExtension (path);
				if (!ext.Equals (".png") && !ext.Equals (".exr")) {
					continue;
				}
				string assetPath =  path.Substring(path.IndexOf("Assets/"));
				bool isChange = false;
				TextureImporter import = AssetImporter.GetAtPath(assetPath) as TextureImporter;
				if (!import.GetPlatformTextureSettings ("Android").overridden) {
					import.SetPlatformTextureSettings ("Android", 2048, TextureImporterFormat.ETC_RGB4, false);
					isChange = true;
				}

				if (!import.GetPlatformTextureSettings ("iPhone").overridden) {
					import.SetPlatformTextureSettings ("iPhone", 2048, TextureImporterFormat.PVRTC_RGB4, false);
					isChange = true;
				}

				if(isChange)
					import.SaveAndReimport ();
			}
		}

		/// <summary>  
		/// 设置图片为可读格式  
		/// </summary>  
		/// <param name="_relativeAssetPath"></param>  
		static void SetTextureReadable(string _relativeAssetPath)  
		{  
			string postfix = GetFilePostfix(_relativeAssetPath);  
			if (postfix == ".dds")    // no need to set .dds file.  Using TextureImporter to .dds file would get casting type error.  
			{  
				return;  
			}  

			TextureImporter ti = (TextureImporter)TextureImporter.GetAtPath(_relativeAssetPath);  
			ti.isReadable = true;  
			AssetDatabase.ImportAsset(_relativeAssetPath);  
		} 

		static void ModifyCompress()
		{
			string[] paths = Directory.GetFiles(GetTexturePath(), "*.FBX", SearchOption.AllDirectories);
			foreach (string path in paths) {
				var assetPath = GetRelativeAssetPath(path);
				var modelImporter = AssetImporter.GetAtPath(assetPath) as ModelImporter;
				if (modelImporter == null)
					continue;

				if (modelImporter.meshCompression != ModelImporterMeshCompression.Low)
				{
					modelImporter.meshCompression = ModelImporterMeshCompression.Low;
					modelImporter.SaveAndReimport();
				}
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh ();
		}


		#region Path or 后缀  
		/// <summary>  
		/// 获得相对路径  
		/// </summary>  
		/// <param name="_fullPath"></param>  
		/// <returns></returns>  
		static string GetRelativeAssetPath(string fullPath)  
		{  
			fullPath = GetRightFormatPath(fullPath);  
			int idx = fullPath.IndexOf("Assets");  
			string assetRelativePath = fullPath.Substring(idx);  
			return assetRelativePath;  
		}  

		/// <summary>  
		/// 转换斜杠  
		/// </summary>  
		/// <param name="_path"></param>  
		/// <returns></returns>  
		static string GetRightFormatPath(string path)  
		{  
			return path.Replace("\\", "/");  
		}  

		/// <summary>  
		/// 获取文件后缀  
		/// </summary>  
		/// <param name="_filepath"></param>  
		/// <returns></returns>  
		static string GetFilePostfix(string filepath)   //including '.' eg ".tga", ".dds"  
		{  
			string postfix = "";  
			int idx = filepath.LastIndexOf('.');  
			if (idx > 0 && idx < filepath.Length)  
				postfix = filepath.Substring(idx, filepath.Length - idx);  
			return postfix;  
		}  

		static bool IsIgnorePath(string path)  
		{  
			return path.Contains("\\UI\\");  
		}  

		/// <summary>  
		/// 是否为图片  
		/// </summary>  
		/// <param name="_path"></param>  
		/// <returns></returns>  
		static bool IsTextureFile(string path)  
		{  
			path = path.ToLower();  
			return path.EndsWith(".psd") || path.EndsWith(".tga") || path.EndsWith(".png") || path.EndsWith(".jpg") || path.EndsWith(".dds") || path.EndsWith(".bmp") || path.EndsWith(".tif") || path.EndsWith(".gif");  
		}  

		/// <summary>  
		/// 是否已经转过  
		/// </summary>  
		/// <param name="_path"></param>  
		/// <returns></returns>  
		static bool IsTextureConverted(string path)  
		{  
			return path.Contains("_etc_rgb.") || path.Contains("_etc_a.");  
		}    

		static string GetRGBTexPath(string texPath)
		{  
			return ReplacePath(texPath, "_etc_rgb.");  
		}  

		static string GetAlphaTexPath(string texPath)  
		{  
			return ReplacePath(texPath, "_etc_a.");  
		}  

		static string ReplacePath(string texPath, string texRole)  
		{  
			string result = texPath.Replace(".", texRole);  
			string postfix = GetFilePostfix(texPath);
			return result.Replace(postfix, ".png");  
		}  
		#endregion   
	}  
}