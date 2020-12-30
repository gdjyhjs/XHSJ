using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Update_FileManifestOptions : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_StreamingAssetsPriority(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.FileManifestOptions.StreamingAssetsPriority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_FirstLoadPriority(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.FileManifestOptions.FirstLoadPriority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_AutoHotPriority(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.FileManifestOptions.AutoHotPriority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_UserPriority(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.FileManifestOptions.UserPriority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_ManualPriority(IntPtr l) {
		try {
			pushValue(l,true);
			pushValue(l,Hugula.Update.FileManifestOptions.ManualPriority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Update.FileManifestOptions");
		addMember(l,"StreamingAssetsPriority",get_StreamingAssetsPriority,null,false);
		addMember(l,"FirstLoadPriority",get_FirstLoadPriority,null,false);
		addMember(l,"AutoHotPriority",get_AutoHotPriority,null,false);
		addMember(l,"UserPriority",get_UserPriority,null,false);
		addMember(l,"ManualPriority",get_ManualPriority,null,false);
		createTypeMetatable(l,null, typeof(Hugula.Update.FileManifestOptions));
	}
}
