using UnityEngine;
using UnityEngine.UI;
using System;
using System.Linq;
using System.Collections;
using UnityEditor;

namespace Seven
{
	[CustomEditor(typeof(LanguageText), true)]
	public class LanguageEditor : UnityEditor.Editor
	{
		protected LanguageText Target;
		public override void OnInspectorGUI()
		{
			base.OnInspectorGUI();

			Target = target as LanguageText;

			if (Application.isPlaying)
				return;

			var service = LanguageService.Instance;
			if (service == null || service.Strings == null)
			{
				var p = EditorGUILayout.TextField("Key", Target.Key);
				if (p != Target.Key)
				{
					Target.Key = p;
					EditorUtility.SetDirty(target);
				}
				EditorGUILayout.LabelField("Error ", "ILocalizationService Not Found");
			}
			else
			{
				var languages = service.LanguageNames.ToArray();
				var languageIdx = Array.IndexOf(languages, service.Language.Name);
				var language = EditorGUILayout.Popup("Language", languageIdx, languages);
				if (language != languageIdx){
					Target.Language = languages[language];
					service.Language = new LanguageInfo (languages[language]);

					EditorUtility.SetDirty(target);
				}
				if (!string.IsNullOrEmpty(Target.Key)){
					Target.Value = service.GetStringByKey(Target.Key);
				}
				var files = service.StringsByFile.Select(o => o.Key).ToArray();

				var findex = Array.IndexOf(files, Target.File);
				var fi = EditorGUILayout.Popup("File", findex, files);

				if (findex == -1 || fi != findex){
					Target.File = files[0]; 
					EditorUtility.SetDirty(target);
				}
				//
				if (!string.IsNullOrEmpty(Target.File))
				{
					var words = service.StringsByFile[Target.File].Select(o => o.Key).ToArray();
					var index = Array.IndexOf(words, Target.Key);

					var i = EditorGUILayout.Popup("Keys", index, words);

					if (i != index)
					{
						Target.Key = words[i];
						Target.Value = service.GetStringByKey(Target.Key);
						EditorUtility.SetDirty(target);
					}

				}
				if (!string.IsNullOrEmpty(Target.Value))
				{
					EditorGUILayout.LabelField("Value ", Target.Value);
					Target.GetComponent<UnityEngine.UI.Text>().text = Target.Value;
				}
			}
		}
	}
}
