using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Item : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Get(IntPtr l) {
		try {
			Seven.Item self=(Seven.Item)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.Get(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_UserData(IntPtr l) {
		try {
			Seven.Item self=(Seven.Item)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.UserData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_UserData(IntPtr l) {
		try {
			Seven.Item self=(Seven.Item)checkSelf(l);
			SLua.LuaTable v;
			checkType(l,2,out v);
			self.UserData=v;
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
			Seven.Item self=(Seven.Item)checkSelf(l);
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
			Seven.Item self=(Seven.Item)checkSelf(l);
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
	static public int get_index(IntPtr l) {
		try {
			Seven.Item self=(Seven.Item)checkSelf(l);
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
			Seven.Item self=(Seven.Item)checkSelf(l);
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
			Seven.Item self=(Seven.Item)checkSelf(l);
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
			Seven.Item self=(Seven.Item)checkSelf(l);
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
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Item");
		addMember(l,Get);
		addMember(l,"UserData",get_UserData,set_UserData,true);
		addMember(l,"data",get_data,set_data,true);
		addMember(l,"index",get_index,set_index,true);
		addMember(l,"page",get_page,set_page,true);
		createTypeMetatable(l,null, typeof(Seven.Item),typeof(UnityEngine.MonoBehaviour));
	}
}
