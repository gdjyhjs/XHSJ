using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_RotaryTable : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int InitUI(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			self.InitUI();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StartTurn(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.StartTurn(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int StopTurn(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			self.StopTurn();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetAllItem(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			var ret=self.GetAllItem();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_hor_count(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hor_count);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_hor_count(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.hor_count=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ver_count(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ver_count);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_ver_count(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.ver_count=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_spacing(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.spacing);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_spacing(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.spacing=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_g_item(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.g_item);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_g_item(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			UnityEngine.GameObject v;
			checkType(l,2,out v);
			self.g_item=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_max_time(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.max_time);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_max_time(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.max_time=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_min_time(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.min_time);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_min_time(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.min_time=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__add_speed(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self._add_speed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__add_speed(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self._add_speed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__min_speed(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self._min_speed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__min_speed(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self._min_speed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get__max_speed(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self._max_speed);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set__max_speed(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self._max_speed=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_time_error(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.time_error);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_time_error(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.time_error=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onEndFn(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onEndFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onEndFn(IntPtr l) {
		try {
			Seven.RotaryTable self=(Seven.RotaryTable)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onEndFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.RotaryTable");
		addMember(l,InitUI);
		addMember(l,StartTurn);
		addMember(l,StopTurn);
		addMember(l,GetAllItem);
		addMember(l,"hor_count",get_hor_count,set_hor_count,true);
		addMember(l,"ver_count",get_ver_count,set_ver_count,true);
		addMember(l,"spacing",get_spacing,set_spacing,true);
		addMember(l,"g_item",get_g_item,set_g_item,true);
		addMember(l,"max_time",get_max_time,set_max_time,true);
		addMember(l,"min_time",get_min_time,set_min_time,true);
		addMember(l,"_add_speed",get__add_speed,set__add_speed,true);
		addMember(l,"_min_speed",get__min_speed,set__min_speed,true);
		addMember(l,"_max_speed",get__max_speed,set__max_speed,true);
		addMember(l,"time_error",get_time_error,set_time_error,true);
		addMember(l,"onEndFn",get_onEndFn,set_onEndFn,true);
		createTypeMetatable(l,null, typeof(Seven.RotaryTable),typeof(UnityEngine.MonoBehaviour));
	}
}
