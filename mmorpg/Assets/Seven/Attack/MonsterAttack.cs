using UnityEngine;
using System.Collections;

namespace Seven.Attack
{
	[SLua.CustomLuaClass]
	public class MonsterAttack : MonoBehaviour
	{
		private Animator animator;
		private CharacterController charCtr;
		private bool moving = false;
		public int speed = 5;
		private Vector3 targetPos;
		private float errorTime = 1f; //容错时间

		// Use this for initialization
		void Start ()
		{
			animator = GetComponent<Animator> ();
			charCtr = GetComponent<CharacterController> ();
		}

		void Update()
		{
			UpdateMove ();
		}

		//角色控制器组件在与具有Collider组件对象之间的碰撞
		void OnControllerColliderHit(ControllerColliderHit hit)
		{
			//得到接收碰撞名称
			GameObject hitObject = hit.collider.gameObject;
			if (hitObject.tag == "Wall") {
				StopMove ();
			}
		}

		public void StopMove()
		{
			moving = false;
			errorTime = 1f;
		}

		void UpdateMove()
		{
			if (!moving)
				return;

			Vector3 pos = transform.position;
			Vector3 dv = targetPos - pos;

			Vector3 v = dv.normalized*speed*Time.deltaTime;
			v.y = -20 * Time.deltaTime;
			charCtr.Move(v);

			float currentDist = dv.x*dv.x + dv.y*dv.y + dv.z*dv.z;
			float moveDist = v.x*v.x + v.y*v.y + v.z*v.z;

			errorTime -= Time.deltaTime;
			if (currentDist <= 0.05 || errorTime <= 0 || moveDist > currentDist)  
			{  
				StopMove ();
				return;
			} 
		}

		public void PlayAttack(string cmd)
		{
			AnimatorStateInfo stateInfo = animator.GetCurrentAnimatorStateInfo (1);
			if (cmd.Equals ("atk")) {
				if (stateInfo.IsName ("EmptyState")) {
					animator.Play ("atk", 1);
				}
			} else {
				stateInfo = animator.GetCurrentAnimatorStateInfo (1);
				if (stateInfo.IsName ("EmptyState") || stateInfo.IsName ("atk")) {
					animator.Play (cmd, 1);
				}
			}
		}

		public bool IsMove()
		{
			return moving;
		}

		public void AtkMove(Vector3 dir)
		{
			targetPos = transform.position + dir;
			errorTime = 1f;
			targetPos = PublicFun.GetNavMeshPos (targetPos.x, targetPos.z, 0);
			if (targetPos.x == -1 && targetPos.y == -1 && targetPos.z == -1) {
				moving = false;
			} else {
				moving = true;
			}
		}
	}
}

