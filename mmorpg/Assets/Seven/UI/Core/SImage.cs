using UnityEngine;
using UnityEngine.UI.Ext;
using UnityEngine.UI;
using UnityEngine.Rendering;
using SLua;
using Hugula.Utils;
using Hugula.Loader;
using System.Collections.Generic;
using System.IO;
using Seven;

#if UNITY_EDITOR
using UnityEditor;
#endif
namespace UnityEngine.UI
{
	[SLua.CustomLuaClass]
	public class SImage : UnityEngine.UI.Image
	{
		class ATexEntry
		{
			public Texture aTex;
			public int count;
		}
		private static Dictionary<string, ATexEntry> aTexList = new Dictionary<string, ATexEntry>();

		static Texture GetATex(string name)
		{
			if (aTexList.ContainsKey (name)) {
				ATexEntry at = aTexList [name];
				at.count++;
				return at.aTex;
			}
			return null;
		}

		static void AddATex(string name, Texture aTex)
		{
			if (!aTexList.ContainsKey (name)) {
				ATexEntry at = new ATexEntry ();
				at.count = 1;
				at.aTex = aTex;
				aTexList.Add (name, at);
			}
		}

		[SLua.DoNotToLua]
		public static void RemoveATex(string name)
		{
			if (aTexList.ContainsKey (name)) {
				ATexEntry at = aTexList [name];
				at.count--;
				if (at.count == 0) {
					aTexList.Remove (name);
//					CountMananger.Subtract (CUtils.GetRightFileName (name) + Common.CHECK_ASSETBUNDLE_SUFFIX);
				}
			}
		}

		public static void ClearATexList()
		{
//			foreach (string key in aTexList.Keys) {
//				CountMananger.Subtract (CUtils.GetRightFileName (key) + Common.CHECK_ASSETBUNDLE_SUFFIX);
//			}
			aTexList.Clear ();
		}

		private Texture m_aTex;
		public Texture alphaTex
		{
			set
			{
				m_aTex = value;
			}
			get 
			{
				return m_aTex;
			}
		}

		void SetAlphaTex(string alphaName)
		{
			if (alphaName.Equals ("unitywhite")) {
				return;
			}
			if (!alphaName.Contains ("_a")) {
				return;
			}
			alphaName = alphaName.ToLower();
			Texture aTex = GetATex (alphaName);
			if (aTex != null) {
				m_aTex = aTex;

			} else {
				
//				#if UNITY_EDITOR
//				m_aTex = AssetDatabase.LoadAssetAtPath ( AssetDatabase.GetAssetPath (mainTexture).Replace ("rgb.png", "a.png"), typeof(Texture)) as Texture;
//				AddATex (alphaName, m_aTex);
//				#else

				string abName = CUtils.GetRightFileName (alphaName)+Common.CHECK_ASSETBUNDLE_SUFFIX;
				CRequest req = CRequest.Get();
				req.relativeUrl = abName;
				req.assetName = alphaName;
				req.async = false;
				req.assetType = CacheManager.Typeof_Texture2D;
				var uris = req.uris;
				string url;
				if (File.Exists (CUtils.PathCombine (uris [0], req.relativeUrl))) {
					url = CUtils.GetAndroidABLoadPath (CUtils.PathCombine (uris [0], req.relativeUrl));
				} else {
					url = CUtils.GetAndroidABLoadPath (CUtils.PathCombine (uris [1], req.relativeUrl));
				}

				AssetBundle ab = null;
				if (CacheManager.GetCache (req.keyHashCode) != null) {
					ab = CacheManager.GetCache (req.keyHashCode).assetBundle;
				} else {
					ab = AssetBundle.LoadFromFile (url);
					CacheManager.AddSourceCacheDataFromWWW (ab, req);
				}
				if (ab != null) {
					m_aTex = ab.LoadAsset (req.assetName, req.assetType) as Texture;
					AddATex (alphaName, m_aTex);
				}
//				#endif
			}
		}

		public void SetSprite(string rgbName, string spriteName, LuaFunction cb = null)
		{
			if (rgbName.Equals ("unitywhite")) {
				return;
			}
			SetAlphaTex (rgbName.Replace("rgb","a"));
			STextureManage.getInstance ().Load (rgbName, spriteName,delegate(Sprite sp) {
				enabled = false;
				sprite = sp;
				if(cb!=null){
					cb.call(sp);
				}
				enabled = true;
			});
		}

		protected override void Awake()
		{
			base.Awake();
			if (Application.isPlaying)
			{
				hideFlags = HideFlags.DontSave;
			}
			SetAlphaTex (mainTexture.name.Replace("rgb", "a").ToLower());
		}

		Material m_SplitAlphaMaterial;
		[SLua.DoNotToLua]
		public override Material GetModifiedMaterial(Material baseMaterial)
		{
			if (sprite != null && m_aTex == null) {
				SetAlphaTex (mainTexture.name.Replace("rgb", "a").ToLower());
			}

			var toUse = baseMaterial;
			if (baseMaterial && !baseMaterial.name.Contains ("Default UI Material")) {
				if (baseMaterial.shader.name.Equals ("Seven/UISprites/Circular")) {//圆形裁剪
					float wr = sprite.rect.width * 1.0f / sprite.texture.width;  
					float offX = sprite.rect.x * 1.0f / sprite.texture.width;  
					float hr = sprite.rect.height * 1.0f / sprite.texture.height; 
					float offY = sprite.rect.y * 1.0f / sprite.texture.height; 
					baseMaterial.SetFloat ("_WidthRate", wr);  
					baseMaterial.SetFloat ("_HeightRate", hr);  
					baseMaterial.SetFloat ("_XOffset", offX);  
					baseMaterial.SetFloat ("_YOffset", offY); 
					baseMaterial.EnableKeyword ("SEVEN_UI_CIRCULAR");
					toUse = baseMaterial;
				} else {
					toUse = SplitAlphaMaterial.Add (toUse, m_aTex, sprite);
				}
			} else {
				// split alpha
				#if UNITY_EDITOR
				if (!Application.isPlaying)
				{
					SetAlphaTex(mainTexture.name.Replace("rgb", "a").ToLower());
				}
				#endif
				toUse = SplitAlphaMaterial.Add(toUse, m_aTex);
			}

			SplitAlphaMaterial.Remove(m_SplitAlphaMaterial);
			m_SplitAlphaMaterial = toUse;

			// maskable
			if (m_ShouldRecalculateStencil)
			{
				var rootCanvas = MaskUtilities.FindRootSortOverrideCanvas(transform);
				m_StencilValue = maskable ? MaskUtilities.GetStencilDepth(transform, rootCanvas) : 0;
				m_ShouldRecalculateStencil = false;
			}

			// if we have a Mask component then it will
			// generate the mask material. This is an optimisation
			// it adds some coupling between components though :(
			if (m_StencilValue > 0 && GetComponent<Mask>() == null)
			{
				var maskMat = StencilMaterial.Add(toUse, (1 << m_StencilValue) - 1, StencilOp.Keep, CompareFunction.Equal, ColorWriteMask.All, (1 << m_StencilValue) - 1, 0);
				StencilMaterial.Remove(m_MaskMaterial);
				m_MaskMaterial = maskMat;
				toUse = m_MaskMaterial;

				toUse.SetTexture("_AlphaTex", m_aTex);
			}

			return toUse;
		}
	}
}