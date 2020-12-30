using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Seven_GVoiceComponent : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int SetMaxMessageLength(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			System.Int32 a1;
			checkType(l,2,out a1);
			var ret=self.SetMaxMessageLength(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int RegisterGVoice(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			var ret=self.RegisterGVoice();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_btnStartRecord(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			var ret=self.Click_btnStartRecord();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_btnStopRecord(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			var ret=self.Click_btnStopRecord();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_btnUploadFile(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			var ret=self.Click_btnUploadFile();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_btnDownloadFile(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				var ret=self.Click_btnDownloadFile();
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==3){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				System.String a2;
				checkType(l,3,out a2);
				var ret=self.Click_btnDownloadFile(a1,a2);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_btnPlayReocrdFile(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				var ret=self.Click_btnPlayReocrdFile();
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==2){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.Click_btnPlayReocrdFile(a1);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_btnStopPlayRecordFile(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			var ret=self.Click_btnStopPlayRecordFile();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_btnSpeechToText(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				var ret=self.Click_btnSpeechToText();
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==2){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.Click_btnSpeechToText(a1);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Click_getVoiceLength(IntPtr l) {
		try {
			int argc = LuaDLL.lua_gettop(l);
			if(argc==1){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				var ret=self.Click_getVoiceLength();
				pushValue(l,true);
				pushValue(l,ret);
				return 2;
			}
			else if(argc==2){
				Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
				System.String a1;
				checkType(l,2,out a1);
				var ret=self.Click_getVoiceLength(a1);
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
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_appID(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.appID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_appID(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.appID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_appKey(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.appKey);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_appKey(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.appKey=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_openID(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.openID);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_openID(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			System.String v;
			checkType(l,2,out v);
			self.openID=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onApplyMessagekeyCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onApplyMessagekeyCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onApplyMessagekeyCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onApplyMessagekeyCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onUploadReccordFileCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onUploadReccordFileCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onUploadReccordFileCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onUploadReccordFileCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onDownloadRecordFileCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onDownloadRecordFileCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onDownloadRecordFileCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onDownloadRecordFileCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onPlayRecordFilCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onPlayRecordFilCompleteFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onPlayRecordFilCompleteFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onPlayRecordFilCompleteFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_onSpeechToTextFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.onSpeechToTextFn);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_onSpeechToTextFn(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			SLua.LuaFunction v;
			checkType(l,2,out v);
			self.onSpeechToTextFn=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_get_voice_sound_wave(IntPtr l) {
		try {
			Seven.GVoiceComponent self=(Seven.GVoiceComponent)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.get_voice_sound_wave);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Seven.GVoiceComponent");
		addMember(l,SetMaxMessageLength);
		addMember(l,RegisterGVoice);
		addMember(l,Click_btnStartRecord);
		addMember(l,Click_btnStopRecord);
		addMember(l,Click_btnUploadFile);
		addMember(l,Click_btnDownloadFile);
		addMember(l,Click_btnPlayReocrdFile);
		addMember(l,Click_btnStopPlayRecordFile);
		addMember(l,Click_btnSpeechToText);
		addMember(l,Click_getVoiceLength);
		addMember(l,"appID",get_appID,set_appID,true);
		addMember(l,"appKey",get_appKey,set_appKey,true);
		addMember(l,"openID",get_openID,set_openID,true);
		addMember(l,"onApplyMessagekeyCompleteFn",get_onApplyMessagekeyCompleteFn,set_onApplyMessagekeyCompleteFn,true);
		addMember(l,"onUploadReccordFileCompleteFn",get_onUploadReccordFileCompleteFn,set_onUploadReccordFileCompleteFn,true);
		addMember(l,"onDownloadRecordFileCompleteFn",get_onDownloadRecordFileCompleteFn,set_onDownloadRecordFileCompleteFn,true);
		addMember(l,"onPlayRecordFilCompleteFn",get_onPlayRecordFilCompleteFn,set_onPlayRecordFilCompleteFn,true);
		addMember(l,"onSpeechToTextFn",get_onSpeechToTextFn,set_onSpeechToTextFn,true);
		addMember(l,"get_voice_sound_wave",get_get_voice_sound_wave,null,true);
		createTypeMetatable(l,null, typeof(Seven.GVoiceComponent),typeof(UnityEngine.MonoBehaviour));
	}
}
