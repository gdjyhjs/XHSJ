using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Update_CrcCheck : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckUriCrc_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			var ret=Hugula.Update.CrcCheck.CheckUriCrc(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetLocalFileCrc_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.UInt32 a2;
			var ret=Hugula.Update.CrcCheck.GetLocalFileCrc(a1,out a2);
			pushValue(l,true);
			pushValue(l,ret);
			pushValue(l,a2);
			return 3;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Update.CrcCheck");
		addMember(l,CheckUriCrc_s);
		addMember(l,GetLocalFileCrc_s);
		createTypeMetatable(l,null, typeof(Hugula.Update.CrcCheck));
	}
}
