using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_ContentSizeFitterParent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_upOffset(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.upOffset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_upOffset(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.upOffset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_downOffset(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.downOffset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_downOffset(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.downOffset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onRectTransformDimensionsChangeFn(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onRectTransformDimensionsChangeFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onRectTransformDimensionsChangeFn(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onRectTransformDimensionsChangeFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_open(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.open);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_open(IntPtr l) {
		try {
			Seven.ContentSizeFitterParent self=(Seven.ContentSizeFitterParent)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.open=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.ContentSizeFitterParent");
		addMember(l,"upOffset",get_upOffset,set_upOffset,true);
		addMember(l,"downOffset",get_downOffset,set_downOffset,true);
		addMember(l,"onRectTransformDimensionsChangeFn",get_onRectTransformDimensionsChangeFn,set_onRectTransformDimensionsChangeFn,true);
		addMember(l,"open",get_open,set_open,true);
		createTypeMetatable(l,null, typeof(Seven.ContentSizeFitterParent),typeof(UnityEngine.UI.ContentSizeFitter));
	}
}
