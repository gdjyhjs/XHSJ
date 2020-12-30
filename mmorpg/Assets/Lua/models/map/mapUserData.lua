--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-08-05 10:43:18
--]]

local MapUserData = {}
local Enum = require("enum.enum")

local obj_key_name = {
	[Enum.MAP_OBJECT_TYPE.PATH_POINT] = "path_ico",--寻路点
	[Enum.MAP_OBJECT_TYPE.NPC] = "npc_mark", --npc
	[Enum.MAP_OBJECT_TYPE.TRANPORT] = "trad_mark", --传送阵
	[Enum.MAP_OBJECT_TYPE.CREATURE] = "creature_mark", --怪物
	[Enum.MAP_OBJECT_TYPE.CREATURE_CENTER] = "creature_mark",--寻路点
}

function MapUserData:get_obj_key_name(MAP_OBJECT_TYPE)
	return obj_key_name[MAP_OBJECT_TYPE] or "common"
end


return MapUserData
