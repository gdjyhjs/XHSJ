using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System;
using SimpleJSON;
using Hugula.Loader;
using Hugula.Utils;

namespace Seven
{	
	[SLua.CustomLuaClass]
	public class LanguageInfo : IEquatable<LanguageInfo>
	{
		public string Name;
		public LanguageInfo(){}

		public LanguageInfo(string name)
		{
			Name = name;
		}

		public static readonly LanguageInfo English = new LanguageInfo("English");

		public bool Equals(LanguageInfo other)
		{
			return other.Name == Name;
		}
	}

	[ExecuteInEditMode]
	[SLua.CustomLuaClass]
	public class LanguageService {

		private static LanguageService _instance;
		public static LanguageService Instance
		{
			get { return _instance ?? (_instance = new LanguageService()); }
		}
		public List<string> Files { get; set; }
		public Dictionary<string, Dictionary<string, string>> StringsByFile { get; set; }
		public Dictionary<string, string> Strings { get; set; }

		public List<LanguageInfo> Languages = new List<LanguageInfo>
		{
			LanguageInfo.English,
		};

		public List<String> LanguageNames = new List<String> ();

		private LanguageInfo _language = new LanguageInfo {Name = "English" };
		public LanguageInfo Language
		{
			get { return _language; }
			set
			{
				if (!HasLanguage(value))
				{
					Debug.LogError("Invalid Language " + value);
				}

				_language = value;
				ReadJosnFiles();
			}
		}
		bool HasLanguage(LanguageInfo language)
		{
			foreach (var systemLanguage in Languages)
			{
				if (systemLanguage.Equals(language))
					return true;
			}
			return false;
		}

		public LanguageService()
		{
			LoadContent();
		}

		public void LoadContent()
		{		
#if UNITY_EDITOR
			var path = "Assets/CustomerResource/Localization/LocalizationConfig.json";
			TextAsset config = (TextAsset) UnityEditor.AssetDatabase.LoadAssetAtPath(path, typeof(TextAsset));
			var jsArray = JSONNode.Parse (config.text);
			LoadAllLanguages ((JSONClass)jsArray);
			return;
#endif
			string assetName = "LocalizationConfig".ToLower ();
			string abName = CUtils.GetRightFileName (assetName + Common.CHECK_ASSETBUNDLE_SUFFIX);

			CRequest req = CRequest.Get();
			req.relativeUrl = abName;
			req.assetName = assetName;
			req.assetType = typeof (TextAsset);
			req.async = false;
			req.OnComplete += delegate (CRequest req1) {
				TextAsset main = req1.data as TextAsset; //www.assetBundle.mainAsset as TextAsset;
				if (main.bytes == null)
				{
					Debug.LogError("Localization Files Not Found : LocalizationConfig.json");
				}else{
					var jsonArray = JSONNode.Parse (main.text);
					LoadAllLanguages ((JSONClass)jsonArray);
				}
				CacheManager.Unload (req1.keyHashCode);
			};

			req.OnEnd += delegate (CRequest req1) {

			};
			CacheManager.Unload(req.keyHashCode);
			ResourcesLoader.LoadAsset (req);
		}

		void LoadAllLanguages(JSONClass jsonClass){
			var d = LanguageInfo.English;
			foreach(KeyValuePair<string, JSONNode> json in jsonClass)
			{
				var language = new LanguageInfo (json.Value);
				LanguageNames.Add (language.Name);
				Languages.Add(language);
				if (json.Key == "Default"){
					d = language;
				}					
			}
			Language = d;
		}
			
		// 读取Josn文件
		void ReadJosnFiles()
		{
			Strings = new Dictionary<string, string>();
			StringsByFile = new Dictionary<string, Dictionary<string, string>>();
			Files = new List<string>();
#if UNITY_EDITOR

			var path = "Assets/CustomerResource/Localization/"+Language.Name+".json";
			TextAsset resource = (TextAsset)UnityEditor.AssetDatabase.LoadAssetAtPath (path, typeof(TextAsset));
			ReadTextAsset(resource);
			return;
#endif
			string assetName = Language.Name.ToLower ();
			string abName = CUtils.GetRightFileName (assetName + Common.CHECK_ASSETBUNDLE_SUFFIX);

			CRequest req = CRequest.Get();
			req.relativeUrl = abName;
			req.assetName = assetName;
			req.assetType = typeof (TextAsset);
			req.async = false;

			req.OnComplete += delegate (CRequest req1) {
			TextAsset main = req1.data as TextAsset; //www.assetBundle.mainAsset as TextAsset;
			#if UNITY_EDITOR
			Debug.Log (Language.Name + " is loaded " + main.bytes.Length);
			#endif
			if (main.bytes == null)
			{
				Debug.LogError("Localization Files Not Found : " + Language.Name);
			}else{
				ReadTextAsset(main);
			}
			CacheManager.Unload (req1.keyHashCode);
		};

		req.OnEnd += delegate (CRequest req1) {

		};

		CacheManager.Unload(req.keyHashCode);
		ResourcesLoader.LoadAsset (req);

		}

		// 将TextAsset内容读取到字典中
		void ReadTextAsset(TextAsset resource)
		{
			var jsonArray = JSONNode.Parse (resource.text);
			Files.Add(resource.name);
			StringsByFile.Add(resource.name, new Dictionary<string, string>());
			foreach(KeyValuePair<string, JSONNode> json in (JSONClass)jsonArray)
			{
				StringsByFile[resource.name].Add(json.Key, json.Value);
				if (Strings.ContainsKey(json.Key))
					Debug.LogWarning("Duplicate string : " + resource + " : " + json.Key);
				else
					Strings.Add(json.Key, json.Value);
			}
		}

		// 根据key获取相应的语言内容
		public string GetStringByKey(string key)
		{
			if (!Strings.ContainsKey(key))
			{
//				Debug.LogWarning(string.Format("Localization Key Not Found {0} : {1} ", Language.Name, key));
				return key;
			}
			return Strings[key]; 
		}
	}
}
