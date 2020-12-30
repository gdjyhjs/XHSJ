using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;

namespace Seven.Attack
{
	[SLua.CustomLuaClass]
	public class PlayerAttack : MonoBehaviour
	{
		private Animator animator;
		private AnimatorStateInfo stateInfo;
		private CharacterController charCtr;
		private DynamicAddEvents eventMgr;

		private int clickCount = 0;
		private Vector3 targetPos;

		private float time1 = 0f;
		private float time2 = 0f;
		private float time3 = 0f;

		private bool moving = false;
		private float errorTime = 1f; //容错时间
		private float delayTime = 0;

		public float speed = 5;
		public float exitTime1 = 0.68f; //普通攻击1到攻击2的时间
		public float exitTime2 = 0.38f; //普通攻击2到攻击3的时间
		public float exitTime3 = 0.9f; //普通攻击3到攻击1的时间
		public float connectTime = 2f;  //连接时间
		public Vector3 moveVec = Vector3.zero;//攻击向前移动的世界坐标向量

		private Dictionary<string, float> distanceList = new Dictionary<string, float>();//攻击移动距离
		private Dictionary<string, float> timeList = new Dictionary<string, float>(); //攻击移动延迟时间
		private Dictionary<string, float> speedList = new Dictionary<string, float>(); //攻击移动速度

		private Dictionary<string, float> aniTimeList = new Dictionary<string, float>();// 动画时长

		// Use this for initialization
		void Start ()
		{
			animator = GetComponent<Animator> ();
			charCtr = GetComponent<CharacterController> ();
			eventMgr = GetComponent<DynamicAddEvents> ();
			InitAniTime ();
		}

		void InitAniTime()
		{
			if (eventMgr) {
				aniTimeList.Add ("atk3", eventMgr.GetAniTime ("atk3"));
			}
//			aniTimeList.Add ("skill1", eventMgr.GetAniTime ("skill1"));
//			aniTimeList.Add ("skill2", eventMgr.GetAniTime ("skill2"));
//			aniTimeList.Add ("skill3", eventMgr.GetAniTime ("skill3"));
//			aniTimeList.Add ("skill4", eventMgr.GetAniTime ("skill4"));
//			aniTimeList.Add ("skill5", eventMgr.GetAniTime ("skill5"));
		}

		// Update is called once per frame
		void Update ()
		{
			UpdateAniState ();
			CaculateTime();
			UpdateMove ();
		}

		void UpdateAniState()
		{
			stateInfo = animator.GetCurrentAnimatorStateInfo (1);
			if (stateInfo.IsName("atk1") && (stateInfo.normalizedTime >= exitTime1) && (clickCount == 2))  //普通攻击1切换到普通攻击2
			{  
				animator.Play("atk2", 1);
				clickCount = 0;
				time2 = connectTime;
				time1 = 0f;
				time3 = 0f;
			}
			else if (stateInfo.IsName("atk2") && (stateInfo.normalizedTime >= exitTime2) && (clickCount == 3))  //普通攻击2切换到普通攻击3
			{  
				animator.Play("atk3", 1);
				clickCount = 0;
				time1 = 0f;
				time2 = 0f;
				time3 = aniTimeList ["atk3"];
			}
			else if (stateInfo.IsName("atk3") && (stateInfo.normalizedTime >= exitTime3) && (clickCount == 1))  //普通攻击3切换到普通攻击1
			{  
				animator.Play("atk1", 1);
				clickCount = 0;
				time1 = 0f;
				time2 = 0f;
				time3 = 0f;
			}

		}

		void CallBack(string arg)
		{
			AtkMove (arg);
		}

		void AtkMove(string cmd)
		{
			StopMove ();

			float atkMoveDistance = GetAtkMoveDistance(cmd);
			delayTime = GetAtkMoveTime (cmd);
			speed = GetAtkMoveSpeed (cmd);

			if (atkMoveDistance == -1f)
				return;
			
			targetPos = transform.position;
			moveVec = transform.TransformDirection(Vector3.forward*atkMoveDistance);
			targetPos += moveVec;
			errorTime = 1f;
			targetPos = PublicFun.GetNavMeshPos (targetPos.x, targetPos.z, 0);
			if (targetPos.x == -1 && targetPos.y == -1 && targetPos.z == -1) {
				moving = false;
			} else {
				if (delayTime == 0) {
					moving = true;
				}
			}
		}

		public void StopMove()
		{
			moving = false;
			errorTime = 1f;
			delayTime = 0f;
		}

		void CaculateTime()
		{
			if (time1 > 0) 
			{
				time1 -= Time.deltaTime;
			}
			if (time2 > 0) 
			{
				time2 -= Time.deltaTime;
			}
			if (time3 > 0) 
			{
				time3 -= Time.deltaTime;
			}
			if (delayTime > 0) {
				delayTime -= Time.deltaTime;
				if (delayTime <= 0) {
					moving = true;
				}
			}
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

		void UpdateMove()
		{
			if (!moving)
				return;
			
			Vector3 pos = transform.position;
			Vector3 dv = targetPos - pos;

			float currentDist = dv.x*dv.x + dv.y*dv.y + dv.z*dv.z;
			errorTime -= Time.deltaTime;
			if (currentDist <= 0.05 || errorTime <= 0)  
			{  
				StopMove ();
				return;
			}

			dv = dv.normalized*speed*Time.deltaTime;
			float moveDis = dv.x*dv.x + dv.y*dv.y + dv.z*dv.z;
			if (currentDist < moveDis)  
			{  
				StopMove ();
				return;
			}


			dv.y = -20 * Time.deltaTime;
			charCtr.Move(dv);
		}

		public void PlayAttack(string cmd)
		{
			if (cmd.Equals ("atk")) {
				NormalAtk ();
			} else {
				stateInfo = animator.GetCurrentAnimatorStateInfo (1);
				if (stateInfo.IsName ("EmptyState") || stateInfo.IsName ("forward") || stateInfo.IsName ("atk1") || stateInfo.IsName ("atk2") || stateInfo.IsName ("atk3")) {//普攻是可以被其他技能立即打断
					clickCount = 0;
					animator.Play (cmd, 1);
				}
			}
		}

		void NormalAtk()
		{
			stateInfo = animator.GetCurrentAnimatorStateInfo (1);

			if (time1 > 0) 
			{
				if (stateInfo.IsName ("EmptyState")) {
					animator.Play("atk2", 1);
					time2 = connectTime;
					time1 = 0f;
					time3 = 0f;
					clickCount = 0;
				} else {

					clickCount = 2;
				}
			}
			else if (time2 > 0) 
			{
				if (stateInfo.IsName ("EmptyState")) {
					animator.Play("atk3", 1);
					time3 = aniTimeList ["atk3"];
					time2 = 0f;
					time1 = 0f;
					clickCount = 0;
				} else {
					clickCount = 3;
				}
			}
			else if(time3 > 0)
			{
				clickCount = 1;
			}
			else
			{
				if (stateInfo.IsName ("EmptyState")) {
					animator.Play ("atk1", 1);
					time1 = connectTime;
				}
			}
		}

		public bool IsMove()
		{
			return moving;
		}

		float GetAtkMoveTime(string key)
		{
			if (timeList.ContainsKey (key)) 
			{
				return timeList[key];
			}
			return -1f;
		}

		float GetAtkMoveDistance(string key)
		{
			if (distanceList.ContainsKey (key)) 
			{
				return distanceList[key];
			}
			return -1f;
		}

		float GetAtkMoveSpeed(string key)
		{
			if (speedList.ContainsKey (key)) 
			{
				return speedList[key];
			}
			return -1f;
		}

		public void AddAtkMoveTime(string key, float time)
		{
			if (!timeList.ContainsKey (key)) 
			{
				timeList.Add (key, time);
			}
		}

		public void AddAtkMoveDistance(string key, float dis)
		{
			if (!distanceList.ContainsKey (key)) 
			{
				distanceList.Add (key, dis);
			}
		}

		public void AddAtkMoveSpeed(string key, float speed)
		{
			if (!speedList.ContainsKey (key)) 
			{
				speedList.Add (key, speed);
			}
		}

		// 清除所有接下来的攻击动作
		public void ClearAllAtkPlay()
		{
			clickCount = 0;
		}
	}
}

