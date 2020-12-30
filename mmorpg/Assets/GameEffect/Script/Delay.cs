using UnityEngine;
using System.Collections;
using SLua;

namespace Seven.Effect
{
	[SLua.CustomLuaClass]
	public class Delay : MonoBehaviour {

		public float delayTime = 0.0f;
		public float hideTime = 0.0f;

		public LuaFunction onFinishFn;

		private Animator animator;
		private bool initPlay = true;
		private bool isHide = false;
		// Use this for initialization
		void Start () {
			if (!initPlay)
				return;
			
			if (hideTime > 0.0) {
				Invoke ("HideFunc", hideTime);
			}

			animator = gameObject.GetComponent<Animator> ();
			if (delayTime > 0) {
				gameObject.SetActive (false);
				gameObject.SetActiveRecursively (false);
				Invoke ("DelayFunc", delayTime);
			} else 
			{
				PlayAni ();
			}
		}

		void DelayFunc()
		{
			gameObject.SetActive (true);
			gameObject.SetActiveRecursively(true);
			PlayAni();
		}

		void HideFunc()
		{
			if (isHide) {
				return;
			}
			isHide = true;

			if (onFinishFn != null)
				onFinishFn.call ();
			gameObject.SetActive (false);
		}

		void PlayAni()
		{
			if (animator != null)
			{
				animator.SetTrigger ("play");
			}
		}

		public void ShowEffect()
		{
			isHide = false;	
			CancelInvoke ();
			if (hideTime > 0.0) {
				Invoke ("HideFunc", hideTime);
			}

			if (delayTime > 0.0) {
				gameObject.SetActive (false);
				gameObject.SetActiveRecursively (false);
				Invoke ("DelayFunc", delayTime);
			}
			else 
			{
				gameObject.SetActive (true);
				gameObject.SetActiveRecursively (true);
				PlayAni();
			}
		}

		public void SetInitPlay(bool flag)
		{
			initPlay = flag;
		}
	}
}