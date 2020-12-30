using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_ResourcesLoader : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadLuaTable_s(IntPtr l) {
		try {
			SLua.LuaTable a1;
			checkType(l,1,out a1);
			System.Action<System.Boolean> a2;
			LuaDelegation.checkDelegate(l,2,out a2);
			System.Action<Hugula.Loader.LoadingEventArg> a3;
			LuaDelegation.checkDelegate(l,3,out a3);
			System.Int32 a4;
			checkType(l,4,out a4);
			Hugula.Loader.ResourcesLoader.LoadLuaTable(a1,a2,a3,a4);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadGroupAsset_s(IntPtr l) {
		try {
			Hugula.Loader.BundleGroundQueue a1;
			checkType(l,1,out a1);
			Hugula.Loader.ResourcesLoader.LoadGroupAsset(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadAssetCoroutine_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Type a3;
			checkType(l,3,out a3);
			System.Int32 a4;
			checkType(l,4,out a4);
			var ret=Hugula.Loader.ResourcesLoader.LoadAssetCoroutine(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadAsset_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				Hugula.Loader.CRequest a1;
				checkType(l,1,out a1);
				System.Boolean a2;
				checkType(l,2,out a2);
				var ret=Hugula.Loader.ResourcesLoader.LoadAsset(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==6){
				System.String a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				System.Type a3;
				checkType(l,3,out a3);
				System.Action<Hugula.Loader.CRequest> a4;
				LuaDelegation.checkDelegate(l,4,out a4);
				System.Action<Hugula.Loader.CRequest> a5;
				LuaDelegation.checkDelegate(l,5,out a5);
				System.Int32 a6;
				checkType(l,6,out a6);
				Hugula.Loader.ResourcesLoader.LoadAsset(a1,a2,a3,a4,a5,a6);
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
	static public int HttpRequestCoroutine_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Object a2;
			checkType(l,2,out a2);
			System.Type a3;
			checkType(l,3,out a3);
			var ret=Hugula.Loader.ResourcesLoader.HttpRequestCoroutine(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int HttpRequest_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				Hugula.Loader.CRequest a1;
				checkType(l,1,out a1);
				System.Boolean a2;
				checkType(l,2,out a2);
				var ret=Hugula.Loader.ResourcesLoader.HttpRequest(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==6){
				System.String a1;
				checkType(l,1,out a1);
				System.Object a2;
				checkType(l,2,out a2);
				System.Type a3;
				checkType(l,3,out a3);
				System.Action<Hugula.Loader.CRequest> a4;
				LuaDelegation.checkDelegate(l,4,out a4);
				System.Action<Hugula.Loader.CRequest> a5;
				LuaDelegation.checkDelegate(l,5,out a5);
				Hugula.Loader.UriGroup a6;
				checkType(l,6,out a6);
				Hugula.Loader.ResourcesLoader.HttpRequest(a1,a2,a3,a4,a5,a6);
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
	static public int WWWRequest_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==2){
				Hugula.Loader.CRequest a1;
				checkType(l,1,out a1);
				System.Boolean a2;
				checkType(l,2,out a2);
				var ret=Hugula.Loader.ResourcesLoader.WWWRequest(a1,a2);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==6){
				System.String a1;
				checkType(l,1,out a1);
				System.Object a2;
				checkType(l,2,out a2);
				System.Type a3;
				checkType(l,3,out a3);
				System.Action<Hugula.Loader.CRequest> a4;
				LuaDelegation.checkDelegate(l,4,out a4);
				System.Action<Hugula.Loader.CRequest> a5;
				LuaDelegation.checkDelegate(l,5,out a5);
				Hugula.Loader.UriGroup a6;
				checkType(l,6,out a6);
				Hugula.Loader.ResourcesLoader.WWWRequest(a1,a2,a3,a4,a5,a6);
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
	static public int WWWRequestCoroutine_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.Object a2;
			checkType(l,2,out a2);
			System.Type a3;
			checkType(l,3,out a3);
			var ret=Hugula.Loader.ResourcesLoader.WWWRequestCoroutine(a1,a2,a3);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Initialize_s(IntPtr l) {
		try {
			Hugula.Loader.ResourcesLoader.Initialize();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_asyncSize(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ResourcesLoader.asyncSize);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_asyncSize(IntPtr l) {
		try {
			System.UInt32 v;
			checkType(l,2,out v);
			Hugula.Loader.ResourcesLoader.asyncSize=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_maxLoading(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ResourcesLoader.maxLoading);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_maxLoading(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			Hugula.Loader.ResourcesLoader.maxLoading=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_bundleMax(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ResourcesLoader.bundleMax);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_bundleMax(IntPtr l) {
		try {
			System.Int32 v;
			checkType(l,2,out v);
			Hugula.Loader.ResourcesLoader.bundleMax=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_BundleLoadBreakMilliSeconds(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ResourcesLoader.BundleLoadBreakMilliSeconds);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_BundleLoadBreakMilliSeconds(IntPtr l) {
		try {
			System.Single v;
			checkType(l,2,out v);
			Hugula.Loader.ResourcesLoader.BundleLoadBreakMilliSeconds=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnAllComplete(IntPtr l) {
		try {
			System.Action v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) Hugula.Loader.ResourcesLoader.OnAllComplete=v;
			else if(op==1) Hugula.Loader.ResourcesLoader.OnAllComplete+=v;
			else if(op==2) Hugula.Loader.ResourcesLoader.OnAllComplete-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnProgress(IntPtr l) {
		try {
			System.Action<Hugula.Loader.LoadingEventArg> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) Hugula.Loader.ResourcesLoader.OnProgress=v;
			else if(op==1) Hugula.Loader.ResourcesLoader.OnProgress+=v;
			else if(op==2) Hugula.Loader.ResourcesLoader.OnProgress-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnAssetBundleComplete(IntPtr l) {
		try {
			System.Action<Hugula.Loader.CRequest,UnityEngine.AssetBundle> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) Hugula.Loader.ResourcesLoader.OnAssetBundleComplete=v;
			else if(op==1) Hugula.Loader.ResourcesLoader.OnAssetBundleComplete+=v;
			else if(op==2) Hugula.Loader.ResourcesLoader.OnAssetBundleComplete-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnAssetBundleErr(IntPtr l) {
		try {
			System.Action<Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) Hugula.Loader.ResourcesLoader.OnAssetBundleErr=v;
			else if(op==1) Hugula.Loader.ResourcesLoader.OnAssetBundleErr+=v;
			else if(op==2) Hugula.Loader.ResourcesLoader.OnAssetBundleErr-=v;
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
			pushValue(l,Hugula.Loader.ResourcesLoader.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.ResourcesLoader");
		addMember(l,LoadLuaTable_s);
		addMember(l,LoadGroupAsset_s);
		addMember(l,LoadAssetCoroutine_s);
		addMember(l,LoadAsset_s);
		addMember(l,HttpRequestCoroutine_s);
		addMember(l,HttpRequest_s);
		addMember(l,WWWRequest_s);
		addMember(l,WWWRequestCoroutine_s);
		addMember(l,Initialize_s);
		addMember(l,"asyncSize",get_asyncSize,set_asyncSize,false);
		addMember(l,"maxLoading",get_maxLoading,set_maxLoading,false);
		addMember(l,"bundleMax",get_bundleMax,set_bundleMax,false);
		addMember(l,"BundleLoadBreakMilliSeconds",get_BundleLoadBreakMilliSeconds,set_BundleLoadBreakMilliSeconds,false);
		addMember(l,"OnAllComplete",null,set_OnAllComplete,false);
		addMember(l,"OnProgress",null,set_OnProgress,false);
		addMember(l,"OnAssetBundleComplete",null,set_OnAssetBundleComplete,false);
		addMember(l,"OnAssetBundleErr",null,set_OnAssetBundleErr,false);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Loader.ResourcesLoader),typeof(UnityEngine.MonoBehaviour));
	}
}
