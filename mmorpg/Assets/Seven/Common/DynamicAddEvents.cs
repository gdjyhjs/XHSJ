// Copyright (c) 2017 Seven
// direct 
//
using UnityEngine;
using System.Collections.Generic;
using SLua;

namespace Seven
{
	/// <summary>
	/// 引用挂接
	/// </summary>
	[SLua.CustomLuaClass]
	public class DynamicAddEvents : MonoBehaviour
	{

		private Animator animator = null;  
		private RuntimeAnimatorController runtimeAnimatorController = null;  
		private AnimationClip[] clips = null;

		private Dictionary<string, AnimationClip> clipList = new Dictionary<string, AnimationClip>();


		//开始移动回调
		public LuaFunction CallBackFn;

		void Awake()  
		{  
			animator = GetComponent<Animator>();  
			// 获取运行时运行时动画器控制器  
            if (animator != null)
            { 
                runtimeAnimatorController = animator.runtimeAnimatorController;
				if (runtimeAnimatorController) {
					//获取含有的动画片段  
					clips = runtimeAnimatorController.animationClips;
					InitClips ();
				}
            }
		}  

		void CallBack(string arg)
		{
			if (CallBackFn != null) {
				CallBackFn.call (arg);
			}
		}

		void InitClips()
		{
			for (int i = 0; i < clips.Length; i++)  
			{  
				if (!clipList.ContainsKey (clips [i].name)) 
					clipList.Add (clips [i].name, clips [i]);
			}  
		}

		public void AddEvent(string name, float percent, string param)
		{
			//根据动画名称设置对应的事件  
			if (clipList.ContainsKey (name)) 
			{
				bool isHave = false;
				AnimationClip ac = clipList [name];
				for (int i = 0; i < ac.events.Length; i++) 
				{
					AnimationEvent e = ac.events [i];
					if (e.stringParameter == param) 
					{
						isHave = true;
						break;
					}
				}
				if (isHave)
					return;
				
				AnimationEvent aevent = new AnimationEvent(); 
				aevent.functionName = "CallBack";
				aevent.time = ac.length*percent;
				aevent.stringParameter = param;
				ac.AddEvent (aevent);
			}
		}

		public void RemoveEvent(string name, string param)
		{
			if (clipList.ContainsKey (name)) 
			{
				int index = 0;
				AnimationClip ac = clipList [name];
				AnimationEvent[] list = new AnimationEvent[0];
				for (int i = 0; i < ac.events.Length; i++) 
				{
					AnimationEvent e = ac.events [i];
					if (e.stringParameter != param) 
					{
						list[index] = e;
						index++;
					}
				}
				ac.events = list;
			}
		}

		public float GetAniTime(string name)
		{
			if (clipList.ContainsKey (name)) 
			{
				return clipList [name].length;
			}
			return 0;
		}
	}

}
