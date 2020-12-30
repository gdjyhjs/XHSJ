/**
 * 跟随移动
*/
using UnityEngine;
using System.Collections;
using SLua;

namespace Seven.Move
{
	[SLua.CustomLuaClass]
	public class FollowMove : MonoBehaviour
	{
		public float maxDistance = 5f;//移动跟随距离
		public float minDistance = 1f;//停止移动距离
		public float atkFollowDistance = 15;//战斗跟随距离
		public float speed = 5f;//跟随速度

		public LuaFunction starMoveFn;//开始移动回调
		public LuaFunction atkBackFn; //战斗中瞬间回到主角旁边回调
		public LuaFunction stopMoveFn; //停止移动回调
		private GameObject target;//跟随目标

		private bool isFollow = true;

		private NormalMove targetNormalMove;
		private AutoMove targetAutoMove;
		private CharacterController charCtr;
		private AutoMove autoMove;
		private FollowMove followMove;

		private Animator animator;

		private bool isMoving = false;
		private float maxDistanceD;
		private float minDistanceD;
		private float atkFollowDistanceD = 225;
		private bool isAtk = false; //是否处于战斗状态
		private bool isAutoMove = false;
		private bool isHero = false;// 是否是否武将
		private bool isTargetFollow = false;

		//设置跟随距离
		public void SetFollowDistance(float dis)
		{
			maxDistance = dis;
			maxDistanceD = dis * dis;
		}

		//设置攻击跟随距离
		public void SetAtkFollowDistance(float dis)
		{
			atkFollowDistance = dis;
			atkFollowDistanceD = dis * dis;
		}

		//设置停止距离
		public void SetStopDistance(float dis)
		{
			minDistance = dis;
			minDistanceD = dis * dis;
		}

		//设置攻击状态
		public void SetAtk(bool atk)
		{
			isAtk = atk;
		}

		//设置跟随移动
		public void SetFollow(bool follow)
		{
			isFollow = follow;
			this.enabled = follow;
		}

		public bool IsFollow()
		{
			return isFollow;
		}

		//设置跟随目标
		public void SetTarget(GameObject target)
		{
			this.target = target;
			if (target != null) {
				targetNormalMove = target.GetComponent<NormalMove> ();
				targetAutoMove = target.GetComponent<AutoMove> ();
				followMove = target.GetComponent<FollowMove> ();
			} else {
				targetNormalMove = null;
				targetAutoMove = null;
				followMove = null;
			}
		}

		public bool IsMove()
		{
			return isMoving;
		}

		public void SetHero(bool hero)
		{
			isHero = hero;
		}

		//设置跟随目标也是跟随
		public void SetTargetFollowMove(bool flag)
		{
			isTargetFollow = flag;
			if (flag) {
				followMove = target.GetComponent<FollowMove> ();
			} else {
				followMove = null;
			}
		}

		// Use this for initialization
		void Start ()
		{
			animator = GetComponent<Animator> ();
			maxDistanceD = maxDistance*maxDistance;
			charCtr = GetComponent<CharacterController> ();
			autoMove = GetComponent<AutoMove> ();

			minDistanceD = minDistance * minDistance;
		}
		
		// Update is called once per frame
		void Update ()
		{
			if (!isFollow || target == null || isAutoMove)
				return;
			
			if (!targetNormalMove.IsMove () && !targetAutoMove.IsAutoMove () && ((isTargetFollow && followMove && !followMove.isMoving) || (!isTargetFollow))) 
			{
				StopMove();
				return;
			}

			UpdateMove();
		}

		private void UpdateMove()
		{
			Vector3 targetPos = target.transform.position;
			Vector3 pos = transform.position;

			Vector3 dv = targetPos - pos;
			float currentDist = dv.x*dv.x + dv.y*dv.y + dv.z*dv.z;
			float maxDis = maxDistanceD;
//			if (isAtk){
//				maxDis = atkFollowDistanceD;
//			}

			if (currentDist < maxDis) {
				if (isMoving) {
					if (currentDist <= minDistanceD) {
						StopMove ();
						return;
					}
				} else {
					StopMove ();
					return;
				}
			} else if (currentDist > atkFollowDistanceD) {//超过最大跟随距离，瞬间回到人物身边
				if (atkBackFn != null) {
					atkBackFn.call ();
				}
				if (!animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
					animator.SetTrigger ("cancel");
				}
				this.transform.LookAt (targetPos);

				this.transform.position = targetPos+target.transform.TransformDirection (Vector3.right * minDistance);
//				StopMove ();
				return;
			}

			//朝向目标  (Z轴朝向目标)  
			Quaternion rotate = Quaternion.LookRotation(dv);
			transform.rotation = Quaternion.Slerp(transform.rotation, rotate, Time.smoothDeltaTime * 5);

			StartMove ();

			//废弃
//			float dis = (speed-1) * Time.deltaTime;
//			if (dis * dis > currentDist)
//				dis = Mathf.Sqrt(currentDist);
//			//平移 （朝向Z轴移动）  
//			this.transform.Translate(Vector3.forward * dis);

			if (dv.sqrMagnitude > 0.01f) {//平滑处理
				dv = dv.normalized*speed*Time.smoothDeltaTime;
				dv.y = -20 * Time.smoothDeltaTime;
				charCtr.Move (dv);
			}
		}

		// 停止移动
		void StopMove()
		{
			if (isMoving) {
				animator.SetBool ("move", false);
				isMoving = false;

				if (stopMoveFn != null)
					stopMoveFn.call ();

				Vector3 pos = target.transform.position;
				if (isHero) {
					pos += target.transform.TransformDirection (Vector3.right * 3);
					autoMove.minDistance = 0.3f;
					autoMove.finishFn = delegate {
						transform.eulerAngles = target.transform.eulerAngles;
					};
				} else {
					autoMove.minDistance = maxDistance;
					autoMove.finishFn = null;
				}
				autoMove.SetDestination2 (pos);
			}
		}

		void StartMove()
		{
			if (!isMoving)
			{
				autoMove.StopMove (false);
				animator.SetBool("move", true);
				isMoving = true;
				if (starMoveFn != null)
					starMoveFn.call();
			}
		}

		void OnControllerColliderHit(ControllerColliderHit hit) 
		{
			if (hit.gameObject.tag == "Wall" && !isAutoMove) { //跟随过程中如果碰到墙壁，者自动寻路
				isAutoMove = true;
				autoMove.minDistance = 1;
				autoMove.finishFn = OnrriveDestinationCallBack;
				autoMove.SetDestination2 (target.transform.position);
			}
		}

		void OnrriveDestinationCallBack()
		{
			isAutoMove = false;
			isMoving = false;
		}
	}
}
