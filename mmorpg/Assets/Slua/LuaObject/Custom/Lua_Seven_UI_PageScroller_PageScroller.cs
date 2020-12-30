using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_UI_PageScroller_PageScroller : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnEndDrag(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			UnityEngine.EventSystems.PointerEventData a1;
			checkType(l,2,out a1);
			self.OnEndDrag(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ChangePageIndex(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.ChangePageIndex(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetPageIndex(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.SetPageIndex(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetCurPage(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			var ret=self.GetCurPage();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetLastPage(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			var ret=self.GetLastPage();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetNextPage(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			var ret=self.GetNextPage();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetItem(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.GetItem(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetPage(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			self.SetPage(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetData(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			SLua.LuaTable a1;
			checkType(l,2,out a1);
			self.SetData(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_OnUpdateFn(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.OnUpdateFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnUpdateFn(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.OnUpdateFn=v;
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
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
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
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
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
	static public int set_OnPageChanged(IntPtr l) {
		try {
			Seven.UI.PageScroller.PageScroller self=(Seven.UI.PageScroller.PageScroller)checkSelf(l);
			System.Action<System.Int32,System.Int32> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnPageChanged=v;
			else if(op==1) self.OnPageChanged+=v;
			else if(op==2) self.OnPageChanged-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.UI.PageScroller.PageScroller");
		addMember(l,OnEndDrag);
		addMember(l,ChangePageIndex);
		addMember(l,SetPageIndex);
		addMember(l,GetCurPage);
		addMember(l,GetLastPage);
		addMember(l,GetNextPage);
		addMember(l,GetItem);
		addMember(l,SetPage);
		addMember(l,SetData);
		addMember(l,"OnUpdateFn",get_OnUpdateFn,set_OnUpdateFn,true);
		addMember(l,"speed",get_speed,set_speed,true);
		addMember(l,"OnPageChanged",null,set_OnPageChanged,true);
		createTypeMetatable(l,null, typeof(Seven.UI.PageScroller.PageScroller),typeof(UnityEngine.UI.ScrollRect));
	}
}
