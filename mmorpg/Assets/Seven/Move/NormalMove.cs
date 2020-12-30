using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;

namespace Seven.Move
{
	[SLua.CustomLuaClass]
	public class NormalMove : MonoBehaviour
	{
		public Animator animator;
		public CharacterController charCtr;
		public float speed = 5;
		public bool isJoystickEnable = false;
		private bool isKayboard = true;
		private bool kaydown = false;
		public bool canNotMove = false;//不可移动

		public LuaFunction joystickStartFn; //摇杆开始移动回调函数
		public LuaFunction joystickMoveFn; //摇杆移动回调函数
		public LuaFunction joystickMoveEndFn;//摇杆移动完成回调函数
		public LuaFunction finishMoveFn;
		public LuaFunction aniChangeFn;// 动画改变回调
		public static bool isJoysticMove = false;

		private bool moving = false;//是否移动
		private float gravity = 20;
		private Vector3 dir = Vector3.zero;
		private JoystickController joyCtr;

		private bool isMoveForward = false;//沿着当前朝向走
		private Vector2 moveForwardDir = Vector2.zero;

		private Vector3 targetPos;
		private bool isMoveTo = false;
		private float minDistance = 0.3f;
		private float minDistanceD;
		private List<string> skillName = new List<string>();

		private Transform target;
		private AutoMove autoMove;
		private bool isAutoMove = false;

		// Use this for initialization
		void Awake ()
		{
			isMoveTo = false;
			animator = GetComponent<Animator> ();
			charCtr = GetComponent<CharacterController> ();
			minDistanceD = minDistance * minDistance;
			AddSkill ("EmptyState");
		}
		
		// Update is called once per frame
		void Update ()
		{
			InitJoystick ();

			if (isMoveForward) 
			{
				Move (moveForwardDir.x, moveForwardDir.y);
			}

			if (isMoveTo && moving) 
			{  
				if (target) {
					targetPos = target.position;
				}

				Vector3 pos = transform.position;
				Vector3 dv = targetPos - pos;
				Vector3 lookPos = targetPos;
				lookPos.y = pos.y;

				//朝向目标  (Z轴朝向目标)  
				this.transform.LookAt (lookPos);

				float currentDist = dv.x*dv.x + dv.y*dv.y + dv.z*dv.z;
				if (currentDist <= minDistanceD)  
				{  
					StopMove ();
					if (finishMoveFn != null)
						finishMoveFn.call ();
					return;
				}  

				dv = dv.normalized*speed*Time.deltaTime;
				dv.y = -gravity * Time.deltaTime;
				charCtr.Move(dv);
			}
			if (!isKayboard)
				return;
			if (!isJoystickEnable)
				return;
			float h = Input.GetAxis("Horizontal");
			float v = -Input.GetAxis("Vertical");
			if (Input.anyKeyDown)
			{
				//排除鼠标事件
				if (Mathf.Abs (h) > 0.05f || Mathf.Abs (v) > 0.05f) {
					kaydown = true;
				}
			}
			if (kaydown)
			{
				if (Mathf.Abs(h) > 0.05f || Mathf.Abs(v) > 0.05f) 
				{
					Move (v, h);
				} else
				{
					kaydown = false;
					StopMove ();
				}
			}
		}

		bool IsCanMove()
		{
			bool isCan = false;
			for (int i = 0; i < skillName.Count; i++) {
				if (animator.GetCurrentAnimatorStateInfo (1).IsName (skillName [i])) {
					isCan = true;
					break;
				}
			}
			return isCan;
		}

		public void Move(float x, float z)
		{
			//只有在当前空状态才可以行走
			if (IsCanMove()) 
			{
				StartMove ();

				dir.x = x;
				dir.y = 0;
				dir.z = z;
				dir = dir.normalized;

				transform.LookAt (dir + transform.position);

				dir.y = -gravity * Time.deltaTime;

				dir *= speed * Time.deltaTime;
				charCtr.Move (dir);
			}
		}

		// 停止移动
		public void StopMove()
		{
			moving = false;
			isMoveTo = false;
			target = null;

			if (animator == null)
				return;
			animator.SetBool ("move", false);

			if (aniChangeFn != null)
				aniChangeFn.call (false);
		}

		public void StartMove()
		{
			animator.SetBool ("move", true);
			moving = true;

			if (aniChangeFn != null)
				aniChangeFn.call (true);
		}

		// 是否正在移动
		public bool IsMove()
		{
			return moving;
		}

        // 设置向前移动
		public void SetMoveForward(bool flag)
		{
			isMoveForward = flag;

			if (flag) 
			{
				StartMove ();
				charCtr.radius = 0.1f;
				float w = transform.localEulerAngles.y * Mathf.PI / 180;

				moveForwardDir.x = Mathf.Sin (w);
				moveForwardDir.y = Mathf.Cos (w);
			} else 
			{
				charCtr.radius = 1f;
				StopMove ();
			}
		}

		bool MoveTo(LuaFunction finishCb = null, float distance = 0.3f, string ani = "")
		{
			if (canNotMove)
				return false;

			if (!animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) 
			{
				return false;
			}

			if (animator.GetCurrentAnimatorStateInfo (0).IsName ("sidle")) 
			{
				animator.SetTrigger ("cancel");
			}

			finishMoveFn = finishCb;

			minDistance = distance;
			minDistanceD = distance * distance;

			if (!ani.Equals ("")) {
				animator.Play (ani, 1);
				moving = true;
			} else {
				StartMove ();
			}

			isMoveTo = true;
			return true;
		}

		void OnControllerColliderHit(ControllerColliderHit hit) 
		{
			if (hit.gameObject.tag == "Wall" && !isAutoMove) { //跟随过程中如果碰到墙壁，者自动寻路
				isAutoMove = true;
				if (autoMove == null)
					autoMove = GetComponent<AutoMove> ();
			}
		}

		void OnrriveDestinationCallBack()
		{
			isAutoMove = false;
			if (finishMoveFn != null)
				finishMoveFn.call ();
		}

		/// <summary>
		/// Moves to.
		/// </summary>
		/// <param name="pos">移动目标点.</param>
		/// <param name="finishCb">移动完成回调.</param>
		/// <param name="distance">距离目标点多远停止.</param>
		/// <param name="ani">移动需要播放的动画.</param>
		public bool MoveTo(Vector3 pos, LuaFunction finishCb = null, float distance = 0.3f, string ani = "")
		{
			targetPos = pos;
			if (isAutoMove) {
				autoMove.minDistance = distance;
				autoMove.finishFn = OnrriveDestinationCallBack;
				finishMoveFn = finishCb;
				return autoMove.SetDestination2 (pos);
			} else {
				return MoveTo (finishCb, distance, ani);
			}
		}

		public bool MoveTo(Transform target, LuaFunction finishCb = null, float distance = 0.3f, string ani = "")
		{
			this.target = target;
			return MoveTo (finishCb, distance, ani);
			if (isAutoMove) {
				autoMove.minDistance = distance;
				autoMove.finishFn = OnrriveDestinationCallBack;
				finishMoveFn = finishCb;
				return autoMove.SetDestination2 (target.transform.position);
			} else {
				return MoveTo (finishCb, distance, ani);
			}
		}

		// 初始化摇杆
		void InitJoystick()
		{
			if (isJoystickEnable && joyCtr == null) 
			{
				joyCtr = JoystickController.Instance;
				if (joyCtr) 
				{
					joyCtr.OnJoystickStartFn = this.OnJoystickStart;
					joyCtr.OnJoystickMoveFn = this.OnJoystickMove;
					joyCtr.OnJoystickMoveEndFn = this.OnJoystickMoveEnd;
				}
			}
		}

		public void EnableJoysick(bool enable)
		{
			isJoystickEnable = enable;
			joyCtr = JoystickController.Instance;
			if (joyCtr) {
				joyCtr.joy.OnPointerUp (null);
				joyCtr.joy.enabled = enable;
			}
			if (isJoystickEnable) {
				if (joyCtr) {
					joyCtr.OnJoystickStartFn = this.OnJoystickStart;
					joyCtr.OnJoystickMoveFn = this.OnJoystickMove;
					joyCtr.OnJoystickMoveEndFn = this.OnJoystickMoveEnd;
				}
			}
		}

		// 摇杆开始回调函数
		public void OnJoystickStart()
		{
			isJoysticMove = true;
			if (!isJoystickEnable)
				return;

			if (animator.GetCurrentAnimatorStateInfo (0).IsName ("sidle")) 
			{
				animator.SetTrigger ("cancel");
			}

			if (joystickStartFn != null)
				joystickStartFn.call ();
		}

		// 摇杆移动回调函数
		public void OnJoystickMove(Vector2 direction)
		{
			if (!isJoystickEnable || animator == null || canNotMove)
				return;

			direction = direction.normalized;
			float sin45 = 0.707f;
			float cos45 = 0.707f;
			float x = direction.x * cos45 + direction.y * sin45;
			float y = direction.x * sin45 - direction.y * cos45;
			Move (y, x);
			isKayboard = false;
			if (joystickMoveFn != null)
				joystickMoveFn.call ();
		}

		// 摇杆停止回调函数
		public void OnJoystickMoveEnd()
		{
			isJoysticMove = false;
			if (!isJoystickEnable)
				return;

			StopMove ();
			isKayboard = true;
			if (joystickMoveEndFn != null)
				joystickMoveEndFn.call ();
		}

		public void AddSkill(string name)
		{
			skillName.Add (name);
		}

		public void SetCharCtrRadiusAndHeight(float radius, float height)
		{
			charCtr.radius = radius;
			charCtr.height = height;
			Vector3 center = charCtr.center;
			charCtr.center = new Vector3(center.x, height/2, center.z);
		}
	}
}
