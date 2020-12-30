--[[
	过关斩将失败界面
	create at 17.7.20
	by xin
]]
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "challenge_default.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local challengeDefault = class(UIBase,function(self,msg)
	
	self.msg = msg

	local item_obj = LuaItemManager:get_item_obejct("challenge")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function challengeDefault:on_asset_load(key,asset)
	self:init_ui()
end        

function challengeDefault:init_ui()
	self:start_scheduler()
end



--鼠标单击事件
function challengeDefault:on_click( obj, arg)
	print("wtf challengeDefault click",obj.name)
    local event_name = obj.name
    if event_name == "back_btn" then 
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效

    elseif event_name == "btn_RecoverPiont3" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()
    	LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()

    end
end

function challengeDefault:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	self.tick_time = Net:get_server_time_s()
	local update = function()
		--8秒自动离开副本
		if self.tick_time then
			if Net:get_server_time_s() - self.tick_time >= 8 then
				LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
				self:stop_schedule()
				self.tick_time = nil
			end
		end
	end
	update()
	self.schedule_id = Schedule(update, 0.1)
end
function challengeDefault:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function challengeDefault:clear()
	StateManager:remove_register_view(self)
	self:stop_schedule()
end
function challengeDefault:on_showed()
	StateManager:register_view(self)
end
function challengeDefault:on_hided()
	self:clear()
end
-- 释放资源
function challengeDefault:dispose()
	self:clear()
    self._base.dispose(self)
end

function challengeDefault:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then 
		if id2 == Net:get_id2("copy", "PassCopyR") then
			
		end
	end
end

return challengeDefault