using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Update_FileManifest : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Update.FileManifest o;
			o=new Hugula.Update.FileManifest();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckABIsDone(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.CheckABIsDone(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int AppendFileManifest(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			Hugula.Update.FileManifest a1;
			checkType(l,2,out a1);
			self.AppendFileManifest(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetVariants(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetVariants(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetAllDependencies(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetAllDependencies(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetDirectDependencies(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetDirectDependencies(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Clear(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_appNumVersion(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.appNumVersion);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_appNumVersion(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.appNumVersion=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_crc32(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.crc32);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_crc32(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			System.UInt32 v;
			checkType(l,2,out v);
			self.crc32=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_hasFirstLoad(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.hasFirstLoad);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_hasFirstLoad(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.hasFirstLoad=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Count(IntPtr l) {
		try {
			Hugula.Update.FileManifest self=(Hugula.Update.FileManifest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Count);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Update.FileManifest");
		addMember(l,CheckABIsDone);
		addMember(l,AppendFileManifest);
		addMember(l,GetVariants);
		addMember(l,GetAllDependencies);
		addMember(l,GetDirectDependencies);
		addMember(l,Clear);
		addMember(l,"appNumVersion",get_appNumVersion,set_appNumVersion,true);
		addMember(l,"crc32",get_crc32,set_crc32,true);
		addMember(l,"hasFirstLoad",get_hasFirstLoad,set_hasFirstLoad,true);
		addMember(l,"Count",get_Count,null,true);
		createTypeMetatable(l,constructor, typeof(Hugula.Update.FileManifest),typeof(UnityEngine.ScriptableObject));
	}
}
