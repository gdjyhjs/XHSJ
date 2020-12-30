--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 09:57:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MozuView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "defense.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function MozuView:on_asset_load(key,asset)
	self:init_ui()
end

function MozuView:init_ui()
	self.time_text = self.refer:Get(1)	--luaHelper.Find(self.root,"timeText")
	--[[if self.item_obj.end_time <= Net:get_server_time_s() then
		self:start_scheduler()
		local left_time = self.item_obj.end_time - Net:get_server_time_s()
		self.time_text.text = gf_convert_timeEx(left_time)
	else
		self.time_text.text = "00:00:00"
	end]]
	local data = ConfigMgr:get_config("daily")[2007]
	local str = string.format("%02d:%02d-%02d:%02d",data.day_time[1],data.day_time[2],data.day_time[3],data.day_time[4])
	self.time_text.text = str
end

function MozuView:on_click( item_obj, obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "enter_btn" then -- 进入副本
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		--if gf_getItemObject("activeDaily"):is_have_active(ClientEnum.MAIN_UI_BTN.DEFENSE) == true then
			LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(130001)
		--else
		--	gf_message_tips(gf_localize_string("该活动已经结束"))
		--end
	elseif cmd == "closeBtn" then -- 关闭
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

function MozuView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function MozuView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function MozuView:on_showed()
	self:register()
end

function MozuView:on_hided( )
	self:cancel_register()
	self:stop_schedule()
end

-- 释放资源
function MozuView:dispose()	
	self:cancel_register()
	self:stop_schedule()
    self._base.dispose(self)
end


function MozuView:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local end_time = self.item_obj.end_time
	local update = function()
		local left_time = end_time - Net:get_server_time_s()
		self.time_text.text = gf_convert_timeEx(left_time)
		if left_time <= 0 then
			self:stop_schedule()
			return
		end
		
	end
	self.schedule_id = Schedule(update, 0.5)
end

function MozuView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

return MozuView

