/**
 * 玩家一些动作切换
*/

using UnityEngine;
using System.Collections;
using SLua;

namespace Seven.Player
{
	[SLua.CustomLuaClass]
	public class PlayerState : MonoBehaviour
	{
		public float time = 10f;
		public int count = 2;

		private Animator animator;
		private DynamicAddEvents aniEvent;

		private float atkIdleTime = 0f;
		private bool isSIdle = false;
		private bool isOpen = true;

		// Use this for initialization
		void Start ()
		{
			animator = GetComponent<Animator> ();
			aniEvent = GetComponent<DynamicAddEvents> ();
			atkIdleTime = aniEvent.GetAniTime ("atkidle");
//			atkIdleTime =1.1f;
			InvokeRepeating("OnUpdate", 0f, 0.5f);//1秒后调用LaunchProjectile () 函数，之后每5秒调用一次
		}

		void OnUpdate()
		{
			CheckSIdle();
		}

		void CheckSIdle()
		{
			if (!isOpen)
				return;
			
			if (!animator.GetCurrentAnimatorStateInfo (0).IsName ("atkidle"))
				return;
			
			if (animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState") && animator.GetCurrentAnimatorStateInfo(0).IsName ("atkidle")) {
				time -= 0.5f;
				if (time <= 0) { //play atkidle
					if (Random.Range (0, 100) > 50) {
						animator.Play ("sidle", 1);
						time = atkIdleTime * count;
						isSIdle = true;
					} else {
						time = 10f;
					}
				}

			} else {
				if (!animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
					time = 10f;
					isSIdle = false;
				}
				if (!isSIdle) {
					time = 10f;
				} else {
					time = atkIdleTime * count;
				}
			}
		}

		public void SetOpen(bool open)
		{
			isOpen = open;
		}
	}
}

