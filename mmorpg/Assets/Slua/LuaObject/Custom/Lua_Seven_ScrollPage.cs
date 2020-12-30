using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_ScrollPage : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetPage(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
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
	static public int GetCurrentPageIndex(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			var ret=self.GetCurrentPageIndex();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RefreshPage(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			System.Boolean a2;
			checkType(l,3,out a2);
			self.RefreshPage(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_smooting(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.smooting);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_smooting(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.smooting=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_pageItem(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pageItem);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_pageItem(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			Seven.PageItem v;
			checkType(l,2,out v);
			self.pageItem=v;
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
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnSetPage(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			System.Action v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnSetPage=v;
			else if(op==1) self.OnSetPage+=v;
			else if(op==2) self.OnSetPage-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_pageNum(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pageNum);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_pageNum(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.pageNum=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_pageDistance(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.pageDistance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_pageDistance(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.pageDistance=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onItemRender(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onItemRender);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onItemRender(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onItemRender=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onPageChangedFn(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onPageChangedFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onPageChangedFn(IntPtr l) {
		try {
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onPageChangedFn=v;
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
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
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
			Seven.ScrollPage self=(Seven.ScrollPage)checkSelf(l);
			SLua.LuaTable v;
			checkType(l,2,out v);
			self.data=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.ScrollPage");
		addMember(l,SetPage);
		addMember(l,GetCurrentPageIndex);
		addMember(l,RefreshPage);
		addMember(l,"smooting",get_smooting,set_smooting,true);
		addMember(l,"pageItem",get_pageItem,set_pageItem,true);
		addMember(l,"OnPageChanged",null,set_OnPageChanged,true);
		addMember(l,"OnSetPage",null,set_OnSetPage,true);
		addMember(l,"pageNum",get_pageNum,set_pageNum,true);
		addMember(l,"pageDistance",get_pageDistance,set_pageDistance,true);
		addMember(l,"onItemRender",get_onItemRender,set_onItemRender,true);
		addMember(l,"onPageChangedFn",get_onPageChangedFn,set_onPageChangedFn,true);
		addMember(l,"data",get_data,set_data,true);
		createTypeMetatable(l,null, typeof(Seven.ScrollPage),typeof(UnityEngine.MonoBehaviour));
	}
}
