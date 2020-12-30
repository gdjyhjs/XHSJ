--[[--
-- 成就
-- @Author:xcb
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper

local AchievementTips = LuaItemManager:get_item_obejct("achievementTips")
--UI资源
AchievementTips.assets=
{
    --View("achievementTipsView", AchievementTips) 
}

--初始化函数只会调用一次
function AchievementTips:initialize()
end

function AchievementTips:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end

