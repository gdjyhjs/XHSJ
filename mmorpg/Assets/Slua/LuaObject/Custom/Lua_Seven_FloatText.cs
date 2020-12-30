using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_FloatText : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_target(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.target);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_target(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.Transform v;
			checkType(l,2,out v);
			self.target=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_duration(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.duration);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_duration(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.duration=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_max_offset(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.max_offset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_max_offset(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.max_offset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_min_offset(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.min_offset);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_min_offset(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.min_offset=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_start_pos_x(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.start_pos_x);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_start_pos_x(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.start_pos_x=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_end_pos_x(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.end_pos_x);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_end_pos_x(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.end_pos_x=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_offset_x(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.offset_x);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_offset_x(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.AnimationCurve v;
			checkType(l,2,out v);
			self.offset_x=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_start_pos_y(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.start_pos_y);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_start_pos_y(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.start_pos_y=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_end_pos_y(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.end_pos_y);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_end_pos_y(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.end_pos_y=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_offset_y(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.offset_y);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_offset_y(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.AnimationCurve v;
			checkType(l,2,out v);
			self.offset_y=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_start_sca(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.start_sca);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_start_sca(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.start_sca=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_end_sca(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.end_sca);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_end_sca(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.Vector3 v;
			checkType(l,2,out v);
			self.end_sca=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_scale(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.scale);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_scale(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.AnimationCurve v;
			checkType(l,2,out v);
			self.scale=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_start_alp(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.start_alp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_start_alp(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.start_alp=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_end_alp(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.end_alp);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_end_alp(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			System.Single v;
			checkType(l,2,out v);
			self.end_alp=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_alpha(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.alpha);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_alpha(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			UnityEngine.AnimationCurve v;
			checkType(l,2,out v);
			self.alpha=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_end_fun(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.end_fun);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_end_fun(IntPtr l) {
		try {
			Seven.FloatText self=(Seven.FloatText)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.end_fun=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.FloatText");
		addMember(l,"target",get_target,set_target,true);
		addMember(l,"duration",get_duration,set_duration,true);
		addMember(l,"max_offset",get_max_offset,set_max_offset,true);
		addMember(l,"min_offset",get_min_offset,set_min_offset,true);
		addMember(l,"start_pos_x",get_start_pos_x,set_start_pos_x,true);
		addMember(l,"end_pos_x",get_end_pos_x,set_end_pos_x,true);
		addMember(l,"offset_x",get_offset_x,set_offset_x,true);
		addMember(l,"start_pos_y",get_start_pos_y,set_start_pos_y,true);
		addMember(l,"end_pos_y",get_end_pos_y,set_end_pos_y,true);
		addMember(l,"offset_y",get_offset_y,set_offset_y,true);
		addMember(l,"start_sca",get_start_sca,set_start_sca,true);
		addMember(l,"end_sca",get_end_sca,set_end_sca,true);
		addMember(l,"scale",get_scale,set_scale,true);
		addMember(l,"start_alp",get_start_alp,set_start_alp,true);
		addMember(l,"end_alp",get_end_alp,set_end_alp,true);
		addMember(l,"alpha",get_alpha,set_alpha,true);
		addMember(l,"end_fun",get_end_fun,set_end_fun,true);
		createTypeMetatable(l,null, typeof(Seven.FloatText),typeof(UnityEngine.MonoBehaviour));
	}
}
