//提取fbx中的动画文件
using UnityEngine;  
using UnityEditor;  
using System.Collections;  
using System.IO;
using System.Collections.Generic;
using System;
using Hugula.Editor;  

namespace Seven.Tool
{
	public class ExtractFbxClipTool{  

		[MenuItem("Assets/Animation/提取FBX动画文件")]  
		static void GetFiltered()  
		{  
			string[] guids = null;
			List<string> paths = new List<string>();
			UnityEngine.Object[] SelectionAsset = Selection.GetFiltered(typeof(UnityEngine.Object),SelectionMode.Assets);  
			Debug.Log(SelectionAsset.Length);  
			foreach(UnityEngine.Object obj in SelectionAsset)  
			{  
				if (obj.GetType () == typeof(GameObject)) {
					string path = AssetDatabase.GetAssetPath (obj);
					CreateNewClip(path);
				} else {
					paths.Add(AssetDatabase.GetAssetPath (obj));
				}
			}  
			if (SelectionAsset.Length > 0) {
				if(paths.Count > 0)
					guids = AssetDatabase.FindAssets (string.Format ("t:{0}", typeof(AnimationClip).ToString().Replace("UnityEngine.", "")), paths.ToArray());
				else
					guids = new string[]{};
			}

			for(int i = 0; i < guids.Length; i++)
			{
				string assetPath = AssetDatabase.GUIDToAssetPath (guids [i]);
				CreateNewClip (assetPath);

			}

			AssetDatabase.Refresh();  
		}  

		static void CreateNewClip(string path)
		{
			AnimationClip clip = AssetDatabase.LoadAssetAtPath<AnimationClip> (path);
			if (clip != null && !IsIgnore (path)) {
				if (IsAnimationTy (path)) {
					ChangeAnimation (path);
				}
				AnimationClip newClip = new AnimationClip ();  
				EditorUtility.CopySerialized (clip, newClip);
				string name = Path.GetFileName (path);
				string animPath = path.Replace (name, clip.name + ".anim");
				if (IsNeedLoop (path)) {
					//设置idle文件为循环动画
					SerializedObject serializedClip = new SerializedObject(newClip);
					AnimationClipSettings clipSettings = new AnimationClipSettings(serializedClip.FindProperty("m_AnimationClipSettings"));
					clipSettings.loopTime = true;
					serializedClip.ApplyModifiedProperties();
				}

				AssetDatabase.CreateAsset (newClip, animPath);
//				AssetDatabase.DeleteAsset (path);
			}
		}

		// 提取动画文件
		public static void ExtractFbxClip(string root)
		{
			string[] paths = Directory.GetFiles (root, "*.FBX", SearchOption.AllDirectories);
			foreach (string path in paths) {
				CreateNewClip (GetAssetPath (path));
			}
		}

		static string GetAssetPath(string path)
		{ 
			int idx = path.IndexOf("Assets");  
			string assetRelativePath = path.Substring(idx);  
			return assetRelativePath; 
		}

		public static bool IsNeedLoop(string path)
		{
			string name = Path.GetFileName (path);
			return name.Contains ("idle") || name.Contains ("atkidle") || name.Contains ("ride_idle") || name.Contains ("ride_walk") || name.Contains ("sidle") || name.Contains ("walk") || name.Contains ("sit") || name.Contains ("collect");
		}

		public static bool IsIgnore(string path)
		{
			string name = Path.GetFileName (path);
			return name.Contains ("skin") || name.Contains ("Skin");
		}

		//判断是否需要把动画设置为animation模式
		public static bool IsAnimationTy(string path)
		{
			string name = Path.GetFileName (path);
			//不包括角色的xp动画
			bool isXP = name.Contains ("xp") && !name.Contains("111101") && !name.Contains("112101") && !name.Contains("114101");
			return name.Contains ("jump") || name.Contains ("show") || isXP;
		}

		// 把fbx转为animation模式
		static void ChangeAnimation(string path)
		{
			var modelImporter = AssetImporter.GetAtPath(path) as ModelImporter;
			if (modelImporter == null)
				return;
			modelImporter.defaultClipAnimations[0].loopTime = true;
			if (modelImporter.importAnimation && modelImporter.animationType != ModelImporterAnimationType.Legacy)
			{
				modelImporter.animationType = ModelImporterAnimationType.Legacy;
				modelImporter.SaveAndReimport();
			}
//			GameObject obj = UnityEditor.AssetDatabase.LoadAssetAtPath (path, typeof(GameObject)) as GameObject;
//			BuildScript.SetAssetBundleName (obj, true);
		}

		class AnimationClipSettings
		{
			SerializedProperty m_Property;

			private SerializedProperty Get (string property) { return m_Property.FindPropertyRelative(property); }

			public AnimationClipSettings(SerializedProperty prop) { m_Property = prop; }

			public float startTime   { get { return Get("m_StartTime").floatValue; } set { Get("m_StartTime").floatValue = value; } }
			public float stopTime	{ get { return Get("m_StopTime").floatValue; }  set { Get("m_StopTime").floatValue = value; } }
			public float orientationOffsetY { get { return Get("m_OrientationOffsetY").floatValue; } set { Get("m_OrientationOffsetY").floatValue = value; } }
			public float level { get { return Get("m_Level").floatValue; } set { Get("m_Level").floatValue = value; } }
			public float cycleOffset { get { return Get("m_CycleOffset").floatValue; } set { Get("m_CycleOffset").floatValue = value; } }

			public bool loopTime { get { return Get("m_LoopTime").boolValue; } set { Get("m_LoopTime").boolValue = value; } }
			public bool loopBlend { get { return Get("m_LoopBlend").boolValue; } set { Get("m_LoopBlend").boolValue = value; } }
			public bool loopBlendOrientation { get { return Get("m_LoopBlendOrientation").boolValue; } set { Get("m_LoopBlendOrientation").boolValue = value; } }
			public bool loopBlendPositionY { get { return Get("m_LoopBlendPositionY").boolValue; } set { Get("m_LoopBlendPositionY").boolValue = value; } }
			public bool loopBlendPositionXZ { get { return Get("m_LoopBlendPositionXZ").boolValue; } set { Get("m_LoopBlendPositionXZ").boolValue = value; } }
			public bool keepOriginalOrientation { get { return Get("m_KeepOriginalOrientation").boolValue; } set { Get("m_KeepOriginalOrientation").boolValue = value; } }
			public bool keepOriginalPositionY { get { return Get("m_KeepOriginalPositionY").boolValue; } set { Get("m_KeepOriginalPositionY").boolValue = value; } }
			public bool keepOriginalPositionXZ { get { return Get("m_KeepOriginalPositionXZ").boolValue; } set { Get("m_KeepOriginalPositionXZ").boolValue = value; } }
			public bool heightFromFeet { get { return Get("m_HeightFromFeet").boolValue; } set { Get("m_HeightFromFeet").boolValue = value; } }
			public bool mirror { get { return Get("m_Mirror").boolValue; } set { Get("m_Mirror").boolValue = value; } }
		}
	} 
}