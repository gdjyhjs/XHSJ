using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Move_FollowMove : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetFollowDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.SetFollowDistance(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetAtkFollowDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.SetAtkFollowDistance(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetStopDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			self.SetStopDistance(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetAtk(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetAtk(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetFollow(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetFollow(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int IsFollow(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			var ret=self.IsFollow();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetTarget(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
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
	static public int IsMove(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
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
	static public int SetHero(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetHero(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetTargetFollowMove(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetTargetFollowMove(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.maxDistance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.maxDistance=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_minDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.minDistance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_minDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.minDistance=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_atkFollowDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.atkFollowDistance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_atkFollowDistance(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.atkFollowDistance=v;
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
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
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
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
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
	static public int get_starMoveFn(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.starMoveFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_starMoveFn(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.starMoveFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_atkBackFn(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.atkBackFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_atkBackFn(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.atkBackFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_stopMoveFn(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.stopMoveFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_stopMoveFn(IntPtr l) {
		try {
			Seven.Move.FollowMove self=(Seven.Move.FollowMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.stopMoveFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Move.FollowMove");
		addMember(l,SetFollowDistance);
		addMember(l,SetAtkFollowDistance);
		addMember(l,SetStopDistance);
		addMember(l,SetAtk);
		addMember(l,SetFollow);
		addMember(l,IsFollow);
		addMember(l,SetTarget);
		addMember(l,IsMove);
		addMember(l,SetHero);
		addMember(l,SetTargetFollowMove);
		addMember(l,"maxDistance",get_maxDistance,set_maxDistance,true);
		addMember(l,"minDistance",get_minDistance,set_minDistance,true);
		addMember(l,"atkFollowDistance",get_atkFollowDistance,set_atkFollowDistance,true);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"starMoveFn",get_starMoveFn,set_starMoveFn,true);
		addMember(l,"atkBackFn",get_atkBackFn,set_atkBackFn,true);
		addMember(l,"stopMoveFn",get_stopMoveFn,set_stopMoveFn,true);
		createTypeMetatable(l,null, typeof(Seven.Move.FollowMove),typeof(UnityEngine.MonoBehaviour));
	}
}
