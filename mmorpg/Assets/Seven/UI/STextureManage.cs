using UnityEngine;  
using System.Collections;  
using System.Collections.Generic; 
using Hugula.Utils;
using Hugula.Loader;
using SLua;
using System.IO;

namespace Seven
{
	//纹理图集加载管理  
	[SLua.CustomLuaClass]
	public class STextureManage { 
		private static STextureManage m_pContainer = null;  
		public static STextureManage getInstance(){  
			if(m_pContainer == null){  
				m_pContainer = new STextureManage();
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

		/// <summary>
		/// 加载图集上的一个小图
		/// </summary>
		/// <param name="name">图集名字</param>
		/// <param name="spriteName">小图名字</param>
		/// <param name="onComplete">完成回调</param>
		/// <param name="onError">错误回调</param>
		public Sprite Load(string name, string spriteName, LuaFunction onComplete, LuaFunction onError)
		{
			Sprite sprite = null;

			string assetName = name.ToLower ();
			string abName = CUtils.GetRightFileName (assetName + Common.CHECK_ASSETBUNDLE_SUFFIX);
			sprite = FindSpriteFormBuffer (abName,spriteName);
			if (sprite) {
				if (onComplete != null) {
					Object[] atlas = null;
					if (m_pAtlasDic.ContainsKey (abName)) {
						atlas = m_pAtlasDic [abName];
					}
					Sprite[] sprites = new Sprite[atlas.Length-1];
					for (int i = 1; i < atlas.Length; i++) {
						sprites [i-1] = (Sprite)atlas [i];
					}
					onComplete.call (sprite, sprites);
				}
				return sprite;
			}

			CRequest req = CRequest.Get();
			req.relativeUrl = abName;
			req.assetName = assetName;
			req.async = false;
			req.assetType = CacheManager.Typeof_ABAllAssets;
			req.OnComplete += delegate (CRequest req1) {
				CountMananger.Add(req1.keyHashCode);
				Object[] atlas = req1.data as Object[];
				if(!m_pAtlasDic.ContainsKey(req1.relativeUrl)){
					m_pAtlasDic.Add (req1.relativeUrl, atlas); 
				} 
				sprite = SpriteFormAtlas (atlas, spriteName);
				if(onComplete != null){
					Sprite[] sprites = new Sprite[atlas.Length-1];
					for (int i = 1; i < atlas.Length; i++) {
						sprites [i-1] = (Sprite)atlas [i];
					}
					onComplete.call(sprite, sprites);
				}
			};

			req.OnEnd += delegate (CRequest req1) {
				if(onError != null){
					onError.call();
				}
			};
			ResourcesLoader.LoadAsset (req);

			return sprite;
		}

		[SLua.DoNotToLua]
		public void Load(string name, string spriteName, System.Action<Sprite> OnFinish)
		{
			Sprite sprite = null;

			string assetName = name.ToLower ();
			string abName = CUtils.GetRightFileName (assetName + Common.CHECK_ASSETBUNDLE_SUFFIX);
			sprite = FindSpriteFormBuffer (abName,spriteName);
			if (sprite) {
				if (OnFinish != null) {
					OnFinish (sprite);
				}
				return;
			}

			CRequest req = CRequest.Get();
			req.relativeUrl = abName;
			req.assetName = assetName;
			req.async = false;
			req.assetType = CacheManager.Typeof_ABAllAssets;
			req.OnComplete += delegate (CRequest req1) {
				CountMananger.Add(req1.keyHashCode);
				Object[] atlas = req1.data as Object[];
				if(!m_pAtlasDic.ContainsKey(req1.relativeUrl)){
					m_pAtlasDic.Add (req1.relativeUrl, atlas); 
				} 
				sprite = SpriteFormAtlas (atlas, spriteName);
				if (OnFinish != null) {
					OnFinish (sprite);
				}
			};
			ResourcesLoader.LoadAsset (req);
		}

		//删除图集缓存  
		public void DeleteAtlas(string abName){  
			if (m_pAtlasDic.ContainsKey (abName)) {  
				m_pAtlasDic.Remove (abName);  
			}  
		} 

		//获取大图
		public Texture2D GetBigImg(string name)
		{
			string assetName = name.ToLower ();
			string abName = CUtils.GetRightFileName (assetName + Common.CHECK_ASSETBUNDLE_SUFFIX);
			if (m_pAtlasDic.ContainsKey (abName)) { 
				return (Texture2D)m_pAtlasDic[abName][0];
			}
			return null;
		}

		public void Clear()
		{
//			foreach (string key in m_pAtlasDic.Keys) {
//				CountMananger.Subtract (key);
//			}
			m_pAtlasDic.Clear ();
		}

		//从缓存中查找图集，并找出sprite  
		private Sprite FindSpriteFormBuffer(string abName,string _spriteName){  
//			Debug.Log ("从缓存中查找图集"+abName+", "+m_pAtlasDic.ContainsKey (abName)+","+m_pAtlasDic.Count);
			if (m_pAtlasDic.ContainsKey (abName)) {  
				Object[] _atlas = m_pAtlasDic[abName];  
				Sprite _sprite = SpriteFormAtlas(_atlas,_spriteName);  
				return _sprite;  
			}  
			return null;  
		}  
		//从图集中，并找出sprite  
		private Sprite SpriteFormAtlas(Object[] _atlas,string _spriteName){  
			for (int i = 0; i < _atlas.Length; i++) {  
				if (_atlas [i] && _atlas [i].GetType () == typeof(UnityEngine.Sprite)) {  
					if(_atlas [i].name == _spriteName){  
						return (Sprite)_atlas [i];  
					}  
				}  
			}  
//			Debug.LogWarning ("图片名:"+_spriteName+";在图集中找不到");  
			return null;  
		}  
	}  
}