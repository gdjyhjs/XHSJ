using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_LanguageService : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Seven.LanguageService o;
			o=new Seven.LanguageService();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int LoadContent(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			self.LoadContent();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetStringByKey(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetStringByKey(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Languages(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Languages);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Languages(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			System.Collections.Generic.List<Seven.LanguageInfo> v;
			checkType(l,2,out v);
			self.Languages=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_LanguageNames(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.LanguageNames);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_LanguageNames(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			System.Collections.Generic.List<System.String> v;
			checkType(l,2,out v);
			self.LanguageNames=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Instance(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Seven.LanguageService.Instance);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Files(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Files);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Files(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			List<System.String> v;
			checkType(l,2,out v);
			self.Files=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_StringsByFile(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.StringsByFile);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_StringsByFile(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			Dictionary<System.String,Dictionary<System.String,System.String>> v;
			checkType(l,2,out v);
			self.StringsByFile=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Strings(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Strings);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Strings(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			Dictionary<System.String,System.String> v;
			checkType(l,2,out v);
			self.Strings=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Language(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Language);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Language(IntPtr l) {
		try {
			Seven.LanguageService self=(Seven.LanguageService)checkSelf(l);
			Seven.LanguageInfo v;
			checkType(l,2,out v);
			self.Language=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.LanguageService");
		addMember(l,LoadContent);
		addMember(l,GetStringByKey);
		addMember(l,"Languages",get_Languages,set_Languages,true);
		addMember(l,"LanguageNames",get_LanguageNames,set_LanguageNames,true);
		addMember(l,"Instance",get_Instance,null,false);
		addMember(l,"Files",get_Files,set_Files,true);
		addMember(l,"StringsByFile",get_StringsByFile,set_StringsByFile,true);
		addMember(l,"Strings",get_Strings,set_Strings,true);
		addMember(l,"Language",get_Language,set_Language,true);
		createTypeMetatable(l,constructor, typeof(Seven.LanguageService));
	}
}
