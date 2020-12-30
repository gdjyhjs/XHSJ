using UnityEngine;
using System.Collections;
using SLua;

namespace Seven
{
	[SLua.CustomLuaClass]
	public class ColliderEvent : MonoBehaviour
	{
		public LuaFunction onCollisionEnterFn;
		public LuaFunction onCollisionExitFn;
		public LuaFunction onMouseDownFn;
		public LuaFunction onMouseUpFn;

		void OnTriggerEnter(Collider collision)
		{
			if (onCollisionEnterFn != null)
				onCollisionEnterFn.call (collision);
		}

		void OnTriggerExit(Collider collision)
		{
			if (onCollisionExitFn != null)
				onCollisionExitFn.call (collision);
		}

		void OnMouseDown()
		{
			if (onMouseDownFn != null)
				onMouseDownFn.call (gameObject);
		}

		void OnMouseUp()
		{
			if (onMouseUpFn != null)
			{
				onMouseUpFn.call ();
			}
		}

	}
}

