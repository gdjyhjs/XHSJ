using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using SLua;

namespace Seven{
	[SLua.CustomLuaClass]
	public class ContentSizeFitterParent : ContentSizeFitter {
		[DoNotToLua]
		public RectTransform parent;
		public float upOffset;
		public float downOffset;
		[DoNotToLua]
		public float spacing;
		[SerializeField]
		private RectTransform[] childs;//如果是要根据所有直属子物体来控制高度，这个不用给值
		[DoNotToLua]
		public float maxHeight;
		[DoNotToLua]
		public float minHeight;
		private bool withChild = false;
		public LuaFunction onRectTransformDimensionsChangeFn;
		public bool open = true;
		protected override void Start ()
		{
			base.Start ();
			if (childs == null || childs.Length < 1)
				withChild = true;
		}
		protected override void OnRectTransformDimensionsChange ()
		{
			base.OnRectTransformDimensionsChange ();
			if (open)
				SetParent ();
		}

		protected override void OnEnable ()
		{
				SetLayoutVertical ();
		}


		private void SetParent(){
			if (parent != null) {
				if (withChild) {
					childs = new RectTransform[parent.childCount];
					for (int i = 0; i < parent.childCount; i++) {
						childs [i] = parent.GetChild (i) as RectTransform;
					}
				}
				if (childs.Length > 0) {
					float height = upOffset + downOffset + (childs.Length - 1) * spacing;
					for (int i = 0; i < childs.Length; i++) {
						if (childs [i].gameObject.activeSelf)
							height += childs [i].sizeDelta.y;
					}
					parent.sizeDelta = new Vector2 (parent.sizeDelta.x, height > maxHeight ? maxHeight : height < minHeight ? minHeight : height);
				}
			}
				if (onRectTransformDimensionsChangeFn != null)
					onRectTransformDimensionsChangeFn.call ();
		}
	}
}