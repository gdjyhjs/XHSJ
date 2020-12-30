using UnityEngine;
using System.Collections;

namespace Seven
{
	public class JoystickController: MonoBehaviour
	{
		public static JoystickController Instance;

		public System.Action<Vector2> OnJoystickMoveFn;
		public System.Action OnJoystickMoveEndFn;
		public System.Action OnJoystickStartFn;

		public ETCJoystick joy;

		void Start()
		{
			Instance = this;
			joy = gameObject.GetComponent<ETCJoystick> ();
		}

		public void OnjoystiscStart()
		{
			if (OnJoystickStartFn != null)
				OnJoystickStartFn ();
		}

		public void OnJoystickMove(Vector2 direction)
		{
			if (OnJoystickMoveFn != null)
				OnJoystickMoveFn (direction);
		}

		public void OnJoystickMoveEnd()
		{
			if (OnJoystickMoveEndFn != null)
				OnJoystickMoveEndFn ();
		}
	}
}

