using UnityEngine;
using System.Collections;
using SLua;
using UnityEngine.EventSystems;
using System.Collections.Generic;
using Seven.Move;

namespace Seven.Touch
{
	[SLua.CustomLuaClass]
	public class FingerTouchController : MonoBehaviour
	{

		private float fingerActionSensitivity = 10f; //手指动作的敏感度，这里设定为 二十分之一的屏幕宽度.
		//
		private float fingerBeginX;
		private float fingerBeginY;
		private float fingerCurrentX;
		private float fingerCurrentY;
		private float fingerSegmentX;
		private float fingerSegmentY;
		//
		private int fingerTouchState;

		private double halfScreenWidth;

		//
		private int FINGER_STATE_NULL = 0;
		private int FINGER_STATE_TOUCH = 1;
		private int FINGER_STATE_ADD = 2;
		// Use this for initialization

		private bool isMove = false;

		public LuaFunction onFingerMoveUpFn;
		public LuaFunction onFingerMoveDownFn;
		public System.Action OnTouchFn;

		public static FingerTouchController _instance;
		public static FingerTouchController Instance()
		{
			if (_instance == null)
				_instance = new FingerTouchController ();
			return _instance;
		}

		void Start () 
		{
			_instance = this;

			fingerActionSensitivity = Screen.width * 0.05f;
			halfScreenWidth = Screen.width * 0.2f;

			fingerBeginX = 0;
			fingerBeginY = 0;
			fingerCurrentX = 0;
			fingerCurrentY = 0;
			fingerSegmentX = 0;
			fingerSegmentY = 0;

			fingerTouchState = FINGER_STATE_NULL;
		}
		// Update is called once per frame
		void Update ()
		{

			if (Input.GetKeyDown (KeyCode.Mouse0)) 
			{
				if(IsPointerOverGameObject(Input.mousePosition))  
					return;
				
				if(fingerTouchState == FINGER_STATE_NULL)
				{
					fingerTouchState = FINGER_STATE_TOUCH;
					fingerBeginX = Input.mousePosition.x;
					fingerBeginY = Input.mousePosition.y;
				}

			}

			if(fingerTouchState == FINGER_STATE_TOUCH)
			{
				fingerCurrentX = Input.mousePosition.x;
				fingerCurrentY = Input.mousePosition.y;
				fingerSegmentX = fingerCurrentX - fingerBeginX;
				fingerSegmentY = fingerCurrentY - fingerBeginY;

			}
				
			if (fingerTouchState == FINGER_STATE_TOUCH) 
			{
				float fingerDistance = fingerSegmentX*fingerSegmentX + fingerSegmentY*fingerSegmentY; 

				if (fingerDistance > (fingerActionSensitivity * fingerActionSensitivity)) {
					isMove = true;
					toAddFingerAction ();
				} else if (fingerDistance >= 16) {
					isMove = true;
				}
			}

			if (Input.GetMouseButtonUp (0)) {
				fingerTouchState = FINGER_STATE_NULL;
				if (!NormalMove.isJoysticMove && !isMove && !IsPointerOverGameObject (Input.mousePosition)) {
					RaycastHit hit;  
					bool isHit = Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100f, 1<<8);  //只检查chacater层的碰撞
					if (isHit) {  
						hit.collider.gameObject.SendMessage ("OnTouched", SendMessageOptions.DontRequireReceiver); 
					} else {
						if (OnTouchFn != null)
							OnTouchFn ();
					}
				}
				isMove = false;
			}
		}

		bool IsPointerOverGameObject(Vector2 screenPosition)
		{
			//实例化点击事件
			PointerEventData eventDataCurrentPosition = new PointerEventData(UnityEngine.EventSystems.EventSystem.current);
			//将点击位置的屏幕坐标赋值给点击事件
			eventDataCurrentPosition.position = new Vector2(screenPosition.x, screenPosition.y);

			List<RaycastResult> results = new List<RaycastResult>();
			//向点击处发射射线
			EventSystem.current.RaycastAll(eventDataCurrentPosition, results);

			return results.Count > 0;
		}

		private void toAddFingerAction()
		{

			fingerTouchState = FINGER_STATE_ADD;

			if (Mathf.Abs (fingerSegmentX) > Mathf.Abs (fingerSegmentY)) 
			{
				fingerSegmentY = 0;
			} 
			else 
			{
				fingerSegmentX = 0;
			}

			if (fingerSegmentX == 0) 
			{
				// 右半屏幕才响应上下滑动
				if (fingerBeginX > halfScreenWidth) 
				{
					if (fingerSegmentY > 0) {
//						Debug.Log ("up");
						if (onFingerMoveUpFn != null)
							onFingerMoveUpFn.call ();
						
					} else {
//						Debug.Log ("down");
						if (onFingerMoveDownFn != null)
							onFingerMoveDownFn.call ();
					}
				}
			} 
			else if(fingerSegmentY == 0) 
			{
				if(fingerSegmentX > 0)
				{
//					Debug.Log ("right");
				}
				else
				{
//					Debug.Log("left");
				}
			}

		}
	}

}
