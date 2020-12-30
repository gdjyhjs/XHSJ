--[[--
-- 战场
-- @Author:Seven
-- @DateTime:2017-09-05 09:47:45
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local leftPanelBase = require("models.mainuiLeftPanel.leftPanelBase")

local RvrView=class(leftPanelBase,function(self,item_obj,...)
	self.rvr_item = LuaItemManager:get_item_obejct("rvr")

    leftPanelBase._ctor(self, "mainui_rvr.u3d", item_obj,...) -- 资源名字全部是小写
end)

-- 资源加载完成
function RvrView:on_asset_load(key,asset)
	self:set_always_receive(true)
	self:init_ui()
	RvrView._base.on_asset_load(self,key,asset)
	-- self:hide()
end

function RvrView:init_ui()
	self.energy 			= self.refer:Get("energy") 			    -- 能量储备
	self.kill_num 			= self.refer:Get("kill_num") 			-- 击杀数量
	self.assist 			= self.refer:Get("assist")				-- 助攻次数
	self.honor 				= self.refer:Get("honor")				-- 荣誉
	self.feats				= self.refer:Get("feats")  				-- 战功

	self.tween = self.refer:Get("tween")
	self:init_tween()
	self.is_init = true
end

function RvrView:init_tween()
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tween.gameObject.transform.localPosition.y
	self.tween.from = Vector3(-half_w+dx, y, 0)
	self.tween.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("rvr_rt").anchoredPosition = Vector2(dx, self.refer:Get("rvr_rt").anchoredPosition.y)
end

function RvrView:update_ui()
	self.energy.text 			= self.rvr_item:get_energy() 			    -- 能量储备
	self.kill_num.text 			= self.rvr_item:get_kill_num() 				-- 击杀数量
	self.assist.text 			= self.rvr_item:get_assist()				-- 助攻次数
	self.honor.text 			= self.rvr_item:get_honor()					-- 荣誉
	self.feats.text				= self.rvr_item:get_feats()  				-- 战功
end

-- function RvrView:show_view( show )
-- 	if not self.tween or not self:is_visible() then
-- 		return
-- 	end

-- 	if show then
-- 		self.tween:PlayReverse()
-- 	else
-- 		self.tween:PlayForward()
-- 	end
-- end

function RvrView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "rvr_statistics_btn" then -- 战场战况
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("rvrStatisticsView", self.rvr_item)
	end
end

function RvrView:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "FactionStatisticsR") then -- 战场实时数据
			self:update_ui()
		end
	end
end

function RvrView:register()
	StateManager:register_view( self )
end

function RvrView:cancel_register()
	StateManager:remove_register_view( self )
end

function RvrView:on_showed()
	self:register()
	if self.is_init then
		self:update_ui()
	end
end

function RvrView:on_hided()
	self:cancel_register()
end

-- 释放资源
function RvrView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return RvrView

