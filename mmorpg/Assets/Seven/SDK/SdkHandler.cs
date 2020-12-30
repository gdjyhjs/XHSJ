using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using SLua;
using quicksdk;

namespace Seven.SDK
{
	[SLua.CustomLuaClass]
	public class SdkHandle : QuickSDKListener 
	{
		private static SdkHandle _instance;
		public static SdkHandle Instance() {
			return _instance;
		}

		// Use this for initialization
		void Start () {
			_instance = this;
			QuickSDK.getInstance ().setListener (this);
		}

		void showLog(string title, string message)
		{
			Debug.Log ("title: " + title + ", message: " + message);
		}

		//登录
		public void Login()
		{
			QuickSDK.getInstance ().login ();
		}

		//登出
		public void Logout()
		{
			QuickSDK.getInstance ().logout ();

		}

		//购买
		public void Pay(string jsonString)
		{
			OrderInfo orderInfo = new OrderInfo();
			GameRoleInfo gameRoleInfo = new GameRoleInfo();

			var data = SimpleJSON.JSONNode.Parse(jsonString);
			orderInfo.goodsID = data["goodsID"].Value;
			orderInfo.goodsName = data["goodsName"].Value;
			orderInfo.goodsDesc = data["goodsDesc"].Value;
			orderInfo.quantifier = data["quantifier"].Value;
			orderInfo.extrasParams = data["extrasParams"].Value;
			orderInfo.count = data["count"].AsInt;
			orderInfo.amount = data["amount"].AsInt;
			orderInfo.price = data["price"].AsFloat;
			orderInfo.callbackUrl = data["callbackUrl"].Value;
			orderInfo.cpOrderID = data["cpOrderID"].Value;

			gameRoleInfo.gameRoleBalance = data["gameRoleBalance"].Value;
			gameRoleInfo.gameRoleID = data["gameRoleID"].Value;
			gameRoleInfo.gameRoleLevel = data["gameRoleLevel"].Value;
			gameRoleInfo.gameRoleName = data["gameRoleName"].Value;
			gameRoleInfo.partyName = data["partyName"].Value;
			gameRoleInfo.serverID = data["serverID"].Value;
			gameRoleInfo.serverName = data["serverName"].Value;
			gameRoleInfo.vipLevel = data["vipLevel"].Value;
			gameRoleInfo.roleCreateTime = data["roleCreateTime"].Value;
			QuickSDK.getInstance ().pay (orderInfo, gameRoleInfo);
		}

		//创建角色
		public void CreatRole(string jsonString)
		{
			//注：GameRoleInfo的字段，如果游戏有的参数必须传，没有则不用传
			GameRoleInfo gameRoleInfo = new GameRoleInfo();

			var data = SimpleJSON.JSONNode.Parse(jsonString);
			gameRoleInfo.gameRoleBalance = data["gameRoleBalance"].Value;
			gameRoleInfo.gameRoleID = data["gameRoleID"].Value;
			gameRoleInfo.gameRoleLevel = data["gameRoleLevel"].Value;
			gameRoleInfo.gameRoleName = data["gameRoleName"].Value;
			gameRoleInfo.partyName = data["partyName"].Value;
			gameRoleInfo.serverID = data["serverID"].Value;
			gameRoleInfo.serverName = data["serverName"].Value;
			gameRoleInfo.vipLevel = data["vipLevel"].Value;
			gameRoleInfo.roleCreateTime = data["roleCreateTime"].Value;//UC与1881渠道必传，值为10位数时间戳

			gameRoleInfo.gameRoleGender = data["gameRoleGender"].Value;//360渠道参数
			gameRoleInfo.gameRolePower=data["gameRolePower"].Value;//360渠道参数，设置角色战力，必须为整型字符串
			gameRoleInfo.partyId=data["partyId"].Value;//360渠道参数，设置帮派id，必须为整型字符串

			gameRoleInfo.professionId = data["professionId"].Value;//360渠道参数，设置角色职业id，必须为整型字符串
			gameRoleInfo.profession = data["profession"].Value;//360渠道参数，设置角色职业名称
			gameRoleInfo.partyRoleId = data["partyRoleId"].Value;//360渠道参数，设置角色在帮派中的id
			gameRoleInfo.partyRoleName = data["partyRoleName"].Value; //360渠道参数，设置角色在帮派中的名称
			gameRoleInfo.friendlist = data["friendlist"].Value;//360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190


			QuickSDK.getInstance ().createRole(gameRoleInfo);//创建角色
		}

		//进入游戏
		public void EnterGame(string jsonString)
		{
			//注：GameRoleInfo的字段，如果游戏有的参数必须传，没有则不用传
			GameRoleInfo gameRoleInfo = new GameRoleInfo();

			var data = SimpleJSON.JSONNode.Parse(jsonString);
			gameRoleInfo.gameRoleBalance = data["gameRoleBalance"].Value;
			gameRoleInfo.gameRoleID = data["gameRoleID"].Value;
			gameRoleInfo.gameRoleLevel = data["gameRoleLevel"].Value;
			gameRoleInfo.gameRoleName = data["gameRoleName"].Value;
			gameRoleInfo.partyName = data["partyName"].Value;
			gameRoleInfo.serverID = data["serverID"].Value;
			gameRoleInfo.serverName = data["serverName"].Value;
			gameRoleInfo.vipLevel = data["vipLevel"].Value;
			gameRoleInfo.roleCreateTime = data["roleCreateTime"].Value;//UC与1881渠道必传，值为10位数时间戳

			gameRoleInfo.gameRoleGender = data["gameRoleGender"].Value;//360渠道参数
			gameRoleInfo.gameRolePower=data["gameRolePower"].Value;//360渠道参数，设置角色战力，必须为整型字符串
			gameRoleInfo.partyId=data["partyId"].Value;//360渠道参数，设置帮派id，必须为整型字符串

			gameRoleInfo.professionId = data["professionId"].Value;//360渠道参数，设置角色职业id，必须为整型字符串
			gameRoleInfo.profession = data["profession"].Value;//360渠道参数，设置角色职业名称
			gameRoleInfo.partyRoleId = data["partyRoleId"].Value;//360渠道参数，设置角色在帮派中的id
			gameRoleInfo.partyRoleName = data["partyRoleName"].Value; //360渠道参数，设置角色在帮派中的名称
			gameRoleInfo.friendlist = data["friendlist"].Value;//360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190

			QuickSDK.getInstance ().enterGame (gameRoleInfo);//开始游戏
		}

		//更新角色信息
		public void UpdateRoleInfo(string jsonString)
		{
			//注：GameRoleInfo的字段，如果游戏有的参数必须传，没有则不用传
			GameRoleInfo gameRoleInfo = new GameRoleInfo();

			var data = SimpleJSON.JSONNode.Parse(jsonString);
			gameRoleInfo.gameRoleBalance = data["gameRoleBalance"].Value;
			gameRoleInfo.gameRoleID = data["gameRoleID"].Value;
			gameRoleInfo.gameRoleLevel = data["gameRoleLevel"].Value;
			gameRoleInfo.gameRoleName = data["gameRoleBalance"].Value;
			gameRoleInfo.partyName = data["gameRoleName"].Value;
			gameRoleInfo.serverID = data["serverID"].Value;
			gameRoleInfo.serverName = data["serverName"].Value;
			gameRoleInfo.vipLevel = data["vipLevel"].Value;
			gameRoleInfo.roleCreateTime = data["roleCreateTime"].Value;//UC与1881渠道必传，值为10位数时间戳

			gameRoleInfo.gameRoleGender = data["gameRoleGender"].Value;//360渠道参数
			gameRoleInfo.gameRolePower=data["gameRolePower"].Value;//360渠道参数，设置角色战力，必须为整型字符串
			gameRoleInfo.partyId=data["partyId"].Value;//360渠道参数，设置帮派id，必须为整型字符串

			gameRoleInfo.professionId = data["professionId"].Value;//360渠道参数，设置角色职业id，必须为整型字符串
			gameRoleInfo.profession = data["profession"].Value;//360渠道参数，设置角色职业名称
			gameRoleInfo.partyRoleId = data["partyRoleId"].Value;//360渠道参数，设置角色在帮派中的id
			gameRoleInfo.partyRoleName = data["partyRoleName"].Value; //360渠道参数，设置角色在帮派中的名称
			gameRoleInfo.friendlist = data["friendlist"].Value;//360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190

			QuickSDK.getInstance ().updateRole(gameRoleInfo);
		}

		//退出
		public void Exit(){
			if(QuickSDK.getInstance().isChannelHasExitDialog ()){
				QuickSDK.getInstance().exit();
			}else{
				//游戏调用自身的退出对话框，点击确定后，调用QuickSDK的exit()方法
				QuickSDK.getInstance().exit();
			}
		}

		//显示工具栏
		public void ShowToolbar()
		{
			QuickSDK.getInstance ().showToolBar (ToolbarPlace.QUICK_SDK_TOOLBAR_BOT_LEFT);
		}

		//隐藏工具栏
		public void HideToolbar()
		{
			QuickSDK.getInstance ().hideToolBar ();
		}

		//进入用户中心
		public void EnterUserCenter()
		{
			QuickSDK.getInstance ().callFunction (FuncType.QUICK_SDK_FUNC_TYPE_ENTER_USER_CENTER);
		}

		//进入论坛
		public void EnterBBS()
		{
			QuickSDK.getInstance ().callFunction (FuncType.QUICK_SDK_FUNC_TYPE_ENTER_BBS);
		}

		//进入客服中心
		public void EnterCustomer()
		{
			QuickSDK.getInstance ().callFunction (FuncType.QUICK_SDK_FUNC_TYPE_ENTER_CUSTOMER_CENTER);
		}

		//用户uid
		public string UserId()
		{
			return QuickSDK.getInstance ().userId ();
		}

		//渠道号
		public int ChannelType()
		{
			return QuickSDK.getInstance ().channelType ();
		}

		void OnApplicationPause(bool pauseStatus)
		{
			if (pauseStatus) {
				PauseGame ();
			} else {
				ResumeGame ();
			}
		}

		void PauseGame()
		{
			Time.timeScale = 0;
			QuickSDK.getInstance ().callFunction (FuncType.QUICK_SDK_FUNC_TYPE_PAUSED_GAME);
		}

		void ResumeGame()
		{
			Time.timeScale = 1;
		}

		void OnDestroy()
		{
			Logout ();
		}

		//************************************************************以下是需要实现的回调接口*************************************************************************************************************************
		//callback

		public LuaFunction InitSuccessFunc;
		public LuaFunction InitFailedFunc;
		public LuaFunction LoginSuccessFunc;
		public LuaFunction LoginFailedFunc;
		public LuaFunction SwichAccountSuccessFunc;
		public LuaFunction LogoutFunc;
		public LuaFunction PaySuccessFunc;
		public LuaFunction PayCancelFunc;
		public LuaFunction PayFailedFunc;
		public LuaFunction ExitSuccessFunc;

		[SLua.DoNotToLua]
		public override void onInitSuccess()
		{
			showLog("onInitSuccess", "");
			if (InitSuccessFunc != null) {
				InitSuccessFunc.call ();
			}
//			Login (); //如果游戏需要启动时登录，需要在初始化成功之后调用
		}

		[SLua.DoNotToLua]
		public override void onInitFailed(ErrorMsg errMsg)
		{
			showLog("onInitFailed", "msg: " + errMsg.errMsg);
			if (InitFailedFunc != null) {
				InitFailedFunc.call (errMsg.errMsg);
			}
		}

		[SLua.DoNotToLua]
		public override void onLoginSuccess(UserInfo userInfo)
		{
			showLog ("onLoginSuccess", "uid: " + userInfo.uid + " ,username: " + userInfo.userName + " ,userToken: " + userInfo.token + ", msg: " + userInfo.errMsg);
			if (LoginSuccessFunc != null) {
				LoginSuccessFunc.call (userInfo.uid, userInfo.userName, userInfo.token);
			}
		}

		[SLua.DoNotToLua]
		public override void onSwitchAccountSuccess(UserInfo userInfo){
			//切换账号成功，清除原来的角色信息，使用获取到新的用户信息，回到进入游戏的界面，不需要再次调登录
			showLog ("onLoginSuccess", "uid: " + userInfo.uid + " ,username: " + userInfo.userName + " ,userToken: " + userInfo.token + ", msg: " + userInfo.errMsg);
			if (SwichAccountSuccessFunc != null) {
				SwichAccountSuccessFunc.call (userInfo.uid, userInfo.userName, userInfo.token);
			}
		}

		[SLua.DoNotToLua]
		public override void onLoginFailed (ErrorMsg errMsg)
		{
			showLog("onLoginFailed", "msg: "+ errMsg.errMsg);
			if (LoginFailedFunc != null) {
				LoginFailedFunc.call (errMsg.errMsg);
			}
		}

		[SLua.DoNotToLua]
		public override void onLogoutSuccess ()
		{
			showLog("onLogoutSuccess", "");
			//注销成功后回到登陆界面
			if (LogoutFunc != null) {
				LogoutFunc.call ();
			}
		}

		[SLua.DoNotToLua]
		public override void onPaySuccess (PayResult payResult)
		{
			showLog("onPaySuccess", "orderId: "+payResult.orderId+", cpOrderId: "+payResult.cpOrderId+" ,extraParam"+payResult.extraParam);
			if (PaySuccessFunc != null) {
				PaySuccessFunc.call (payResult.orderId, payResult.cpOrderId, payResult.extraParam);
			}
		}

		[SLua.DoNotToLua]
		public override void onPayCancel (PayResult payResult)
		{
			showLog("onPayCancel", "orderId: "+payResult.orderId+", cpOrderId: "+payResult.cpOrderId+" ,extraParam"+payResult.extraParam);
			if (PayCancelFunc != null) {
				PayCancelFunc.call (payResult.orderId, payResult.cpOrderId, payResult.extraParam);
			}
		}

		[SLua.DoNotToLua]
		public override void onPayFailed (PayResult payResult)
		{
			showLog("onPayFailed", "orderId: "+payResult.orderId+", cpOrderId: "+payResult.cpOrderId+" ,extraParam"+payResult.extraParam);
			if (PayFailedFunc != null) {
				PayFailedFunc.call (payResult.orderId, payResult.cpOrderId, payResult.extraParam);
			}
		}

		[SLua.DoNotToLua]
		public override void onExitSuccess ()
		{
			showLog ("onExitSuccess", "");
			//退出成功的回调里面调用  QuickSDK.getInstance ().exitGame ();  即可实现退出游戏，杀进程。为避免与渠道发生冲突，请不要使用  Application.Quit ();
			QuickSDK.getInstance ().exitGame ();
			if (ExitSuccessFunc != null) {
				ExitSuccessFunc.call ();
			}
		}



	}
}

