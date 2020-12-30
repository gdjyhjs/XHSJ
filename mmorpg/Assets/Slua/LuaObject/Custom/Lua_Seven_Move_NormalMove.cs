using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Move_NormalMove : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Move(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.Move(a1,a2);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			self.StartMove();
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	static public int SetMoveForward(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	static public int MoveTo(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(UnityEngine.Transform),typeof(SLua.LuaFunction),typeof(float),typeof(string))){
				Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
				UnityEngine.Transform a1;
				checkType(l,2,out a1);
				SLua.LuaFunction a2;
				checkType(l,3,out a2);
				System.Single a3;
				checkType(l,4,out a3);
				System.String a4;
				checkType(l,5,out a4);
				var ret=self.MoveTo(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(UnityEngine.Vector3),typeof(SLua.LuaFunction),typeof(float),typeof(string))){
				Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
				UnityEngine.Vector3 a1;
				checkType(l,2,out a1);
				SLua.LuaFunction a2;
				checkType(l,3,out a2);
				System.Single a3;
				checkType(l,4,out a3);
				System.String a4;
				checkType(l,5,out a4);
				var ret=self.MoveTo(a1,a2,a3,a4);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EnableJoysick(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.EnableJoysick(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnJoystickStart(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			self.OnJoystickStart();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnJoystickMove(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			UnityEngine.Vector2 a1;
			checkType(l,2,out a1);
			self.OnJoystickMove(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnJoystickMoveEnd(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			self.OnJoystickMoveEnd();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddSkill(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.AddSkill(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetCharCtrRadiusAndHeight(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			self.SetCharCtrRadiusAndHeight(a1,a2);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	static public int get_charCtr(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	static public int get_speed(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	static public int get_isJoystickEnable(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isJoystickEnable);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isJoystickEnable(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isJoystickEnable=v;
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	static public int get_joystickStartFn(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.joystickStartFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_joystickStartFn(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.joystickStartFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_joystickMoveFn(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.joystickMoveFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_joystickMoveFn(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.joystickMoveFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_joystickMoveEndFn(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.joystickMoveEndFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_joystickMoveEndFn(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.joystickMoveEndFn=v;
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_aniChangeFn(IntPtr l) {
		try {
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
			Seven.Move.NormalMove self=(Seven.Move.NormalMove)checkSelf(l);
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
	static public int get_isJoysticMove(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Seven.Move.NormalMove.isJoysticMove);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isJoysticMove(IntPtr l) {
		try {
			System.Boolean v;
			checkType(l,2,out v);
			Seven.Move.NormalMove.isJoysticMove=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Move.NormalMove");
		addMember(l,Move);
		addMember(l,StopMove);
		addMember(l,StartMove);
		addMember(l,IsMove);
		addMember(l,SetMoveForward);
		addMember(l,MoveTo);
		addMember(l,EnableJoysick);
		addMember(l,OnJoystickStart);
		addMember(l,OnJoystickMove);
		addMember(l,OnJoystickMoveEnd);
		addMember(l,AddSkill);
		addMember(l,SetCharCtrRadiusAndHeight);
		addMember(l,"animator",get_animator,set_animator,true);
		addMember(l,"charCtr",get_charCtr,set_charCtr,true);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"isJoystickEnable",get_isJoystickEnable,set_isJoystickEnable,true);
		addMember(l,"canNotMove",get_canNotMove,set_canNotMove,true);
		addMember(l,"joystickStartFn",get_joystickStartFn,set_joystickStartFn,true);
		addMember(l,"joystickMoveFn",get_joystickMoveFn,set_joystickMoveFn,true);
		addMember(l,"joystickMoveEndFn",get_joystickMoveEndFn,set_joystickMoveEndFn,true);
		addMember(l,"finishMoveFn",get_finishMoveFn,set_finishMoveFn,true);
		addMember(l,"aniChangeFn",get_aniChangeFn,set_aniChangeFn,true);
		addMember(l,"isJoysticMove",get_isJoysticMove,set_isJoysticMove,false);
		createTypeMetatable(l,null, typeof(Seven.Move.NormalMove),typeof(UnityEngine.MonoBehaviour));
	}
}
