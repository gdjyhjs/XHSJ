using UnityEngine;
using System.Collections;
using SLua;

namespace Seven.Shell
{
	[SLua.CustomLuaClass]
	public class Radar : MonoBehaviour
	{
		public LuaFunction OnArriveFn;

		public GameObject target;  
		public float speed = 10;  
		public Vector3 offset = Vector3.zero;

		private float distanceToTarget;  
		private bool move = true;

		void Start ()  
		{  
			  
		}  

		void Update()
		{
			if (move)
			{
				Shoot ();
			}
		}

		void Shoot ()  
		{  
			if (target == null) 
			{
				Finish ();
				return;
			}

			Vector3 targetPos = target.transform.position+offset;  
			Vector3 pos = transform.position;

			//朝向目标  (Z轴朝向目标)  
			this.transform.LookAt (targetPos);  
			//根据距离衰减 角度  
			float angle = Mathf.Min (1, Vector3.Distance (pos, targetPos) / distanceToTarget) * 45;  
			//旋转对应的角度（线性插值一定角度，然后每帧绕X轴旋转）  
			this.transform.rotation = this.transform.rotation * Quaternion.Euler (Mathf.Clamp (-42, -angle, 42), 0, 0);  
			//当前距离目标点  
			float currentDist = Vector3.Distance (pos, targetPos); 
			if (currentDist < 2f)  
			{  
				Finish (); 
				return;
			}  
			//平移 （朝向Z轴移动）  
			this.transform.Translate (Vector3.forward * Mathf.Min (speed * Time.deltaTime, currentDist));  
		}

		void Finish()
		{
			if (OnArriveFn != null)
				OnArriveFn.call ();
			
			gameObject.SetActive (false);
			move = false;  
		}

		public void Play()
		{
			distanceToTarget = Vector3.Distance (this.transform.position, target.transform.position);  
			move = true;
		}
	}
}

