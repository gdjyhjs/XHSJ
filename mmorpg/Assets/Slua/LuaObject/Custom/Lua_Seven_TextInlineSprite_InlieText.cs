using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_TextInlineSprite_InlieText : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_OnHrefClickFn(IntPtr l) {
		try {
			Seven.TextInlineSprite.InlieText self=(Seven.TextInlineSprite.InlieText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.OnHrefClickFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnHrefClickFn(IntPtr l) {
		try {
			Seven.TextInlineSprite.InlieText self=(Seven.TextInlineSprite.InlieText)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.OnHrefClickFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_OnTextClickFn(IntPtr l) {
		try {
			Seven.TextInlineSprite.InlieText self=(Seven.TextInlineSprite.InlieText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.OnTextClickFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnTextClickFn(IntPtr l) {
		try {
			Seven.TextInlineSprite.InlieText self=(Seven.TextInlineSprite.InlieText)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.OnTextClickFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.TextInlineSprite.InlieText");
		addMember(l,"OnHrefClickFn",get_OnHrefClickFn,set_OnHrefClickFn,true);
		addMember(l,"OnTextClickFn",get_OnTextClickFn,set_OnTextClickFn,true);
		createTypeMetatable(l,null, typeof(Seven.TextInlineSprite.InlieText),typeof(UnityEngine.UI.Text));
	}
}
