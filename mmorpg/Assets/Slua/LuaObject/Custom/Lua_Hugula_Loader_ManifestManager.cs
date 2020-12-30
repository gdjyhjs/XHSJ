using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_ManifestManager : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckABIsDone_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.ManifestManager.CheckABIsDone(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckIsInFileManifest_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.ManifestManager.CheckIsInFileManifest(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadUpdateFileManifest_s(IntPtr l) {
		try {
			System.Action a1;
			LuaDelegation.checkDelegate(l,1,out a1);
			Hugula.Loader.ManifestManager.LoadUpdateFileManifest(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadFileManifest_s(IntPtr l) {
		try {
			System.Action a1;
			LuaDelegation.checkDelegate(l,1,out a1);
			Hugula.Loader.ManifestManager.LoadFileManifest(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckClearCacheFiles_s(IntPtr l) {
		try {
			System.Action<Hugula.Loader.LoadingEventArg> a1;
			LuaDelegation.checkDelegate(l,1,out a1);
			System.Action a2;
			LuaDelegation.checkDelegate(l,2,out a2);
			Hugula.Loader.ManifestManager.CheckClearCacheFiles(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetVariantName_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.ManifestManager.GetVariantName(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckNeedUncompressStreamingAssets_s(IntPtr l) {
		try {
			var ret=Hugula.Loader.ManifestManager.CheckNeedUncompressStreamingAssets();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CompleteUncompressStreamingAssets_s(IntPtr l) {
		try {
			Hugula.Loader.ManifestManager.CompleteUncompressStreamingAssets();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckFirstLoad_s(IntPtr l) {
		try {
			var ret=Hugula.Loader.ManifestManager.CheckFirstLoad();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FinishFirstLoad_s(IntPtr l) {
		try {
			Hugula.Loader.ManifestManager.FinishFirstLoad();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckNeedBackgroundLoad_s(IntPtr l) {
		try {
			var ret=Hugula.Loader.ManifestManager.CheckNeedBackgroundLoad();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FinishBackgroundLoad_s(IntPtr l) {
		try {
			Hugula.Loader.ManifestManager.FinishBackgroundLoad();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckNeedExtensionsFolder_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.ManifestManager.CheckNeedExtensionsFolder(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int FinishExtensionsFolder_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			Hugula.Loader.ManifestManager.FinishExtensionsFolder(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_fileManifest(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ManifestManager.fileManifest);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_fileManifest(IntPtr l) {
		try {
			Hugula.Update.FileManifest v;
			checkType(l,2,out v);
			Hugula.Loader.ManifestManager.fileManifest=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_updateFileManifest(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ManifestManager.updateFileManifest);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_updateFileManifest(IntPtr l) {
		try {
			Hugula.Update.FileManifest v;
			checkType(l,2,out v);
			Hugula.Loader.ManifestManager.updateFileManifest=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_bundlesWithVariant(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ManifestManager.bundlesWithVariant);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_bundlesWithVariant(IntPtr l) {
		try {
			System.String[] v;
			checkArray(l,2,out v);
			Hugula.Loader.ManifestManager.bundlesWithVariant=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ActiveVariants(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Loader.ManifestManager.ActiveVariants);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_ActiveVariants(IntPtr l) {
		try {
			System.String[] v;
			checkArray(l,2,out v);
			Hugula.Loader.ManifestManager.ActiveVariants=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.ManifestManager");
		addMember(l,CheckABIsDone_s);
		addMember(l,CheckIsInFileManifest_s);
		addMember(l,LoadUpdateFileManifest_s);
		addMember(l,LoadFileManifest_s);
		addMember(l,CheckClearCacheFiles_s);
		addMember(l,GetVariantName_s);
		addMember(l,CheckNeedUncompressStreamingAssets_s);
		addMember(l,CompleteUncompressStreamingAssets_s);
		addMember(l,CheckFirstLoad_s);
		addMember(l,FinishFirstLoad_s);
		addMember(l,CheckNeedBackgroundLoad_s);
		addMember(l,FinishBackgroundLoad_s);
		addMember(l,CheckNeedExtensionsFolder_s);
		addMember(l,FinishExtensionsFolder_s);
		addMember(l,"fileManifest",get_fileManifest,set_fileManifest,false);
		addMember(l,"updateFileManifest",get_updateFileManifest,set_updateFileManifest,false);
		addMember(l,"bundlesWithVariant",get_bundlesWithVariant,set_bundlesWithVariant,false);
		addMember(l,"ActiveVariants",get_ActiveVariants,set_ActiveVariants,false);
		createTypeMetatable(l,null, typeof(Hugula.Loader.ManifestManager));
	}
}
