using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_SDK_SdkHandle : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Login(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.Login();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Logout(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.Logout();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Pay(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.Pay(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CreatRole(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.CreatRole(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EnterGame(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.EnterGame(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UpdateRoleInfo(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.UpdateRoleInfo(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Exit(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.Exit();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ShowToolbar(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.ShowToolbar();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int HideToolbar(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.HideToolbar();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EnterUserCenter(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.EnterUserCenter();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EnterBBS(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.EnterBBS();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int EnterCustomer(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			self.EnterCustomer();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int UserId(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			var ret=self.UserId();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ChannelType(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			var ret=self.ChannelType();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Instance_s(IntPtr l) {
		try {
			var ret=Seven.SDK.SdkHandle.Instance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_InitSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.InitSuccessFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_InitSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.InitSuccessFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_InitFailedFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.InitFailedFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_InitFailedFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.InitFailedFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_LoginSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.LoginSuccessFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_LoginSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.LoginSuccessFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_LoginFailedFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.LoginFailedFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_LoginFailedFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.LoginFailedFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_SwichAccountSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.SwichAccountSuccessFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_SwichAccountSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.SwichAccountSuccessFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_LogoutFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.LogoutFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_LogoutFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.LogoutFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_PaySuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.PaySuccessFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_PaySuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.PaySuccessFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_PayCancelFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.PayCancelFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_PayCancelFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.PayCancelFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_PayFailedFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.PayFailedFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_PayFailedFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.PayFailedFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ExitSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.ExitSuccessFunc);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_ExitSuccessFunc(IntPtr l) {
		try {
			Seven.SDK.SdkHandle self=(Seven.SDK.SdkHandle)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.ExitSuccessFunc=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.SDK.SdkHandle");
		addMember(l,Login);
		addMember(l,Logout);
		addMember(l,Pay);
		addMember(l,CreatRole);
		addMember(l,EnterGame);
		addMember(l,UpdateRoleInfo);
		addMember(l,Exit);
		addMember(l,ShowToolbar);
		addMember(l,HideToolbar);
		addMember(l,EnterUserCenter);
		addMember(l,EnterBBS);
		addMember(l,EnterCustomer);
		addMember(l,UserId);
		addMember(l,ChannelType);
		addMember(l,Instance_s);
		addMember(l,"InitSuccessFunc",get_InitSuccessFunc,set_InitSuccessFunc,true);
		addMember(l,"InitFailedFunc",get_InitFailedFunc,set_InitFailedFunc,true);
		addMember(l,"LoginSuccessFunc",get_LoginSuccessFunc,set_LoginSuccessFunc,true);
		addMember(l,"LoginFailedFunc",get_LoginFailedFunc,set_LoginFailedFunc,true);
		addMember(l,"SwichAccountSuccessFunc",get_SwichAccountSuccessFunc,set_SwichAccountSuccessFunc,true);
		addMember(l,"LogoutFunc",get_LogoutFunc,set_LogoutFunc,true);
		addMember(l,"PaySuccessFunc",get_PaySuccessFunc,set_PaySuccessFunc,true);
		addMember(l,"PayCancelFunc",get_PayCancelFunc,set_PayCancelFunc,true);
		addMember(l,"PayFailedFunc",get_PayFailedFunc,set_PayFailedFunc,true);
		addMember(l,"ExitSuccessFunc",get_ExitSuccessFunc,set_ExitSuccessFunc,true);
		createTypeMetatable(l,null, typeof(Seven.SDK.SdkHandle),typeof(quicksdk.QuickSDKListener));
	}
}
