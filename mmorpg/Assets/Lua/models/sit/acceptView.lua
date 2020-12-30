--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-27 09:17:42
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local AcceptView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "sit_receive.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function AcceptView:on_asset_load(key,asset)
	self:register()
	self:init_ui()
	self.item_obj:get_be_invite_list_c2s()
	self:update_red_point()
end

function AcceptView:init_ui()
	self.scroll_table = self.refer:Get("scrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)
end

function AcceptView:update_red_point()
	Net:receive({id=ClientEnum.MAIN_UI_BTN.SIT, visible = false}, ClientProto.ShowOrHideMainuiBtn)
end

function AcceptView:refresh( data )
	if not data then
		return
	end

	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function AcceptView:update_item( item, index, data )
	item:Get(1).text = data.name
	item:Get(2).text = data.level
	gf_set_head_ico(item:Get(3), data.head)
end

function AcceptView:on_click( sender, arg )
	local cmd = sender.name
	if cmd == "sit_receive_close" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:one_key_refuse_invite_c2s()
		self:dispose()

	elseif cmd == "refuse_btn" then -- 全部拒绝
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:one_key_refuse_invite_c2s()
		self:dispose()

	elseif cmd == "agree_btn" then -- 同意
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:assept_invite_rest_c2s(arg.data.roleId)
		self:dispose()
		
	end
end

function AcceptView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "GetBeInviteListR") then -- 获取收到邀请列表
			self:refresh(self.item_obj.be_invite_list)
		end
	end
end

function AcceptView:register()
	StateManager:register_view( self )
end

function AcceptView:cancel_register()
	StateManager:remove_register_view( self )
end

-- 释放资源
function AcceptView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return AcceptView

