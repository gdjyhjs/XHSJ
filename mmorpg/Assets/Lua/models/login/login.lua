--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-03-31 16:37:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local CryptographHelper = Hugula.Cryptograph.CryptographHelper

local Login = LuaItemManager:get_item_obejct("login")
--UI资源
Login.assets=
{
    View("loginInitView", Login),

    -- Asset("login_internal.u3d"), 
    -- Asset("login_channel.u3d", true),-- 预加载
}

--点击事件
function Login:on_click(obj,arg)
	print("登录产生的点击事件")
	self:call_event("login_init_view_on_click",false,obj,arg)
	return true
end

--值改变事件
function Login:on_input_field_value_changed( obj,arg )
	self:call_event("login_init_view_value_change",false,obj,arg)
end

--每次显示时候调用
function Login:on_showed( ... )

end

--初始化函数只会调用一次
function Login:initialize()
	self.sdk = "sdk"
	self.device_id = "1"
	self.token = "token"
	self.platform = "mac"
	self.ip = "" -- 游戏服ip
	self.port = 0 -- 游戏服端口
	self.role_id = 0 -- 玩家角色id
	self.area_id = 0 -- 玩家区id
	self.c_version = "0.0.0"  -- 客户端版本
	self.s_version = "" -- 服务器版本号	
	self.pkg_name = "com.yckj.qisha" -- 客户端包名
	self.login_time = 0 -- 登录时间搓

	self.game_data = LuaItemManager:get_item_obejct("game")

	self.server_list = ConfigMgr:get_config("serverList")
	
end

-- 获取角色信息
function Login:get_role( area_id )
	return self.role_list[area_id]
end

-- 获取默认选区
function Login:get_default_area()
	-- 现在默认选择第一个，以后会做修改TODO
	return self.server_list[1].code
end

function Login:get_create_role_time()
	return self.create_role_t
end

-- 内网登录
function Login:debug_login(account, password)
	local game = LuaItemManager:get_item_obejct("game")
	self.account = account or game.player_account
	self.password = password or game.player_password

	self:login_c2s(account, password)
end

-- sdk登录
function Login:sdk_login()
	local game = LuaItemManager:get_item_obejct("game")
	self.account = SdkMgr:get_user_name() or game.player_account
	self.token = SdkMgr:get_token() or ""

	self:login_c2s(self.account)
end

function Login:on_receive( msg, id1, id2, sid )

	if id1 == Net:get_id1("login") then
		if id2 == Net:get_id2("login", "RegistR") then -- 注册返回
			self:regist_s2c(msg)

		elseif id2 == Net:get_id2("login", "LoginR") then -- 登录返回
			self:login_s2c(msg)
		elseif id2 == Net:get_id2("login", "ConnectR") then -- 连接成功时服务器主动推送
			self.connect = msg
			if SdkMgr:is_sdk() then
				LuaItemManager:get_item_obejct("login"):sdk_login()
			end

		elseif id2 == Net:get_id2("login", "LoginGameR") then -- 登录某个区返回
			self:login_game_s2c(msg)

		elseif id2 == Net:get_id2("login", "AreaListR") then -- 获取服务器列表
			self:area_list_s2c(msg)
		elseif id2 == Net:get_id2("login", "RandomRoleNameR") then -- 返回随机名字
			self:random_role_name_s2c(msg)
		end

	elseif id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "LoginR") then -- 注册返回
			self:login_2_s2c(msg)

		elseif id2 == Net:get_id2("base", "GetNewerStepR") then -- 获取新手步骤
			self:get_guide_s2c(msg)

		end
	end
end

--获得随机名字
function Login:random_role_name_c2s(sex_type,bSymbol)
	print("请求随机名字",sex_type,bSymbol)
	local msg = {
		sex_type=sex_type,
		bSymbol=bSymbol,
		areaId=self.select_area,
	}
	Net:send(msg, "login", "RandomRoleName")
end

--获取最少人玩的角色
function Login:min_career_c2s()
	Net:send({areaId = self.select_area}, "login", "MinCareer")
end

function Login:random_role_name_s2c(msg)
	-- print("获得随机名字",msg.name)
	-- local create_role = LuaItemManager:get_item_obejct("createRole")
	-- create_role:get_ui():write_name(msg.name)
end

-- 注册玩家账号协议
function Login:regist_c2s( account, password )
	local msg = {
		account = account,
		password = password,
		platform = self.platform,
		device_id = self.device_id,
	}
	--gf_print_table(msg, "发送注册协议:")
	print("注册:",account)
	Net:send(msg, "login", "Regist")
end

-- 注册玩家账返回
function Login:regist_s2c( msg )
	if msg.err == 0 then -- 注册成功,进入登录
		self:login_c2s(self.account, self.password)
	else
		self.assets[1]:float_text(Net:error_code(msg.err))
		SdkMgr:logout()
	end
end

-- 登录协议
function Login:login_c2s(account, password)
	if not self.connect then
		print("无法连接服务器！")
		gf_message_tips(gf_localize_string("无法连接服务器！"))
		return
	end
	gf_mask_show(true)

	account = account or ""
	password = password or "123"
	local msg = {
		account = account,
		password = CryptographHelper.Md5String(self.connect.key..password),
		device_id = self.device_id,
		token = SdkMgr:get_token(),
		uid = SdkMgr:get_uid(),
	}
	if SdkMgr:is_sdk() then
		msg.thirdSDK = tostring(SdkMgr:get_channel())
	end

	gf_print_table(msg, "发送登录协议:")
	Net:send(msg, "login", "Login")
end

-- 登录返回
function Login:login_s2c( msg )
	self.login_info = msg

	print(Net:error_code(msg.err))
	if msg.err == 0 then -- 登录成功
		print("登录服登录成功！")
		-- 保存账号密码
		local game = LuaItemManager:get_item_obejct("game")
		game:set_player_account(self.account)
		game:set_player_password(self.password)

		-- 获取服务器列表
		self:area_list_c2s()

	elseif msg.err == 102 then -- 该账号未注册
		--注册账号
		self:regist_c2s(self.account, self.password)
	end
end

-- 登录某个区[没有角色创建角色]
function Login:login_game_c2s( area, name, career )
	if self.is_login then
		print("已经请求过登录")
		return
	end
	local cb = function()
		if self.is_login then
			self.is_login = false
			gf_mask_show(false)
			Net:back_to_login("网络异常，重新连接")
		end
	end
	gf_mask_show(true, cb)
	self.is_login = true
	self.is_create_role = career ~= nil -- 是否是创建角色
	self.role_name = name
	local msg = {area = area, name = name, career = career}
	gf_print_table(msg, "登录某个区：")
	Net:send(msg, "login", "LoginGame")
end

-- 登录某个区返回
function Login:login_game_s2c( msg )
	gf_print_table(msg, "登录某个区返回")
	-- print(Net:error_code(msg.err))
	gf_mask_show(false)
	self.is_login = false
	
	if msg.err == 0 then
		local game = LuaItemManager:get_item_obejct("game")
		game.role_id = msg.roleId
		game.area_id = msg.area
		game.area_name = self.server_list[game.area_id].name
		self.role_id = msg.roleId
		self.area_id = msg.area
		self.create_role_t = msg.createTm or 0
		print("创角色时间:",self.create_role_t)

		-- 重新连接服务器
		self.ip = msg.dns or msg.ip
		self.port = msg.port 
		Net:connect(self.ip, self.port)
	else
		print(msg.err)
		self.assets[1]:float_text(Net:error_code(msg.err))

		SdkMgr:logout()

		Net:back_to_login( Net:error_code(msg.err) )
	end
end

-- 获取服务器列表
function Login:area_list_c2s()
	print("请求服务器：获取服务器列表")
	Net:send({}, "login", "AreaList")
end

-- 获取服务器返回
function Login:area_list_s2c( msg )
	gf_print_table(msg,"服务器信息返回:")
	gf_mask_show(false)
	local server_list = self.server_list
	if msg.changeList then
		for k,v in pairs(server_list) do
			if msg.changeList[k] then
				v = msg.changeList[k]
			end
		end
	end
	self.server_list = server_list -- 服务器列表
	self.role_list = msg.roleList or {} -- 角色列表
	self.recommed_list = msg.recommed or {}-- 推荐服

	-- 进入选服界面
	self.assets[1]:load_ui("loginChannelView", "loginInternalView")
end

-- 登录游戏服
function Login:login_2_c2s()
	local msg = {
		roleId = self.role_id, 
		token = self.token, 
		time = os.time(),
		deviceId = self.device_id,
		version = self.version,
		pkgName = self.pkg_name,
	}
	gf_print_table(msg, "游戏服登录协议:")
	Net:send(msg, "base", "Login")
end

-- 游戏服登录返回
function Login:login_2_s2c( msg )
	if msg.err ~= 0 then -- 登录成功
	end
	self.game_data.role_info = msg.role
	LuaItemManager:get_item_obejct("setting"):init_value()
	self.map_id = msg.role.mapId
	self.copy_id = msg.role.copyCode
	gf_print_table(msg.role, "玩家角色信息")
	self.s_version = msg.version
	self.login_time = msg.time
	Net:set_heart(true)
	LuaItemManager:get_item_obejct("copy"):set_copy_id(self.copy_id)
	local game = LuaItemManager:get_item_obejct("game")
	game:set_server_open_time(msg.serverStartTm)

	-- require("requestMsg"):request_msg()
	-- 向sdk发送创角
	if self.is_create_role then
		self.is_create_role = nil
		SdkMgr:create_role(self.role_id, self.role_name)
	end
	SdkMgr:enter_game()

	-- require("tickMsg")()

	print("登录游戏服成功！")
end

function Login:get_guide_s2c( msg )
	if msg.step < 1 then -- 还没完成首场战斗
		print("进入首场战斗")
		LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(80001)
	else
		LuaItemManager:get_item_obejct("battle"):change_scene(self.map_id, self.copy_id)
		print("进入游戏",self.map_id)
	end
end

-- 地图加载完成
function Login:on_map_loaded_c2s()
	print("发送地图加载完成协议")
	Net:send({}, "scene", "OnMapLoaded")
end
