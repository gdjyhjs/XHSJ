--[[--
-- 公告编辑界面
-- @Author:Seven
-- @DateTime:2017-06-20 17:54:48
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local EditNoticeView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "release_notice.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function EditNoticeView:on_asset_load(key,asset)
	self:init_ui()
end

function EditNoticeView:init_ui()
	-- 输入框
	self.inputfield = self.items.InputField:GetComponent("UnityEngine.UI.InputField")
end

function EditNoticeView:on_click( sender, arg )
	local cmd = sender.name

	if cmd == "release_notice_close_btn" then 
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif cmd == "release_notice_send_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:modify_info_c2s(self.inputfield.text)
		self:dispose()

	elseif cmd == "release_notice_cancle_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("noticeView", self.item_obj)
		self:dispose()

	end
end

function EditNoticeView:on_receive( msg, id1, id2, sid )
	
end

function EditNoticeView:on_showed()
	StateManager:register_view( self )
end

function EditNoticeView:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function EditNoticeView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return EditNoticeView

