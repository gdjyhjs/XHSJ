using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_DynamicAddEvents : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddEvent(IntPtr l) {
		try {
			Seven.DynamicAddEvents self=(Seven.DynamicAddEvents)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			System.String a3;
			checkType(l,4,out a3);
			self.AddEvent(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RemoveEvent(IntPtr l) {
		try {
			Seven.DynamicAddEvents self=(Seven.DynamicAddEvents)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			self.RemoveEvent(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetAniTime(IntPtr l) {
		try {
			Seven.DynamicAddEvents self=(Seven.DynamicAddEvents)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetAniTime(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CallBackFn(IntPtr l) {
		try {
			Seven.DynamicAddEvents self=(Seven.DynamicAddEvents)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.CallBackFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_CallBackFn(IntPtr l) {
		try {
			Seven.DynamicAddEvents self=(Seven.DynamicAddEvents)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.CallBackFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.DynamicAddEvents");
		addMember(l,AddEvent);
		addMember(l,RemoveEvent);
		addMember(l,GetAniTime);
		addMember(l,"CallBackFn",get_CallBackFn,set_CallBackFn,true);
		createTypeMetatable(l,null, typeof(Seven.DynamicAddEvents),typeof(UnityEngine.MonoBehaviour));
	}
}
