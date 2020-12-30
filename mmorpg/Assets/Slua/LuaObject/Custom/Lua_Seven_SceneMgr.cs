using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_SceneMgr : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetActiveScene_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(matchType(l,argc,1,typeof(string))){
				System.String a1;
				checkType(l,1,out a1);
				var ret=Seven.SceneMgr.SetActiveScene(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(matchType(l,argc,1,typeof(UnityEngine.SceneManagement.Scene))){
				UnityEngine.SceneManagement.Scene a1;
				checkValueType(l,1,out a1);
				var ret=Seven.SceneMgr.SetActiveScene(a1);
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.SceneMgr");
		addMember(l,SetActiveScene_s);
		createTypeMetatable(l,null, typeof(Seven.SceneMgr));
	}
}
