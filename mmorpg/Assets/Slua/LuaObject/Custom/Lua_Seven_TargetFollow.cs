using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_TargetFollow : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetTarget(IntPtr l) {
		try {
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
			UnityEngine.GameObject a1;
			checkType(l,2,out a1);
			self.SetTarget(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Reset(IntPtr l) {
		try {
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
			self.Reset();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetCameraScale(IntPtr l) {
		try {
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			System.Single a3;
			checkType(l,4,out a3);
			System.Single a4;
			checkType(l,5,out a4);
			System.Single a5;
			checkType(l,6,out a5);
			self.SetCameraScale(a1,a2,a3,a4,a5);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetTeamFollow(IntPtr l) {
		try {
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetTeamFollow(a1);
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
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
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
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_addOther(IntPtr l) {
		try {
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.addOther);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_addOther(IntPtr l) {
		try {
			Seven.TargetFollow self=(Seven.TargetFollow)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.addOther=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.TargetFollow");
		addMember(l,SetTarget);
		addMember(l,Reset);
		addMember(l,SetCameraScale);
		addMember(l,SetTeamFollow);
		addMember(l,"target",get_target,set_target,true);
		addMember(l,"addOther",get_addOther,set_addOther,true);
		createTypeMetatable(l,null, typeof(Seven.TargetFollow),typeof(UnityEngine.MonoBehaviour));
	}
}
