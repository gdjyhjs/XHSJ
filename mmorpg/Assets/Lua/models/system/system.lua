--[[--
--
-- @Author:LiYunFei
-- @DateTime:2017-03-25 15:38:56
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local System = LuaItemManager:get_item_obejct("system")
--UI资源
System.assets=
{
    View("systemView", System) 
}

--点击事件
function System:on_click(obj,arg)
	self:call_event("system_view_on_clict", false, obj, arg)
end

--每次显示时候调用
function System:on_showed( ... )

end

--初始化函数只会调用一次
function System:initialize()
	
end

