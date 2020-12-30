--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-03-29 14:54:44
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local WifgetTimeCellSignal = LuaItemManager:get_item_obejct("wifgetTimeCellSignal")
--UI资源
WifgetTimeCellSignal.assets=
{
    View("wifgetTimeCellSignalView", WifgetTimeCellSignal) 
}