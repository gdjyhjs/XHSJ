using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_AnimationEventMgr : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_callback(IntPtr l) {
		try {
			Seven.AnimationEventMgr self=(Seven.AnimationEventMgr)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.callback);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_callback(IntPtr l) {
		try {
			Seven.AnimationEventMgr self=(Seven.AnimationEventMgr)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.callback=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.AnimationEventMgr");
		addMember(l,"callback",get_callback,set_callback,true);
		createTypeMetatable(l,null, typeof(Seven.AnimationEventMgr),typeof(UnityEngine.MonoBehaviour));
	}
}
