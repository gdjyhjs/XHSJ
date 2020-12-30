--[[--
--
-- @Author:huangjunshan
-- @DateTime:2017-08-17 20:42:50
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SwornBrothers = LuaItemManager:get_item_obejct("swornBrothers")
--UI资源
SwornBrothers.assets=
{
    View("swornBrothersView", SwornBrothers) 
}

--点击事件
function SwornBrothers:on_click(obj,arg)
	return true
end

--每次显示时候调用
function SwornBrothers:on_showed( ... )

end

--初始化函数只会调用一次
function SwornBrothers:initialize()
	
end

