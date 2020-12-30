using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UnityEngine_UI_LoopHorizontalScrollRect : LuaObject {
	static public void reg(IntPtr l) {
		getTypeTable(l,"UnityEngine.UI.LoopHorizontalScrollRect");
		createTypeMetatable(l,null, typeof(UnityEngine.UI.LoopHorizontalScrollRect),typeof(UnityEngine.UI.LoopScrollRect));
	}
}
