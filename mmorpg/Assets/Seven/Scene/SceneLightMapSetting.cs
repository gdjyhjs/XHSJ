using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.Rendering;

namespace Seven
{
	[ExecuteInEditMode]
	public class SceneLightMapSetting : MonoBehaviour {
		public Texture2D []lightmapFar, lightmapNear;
		public LightmapsMode mode;
		public List<string> renderName = new List<string>();
		public Vector4[] lightmapScaleOffset;
		public int[] lightmapIndex;
		public FogMode fogMode;
		public Color fogColor;
		public float fogStartDistance;
		public float fogEndDistance;
		public bool fog;
		public AmbientMode ambientMode;
		public Color ambientLight;

		public void SaveSettings()
		{
			mode = LightmapSettings.lightmapsMode;
			lightmapFar = null;
			lightmapNear = null;
			if (LightmapSettings.lightmaps != null && LightmapSettings.lightmaps.Length > 0)
			{
				int l = LightmapSettings.lightmaps.Length;
				lightmapFar = new Texture2D[l];
				lightmapNear = new Texture2D[l];
				for (int i = 0; i < l; i++)
				{
					lightmapFar[i] = LightmapSettings.lightmaps[i].lightmapColor;
					lightmapNear[i] = LightmapSettings.lightmaps[i].lightmapDir;
				}
			}
			RendererLightMapSetting[] savers = Transform.FindObjectsOfType<RendererLightMapSetting>();
			foreach(RendererLightMapSetting s in savers)
			{
				s.SaveSettings();
			}

			//保存雾效
			fogMode = RenderSettings.fogMode;
			fogColor = RenderSettings.fogColor;
			fogStartDistance = RenderSettings.fogStartDistance;
			fogEndDistance = RenderSettings.fogEndDistance;
			fog = RenderSettings.fog;

			ambientMode = RenderSettings.ambientMode;
			ambientLight = RenderSettings.ambientLight;
		}

		public void LoadSettings()
		{
			LightmapSettings.lightmapsMode = mode;
			int l1 = (lightmapFar == null) ? 0 : lightmapFar.Length;
			int l2 = (lightmapNear == null) ? 0 : lightmapNear.Length;
			int l = (l1 < l2) ? l2 : l1;
			LightmapData[] lightmaps = null;
			if (l > 0)
			{
				lightmaps = new LightmapData[l];
				for (int i = 0; i < l; i++)
				{
					lightmaps[i] = new LightmapData();
					if (i < l1)
						lightmaps[i].lightmapColor = lightmapFar[i];
					if (i < l2)
						lightmaps[i].lightmapDir = lightmapNear[i];
				}

				LightmapSettings.lightmaps = lightmaps;
			}

			Renderer[] savers = Transform.FindObjectsOfType<Renderer>();
			foreach (Renderer s in savers) {
				int index = renderName.IndexOf (s.name);
				if (index != -1) {
					s.lightmapIndex = lightmapIndex [index];
					s.lightmapScaleOffset = lightmapScaleOffset [index];
				}
			}

			RenderSettings.fogMode = fogMode;
			RenderSettings.fogColor = fogColor;
			RenderSettings.fogStartDistance = fogStartDistance;
			RenderSettings.fogEndDistance = fogEndDistance;
			RenderSettings.fog = fog;

			RenderSettings.ambientMode = ambientMode;
			RenderSettings.ambientLight = ambientLight;
		}

		void OnEnable()
		{
			#if UNITY_EDITOR
			UnityEditor.Lightmapping.completed += SaveSettings;
			#endif
		}
		void OnDisable()
		{
			#if UNITY_EDITOR
			UnityEditor.Lightmapping.completed -= SaveSettings;
			#endif
		}

		void Awake () {
			if(Application.isPlaying){
				LoadSettings();
			}
		}
	}
}