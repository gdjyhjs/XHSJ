--[[--
-- 设置
-- @Author:Seven
-- @DateTime:2017-07-04 19:48:53
--]]

local LuaHelper = LuaHelper
local messageObj = LuaHelper.Find("Message")
local LocalDelivery = LuaHelper.GetComponent(messageObj,"Seven.Message.LocalDelivery")

local Vector3 = UnityEngine.Vector3
local PlayerPrefs = UnityEngine.PlayerPrefs
local Setting = LuaItemManager:get_item_obejct("setting")
--UI资源
Setting.assets=
{
    View("settingView", Setting) 
}

--点击事件
function Setting:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
	return true
end

--每次显示时候调用
function Setting:on_showed( ... )

end

function Setting:test()
	LocalDelivery:AndroidTextNotification()
end

--初始化函数只会调用一次
function Setting:initialize()
	LocalDelivery.messageFn = handler(self, self.local_message)
	self:init_quality()
	-- self:init_value()
end

function Setting:init_quality()
	self.quality = 2
	local data =  ConfigMgr:get_config("graphics_card")
	local gpu = UnityEngine.SystemInfo.graphicsDeviceName
	if #data== 0 then return end
	for k,v in pairs(data) do
		if string.find(gpu, v.name) and string.find(gpu, v.value) then
			self.quality = v.quality
		end
	end
end

--初始化参数
function Setting:init_value()
	local r_id =  LuaItemManager:get_item_obejct("game").role_id
	if PlayerPrefs.HasKey("Setting"..r_id) then
		self.setting_tb = self:get_setting()
		return
	end
	self:initialization_setting()
end
--初始化设置
function Setting:initialization_setting()
	local data = ConfigMgr:get_config("setting")
	self.setting_tb = {}
	for k,v in pairs(data) do
		if v.code == ClientEnum.SETTING.AUTO_ATK
			or v.code == ClientEnum.SETTING.DISPLAY_NUMBER 
			or v.code == ClientEnum.SETTING.TAKE_MEDICINE  then
			self.setting_tb[v.code] = v.value[1]
 		elseif v.code == ClientEnum.SETTING.MESSAGE_PUSH then
 			self.setting_tb[v.code] = {}
 			local tb_mp = v.value
			for kk,vv in pairs(tb_mp) do
				self.setting_tb[v.code][#self.setting_tb[v.code]+1] = vv == 1
			end
 		else
			self.setting_tb[v.code] = v.value[1] == 1
		end
	end
	self:set_setting(self.setting_tb)
	if Sound then
		Sound:set_musicVolume(0.75)
		Sound:set_isPlayMusicVolume(true)
		Sound:set_fxVolume(0.75)
		Sound:set_isPlayFxVolume(true)
	end
	if LuaItemManager:get_item_obejct("chat") then
		--世界语音
		LuaItemManager:get_item_obejct("chat"):set_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.WORLD,self:get_setting_value(ClientEnum.SETTING.WORLD_CHAT))
		-- 军团语音
		LuaItemManager:get_item_obejct("chat"):set_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.ARMY_GROUP,self:get_setting_value(ClientEnum.SETTING.LEGION_CHAT))
		-- 队伍语音
		LuaItemManager:get_item_obejct("chat"):set_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.TEAM,self:get_setting_value(ClientEnum.SETTING.TEAM_CHAT))
	end
	if LuaItemManager:get_item_obejct("battle") then
		LuaItemManager:get_item_obejct("battle"):set_other_players_visible(true)
		LuaItemManager:get_item_obejct("battle"):set_monsters_visible(true)
		LuaItemManager:get_item_obejct("battle"):set_other_heros_visible(true)
		LuaItemManager:get_item_obejct("battle"):set_titles_visible(true)
	end
end
--本地推送
function Setting:local_message()
	--10秒后发送
	LocalDelivery:NotificationMessage("七煞推送10秒测试",System.DateTime.Now.AddSeconds(10),false);
	--每天中午12点推送
	LocalDelivery:NotificationMessage("每天中午12点推送",12,true);
end


--获取设置值
function Setting:get_setting_value(enum,other_enum)
	if enum == ClientEnum.SETTING.MESSAGE_PUSH then
		return self.setting_tb[enum][other_enum]
	end
	return self.setting_tb[enum]
end
--改变设置值
function Setting:set_setting_value(enum,value,other_enum)
	--改变值区
	if enum == ClientEnum.SETTING.MESSAGE_PUSH then
		self.setting_tb[enum][other_enum] = not self.setting_tb[enum][other_enum]
	elseif enum == ClientEnum.SETTING.DISPLAY_NUMBER 
		or enum == ClientEnum.SETTING.AUTO_ATK 
		or enum == ClientEnum.SETTING.TAKE_MEDICINE  then    
		self.setting_tb[enum] = value

		if enum == ClientEnum.SETTING.DISPLAY_NUMBER then
			LuaItemManager:get_item_obejct("battle"):refresh_players_num()
		end
	else
		self.setting_tb[enum] = not self.setting_tb[enum]
		print("设置",self.setting_tb[enum])
		if enum == ClientEnum.SETTING.SHIELD_OTHER_PLAYER then
			LuaItemManager:get_item_obejct("battle"):set_other_players_visible(not self.setting_tb[enum])
		elseif enum == ClientEnum.SETTING.SHIELD_MONSTER then
			LuaItemManager:get_item_obejct("battle"):set_monsters_visible(not self.setting_tb[enum])
		elseif enum == ClientEnum.SETTING.SHIELD_OTHER_HERO then
			LuaItemManager:get_item_obejct("battle"):set_other_heros_visible(not self.setting_tb[enum])
		elseif enum == ClientEnum.SETTING.SHIELD_TITLE then
			LuaItemManager:get_item_obejct("battle"):set_titles_visible(not self.setting_tb[enum])
		end
	end
	--通知区
	if enum == ClientEnum.SETTING.WORLD_CHAT then --世界语音
		LuaItemManager:get_item_obejct("chat"):set_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.WORLD,self.setting_tb[enum])
	elseif enum ==  ClientEnum.SETTING.LEGION_CHAT then -- 军团语音
		LuaItemManager:get_item_obejct("chat"):set_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.ARMY_GROUP,self.setting_tb[enum])
	elseif enum == ClientEnum.SETTING.TEAM_CHAT then -- 队伍语音
		LuaItemManager:get_item_obejct("chat"):set_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.TEAM,self.setting_tb[enum])
	end
	
	self:set_setting(self.setting_tb) 
end

function Setting:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "GetAutoCombatConfR") then
			gf_print_table(msg,"wtf receive GetAutoCombatConfR")
			self:get_auto_combat_conf_s2c(msg)

		elseif id2 == Net:get_id2("scene", "SetAutoCombatConfR") then
			self:set_auto_combat_conf_s2c(msg)
		end
	elseif id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "SetSaftyCodeR") then--设置安全码
			-- gf_print_table(msg,"安全锁设置")
			self:set_safty_code_s2c(msg)
		elseif id2 == Net:get_id2("base", "ResetSaftyCodeR") then--重设安全码
			-- gf_print_table(msg,"安全锁重设")
			self:reset_safty_code_s2c(msg)
		elseif id2 == Net:get_id2("base", "LockSaftyCodeR") then--锁定安全锁
			-- gf_print_table(msg,"安全锁锁定")
			self:lock_safty_code_s2c(msg)
		elseif id2 == Net:get_id2("base", "UnlockSaftyCodeR") then--解除安全锁
			-- gf_print_table(msg,"安全锁解除")
			self:unlock_safty_code_s2c(msg)
		elseif id2 == Net:get_id2("base", "GetSaftyStateR") then--获取当前玩家安全锁状态
			-- gf_print_table(msg,"安全锁状态")
			gf_print_table(msg,"wtf receive GetSaftyStateR")
			self:get_safty_state_s2c(msg)
		end
	end
end

-- 设置挂机配置
function Setting:set_auto_combat_conf_c2s( medicine_per, auto_rivive, auto_atk )
	if self.medicine_per == medicine_per and self.auto_rivive == auto_rivive and self.auto_atk == auto_atk then
		return
	end

	auto_rivive = auto_rivive == true and 1 or 0
	auto_atk = auto_atk == true and 1 or 0

	local msg = 
	{
		config = {[1] = medicine_per, [2] = auto_rivive, [3] = auto_atk}
	}
	gf_print_table(msg, "设置挂机配置")
	Net:send(msg, "scene", "SetAutoCombatConf")
	self.temp_msg = msg
end

function Setting:set_auto_combat_conf_s2c( msg )
	
	if msg.err ~= 0 then
		return
	end

	self.medicine_per = self.temp_msg.config[1]
	self.auto_rivive = self.temp_msg.config[2]
	self.auto_atk = self.temp_msg.config[3]
end

-- 获取挂机配置
function Setting:get_auto_combat_conf_c2s()
	Net:send({}, "scene", "GetAutoCombatConf")
end
function Setting:get_auto_combat_conf_s2c( msg )
	gf_print_table(msg, "获取挂机配置")
	self.medicine_per = msg.config[1] or 50
	self.auto_rivive = msg.config[2] or false
	self.auto_atk = msg.config[3] or 0
end
--获取安全锁状态
function Setting:get_setting_state()
	return self.setting_state
end

--判断安全锁状态
function Setting:is_lock(s_id)
	local data = ConfigMgr:get_config("item")
	if s_id and type(s_id) =="number" then
		if data[s_id] and data[s_id].bind == 1 then
			return false
		end
	elseif s_id and  type(s_id) == "table" then
		for k,v in pairs(s_id or {} ) do
			if data[v] and data[v].bind == 1 then
				return false
			end
		end
	end
	if self.setting_state == ServerEnum.ROLE_SAFTY_STATE.LOCK then
		require("models.setting.settingPassword")()
		return true
	end
	return false
end

--设置安全码
function Setting:set_safty_code_c2s(s_code)
	Net:send({saftyCode = s_code}, "base", "SetSaftyCode")
end
function Setting:set_safty_code_s2c(msg)
	if msg.err == 0 then
		self.setting_state = ServerEnum.ROLE_SAFTY_STATE.LOCK
	end
end

--重设安全码
function Setting:reset_safty_code_c2s(o_code,n_code)
	-- print("安全锁重设"..o_code)
	if not n_code or n_code == "" then
		self.is_have_lock = true
	end
	Net:send({oldCode=o_code,newCode =n_code}, "base", "ResetSaftyCode")
end
function Setting:reset_safty_code_s2c(msg)
	if msg.err == 0 then
		if self.is_have_lock then
			self.setting_state = ServerEnum.ROLE_SAFTY_STATE.NONE
		else
			self.setting_state = ServerEnum.ROLE_SAFTY_STATE.LOCK
		end
		self.is_have_lock = nil
	end
end

--锁定安全锁
function Setting:lock_safty_code_c2s()
	Net:send({}, "base", "LockSaftyCode")
end
function Setting:lock_safty_code_s2c(msg)
	if msg.err == 0 then
		self.setting_state = ServerEnum.ROLE_SAFTY_STATE.LOCK	
		gf_message_tips("上锁成功")
	end
end

--解除安全锁
function Setting:unlock_safty_code_c2s(s_code)
	Net:send({saftyCode = s_code}, "base", "UnlockSaftyCode")
end
function Setting:unlock_safty_code_s2c(msg)
	if msg.err ==0 then
		self.setting_state = ServerEnum.ROLE_SAFTY_STATE.UNLOCK
		gf_message_tips("解锁成功")
	end
end

--获取当前玩家安全锁状态
function Setting:get_safty_state_c2s()
	Net:send({}, "base", "GetSaftyState")
end
function Setting:get_safty_state_s2c(msg)
	self.setting_state = msg.state
	print("玩家当前状态"..self.setting_state)
end

function Setting:set_setting(tb)
	local s = serpent.dump(tb)
	local role_id = LuaItemManager:get_item_obejct("game").role_id
	PlayerPrefs.SetString("Setting"..role_id,s)
end
function Setting:get_setting()
	local role_id = LuaItemManager:get_item_obejct("game").role_id
	local s = PlayerPrefs.GetString("Setting"..role_id, "")
	-- if s ~= "" then
		local tb = loadstring(s)()
		return tb
	-- end
end

