using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

namespace Seven{
	[SLua.CustomLuaClass]
	public class ModelRotation : MonoBehaviour, IDragHandler {
		[SerializeField]
		public Transform target;
//		public Transform target{
//			get{ return tar; }
//			set{
//				tar = value; 
//				tar.SetParent (transform, false);
//				Hugula.Utils.LuaHelper.SetLayerToAllChild (tar, gameObject.layer);
//			}
//		}
		public float speed = 1f;
		public void OnDrag(PointerEventData eventData)
		{
			target.localRotation = Quaternion.Euler(0f, -0.5f * eventData.delta.x * speed, 0f) * target.localRotation;
		}
	}
}