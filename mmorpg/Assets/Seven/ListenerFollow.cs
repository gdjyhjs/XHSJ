// Copyright (c) 2016 Seven
// direct 
//
using UnityEngine;
using System.Collections.Generic;

namespace Seven
{
	/// <summary>
	/// 引用挂接
	/// </summary>
	[SLua.CustomLuaClass]
	public class ListenerFollow : MonoBehaviour
	{

		//目标物体
		public Transform target;

		void LateUpdate()
		{
			if (target == null) 
			{
				return;
			}
			transform.position = target.position;
		}
	}

}