--[[-- 魔域修炼
--
-- @Author:Seven
-- @DateTime:2017-12-13 15:04:45
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local zork_practice = LuaItemManager:get_item_obejct("zorkPractice")
local auto_atk_wait_time = 10 -- 自动挂机等待时间 10秒


local leftPanelBase = require("models.mainuiLeftPanel.leftPanelBase")

local Zork=class(leftPanelBase,function(self,item_obj,...)
    leftPanelBase._ctor(self, "mainui_zork_practice.u3d", item_obj,...) -- 资源名字全部是小写
end)

-- 资源加载完成
function Zork:on_asset_load(key,asset)
	self.is_init = true
	self.tween = self.refer:Get("tween")
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tween.gameObject.transform.localPosition.y
	self.tween.from = Vector3(-half_w+dx, y, 0)
	self.tween.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("zork_practice_rt").anchoredPosition = Vector2(dx, self.refer:Get("zork_practice_rt").anchoredPosition.y)
	
	self.txtTenfoldTime = self.refer:Get("txtTenfoldTime")
	self.txtGainExperience = self.refer:Get("txtGainExperience")
	self.txtInspireDamage = self.refer:Get("txtInspireDamage")
	self.txtVipExpUp = self.refer:Get("txtVipExpUp")
	self.txtPotionExpUp = self.refer:Get("txtPotionExpUp")
	self.txtTeamExpUp = self.refer:Get("txtTeamExpUp")
	self.btnTenfoldTime = self.refer:Get("btnTenfoldTime")
	self.btnInspireDamage = self.refer:Get("btnInspireDamage")
	self.max_prop_count = ConfigMgr:get_config("t_misc").deathtrap.item_count_max
	self.last_click_time = Net:get_server_time_s()
	Zork._base.on_asset_load(self,key,asset)

	print("发协议吗",self.is_init,self.txtTenfoldTime)
	Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_TIME ,pos = self.btnTenfoldTime.transform.position }, ClientProto.GuideFeeble)
	Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_HARM ,pos = self.btnInspireDamage.transform.position }, ClientProto.GuideFeeble)
	Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_EXP_MEDICINE ,pos = self.refer:Get("btnPotionExpUp").transform.position }, ClientProto.GuideFeeble)
end

-- function Zork:show_view( show )
-- 	self.init_show = show
-- 	if not self.tween then
-- 		return
-- 	end

-- 	if show then
-- 		self.tween:PlayReverse()
-- 		-- print("重置操作时间",self.last_click_time)
-- 		self.last_click_time = Net:get_server_time_s()
-- 	else
-- 		self.tween:PlayForward()
-- 	end
-- end

function Zork:on_click( obj, arg )
	self.last_click_time = Net:get_server_time_s()
	-- print("重置操作时间",self.last_click_time)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btnTenfoldTime" then -- 修炼石
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		zork_practice:use_zork_practice_item()
		Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_TIME,type = 2 },ClientProto.GuideFeebleClose)
	elseif cmd == "btnInspireDamage" then -- 鼓舞
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		View("inspireCcmp",zork_practice)
		-- Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_HARM,type = 2 },ClientProto.GuideFeebleClose)
	elseif cmd == "btnPotionExpUp" then -- 经验药
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		zork_practice:use_add_exp_gain_item()
		-- Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_EXP_MEDICINE,type = 2 },ClientProto.GuideFeebleClose)
	end
end

function Zork:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.JoystickStartMove
		or id1 == ClientProto.TouchMonster
		or id1 == ClientProto.OnStopAutoMove
		or id1 == ClientProto.MouseClick
		then
		self.last_click_time = Net:get_server_time_s()
	end
end

function Zork:on_update( dt )
	print("Zork:on_update",dt)
	if self.is_init then
		local char =  LuaItemManager:get_item_obejct("battle"):get_character()
		if not char or char:is_move() then
			self.last_click_time = Net:get_server_time_s()
		end

		local buff = LuaItemManager:get_item_obejct("buff")
		-- 10倍经验 12:13
		self.txtTenfoldTime.text = gf_convert_time_ms(zork_practice:get_practice_time())
		-- 已获经验 100
		self.txtGainExperience.text = gf_format_count(zork_practice:get_obtained_exp())
		-- vip经验加成 20%
		self.txtVipExpUp.text = string.format("%d%%",LuaItemManager:get_item_obejct("vipPrivileged"):get_battle_exp()/100)
		-- 经验加成buff 10%
		local buffId = buff:get_buff_id(15) -- 经验加成buff
		local buffValue = buff:get_buff_value(buffId) or 0 -- 经验加成buff
		self.txtPotionExpUp.text = string.format("%d%%",buffValue/100)
		-- 组队经验加成 10%
		local playersInfo = LuaItemManager:get_item_obejct("team"):get_member_map_inside()[LuaItemManager:get_item_obejct("game"):get_map_id()]
		local playerCount = playersInfo and #playersInfo or 1
		local itemExp = ConfigMgr:get_config("deathtrap_team")[playerCount].exp_per
		self.txtTeamExpUp.text = string.format("%d%%",(itemExp)/100)
		-- 鼓舞伤害 100%
		local buffId = buff:get_buff_id(21) -- 鼓舞buff
		local buffValue = buff:get_buff_value(buffId) or 0 -- 鼓舞伤害加成buff
		self.txtInspireDamage.text = string.format("%d%%",buffValue/100)

		local showBtnTenfoldTime = zork_practice:get_use_prop_count() < self.max_prop_count -- 判断修炼石使用次数
		if showBtnTenfoldTime ~= self.btnTenfoldTime.activeSelf then
			self.btnTenfoldTime:SetActive(showBtnTenfoldTime)
		end
		local showBtnInspireDamage = buffValue < 10000 -- 判断鼓舞加号
		if showBtnInspireDamage ~= self.btnInspireDamage.activeSelf then
			self.btnInspireDamage:SetActive(showBtnInspireDamage)
		end
		if self.last_click_time and Net:get_server_time_s() - self.last_click_time > auto_atk_wait_time then
			-- 超过10秒没操作，自动挂机
			Net:receive(true, ClientProto.AutoAtk)
		end
	end
end

function Zork:register()
	if not self.schedule then
		StateManager:register_view( self )
		self.schedule = Schedule(handler(self, self.on_update), 0.5)
	end
end

function Zork:cancel_register()
	if self.schedule then
		StateManager:remove_register_view( self )
		self.schedule:stop()
		self.schedule = nil
	end
end

function Zork:on_showed()
	if self.is_init then
		self:on_update()
		print("发协议吗",self.is_init,self.txtTenfoldTime)
		Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_TIME ,pos = self.btnTenfoldTime.transform.position }, ClientProto.GuideFeeble)
		Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_HARM ,pos = self.btnInspireDamage.transform.position }, ClientProto.GuideFeeble)
		Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_EXP_MEDICINE ,pos = self.refer:Get("btnPotionExpUp").transform.position }, ClientProto.GuideFeeble)
	end
	self:register()
end

function Zork:on_hided()
	self:cancel_register()
	Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_TIME,type = 0 },ClientProto.GuideFeebleClose)
	Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_HARM,type = 0 },ClientProto.GuideFeebleClose)
	Net:receive({code = ClientEnum.GUIDE_FEEBLE.ADD_MY_EXP_MEDICINE,type = 0 },ClientProto.GuideFeebleClose)
end

-- 释放资源
function Zork:dispose()
	self.is_init = nil
	self:hide()
    self._base.dispose(self)
 end

return Zork

