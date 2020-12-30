using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using SLua;
using UnityEngine.EventSystems;
using Seven.Touch;
using UnityEngine.AI;

namespace Seven.Move
{
	[SLua.CustomLuaClass]
	public class AutoMove : MonoBehaviour
	{
		public float speed = 5;// 移动速度
		public float minDistance = 1; // 距离目的地的最短距离
		public bool canNotMove = false;
		private bool enableTouchMove = false;// 点击移动

		public LuaFunction pathCallbackFn;//路径回调函数
		public LuaFunction arriveDestinationFn; //到达目的地回调函数
		public LuaFunction aniChangeFn;// 动画改变回调
		public LuaFunction touchMoveFn;//鼠标点击移动

		[SLua.DoNotToLua]
		public System.Action finishFn;

		//寻路组件
		private UnityEngine.AI.NavMeshAgent agent;
		private Animator animator;
		private UnityEngine.AI.NavMeshPath path;
		private CharacterController charCtr;

		private bool moving = false;
		private bool isTouchMove = false;//是否是鼠标点击移动
		private bool isTaskMove = false;

		private Vector3 invalidPos = new Vector3(-1000,-1000,-1000);
		private Vector3 tempDestination = new Vector3(-1000,-1000,-1000);

		private float touchTime = 0;//点击时间

		private bool DEBUG = false;//开启路线显示
		private LineRenderer line;
		private static LineRenderer line2;
		private static GameObject obj = null;

		private int index = 1;

		// Use this for initialization
		void Awake ()
		{
			agent = GetComponent<UnityEngine.AI.NavMeshAgent> ();
			animator = GetComponent<Animator> ();
			path = new UnityEngine.AI.NavMeshPath();
			charCtr = GetComponent<CharacterController> ();

			if (obj == null) {
				obj = new GameObject ("坐标装换");
			}

			if (DEBUG) {
				GameObject o = new GameObject ("画线");
				line = o.AddComponent<LineRenderer> ();
				o = new GameObject ("画线1");
				line2 = o.AddComponent<LineRenderer> ();
			}
		}
		
		// Update is called once per frame
		void Update ()
		{
			//自动寻路
			if (!isTaskMove && moving && agent.enabled) {
				if (!agent.pathPending && agent.remainingDistance <= minDistance) {
					StopMove ();
					if (arriveDestinationFn != null && !isTouchMove)
						arriveDestinationFn.call ();
					if (finishFn != null)
						finishFn ();
					
					isTouchMove = false;
					
				}
			}

			if (tempDestination.x != invalidPos.x) {
				if (animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
					SetDestination3 (tempDestination, false);
					tempDestination = invalidPos;
				}
			}

			UpdateOffetMove ();
		}

		void TouchMove()
		{
			if (!enableTouchMove || canNotMove)
				return;
			if (!transform.parent.name.Equals ("Player")) {
				return;
			}

			Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
			//发射射线
			RaycastHit hitInfo = new RaycastHit();
			if (Physics.Raycast(ray, out hitInfo, 300, 1<<12))//自点击floor层
			{
				ray = Camera.main.ScreenPointToRay(Input.mousePosition);
				RaycastHit rayhit;
				if (Physics.Raycast(ray, out rayhit))
				{
					if (rayhit.transform.gameObject.layer == 8) {//点击到character层
						return;
					}
				}

				if (!animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
					if (touchMoveFn != null)
						touchMoveFn.call (hitInfo.point);
					return;
				}

				//如果真正自动寻路，一秒内点击2次，切换到新的目标点
				if (agent.enabled && !isTouchMove) {
					if (touchTime == 0) {
						touchTime = Time.realtimeSinceStartup;
						return;
					} else if (Time.realtimeSinceStartup - touchTime > 1.5) {
						touchTime = Time.realtimeSinceStartup;
						return;
					}
				}
				touchTime = 0;

				minDistance = 0.3f;
				if (SetDestination2 (hitInfo.point)) {
					if (touchMoveFn != null)
						touchMoveFn.call (hitInfo.point);
					isTouchMove = true;
				}
			}
		}

		// 更新偏移路线移动
		void UpdateOffetMove()
		{
			if (!isTaskMove || !moving || isTouchMove || canNotMove)
				return;

			float dis = 0.5f;
			if (index >= path.corners.Length-1) {
				dis = minDistance;
			}

			if (Vector3.Distance(ignoreY(path.corners[index]), ignoreY(transform.position)) <= dis) {
				index++;
				if (index == path.corners.Length) {
					StopMove ();
					if (arriveDestinationFn != null && !isTouchMove)
						arriveDestinationFn.call ();
					return;
				}
			} 
			//朝向目标  (Z轴朝向目标)  
			Vector3 dv = ignoreY(path.corners[index]) - ignoreY(transform.position);
			if (dv.sqrMagnitude > 0.1f) {//平滑处理
				Quaternion rotate = Quaternion.LookRotation(dv);
				transform.rotation = Quaternion.Slerp(transform.rotation, rotate, Time.smoothDeltaTime * 5);

				dv = dv.normalized * speed * Time.smoothDeltaTime;
				dv.y = -20*Time.smoothDeltaTime;
				charCtr.Move (dv);
			}

		}

		//这个函数用来取消向量的Y轴影响，比如主角的高度与点之间可能有一段距离，我们要忽略这段距离
		Vector3 ignoreY(Vector3 v3)
		{
			return new Vector3(v3.x, 0, v3.z);
		}

		bool RayHit(Vector3 pos, float dis, Vector3 dir)
		{
			RaycastHit hit;
			Ray ray = new Ray (pos, dir);
			if (Physics.Raycast (ray, out hit, dis, 1 << 13)) {//Wall layer
				return true;
			}
			return false;
		}

		//设置移动的目的点
		public bool SetDestination4(Vector3 pos, bool force, bool isPath)
		{
			if (canNotMove)
				return false;
			
			if (!animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
				if (force) {
					tempDestination = pos;
				}

				return false;
			}
			tempDestination = invalidPos;

			if (animator.GetCurrentAnimatorStateInfo (0).IsName ("sidle")) {
				animator.SetTrigger ("cancel");
			}

			//判断是否小于最小移动距离，小于就不移动
			if (Vector3.Distance (transform.position, pos) <= minDistance)
			{
				StopMove ();
				if (arriveDestinationFn != null)
					arriveDestinationFn.call ();
				return true;
			}

			agent.enabled = true;
			if (!agent.isOnNavMesh) {
				tempDestination = pos;
				return false;
			}

			agent.CalculatePath (pos, path);

			if (DEBUG) {
				line.SetVertexCount (path.corners.Length);
				line.SetPositions (path.corners);
			}

			float offset = 3f;
			for (int i = 1; i < path.corners.Length-1; i++) {
				Vector3 p = path.corners [i];
				obj.transform.position = p;
				obj.transform.LookAt (path.corners [i + 1]);

				bool dir_left = true;
				bool check = true;
				//判断应该向左边还是右边偏移
				Vector3 v = obj.transform.TransformDirection (Vector3.left);
				Vector3 r = p + v+new Vector3(0,250,0);

				if (RayHit(r,300,Vector3.down)) {//Wall layer
					p += obj.transform.TransformDirection (Vector3.right)*offset;
					r = p +new Vector3(0,250,0);
					if (RayHit(r,300,Vector3.down)) {//Wall layer
						p = path.corners [i];
						check = false;
					}
					dir_left = false;

				} else {
					p += v * offset;
					r = p +new Vector3(0,250,0);
					if (RayHit(r,300,Vector3.down)) {//Wall layer
						p = path.corners [i];
						check = false;
					}
				}

				if (check && Vector3.Distance (path.corners [i], path.corners [i + 1]) > 1f) {
					//判断得出来的两个点联系有没有穿过墙，有则更换点

					if (RayHit(p,Vector3.Distance (p, path.corners [i + 1]),path.corners [i + 1] - p)) {//Wall layer
						if (dir_left) {
							v = obj.transform.TransformDirection (Vector3.right);
							r = p + v + new Vector3 (0, 200, 0);

							if (!RayHit(r,300,Vector3.down)) {//Wall layer
								p = path.corners [i] + v * offset;

								if (RayHit(p,Vector3.Distance (p, path.corners [i + 1]),path.corners [i + 1] - p)) {//Wall layer
									p = path.corners [i];
								}
							} else {
								p = path.corners [i];
							}
						} else {
							p = path.corners [i];
						}
					}
				}
				path.corners [i] = p;
			}

			if (DEBUG) {
				line2.SetVertexCount (path.corners.Length);
				line2.SetPositions (path.corners);
			}

			if (isPath) 
			{
				Vector3[] pathList = new Vector3[path.corners.Length];
				for (int i = 0; i < path.corners.Length; i++) {
					pathList [i] = path.corners [i];
				}

				if (pathCallbackFn != null)
					pathCallbackFn.call (pathList);
			}
			StartMove ();
			agent.enabled = false;
			index = 1;
			isTaskMove = true;
			return true;
		}

		//设置移动的目的点
		public bool SetDestination(Vector3 pos, bool force, bool isPath)
		{
			if (canNotMove)
				return false;

			if (!animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
				if (force) {
					tempDestination = pos;
				}

				return false;
			}

			tempDestination = invalidPos;

			if (animator.GetCurrentAnimatorStateInfo (0).IsName ("sidle")) {
				animator.SetTrigger ("cancel");
			}

			//判断是否小于最小移动距离，小于就不移动
			if (Vector3.Distance (transform.position, pos) <= minDistance)
			{
				StopMove ();
				if (arriveDestinationFn != null)
					arriveDestinationFn.call ();
				return true;
			}

			agent.enabled = true;

			if (!agent.isOnNavMesh) {
				tempDestination = pos;
				return false;
			}

			if(isPath)
				agent.CalculatePath (pos, path);

			if (agent.SetDestination (pos)) {
				StartMove ();
			} else {
				agent.enabled = false;
				return false;
			}

			if (isPath) {
				Vector3[] pathList = new Vector3[path.corners.Length];
				for (int i = 0; i < path.corners.Length; i++) {
					pathList [i] = path.corners [i];
				}

				if (pathCallbackFn != null)
					pathCallbackFn.call (pathList);
			}

			return true;
		}

		//设置移动的目的点
		public bool SetDestination3(Vector3 pos, bool force)
		{
			if (canNotMove)
				return false;

			if (!animator.GetCurrentAnimatorStateInfo (1).IsName ("EmptyState")) {
				if (force) {
					tempDestination = pos;
				}

				return false;
			}
			tempDestination = invalidPos;

			if (animator.GetCurrentAnimatorStateInfo (0).IsName ("sidle")) {
				animator.SetTrigger ("cancel");
			}

			//判断是否小于最小移动距离，小于就不移动
			if (Vector3.Distance (transform.position, pos) <= minDistance)
			{
				StopMove ();
				if (arriveDestinationFn != null)
					arriveDestinationFn.call ();
				return true;
			}

			agent.enabled = true;

			if (!agent.isOnNavMesh) {
				tempDestination = pos;
				return false;
			}

			if (agent.SetDestination (pos)) {
				StartMove ();
			} else {
				agent.enabled = false;
				return false;
			}
			return true;
		}

		//设置移动的目的点
		[SLua.DoNotToLua]
		public bool SetDestination2(Vector3 pos)
		{
			if (canNotMove) 
			{
				return false;
			}

			//判断是否小于最小移动距离，小于就不移动
			if (Vector3.Distance (transform.position, pos) <= minDistance)
			{
				StopMove ();
				return true;
			}
				
			if (animator.GetCurrentAnimatorStateInfo (0).IsName ("sidle")) {
				animator.SetTrigger ("cancel");
			}

			agent.enabled = true;
			if (!agent.isOnNavMesh) {
				tempDestination = pos;
				return false;
			}

			if (agent.SetDestination (pos)) {
				StartMove ();
				return true;
			}
			agent.enabled = false;
			return false;
		}

		//停止自动寻路
		public void StopMove(bool stopAni = true) 
		{
			moving = false;
			isTaskMove = false;
			index = 1;
			if (agent == null)
				return;
			
			if (agent.enabled) 
			{
				agent.isStopped = true;
				agent.enabled = false;
			}

			if (stopAni) {
				animator.SetBool ("move", false);
			}

			if (aniChangeFn != null)
				aniChangeFn.call (false);
		}

		public void StartMove()
		{
			index = 1;
			agent.enabled = true;
			agent.speed = speed;
			moving = true;
			animator.Play ("walk", 0);
			animator.SetBool ("move", true);

			if (aniChangeFn != null)
				aniChangeFn.call (true);
		}

		//是否正在自动寻路
		public bool IsAutoMove()
		{
			return moving;
		}

		public bool IsTouchMove()
		{
			return isTouchMove;
		}

		public void EnableTouchMove(bool enable)
		{
			this.enableTouchMove = enable;
			if (enable) {
				FingerTouchController.Instance ().OnTouchFn = TouchMove;
			}
		}
	}

}
