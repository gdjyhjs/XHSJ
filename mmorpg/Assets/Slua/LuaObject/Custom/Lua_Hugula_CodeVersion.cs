using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_CodeVersion : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Subtract_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			var ret=Hugula.CodeVersion.Subtract(a1,a2);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_CODE_VERSION(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.CodeVersion.CODE_VERSION);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_CODE_VERSION(IntPtr l) {
		try {
			int v;
			checkType(l,2,out v);
			Hugula.CodeVersion.CODE_VERSION=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_APP_VERSION(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.CodeVersion.APP_VERSION);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_APP_NUMBER(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.CodeVersion.APP_NUMBER);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_APP_NUMBER(IntPtr l) {
		try {
			int v;
			checkType(l,2,out v);
			Hugula.CodeVersion.APP_NUMBER=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.CodeVersion");
		addMember(l,Subtract_s);
		addMember(l,"CODE_VERSION",get_CODE_VERSION,set_CODE_VERSION,false);
		addMember(l,"APP_VERSION",get_APP_VERSION,null,false);
		addMember(l,"APP_NUMBER",get_APP_NUMBER,set_APP_NUMBER,false);
		createTypeMetatable(l,null, typeof(Hugula.CodeVersion));
	}
}
