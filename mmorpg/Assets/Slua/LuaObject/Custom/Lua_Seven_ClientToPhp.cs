using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_ClientToPhp : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int sendDataToPhp(IntPtr l) {
		try {
			Seven.ClientToPhp self=(Seven.ClientToPhp)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.sendDataToPhp(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int sendtxtToPhp(IntPtr l) {
		try {
			Seven.ClientToPhp self=(Seven.ClientToPhp)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.sendtxtToPhp(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_url(IntPtr l) {
		try {
			Seven.ClientToPhp self=(Seven.ClientToPhp)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.url);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_url(IntPtr l) {
		try {
			Seven.ClientToPhp self=(Seven.ClientToPhp)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.url=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.ClientToPhp");
		addMember(l,sendDataToPhp);
		addMember(l,sendtxtToPhp);
		addMember(l,"url",get_url,set_url,true);
		createTypeMetatable(l,null, typeof(Seven.ClientToPhp),typeof(UnityEngine.MonoBehaviour));
	}
}
