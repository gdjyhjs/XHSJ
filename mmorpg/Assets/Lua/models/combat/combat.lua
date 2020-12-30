--[[--
--
-- @Author:Seven
-- @DateTime:2017-03-27 12:32:47
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Combat = LuaItemManager:get_item_obejct("combat")
--UI资源
Combat.assets=
{
    View("combatView", Combat) 
}

--点击事件
function Combat:on_click(obj,arg)
	self:call_event("combat_view_on_clict", false, obj, arg)
end

--每次显示时候调用
function Combat:on_showed( ... )

end

--初始化函数只会调用一次
function Combat:initialize()
	
end

