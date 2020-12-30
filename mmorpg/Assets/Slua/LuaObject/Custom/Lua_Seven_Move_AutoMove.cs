using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Move_AutoMove : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetDestination4(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			UnityEngine.Vector3 a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			System.Boolean a3;
			checkType(l,4,out a3);
			var ret=self.SetDestination4(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetDestination(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			UnityEngine.Vector3 a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			System.Boolean a3;
			checkType(l,4,out a3);
			var ret=self.SetDestination(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetDestination3(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			UnityEngine.Vector3 a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			var ret=self.SetDestination3(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopMove(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.StopMove(a1);
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
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			self.StartMove();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int IsAutoMove(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			var ret=self.IsAutoMove();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int IsTouchMove(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			var ret=self.IsTouchMove();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EnableTouchMove(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.EnableTouchMove(a1);
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
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
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
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
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
	static public int get_minDistance(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
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
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
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
	static public int get_canNotMove(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.canNotMove);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_canNotMove(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.canNotMove=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_pathCallbackFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pathCallbackFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_pathCallbackFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.pathCallbackFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_arriveDestinationFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.arriveDestinationFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_arriveDestinationFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.arriveDestinationFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_aniChangeFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.aniChangeFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_aniChangeFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.aniChangeFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_touchMoveFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.touchMoveFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_touchMoveFn(IntPtr l) {
		try {
			Seven.Move.AutoMove self=(Seven.Move.AutoMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.touchMoveFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Move.AutoMove");
		addMember(l,SetDestination4);
		addMember(l,SetDestination);
		addMember(l,SetDestination3);
		addMember(l,StopMove);
		addMember(l,StartMove);
		addMember(l,IsAutoMove);
		addMember(l,IsTouchMove);
		addMember(l,EnableTouchMove);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"minDistance",get_minDistance,set_minDistance,true);
		addMember(l,"canNotMove",get_canNotMove,set_canNotMove,true);
		addMember(l,"pathCallbackFn",get_pathCallbackFn,set_pathCallbackFn,true);
		addMember(l,"arriveDestinationFn",get_arriveDestinationFn,set_arriveDestinationFn,true);
		addMember(l,"aniChangeFn",get_aniChangeFn,set_aniChangeFn,true);
		addMember(l,"touchMoveFn",get_touchMoveFn,set_touchMoveFn,true);
		createTypeMetatable(l,null, typeof(Seven.Move.AutoMove),typeof(UnityEngine.MonoBehaviour));
	}
}
