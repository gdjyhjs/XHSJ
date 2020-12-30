using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_LanguageInfo : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			Seven.LanguageInfo o;
			if(argc==1){
				o=new Seven.LanguageInfo();
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			else if(argc==2){
				System.String a1;
				checkType(l,2,out a1);
				o=new Seven.LanguageInfo(a1);
				pushValue(l,true);
				pushValue(l,o);
				return 2;
			}
			return error(l,"New object failed.");
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_Name(IntPtr l) {
		try {
			Seven.LanguageInfo self=(Seven.LanguageInfo)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.Name);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_Name(IntPtr l) {
		try {
			Seven.LanguageInfo self=(Seven.LanguageInfo)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.Name=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_English(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Seven.LanguageInfo.English);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.LanguageInfo");
		addMember(l,"Name",get_Name,set_Name,true);
		addMember(l,"English",get_English,null,false);
		createTypeMetatable(l,constructor, typeof(Seven.LanguageInfo));
	}
}
