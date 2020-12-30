--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-01 11:47:10
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Npc = LuaItemManager:get_item_obejct("npc")

--初始化函数只会调用一次
function Npc:initialize()
	self:init_info()
	print("初始化npc数据类")
end
function Npc:init_info()
	local data = ConfigMgr:get_config("npc_talk")
	self.npc_talk_tb = copy(data)
	local tb = ConfigMgr:get_config("npc_move")
	self.npc_move_tb = copy(tb)
	local npc_data = ConfigMgr:get_config("npc")
	self.npc_day_talk = {}
	for k,v in pairs(npc_data) do
		if v.touch == 1 then
			local x = #self.npc_day_talk+1
			self.npc_day_talk[x]= copy(v)
		end
	end
end
