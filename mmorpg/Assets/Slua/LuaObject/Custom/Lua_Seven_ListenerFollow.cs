using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_ListenerFollow : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_target(IntPtr l) {
		try {
			Seven.ListenerFollow self=(Seven.ListenerFollow)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.target);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_target(IntPtr l) {
		try {
			Seven.ListenerFollow self=(Seven.ListenerFollow)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.ListenerFollow");
		addMember(l,"target",get_target,set_target,true);
		createTypeMetatable(l,null, typeof(Seven.ListenerFollow),typeof(UnityEngine.MonoBehaviour));
	}
}
