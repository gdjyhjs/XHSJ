--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-08-14 20:52:28
--]]

local DestinyTools = {}
local itemSys = LuaItemManager:get_item_obejct("itemSys")

--图标
-- "destiny_bg_0"..color
-- "destiny_bg"
-- 
function DestinyTools:get_destiny_bg(color)
	return color and "destiny_bg_0"..color or "destiny_bg"
end



return DestinyTools
