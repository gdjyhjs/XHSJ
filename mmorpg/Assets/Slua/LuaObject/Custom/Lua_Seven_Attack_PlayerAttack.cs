using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Attack_PlayerAttack : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopMove(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
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
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
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
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
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
	static public int AddAtkMoveTime(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.AddAtkMoveTime(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddAtkMoveDistance(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.AddAtkMoveDistance(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddAtkMoveSpeed(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.AddAtkMoveSpeed(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearAllAtkPlay(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			self.ClearAllAtkPlay();
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
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
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
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
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
	static public int get_exitTime1(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.exitTime1);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_exitTime1(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.exitTime1=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_exitTime2(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.exitTime2);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_exitTime2(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.exitTime2=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_exitTime3(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.exitTime3);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_exitTime3(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.exitTime3=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_connectTime(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.connectTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_connectTime(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.connectTime=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_moveVec(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.moveVec);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_moveVec(IntPtr l) {
		try {
			Seven.Attack.PlayerAttack self=(Seven.Attack.PlayerAttack)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.moveVec=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Attack.PlayerAttack");
		addMember(l,StopMove);
		addMember(l,PlayAttack);
		addMember(l,IsMove);
		addMember(l,AddAtkMoveTime);
		addMember(l,AddAtkMoveDistance);
		addMember(l,AddAtkMoveSpeed);
		addMember(l,ClearAllAtkPlay);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"exitTime1",get_exitTime1,set_exitTime1,true);
		addMember(l,"exitTime2",get_exitTime2,set_exitTime2,true);
		addMember(l,"exitTime3",get_exitTime3,set_exitTime3,true);
		addMember(l,"connectTime",get_connectTime,set_connectTime,true);
		addMember(l,"moveVec",get_moveVec,set_moveVec,true);
		createTypeMetatable(l,null, typeof(Seven.Attack.PlayerAttack),typeof(UnityEngine.MonoBehaviour));
	}
}
