--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-17 15:11:20
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Announcement = LuaItemManager:get_item_obejct("announcement")
--UI资源
Announcement.assets=
{
    View("announcementView", Announcement) 
}

Announcement.event_name = "announcement_view_on_click"
--点击事件
function Announcement:on_click(obj,arg)
	self:call_event(self.event_name, false, obj, arg)
end

--每次显示时候调用
function Announcement:on_showed( ... )

end

--初始化函数只会调用一次
function Announcement:initialize()
	
end

--判断是否有未读公告
function Announcement:show_red()
	local data = ConfigMgr:get_config("announcement")
	for i,v in ipairs(data) do
		if v.order>0 and v.order>UnityEngine.PlayerPrefs.GetInt("announcement"..i,0) then
			return true
		end
	end
	return false
end