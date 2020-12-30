using UnityEngine;
using System.Collections;
using SLua;

namespace Seven.Shell
{
	public class Line : MonoBehaviour
	{
		public LuaFunction OnArriveFn;

		public GameObject target;  
		public float speed = 10;
		public Vector3 tpos = Vector3.zero;
		public Vector3 offset = Vector3.zero;

		private bool move = false;
		private bool isMoveTo = false;

		void Start ()  
		{

		}  

		void Update()
		{
			if (move)
			{
				Shoot ();
			}

			if (isMoveTo) 
			{
				UpdateMoveTo ();
			}
		}

		void Shoot ()  
		{  
			if (target == null) 
			{
				Finish ();
				return;
			}

			Vector3 targetPos = target.transform.position + offset;  
			Vector3 pos = transform.position;
				
			//朝向目标  (Z轴朝向目标)  
			this.transform.LookAt (targetPos);

			float currentDist = Vector3.Distance (pos, targetPos); 
			if (currentDist < 0.5f)  
			{  
				Finish (); 
				return;
			}  
			//平移 （朝向Z轴移动）  
			this.transform.Translate (Vector3.forward * Mathf.Min (speed * Time.deltaTime, currentDist));  
		}

		void UpdateMoveTo()
		{
			Vector3 pos = transform.position;

			//朝向目标  (Z轴朝向目标)  
			this.transform.LookAt (tpos);

			float currentDist = Vector3.Distance (pos, tpos); 
			if (currentDist < 0.5f)  
			{  
				gameObject.SetActive (false);
				isMoveTo = false;
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
			move = true;
		}

		public void MoveTo(Vector3 pos)
		{
			tpos = pos;
			isMoveTo = true;
		}
	}
}

