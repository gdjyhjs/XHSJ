using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Touch_FingerTouchController : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Instance_s(IntPtr l) {
		try {
			var ret=Seven.Touch.FingerTouchController.Instance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onFingerMoveUpFn(IntPtr l) {
		try {
			Seven.Touch.FingerTouchController self=(Seven.Touch.FingerTouchController)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onFingerMoveUpFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onFingerMoveUpFn(IntPtr l) {
		try {
			Seven.Touch.FingerTouchController self=(Seven.Touch.FingerTouchController)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onFingerMoveUpFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onFingerMoveDownFn(IntPtr l) {
		try {
			Seven.Touch.FingerTouchController self=(Seven.Touch.FingerTouchController)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onFingerMoveDownFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onFingerMoveDownFn(IntPtr l) {
		try {
			Seven.Touch.FingerTouchController self=(Seven.Touch.FingerTouchController)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onFingerMoveDownFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnTouchFn(IntPtr l) {
		try {
			Seven.Touch.FingerTouchController self=(Seven.Touch.FingerTouchController)checkSelf(l);
			System.Action v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnTouchFn=v;
			else if(op==1) self.OnTouchFn+=v;
			else if(op==2) self.OnTouchFn-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Seven.Touch.FingerTouchController._instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__instance(IntPtr l) {
		try {
			Seven.Touch.FingerTouchController v;
			checkType(l,2,out v);
			Seven.Touch.FingerTouchController._instance=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Touch.FingerTouchController");
		addMember(l,Instance_s);
		addMember(l,"onFingerMoveUpFn",get_onFingerMoveUpFn,set_onFingerMoveUpFn,true);
		addMember(l,"onFingerMoveDownFn",get_onFingerMoveDownFn,set_onFingerMoveDownFn,true);
		addMember(l,"OnTouchFn",null,set_OnTouchFn,true);
		addMember(l,"_instance",get__instance,set__instance,false);
		createTypeMetatable(l,null, typeof(Seven.Touch.FingerTouchController),typeof(UnityEngine.MonoBehaviour));
	}
}
