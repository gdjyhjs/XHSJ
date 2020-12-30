using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_CameraFollow : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetRot(IntPtr l) {
		try {
			Seven.CameraFollow self=(Seven.CameraFollow)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.SetRot(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetRoll(IntPtr l) {
		try {
			Seven.CameraFollow self=(Seven.CameraFollow)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.SetRoll(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_distance(IntPtr l) {
		try {
			Seven.CameraFollow self=(Seven.CameraFollow)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.distance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_distance(IntPtr l) {
		try {
			Seven.CameraFollow self=(Seven.CameraFollow)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.distance=v;
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
			Seven.CameraFollow self=(Seven.CameraFollow)checkSelf(l);
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
			Seven.CameraFollow self=(Seven.CameraFollow)checkSelf(l);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.CameraFollow");
		addMember(l,SetRot);
		addMember(l,SetRoll);
		addMember(l,"distance",get_distance,set_distance,true);
		addMember(l,"target",get_target,set_target,true);
		createTypeMetatable(l,null, typeof(Seven.CameraFollow),typeof(UnityEngine.MonoBehaviour));
	}
}
