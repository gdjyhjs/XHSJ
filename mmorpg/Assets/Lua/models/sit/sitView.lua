--[[--
-- 打坐UI
-- @Author:Seven
-- @DateTime:2017-06-26 12:32:04
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SitView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "sit_invitation.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function SitView:on_asset_load(key,asset)
	self.is_init = true

	self:register()

	self.scroll_table = self.refer:Get("scrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	self.toggle = self.refer:Get("toggle")
	self.toggle.isOn = self.item_obj.is_auto_accept

	self.item_obj:get_near_role_list_c2s()
end

function SitView:refresh( data )
	if not data then
		return
	end

	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function SitView:update_item( item, index, data )
	-- 名字
	item:Get(1).text = data.name
	-- 等级
	item:Get(2).text = data.level
	-- 玩家头像
	gf_set_head_ico(item:Get(3), data.head)
	-- 友好度
	item:Get(4).text = data.intimacy == -1 and 0 or data.intimacy
end

function SitView:on_click( item_obj, sender, arg )
	local cmd = sender.name
	
	if cmd == "sit_invitation_close" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:remove_from_state()

	elseif cmd == "one_key_invite_btn" then -- 一键邀请
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if not self.item_obj:get_invite_list() or #self.item_obj:get_invite_list() == 0 then
			gf_message_tips(gf_localize_string("没有可以邀请的玩家"))
			return
		end

		gf_message_tips(gf_localize_string("已发出邀请"))
		self.item_obj:one_key_invite_near_c2s()
		self.item_obj:remove_from_state()
		

	elseif cmd == "invite_btn" then -- 邀请
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_message_tips(gf_localize_string("已发出邀请"))
		self.item_obj:invite_rest_c2s(arg.data.roleId)
		self.item_obj:remove_from_state()

	elseif cmd == "Toggle" then -- 是否自动接收打坐邀请
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if arg.isOn then
			self.item_obj:set_auto_accept_c2s(1)
		else
			self.item_obj:set_auto_accept_c2s(0)
		end
	end
end

function SitView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "NearRoleListR") then -- 可以邀请列表
			self:refresh(self.item_obj:get_invite_list())

		elseif id2 == Net:get_id2("scene", "InviteRestR") or 
		       id2 == Net:get_id2("scene", "OneKeyInviteNearR") then
		    if msg.err == 0 then
				gf_message_tips(gf_localize_string("邀请成功"))
		    end
		end
	end
end

function SitView:on_showed()
	if self.is_init then
		self.item_obj:get_near_role_list_c2s()
	end
end

function SitView:register()
	-- StateManager:register_view( self )
	self.item_obj:register_event("on_clict", handler(self, self.on_click))
end

function SitView:cancel_register()
	-- StateManager:remove_register_view( self )
	self.item_obj:register_event("on_clict", nil)
end

-- 释放资源
function SitView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return SitView

