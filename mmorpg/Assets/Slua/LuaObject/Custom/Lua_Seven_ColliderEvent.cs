using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_ColliderEvent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onCollisionEnterFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onCollisionEnterFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCollisionEnterFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onCollisionEnterFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onCollisionExitFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onCollisionExitFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onCollisionExitFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onCollisionExitFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onMouseDownFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onMouseDownFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onMouseDownFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onMouseDownFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onMouseUpFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onMouseUpFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onMouseUpFn(IntPtr l) {
		try {
			Seven.ColliderEvent self=(Seven.ColliderEvent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onMouseUpFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.ColliderEvent");
		addMember(l,"onCollisionEnterFn",get_onCollisionEnterFn,set_onCollisionEnterFn,true);
		addMember(l,"onCollisionExitFn",get_onCollisionExitFn,set_onCollisionExitFn,true);
		addMember(l,"onMouseDownFn",get_onMouseDownFn,set_onMouseDownFn,true);
		addMember(l,"onMouseUpFn",get_onMouseUpFn,set_onMouseUpFn,true);
		createTypeMetatable(l,null, typeof(Seven.ColliderEvent),typeof(UnityEngine.MonoBehaviour));
	}
}
