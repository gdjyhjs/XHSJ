// Copyright (c) 2016 Seven
// direct 
//
using UnityEngine;
using System.Collections.Generic;
using SLua;

namespace Seven
{
	/// <summary>
	/// 引用挂接
	/// </summary>
	[SLua.CustomLuaClass]
	public class AnimationEventMgr : MonoBehaviour
	{

		/// <summary>``
		/// for index
		/// </summary>

		//开始移动回调
		public LuaFunction callback;

		void CallBack(string arg)
		{
			if (callback != null) {
				callback.call (arg);
			}
		}
	}

}
