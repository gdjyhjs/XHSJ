using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_Microphone : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Start_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Boolean a2;
			checkType(l,2,out a2);
			System.Int32 a3;
			checkType(l,3,out a3);
			System.Int32 a4;
			checkType(l,4,out a4);
			var ret=Seven.Microphone.Start(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int End_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Seven.Microphone.End(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int IsRecording_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Seven.Microphone.IsRecording(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetPosition_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Seven.Microphone.GetPosition(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetDeviceCaps_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Int32 a2;
			System.Int32 a3;
			Seven.Microphone.GetDeviceCaps(a1,out a2,out a3);
			pushValue(l,true);
			pushValue(l,a2);
			pushValue(l,a3);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_devices(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Seven.Microphone.devices);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.Microphone");
		addMember(l,Start_s);
		addMember(l,End_s);
		addMember(l,IsRecording_s);
		addMember(l,GetPosition_s);
		addMember(l,GetDeviceCaps_s);
		addMember(l,"devices",get_devices,null,false);
		createTypeMetatable(l,null, typeof(Seven.Microphone));
	}
}
