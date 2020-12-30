--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-09 18:14:39
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Uimask = LuaItemManager:get_item_obejct("uimask")
--UI资源
Uimask.assets=
{
    View("uimaskView", Uimask) 
}

--点击事件
function Uimask:on_click(obj,arg)
	return true
end

--每次显示时候调用
function Uimask:on_showed( ... )

end

--初始化函数只会调用一次
function Uimask:initialize()
	
end

