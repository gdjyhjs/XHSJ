using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Move_NpcMove : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int MoveTo(IntPtr l) {
		try {
			Seven.Move.NpcMove self=(Seven.Move.NpcMove)checkSelf(l);
			UnityEngine.Vector3 a1;
			checkType(l,2,out a1);
			SLua.LuaFunction a2;
			checkType(l,3,out a2);
			self.MoveTo(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopMove(IntPtr l) {
		try {
			Seven.Move.NpcMove self=(Seven.Move.NpcMove)checkSelf(l);
			self.StopMove();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StartMove(IntPtr l) {
		try {
			Seven.Move.NpcMove self=(Seven.Move.NpcMove)checkSelf(l);
			self.StartMove();
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
			Seven.Move.NpcMove self=(Seven.Move.NpcMove)checkSelf(l);
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
			Seven.Move.NpcMove self=(Seven.Move.NpcMove)checkSelf(l);
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
	static public int get_finishMoveFn(IntPtr l) {
		try {
			Seven.Move.NpcMove self=(Seven.Move.NpcMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.finishMoveFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_finishMoveFn(IntPtr l) {
		try {
			Seven.Move.NpcMove self=(Seven.Move.NpcMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.finishMoveFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Move.NpcMove");
		addMember(l,MoveTo);
		addMember(l,StopMove);
		addMember(l,StartMove);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"finishMoveFn",get_finishMoveFn,set_finishMoveFn,true);
		createTypeMetatable(l,null, typeof(Seven.Move.NpcMove),typeof(UnityEngine.MonoBehaviour));
	}
}
