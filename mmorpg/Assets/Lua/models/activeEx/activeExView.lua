--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 09:57:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveExView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "service_open_activity.u3d") -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function ActiveExView:on_asset_load(key,asset)
end

function ActiveExView:init_ui()
	self.rotation_total_time = 3
	self.rotation_pass_time = 0
	self.select_index = 1
	self.title_list = LuaItemManager:get_item_obejct("activeEx"):get_time_list()
	self.list_data = {}
	self.left_scroll = self.refer:Get(1)

	local function update_title(item,index,data)
		local button = item:Get(1)
		local text = item:Get(2)
		if self.select_index == index then
			item:GetComponent("UnityEngine.UI.Button").interactable = false
			button.gameObject:SetActive(true)
			local name = string.format("<color=#F8D4BAFF>%s</color>",ConfigMgr:get_config("activity_server_start")[data].name)
			text.text = name
		else
			item:GetComponent("UnityEngine.UI.Button").interactable = true
			button.gameObject:SetActive(false)
			local name = string.format("<color=#F4B597FF>%s</color>",ConfigMgr:get_config("activity_server_start")[data].name)
			text.text = name
		end
		item.name = string.format("preItem%s",index)

		local flag = LuaItemManager:get_item_obejct("activeEx"):get_red_point(data)
		local red_point = item:Get(3)
		red_point:SetActive(flag)
	end

	self.left_scroll.data = self.title_list

	self.left_scroll.onItemRender = update_title
	self.left_scroll:Refresh(0,#self.title_list - 1)
	self:stop_schedule()
	self:show_page(self.select_index)
end

function ActiveExView:on_click( item_obj, obj, arg )
	local event_name = obj.name
	if string.find(event_name,"preItem") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"preItem","")
		index = tonumber(index)
		self.left_scroll:Refresh(self.select_index - 1,self.select_index -1)
		self.left_scroll:Refresh(index - 1,index -1)
		self.select_index = index
		self:show_page(self.select_index)
	elseif event_name == "closeBtn" then
		self:dispose()
	end
end
		
function ActiveExView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function ActiveExView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function ActiveExView:on_showed()
	self:register()
	self:init_ui()
end

function ActiveExView:on_hided( )
	self:cancel_register()
	self:stop_schedule()
end

function ActiveExView:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.closeActiveEx then
		self:dispose()
	end
	if id1 == ClientProto.ShowHotPoint then
		if msg.btn_id == ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER then
			self.left_scroll:Refresh(0,#self.title_list - 1)
		end
	end
end

function ActiveExView:show_page(index)
	self:stop_schedule()
	if self.sub_ui ~= nil then
		self.sub_ui:dispose()
	end
	self.select_index = index
	local activity_id = self.title_list[index]
	local activity_type = ConfigMgr:get_config("activity_server_start")[activity_id].activity_type
	LuaItemManager:get_item_obejct("activeEx").activity_id = activity_id
	if activity_type == 1 then	--登录
		self.sub_ui = require("models.activeEx.activeExLogin")()
	elseif activity_type == 2 then	--排行
		self.sub_ui = require("models.activeEx.activeExRank")()
	elseif activity_type == 3 then	--兑换
		self.sub_ui = require("models.activeEx.activeExExchange")()
	elseif activity_type == 4 then	--任务
		self.sub_ui = require("models.activeEx.activeExTask")()
	elseif activity_type == 5 then	--转盘
		self.sub_ui = require("models.activeEx.activeExWheel")()
	end
end
-- 释放资源
function ActiveExView:dispose()
	if self.sub_ui ~= nil then
		self.sub_ui:dispose()
	end	
	self:cancel_register()
    self._base.dispose(self)
    self:stop_schedule()
end

function ActiveExView:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function(dt)
		if self.rotation_pass_time < self.rotation_total_time then
			self.rotation_pass_time = self.rotation_pass_time + dt
			local add_rotation = self.speed * dt
			self.total_rotation = self.total_rotation - add_rotation
			self.speed = self.speed - self.damp * dt
		else
			self:stop_schedule()
		end
	end
	self.schedule_id = Schedule(update, 0.05)
end

function ActiveExView:play_rotation(reward_id)
	local cur_rotation = self.refer.transform.rotation.z
	self.total_rotation = 360 - cur_rotation + self:get_reward_rotation(reward_id) + 360
	self.damp = 2 * self.total_rotation / (self.rotation_total_time * self.rotation_total_time)
	self.speed = self.damp * self.rotation_total_time
end

function ActiveExView:get_reward_rotation(reward_id)
	return 30
end

function ActiveExView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

return ActiveExView