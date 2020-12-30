--[[--
-- 军团审批申请列表界面
-- @Author:Seven
-- @DateTime:2017-06-19 21:11:40
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LegionApplyView=class(UIBase,function(self)
	local item_obj = gf_getItemObject("legion")
    UIBase._ctor(self, "legion_request_list.u3d", item_obj) -- 资源名字全部是小写
    
end)

-- 资源加载完成
function LegionApplyView:on_asset_load(key,asset)
	self:init_ui()

	self.item_obj:get_apply_list_c2s()
end

function LegionApplyView:init_ui()
	print("wtf. hhh:",gf_getItemObject("legion"):get_auto_allow())
	self.refer:Get(1):SetActive(gf_getItemObject("legion"):get_auto_allow() == 1)

	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)
end

function LegionApplyView:refresh( data )
	
	self.refer:Get(2):SetActive(false)
	if not next(data or {}) then
		self.refer:Get(2):SetActive(true)
	end

	self.scroll_table.data = {}
	self.scroll_table:Refresh(-1,-1)

	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1)
end

function LegionApplyView:update_item( item, index, data )
	-- 高亮图片
	-- item:Get(1)

	-- 名字
	item:Get(2).text = data.name
	-- 等级
	item:Get(3).text = data.level
	-- 职业
	item:Get(4).text = ClientEnum.JOB_NAME[data.career]
	-- 战力
	item:Get(5).text = data.power
end

function LegionApplyView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetApplyListR") then
			self:refresh(self.item_obj:get_apply_list())

		elseif id2 == Net:get_id2("alliance", "ApplyReplyR") then
			self.item_obj:get_apply_list_c2s()
			self.item_obj:get_member_list_c2s()

		end
	end
end
 

function LegionApplyView:check_permission()
	if self.item_obj:get_permissions(ServerEnum.ALLIANCE_MANAGE.TITLE_MANAGE) then -- 没有职位管理权限
		return true
	else
		gf_message_tips(gf_localize_string("你没有管理权限"))
	end
end
function LegionApplyView:check_permission2()
	if self.item_obj:get_permissions(ServerEnum.ALLIANCE_MANAGE.ACCEPT_APPLY) then -- 没有职位管理权限
		return true
	else
		gf_message_tips(gf_localize_string("你没有权限"))
	end
end

function LegionApplyView:auto_check_click(arg)
	arg:SetActive(not arg.activeSelf)

	gf_getItemObject("legion"):send_to_modify_join_limit(nil,nil,arg.activeSelf and 1 or 0)
end

function LegionApplyView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("LegionApplyView on_click",cmd)
	if cmd == "refresh_btn" then -- 刷新列表
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:get_apply_list_c2s()

	elseif cmd == "all_ignore_btn" then -- 忽略全部
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if #self.item_obj:get_apply_list() == 0 then
			gf_message_tips(gf_localize_string("申请列表为空，无法忽略"))
			return
		end
		if self:check_permission2() then
			self.item_obj:one_key_reject_c2s()
			local temp = self.item_obj:get_apply_list()
			self:refresh(temp)
		end

	elseif cmd == "agree_legion_req_btn" then -- 同意
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self:check_permission2() then
			self.item_obj:apply_reply_c2s(arg.data.roleId, true)
			
		end

	elseif cmd == "ignore_btn" then -- 忽略
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self:check_permission2() then
			self.item_obj:apply_reply_c2s(arg.data.roleId, false)
			
		end

	elseif cmd == "career_mgr_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.legion.legionApplySetting")()

	elseif cmd == "career_mgr_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.legion.legionPositionMgr")()

	elseif cmd == "apply_close_Btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
		self:dispose()

	elseif cmd == "auto_join_check" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:auto_check_click(arg)

	elseif cmd == "all_agree_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:apply_reply_c2s(0, true)

	end
end

function LegionApplyView:clear_sub_view()
	if self.last_view then
		self.last_view:hide()
		self.last_view = nil
	end
end

function LegionApplyView:on_showed()
	StateManager:register_view( self )
end

function LegionApplyView:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function LegionApplyView:dispose()
	self.lastView = nil
	StateManager:remove_register_view( self )
    self._base.dispose(self)
end

return LegionApplyView

