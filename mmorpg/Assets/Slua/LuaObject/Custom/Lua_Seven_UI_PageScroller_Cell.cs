﻿using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_UI_PageScroller_Cell : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Get(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,2,typeof(int))){
				Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
				System.Int32 a1;
				checkType(l,2,out a1);
				var ret=self.Get(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,2,typeof(string))){
				Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.Get(a1);
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
	static public int get_rectTransform(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.rectTransform);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_rectTransform(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			UnityEngine.RectTransform v;
			checkType(l,2,out v);
			self.rectTransform=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_refers(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.refers);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_refers(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			UnityEngine.GameObject[] v;
			checkArray(l,2,out v);
			self.refers=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_monos(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.monos);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_monos(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			UnityEngine.Object[] v;
			checkArray(l,2,out v);
			self.monos=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_data(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.data);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_data(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			System.Object v;
			checkType(l,2,out v);
			self.data=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_fdata(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.fdata);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_fdata(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.fdata=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_index(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.index);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_index(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.index=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_page(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.page);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_page(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.page=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Length(IntPtr l) {
		try {
			Seven.UI.PageScroller.Cell self=(Seven.UI.PageScroller.Cell)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Length);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.UI.PageScroller.Cell");
		addMember(l,Get);
		addMember(l,"rectTransform",get_rectTransform,set_rectTransform,true);
		addMember(l,"refers",get_refers,set_refers,true);
		addMember(l,"monos",get_monos,set_monos,true);
		addMember(l,"data",get_data,set_data,true);
		addMember(l,"fdata",get_fdata,set_fdata,true);
		addMember(l,"index",get_index,set_index,true);
		addMember(l,"page",get_page,set_page,true);
		addMember(l,"Length",get_Length,null,true);
		createTypeMetatable(l,null, typeof(Seven.UI.PageScroller.Cell),typeof(UnityEngine.MonoBehaviour));
	}
}
