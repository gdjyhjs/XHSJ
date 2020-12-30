using UnityEngine;
using System.Collections;
using SLua;

namespace Seven
{
	[SLua.CustomLuaClass]
	public class HpFollow : MonoBehaviour
	{
		public RectTransform hp;
		public Transform target;

		private bool isUpdate = true;
		private Vector3 lastTargetPos = Vector3.zero;

		private TargetFollow targetFollow;

		// Use this for initialization
		void Start ()
		{
			isUpdate = true;
			targetFollow = GameObject.Find ("Main Camera").GetComponent<TargetFollow> ();
		}

		// Update is called once per frame
		void Update ()
		{
			if (target == null || hp == null || Camera.main == null)
				return;

//			if (isUpdate && (targetFollow.IsMove()||target.position != lastTargetPos)) 
//			{
				UpdateHp ();
//			}
		}

		public void UpdateHp()
		{
			hp.position =  Camera.main.WorldToScreenPoint(target.position);
			lastTargetPos = target.position;
		}

		public void SetUpdateHp(bool need)
		{
			isUpdate = need;
			this.enabled = need;
		}

		public bool IsUpdate()
		{
			return isUpdate;
		}

		public void SetTarget(Transform target)
		{
			this.target = target;
			UpdateHp ();
		}
	}
}
