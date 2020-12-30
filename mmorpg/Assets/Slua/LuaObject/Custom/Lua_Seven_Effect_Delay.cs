using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Effect_Delay : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ShowEffect(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			self.ShowEffect();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetInitPlay(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetInitPlay(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_delayTime(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.delayTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_delayTime(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.delayTime=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_hideTime(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hideTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_hideTime(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.hideTime=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onFinishFn(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onFinishFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onFinishFn(IntPtr l) {
		try {
			Seven.Effect.Delay self=(Seven.Effect.Delay)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onFinishFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Effect.Delay");
		addMember(l,ShowEffect);
		addMember(l,SetInitPlay);
		addMember(l,"delayTime",get_delayTime,set_delayTime,true);
		addMember(l,"hideTime",get_hideTime,set_hideTime,true);
		addMember(l,"onFinishFn",get_onFinishFn,set_onFinishFn,true);
		createTypeMetatable(l,null, typeof(Seven.Effect.Delay),typeof(UnityEngine.MonoBehaviour));
	}
}
