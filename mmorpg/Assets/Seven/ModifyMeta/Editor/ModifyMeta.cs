using System.Linq;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using System.IO;
using Hugula.Editor;
using Hugula.Utils;

public class ModifyMeta : EditorWindow
{
	#region const
	private string rootFolder = "Assets/CustomerResource/Texture/";
	static int winType = 0;
	#endregion const

	#region private members


	#endregion private members

	#region EditorWindow
	[MenuItem("Tools/修改UI图片设置")]
	public static void OpenWindow()
	{
		winType = 1;
		EditorWindow.GetWindow(typeof(ModifyMeta));
	}

	[MenuItem("Tools/修改模型图片")]
	public static void OpenCompress()
	{
		winType = 2;
		EditorWindow.GetWindow(typeof(ModifyMeta));
	}

	[MenuItem("Tools/设置文件夹ABName")]
	public static void SetFolderABName()
	{
		winType = 3;
		EditorWindow.GetWindow(typeof(ModifyMeta));
	}

	[MenuItem("Tools/清除文件夹ABName")]
	public static void ClearFolderABName()
	{
		winType = 4;
		EditorWindow.GetWindow(typeof(ModifyMeta));
	}

	void OnEnable()
	{
		
	}

	static string folder;
	void OnGUI()
	{
		
		if (winType == 1) {
			if (GUILayout.Button ("开始"))
				CreateAnimationAssets ();

		} else if (winType == 2) {
			GUILayout.Label ("修改模型图片", EditorStyles.boldLabel);
			if (GUILayout.Button ("开始")) {
				ModifyModelImg ();
			}
		}else if (winType == 3) {
			GUILayout.Label ("设置文件夹ABName", EditorStyles.boldLabel);

			folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
			if (GUILayout.Button ("开始")) {
				if (!folder.Equals ("")) {
					SetFolderABName (folder);
				}
			}
		}else if (winType == 4) {
			GUILayout.Label ("清除文件夹ABName", EditorStyles.boldLabel);

			folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
			if (GUILayout.Button ("开始")) {
				if (!folder.Equals ("")) {
					ClearFolderABName (folder);
				}
			}
		}
	}
	#endregion EditorWindow

	public void CreateAnimationAssets()
	{
		if (!Directory.Exists(rootFolder))
		{
			return;
		}

		Modify (rootFolder);
		Modify (rootFolder + "icon/");

		AssetDatabase.Refresh ();
		Debug.Log ("修改meta成功！");
	}

	public void Modify(string rootFolder, bool isAbName = true, bool isPacking = true)
	{
		// 遍历目录，查找生成controller文件
		var folders = Directory.GetDirectories(rootFolder);
		foreach (var folder in folders)
		{
			DirectoryInfo info = new DirectoryInfo(folder);

			// 给文件夹加上ab name
			if(isAbName){
				string ap =  info.FullName.Substring(info.FullName.IndexOf("Assets/"));
				AssetImporter ip = AssetImporter.GetAtPath(ap) as AssetImporter;
				if(ip.assetBundleName == ""){
					string objName = info.Name.ToLower ()+"_folder";
					objName = HugulaEditorSetting.instance.GetAssetBundleNameByReplaceIgnore (objName);
					string name = CUtils.GetRightFileName (objName);
					var suffix = Common.CHECK_ASSETBUNDLE_SUFFIX;
					ip.assetBundleName = name + suffix;
					ip.SaveAndReimport ();
				}
			}

			foreach(FileInfo f in info.GetFiles("*.png")) //查找文件
			{
				string path = f.FullName;
				string assetPath =  path.Substring(path.IndexOf("Assets/"));
				//				string text = File.ReadAllText(path);
				bool isChange = false;
				TextureImporter import = AssetImporter.GetAtPath(assetPath) as TextureImporter;
				if (import.textureType != TextureImporterType.Sprite) 
				{
					import.textureType = TextureImporterType.Sprite;
					isChange = true;
				}
				//图标不设置图集
				if (isPacking) {
					if (import.spritePackingTag != info.Name) 
					{
						import.spritePackingTag = info.Name;
						isChange = true;
					}
				} else 
				{
					if (import.spritePackingTag != "") 
					{
						import.spritePackingTag = "";
						isChange = true;
					}
				}

				if (import.mipmapEnabled) 
				{
					import.mipmapEnabled = false;
					isChange = true;
				}

				if (!import.crunchedCompression) 
				{
					import.crunchedCompression = true;
					import.compressionQuality = 50;
					isChange = true;
				}
				#if UNITY_IPHONE
//				if (!import.isReadable) {
//					import.isReadable = true;
//					isChange = true;
//				}
				if (!import.GetPlatformTextureSettings ("iPhone").overridden) {
					import.SetPlatformTextureSettings ("iPhone", 2048, TextureImporterFormat.PVRTC_RGB4, true);
					isChange = true;
				}
				#endif
//				if (import.maxTextureSize != 512) 
//				{
//					import.maxTextureSize = 512;
//					isChange = true;
//				}
				#if UNITY_ANDROID
				if (!import.GetPlatformTextureSettings ("Android").overridden) 
				{
					import.SetPlatformTextureSettings ("Android", 2048, TextureImporterFormat.ETC_RGB4, true);
					isChange = true;
				}
				#endif

//				if (import.assetBundleName == "") 
//				{
//					string objName = f.Name.ToLower ();
//					objName = HugulaEditorSetting.instance.GetAssetBundleNameByReplaceIgnore (objName);
//					string name = CUtils.GetRightFileName (objName);
//					var suffix = Common.CHECK_ASSETBUNDLE_SUFFIX;
//					import.assetBundleName = name + suffix;
//					isChange = true;
//				}

				if(isChange)
					import.SaveAndReimport ();
			}
		}
	}

	//修改模型图片压缩格式
	public void ModifyModelImg()
	{
		Debug.Log ("开始修改模型图片...");
		string root = Path.Combine (Application.dataPath, "Model");
		string[] paths = Directory.GetFiles (root, "*.png", SearchOption.AllDirectories);
		foreach (string path in paths) {
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
		Debug.Log ("修改模型图片完成！");
	}

	//添加文件夹abname
	public void SetFolderABName(string folder)
	{
		var folders = Directory.GetDirectories(Path.Combine(Application.dataPath, folder));
		foreach (var f in folders)
		{
			DirectoryInfo info = new DirectoryInfo(f);
			string ap =  info.FullName.Substring(info.FullName.IndexOf("Assets/"));
			AssetImporter ip = AssetImporter.GetAtPath(ap) as AssetImporter;
			if(ip.assetBundleName == ""){
				string objName = folder+info.Name.ToLower ()+"_folder";
				objName = HugulaEditorSetting.instance.GetAssetBundleNameByReplaceIgnore (objName);
				string name = CUtils.GetRightFileName (objName);
				var suffix = Common.CHECK_ASSETBUNDLE_SUFFIX;
				ip.assetBundleName = name + suffix;
				ip.SaveAndReimport ();
			}
		}
		AssetDatabase.Refresh ();
	}

	public void ClearFolderABName(string folder)
	{
		var folders = Directory.GetDirectories(Path.Combine(Application.dataPath, folder));
		foreach (var f in folders)
		{
			DirectoryInfo info = new DirectoryInfo(f);
			string ap =  info.FullName.Substring(info.FullName.IndexOf("Assets/"));
			AssetImporter ip = AssetImporter.GetAtPath(ap) as AssetImporter;
			if(ip.assetBundleName != ""){
				ip.assetBundleName = "";
				ip.SaveAndReimport ();
			}
		}
		AssetDatabase.Refresh ();
	}
}
