using UnityEngine;
using UnityEditor;
using System.IO;
using System.Text;
using System.Linq;
using System.Collections;
using System.Collections.Generic;
using System;
using Seven;

namespace Seven.ToolEditor
{
	public class SceneTools
	{
		static string[] _sNeedAssetType = new string[1]{
			".unity",
		};

		[MenuItem("Tools/保存场景光照贴图信息", false, 111)]
		public static void SaveSceneMapLightSetting()
		{
			UnityEngine.Object[] selObjs = Selection.GetFiltered (typeof(UnityEngine.Object), SelectionMode.DeepAssets);
			if (selObjs == null || selObjs.Length == 0) {
				Debug.LogError ("请到\"Scenes\" 目录下选中需要保存场景光照贴图信息的场景!");
				return;
			}

			string assetPath;
			UnityEngine.Object assetObj = null;
			GameObject gameObj = null;
			SceneLightMapSetting slms = null;
			RendererLightMapSetting rlms = null;
			bool needSave = false;
			for (int i = 0; i < selObjs.Length; ++i) {
				needSave = false;
				assetPath = AssetDatabase.GetAssetPath (selObjs [i]);
				foreach (string extName in _sNeedAssetType) {
					if (assetPath.EndsWith (extName)) {
						needSave = true;
						break;
					}
				}
				if (!needSave)
					continue;

				assetObj = AssetDatabase.LoadAssetAtPath (assetPath, typeof(UnityEngine.Object)) as UnityEngine.Object;
				EditorApplication.OpenScene (assetPath);

				gameObj = GameObject.Find ("scene_root");
				if (gameObj == null) {
					Debug.LogError ("不合法的场景：场景没有scene_root根节点！！");
					continue;
				}

				slms = gameObj.GetComponent<SceneLightMapSetting>();
				if(slms == null){
					slms = gameObj.AddComponent<SceneLightMapSetting>();
				}

				Renderer[] savers = Transform.FindObjectsOfType<Renderer>();
				int index = 0;

				slms.lightmapIndex = new int[savers.Length];
				slms.lightmapScaleOffset = new Vector4[savers.Length];

				foreach(Renderer s in savers)
				{
					if(s.lightmapIndex != -1){
//						rlms = s.gameObject.GetComponent<RendererLightMapSetting>();
//						if(rlms == null){
//							rlms = s.gameObject.AddComponent<RendererLightMapSetting>();
//						}
//						slms.renderName[index] = s.name;
						slms.renderName.Add (s.name);
						slms.lightmapIndex [index] = s.lightmapIndex;
						slms.lightmapScaleOffset [index] = s.lightmapScaleOffset;
						index++;
					}
				}

				slms.SaveSettings();

				EditorApplication.SaveScene();

				Debug.Log(string.Format("场景{0}的光照贴图信息保存完成", assetObj.name));
			}
			AssetDatabase.SaveAssets();
		}
	}
}