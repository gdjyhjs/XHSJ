using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_UI_MessageBoxInfo : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.UI.MessageBoxInfo o;
			o=new Hugula.UI.MessageBoxInfo();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_text(IntPtr l) {
		try {
			Hugula.UI.MessageBoxInfo self=(Hugula.UI.MessageBoxInfo)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.text);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_text(IntPtr l) {
		try {
			Hugula.UI.MessageBoxInfo self=(Hugula.UI.MessageBoxInfo)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.text=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_caption(IntPtr l) {
		try {
			Hugula.UI.MessageBoxInfo self=(Hugula.UI.MessageBoxInfo)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.caption);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_caption(IntPtr l) {
		try {
			Hugula.UI.MessageBoxInfo self=(Hugula.UI.MessageBoxInfo)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.caption=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_btns(IntPtr l) {
		try {
			Hugula.UI.MessageBoxInfo self=(Hugula.UI.MessageBoxInfo)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.btns);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_btns(IntPtr l) {
		try {
			Hugula.UI.MessageBoxInfo self=(Hugula.UI.MessageBoxInfo)checkSelf(l);
			Hugula.UI.MessageBoxButton[] v;
			checkArray(l,2,out v);
			self.btns=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.UI.MessageBoxInfo");
		addMember(l,"text",get_text,set_text,true);
		addMember(l,"caption",get_caption,set_caption,true);
		addMember(l,"btns",get_btns,set_btns,true);
		createTypeMetatable(l,constructor, typeof(Hugula.UI.MessageBoxInfo));
	}
}
