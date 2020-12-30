using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Schedule : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StartUpdate(IntPtr l) {
		try {
			Seven.Schedule self=(Seven.Schedule)checkSelf(l);
			SLua.LuaFunction a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.StartUpdate(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ResetUpdateTime(IntPtr l) {
		try {
			Seven.Schedule self=(Seven.Schedule)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.ResetUpdateTime(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopUpdate(IntPtr l) {
		try {
			Seven.Schedule self=(Seven.Schedule)checkSelf(l);
			self.StopUpdate();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PauseUpdate(IntPtr l) {
		try {
			Seven.Schedule self=(Seven.Schedule)checkSelf(l);
			self.PauseUpdate();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ResumeUpdate(IntPtr l) {
		try {
			Seven.Schedule self=(Seven.Schedule)checkSelf(l);
			self.ResumeUpdate();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Schedule");
		addMember(l,StartUpdate);
		addMember(l,ResetUpdateTime);
		addMember(l,StopUpdate);
		addMember(l,PauseUpdate);
		addMember(l,ResumeUpdate);
		createTypeMetatable(l,null, typeof(Seven.Schedule),typeof(UnityEngine.MonoBehaviour));
	}
}
