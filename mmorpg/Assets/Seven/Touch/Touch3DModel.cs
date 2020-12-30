using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using System.Collections.Generic;
using SLua;
using UnityEngine.EventSystems;
namespace Seven.Touch
{
	[SLua.CustomLuaClass]
	public class Touch3DModel : MonoBehaviour
	{	
		public LuaFunction onTouchedFn;
		void OnTouched()  
		{  
			if (onTouchedFn != null) 
			{
				onTouchedFn.call ();
			}
		} 
	}
}

