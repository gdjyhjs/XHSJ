// Copyright (c) 2016 Seven
// direct 
//
using UnityEngine;
using System.Collections.Generic;
using Seven.Move;
using Seven.Attack;

namespace Seven
{
	/// <summary>
	/// 引用挂接
	/// </summary>
	[SLua.CustomLuaClass]
	public class TargetFollow : MonoBehaviour
	{

		/// <summary>``
		/// for index
		/// </summary>

		//跟随目标
		public Transform target;
		public bool addOther = true;
		private Vector3 offset;
		private Vector3 originOffset;

		private NormalMove targetNormalMove;
		private AutoMove targetAutoMove;
		private PlayerAttack atkMgr;
		private CameraShake shake;
		private DeemoRadialBlur deemo;

		private float speed = 0.0f;
		private float resumeSpeed;
		private float scaleTime;
		private float stopTime;
		private float resumeTime;
		private float late_time;
		private bool isScale = false;
		private Vector3 offsetNormalized;
		private bool isTeamFollow = false;

		void Start()
		{
			offset = transform.position - target.position;
			originOffset = offset;
			offsetNormalized = offset.normalized;

			if (addOther) {
				shake = gameObject.AddComponent<CameraShake> ();
				if (gameObject.GetComponent<ChangeCamera> () == null)
					gameObject.AddComponent<ChangeCamera> ();
				deemo = gameObject.AddComponent<DeemoRadialBlur> ();
				deemo.enabled = false;
			}
		}

		void Update()
		{
			if (!target)
				return;
			
			UpdataScale ();

			if (!IsMove () && (shake && !shake.IsShake()) && !isScale)
				return;
			
			transform.position = target.position + offset;
		}

		void UpdataScale()
		{
			if (isScale) 
			{
				if (late_time > 0) {
					late_time -= Time.deltaTime;
				}
				else if (scaleTime > 0) {
					scaleTime -= Time.deltaTime;
					offset -= offsetNormalized*speed*Time.deltaTime;
				} 
				else if (stopTime > 0) {
					stopTime -= Time.deltaTime;
				} 
				else if (resumeTime > 0) {
					resumeTime -= Time.deltaTime;
					offset += offsetNormalized*resumeSpeed*Time.deltaTime;
					if (resumeTime <= 0) {
						offset = originOffset;
						isScale = false;
						transform.position = target.position + offset;
					}
				} 
				else {
					offset = originOffset;
					isScale = false;
				}
			}
		}

		public void SetTarget(GameObject target)
		{
			if (target != null) {
				this.target = target.transform;
				this.transform.position = this.target.position + offset;

				targetNormalMove = target.GetComponent<NormalMove> ();
				targetAutoMove = target.GetComponent<AutoMove> ();
				atkMgr = target.GetComponent<PlayerAttack> ();
			} else {
				this.target = null;
			}
		}

		public void Reset()
		{
			transform.position = target.position + offset;
		}

		public void SetCameraScale(float scaleTime, float stopTime, float resumeTime, float late_time,float distance)
		{
			this.scaleTime = scaleTime;
			this.stopTime = stopTime;
			this.resumeTime = resumeTime;
			this.late_time = late_time;
			this.speed = distance / scaleTime;
			this.resumeSpeed = distance / resumeTime;
			this.isScale = true;
		}

		[SLua.DoNotToLua]
		public bool IsMove()
		{
			if (targetNormalMove == null || targetAutoMove == null || atkMgr == null)
				return false;
			return targetNormalMove.IsMove () || targetAutoMove.IsAutoMove () || atkMgr.IsMove() || isTeamFollow;
		}

		//设置跟随队长
		public void SetTeamFollow(bool follow)
		{
			isTeamFollow = follow;
		}
	}

}