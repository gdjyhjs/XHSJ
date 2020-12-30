--[[--
-- 军团基础架构界面
-- @Author:Seven
-- @DateTime:2017-06-19 20:44:23
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local CreateBaseView=class(UIBase,function(self,item_obj)
    self.view_list = {}
    self:set_bg_visible(true)
    UIBase._ctor(self, "create_base_view.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function CreateBaseView:on_asset_load(key,asset)
	
	self:hide_mainui()
	self:init_ui()
end

function CreateBaseView:init_ui()

	self.page_mgr = PageMgr(self.refer:Get("yeqian"))

	self:select_page(1)
end


function CreateBaseView:select_page( page )
	if not self.page_mgr then
		return
	end
	
	self.page_mgr:select_page(page)
	if self.page_mgr:get_last_page() and self.view_list[self.page_mgr:get_last_page()] then
		self.view_list[self.page_mgr:get_last_page()]:hide()
	end

	if not self.view_list[page] or not self.view_list[page].root then
		if page == 1 then -- 信息
			self.view_list[page] = self:create_sub_view("applyView")

		elseif page == 2 then -- 管理
			self.view_list[page] = self:create_sub_view("createLegionView")

		end
	else
		self.view_list[page]:show()
	end
end

function CreateBaseView:create_sub_view( name, ... )
	local view = require("models.legion."..name)(self.item_obj, ...)
	self:add_child(view)
	return view
end

function CreateBaseView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "BuildR") then
			if msg.err == 0 then
				self.item_obj:add_to_state()
				self:dispose()
			end

		end
	end
end

function CreateBaseView:check_permission()
	if self.item_obj:get_permissions(ServerEnum.ALLIANCE_MANAGE.TITLE_MANAGE) then -- 没有职位管理权限
		return true
	else
		gf_message_tips(gf_localize_string("你没有管理权限"))
	end
end

function CreateBaseView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "legion_apply_colse_btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif string.find(cmd, "page") then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
		self:select_page(arg.transform:GetSiblingIndex()+1)

	elseif cmd == "chat_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:dispose()
		LuaItemManager:get_item_obejct("chat"):open_public_chat_ui(ServerEnum.CHAT_CHANNEL.CURRENT)
	end

end

function CreateBaseView:register()
	StateManager:register_view( self )
end

function CreateBaseView:cancel_register()
	StateManager:remove_register_view( self )
end

function CreateBaseView:show()
	CreateBaseView._base.show(self, true)
end

function CreateBaseView:on_showed()
	self:register()
	if self:is_loaded() then
		self:select_page(1)
	end
end

function CreateBaseView:on_hided()
	self:cancel_register()
end

-- 释放资源
function CreateBaseView:dispose()
	self.view_list = {}
	self:cancel_register()
    self._base.dispose(self)
end

return CreateBaseView

