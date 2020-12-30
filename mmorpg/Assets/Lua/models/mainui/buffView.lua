--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-28 11:31:32
--]]

local BuffView = class(function ( self, ui, item_obj )
	self.ui = ui
	self.item_obj = item_obj
	self:init()
end)

function BuffView:init()
	self:init_ui()
end
function BuffView:init_ui()
	self.buff_item = self.ui.buff
	self.scroll_left_table = self.buff_item:Get("Content")
	self.scroll_left_table.onItemRender = handler(self,self.update_left_item)
	self:refresh_left(LuaItemManager:get_item_obejct("buff"):get_buff_data())
end

function BuffView:refresh_left(data)
	self.scroll_left_table.data = data
	self.scroll_left_table:Refresh(0 ,-1) --显示列表
end

function BuffView:update_left_item(item,index,data)
	gf_setImageTexture(item:Get(1),data.icon)
end
--点击事件
function BuffView:on_click(item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd =="buff_item(Clone)" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("buff信息")
		require("models.buff.buffTips")()
	end
end

function BuffView:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.BuffInfo then
		self:refresh_left(msg)
	end
end

return BuffView
