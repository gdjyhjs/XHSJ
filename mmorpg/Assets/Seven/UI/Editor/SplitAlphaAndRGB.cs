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
	public class STManage {  
		private static STManage m_pContainer = null;  
		public static STManage getInstance(){  
			if(m_pContainer == null){  
				m_pContainer = new STManage();
				m_pContainer.initData ();
			}
			return m_pContainer;  
		}  
		private Dictionary<string, Object[]> m_pAtlasDic;//图集的集合  
		void Awake(){  
			initData ();  
		}  
		private void initData(){  
			m_pAtlasDic = new Dictionary<string, Object[]> ();  
		}  
		// Use this for initialization  
		void Start () {  
		}  

		public void LoadSprite(string path)
		{
			DeleteAtlas (path);
			Object[] _atlas = UnityEditor.AssetDatabase.LoadAllAssetsAtPath  (path);  
			m_pAtlasDic.Add (path,_atlas);  
		}

		public Sprite GetSprite(string name)
		{
			Sprite sp = null;
			string k = null;
			foreach (string key in m_pAtlasDic.Keys) {
				sp = SpriteFormAtlas (m_pAtlasDic [key], name);
				k = key.Replace("_rgb.png", "");
				if (sp) {
					break;
				}
			}

			if (sp == null)
				return null;

			return sp;
		}

		//删除图集缓存  
		public void DeleteAtlas(string path){  
			if (m_pAtlasDic.ContainsKey (path)) {  
				m_pAtlasDic.Remove (path);  
			}  
		}  

		//从图集中，并找出sprite  
		private Sprite SpriteFormAtlas(Object[] _atlas,string _spriteName){  
			for (int i = 0; i < _atlas.Length; i++) {  
				if (_atlas [i].GetType () == typeof(UnityEngine.Sprite)) {  
					if(_atlas [i].name == _spriteName){  
						return (Sprite)_atlas [i];  
					}  
				}  
			}  
			//			Debug.LogWarning ("图片名:"+_spriteName+";在图集中找不到");  
			return null;  
		} 

		//导出lua查找文件
		public void ExiportLua()
		{
			string lua = "local tbl = {\n";
			foreach(string key in m_pAtlasDic.Keys){
				Object[] altas = m_pAtlasDic[key];
				string[] t = key.Split('/');
				t = t[t.Length-1].Split('.');
				string bigName = t[0];
				foreach(var sprite in altas){
					lua += "	[\""+sprite.name+"\"] = \""+bigName+"\",\n";
				}
			}
			lua += "}\n";
			lua += "return tbl";
			Debug.Log("导出lua完成："+lua);

			string luaPath = Application.dataPath+"/Lua/config/altas_sprite.lua";
			File.Delete (luaPath);
			using (StreamWriter sr = new StreamWriter(luaPath, false))
			{
				sr.Write(lua);
			}
		}
	}  

	public class SplitAlphaAndRGB : EditorWindow
	{  
		static int winType = 0;
		static string folder;

		#region EditorWindow
		[MenuItem("Tools/SpritesPacker/分离图片通道")]
		public static void OpenWindow()
		{
			winType = 1;
			EditorWindow.GetWindow(typeof(SplitAlphaAndRGB));
		}

		[MenuItem("Tools/SpritesPacker/更换UI图片")]
		public static void CreateMat()
		{
			winType = 2;
			EditorWindow.GetWindow(typeof(SplitAlphaAndRGB));
		}

		//		[MenuItem("Tools/SpritesPacker/更换prefab UGUI图片")]
		public static void ModifyPrefabImg()
		{
			winType = 3;
			EditorWindow.GetWindow(typeof(SplitAlphaAndRGB));
		}

		void OnEnable()
		{
			folder = "";
		}

		void OnGUI()
		{
			if (winType == 1) {
				GUILayout.Label ("分离图片通道", EditorStyles.boldLabel);
				folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					SplitRgbAndAlphaChannel (folder);
				}

			} else if (winType == 2) {
				GUILayout.Label ("更换UI图片", EditorStyles.boldLabel);
				folder = EditorGUILayout.TextField("文件夹名字(默认导出所有)", folder);
				if (GUILayout.Button ("开始")){
					ChangeUI (folder);
				}

			} else if (winType == 3) {
				if (GUILayout.Button ("开始")) {
				}
			}
		}
		#endregion EditorWindow

		static string GetUIPath()  
		{  
			return Application.dataPath + "/CustomerResource/TUI/";  
		}  

		static string GetTexturePath()
		{
			return Application.dataPath + "/CustomerResource/OutPut/";
		}

		static string GetBigTexturePath()
		{
			return Application.dataPath + "/CustomerResource/Texture/";
		}


		//分离rgb和alpha通道
		public static void SplitRgbAndAlphaChannel(string folder = "")  
		{  
			Debug.Log("开始分离"); 
			if (folder == null) {
				folder = "";
			}
			string[] paths = Directory.GetFiles(GetTexturePath()+folder, "*.*", SearchOption.AllDirectories);  
			foreach (string path in paths)  
			{  
				if (!string.IsNullOrEmpty(path) && !IsIgnorePath(path) && IsTextureFile(path) && !IsTextureConverted(path))   //full name  
				{  
					SplitOneTextureChannel(path);  
				}  
			}
			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();  
			ReImportAsset();  
			SetAllABName ();
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
			string outputPath = texPath.Replace ("OutPut", "Texture");
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
				int idx	= assetpath.IndexOf ("_etc");
				string basePath = assetpath.Substring (0, idx).Replace("Texture","OutPut") + ".png";

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

				importer.textureType = TextureImporterType.Sprite;  
				importer.isReadable = false;  //increase memory cost if readable is true    

				importer.mipmapEnabled = false;  

				importer.wrapMode = TextureWrapMode.Clamp;  
				importer.anisoLevel = 1;  

				importer.maxTextureSize = Mathf.Max(item.Value[0], item.Value[1]);  
				importer.textureFormat = TextureImporterFormat.ETC_RGB4;  
				importer.compressionQuality = 50;  

				importer.spriteImportMode = SpriteImportMode.Multiple;
				if (baseImporter != null) {
					importer.spritesheet = baseImporter.spritesheet;
				} else {
					Debug.LogError ("找不到图片meta："+basePath);
				}
				importer.SetPlatformTextureSettings ("Android", 2048, TextureImporterFormat.ETC_RGB4, false);
				importer.SetPlatformTextureSettings ("iPhone", 2048, TextureImporterFormat.PVRTC_RGB4, false);

//				string name = Path.GetFileNameWithoutExtension (assetpath).Replace ("_rgb", "").Replace ("_a", "");
//				importer.assetBundleName = CUtils.GetRightFileName (name)+Common.CHECK_ASSETBUNDLE_SUFFIX;

				importer.SaveAndReimport ();
				AssetDatabase.ImportAsset(item.Key); 
			} 

			//			foreach (string path in ReImportList.Keys) {
			//				if (path.Contains ("etc_rgb")) {
			//					AssetDatabase.DeleteAsset (GetRelativeAssetPath(path.Replace ("_etc_rgb", "")));
			//				}
			//			}
			Debug.Log ("拷贝图片信息完成！");
		}  

		//递归所有UI Prefab
		public static void  ChangeUI(string folder = "")
		{
			if (folder == null) {
				folder = "";
			}
			LoadAllRgbPng ();

			folder = Path.Combine (GetUIPath (), folder);

			//拷贝除了prefab
//			CopyFiles (Directory.GetFiles (folder, "*.anim", SearchOption.AllDirectories));
//			AssetDatabase.Refresh ();
//			CopyFiles (Directory.GetFiles (folder, "*.mat", SearchOption.AllDirectories));
//			CopyFiles (Directory.GetFiles (folder, "*.controller", SearchOption.AllDirectories));
//			CopyFiles (Directory.GetFiles (folder, "*.shader", SearchOption.AllDirectories));
//			CopyFiles (Directory.GetFiles (folder, "*.cs", SearchOption.AllDirectories));
//			AssetDatabase.Refresh ();

			string[] paths = Directory.GetFiles(folder, "*.prefab", SearchOption.AllDirectories);
			foreach (string path in paths)  
			{  
				ChangePrefab (path);
			}

			AssetDatabase.SaveAssets ();
			AssetDatabase.Refresh();
			Debug.Log ("prefab更换图片完成");
		}

		static void CopyFiles(string[] paths)
		{
			foreach (string path in paths)  
			{  
				string output = path.Replace ("TUI/", "UI/");
				string folder = output.Replace (Path.GetFileName (output), "");
				EditorUtils.CheckDirectory (folder);
				AssetDatabase.DeleteAsset (GetRelativeAssetPath (output));
				File.Copy (path, output, true);
			}
		}

		public static void ChangePrefab(string path)
		{
			string assetPath =  GetRelativeAssetPath(path);
			Debug.Log ("开始更换ui：" + assetPath);
			GameObject prefab = AssetDatabase.LoadAssetAtPath(assetPath, typeof(GameObject)) as GameObject;
			prefab = Instantiate (prefab);

			ClearImgDic ();
			ChangeImage(prefab.transform);
			string output = assetPath.Replace ("/TUI/", "/UI/");
			EditorUtils.CheckDirectory (output.Replace (Path.GetFileName (output), ""));
			GameObject obj = PrefabUtility.CreatePrefab(output, prefab);
			Hugula.Editor.BuildScript.SetAssetBundleName (obj, true);
		}

		//转换为某些prefab
		public static void ChangePrefabs()
		{
			LoadAllRgbPng ();
			foreach (string arg in System.Environment.GetCommandLineArgs())
			{
				if (arg.StartsWith("var"))
				{
					string[] files = arg.Split (':') [1].Split (',');
					foreach (string file in files) {
						if (!file.Equals ("")) {
							string path = Path.Combine(Path.Combine (Application.dataPath, "CustomerResource/TUI"), file);
							ChangePrefab (path);
						}
					}
				}
			}
		}

		// 加载所有的rgb图片
		static void LoadAllRgbPng()
		{
			// 遍历目录，查找生成controller文件
			string[] paths = Directory.GetFiles(GetBigTexturePath(), "*rgb.png", SearchOption.AllDirectories);
			foreach (string path in paths)  
			{  
				STManage.getInstance ().LoadSprite (GetRelativeAssetPath (path));
			}  
			STManage.getInstance().ExiportLua();
		}

		static Dictionary<Image, object[]> imgDic = new Dictionary<Image, object[]> ();
		static Dictionary<Image, object[]> imgDicCell = new Dictionary<Image, object[]> ();
		static Dictionary<Image, object[]> imgDicItem = new Dictionary<Image, object[]> ();
		static Dictionary<Image, object[]> imgDicRItem = new Dictionary<Image, object[]> ();
		static Dictionary<Image, object[]> imgLoopItem = new Dictionary<Image, object[]> ();
		static Dictionary<Image, Toggle> toggleList = new Dictionary<Image, Toggle> ();

		static void ClearImgDic()
		{
			imgDic.Clear ();
			imgDicCell.Clear ();
			imgDicItem.Clear ();
			imgDicRItem.Clear ();
			imgLoopItem.Clear ();
			toggleList.Clear ();
		}

		static void InitImgDic(Object[] list, System.Type ty, Dictionary<Image, object[]> imgDic)
		{
			for (int i = 0; i < list.Length; i++) {
				var refer = list [i];
				int length = 0;
				Object[] monos = null;
				if (ty == typeof(ReferGameObjects)) {
					length = ((ReferGameObjects)refer).Length;
					monos = ((ReferGameObjects)refer).monos;
				} else if (ty == typeof(Cell)) {
					length = ((Cell)refer).Length;
					monos = ((Cell)refer).monos;
				}else if (ty == typeof(ScrollRectItem)) {
					length = ((ScrollRectItem)refer).Length;
					monos = ((ScrollRectItem)refer).monos;
				}else if (ty == typeof(LoopItem)) {
					length = ((LoopItem)refer).Length;
					monos = ((LoopItem)refer).monos;
					//					Debug.Log (list+","+length+","+monos+","+((LoopItem)refer).gameObject.name);
				}

				for (int j = 0; j < length; j++) {
					var obj = monos[j];
					if (obj != null && typeof(Image) == obj.GetType()) {
						if (!imgDic.ContainsKey ((Image)obj)) {
							object[] l = new object[2];
							l [0] = j;
							l [1] = refer;
							//							Debug.Log ("添加图片" + ((Image)obj).sprite.name);
							imgDic.Add ((Image)obj, l);
						} else {
							//							Debug.Log("已经包含图片名字："+obj.name);
							object[] old = imgDic [(Image)obj];
							object[] l = new object[old.Length + 2];
							for (int k = 0; k < old.Length; k++) {
								l[k] = old [k];
							}
							l [old.Length] = j;
							l [old.Length+1] = refer;
							imgDic [(Image)obj] = l;
						}
					}
				}
			}
		}

		static void InitImgDic(Transform root)
		{
			ReferGameObjects[] referList = root.GetComponents<ReferGameObjects> ();
			InitImgDic (referList, typeof(ReferGameObjects), imgDic);

			Cell[] cellList = root.GetComponents<Cell> ();
			InitImgDic (cellList, typeof(Cell), imgDicCell);

			ScrollRectItem[] sItemList = root.GetComponents<ScrollRectItem> ();
			InitImgDic (sItemList, typeof(ScrollRectItem), imgDicRItem);

			LoopItem[] lItemList = root.GetComponents<LoopItem> ();
			InitImgDic (lItemList, typeof(LoopItem), imgLoopItem);

			Item[] itemList = root.GetComponents<Item> ();
			for (int i = 0; i < itemList.Length; i++) {
				Item item = itemList [i];

				foreach (string key in item.ObjDic.Keys) {
					var obj = item.ObjDic[key];
					if (obj != null && typeof(Image) == obj.GetType()) {
						object[] l = new object[2];
						l [0] = key;
						l [1] = item;
						imgDicItem.Add ((Image)obj, l);
					}
				}
			}
		}

		static object[] GetImgValue(Image img, Dictionary<Image, object[]> imgDic)
		{
			//			Debug.Log ("获取图片"+img.sprite.name+", "+imgDic.ContainsKey (img));
			if (imgDic.ContainsKey (img)) {
				return imgDic [img];
			}
			return null;
		}

		static void ChangeImgDic(object[] list, SImage simg, System.Type ty)
		{
			if (list != null) {

				for (int i = 0; i < list.Length;i += 2) {
					var refer = list [i+1];
					Object[] monos = null;
					if (ty == typeof(ReferGameObjects)) {
						monos = ((ReferGameObjects)refer).monos;
					} else if (ty == typeof(Cell)) {
						monos = ((Cell)refer).monos;
					}else if (ty == typeof(ScrollRectItem)) {
						monos = ((ScrollRectItem)refer).monos;
					}else if (ty == typeof(LoopItem)) {
						monos = ((LoopItem)refer).monos;
					}
					int index = (int)list [i];
					monos [index] = simg;
				}
			}
		}

		static void InitToggles(Transform root)
		{
			Toggle[] objs = root.GetComponents<Toggle> ();
			foreach(Toggle tog in objs){
				if (tog.graphic != null && !toggleList.ContainsKey((Image)tog.graphic)) {
					toggleList.Add ((Image)tog.graphic, tog);
				}
			}
		}

		static Toggle GetToggle(Image img)
		{
			if (toggleList.ContainsKey (img)) {
				return toggleList [img];
			}
			return null;
		}


		static void ChangeImage(Transform root)
		{
			InitImgDic (root);
			InitToggles (root);
			foreach(Transform child in root)
			{
				InitImgDic (child);
				Image img = child.GetComponent<Image>();

				if(img != null && typeof(SImage) != img.GetType())
				{
					if (img.sprite != null) {
						Sprite sp = STManage.getInstance ().GetSprite (img.sprite.name);
						if (sp == null) {
							string rgbPath = GetRelativeAssetPath(Path.Combine (Application.dataPath+"/GameEffect/EffectResources/EffectTexture/ImgRGBA/", img.sprite.name + "_etc_rgb.png"));
							sp = UnityEditor.AssetDatabase.LoadAssetAtPath (rgbPath, typeof(Sprite)) as Sprite;
						}
						ChangeImgToSimg (child, img, sp);
					} else {
						ChangeImgToSimg (child, img, null);
					}


					Button btn = child.GetComponent<Button> ();
					if (btn != null) {
						SpriteState st = new SpriteState ();
						if (btn.spriteState.disabledSprite != null) {
							Sprite bsp = STManage.getInstance().GetSprite(btn.spriteState.disabledSprite.name);
							if (bsp != null) {
								st.disabledSprite = bsp;
								btn.spriteState = st;
							}
						}

						if (btn.spriteState.pressedSprite != null) {
							Sprite bsp = STManage.getInstance().GetSprite(btn.spriteState.pressedSprite.name);
							if (bsp != null) {
								st.pressedSprite = bsp;
								btn.spriteState = st;
							}
						}

						if (btn.spriteState.highlightedSprite != null) {
							Sprite bsp = STManage.getInstance().GetSprite(btn.spriteState.highlightedSprite.name);
							if (bsp != null) {
								st.highlightedSprite = bsp;
								btn.spriteState = st;
							}
						}
					}
				}

//				Animator ant = child.GetComponent<Animator> ();
//				if (ant != null && ant.runtimeAnimatorController != null) {
//					string assetpath = AssetDatabase.GetAssetPath (ant.runtimeAnimatorController).Replace ("TUI/", "UI/");
//					ant.runtimeAnimatorController = AssetDatabase.LoadAssetAtPath (assetpath, typeof(AnimatorController)) as AnimatorController;
//				}

				if (child.childCount > 0) {
					ChangeImage (child);
				}
			}
		}

		static void ChangeImgToSimg(Transform child, Image img, Sprite sp)
		{
			object[] rl = GetImgValue(img, imgDic);
			object[] cl = GetImgValue(img, imgDicCell);
			object[] il = GetImgValue(img, imgDicItem);
			object[] ril = GetImgValue(img, imgDicRItem);
			object[] ll = GetImgValue(img, imgLoopItem);
			Toggle tog = GetToggle(img);

			Image.Type ty = img.type;
			Color color = img.color;
			bool rayt = img.raycastTarget;
			Image.FillMethod fillMethod = img.fillMethod;
			int fillOrg = img.fillOrigin;
			float fillAmount = img.fillAmount;
			bool enable = img.enabled;
			Material mat = img.material;
//			Material mat = null;
//			if (img.material != null) {
//				string assetpath = AssetDatabase.GetAssetPath (img.material);
//				if (assetpath.Contains ("TUI/")) {
//					assetpath = assetpath.Replace ("TUI/", "UI/");
//				}
//				mat = AssetDatabase.LoadAssetAtPath (assetpath, typeof(Material)) as Material;
//			}

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

			ChangeImgDic (rl, simg, typeof(ReferGameObjects));
			ChangeImgDic (cl, simg, typeof(Cell));
			ChangeImgDic (ril, simg, typeof(ScrollRectItem));
			ChangeImgDic (ll, simg, typeof(LoopItem));

			if (il != null) {
				Item item = (Item)il [1];
				string key = (string)il [0];
				item.ObjDic [key] = simg;
			}
			if (tog != null) {
				tog.graphic = simg;
			}
		}

		static void SetAllABName()  
		{  
			Debug.Log("设置abName Start.");    
			string[] paths = Directory.GetFiles(GetBigTexturePath(), "*.png", SearchOption.AllDirectories);  
			foreach (string path in paths)  
			{  
				Texture2D obj = AssetDatabase.LoadAssetAtPath (GetRelativeAssetPath(path), typeof(Texture2D)) as Texture2D;
				Hugula.Editor.BuildScript.SetAssetBundleName (obj, true);

			}  
			//			var folders = Directory.GetDirectories(GetTexturePath());
			//			foreach (var folder in folders) {
			//				DirectoryInfo info = new DirectoryInfo (folder);
			//
			//				// 给文件夹加上ab name
			//				string ap = info.FullName.Substring (info.FullName.IndexOf ("Assets/"));
			//				AssetImporter ip = AssetImporter.GetAtPath (ap) as AssetImporter;
			//				if (ip.assetBundleName == "") {
			//					string objName = info.Name.ToLower () + "_folder";
			//					objName = Hugula.Editor.HugulaEditorSetting.instance.GetAssetBundleNameByReplaceIgnore (objName);
			//					string name = CUtils.GetRightFileName (objName);
			//					var suffix = Common.CHECK_ASSETBUNDLE_SUFFIX;
			//					ip.assetBundleName = name + suffix;
			//					ip.SaveAndReimport ();
			//				}
			//			}

			AssetDatabase.Refresh();   
			Debug.Log("设置anName Finish.");    
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