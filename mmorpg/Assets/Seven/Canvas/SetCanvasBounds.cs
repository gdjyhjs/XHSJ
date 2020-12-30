/**
 * iphone屏幕适配
*/
using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;
using UnityEngine.UI;

namespace Seven
{
	public class SetCanvasBounds : MonoBehaviour {

		#if UNITY_IOS
		[DllImport("__Internal")]
		private extern static void GetSafeAreaImpl(out float x, out float y, out float w, out float h);
		#endif

		static float scaler = Screen.width / Screen.height;

		private Rect GetSafeArea()
		{
			float x, y, w, h;
			#if UNITY_IOS && !UNITY_EDITOR
			GetSafeAreaImpl(out x, out y, out w, out h);
			#else
			x = 0;
			y = 0;
			w = Screen.width;
			h = Screen.height;
			#endif
			if (isIphoneX) {
				x -= 50;
				y -= 60;
				w += 100;
				h += 60;
			}
			return new Rect(x, y, w, h);
		}

		public RectTransform panel;
		public bool IsSet = true;
		Rect lastSafeArea = new Rect(0, 0, 0, 0);
		bool isIphoneX = false;

		// Use this for initialization
		void Awake () {
			
//			GameObject obj = new GameObject ("SevenPanel");
//			panel = obj.AddComponent<RectTransform> ();
//
//			Transform[] child = new Transform[transform.childCount];
//			for (int i = 0; i < transform.childCount; i++) {
//				Transform ct = transform.GetChild (i);
//				child [i] = ct;
//			}
//
//			obj.transform.parent = transform;
//			panel.anchoredPosition3D = Vector3.zero;
//			panel.sizeDelta = Vector2.zero;
//			panel.anchorMin = new Vector2(0,0);
//			panel.anchorMax = new Vector2(1,1);
//			panel.pivot = new Vector2 (0.5f, 0.5f);
//			panel.localScale = new Vector3 (1, 1, 1);
//
//			for (int i = 0; i < child.Length; i++) {
//				child [i].parent = obj.transform;
//			}
			gameObject.SetActive(false);
			if (panel == null) {
				Transform p = transform.Find ("panel");
				if (p != null) {
					panel = p.GetComponent<RectTransform> ();
				}
			}

			#if UNITY_IOS && !UNITY_EDITOR
			if (Screen.width == 2436 && Screen.height == 1125) {
				isIphoneX = true;
			}
			#endif

			if (scaler > 1.78f) {
				CanvasScaler cs = GetComponent<CanvasScaler> ();
				if (cs != null) {
					cs.matchWidthOrHeight = 1f;
				}
			}
			RefreshArea ();
			gameObject.SetActive (true);
		}

		void ApplySafeArea(Rect area)
		{
			var anchorMin = area.position;
			var anchorMax = area.position + area.size;
			anchorMin.x /= Screen.width;
			anchorMin.y /= Screen.height;
			anchorMax.x /= Screen.width;
			anchorMax.y /= Screen.height;
			if (panel != null) {
				panel.anchorMin = anchorMin;
				panel.anchorMax = anchorMax;
			}
			lastSafeArea = area;
		}

		void RefreshArea()
		{
			#if UNITY_IOS && !UNITY_EDITOR
			if (IsSet) {
				Rect safeArea = GetSafeArea (); // or Screen.safeArea if you use a version of Unity that supports it

				if (safeArea != lastSafeArea)
					ApplySafeArea (safeArea);
			}
			#endif
		}

		// Update is called once per frame
		void Update () 
		{
			RefreshArea ();
		}
	}
}
