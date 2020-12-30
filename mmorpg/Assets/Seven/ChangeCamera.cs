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
//	[SLua.CustomLuaClass]
	public class ChangeCamera : MonoBehaviour
	{

		/// <summary>``
		/// for index
		/// </summary>
//		public GameObject camera;

		private Camera beginCamera;
		private GameObject effectCamera;
		private Camera camera;

		void Awake()
		{
			camera = GetComponent<Camera> ();
			camera.clearFlags = CameraClearFlags.Depth;
			camera.cullingMask &= ~(1<<5);
			camera.cullingMask &= ~(1<<9);
			camera.cullingMask &= ~(1<<10);
			camera.cullingMask &= ~(1<<11);

			beginCamera = GameObject.Find("BeginCamera").GetComponent<Camera>();
			beginCamera.enabled = false;

			effectCamera = GameObject.Find ("EffectCamera");
			if (effectCamera) {
				effectCamera.transform.parent = transform;
				effectCamera.transform.position = transform.position;
				effectCamera.transform.eulerAngles = transform.eulerAngles;
			}
		}

		void OnDestroy()
		{
			if(effectCamera && beginCamera)
				effectCamera.transform.parent = beginCamera.transform.parent;
			if(beginCamera)
				beginCamera.enabled = true;
		}
	}

}