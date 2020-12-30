--[[
	pvp等待复活界面界面  属性
	create at 17.10.13
	by xin
]]
local dataUse = require("models.hero.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "pvp_revive.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local relive = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function relive:on_asset_load(key,asset)
    self:init_ui()
end

function relive:init_ui()
	self:start_scheduler()
end

function relive:start_scheduler()
	self.start_time = Net:get_server_time_s()
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		local time = Net:get_server_time_s() - self.start_time
		time = math.floor(time)
		if time <= 5 then
			self.refer:Get(1).text = 5 - time
		else
			self:stop_schedule()
		end
	end
	update()
	self.schedule_id = Schedule(update, 0.01)
end

function relive:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

--鼠标单击事件
function relive:on_click( obj, arg)
	local event_name = obj.name
	print("relive click",event_name)
    if event_name == "hero_property" then 
    end
end

function relive:on_showed()
	StateManager:register_view(self)
end

function relive:clear()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function relive:on_hided()
	self:clear()
end
-- 释放资源
function relive:dispose()
	self:clear()
    self._base.dispose(self)
end

function relive:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "WakeUpHeroR") then
		end
	end
	if id1 == ClientProto.PlayerBlood then
		if msg.player_hp > 0 then
			self:dispose()
		end
	end
end

return relive