using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_TextInlineSprite_InlieSpriteText : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_m_AnimSpriteInfor(IntPtr l) {
		try {
			Seven.TextInlineSprite.InlieSpriteText self=(Seven.TextInlineSprite.InlieSpriteText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.m_AnimSpriteInfor);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_m_AnimSpriteInfor(IntPtr l) {
		try {
			Seven.TextInlineSprite.InlieSpriteText self=(Seven.TextInlineSprite.InlieSpriteText)checkSelf(l);
			System.Collections.Generic.List<Seven.TextInlineSprite.InlineSpriteInfor[]> v;
			checkType(l,2,out v);
			self.m_AnimSpriteInfor=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_OnHrefClickFn(IntPtr l) {
		try {
			Seven.TextInlineSprite.InlieSpriteText self=(Seven.TextInlineSprite.InlieSpriteText)checkSelf(l);
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
			Seven.TextInlineSprite.InlieSpriteText self=(Seven.TextInlineSprite.InlieSpriteText)checkSelf(l);
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
			Seven.TextInlineSprite.InlieSpriteText self=(Seven.TextInlineSprite.InlieSpriteText)checkSelf(l);
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
			Seven.TextInlineSprite.InlieSpriteText self=(Seven.TextInlineSprite.InlieSpriteText)checkSelf(l);
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
		getTypeTable(l,"Seven.TextInlineSprite.InlieSpriteText");
		addMember(l,"m_AnimSpriteInfor",get_m_AnimSpriteInfor,set_m_AnimSpriteInfor,true);
		addMember(l,"OnHrefClickFn",get_OnHrefClickFn,set_OnHrefClickFn,true);
		addMember(l,"OnTextClickFn",get_OnTextClickFn,set_OnTextClickFn,true);
		createTypeMetatable(l,null, typeof(Seven.TextInlineSprite.InlieSpriteText),typeof(UnityEngine.UI.Text));
	}
}
