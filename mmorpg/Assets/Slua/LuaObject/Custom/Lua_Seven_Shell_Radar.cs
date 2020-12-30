using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Shell_Radar : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Play(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			self.Play();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_OnArriveFn(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.OnArriveFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnArriveFn(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.OnArriveFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_target(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
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
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_speed(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.speed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_speed(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.speed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_offset(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.offset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_offset(IntPtr l) {
		try {
			Seven.Shell.Radar self=(Seven.Shell.Radar)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.offset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Shell.Radar");
		addMember(l,Play);
		addMember(l,"OnArriveFn",get_OnArriveFn,set_OnArriveFn,true);
		addMember(l,"target",get_target,set_target,true);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"offset",get_offset,set_offset,true);
		createTypeMetatable(l,null, typeof(Seven.Shell.Radar),typeof(UnityEngine.MonoBehaviour));
	}
}
