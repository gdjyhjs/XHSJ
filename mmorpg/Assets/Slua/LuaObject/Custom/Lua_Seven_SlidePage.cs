using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_SlidePage : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnEndDrag(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
	static public int get_maxPageIndex(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.maxPageIndex);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxPageIndex(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.maxPageIndex=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_minPageIndex(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.minPageIndex);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_minPageIndex(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.minPageIndex=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_content(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.content);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_content(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.content=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_endDragFn(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.endDragFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_endDragFn(IntPtr l) {
		try {
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.endDragFn=v;
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
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
			Seven.SlidePage self=(Seven.SlidePage)checkSelf(l);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.SlidePage");
		addMember(l,OnEndDrag);
		addMember(l,ChangePageIndex);
		addMember(l,SetPageIndex);
		addMember(l,GetCurPage);
		addMember(l,GetLastPage);
		addMember(l,GetNextPage);
		addMember(l,"maxPageIndex",get_maxPageIndex,set_maxPageIndex,true);
		addMember(l,"minPageIndex",get_minPageIndex,set_minPageIndex,true);
		addMember(l,"content",get_content,set_content,true);
		addMember(l,"endDragFn",get_endDragFn,set_endDragFn,true);
		addMember(l,"speed",get_speed,set_speed,true);
		createTypeMetatable(l,null, typeof(Seven.SlidePage),typeof(UnityEngine.UI.ScrollRect));
	}
}
