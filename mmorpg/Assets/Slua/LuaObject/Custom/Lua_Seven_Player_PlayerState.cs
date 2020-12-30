using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Player_PlayerState : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetOpen(IntPtr l) {
		try {
			Seven.Player.PlayerState self=(Seven.Player.PlayerState)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetOpen(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_time(IntPtr l) {
		try {
			Seven.Player.PlayerState self=(Seven.Player.PlayerState)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.time);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_time(IntPtr l) {
		try {
			Seven.Player.PlayerState self=(Seven.Player.PlayerState)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.time=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_count(IntPtr l) {
		try {
			Seven.Player.PlayerState self=(Seven.Player.PlayerState)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.count);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_count(IntPtr l) {
		try {
			Seven.Player.PlayerState self=(Seven.Player.PlayerState)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.count=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Player.PlayerState");
		addMember(l,SetOpen);
		addMember(l,"time",get_time,set_time,true);
		addMember(l,"count",get_count,set_count,true);
		createTypeMetatable(l,null, typeof(Seven.Player.PlayerState),typeof(UnityEngine.MonoBehaviour));
	}
}
