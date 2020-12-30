// 相机震动效果  
using UnityEngine;
using SLua;

namespace Seven
{
	[SLua.CustomLuaClass]
	public class CameraShake : MonoBehaviour  
	{  
		/// <summary>  
		/// 相机震动方向  
		/// </summary>  
		public Vector3 shakeDir = Vector3.one;  
		/// <summary>  
		/// 相机震动时间  
		/// </summary>  
		public float shakeTime = 1.0f;    

		private float currentTime = 0.0f;  
		private float totalTime = 0.0f;  

		private bool isShake = false;

		public void Shake()  
		{  
			isShake = true;
			totalTime = shakeTime;  
			currentTime = shakeTime;  
		}  

		public void Stop()  
		{  
			isShake = false;
			currentTime = 0.0f;  
			totalTime = 0.0f;  
		}  

		public void SetShakeDir(float x, float y, float z)
		{
			shakeDir.x = x;
			shakeDir.y = y;
			shakeDir.z = z;
		}

		public bool IsShake()
		{
			return isShake;
		}

		void UpdateShake()  
		{  
			if (currentTime > 0.0f && totalTime > 0.0f)  
			{  
				float percent = currentTime / totalTime;  

				Vector3 shakePos = Vector3.zero;  
				shakePos.x = UnityEngine.Random.Range(-Mathf.Abs(shakeDir.x) * percent, Mathf.Abs(shakeDir.x) * percent);  
				shakePos.y = UnityEngine.Random.Range(-Mathf.Abs(shakeDir.y) * percent, Mathf.Abs(shakeDir.y) * percent);  
				shakePos.z = UnityEngine.Random.Range(-Mathf.Abs(shakeDir.z) * percent, Mathf.Abs(shakeDir.z) * percent);  

				Camera.main.transform.position += shakePos;  

				currentTime -= Time.deltaTime;  
			}  
			else  
			{  
				Stop (); 
			}  
		}  

		void LateUpdate()  
		{  
			if (!isShake)
				return;
			
			UpdateShake();  
		}

//		void OnEnable()  
//		{  
//			Shake();  
//		} 

	}  
}
