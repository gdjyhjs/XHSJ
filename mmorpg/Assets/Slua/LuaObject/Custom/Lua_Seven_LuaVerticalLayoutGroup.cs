using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_LuaVerticalLayoutGroup : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onRectTransformDimensionsChangeEndFn(IntPtr l) {
		try {
			Seven.LuaVerticalLayoutGroup self=(Seven.LuaVerticalLayoutGroup)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onRectTransformDimensionsChangeEndFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onRectTransformDimensionsChangeEndFn(IntPtr l) {
		try {
			Seven.LuaVerticalLayoutGroup self=(Seven.LuaVerticalLayoutGroup)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onRectTransformDimensionsChangeEndFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.LuaVerticalLayoutGroup");
		addMember(l,"onRectTransformDimensionsChangeEndFn",get_onRectTransformDimensionsChangeEndFn,set_onRectTransformDimensionsChangeEndFn,true);
		createTypeMetatable(l,null, typeof(Seven.LuaVerticalLayoutGroup),typeof(UnityEngine.UI.VerticalLayoutGroup));
	}
}
