using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UnityEngine_UI_LoopVerticalScrollRect : LuaObject {
	static public void reg(IntPtr l) {
		getTypeTable(l,"UnityEngine.UI.LoopVerticalScrollRect");
		createTypeMetatable(l,null, typeof(UnityEngine.UI.LoopVerticalScrollRect),typeof(UnityEngine.UI.LoopScrollRect));
	}
}
