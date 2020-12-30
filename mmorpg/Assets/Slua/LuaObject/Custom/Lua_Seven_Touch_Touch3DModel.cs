using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Touch_Touch3DModel : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onTouchedFn(IntPtr l) {
		try {
			Seven.Touch.Touch3DModel self=(Seven.Touch.Touch3DModel)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onTouchedFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onTouchedFn(IntPtr l) {
		try {
			Seven.Touch.Touch3DModel self=(Seven.Touch.Touch3DModel)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onTouchedFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Touch.Touch3DModel");
		addMember(l,"onTouchedFn",get_onTouchedFn,set_onTouchedFn,true);
		createTypeMetatable(l,null, typeof(Seven.Touch.Touch3DModel),typeof(UnityEngine.MonoBehaviour));
	}
}
