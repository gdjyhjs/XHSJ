using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_STextureManage : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Seven.STextureManage o;
			o=new Seven.STextureManage();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Load(IntPtr l) {
		try {
			Seven.STextureManage self=(Seven.STextureManage)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			System.String a2;
			checkType(l,3,out a2);
			SLua.LuaFunction a3;
			checkType(l,4,out a3);
			SLua.LuaFunction a4;
			checkType(l,5,out a4);
			var ret=self.Load(a1,a2,a3,a4);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DeleteAtlas(IntPtr l) {
		try {
			Seven.STextureManage self=(Seven.STextureManage)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			self.DeleteAtlas(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetBigImg(IntPtr l) {
		try {
			Seven.STextureManage self=(Seven.STextureManage)checkSelf(l);
			System.String a1;
			checkType(l,2,out a1);
			var ret=self.GetBigImg(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Clear(IntPtr l) {
		try {
			Seven.STextureManage self=(Seven.STextureManage)checkSelf(l);
			self.Clear();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int getInstance_s(IntPtr l) {
		try {
			var ret=Seven.STextureManage.getInstance();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.STextureManage");
		addMember(l,Load);
		addMember(l,DeleteAtlas);
		addMember(l,GetBigImg);
		addMember(l,Clear);
		addMember(l,getInstance_s);
		createTypeMetatable(l,constructor, typeof(Seven.STextureManage));
	}
}
