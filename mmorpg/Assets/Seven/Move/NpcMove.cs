using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using SLua;

namespace Seven.Move
{
	[SLua.CustomLuaClass]
	public class NpcMove : MonoBehaviour {
		private Animator animator;
		private Vector3 targetPos;
		private bool isMoving = false;
		private bool isMoveTo = false;
		public float speed = 3f;
		public LuaFunction finishMoveFn;
		// Use this for initialization
		void Start () {
			animator = GetComponent<Animator> ();
		}
	
		// Update is called once per frame
		void Update () {
			if (targetPos == null)
				return;
			if(isMoveTo){
				UpdateMove();
			}
		}
		/// <summary>
		/// Moves to.
		/// </summary>
		/// <param name="pos">移动目标点.</param>
		/// <param name="finishCb">移动完成回调.</param>
		public void MoveTo(Vector3 pos, LuaFunction finishCb = null)
		{
			targetPos = pos;
			finishMoveFn = finishCb;
			StartMove();
			// return MoveTo (finishCb, distance, ani);
		}

		private void UpdateMove()
		{
			Vector3 pos = transform.position;
			Vector3 dv = targetPos - pos;
			float currentDist = dv.x*dv.x + dv.y*dv.y + dv.z*dv.z; 
			if (currentDist <= 0.3f*0.3f)
			{  
				StopMove();
				if (finishMoveFn != null)
					finishMoveFn.call ();
				return;
			}  

			//朝向目标  (Z轴朝向目标)  
			this.transform.LookAt (targetPos);
			animator.SetBool ("move", true);
			if (!isMoving) 
			{
				isMoving = true;
				// if (starMoveFn != null)
				// 	starMoveFn.call ();
			}
			float dis = speed * Time.deltaTime;
			if (dis * dis * dis > currentDist)
				dis = Mathf.Sqrt (currentDist);
				//平移 （朝向Z轴移动）  
			this.transform.Translate (Vector3.forward * dis);  
			}

			public void StopMove()
			{
				animator.SetBool ("move", false);
				isMoveTo = false;
				isMoving = false;
			}
			public void StartMove()
			{
				// animator.SetBool ("move", true);
				isMoveTo = true;
				isMoving = true;
			}
	}
}
