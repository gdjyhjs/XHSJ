using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SLua;

namespace Seven{
	[CustomLuaClass]
	public class FloatText : MonoBehaviour {
		[HideInInspector]
		public Transform target;
		private Vector3 target_pos =  new Vector3 (-10000, -10000, 0);
		private Vector3 scene_pos = new Vector3 (-10000, -10000, 0);
		[Tooltip("飘字持续时间")]
		public float duration = 1;
		[Tooltip("出生点最大偏移值")]
		public Vector3 max_offset;
		[Tooltip("出生点最小偏移值")]
		public Vector3 min_offset;
		[Tooltip("曲线开始位置的x坐标点（相对于怪物的头）")]
		public float start_pos_x;
		[Tooltip("曲线结束位置的x坐标点（相对于怪物的头）")]
		public float end_pos_x;
		[Tooltip("x位置曲线的变化轨迹")]
		public AnimationCurve offset_x;
		[Tooltip("曲线开始位置的y坐标点（相对于怪物的头）")]
		public float start_pos_y;
		[Tooltip("曲线结束位置的y坐标点（相对于怪物的头）")]
		public float end_pos_y;
		[Tooltip("y位置曲线的变化轨迹")]
		public AnimationCurve offset_y;
		[Tooltip("曲线开始位置的大小缩放")]
		public Vector3 start_sca;
		[Tooltip("曲线结束位置的大小缩放")]
		public Vector3 end_sca;
		[Tooltip("大小缩放曲线的变化轨迹")]
		public AnimationCurve scale;
		[Tooltip("曲线开始位置的透明度")]
		public float start_alp;
		[Tooltip("曲线结束位置的透明度")]
		public float end_alp;
		[Tooltip("透明度 曲线的变化轨迹")]
		public AnimationCurve alpha;

		public LuaFunction end_fun;

		private RectTransform my_tf;
		private CanvasGroup my_canv;
		private Camera main_camera;
		private RectTransform parent;
		private RectTransform canvas;

		private Vector3 offset_pos;

		private float timer = 0;

		void Awake(){
			my_tf = (RectTransform)transform;
			my_canv = GetComponentInChildren<CanvasGroup> ();
			parent = (RectTransform)transform.parent;
			canvas = GetComponentInParent<Canvas> ().transform as RectTransform;
		}

		void OnEnable () {
			timer = 0;
			offset_pos = new Vector3 (Random.Range (min_offset.x, max_offset.x), Random.Range (min_offset.y, max_offset.y) + 3.5f, 0);
			set_value ();
		}

		void Update(){
			timer = timer + Time.deltaTime;
			set_value ();
		}

		void set_value(){
			main_camera = Camera.main;
			float pos_x = start_pos_x + (end_pos_x - start_pos_x) * offset_x.Evaluate (timer / duration);
			float pos_y = start_pos_y + (end_pos_y - start_pos_y) * offset_y.Evaluate (timer / duration);
			my_tf.localPosition = new Vector3 (pos_x, pos_y, 0);

			my_tf.localScale = start_sca + (end_sca - start_sca) * scale.Evaluate (timer / duration);
			my_canv.alpha = start_alp + (end_alp - start_alp) * alpha.Evaluate (timer / duration);

			if (target != null && main_camera != null) {
				target_pos = target.position;
				scene_pos = main_camera.WorldToScreenPoint (target_pos + offset_pos);
				parent.anchoredPosition = new Vector2 (scene_pos.x * canvas.sizeDelta.x / Screen.width, scene_pos.y * canvas.sizeDelta.y / Screen.height);
			}else if(main_camera != null){
				scene_pos = main_camera.WorldToScreenPoint (target_pos + offset_pos);
				parent.anchoredPosition =  new Vector2 (scene_pos.x * canvas.sizeDelta.x / Screen.width, scene_pos.y * canvas.sizeDelta.y / Screen.height);
			}else {
				parent.anchoredPosition = new Vector3 (-10000, -10000, 0);
			}

			if (timer >= duration) {
				parent.gameObject.SetActive (false);
				target = null;
			}
		}

		void OnDisable(){
			target = null;
			target_pos =  new Vector3 (-10000, -10000, 0);
			if (end_fun != null) {
				end_fun.call ();
			}
		}
	}
}
