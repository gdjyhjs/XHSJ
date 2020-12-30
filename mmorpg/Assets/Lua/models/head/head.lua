--[[--
--
-- @Author:LiYunFei
-- @DateTime:2017-03-27 14:01:13
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Head = LuaItemManager:get_item_obejct("head")
--UI资源
Head.assets=
{
    View("headView", Head) 
}

--点击事件
function Head:on_click(obj,arg)
	self:call_event("head_view_on_clict", false, obj, arg)
end

--每次显示时候调用
function Head:on_showed( ... )

end

--初始化函数只会调用一次
function Head:initialize()
	
end

