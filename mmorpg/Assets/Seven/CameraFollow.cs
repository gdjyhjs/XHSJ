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
	public class CameraFollow : MonoBehaviour
	{

		/// <summary>``
		/// for index
		/// </summary>

		//相机距离目标物体点的距离
		public float distance = 15;
		//目标物体
		public GameObject target;

		//横向角度
		private float rot = 90;
		//纵向角度
		private float roll = 45f * Mathf.PI * 2 /360;


		private float sinRot;
		private float cosRot;
		private float sinRoll;
		private float cosRoll;

		void Start()
		{
			sinRot = Mathf.Sin (rot);
			cosRot = Mathf.Cos (rot);
			sinRoll = Mathf.Sin (roll);
			cosRoll = Mathf.Cos (roll);
		}

		void LateUpdate()
		{
			if (target == null) 
			{
				return;
			}

			if (Camera.main == null) 
			{
				return;
			}

			Vector3 targetPos = target.transform.position;
			Vector3 cameraPos;
			float d = distance * cosRoll;
			float height = distance * sinRoll;
			cameraPos.x = targetPos.x + d * cosRot;
			cameraPos.z = targetPos.z + d * sinRot;
			cameraPos.y = targetPos.y + height;
			Camera.main.transform.position = cameraPos;
			Camera.main.transform.LookAt (target.transform.position);
		}

		public void SetRot(float angle)
		{
			rot = angle;
			sinRot = Mathf.Sin (rot);
			cosRot = Mathf.Cos (rot);
		}

		public void SetRoll(float angle)
		{
			roll = angle * Mathf.PI * 2 /360;
			sinRoll = Mathf.Sin (roll);
			cosRoll = Mathf.Cos (roll);
		}
	}

}