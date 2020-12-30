--[[--
* 网络处理
* 处理消息接收，断网
* @Author:      Seven
* @DateTime:    2017-03-09 21:20:16
]]

require("net.netConfig")
local msgParser = require("net.msgParser")
local error_code = require("config.error_code")-- 错误码

local ping_time = 10000
local send_ping_time = 0

local back_to_login = function(content)
	Net:set_heart(false)
	Net:close()
	local function sure()
		-- 连接登录服
  -- 		Net:connect(NetConfig.host, NetConfig.port)
		-- StateManager:set_current_state(StateManager.login, true)
		gf_restart_game()
	end
	LuaItemManager:get_item_obejct("cCMP"):add_message(content,sure,nil,sure,true and 0 or nil,nil,nil,nil,nil,gf_localize_string("确认"),gf_localize_string("取消"),sure,nil,nil)
	Net:receive(nil,ClientProto.OpenAutoDoTask)--取消自动做任务
	Net:receive({}, ClientProto.OnStopAutoMove)--停止寻路
end

local LNet = Hugula.Net.LNet.main

LNet.onConnectionFn = function(net)
	print("连接服务器成功!",net.Host,net.Port)
	gf_mask_show(false)
	if net.Host == NetConfig.host and net.Port == NetConfig.port then -- 连接登录服成功
		
	else -- 游戏服
		LuaItemManager:get_item_obejct("login"):login_2_c2s()
	end
end

LNet.onIntervalFn = function(net)
	-- luaGC()
end

LNet.onReConnectFn = function(net)
	print("重连")
	--delay(showNetworkInfo,2,"waiting reconnection")
end

LNet.onMessageReceiveFn = function(buff)
	local msg, id1, id2, sid = msgParser.unpack(buff)
	-- gf_print_table(msg)

	-- 错误码提示 测试
	if msg.err and msg.err > 0 then
		if msg.err == 34004 then
			if LuaItemManager:get_item_obejct("setting") then
				LuaItemManager:get_item_obejct("setting"):is_lock()
			end
		else
			local data = ConfigMgr:get_config("err_tips_type")[msg.err]
			if data then
				if data.type == ClientEnum.ERR_CODE_TYPE.BOX then
					LuaItemManager:get_item_obejct("cCMP"):add_message(Net:error_code(msg.err))

				elseif data.type == ClientEnum.ERR_CODE_TYPE.NOT_SHOW then

				elseif data.type == ClientEnum.ERR_CODE_TYPE.SHOW_LOGIN then
					back_to_login(Net:error_code(msg.err))	
				else
					gf_message_tips(Net:error_code(msg.err))
				end
			else
				gf_message_tips(Net:error_code(msg.err))
			end
		end
	end

	local func = function()
		Net:receive(msg, id1, id2, sid)
	end

	if DEBUG and OPEN_DELAY_NET then
		delay(func,OPEN_DELAY_NET_TIME)
	else
		func()
	end

	

	if id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "PingR") then -- 心跳返回
			if send_ping_time~=0 then
				ping_time = os.clock() - send_ping_time
				send_ping_time = 0
			end
			Net:recevie_heart(msg)
		end
	end
end

LNet.onConnectionCloseFn = function(net)
	print("onConnectionClose")
	back_to_login(gf_localize_string("你的网络已断开！点击确定重新连接"))
	--showTips("你的网络已断开！点击确定重新连接",onReConnect)
	-- LNet:ReConnect()
end

LNet.onConnectionTimeoutFn = function(net)
	print("Connection time out")
	back_to_login(gf_localize_string("网络连接超时,点击确定重新连接"))
	--showTips("网络连接超时,点击确定重新连接",onReConnect)
	--showNetworkInfo("connection time out")
	-- LNet:ReConnect()
	gf_mask_show(false)
end

Hugula.PLua.instance.onAppPauseFn = function(sender, pauseStatus)
--	print("onApplicationPause ="..tostring(bl).." isConnected="..tostring(LNet.isConnected))
--	print("pingMsg onAppPause  "..CUtils.getDateTime())
	if pauseStatus == false then
		-- if LNet.isConnected == false then LNet:ReConnect() end
	end
end



Net = {}
Net.server_time_ms = 0 -- 服务器时间ms
Net.client_time_ms = 0 -- 客户端时间ms

-- 网络初始化
function Net:init()
	self.param = {}
	self.sid = 0
	self.is_heart = false -- 是否要发心跳包，只有在连接游戏服以后才要发心跳包
	Schedule(handler(self, self.on_update), 30)
end

-- 发送消息
function Net:send( msg, id1, id2, sid )
	gf_print_table(msg, "send msg:"..id1.." "..id2.." "..(sid or -1).." Time"..os.date("%H:%M:%S",os.time()))
	local buff = msgParser.pack(msg, id1, id2, sid)
	LNet:SendMsg(buff)
end

function Net:receive( msg, id1, id2, sid )
	StateManager:on_receive(msg, id1, id2, sid)
end

-- 连接服务器
function Net:connect( host, port )
	gf_mask_show(true)
	self:close()
	LNet:Connect(host, port)
end

function Net:close()
	LNet:Close()
end

-- 设置发送心跳包
function Net:set_heart( enable )
	self.is_heart = enable or false
	if self.is_heart then
		self:send_heart()
	end
end

function Net:get_id1( package )
	return msgParser.getId1(package)
end

function Net:get_id2( package, message )
	local id1, id2 = msgParser.getId(package, message)
	return id2
end

function Net:error_code( err )
	return error_code[err]
end

-- 心跳包 一分钟发一次
function Net:send_heart()
	print("发送心跳包")
	send_ping_time = send_ping_time==0 and os.clock() or send_ping_time
	local msg = {time = os.time()}
	self:send(msg, "base", "Ping")
end

function Net:get_sid()
	self.sid = self.sid + 1
	if self.sid > 255 then
		self.sid = 0
	end
	return self.sid
end

function Net:set_sid_param(...)
	local sid = self:get_sid()
	self.param[sid] = {...}
	return sid
end

function Net:get_sid_param(sid)
	local param = self.param[sid]
	return param 
end

-- 心跳返回
function Net:recevie_heart( msg )
	gf_print_table(msg, "心跳包返回:")
	self.server_time_ms = msg.time*1000
	self.client_time_ms = Seven.PublicFun.GetTimeStamp(false)
end

-- 获取服务器时间毫秒
function Net:get_server_time_ms()
	if self.server_time_ms and self.client_time_ms then
		local pas = Seven.PublicFun.GetTimeStamp(false) - self.client_time_ms
		local nowt = self.server_time_ms + pas
		return math.floor(nowt)
	else
		return Seven.PublicFun.GetTimeStamp(false)
	end
end

-- 获取服务器时间秒
function Net:get_server_time_s()
	return self:get_server_time_ms()*0.001
end

function Net:on_update( dt )
	-- 连接上游戏服，开始发心跳包
	if LNet.IsConnected then
		if self.is_heart then
			self:send_heart()
		end
	end
end

function Net:get_ping_time()
	return send_ping_time==0 and ping_time or os.clock() - send_ping_time
end

function Net:back_to_login( connect )
	back_to_login(connect)
end

Net:init()
-- Net:connect(NetConfig.host, NetConfig.port)


-- 这里增加测试协议
-- msgParser.printProt("scene")
--msgParser.printProt("bag")



