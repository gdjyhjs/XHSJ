using System.Linq;
using UnityEngine;
using UnityEditor;
using UnityEditor.Animations;
using System.IO;
using Hugula.Editor;
using Hugula.Utils;
using System.Collections.Generic;
using Seven.Tool;

public static class AnimatorFactoryUtil
{
	public static AnimationClip LoadAnimClip(string path)
	{
		return (AnimationClip)AssetDatabase.LoadAssetAtPath(path, typeof(AnimationClip));
	}

	public static AnimationClip LoadAnimClip(string fbxPath, string animPath)
	{
		var objs = AssetDatabase.LoadAllAssetsAtPath(fbxPath);
		return objs.Where(o => o is AnimationClip && o.name.Equals(animPath)).Select(o => o as AnimationClip).FirstOrDefault();
	}
}

public class AnimatorFactory : EditorWindow
{
	#region const
	private string rootFolder = "Assets/Model/";
	#endregion const

	#region private members
	private string characterName;
	private AnimatorController productController;
	private AnimatorStateMachine baseLayerMachine;
	private AnimatorStateMachine crouchLayerMachine;

	// base layer states
	private AnimatorState idle;
	private AnimatorState walk;
	private AnimatorState atkIdle;

	// attack layer states
	private AnimatorState empty;
	private AnimatorState atk;
	private AnimatorState atk1;
	private AnimatorState atk2;
	private AnimatorState atk3;
	private AnimatorState skill1;
	private AnimatorState skill2;
	private AnimatorState skill3;
	private AnimatorState skill4;
	private AnimatorState skill5;
	private AnimatorState xp;
	private AnimatorState hit;
	private AnimatorState dead;
	private AnimatorState psit;
	private AnimatorState sit;
	private AnimatorState fsit;
	private AnimatorState ride_idle;
	private AnimatorState ride_walk;
	private AnimatorState collect;
	private AnimatorState sidle;
	private AnimatorState forward;
	private AnimatorState show;
	private AnimatorState change;

	private Shader shader;

	private float dtime = 0.05f;
	static int winType = 0;

	#endregion private members

	#region EditorWindow
	[MenuItem("Tools/动画生产器")]
	public static void OpenWindow()
	{
		winType = 1;
		EditorWindow.GetWindow(typeof(AnimatorFactory));
	}

	[MenuItem("Tools/修改模型动画压缩模式")]
	public static void OpenCompress()
	{
		winType = 2;
		EditorWindow.GetWindow(typeof(AnimatorFactory));
	}

	void OnEnable()
	{
		// set default name
		characterName = "";
	}

	void OnGUI()
	{
		if (winType == 1) {
			GUILayout.Label("设置", EditorStyles.boldLabel);
			characterName = EditorGUILayout.TextField("文件夹名字(默认导出所有)", characterName);

			if (GUILayout.Button ("生成动画"))
				CreateAnimationAssets ();

		} else if (winType == 2) {
			if (GUILayout.Button ("修改模型动画压缩模式"))
				ModifyCompress ();
		}
	}
	#endregion EditorWindow

	public void ModifyCompress()
	{
		var assets = AssetDatabase.FindAssets("t:GameObject");

		AssetDatabase.StartAssetEditing();

		foreach (var guid in assets)
		{
			var assetPath = AssetDatabase.GUIDToAssetPath(guid);
			var modelImporter = AssetImporter.GetAtPath(assetPath) as ModelImporter;
			if (modelImporter == null)
				continue;

			if (modelImporter.importAnimation && modelImporter.animationCompression != ModelImporterAnimationCompression.Optimal)
			{
				modelImporter.animationCompression = ModelImporterAnimationCompression.Optimal;
//				modelImporter.animationType = ModelImporterAnimationType.Legacy;
				modelImporter.meshCompression = ModelImporterMeshCompression.Medium;
				modelImporter.SaveAndReimport();
			}
		}

		AssetDatabase.StopAssetEditing();

		AssetDatabase.Refresh();
	}

	public void CreateAnimationAssets()
	{
		if (!Directory.Exists(rootFolder))
		{
			Directory.CreateDirectory(rootFolder);
			return;
		}

		if (characterName != "") 
		{
			CreateAnimator (characterName, rootFolder+characterName);
		} else 
		{
			// 遍历目录，查找生成controller文件
			var folders = Directory.GetDirectories(rootFolder);
			foreach (var folder in folders)
			{
				DirectoryInfo info = new DirectoryInfo(folder);
				string folderName = info.Name;
				CreateAnimator (folderName, folder);
			}
		}

		AssetDatabase.SaveAssets ();
		AssetDatabase.Refresh ();

		Debug.Log ("生产动画文件成功！");
	}

	public void CreateAnimator(string folderName, string folder)
	{
		if (!Directory.Exists (folder)) {
			Debug.LogError ("不存在文件夹：" + folder);
			return;
		}

		string[] paths = Directory.GetFiles (folder, "*.FBX", SearchOption.AllDirectories);
		if (paths.Length == 0) {//没有fbx
			return;
		}

		ExtractFbxClipTool.ExtractFbxClip (folder);

		string ctrPath = string.Format ("{0}/{1}.controller", folder, folderName);
		CreateCtr (ctrPath);

		//如果没有idle，那说明是套装，用第一套的动作
		bool isSuit = false;
		string tempFolderName = folderName;

		bool isWeapon = false;
		if (paths.Length == 1) {
			var obj = AssetDatabase.LoadAssetAtPath(paths [0], typeof(GameObject)) as GameObject;
			isWeapon = obj.transform.childCount == 0;

			if(!File.Exists(string.Format("{0}/idle.anim", folder)) && !isWeapon)
			{
				int len = folder.Length;
				folder = folder.Remove(len-3,3) + "101";
				len = folderName.Length;
				folderName = folderName.Remove(len-3,3) + "101";
				if (!Directory.Exists (folder)) {
					folder = folder.Replace (folderName, tempFolderName);
					folderName = tempFolderName;
					isSuit = false;
				} else {
					isSuit = true;
				}
			}

			if (paths [0].Contains ("@skin") && !isWeapon && !isSuit) {//如果只有皮肤，不是武器，返回
				return;
			}
		}

		// 得到其layer
		var baseLayer = productController.layers[0];
		var attackLayer = productController.layers[1];

		// 绑定动画文件
		CreateEmpty(baseLayer);
		if (File.Exists (string.Format ("{0}/atkidle.anim", folder))) {
			CreateAtkIdle (string.Format("{0}/atkidle.anim", folder), baseLayer);
			CreatePlayerWalk (string.Format ("{0}/walk.anim", folder), baseLayer);
			CreateRideIdle (string.Format("{0}/ride_idle.anim", folder), baseLayer);
			CreateRideWalk (string.Format ("{0}/ride_walk.anim", folder), baseLayer);
			CreateUIIdle (string.Format ("{0}/idle.anim", folder), baseLayer);
		} else {
			CreateIdle (string.Format("{0}/idle.anim", folder), baseLayer);
			CreateWalk (string.Format ("{0}/walk.anim", folder), baseLayer);
		}
		CreateSidle (string.Format ("{0}/sidle.anim", folder), baseLayer);
//		CreateShow (string.Format ("{0}/Show.anim", folder), baseLayer);
		CreateChange (string.Format ("{0}/change.anim", folder), baseLayer);

		CreateEmpty (attackLayer);
		CreateATK (string.Format ("{0}/atk.anim", folder), attackLayer);
		CreateATK1 (string.Format ("{0}/atk1.anim", folder), attackLayer);
		CreateATK2 (string.Format ("{0}/atk2.anim", folder), attackLayer);
		CreateATK3 (string.Format ("{0}/atk3.anim", folder), attackLayer);
		CreateSkill1 (string.Format ("{0}/skill1.anim", folder), attackLayer);
		CreateSkill2 (string.Format ("{0}/skill2.anim", folder), attackLayer);
		CreateSkill3 (string.Format ("{0}/skill3.anim", folder), attackLayer);
		CreateSkill4 (string.Format ("{0}/skill4.anim", folder), attackLayer);
		CreateSkill5 (string.Format ("{0}/skill5.anim", folder), attackLayer);
		CreateHit (string.Format ("{0}/hit.anim", folder), attackLayer);
		CreateDead (string.Format ("{0}/dead.anim", folder), attackLayer);
		CreatePSit (string.Format ("{0}/psit.anim", folder), attackLayer);
		CreateSit (string.Format ("{0}/sit.anim", folder), attackLayer);
		CreateFSit (string.Format ("{0}/fsit.anim", folder), attackLayer);
		CreateCollect(string.Format ("{0}/collect.anim", folder), attackLayer);
		CreateForward(string.Format ("{0}/forward.anim", folder), attackLayer);
		CreateXP(string.Format ("{0}/xp.anim", folder), attackLayer);

		// 创建预设
		CreatePrefab(tempFolderName);

		//转镜动作处理
		List<string> pathList = new List<string> ();
		if (!folderName.Equals ("111101") && !folderName.Equals ("112101") && !folderName.Equals ("114101") && !isSuit) {
			pathList.Add (string.Format ("{0}/xp.anim", folder));
		}
		if (!isSuit) {
			pathList.Add (string.Format ("{0}/jump.anim", folder));
			pathList.Add (string.Format ("{0}/show.anim", folder));
		}
		foreach (string path in pathList) {
			if (File.Exists (path)) {
				CreateAnimationPrefab (path);
			}
		}

		DeleteFBX (folder);

		if (File.Exists (ctrPath)) {
			EditorUtility.SetDirty (productController);
		}

	}

	public void CreateCtr(string path)
	{
		// 创建animationController文件
		productController = AnimatorController.CreateAnimatorControllerAtPath(path);
		productController.AddLayer ("Attack Layer");

		AnimatorControllerLayer[] layers = productController.layers;
		// set layer parameters
		layers[1].defaultWeight = 1f;
		layers[1].blendingMode = AnimatorLayerBlendingMode.Override;
		// save layer setting to controller
		productController.layers = layers;

		AddParameters ();
	}

	public void CreateAnimationPrefab(string animPath)
	{
		AnimationClip clip = AssetDatabase.LoadAssetAtPath<AnimationClip> (animPath);
		if (clip == null) {
			Debug.LogError ("找不到动作文件：" + animPath);
			return;
		}

		string fileName = Path.GetFileNameWithoutExtension (animPath);
		string folderPath = GetAssetPath(animPath.Replace ("/"+Path.GetFileName(animPath), ""));//文件夹路径

		string[] list = folderPath.Split ('/');
		string folderName = list [list.Length - 1];//文件夹名字

		string prefabPath = CUtils.PathCombine (folderPath, folderName + "@" + fileName + ".prefab");
		string fbxPath = CUtils.PathCombine(folderPath, folderName+"@skin.fbx");
		string orgFbxPath = CUtils.PathCombine(folderPath, folderName+"@"+fileName+".fbx");//原始文件信息
		if (!File.Exists (orgFbxPath)) {
			Debug.LogWarning ("找不到：" + fbxPath + "，无法重新生产prefab!");
			return;
		}
		var prefab = AssetDatabase.LoadAssetAtPath(orgFbxPath, typeof(GameObject)) as GameObject;
		if (prefab == null) {
			Debug.LogError ("动画生成Prefab出错：" + orgFbxPath+", "+animPath);
			return;
		}
		GameObject go = Instantiate(prefab);
		GameObject skinObj = AssetDatabase.LoadAssetAtPath(fbxPath, typeof(GameObject)) as GameObject;

		//更换皮肤网格
		Object[] skinList = go.transform.GetComponentsInChildren<SkinnedMeshRenderer> ();
		foreach (SkinnedMeshRenderer skin in skinList) {
			if (skin.gameObject.name == folderName) {//身体
				
				skin.sharedMesh = skinObj.transform.GetComponentInChildren<SkinnedMeshRenderer> ().sharedMesh;
			} else {//武器
				string weaponPath = rootFolder+skin.gameObject.name+"/"+skin.gameObject.name+"@skin.fbx";
				if (File.Exists (weaponPath)) {
					GameObject weapon = AssetDatabase.LoadAssetAtPath (weaponPath, typeof(GameObject)) as GameObject;
					MeshFilter mf = weapon.transform.GetComponent<MeshFilter> ();
					if (mf != null) {
						skin.sharedMesh = mf.sharedMesh;
					} else {
						Debug.LogError ("找不到武器MeshFilter:" + weaponPath + ", animPath:" + animPath);
					}
				} else {
					Debug.LogError ("找不到武器:" + weaponPath + ", animPath:" + animPath);
				}

				//更换材质球
				string matPath = rootFolder+skin.gameObject.name+"/Materials/"+skin.gameObject.name+".mat";
				skin.material = AssetDatabase.LoadAssetAtPath (matPath, typeof(Material)) as Material;

				//删除武器材质球和图片
				AssetDatabase.DeleteAsset(CUtils.PathCombine(folderPath,"Materials/"+skin.gameObject.name+".mat"));
				AssetDatabase.DeleteAsset(CUtils.PathCombine(folderPath,skin.gameObject.name+".png"));
			}
		}

		DestroyImmediate (go.GetComponent<Animator> ());
		Animation animtion = go.GetComponent<Animation>();
		if (animtion == null) {
			animtion = go.AddComponent<Animation> ();
		}
		animtion.AddClip (clip, clip.name);
		animtion.clip = clip;
		animtion.cullingType = AnimationCullingType.AlwaysAnimate;

		GameObject obj = PrefabUtility.CreatePrefab(prefabPath, go);
		BuildScript.SetAssetBundleName (obj, true);

		DestroyImmediate(go);
	}

	/// <summary>
	/// 生成带动画控制器的对象
	/// </summary>
	/// <param name="name"></param>
	/// <returns></returns>
	public void CreatePrefab(string name)
	{
		string path = string.Format (rootFolder + "{0}/{0}@xp.fbx", name);//有xp的用xp生产预设体（主要是要镜头节点），没有用skin
		bool isChangMesh = true;
		if (!File.Exists (path) || ExtractFbxClipTool.IsAnimationTy(path)) {
			path = path.Replace ("xp", "skin");
			isChangMesh = false;
		}
		var prefab = AssetDatabase.LoadAssetAtPath(path, typeof(GameObject)) as GameObject;
		if (prefab == null) {
			Debug.LogError ("CreatePrefab动画生成Prefab出错：" + path+", name"+name);
			return;
		}
		var go = Instantiate(prefab);
		if (isChangMesh) {
			string skinPath = path.Replace ("xp", "skin");
			var skinObj = AssetDatabase.LoadAssetAtPath(skinPath, typeof(GameObject)) as GameObject;
			SkinnedMeshRenderer skin = go.transform.GetComponentInChildren<SkinnedMeshRenderer> ();
			if (skin != null) {
				var mesh = skinObj.transform.GetComponentInChildren<SkinnedMeshRenderer> ();
				if (mesh != null) {
					skin.sharedMesh = skinObj.transform.GetComponentInChildren<SkinnedMeshRenderer> ().sharedMesh;
				} else {
					Debug.LogWarning ("找不到xp动作的 SkinnedMeshRenderer：" + skinPath);
				}
			} else {
				Debug.LogError ("找不到skin SkinnedMeshRenderer：" + path);
			}
		}

		bool isMonster = false;
		if (walk == null) {
			shader = Shader.Find ("Unlit/Texture");//npc
		} else if (atk == null) {
			shader = Shader.Find ("Unlit/Texture");//character
		} else if (atk1 == null) {
			shader = Shader.Find ("Seven/Dissolve");//monster
			isMonster = true;
		}
		Renderer[] renders = null;

		var head = LuaHelper.FindChild (go.transform, "head");
		if (head != null) {
			var hp = new GameObject ("HP");
			hp.transform.parent = go.transform;
			if (head) {
				hp.transform.position = head.transform.position + new Vector3 (0, 0.5f, 0);
			} else {
				hp.transform.localPosition = new Vector3 (0, 4f, 0);
			}

			var animator = go.GetComponent<Animator> ();
			animator.runtimeAnimatorController = productController;

			UnityEngine.AI.NavMeshAgent agent = go.AddComponent<UnityEngine.AI.NavMeshAgent> ();
			agent.enabled = false;
			agent.acceleration = 100f;
			agent.angularSpeed = 1000f;
			agent.radius = 1f;
			agent.height = 3.5f;

			CharacterController charCtr = go.AddComponent<CharacterController> ();
			charCtr.radius = 1f;
			charCtr.height = 3.5f;
			charCtr.center = new Vector3 (0, 1.75f, 0);

			renders = go.GetComponentsInChildren<Renderer> ();

		} else {
			renders = go.GetComponents<Renderer> ();
			if (renders.Length == 0) {
				renders = go.GetComponentsInChildren<Renderer> ();
				var animator = go.GetComponent<Animator> ();
				animator.runtimeAnimatorController = productController;
			} else {
				//武器
				DestroyImmediate (go.transform.GetComponent<Animator> ());
				DestroyImmediate (go.transform.GetComponent<Animation> ());
				AssetDatabase.DeleteAsset (string.Format (rootFolder + "{0}/{0}.controller", name));
			}
		}

		foreach (Renderer render in renders) 
		{
			if (render.sharedMaterial == null || shader == null) {
				Debug.LogError ("sharedMaterial or shader is null! name ="+name);
				continue;
			}

			render.sharedMaterial.shader = shader;

			if (isMonster) {
				render.sharedMaterial.SetTexture ("_NoiseTex", (Texture2D)UnityEditor.AssetDatabase.LoadAssetAtPath ("Assets/Model/dissolve.png", typeof(Texture2D)));
			}
		}

		GameObject obj = PrefabUtility.CreatePrefab(string.Format(rootFolder+"{0}/{0}.prefab", name), go);
		BuildScript.SetAssetBundleName (obj, true);

		DestroyImmediate(go);
	}

	//删除fbx
	static void DeleteFBX(string folderPath)
	{
		string[] paths = Directory.GetFiles (folderPath, "*.FBX", SearchOption.AllDirectories);
		foreach (string path in paths) {
			if (!ExtractFbxClipTool.IsIgnore (path)) {
				AssetDatabase.DeleteAsset (GetAssetPath (path));
			}
		}
	}

	/// <summary>
	/// 添加动画状态机状态
	/// </summary>
	/// <param name="path"></param>
	/// <param name="layer"></param>
	public AnimatorState AddState(string path, AnimatorControllerLayer layer, string name)
	{
		AnimatorStateMachine sm = layer.stateMachine;
		AnimationClip newClip = AnimatorFactoryUtil.LoadAnimClip(path);

		if (newClip == null)
			return null;

		// 取出动画名字，添加到state里面
		newClip.name = name;

		//有些动画我希望天生它就动画循环
		if(name == "idle" || name == "walk")
		{
			newClip.wrapMode = WrapMode.Loop;
			AnimationClipSettings clipSetting = AnimationUtility.GetAnimationClipSettings(newClip);  
			clipSetting.loopTime = true;

			AnimationUtility.SetAnimationClipSettings(newClip, clipSetting);
		}

		AnimatorState state = sm.AddState(newClip.name);
		state.motion = newClip;
		return state;
	}

	private void AddParameters()
	{
		// use AddParameter interface
		productController.AddParameter("atk", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("atk2", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("atk3", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("skill1", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("skill2", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("skill3", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("skill4", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("skill5", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("dead", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("hit", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("cancel", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("sidle", AnimatorControllerParameterType.Trigger);
		productController.AddParameter("move", AnimatorControllerParameterType.Bool);
		productController.AddParameter("sit", AnimatorControllerParameterType.Bool);
		productController.AddParameter("idle", AnimatorControllerParameterType.Bool);
		productController.AddParameter("ride_idle", AnimatorControllerParameterType.Bool);
		productController.AddParameter("collect", AnimatorControllerParameterType.Bool);
		productController.AddParameter("ui_idle", AnimatorControllerParameterType.Bool);

//		productController.parameters [11].defaultBool = true;
//		Debug.Log ("name = " + productController.parameters [11].name);
	}

	public void CreateIdle(string path, AnimatorControllerLayer layer)
	{
		if (empty == null)
			return;
		
		idle = AddState(path, layer, "idle");
		if (idle == null)
			return;
		
		var trans = empty.AddTransition(idle);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "idle");

		trans = idle.AddTransition(empty);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition(AnimatorConditionMode.IfNot, 0, "idle");
	}

	public void CreateWalk(string path, AnimatorControllerLayer layer)
	{
		walk = AddState (path, layer, "walk");
		if (walk == null)
		{
			return;
		}

		if (idle == null)
			return;

		var trans = idle.AddTransition(walk);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "move");

		trans = walk.AddTransition(idle);
		trans.hasExitTime = false;
		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
		trans.duration = 0.2f;
		trans.AddCondition(AnimatorConditionMode.IfNot, 0, "move");
	}

	public void CreateSidle(string path, AnimatorControllerLayer layer)
	{
		sidle = AddState (path, layer, "sidle");

		if (sidle == null)
			return;

		AnimatorStateMachine sm = layer.stateMachine;
		var trans = sm.AddAnyStateTransition (sidle);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "sidle");

		trans = sidle.AddTransition(walk);
		trans.hasExitTime = false;
		trans.exitTime = 1f;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");

		if (atkIdle == null)
			return;
		
		trans = sidle.AddTransition(atkIdle);
		trans.hasExitTime = true;
		trans.exitTime = 0.8f;
		trans.duration = 0.2f;
	}

	public void CreateAtkIdle(string path,  AnimatorControllerLayer layer)
	{
		if (empty == null)
			return;

		atkIdle = AddState(path, layer, "atkidle");
		if (atkIdle == null)
			return;

		var trans = empty.AddTransition(atkIdle);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "idle");

		trans = atkIdle.AddTransition(empty);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition(AnimatorConditionMode.IfNot, 0, "idle");
	}

	public void CreatePlayerWalk(string path, AnimatorControllerLayer layer)
	{
		walk = AddState (path, layer, "walk");
		if (walk == null)
		{
			return;
		}

		if (atkIdle == null)
			return;

		var trans = atkIdle.AddTransition(walk);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "move");

		trans = walk.AddTransition(atkIdle);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition(AnimatorConditionMode.IfNot, 0, "move");
	}



	public void CreateRideIdle(string path, AnimatorControllerLayer layer)
	{
		if (empty == null)
			return;

		ride_idle = AddState(path, layer, "ride_idle");
		if (ride_idle == null || atkIdle == null)
		{
			return;
		}

		var trans = atkIdle.AddTransition(ride_idle);
		trans.hasExitTime = false;
		trans.exitTime = 1f;
		trans.duration = 0f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "ride_idle");

		trans = ride_idle.AddTransition(atkIdle);
		trans.hasExitTime = false;
		trans.exitTime = 1f;
		trans.duration = 0f;
		trans.AddCondition(AnimatorConditionMode.IfNot, 0, "ride_idle");
	}

	public void CreateRideWalk(string path, AnimatorControllerLayer layer)
	{
		ride_walk = AddState (path, layer, "ride_walk");
		if (ride_walk == null)
		{
			return;
		}

		if (ride_idle == null)
			return;

		var trans = ride_idle.AddTransition(ride_walk);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "move");

		trans = ride_walk.AddTransition(ride_idle);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition(AnimatorConditionMode.IfNot, 0, "move");
	}

	public void CreateUIIdle(string path, AnimatorControllerLayer layer)
	{
		if (empty == null)
			return;

		idle = AddState(path, layer, "idle");
		if (idle == null)
			return;

		var trans = empty.AddTransition(idle);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "ui_idle");

		trans = idle.AddTransition(empty);
		trans.hasExitTime = false;
		trans.duration = 0.2f;
		trans.AddCondition(AnimatorConditionMode.IfNot, 0, "ui_idle");
	}

	public void CreateEmpty(AnimatorControllerLayer layer)
	{
		AnimatorStateMachine sm = layer.stateMachine;
		empty = sm.AddState("EmptyState");
	}

	public void CreateATK(string path, AnimatorControllerLayer layer)
	{
		atk = AddState (path, layer, "atk");

		if (atk == null) 
		{
			return;
		}

		var trans = empty.AddTransition(atk);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "atk");

		trans = atk.AddTransition(empty);
		trans.hasExitTime = true;

		trans = atk.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
//		trans.duration = 0.2f;
	}

	public void CreateATK1(string path, AnimatorControllerLayer layer)
	{
		atk1 = AddState (path, layer, "atk1");

		if (atk1 == null) 
		{
			return;
		}
		
		var trans = empty.AddTransition(atk1);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = dtime;
		trans.AddCondition (AnimatorConditionMode.If, 0, "atk");

		trans = atk1.AddTransition(empty);
		trans.hasExitTime = true;

		trans = atk1.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");

		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
//		trans.duration = 0.2f;
	}

	public void CreateATK2(string path, AnimatorControllerLayer layer)
	{
		atk2 = AddState (path, layer, "atk2");
		if (atk2 == null)
			return;
		
		var trans = atk1.AddTransition(atk2);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = dtime;
		trans.AddCondition (AnimatorConditionMode.If, 0, "atk");

		trans = atk2.AddTransition(empty);
		trans.hasExitTime = true;

		trans = atk2.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");

		trans = empty.AddTransition(atk2);
		trans.hasExitTime = false;
		trans.duration = dtime;
		trans.AddCondition (AnimatorConditionMode.If, 0, "atk2");
	}

	public void CreateATK3(string path, AnimatorControllerLayer layer)
	{
		atk3 = AddState (path, layer, "atk3");

		if (atk3 == null)
			return;
		
		var trans = atk2.AddTransition(atk3);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = dtime;
		trans.AddCondition (AnimatorConditionMode.If, 0, "atk");

		trans = atk3.AddTransition(empty);
		trans.hasExitTime = true;

		trans = atk3.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");

		trans = empty.AddTransition(atk3);
		trans.hasExitTime = false;
		trans.duration = dtime;
		trans.AddCondition (AnimatorConditionMode.If, 0, "atk3");
	}

	public void CreateSkill1(string path, AnimatorControllerLayer layer)
	{
		skill1 = AddState (path, layer, "skill1");

		if (skill1 == null)
			return;

		var trans = empty.AddTransition(skill1);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "skill1");

		trans = skill1.AddTransition(empty);
		trans.hasExitTime = true;

		trans = skill1.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");;
		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
		//		trans.duration = 0.2f;
	}

	public void CreateSkill2(string path, AnimatorControllerLayer layer)
	{
		skill2 = AddState (path, layer, "skill2");

		if (skill2 == null)
			return;

		var trans = empty.AddTransition(skill2);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "skill2");

		trans = skill2.AddTransition(empty);
		trans.hasExitTime = true;

		trans = skill2.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
		//		trans.duration = 0.2f;
	}

	public void CreateSkill3(string path, AnimatorControllerLayer layer)
	{
		skill3 = AddState (path, layer, "skill3");

		if (skill3 == null)
			return;

		var trans = empty.AddTransition(skill3);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "skill3");

		trans = skill3.AddTransition(empty);
		trans.hasExitTime = true;

		trans = skill3.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
		//		trans.duration = 0.2f;
	}

	public void CreateSkill4(string path, AnimatorControllerLayer layer)
	{
		skill4 = AddState (path, layer, "skill4");

		if (skill4 == null)
			return;

		var trans = empty.AddTransition(skill4);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "skill4");

		trans = skill4.AddTransition(empty);
		trans.hasExitTime = true;

		trans = skill4.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
		//		trans.duration = 0.2f;
	}

	public void CreateSkill5(string path, AnimatorControllerLayer layer)
	{
		skill5 = AddState (path, layer, "skill5");

		if (skill5 == null)
			return;

		var trans = empty.AddTransition(skill5);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "skill5");

		trans = skill5.AddTransition(empty);
		trans.hasExitTime = true;

		trans = skill5.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
		//		trans.duration = 0.2f;
	}
		
	public void CreateXP(string path, AnimatorControllerLayer layer)
	{
		xp = AddState (path, layer, "xp");

		if (xp == null)
			return;

		var trans = empty.AddTransition(xp);
		trans.hasExitTime = false;
		trans.exitTime = 1f;

		trans = xp.AddTransition(empty);
		trans.hasExitTime = true;
		trans.exitTime = 1f;
	}

	public void CreateHit(string path, AnimatorControllerLayer layer)
	{
		hit = AddState (path, layer, "hit");

		if (hit == null)
			return;

		var trans = empty.AddTransition(hit);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "hit");

		trans = hit.AddTransition(empty);
		trans.hasExitTime = true;

		trans = hit.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");

		//		trans.interruptionSource = TransitionInterruptionSource.Destination;
		//		trans.duration = 0.2f;
	}

	public void CreateDead(string path, AnimatorControllerLayer layer)
	{
		dead = AddState (path, layer, "dead");

		if (dead == null)
			return;
		
		AnimatorStateMachine sm = layer.stateMachine;
		var trans = sm.AddAnyStateTransition (dead);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "dead");

		trans = dead.AddTransition(empty);
		trans.exitTime = 0.9f;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
	}

	public void CreatePSit(string path, AnimatorControllerLayer layer)
	{
		psit = AddState (path, layer, "psit");

		if (psit == null)
			return;

		var trans = empty.AddTransition(psit);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "sit");
	}

	public void CreateSit(string path, AnimatorControllerLayer layer)
	{
		sit = AddState (path, layer, "sit");

		if (sit == null || psit == null)
			return;

		var trans = psit.AddTransition(sit);
		trans.hasExitTime = true;
	}

	public void CreateFSit(string path, AnimatorControllerLayer layer)
	{
		fsit = AddState (path, layer, "fsit");

		if (fsit == null || sit == null)
			return;

		var trans = sit.AddTransition(fsit);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.IfNot, 0, "sit");

		trans = fsit.AddTransition(empty);
		trans.hasExitTime = true;

		trans = fsit.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
	}

	public void CreateCollect(string path, AnimatorControllerLayer layer)
	{
		collect = AddState (path, layer, "collect");

		if (collect == null)
			return;

		var trans = empty.AddTransition(collect);
		trans.hasExitTime = false;
		trans.exitTime = 0.9f;
		//		trans.interruptionSource = TransitionInterruptionSource.Source;
		trans.duration = 0.2f;
		trans.AddCondition (AnimatorConditionMode.If, 0, "collect");

		trans = collect.AddTransition(empty);
		trans.hasExitTime = false;
		trans.AddCondition (AnimatorConditionMode.IfNot, 0, "collect");

//		trans = collect.AddTransition(empty);
//		trans.hasExitTime = false;
//		trans.AddCondition (AnimatorConditionMode.If, 0, "cancel");
	}

	public void CreateForward(string path, AnimatorControllerLayer layer)
	{
		forward = AddState (path, layer, "forward");

		if (forward == null)
			return;

		var trans = empty.AddTransition(forward);

	}

	public void CreateShow(string path, AnimatorControllerLayer layer)
	{
		show = AddState (path, layer, "show");

		if (show == null)
			return;

		var trans = empty.AddTransition(show);

	}

	public void CreateChange(string path, AnimatorControllerLayer layer)
	{
		change = AddState (path, layer, "change");

		if (change == null)
			return;

		var trans = empty.AddTransition(change);
		trans = change.AddTransition (empty);
		trans.hasExitTime = true;
		trans.exitTime = 0.9f;
		trans.duration = 0.43f;
	}

	static string GetAssetPath(string path)
	{ 
		int idx = path.IndexOf("Assets");  
		string assetRelativePath = path.Substring(idx);  
		return assetRelativePath; 
	}
}

