--[[--
-- 公告界面
-- @Author:Seven
-- @DateTime:2017-06-20 17:54:48
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local NoticeView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "legion_notice.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function NoticeView:on_asset_load(key,asset)
	self:init_ui()
	self.item_obj:get_announcement_c2s()
end

function NoticeView:init_ui()
	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	if self.item_obj:get_permissions(ServerEnum.ALLIANCE_MANAGE.MODIFY_INFO) then
		LuaHelper.FindChild(self.root, "legion_notice_sure_btn"):SetActive(true)
	else
		LuaHelper.FindChild(self.root, "legion_notice_sure_btn"):SetActive(false)
	end
end

function NoticeView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1)
end

function NoticeView:update_item( item, index, data )
	-- 时间
	item:Get(1).text = gf_get_time_stamp(data.time)
	-- 名字
	item:Get(2).text = data.name
	-- 内容
	item:Get(3).text = data.content
end

function NoticeView:on_click( sender, arg )
	local cmd = sender.name
	if cmd == "legion_notice_close_btn" then 
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif cmd == "legion_notice_sure_btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		View("editNoticeView", self.item_obj)
		self:dispose()

	end
end

function NoticeView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetAnnouncementR") then
			gf_print_table(msg, "公告")
			self:refresh(msg.announcement)
		end
	end
end

function NoticeView:on_showed()
	StateManager:register_view( self )
end

function NoticeView:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function NoticeView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return NoticeView

