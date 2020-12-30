using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_MonsterMoveCtr : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetMoveForward(IntPtr l) {
		try {
			Seven.MonsterMoveCtr self=(Seven.MonsterMoveCtr)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetMoveForward(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_charCtr(IntPtr l) {
		try {
			Seven.MonsterMoveCtr self=(Seven.MonsterMoveCtr)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.charCtr);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_charCtr(IntPtr l) {
		try {
			Seven.MonsterMoveCtr self=(Seven.MonsterMoveCtr)checkSelf(l);
			UnityEngine.CharacterController v;
			checkType(l,2,out v);
			self.charCtr=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_animator(IntPtr l) {
		try {
			Seven.MonsterMoveCtr self=(Seven.MonsterMoveCtr)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.animator);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_animator(IntPtr l) {
		try {
			Seven.MonsterMoveCtr self=(Seven.MonsterMoveCtr)checkSelf(l);
			UnityEngine.Animator v;
			checkType(l,2,out v);
			self.animator=v;
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
			Seven.MonsterMoveCtr self=(Seven.MonsterMoveCtr)checkSelf(l);
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
			Seven.MonsterMoveCtr self=(Seven.MonsterMoveCtr)checkSelf(l);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.MonsterMoveCtr");
		addMember(l,SetMoveForward);
		addMember(l,"charCtr",get_charCtr,set_charCtr,true);
		addMember(l,"animator",get_animator,set_animator,true);
		addMember(l,"speed",get_speed,set_speed,true);
		createTypeMetatable(l,null, typeof(Seven.MonsterMoveCtr),typeof(UnityEngine.MonoBehaviour));
	}
}
