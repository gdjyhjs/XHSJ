using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_UI_MessageBoxButton : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.UI.MessageBoxButton o;
			o=new Hugula.UI.MessageBoxButton();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_btnText(IntPtr l) {
		try {
			Hugula.UI.MessageBoxButton self=(Hugula.UI.MessageBoxButton)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.btnText);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_btnText(IntPtr l) {
		try {
			Hugula.UI.MessageBoxButton self=(Hugula.UI.MessageBoxButton)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.btnText=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onClick(IntPtr l) {
		try {
			Hugula.UI.MessageBoxButton self=(Hugula.UI.MessageBoxButton)checkSelf(l);
			UnityEngine.Events.UnityAction v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.onClick=v;
			else if(op==1) self.onClick+=v;
			else if(op==2) self.onClick-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.UI.MessageBoxButton");
		addMember(l,"btnText",get_btnText,set_btnText,true);
		addMember(l,"onClick",null,set_onClick,true);
		createTypeMetatable(l,constructor, typeof(Hugula.UI.MessageBoxButton));
	}
}
