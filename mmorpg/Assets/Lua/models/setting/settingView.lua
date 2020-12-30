--[[--
-- 设置界面
-- @Author:Seven
-- @DateTime:2017-07-04 19:49:26
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SettingView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
    Asset._ctor(self, "system_setting.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function SettingView:on_asset_load(key,asset)
	self:hide_mainui()
	self:init_ui()
	self:register()
	self:init_page(2)
	-- self.item_obj:get_auto_combat_conf_c2s()
	-- self:update_ui()
	self.refer:Get("nortice_red_point"):SetActive(LuaItemManager:get_item_obejct("announcement"):show_red()) -- 公告维护红点
end

function SettingView:init_page(num)
	if self.select_num then
		self.refer:Get("tog_"..self.select_num):SetActive(false)
	end 
	self.select_num = num
	self.refer:Get("tog_"..num):SetActive(true)
	for i=1,3 do
		if i == num then
			self.refer:Get(i).gameObject:SetActive(true)
		else
			self.refer:Get(i).gameObject:SetActive(false)
		end
	end
end
local quality_text = {
	[1] = "哇喔！天命者大人，您的设备堪称神机，小精灵推荐您使用极速画质。",
	[2] = "哇喔！天命者大人，您的设备堪称神机，小精灵推荐您使用高清画质。",
	[3] = "哇喔！天命者大人，您的设备堪称神机，小精灵推荐您使用完美画质。",
}

function SettingView:init_ui()
	self.view_system = self.refer:Get("system")
	-- 音乐
	self.music_tog = self.view_system:Get("tog_music")
	self.music_slider = self.view_system:Get("musicSlider")
	-- 音效
	self.effect_tog = self.view_system:Get("tog_effect")
	self.effect_slider = self.view_system:Get("effectSlider")
	--同屏人数
	self.numberOfScreenSlider = self.view_system:Get("numberOfScreenSlider")
	
	self.txt_number	=self.view_system:Get("txt_number")
	
	self.view_system:Get("txt_choose").text = quality_text[self.item_obj.quality]

	

	-- 性能
	-- 流畅
	self.quality_low1 = self.view_system:Get(1)
	-- 中
	self.quality_low2 = self.view_system:Get(2)
	-- 高
	self.quality_low3 = self.view_system:Get(3)
	
----------------------------------------------------------------------------------------------
	self.view_personal = self.refer:Get("personal")
	-- -- 世界
	self.world_select = self.view_personal:Get("world_select")
	self.world_normal = self.view_personal:Get("world_normal")
	-- LuaItemManager:get_item_obejct("chat"):get_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.WORLD)
	-- -- 军团
	self.legion_select = self.view_personal:Get("legion_select")
	self.legion_normal = self.view_personal:Get("legion_normal")
	-- LuaItemManager:get_item_obejct("chat"):get_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.ARMY_GROUP)
	-- -- 队伍
	self.team_select = self.view_personal:Get("team_select")
	self.team_normal = self.view_personal:Get("team_normal")
	-- LuaItemManager:get_item_obejct("chat"):get_auto_play_gvoice_channel(ServerEnum.CHAT_CHANNEL.TEAM)
	--屏蔽他人
	self.shieldOtherPlayer_select = self.view_personal:Get("shieldOtherPlayer_select")
	self.shieldOtherPlayer_normal = self.view_personal:Get("shieldOtherPlayer_normal")
	--屏蔽怪物
	self.shieldMonster_select = self.view_personal:Get("shieldMonster_select")
	self.shieldMonster_normal = self.view_personal:Get("shieldMonster_normal")
	--屏蔽他人特效
	self.shieldOtherEffects_select = self.view_personal:Get("shieldOtherEffects_select")
	self.shieldOtherEffects_normal = self.view_personal:Get("shieldOtherEffects_normal")
	--屏蔽他人武将
	self.shieldOtherHero_select = self.view_personal:Get("shieldOtherHero_select")
	self.shieldOtherHero_normal = self.view_personal:Get("shieldOtherHero_normal")
	--屏蔽称号
	self.shieldTitle_select = self.view_personal:Get("shieldTitle_select")
	self.shieldTitle_normal = self.view_personal:Get("shieldTitle_normal")
	--关闭震动
	self.shakeOff_select = self.view_personal:Get("shakeOff_select")
	self.shakeOff_normal = self.view_personal:Get("shakeOff_normal")
	--自动原地恢复
	self.revive_select = self.view_personal:Get("revive_select")
	self.revive_normal = self.view_personal:Get("revive_normal")
	-- 武将自动攻击
	self.autoAtk_select = self.view_personal:Get("autoAtk_select")
	self.autoAtk_normal = self.view_personal:Get("autoAtk_normal")
	--自动跟随
	self.follow_select = self.view_personal:Get("follow_select")
	self.follow_normal = self.view_personal:Get("follow_normal")

	-- 自动吃药百分比
	self.takeMedicineSlider = self.view_personal:Get("takeMedicineSlider")
	self.blood_volume = self.view_personal:Get("blood_volume")

	

	local game_item = LuaItemManager:get_item_obejct("game")
	-- 头像
	self.head = self.view_personal:Get("headIco")
	gf_set_head_ico(self.head, game_item:getHead())

	-- 名字
	self.name = self.view_personal:Get("nameTxt")
	self.name.text = game_item:getName()

	-- 唯一id
	self.guid = self.view_personal:Get("guidTxt")
	self.guid.text = game_item:getId()

	-- 服务器名字
	self.server_name = self.view_personal:Get("serverNameTxt")
	self.server_name.text = game_item:get_server_name()

	--安全锁
	self.safeLock = self.refer:Get("safeLock")
	
	self:updata_ui_value()

end

--更新UI信息
function SettingView:updata_ui_value()
	local sc_s = self.item_obj:get_setting_value(ClientEnum.SETTING.DISPLAY_NUMBER)
	self.numberOfScreenSlider.value =tonumber(string.format("%.2f",math.sqrt(sc_s/15+0.25)))-0.5
	if self.numberOfScreenSlider.value ==1 then
		self.txt_number.text = "无限制"
	else
		self.txt_number.text = sc_s.."人"
	end
	self.music_tog.isOn = Sound:get_isPlayMusicVolume()
	self.music_slider.value = Sound:get_musicVolume()
	self.effect_tog.isOn = Sound:get_isPlayFxVolume()
	self.effect_slider.value = Sound:get_fxVolume()
	self:update_ui_system()
	local qualityLevel = LuaItemManager:get_item_obejct("game"):get_quality_level()
	if qualityLevel <= 1 then
		self.quality_low1.isOn = true
	elseif qualityLevel <= 3 then
		self.quality_low2.isOn = true
	elseif qualityLevel then
		self.quality_low3.isOn = true
	end
	print("设置界面"..self.item_obj:get_setting_value(ClientEnum.SETTING.TAKE_MEDICINE))
	self.takeMedicineSlider.value = tonumber(self.item_obj:get_setting_value(ClientEnum.SETTING.TAKE_MEDICINE))/10
	self.blood_volume.text =  self.item_obj:get_setting_value(ClientEnum.SETTING.TAKE_MEDICINE) .."%"
	self:update_ui_safeLock()
	self:update_personal_ui()
end


function SettingView:update_ui_system()
	if self.music_tog.isOn then
		self.view_system:Get("select_txt_music").text = "开"
	else
		self.view_system:Get("select_txt_music").text = ""
	end
	if self.effect_tog.isOn then
		self.view_system:Get("select_txt_effect").text = "开"
	else
		self.view_system:Get("select_txt_effect").text = ""
	end
	self.view_system:Get("tog_music1").enabled = not self.music_tog.isOn
	self.view_system:Get("tog_effect1").enabled = not self.effect_tog.isOn
end
--安全锁
function SettingView:update_ui_safeLock()
	local state = self.item_obj:get_setting_state()
	if state == ServerEnum.ROLE_SAFTY_STATE.NONE then
		self.safeLock:Get(1).localRotation =Quaternion.Euler(0,0,-20)
		self.safeLock:Get(2).text = "<color=#d01212>"..gf_localize_string("安全锁未锁定").."</color>"
		self.safeLock:Get(3).text = gf_localize_string("设置密码")
		self.safeLock:Get(4).text = gf_localize_string("设置锁定")
		self.safeLock:Get(6):SetActive(false)
		self.safeLock:Get(5):SetActive(true)
	elseif state == ServerEnum.ROLE_SAFTY_STATE.LOCK then
		self.safeLock:Get(1).localRotation = Quaternion.Euler(0,0,0)
		self.safeLock:Get(2).text = "<color=#18a700>"..gf_localize_string("安全锁已锁定").."</color>"
		self.safeLock:Get(3).text = gf_localize_string("重设密码")
		self.safeLock:Get(4).text = gf_localize_string("解除锁定")
		self.safeLock:Get(5):SetActive(true)
		self.safeLock:Get(6):SetActive(true)
	elseif state == ServerEnum.ROLE_SAFTY_STATE.UNLOCK then
		self.safeLock:Get(1).localRotation = Quaternion.Euler(0,0,-20)---
		self.safeLock:Get(2).text = "<color=#d01212>"..gf_localize_string("安全锁未锁定").."</color>"
		self.safeLock:Get(3).text = gf_localize_string("重设密码")
		self.safeLock:Get(4).text = gf_localize_string("设置锁定")
		self.safeLock:Get(5):SetActive(false)
		self.safeLock:Get(6):SetActive(true)
	end
end

function SettingView:update_ui()
	self.take_medicine_slider.value = self.item_obj.medicine_per*0.01
	self.auto_atk_tog.isOn = self.item_obj.auto_atk == 1
	self.revive_tog.isOn = self.item_obj.auto_rivive == 1
end

function SettingView:update_personal_ui()
	self.world_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.WORLD_CHAT))
	self.legion_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.LEGION_CHAT))
	self.team_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.TEAM_CHAT))
	self.shieldOtherPlayer_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_PLAYER))
	self.shieldMonster_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_MONSTER))
	self.shieldOtherEffects_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_EFFECTS))
	self.shieldOtherHero_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_HERO))
	self.shieldTitle_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_TITLE))
	self.shakeOff_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.SHAKE_OFF))
	self.revive_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.REVIVE))
	-- self.autoAtk_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.AUTO_ATK) == 1 )
	self.follow_select:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.FOLLOW))

	self.world_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.WORLD_CHAT))
	self.legion_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.LEGION_CHAT))
	self.team_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.TEAM_CHAT))
	self.shieldOtherPlayer_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_PLAYER))
	self.shieldMonster_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_MONSTER))
	self.shieldOtherEffects_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_EFFECTS))
	self.shieldOtherHero_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_HERO))
	self.shieldTitle_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.SHIELD_TITLE))
	self.shakeOff_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.SHAKE_OFF))
	self.revive_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.REVIVE))
	-- self.autoAtk_normal:SetActive(not (self.item_obj:get_setting_value(ClientEnum.SETTING.AUTO_ATK) == 1) )
	self.follow_normal:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.FOLLOW))
end

function SettingView:save_data()
	self.item_obj:set_auto_combat_conf_c2s(self.take_medicine_slider.value*100, self.revive_tog.isOn, self.auto_atk_tog.isOn)
end

function SettingView:on_click( item_obj, obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "setting_close_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self.item_obj:remove_from_state()
		-- self:save_data()
		self:dispose()
	elseif cmd == "page1" then --页签1
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:init_page(1)
	elseif cmd == "page2" then --页签2
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:init_page(2)
	elseif cmd == "page3" then --页签3
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:init_page(3)
	elseif cmd == "btnSetPassword" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if state == ServerEnum.ROLE_SAFTY_STATE.NONE then
			self.set_pass_view = require("models.setting.settingPassword")()
		else
			self.set_pass_view =require("models.setting.settingPassword")(true) --重新设置
		end
	elseif cmd == "btnSetLock" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local state = self.item_obj:get_setting_state()
		if state == ServerEnum.ROLE_SAFTY_STATE.UNLOCK then
			self.item_obj:lock_safty_code_c2s()
		else
			self.set_pass_view = require("models.setting.settingPassword")()
		end
	elseif cmd == "numberOfScreenSlider" then -- 同屏幕人数
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.numberOfScreenSlider.value == 1 then
			arg.text = "无限制"
		else
			local x = self.numberOfScreenSlider.value+1
			local num = math.floor(self.numberOfScreenSlider.value*15*x)
			-- local num = math.pow(2,self.numberOfScreenSlider.value*5)
			arg.text = num .. "人"
			self.item_obj:set_setting_value(ClientEnum.SETTING.DISPLAY_NUMBER,num)
		end
	elseif cmd == "tog_music" then -- 音乐开关
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		Sound:set_isPlayMusicVolume(self.music_tog.isOn)
		self:update_ui_system()
	elseif cmd == "musicSlider" then -- 音乐音量
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		Sound:set_musicVolume(self.music_slider.value)
		self.music_tog.isOn = self.music_slider.value>0
		Sound:set_isPlayMusicVolume(self.music_tog.isOn)
		self:update_ui_system()
	elseif cmd == "tog_effect" then -- 音效开关
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		Sound:set_isPlayFxVolume(self.effect_tog.isOn)
		self:update_ui_system()
	elseif cmd == "effectSlider" then -- 音效音量
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		Sound:set_fxVolume(self.effect_slider.value)
		self.effect_tog.isOn = self.effect_slider.value>0
		Sound:set_isPlayFxVolume(self.effect_tog.isOn)
		self:update_ui_system()
	elseif cmd == "btn_quality_low1" and arg.isOn == true then -- 性能流畅
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("game"):set_quality_level(1)
	elseif cmd == "btn_quality_low2" and arg.isOn == true then -- 性能中
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("game"):set_quality_level(3)
	elseif cmd == "btn_quality_low3" and arg.isOn == true then -- 性能高
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("game"):set_quality_level(5)	
	elseif cmd == "switch_account_btn" then -- 切换账号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self.item_obj:remove_from_state()
		-- self:save_data()
		gf_mask_show(true)
		PLua.Delay(function()
			gf_mask_show(false)
			self:dispose()
			gf_restart_game()
		end,0.5)
		-- StateManager:set_current_state(StateManager.login, true)
	elseif cmd == "call_center_btn" then -- 客服中心
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.setting.customerServiceView")()
	elseif cmd == "nortice_btn" then -- 维护公告
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("announcement"):add_to_state()

	elseif cmd == "online_btn" then -- 游戏推广
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("系统机型",UnityEngine.SystemInfo.deviceModel)
		-- gf_message_tips("系统机型"..UnityEngine.SystemInfo.deviceModel)
		-- gf_message_tips("显卡名称"..UnityEngine.SystemInfo.graphicsDeviceName)
		-- gf_message_tips("系统名称"..UnityEngine.SystemInfo.operatingSystem)
		-- gf_message_tips("处理器名称"..UnityEngine.SystemInfo.processorType)
		self.item_obj:initialization_setting()
		self:updata_ui_value()
		-- self.item_obj:test()
	elseif cmd == "push_btn" then --游戏推送
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.setting.messagePush")()
	-- elseif cmd == "voiceToggle" then -- 语音开关
	-- 	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	-- 	LuaItemManager:get_item_obejct("chat"):set_is_speaker_volume(self.voice_tog.isOn)

	-- elseif cmd == "voiceSlider" then -- 语音音量
	-- 	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	-- 	LuaItemManager:get_item_obejct("chat"):set_speaker_volume(self.voice_slider.value)
	-- 	self.voice_tog.isOn = self.voice_slider.value>0

	elseif cmd == "btnWorld" then -- 自动播放语音设置（世界）
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.WORLD_CHAT)
		self:update_personal_ui()
	elseif cmd == "btnLegion" then -- 自动播放语音设置（军团）
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.LEGION_CHAT)
		self:update_personal_ui()
	elseif cmd == "btnTeam" then -- 自动播放语音设置（队伍）
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.TEAM_CHAT)
		self:update_personal_ui()
	elseif cmd == "btnShieldOtherPlayer" then -- 屏蔽他人
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.SHIELD_OTHER_PLAYER)
		self:update_personal_ui()
	elseif cmd == "btnShieldMonster" then -- 屏蔽怪物
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.SHIELD_MONSTER)
		self:update_personal_ui()
	elseif cmd == "btnShieldOtherEffects" then -- 屏蔽他人特效
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.SHIELD_OTHER_EFFECTS)
		self:update_personal_ui()
	elseif cmd == "btnShieldOtherHero" then -- 屏蔽他人武将
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.SHIELD_OTHER_HERO)
		self:update_personal_ui()
	elseif cmd == "btnShieldTitle" then -- 屏蔽称号
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.SHIELD_TITLE)
		self:update_personal_ui()
	elseif cmd == "btnShakeOff" then -- 关闭震动
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.SHAKE_OFF)
		self:update_personal_ui()
	elseif cmd == "btnRevive" then -- 自动原地恢复
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.REVIVE)
		self:update_personal_ui()
	elseif cmd == "btnAutoAtk" then -- 武将是否自动攻击
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效	
		if self.item_obj:get_setting_value(ClientEnum.SETTING.AUTO_ATK) == 1 then
			self.item_obj:set_setting_value(ClientEnum.SETTING.AUTO_ATK,0)
		else
			self.item_obj:set_setting_value(ClientEnum.SETTING.AUTO_ATK,1)
		end
		self:update_personal_ui()
	elseif cmd == "btnFollow" then -- 自动跟随
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效	
		self.item_obj:set_setting_value(ClientEnum.SETTING.FOLLOW)
		self:update_personal_ui()
	elseif cmd == "takeMedicineSlider" then --设置血量
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效	
		local v =  math.floor(self.takeMedicineSlider.value)*10
		self.blood_volume.text =  v .."%"
		self.item_obj:set_setting_value(ClientEnum.SETTING.TAKE_MEDICINE,v)
	end
end

function SettingView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "GetAutoCombatConfR") then
			self:update_ui()
		end
	elseif id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "SetSaftyCodeR")--设置安全码
			or id2 == Net:get_id2("base", "ResetSaftyCodeR") --重设安全码
			or id2 == Net:get_id2("base", "LockSaftyCodeR")--锁定安全锁
			or id2 == Net:get_id2("base", "UnlockSaftyCodeR") then --解除安全锁
			if msg.err == 0 then
				self:update_ui_safeLock()
			end
			gf_mask_show(false)
		end
	elseif id1 == ClientProto.ShowHotPoint then
		if msg.btn_id == ClientEnum.MAIN_UI_BTN.PARTNER then
			self.view_personal:Get("red_point"):SetActive(msg.visible)
		end
	end
end

function SettingView:register()
    self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function SettingView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function SettingView:on_hided()
	self:cancel_register()
end

-- 释放资源
function SettingView:dispose()
	self:hide()
    self._base.dispose(self)
end

return SettingView

