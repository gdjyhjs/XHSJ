using UnityEngine;
using System;
using System.Collections.Generic;
using SLua;
using Hugula;

namespace Seven
{
	[SLua.CustomLuaClass]
	public class MonsterMoveCtr : MonoBehaviour
	{
		public CharacterController charCtr;
		public Animator animator;

		public float speed = 5;

		private bool isMove = false;//是否移动
		private float gravity = 20;
		private Vector3 dir = Vector3.zero;
		private bool isMoveForward = false;//沿着当前朝向走
		private Vector2 moveForwardDir = Vector2.zero;

		void Awake()
		{
			charCtr = GetComponent<CharacterController> ();
			animator = GetComponent<Animator> ();
		}

		void Update()
		{
			if (isMoveForward) {
				Move (moveForwardDir.x, moveForwardDir.y);
				return;
			} else {
				Idle ();
			}
		}

		void Move(float x, float z)
		{
			x = -x;

			//只有在当前空状态才可以行走
			if (animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
				if (!isMove) {
					isMove = true;
					animator.SetBool ("move", true);
				} 

				dir.x = x;
				dir.y = 0;
				dir.z = z;

				transform.LookAt (dir + transform.position);

				dir.y = -gravity * Time.deltaTime;

				dir *= speed * Time.deltaTime;
				charCtr.Move (dir);
			}
		}

		void Idle()
		{
			if (isMove) {
				isMove = false;
				animator.SetBool ("move", false);
			}
		}

		public void SetMoveForward(bool flag)
		{
			float w = transform.eulerAngles.y * Mathf.PI / 180;
			isMoveForward = flag;
			moveForwardDir.x = -Mathf.Sin (w);
			moveForwardDir.y = Mathf.Cos (w);
		}
	}
}

