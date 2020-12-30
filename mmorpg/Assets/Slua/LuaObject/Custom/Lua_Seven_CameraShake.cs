using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_CameraShake : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Shake(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			self.Shake();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Stop(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			self.Stop();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetShakeDir(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			System.Single a1;
			checkType(l,2,out a1);
			System.Single a2;
			checkType(l,3,out a2);
			System.Single a3;
			checkType(l,4,out a3);
			self.SetShakeDir(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int IsShake(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			var ret=self.IsShake();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_shakeDir(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.shakeDir);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_shakeDir(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.shakeDir=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_shakeTime(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.shakeTime);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_shakeTime(IntPtr l) {
		try {
			Seven.CameraShake self=(Seven.CameraShake)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.shakeTime=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.CameraShake");
		addMember(l,Shake);
		addMember(l,Stop);
		addMember(l,SetShakeDir);
		addMember(l,IsShake);
		addMember(l,"shakeDir",get_shakeDir,set_shakeDir,true);
		addMember(l,"shakeTime",get_shakeTime,set_shakeTime,true);
		createTypeMetatable(l,null, typeof(Seven.CameraShake),typeof(UnityEngine.MonoBehaviour));
	}
}
