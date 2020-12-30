using UnityEngine;    
using System.Collections;    
using System.Collections.Generic;    
using UnityEditor;    
using System.IO;    
using System.Reflection; 
using UnityEngine.UI;
using Hugula;
using Hugula.Editor;
using Hugula.Utils;
using Hugula.UGUIExtend;
using Seven.UI.PageScroller;
using Seven;
using UnityEditor.Animations;

namespace Seven
{
	public class EffectTools : EditorWindow
	{  
		static int winType = 0;
		static string folder;

		#region EditorWindow
		[MenuItem("Tools/SpritesPacker/分离3d特效图片通道")]
		public static void OpenWindow()
		{
			winType = 1;
			EditorWindow.GetWindow(typeof(EffectTools));
		}

		[MenuItem("Tools/SpritesPacker/更换特效材质球图片")]
		public static void CreateMat()
		{
			winType = 2;
			EditorWindow.GetWindow(typeof(EffectTools));
		}

		[MenuItem("Tools/SpritesPacker/更换特效prefab图片")]
		public static void CreatePrefab()
		{
			winType = 3;
			EditorWindow.GetWindow(typeof(EffectTools));
		}
		[MenuItem("Tools/SpritesPacker/拷贝特效资源")]
		public static void CopyRes()
		{
			winType = 4;
			EditorWindow.GetWindow(typeof(EffectTools));
		}
			
		void OnEnable()
		{
			folder = "";
		}

		void OnGUI()
		{
			if (winType == 1) {
				GUILayout.Label ("分离特效图片通道", EditorStyles.boldLabel);
				folder = EditorGUILayout.TextField("文件名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					SplitRgbAndAlphaChannel (GetInputTexturePath(), folder);
				}

			} else if (winType == 2) {
				GUILayout.Label ("更换特效材质球图片", EditorStyles.boldLabel);
//				folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					ChangeMatsImg();
				}

			}
			else if (winType == 3) {
				GUILayout.Label ("更换特效prefab图片", EditorStyles.boldLabel);
//				folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					ChangeEffectPrefab();
				}

			}
			else if (winType == 4) {
				GUILayout.Label ("拷贝特效资源", EditorStyles.boldLabel);
//				folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					CopyEffectRes ();
				}

			}
		}
		#endregion EditorWindow

		static string RootPath()
		{
			return Application.dataPath;
		}

		static string GetMatPath()  
		{  
			return Path.Combine(RootPath() ,"GameEffect/");  
		} 

		static string GetPrefabPath()  
		{  
			return Path.Combine(RootPath() ,"GameEffect/");  
		}  

		static string GetOutPrefabPath()  
		{  
			return Path.Combine(RootPath() ,"GameEffect/Prefab/");  
		}  

		static string GetOutputTexturePath()
		{
			return Path.Combine(RootPath() ,"GameEffect/EffectResources/EffectTexture/ImgRGBA/");
		}

		public static string GetInputTexturePath()
		{
			return Application.dataPath + "/GameEffect/EffectResources/EffectTexture/tietu 11/";
		}
		static string GetInputUITexturePath()
		{
			return Application.dataPath + "/CustomerResource/Texture/effect_ui_tex/";
		}

		static string s_inputPath = "";

		//分离rgb和alpha通道
		public static void SplitRgbAndAlphaChannel(string inputPath, string fileName = "")  
		{  
			s_inputPath = inputPath;

			Debug.Log("开始分离"); 
			if (folder == null) {
				folder = "";
			}
			if (folder.Equals ("")) {
				string[] paths = Directory.GetFiles (inputPath, "*.png", SearchOption.AllDirectories);  
				foreach (string path in paths) {  
//					if (!string.IsNullOrEmpty (path) && !IsIgnorePath (path) && IsTextureFile (path) && !IsTextureConverted (path)) {   //full name  
						SplitOneTextureChannel (path);  
//					}  
				}
			} else {
				SplitOneTextureChannel (Path.Combine (inputPath, fileName+".png"));
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();  
			if (inputPath == GetInputTexturePath ()) {
				CopyRenderTexture ();
			}
			ReImportAsset();
			Debug.Log("分离结束");    
		}

		//打包某些文件夹
		public static void SplitRgbAndAFolders()
		{
			foreach (string arg in System.Environment.GetCommandLineArgs())
			{
				if (arg.StartsWith("var"))
				{
					string[] folders = arg.Split (':') [1].Split (',');
					foreach (string folder in folders) {
						if (!folder.Equals ("")) {
							SplitRgbAndAlphaChannel (folder);
						}
					}
				}
			}
		}

		static void CopyRenderTexture()
		{
			string[] paths = Directory.GetFiles (GetInputTexturePath(), "*.renderTexture", SearchOption.AllDirectories); 
			foreach (string path in paths)  
			{  
				string output = Path.Combine(GetOutputTexturePath(), Path.GetFileName(path));
				string folder = output.Replace (Path.GetFileName (output), "");
				EditorUtils.CheckDirectory (folder);
				AssetDatabase.DeleteAsset (GetRelativeAssetPath (output));
				File.Copy (path, output, true);
			}
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
			string outputPath = Path.Combine(GetOutputTexturePath(), fileName);
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
			AddImport(strPath_RGB, rgbTex2.width, rgbTex2.height);  

			Texture2D alphaTex2 = new Texture2D(sourcetex.width , sourcetex.height, TextureFormat.RGB24, false);  
			Color[] alphacolors = new Color[colors.Length];  
			for (int i = 0; i < colors.Length; ++i)  
			{  
				float value = colors[i].a;
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
			AddImport(strPath_Alpha, alphaTex2.width, alphaTex2.height);
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

		static Dictionary<string, int[]> ReImportList = new Dictionary<string, int[]>();  
		static void AddImport(string path, int width, int height)  
		{  
			if (ReImportList.ContainsKey (path)) {
				ReImportList [path] = new int[] { width, height };
			} else {
				ReImportList.Add(path, new int[] { width, height });  
			}
		}  

		/// <summary>  
		/// 设置图片格式  
		/// </summary>  
		static void ReImportAsset()  
		{  
			Debug.Log ("开始拷贝图片信息...");
			foreach (var item in ReImportList)  
			{  
				TextureImporter importer = null;  
				string assetpath = GetRelativeAssetPath(item.Key); 

				TextureImporter baseImporter = null;
				string basePath = GetRelativeAssetPath(Path.Combine(s_inputPath, Path.GetFileName(assetpath).Replace("_etc_a","").Replace("_etc_rgb",""))) ;

				try  
				{  
					importer = (TextureImporter)TextureImporter.GetAtPath(assetpath);  
					baseImporter = (TextureImporter)TextureImporter.GetAtPath(basePath);
				}  
				catch  
				{  
					Debug.LogError("Load Texture failed: " + assetpath);  
					return;  
				}  

				if (importer == null)  
				{  
					Debug.Log("importer null:" + assetpath);  
					return;  
				}  

				importer.textureType = baseImporter.textureType;  
				importer.isReadable =  baseImporter.isReadable;  //increase memory cost if readable is true    

				importer.mipmapEnabled =  baseImporter.mipmapEnabled;  

				importer.wrapMode =  baseImporter.wrapMode;  
				importer.anisoLevel =  baseImporter.anisoLevel;  

				importer.maxTextureSize =  baseImporter.maxTextureSize;  
				importer.textureFormat = TextureImporterFormat.ETC_RGB4;  
				importer.compressionQuality = 50;  

				importer.spriteImportMode =  baseImporter.spriteImportMode;
				importer.spritesheet = baseImporter.spritesheet;

				importer.SetPlatformTextureSettings ("Android", 2048, TextureImporterFormat.ETC_RGB4, false);
				importer.SetPlatformTextureSettings ("iPhone", 2048, TextureImporterFormat.PVRTC_RGB4, false);

				if (basePath.Contains ("npcchat")) {
					importer.mipmapEnabled = false;
				}
				string name = Path.GetFileNameWithoutExtension (assetpath);
				importer.assetBundleName = CUtils.GetRightFileName (name)+Common.CHECK_ASSETBUNDLE_SUFFIX;

				importer.SaveAndReimport ();
				AssetDatabase.ImportAsset(item.Key); 
			} 

			Debug.Log ("拷贝图片信息完成！");
		}  


		public static void ChangeEffectPrefab(string fileName = "")
		{
			InitUIBigImg ();

			if (fileName.Equals ("")) {
				string[] paths = Directory.GetFiles (GetPrefabPath (), "*.prefab", SearchOption.AllDirectories);  
				foreach (string path in paths) {  
//					if (path.Contains ("4100") || path.Contains ("guide_arrows")) {
						ChangeOneEffectPrefab (path);
//					}
				}
			} else {
				ChangeOneEffectPrefab (Path.Combine (GetPrefabPath (), fileName+".prefab"));
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh ();
		}

		static bool isHave = false;
		public static void ChangeOneEffectPrefab(string path)
		{
			string assetPath =  GetRelativeAssetPath(path);
			Debug.Log ("开始更换特效prefab：" + assetPath);
			GameObject prefab = AssetDatabase.LoadAssetAtPath(assetPath, typeof(GameObject)) as GameObject;
			prefab = Instantiate (prefab);
			isHave = false;
			ChangePrefabImg (prefab.transform);
			if (isHave) {
//				string output = GetRelativeAssetPath (Path.Combine (GetOutPrefabPath (), Path.GetFileName (path)));
//				EditorUtils.CheckDirectory (output.Replace (Path.GetFileName (output), ""));
//				GameObject obj = PrefabUtility.CreatePrefab (output, prefab);
//				Hugula.Editor.BuildScript.SetAssetBundleName (obj, true);
				GameObject obj = PrefabUtility.CreatePrefab (assetPath, prefab);
			}
		}

		static Dictionary<string, Sprite> sprites = new Dictionary<string, Sprite> ();
		public static void InitUIBigImg()
		{
			Object[] _atlas = UnityEditor.AssetDatabase.LoadAllAssetsAtPath  ("Assets/CustomerResource/Texture/effect_ui_tex/big_effect_ui_tex_etc_rgb.png");
			for (int i = 0; i < _atlas.Length; i++) {  
				if (_atlas [i].GetType () == typeof(UnityEngine.Sprite)) {  
					Sprite sp = _atlas [i] as Sprite;
					sprites.Add (sp.name, sp);
				}  
			} 
		}

		public static Sprite GetSprite(string name)
		{
			if (sprites.ContainsKey (name)) {
				return sprites [name];
			}
			return null;
		}

		public static void ChangePrefabImg(Transform root)
		{
			foreach (Transform child in root) {
				Image img = child.GetComponent<Image>();

				if(img != null && typeof(SImage) != img.GetType())
				{
					string imgName = img.mainTexture.name;
					Sprite sp = GetSprite(imgName); 
					if (sp == null) {
						string rgbPath = GetRelativeAssetPath(Path.Combine (GetOutputTexturePath (), imgName + "_etc_rgb.png"));
						sp = UnityEditor.AssetDatabase.LoadAssetAtPath (rgbPath, typeof(Sprite)) as Sprite;
					}
					Image.Type ty = img.type;
					Color color = img.color;
					bool rayt = img.raycastTarget;
					Image.FillMethod fillMethod = img.fillMethod;
					int fillOrg = img.fillOrigin;
					float fillAmount = img.fillAmount;
					bool enable = img.enabled;
					Material mat = img.material;

					DestroyImmediate (img);
					SImage simg = child.gameObject.AddComponent<SImage> ();
					simg.type = ty;
					simg.sprite = sp;
					simg.color = color;
					simg.raycastTarget = rayt;
					simg.fillMethod = fillMethod;
					simg.fillOrigin = fillOrg;
					simg.fillAmount = fillAmount;
					simg.material = mat;
					simg.enabled = enable;

					isHave = true;
				}
				if (child.childCount > 0) {
					ChangePrefabImg (child);
				}
			}
		
		}

		public static void ChangeMatsImg()
		{
			string[] paths = Directory.GetFiles (GetMatPath (), "*.mat", SearchOption.AllDirectories);  
			foreach (string path in paths) {  
				if (!ChangeMatImg (path)) {
					continue;
				}
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh ();
		}

		static bool ChangeMatImg(string path)
		{
			var mat = UnityEditor.AssetDatabase.LoadAssetAtPath (GetRelativeAssetPath(path), typeof(Material)) as Material;
			if (mat == null) {
				return false;
			}
			if (mat.mainTexture == null) {
				return false;
			}
			string imgName = mat.mainTexture.name;
			string rgbPath = GetRelativeAssetPath(Path.Combine (GetOutputTexturePath (), imgName + "_etc_rgb.png"));
			string aPath = GetRelativeAssetPath(Path.Combine (GetOutputTexturePath (), imgName + "_etc_a.png"));

			string shaderName = mat.shader.name;
			if (!shaderName.Equals ("Particles/Additive") && !shaderName.Equals("Particles/Alpha Blended")) {
				return false;
			}
			shaderName = "Seven/" + shaderName;
			
			Texture2D rgbTex = (Texture2D)UnityEditor.AssetDatabase.LoadAssetAtPath (rgbPath, typeof(Texture2D));
			Texture2D aTex = (Texture2D)UnityEditor.AssetDatabase.LoadAssetAtPath (aPath, typeof(Texture2D));
			if (rgbTex == null || aTex == null) {
				rgbTex = (Texture2D)UnityEditor.AssetDatabase.LoadAssetAtPath ("Assets/CustomerResource/Texture/effect_ui_tex/big_effect_ui_tex_etc_rgb.png", typeof(Texture2D));
				aTex = (Texture2D)UnityEditor.AssetDatabase.LoadAssetAtPath ("Assets/CustomerResource/Texture/effect_ui_tex/big_effect_ui_tex_etc_a.png", typeof(Texture2D));
//				return false;
			}
			mat.shader = Shader.Find (shaderName);
			mat.SetTexture ("_MainTex", rgbTex);
			mat.SetTexture ("_AlphaTex", aTex);
			return true;
		}


		public static void CopyEffectRes()
		{
			string spath = Path.Combine (Application.dataPath, "GameEffect");
			string dpath = Path.Combine (Path.GetFullPath (".."), "EffectRGBA");
			ProjectBuild.CopyDirectory (Path.Combine(spath,"EasyWater"), Path.Combine(dpath,"EasyWater"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"GameEffects"), Path.Combine(dpath,"GameEffects"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"Script"), Path.Combine(dpath,"Script"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"EffectResources/Animation"), Path.Combine(dpath,"EffectResources/Animation"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"EffectResources/EffectMaterial"), Path.Combine(dpath,"EffectResources/EffectMaterial"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"EffectResources/EffectModel"), Path.Combine(dpath,"EffectResources/EffectModel"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"EffectResources/EffectTexture/ImgRGBA"), Path.Combine(dpath,"EffectResources/EffectTexture/ImgRGBA"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"EffectResources/EffectTexture/renderTexture"), Path.Combine(dpath,"EffectResources/EffectTexture/renderTexture"), true);
			ProjectBuild.CopyDirectory (Path.Combine(spath,"EffectResources/EffectTexture/waterTexture"), Path.Combine(dpath,"EffectResources/EffectTexture/waterTexture"), true);
		}

		public static void Run()
		{
			SplitRgbAndAlphaChannel (GetInputTexturePath ());
			ChangeMatsImg ();
			ChangeEffectPrefab ();
			CopyEffectRes ();
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