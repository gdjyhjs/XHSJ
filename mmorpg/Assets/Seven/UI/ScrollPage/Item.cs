using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using Hugula;
using SLua;
using System.Collections.Generic;

namespace Seven
{	
	[SLua.CustomLuaClass]
	public class Item : MonoBehaviour
	{
		[SLua.DoNotToLua]
		public Dictionary<string, Object> ObjDic = new Dictionary<string, Object>();

		public LuaTable UserData;
		public object data;
		public int index;
		public int page;

		public Object Get(string key)
		{
			if (ObjDic.ContainsKey(key))
				return ObjDic [key];
			else
				return null;
		}
	}
}
