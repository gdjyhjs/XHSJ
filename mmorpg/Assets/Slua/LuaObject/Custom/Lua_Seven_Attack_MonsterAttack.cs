using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Attack_MonsterAttack : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopMove(IntPtr l) {
		try {
			Seven.Attack.MonsterAttack self=(Seven.Attack.MonsterAttack)checkSelf(l);
			self.StopMove();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int PlayAttack(IntPtr l) {
		try {
			Seven.Attack.MonsterAttack self=(Seven.Attack.MonsterAttack)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.PlayAttack(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int IsMove(IntPtr l) {
		try {
			Seven.Attack.MonsterAttack self=(Seven.Attack.MonsterAttack)checkSelf(l);
			var ret=self.IsMove();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AtkMove(IntPtr l) {
		try {
			Seven.Attack.MonsterAttack self=(Seven.Attack.MonsterAttack)checkSelf(l);
			UnityEngine.Vector3 a1;
			checkType(l,2,out a1);
			self.AtkMove(a1);
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
			Seven.Attack.MonsterAttack self=(Seven.Attack.MonsterAttack)checkSelf(l);
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
			Seven.Attack.MonsterAttack self=(Seven.Attack.MonsterAttack)checkSelf(l);
			System.Int32 v;
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
		getTypeTable(l,"Seven.Attack.MonsterAttack");
		addMember(l,StopMove);
		addMember(l,PlayAttack);
		addMember(l,IsMove);
		addMember(l,AtkMove);
		addMember(l,"speed",get_speed,set_speed,true);
		createTypeMetatable(l,null, typeof(Seven.Attack.MonsterAttack),typeof(UnityEngine.MonoBehaviour));
	}
}
