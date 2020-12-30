using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_UnityEngine_UI_SImage : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetSprite(IntPtr l) {
		try {
			UnityEngine.UI.SImage self=(UnityEngine.UI.SImage)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			SLua.LuaFunction a3;
			checkType(l,4,out a3);
			self.SetSprite(a1,a2,a3);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ClearATexList_s(IntPtr l) {
		try {
			UnityEngine.UI.SImage.ClearATexList();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_alphaTex(IntPtr l) {
		try {
			UnityEngine.UI.SImage self=(UnityEngine.UI.SImage)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.alphaTex);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_alphaTex(IntPtr l) {
		try {
			UnityEngine.UI.SImage self=(UnityEngine.UI.SImage)checkSelf(l);
			UnityEngine.Texture v;
			checkType(l,2,out v);
			self.alphaTex=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"UnityEngine.UI.SImage");
		addMember(l,SetSprite);
		addMember(l,ClearATexList_s);
		addMember(l,"alphaTex",get_alphaTex,set_alphaTex,true);
		createTypeMetatable(l,null, typeof(UnityEngine.UI.SImage),typeof(UnityEngine.UI.Image));
	}
}
