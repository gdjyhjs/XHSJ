using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Update_BackGroundDownload : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddFirstManifestTask(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			Hugula.Update.FileManifest a1;
			checkType(l,2,out a1);
			Hugula.Update.FileManifest a2;
			checkType(l,3,out a2);
			System.Action<Hugula.Loader.LoadingEventArg> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			System.Action<System.Boolean> a4;
			LuaDelegation.checkDelegate(l,5,out a4);
			var ret=self.AddFirstManifestTask(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddDiffManifestTask(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			Hugula.Update.FileManifest a1;
			checkType(l,2,out a1);
			Hugula.Update.FileManifest a2;
			checkType(l,3,out a2);
			System.Action<Hugula.Loader.LoadingEventArg> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			System.Action<System.Boolean> a4;
			LuaDelegation.checkDelegate(l,5,out a4);
			var ret=self.AddDiffManifestTask(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddBackgroundManifestTask(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			Hugula.Update.FileManifest a1;
			checkType(l,2,out a1);
			System.Action<Hugula.Loader.LoadingEventArg> a2;
			LuaDelegation.checkDelegate(l,3,out a2);
			System.Action<System.Boolean> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			var ret=self.AddBackgroundManifestTask(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddManualManifestTask(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			Hugula.Update.FileManifest a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			System.Action<Hugula.Loader.LoadingEventArg> a3;
			LuaDelegation.checkDelegate(l,4,out a3);
			System.Action<System.Boolean> a4;
			LuaDelegation.checkDelegate(l,5,out a4);
			var ret=self.AddManualManifestTask(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Suspend(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			self.Suspend();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Begin(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			self.Begin();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Dispose_s(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload.Dispose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_hosts(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hosts);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_hosts(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			System.String[] v;
			checkArray(l,2,out v);
			self.hosts=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_loadingCount(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.loadingCount);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_loadingCount(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.loadingCount=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onNetSateChange(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			System.Action<Hugula.Update.BackGroundDownload> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onNetSateChange=v;
			else if(op==1) self.onNetSateChange+=v;
			else if(op==2) self.onNetSateChange-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_alwaysDownLoad(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.alwaysDownLoad);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_alwaysDownLoad(IntPtr l) {
		try {
			Hugula.Update.BackGroundDownload self=(Hugula.Update.BackGroundDownload)checkSelf(l);
			bool v;
			checkType(l,2,out v);
			self.alwaysDownLoad=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_carrierDataNetwork(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.BackGroundDownload.carrierDataNetwork);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_carrierDataNetwork(IntPtr l) {
		try {
			bool v;
			checkType(l,2,out v);
			Hugula.Update.BackGroundDownload.carrierDataNetwork=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.BackGroundDownload.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Update.BackGroundDownload");
		addMember(l,AddFirstManifestTask);
		addMember(l,AddDiffManifestTask);
		addMember(l,AddBackgroundManifestTask);
		addMember(l,AddManualManifestTask);
		addMember(l,Suspend);
		addMember(l,Begin);
		addMember(l,Dispose_s);
		addMember(l,"hosts",get_hosts,set_hosts,true);
		addMember(l,"loadingCount",get_loadingCount,set_loadingCount,true);
		addMember(l,"onNetSateChange",null,set_onNetSateChange,true);
		addMember(l,"alwaysDownLoad",get_alwaysDownLoad,set_alwaysDownLoad,true);
		addMember(l,"carrierDataNetwork",get_carrierDataNetwork,set_carrierDataNetwork,false);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Update.BackGroundDownload),typeof(UnityEngine.MonoBehaviour));
	}
}
