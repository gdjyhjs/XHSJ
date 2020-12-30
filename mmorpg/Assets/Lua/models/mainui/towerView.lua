--[[--
-- 爬塔副本任务栏ui
-- @Author:Seven
-- @DateTime:2017-07-26 19:35:42
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LocalString = 
{
	[1] = gf_localize_string("倒计时："),
	[2] = gf_localize_string("第%d层"),
	[3] = gf_localize_string("最高层数："),
}

local TowerView=class(function(self, root, refer)
    self.root = root
    self.refer = refer

    self.copy_item = LuaItemManager:get_item_obejct("copy")

    self:init_ui()
end)

function TowerView:init_ui()
	self.time_txt = self.refer:Get("time")
	self.floor = self.refer:Get("floor")
	self.max_floor = self.refer:Get("max_floor")

	self.scroll_table = self.refer:Get("scroll_table")
	self.scroll_table.onItemRender = handler(self, self.update_item)
end

function TowerView:update_time( dt )
	if not self.time or self.is_time_out then
		return
	end
	local time = self.time - Net:get_server_time_s()
	if time < 0 then
		if not self.is_time_out then
			self.is_time_out = true

			gf_getItemObject("copy"):exit()

		end
		time = 0
	end

	if self.time_txt then
		self.time_txt.text = LocalString[1]..gf_convert_time(time)
	end
end

function TowerView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function TowerView:update_item( item, index, data )
	gf_set_item(data[1], item:Get(1), item:Get(2))
end

function TowerView:update_view()
	self.is_time_out = false

	local tower_id = gf_getItemObject("copy"):get_tower_copy_id()
	local reward = gf_get_config_table("copy_tower")[tower_id].reward_item or {}

	self:refresh(reward)

	local copy_time_limit = gf_get_config_table("copy")[tower_id].time_limit

	self.total_time = copy_time_limit
	self.time = (gf_getItemObject("copy"):get_time() or Net:get_server_time_s()) + copy_time_limit

	local cur_floor = gf_getItemObject("copy"):get_tower_floor()

	self.floor.text = string.format(LocalString[2], cur_floor)

end

function TowerView:on_receive(msg, id1, id2, sid)
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "PassCopyR") then -- 继续挑战
			self.time = nil
		end
	end
end

return TowerView

