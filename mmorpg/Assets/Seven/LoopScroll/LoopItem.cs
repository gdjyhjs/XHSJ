using UnityEngine;
using System.Collections.Generic;
//using SLua;

namespace UnityEngine.UI
{
	/// <summary>
	/// 滚动列表
	/// </summary>
	[SLua.CustomLuaClass]
	[ExecuteInEditMode]
	[RequireComponent(typeof(RectTransform))]
	public class LoopItem : MonoBehaviour
	{

		/// <summary>
		/// for index
		/// </summary>
		[SLua.DoNotToLua]
		[HideInInspector]
		public List<string> names = new List<string>();

		public RectTransform rectTransform;

		public GameObject[] refers;
		[HideInInspector]
		public Object[] monos;

		public object data;

		public float fdata;

		public int index;

		public LayoutElement element;

		//public int idata;

		//public string sdata;

		// Use this for initialization
		void Start()
		{
			if (rectTransform == null)
				rectTransform = this.GetComponent<RectTransform>();
			if (element == null)
				element = this.GetComponent<LayoutElement> ();
		}

		public Object Get(string n)
		{
			int index = names.IndexOf(n);
			if (index == -1)
			{
				Debug.LogWarning(gameObject.name + "ScrollRectItem : not found the key [" + n + "]");
				return null;
			}
			else
				return Get(index + 1);
		}

		public Object Get(int index)
		{
			index = index - 1;
			if (index >= 0 && index < monos.Length)
			{
				return monos[index];
			}
			else
			{
				Debug.LogWarning(gameObject.name + "ScrollRectItem : not found the key [" + index + "]");
				return null;
			}
		}

		/// <summary>
		/// monos的长度
		/// </summary>
		public int Length
		{
			get
			{
				if (monos != null)
					return monos.Length;
				else
					return 0;
			}
		}

		/// <summary>
		/// 设置宽度
		/// </summary>
		/// <param name="width">Width.</param>
		public void SetWidth(float width)
		{	if (element.preferredWidth != width) {
				element.preferredWidth = width;
			}
		}

		/// <summary>
		/// 设置高度
		/// </summary>
		/// <param name="height">Height.</param>
		public void SetHeight(float height)
		{
			if (element.preferredHeight != height) {
				element.preferredHeight = height;
			}
		}
	}
}

