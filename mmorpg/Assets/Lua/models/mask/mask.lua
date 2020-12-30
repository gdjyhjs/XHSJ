--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-22 20:35:01
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Mask = LuaItemManager:get_item_obejct("mask")
Mask.priority = ClientEnum.PRIORITY.LOADING_MASK

--UI资源
Mask.assets=
{
    View("maskView", Mask) 
}

--点击事件
function Mask:on_click(obj,arg)
	return true
end

--每次显示时候调用
function Mask:on_showed()

end

--初始化函数只会调用一次
function Mask:initialize()
	
end

-- 超时回调
function Mask:set_time_out_cb( cb )
	self.time_out_cb = cb
end

function Mask:time_out()
	if self.time_out_cb then
		self.time_out_cb()
	end
end

Mask:on_focus()

