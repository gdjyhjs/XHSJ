using UnityEngine;
using System.Collections;
using SLua;

namespace Seven
{
	[SLua.CustomLuaClass]
	public class Schedule : MonoBehaviour
	{
		private LuaFunction updateFn;
		private float dt = 0;
		private bool isPuase = false;

		public void StartUpdate (LuaFunction fn, float time)
		{
			updateFn = fn;
			dt = time;
			InvokeRepeating("OnUpdate", dt, dt);//1秒后调用LaunchProjectile () 函数，之后每5秒调用一次
		}

		public void ResetUpdateTime(float time)
		{
			dt = time;
			CancelInvoke ();
			InvokeRepeating("OnUpdate", dt, dt);//1秒后调用LaunchProjectile () 函数，之后每5秒调用一次
		}

		public void StopUpdate()
		{
			CancelInvoke ();
			Destroy (this);
		}

		public void PauseUpdate()
		{
			isPuase = true;
		}

		public void ResumeUpdate()
		{
			isPuase = false;
		}

		void OnUpdate () {
			if (isPuase)
				return;
			
			if (updateFn != null) 
			{
				updateFn.call (dt);
			}
		}  
	}
}

