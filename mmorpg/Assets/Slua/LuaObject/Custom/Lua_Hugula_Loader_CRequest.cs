﻿using System;
using LuaInterface;
using SLua;
using System.Collections.Generic;
public class Lua_Hugula_Loader_CRequest : LuaObject {
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int constructor(IntPtr l) {
		try {
			Hugula.Loader.CRequest o;
			o=new Hugula.Loader.CRequest();
			pushValue(l,true);
			pushValue(l,o);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Dispose(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			self.Dispose();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DispatchComplete(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			self.DispatchComplete();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int DispatchEnd(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			self.DispatchEnd();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int ReleaseToPool(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			self.ReleaseToPool();
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int GetUDKeyURL_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.CRequest.GetUDKeyURL(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int CheckNeedUriGroup_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			var ret=Hugula.Loader.CRequest.CheckNeedUriGroup(a1);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Create_s(IntPtr l) {
		try {
			System.String a1;
			checkType(l,1,out a1);
			System.String a2;
			checkType(l,2,out a2);
			System.Type a3;
			checkType(l,3,out a3);
			System.Action<Hugula.Loader.CRequest> a4;
			LuaDelegation.checkDelegate(l,4,out a4);
			System.Action<Hugula.Loader.CRequest> a5;
			LuaDelegation.checkDelegate(l,5,out a5);
			System.Object a6;
			checkType(l,6,out a6);
			System.Boolean a7;
			checkType(l,7,out a7);
			var ret=Hugula.Loader.CRequest.Create(a1,a2,a3,a4,a5,a6,a7);
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Get_s(IntPtr l) {
		try {
			var ret=Hugula.Loader.CRequest.Get();
			pushValue(l,true);
			pushValue(l,ret);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int Release_s(IntPtr l) {
		try {
			Hugula.Loader.CRequest a1;
			checkType(l,1,out a1);
			Hugula.Loader.CRequest.Release(a1);
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_head(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.head);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_head(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Object v;
			checkType(l,2,out v);
			self.head=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_headers(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.headers);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_headers(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Collections.Generic.Dictionary<System.String,System.String> v;
			checkType(l,2,out v);
			self.headers=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_data(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.data);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_data(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Object v;
			checkType(l,2,out v);
			self.data=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_userData(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.userData);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_userData(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Object v;
			checkType(l,2,out v);
			self.userData=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnEnd(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Action<Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnEnd=v;
			else if(op==1) self.OnEnd+=v;
			else if(op==2) self.OnEnd-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_OnComplete(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Action<Hugula.Loader.CRequest> v;
			int op=LuaDelegation.checkDelegate(l,2,out v);
			if(op==0) self.OnComplete=v;
			else if(op==1) self.OnComplete+=v;
			else if(op==2) self.OnComplete-=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_async(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.async);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_async(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.async=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_priority(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.priority);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_priority(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.priority=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_index(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.index);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_index(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Int32 v;
			checkType(l,2,out v);
			self.index=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isAdditive(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isAdditive);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_isAdditive(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Boolean v;
			checkType(l,2,out v);
			self.isAdditive=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_relativeUrl(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.relativeUrl);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_relativeUrl(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.relativeUrl=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_assetBundleName(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.assetBundleName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_assetName(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.assetName);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_assetName(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.assetName=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_assetType(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.assetType);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_assetType(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			System.Type v;
			checkType(l,2,out v);
			self.assetType=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_isShared(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.isShared);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_url(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.url);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_key(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.key);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_keyHashCode(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.keyHashCode);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_udKey(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.udKey);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_udKey(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.udKey=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_udAssetKey(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.udAssetKey);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_udAssetKey(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			string v;
			checkType(l,2,out v);
			self.udAssetKey=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int get_uris(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			pushValue(l,true);
			pushValue(l,self.uris);
			return 2;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static public int set_uris(IntPtr l) {
		try {
			Hugula.Loader.CRequest self=(Hugula.Loader.CRequest)checkSelf(l);
			Hugula.Loader.UriGroup v;
			checkType(l,2,out v);
			self.uris=v;
			pushValue(l,true);
			return 1;
		}
		catch(Exception e) {
			return error(l,e);
		}
	}
	static public void reg(IntPtr l) {
		getTypeTable(l,"Hugula.Loader.CRequest");
		addMember(l,Dispose);
		addMember(l,DispatchComplete);
		addMember(l,DispatchEnd);
		addMember(l,ReleaseToPool);
		addMember(l,GetUDKeyURL_s);
		addMember(l,CheckNeedUriGroup_s);
		addMember(l,Create_s);
		addMember(l,Get_s);
		addMember(l,Release_s);
		addMember(l,"head",get_head,set_head,true);
		addMember(l,"headers",get_headers,set_headers,true);
		addMember(l,"data",get_data,set_data,true);
		addMember(l,"userData",get_userData,set_userData,true);
		addMember(l,"OnEnd",null,set_OnEnd,true);
		addMember(l,"OnComplete",null,set_OnComplete,true);
		addMember(l,"async",get_async,set_async,true);
		addMember(l,"priority",get_priority,set_priority,true);
		addMember(l,"index",get_index,set_index,true);
		addMember(l,"isAdditive",get_isAdditive,set_isAdditive,true);
		addMember(l,"relativeUrl",get_relativeUrl,set_relativeUrl,true);
		addMember(l,"assetBundleName",get_assetBundleName,null,true);
		addMember(l,"assetName",get_assetName,set_assetName,true);
		addMember(l,"assetType",get_assetType,set_assetType,true);
		addMember(l,"isShared",get_isShared,null,true);
		addMember(l,"url",get_url,null,true);
		addMember(l,"key",get_key,null,true);
		addMember(l,"keyHashCode",get_keyHashCode,null,true);
		addMember(l,"udKey",get_udKey,set_udKey,true);
		addMember(l,"udAssetKey",get_udAssetKey,set_udAssetKey,true);
		addMember(l,"uris",get_uris,set_uris,true);
		createTypeMetatable(l,constructor, typeof(Hugula.Loader.CRequest));
	}
}
