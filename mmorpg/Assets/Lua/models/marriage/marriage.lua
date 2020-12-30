--[[--
--
-- @Author:huangjunshan
-- @DateTime:2017-08-17 20:36:55
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Marriage = LuaItemManager:get_item_obejct("marriage")
--UI资源
Marriage.assets=
{
    View("marriageView", Marriage) 
}

--点击事件
function Marriage:on_click(obj,arg)
	return true
end

--每次显示时候调用
function Marriage:on_showed( ... )

end

--初始化函数只会调用一次
function Marriage:initialize()
	
end

