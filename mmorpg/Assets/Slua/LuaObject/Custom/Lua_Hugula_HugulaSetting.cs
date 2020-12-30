using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_HugulaSetting : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.HugulaSetting o;
			o=new Hugula.HugulaSetting();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AddVariant(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.AddVariant(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ContainsVariant(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.ContainsVariant(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_httpVerHostRelease(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.httpVerHostRelease);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_httpVerHostRelease(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.httpVerHostRelease=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_httpVerHostDev(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.httpVerHostDev);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_httpVerHostDev(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.httpVerHostDev=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_inclusionVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.inclusionVariants);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_inclusionVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			self.inclusionVariants=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_allVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.allVariants);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_allVariants(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			self.allVariants=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_spliteExtensionFolder(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.spliteExtensionFolder);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_compressStreamingAssets(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.compressStreamingAssets);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_httpVerHost(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.httpVerHost);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_appendCrcToFile(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.appendCrcToFile);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_backupResType(IntPtr l) {
		try {
			Hugula.HugulaSetting self=(Hugula.HugulaSetting)checkSelf(l);
			pushValue(l,true);
			pushEnum(l,(int)self.backupResType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.HugulaSetting.instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.HugulaSetting");
		addMember(l,AddVariant);
		addMember(l,ContainsVariant);
		addMember(l,"httpVerHostRelease",get_httpVerHostRelease,set_httpVerHostRelease,true);
		addMember(l,"httpVerHostDev",get_httpVerHostDev,set_httpVerHostDev,true);
		addMember(l,"inclusionVariants",get_inclusionVariants,set_inclusionVariants,true);
		addMember(l,"allVariants",get_allVariants,set_allVariants,true);
		addMember(l,"spliteExtensionFolder",get_spliteExtensionFolder,null,true);
		addMember(l,"compressStreamingAssets",get_compressStreamingAssets,null,true);
		addMember(l,"httpVerHost",get_httpVerHost,null,true);
		addMember(l,"appendCrcToFile",get_appendCrcToFile,null,true);
		addMember(l,"backupResType",get_backupResType,null,true);
		addMember(l,"instance",get_instance,null,false);
		createTypeMetatable(l,constructor, typeof(Hugula.HugulaSetting),typeof(UnityEngine.ScriptableObject));
	}
}
