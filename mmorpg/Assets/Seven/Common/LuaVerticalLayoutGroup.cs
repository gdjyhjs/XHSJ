using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using SLua;

namespace Seven{
	[SLua.CustomLuaClass]
	public class LuaVerticalLayoutGroup : VerticalLayoutGroup {
		//用于聊天系统 先撑起足够空间之后再使用图文混排文本
		public LuaFunction onRectTransformDimensionsChangeEndFn;

		protected override void OnRectTransformDimensionsChange ()
		{
			base.OnRectTransformDimensionsChange ();
			StartCoroutine ("OnRectTransformDimensionsChangeEnd");
		}

		private IEnumerator OnRectTransformDimensionsChangeEnd()
		{
			yield return null;
			if (onRectTransformDimensionsChangeEndFn != null) {
				onRectTransformDimensionsChangeEndFn.call ();
				onRectTransformDimensionsChangeEndFn = null;
			}
		}



	}
}