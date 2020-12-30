using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_LogicHelper : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int OnAssetsLoad_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			SLua.LuaTable a2;
			checkType(l,2,out a2);
			Hugula.LogicHelper.OnAssetsLoad(a1,a2);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.LogicHelper");
		addMember(l,OnAssetsLoad_s);
		createTypeMetatable(l,null, typeof(Hugula.LogicHelper));
	}
}
