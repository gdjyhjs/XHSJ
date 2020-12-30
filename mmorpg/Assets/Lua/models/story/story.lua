--[[--
-- 剧情
-- @Author:Seven
-- @DateTime:2017-08-15 09:49:44
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Story = LuaItemManager:get_item_obejct("story")

--点击事件
function Story:on_click(obj,arg)
end

--每次显示时候调用
function Story:on_showed( ... )

end

--初始化函数只会调用一次
function Story:initialize()
	self.story_view = nil
end

function Story:dispose()
	-- if self.story_view then
	-- 	self.story_view:dispose()
	-- end
	-- self.story_view = nil

	Story._base.dispose(self)
end

-- 显示剧情
function Story:set_data( data )
	-- if not self.story_view then
		local cb = function( view )
			view:set_data(data)
		end
		self.story_view = View("storyView", self, nil, cb)

	-- else
	-- 	self.story_view:set_data(data)
	-- end
end
