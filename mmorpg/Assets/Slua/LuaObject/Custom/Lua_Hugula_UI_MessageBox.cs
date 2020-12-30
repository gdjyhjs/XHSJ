using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_UI_MessageBox : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Show_s(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==3){
				System.String a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				Hugula.UI.MessageBoxButton[] a3;
				checkArray(l,3,out a3);
				Hugula.UI.MessageBox.Show(a1,a2,a3);
				pushValue(l,true);
				return 1;
			}
			else if(argc==4){
				System.String a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				System.String a3;
				checkType(l,3,out a3);
				UnityEngine.Events.UnityAction a4;
				LuaDelegation.checkDelegate(l,4,out a4);
				Hugula.UI.MessageBox.Show(a1,a2,a3,a4);
				pushValue(l,true);
				return 1;
			}
			else if(argc==6){
				System.String a1;
				checkType(l,1,out a1);
				System.String a2;
				checkType(l,2,out a2);
				System.String a3;
				checkType(l,3,out a3);
				UnityEngine.Events.UnityAction a4;
				LuaDelegation.checkDelegate(l,4,out a4);
				System.String a5;
				checkType(l,5,out a5);
				UnityEngine.Events.UnityAction a6;
				LuaDelegation.checkDelegate(l,6,out a6);
				Hugula.UI.MessageBox.Show(a1,a2,a3,a4,a5,a6);
				pushValue(l,true);
				return 1;
			}
			pushValue(l,false);
			LuaDLL.lua_pushstring(l,"No matched override function to call");
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Destroy_s(IntPtr l) {
		try {
			Hugula.UI.MessageBox.Destroy();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Close_s(IntPtr l) {
		try {
			Hugula.UI.MessageBox.Close();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_text(IntPtr l) {
		try {
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
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
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
			UnityEngine.UI.Text v;
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
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
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
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
			UnityEngine.UI.Text v;
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
	static public int get_buttons(IntPtr l) {
		try {
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.buttons);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_buttons(IntPtr l) {
		try {
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
			UnityEngine.UI.Button[] v;
			checkArray(l,2,out v);
			self.buttons=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_buttonClose(IntPtr l) {
		try {
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.buttonClose);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_buttonClose(IntPtr l) {
		try {
			Hugula.UI.MessageBox self=(Hugula.UI.MessageBox)checkSelf(l);
			UnityEngine.UI.Button v;
			checkType(l,2,out v);
			self.buttonClose=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.UI.MessageBox");
		addMember(l,Show_s);
		addMember(l,Destroy_s);
		addMember(l,Close_s);
		addMember(l,"text",get_text,set_text,true);
		addMember(l,"caption",get_caption,set_caption,true);
		addMember(l,"buttons",get_buttons,set_buttons,true);
		addMember(l,"buttonClose",get_buttonClose,set_buttonClose,true);
		createTypeMetatable(l,null, typeof(Hugula.UI.MessageBox),typeof(UnityEngine.MonoBehaviour));
	}
}
