using UnityEngine;
using UnityEngine.UI;
using System;
using System.Linq;
using System.Collections;
using UnityEditor;

namespace Seven
{
	public class UIEditor : UnityEditor.Editor
	{
//		[AddComponentMenu("UGUI/ScrollPage")]
//		[MenuItem("UI/ScrollPage")]
		static void CreateScrollPage()
		{
			Canvas canvas = GameObject.FindObjectOfType<Canvas> ();
			Debug.Log ("------canvas = " + canvas);
//			canvas.gameObject.AddComponent<UIScrollView> ();

		}
	}
}
