using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Message_LocalDelivery : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int NotificationMessage_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string),typeof(System.DateTime),typeof(bool))){
				System.String a1;
				checkType(l,1,out a1);
				System.DateTime a2;
				checkValueType(l,2,out a2);
				System.Boolean a3;
				checkType(l,3,out a3);
				Seven.Message.LocalDelivery.NotificationMessage(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(matchType(l,argc,1,typeof(string),typeof(int),typeof(bool))){
				System.String a1;
				checkType(l,1,out a1);
				System.Int32 a2;
				checkType(l,2,out a2);
				System.Boolean a3;
				checkType(l,3,out a3);
				Seven.Message.LocalDelivery.NotificationMessage(a1,a2,a3);
				pushValue(l,true);
				return 1;
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
	static public int get_messageFn(IntPtr l) {
		try {
			Seven.Message.LocalDelivery self=(Seven.Message.LocalDelivery)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.messageFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_messageFn(IntPtr l) {
		try {
			Seven.Message.LocalDelivery self=(Seven.Message.LocalDelivery)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.messageFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Message.LocalDelivery");
		addMember(l,NotificationMessage_s);
		addMember(l,"messageFn",get_messageFn,set_messageFn,true);
		createTypeMetatable(l,null, typeof(Seven.Message.LocalDelivery),typeof(UnityEngine.MonoBehaviour));
	}
}
