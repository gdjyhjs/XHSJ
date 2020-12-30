using UnityEngine;
using UnityEngine.UI;

namespace Seven
{
	[RequireComponent(typeof (Text))]
	[AddComponentMenu("Language/LanguageText")]

	public class LanguageText : MonoBehaviour {
		[HideInInspector] public string Language;
		[HideInInspector] public string File;
		[HideInInspector] public string Key;
		[HideInInspector] public string Value;

		public LanguageService Localization;
		// Use this for initialization

		void Start()
		{
			Localization = LanguageService.Instance;
			var label = GetComponent<Text>();
			GetComponent<Text>().text = Localization.GetStringByKey(label.text);
		}

	}
}

