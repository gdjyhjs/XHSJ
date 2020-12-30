using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_HpFollow : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UpdateHp(IntPtr l) {
		try {
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
			self.UpdateHp();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetUpdateHp(IntPtr l) {
		try {
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
			System.Boolean a1;
			checkType(l,2,out a1);
			self.SetUpdateHp(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int IsUpdate(IntPtr l) {
		try {
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
			var ret=self.IsUpdate();
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
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
			UnityEngine.Transform a1;
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
	static public int get_hp(IntPtr l) {
		try {
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_hp(IntPtr l) {
		try {
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
			UnityEngine.RectTransform v;
			checkType(l,2,out v);
			self.hp=v;
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
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
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
			Seven.HpFollow self=(Seven.HpFollow)checkSelf(l);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.HpFollow");
		addMember(l,UpdateHp);
		addMember(l,SetUpdateHp);
		addMember(l,IsUpdate);
		addMember(l,SetTarget);
		addMember(l,"hp",get_hp,set_hp,true);
		addMember(l,"target",get_target,set_target,true);
		createTypeMetatable(l,null, typeof(Seven.HpFollow),typeof(UnityEngine.MonoBehaviour));
	}
}
