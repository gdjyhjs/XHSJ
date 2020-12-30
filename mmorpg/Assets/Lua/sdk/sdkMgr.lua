--[[--
-- SDK 管理类
-- @Author:Seven
-- @DateTime:2017-12-23 16:14:02
--]]
local SdkHandle = Seven.SDK.SdkHandle
local SDKOBJ = LuaHelper.Find("SDK")

SdkMgr = {}

function SdkMgr:init()
	self.uid = ""
	self.user_name = ""
	self.token = ""
	self.is_login = false
	
	self.sdk_handler = LuaHelper.AddComponent(SDKOBJ, "Seven.SDK.SdkHandle")
	self.sdk_handler.InitSuccessFunc = handler(self, self.on_init_success)
	self.sdk_handler.InitFailedFunc = handler(self, self.on_init_failed)
	self.sdk_handler.LoginSuccessFunc = handler(self, self.on_login_success)
	self.sdk_handler.LoginFailedFunc = handler(self, self.on_login_failed)
	self.sdk_handler.SwichAccountSuccessFunc = handler(self, self.on_swich_accout_success)
	self.sdk_handler.LogoutFunc = handler(self, self.on_logout)
	self.sdk_handler.PaySuccessFunc = handler(self, self.on_pay_success)
	self.sdk_handler.PayCancelFunc = handler(self, self.on_pay_cancel)
	self.sdk_handler.PayFailedFunc = handler(self, self.on_pay_failed)
	self.sdk_handler.ExitSuccessFunc = handler(self, self.on_exit_success)
	self:login()
end

function SdkMgr:is_sdk()
	return IS_SDK
end

-- 用户id
function SdkMgr:get_uid()
	return self.uid
end

function SdkMgr:get_user_name()
	return self.user_name
end

function SdkMgr:get_token()
	return self.token
end

function SdkMgr:get_channel()
	if not self:is_sdk() then
		return ""
	end
	return self.sdk_handler:ChannelType()
end

function SdkMgr:login()
	if not self:is_sdk() or self.is_login then
		return
	end
	self.is_login = true
	self.sdk_handler:Login()
end

function SdkMgr:logout()
	if not self:is_sdk() then
		return
	end
	self.sdk_handler:Logout()
end

-- 进入用户中心
function SdkMgr:enter_user_center()
	if not self:is_sdk() then
		return
	end
	self.sdk_handler:EnterUserCenter()
end

-- 进入论坛
function SdkMgr:enter_bbs()
	if not self:is_sdk() then
		return
	end
	self.sdk_handler:EnterBBS()
end

-- 进入客服中心
function SdkMgr:enter_customer()
	if not self:is_sdk() then
		return
	end
	self.sdk_handler:EnterCustomer()
end

--[[
购买
]]
function SdkMgr:pay( goods_id, goods_name, count, amount, cp_order_id, extar_param )
	if not self:is_sdk() then
		return
	end
	local game = LuaItemManager:get_item_obejct("game")
	local data = 
	{
		goodsID = goods_id, --产品ID，用来识别购买的产品
		goodsName = goods_name,
		goodsDesc = "", -- 商品描述(停用)
		quantifier = "个", -- 停用
		extrasParams = extar_param or json:encode({roleId = game:getId()}),
		count = count, --购买数量
		amount = amount, --支付总额
		callbackUrl = "",
		cpOrderID = cp_order_id, -- 产品订单号（游戏方的订单号）
		gameRoleBalance = "0", -- 角色用户余额
		gameRoleID = tostring(game:getId()),
		gameRoleLevel = tostring(game:getLevel()),
		gameRoleName = game:getName(),
		partyName = "公会社团",
		serverID = tostring(game:get_area_id()),
		serverName = game:get_server_name(),
		vipLevel = tostring(LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()), -- VIP等级（值为数字字符串）
		roleCreateTime = tostring(LuaItemManager:get_item_obejct("login"):get_create_role_time()),--UC与1881渠道必传，值为10位数时间戳
	}
	local json_str = json:encode(data)
	print("sdk购买：",json_str)
	self.sdk_handler:Pay(json_str)
end

--[[
创建角色
]]
function SdkMgr:create_role( role_id, role_name )
	if not self:is_sdk() then
		return
	end
	local game = LuaItemManager:get_item_obejct("game")
	local data = 
	{
		gameRoleBalance = "0", -- 角色用户余额
		gameRoleID = role_id,
		gameRoleLevel = "1",
		gameRoleName = role_name,
		partyName = "",
		serverID = tostring(game:get_area_id()),
		serverName = game:get_server_name(),
		vipLevel = "0",
		roleCreateTime = tostring(LuaItemManager:get_item_obejct("login"):get_create_role_time()),--UC与1881渠道必传，值为10位数时间戳
		gameRoleGender = "男",--360渠道参数
		gameRolePower="38",--360渠道参数，设置角色战力，必须为整型字符串
		partyId="1100",--360渠道参数，设置帮派id，必须为整型字符串

		professionId = "11",--360渠道参数，设置角色职业id，必须为整型字符串
		profession = "法师",--360渠道参数，设置角色职业名称
		partyRoleId = "1",--360渠道参数，设置角色在帮派中的id
		partyRoleName = "帮主", --360渠道参数，设置角色在帮派中的名称
		friendlist = "无",--360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190
	}
	local json_str = json:encode(data)
	print("sdk创建角色：",json_str)
	self.sdk_handler:CreateRole(json_str)
end

--[[
更新角色
]]
function SdkMgr:update_role( ... )
	if not self:is_sdk() then
		return
	end
	local game = LuaItemManager:get_item_obejct("game")
	local data = 
	{
		gameRoleBalance = "0", -- 角色用户余额
		gameRoleID = tostring(game:getId()),
		gameRoleLevel = tostring(game:getLevel()),
		gameRoleName = game:getName(),
		partyName = "公会社团",
		serverID = tostring(game:get_area_id()),
		serverName = game:get_server_name(),
		vipLevel = tostring(LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()),
		roleCreateTime = tostring(LuaItemManager:get_item_obejct("login"):get_create_role_time()),--UC与1881渠道必传，值为10位数时间戳
		gameRoleGender = "男",--360渠道参数
		gameRolePower=tostring(game:getPower()),--360渠道参数，设置角色战力，必须为整型字符串
		partyId="1100",--360渠道参数，设置帮派id，必须为整型字符串

		professionId = tostring(game:get_career()),--360渠道参数，设置角色职业id，必须为整型字符串
		profession = ClientEnum.JOB_NAME[game:get_career()],--360渠道参数，设置角色职业名称
		partyRoleId = "1",--360渠道参数，设置角色在帮派中的id
		partyRoleName = "帮主", --360渠道参数，设置角色在帮派中的名称
		friendlist = "无",--360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190
	}
	local json_str = json:encode(data)
	print("sdk更新角色：",json_str)
	self.sdk_handler:UpdateRoleInfo(json_str)
end

--[[
进入游戏
]]
function SdkMgr:enter_game( ... )
	if not self:is_sdk() then
		return
	end
	local game = LuaItemManager:get_item_obejct("game")
	local data = 
	{
		gameRoleBalance = "0", -- 角色用户余额
		gameRoleID = tostring(game:getId()),
		gameRoleLevel = tostring(game:getLevel()),
		gameRoleName = game:getName(),
		partyName = "公会社团",
		serverID = tostring(game:get_area_id()),
		serverName = game:get_server_name(),
		vipLevel = tostring(LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()),
		roleCreateTime = tostring(LuaItemManager:get_item_obejct("login"):get_create_role_time()),--UC与1881渠道必传，值为10位数时间戳
		gameRoleGender = "男",--360渠道参数
		gameRolePower=tostring(game:getPower()),--360渠道参数，设置角色战力，必须为整型字符串
		partyId="1100",--360渠道参数，设置帮派id，必须为整型字符串

		professionId = tostring(game:get_career()),--360渠道参数，设置角色职业id，必须为整型字符串
		profession = ClientEnum.JOB_NAME[game:get_career()],--360渠道参数，设置角色职业名称
		partyRoleId = "1",--360渠道参数，设置角色在帮派中的id
		partyRoleName = "帮主", --360渠道参数，设置角色在帮派中的名称
		friendlist = "无",--360渠道参数，设置好友关系列表，格式请参考：http://open.quicksdk.net/help/detail/aid/190
	}
	-- gf_print_table(data, "sdk角色数据:")
	local json_str = json:encode(data)
	print("sdk进入游戏：",json_str)
	self.sdk_handler:EnterGame(json_str)
end


--------------------------------------------回调函数--------------------------------------------------
function SdkMgr:on_init_success()
	self:login()
end

function SdkMgr:on_init_failed(error_msg)
	print("sdk初始化失败：",error_msg)
end

function SdkMgr:on_login_success( uid, user_name, token )
	self.uid = uid
	self.user_name = user_name
	self.token = token
	print("sdk登录成功：",self.uid,self.token,self:get_channel(),self.user_name)
	Net:connect(NetConfig.host, NetConfig.port)
end

function SdkMgr:on_swich_accout_success( uid, user_name, token )
	self.uid = uid
	self.user_name = user_name
	self.token = token
	print("sdk切换账号：",self.uid,self.token,self:get_channel(),self.user_name)
	Net:connect(NetConfig.host, NetConfig.port)
end

function SdkMgr:on_login_failed( error_msg )
	gf_error_tips("SDK 登录失败"..error_msg)
	self.uid = ""
	self.user_name = ""
	self.token = ""
	self:login()
end

function SdkMgr:on_logout()
	self.uid = ""
	self.user_name = ""
	self.token = ""
	self:login()
end

function SdkMgr:on_pay_success( order_id, cp_order_id, extra_param )
	self.order_id = order_id
	self.cp_order_id = cp_order_id
	self.extra_param = extra_param
end

function SdkMgr:on_pay_cancel( order_id, cp_order_id, extra_param )
	
end

function SdkMgr:on_pay_failed( order_id, cp_order_id, extra_param )
	
end

function SdkMgr:on_exit_success()
	
end

-- if SdkMgr:is_sdk() then
-- 	SdkMgr:init()
-- end