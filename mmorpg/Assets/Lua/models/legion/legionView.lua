--[[--
-- 军团主界面
-- @Author:Seven
-- @DateTime:2017-06-19 16:16:41
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LegionView=class(UIBase,function(self, item_obj)
    self.modify_btn_flag = false -- 是否处于修改宗旨状态
    self:set_bg_visible(true)
    UIBase._ctor(self, "legion_info.u3d", item_obj) -- 资源名字全部是小写
end)

local TextColor = 
{
	[1] = UnityEngine.Color(103/255, 248/255, 88/255,1), -- 在线
	[2] = UnityEngine.Color(148/255, 148/255, 148/255,1), -- 离线
}

local JobColor = 
{
	[ServerEnum.ALLIANCE_TITLE.LEADER] = "#e42626",
	[ServerEnum.ALLIANCE_TITLE.VICE_LEADER] = "#ff7e00",
	[ServerEnum.ALLIANCE_TITLE.STRATEGIST] = "#c742cc",
	[ServerEnum.ALLIANCE_TITLE.ADVISER] = "#615bdf",
	[ServerEnum.ALLIANCE_TITLE.PIONEER] = "#4cf9ff",
	[ServerEnum.ALLIANCE_TITLE.MEMBER] = "#604942FF",
}

-- 资源加载完成
function LegionView:on_asset_load(key,asset)
	
	self:hide_mainui(true)
	self:init_ui()
	self:msg_c2s()
end

function LegionView:init_ui()

	-- 军团图标
	self.legion_icon = LuaHelper.FindChildComponent(self.root,"legion_icon",UnityEngine_UI_Image)

	-- 军团名称
	self.legion_name = LuaHelper.FindChildComponent(self.root, "legion_name_txt", "UnityEngine.UI.Text")

	-- 军团等级
	self.legion_level = LuaHelper.FindChildComponent(self.root, "legion_level_txt", "UnityEngine.UI.Text")

	-- 军团资金
	self.legion_money = LuaHelper.FindChildComponent(self.root, "legion_money_txt", "UnityEngine.UI.Text")

	-- 军团人数
	self.legion_num = LuaHelper.FindChildComponent(self.root, "legion_num_txt", "UnityEngine.UI.Text")

	-- 军团宗旨
	self.legion_content = LuaHelper.FindChildComponent(self.root, "content_txt", "UnityEngine.UI.Text")
	self.legion_content_obj = LuaHelper.FindChild(self.root, "content_txt")

	-- 修改宗旨按钮文字
	self.modify_btn_txt = LuaHelper.FindChildComponent(self.root, "modify_btn_txt", "UnityEngine.UI.Text")

	self.input_field = LuaHelper.FindChildComponent(self.root, "InputField", "UnityEngine.UI.InputField")
	self.input_field_obj = LuaHelper.FindChild(self.root, "InputField")
	self.input_field_obj:SetActive(false)

	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	if not self.item_obj:get_permissions(ServerEnum.ALLIANCE_MANAGE.MODIFY_INFO) then
		LuaHelper.FindChild(self.root, "modify_btn"):SetActive(false)
	else
		LuaHelper.FindChild(self.root, "modify_btn"):SetActive(true)
	end

	-- self:refresh(self.item_obj:get_member_list())
end

function LegionView:update_ui(data)
	gf_print_table(data, "wtf data:")
	local icon = ConfigMgr:get_config("alliance_flag")[data.flag].icon
	gf_setImageTexture(self.legion_icon,icon)
	self.legion_name.text = data.name
	self.legion_level.text = data.level
	self.legion_money.text = data.fund or 0
	self.legion_num.text = data.memberSize.."/"..ConfigMgr:get_config("alliance")[data.level].max_member_size
	self.legion_content.text = data.introduction or ""
end

function LegionView:refresh( data )
	for i,v in ipairs(data or {}) do
		if v.logoutTm > 0 then
			data[i].logoutTmEx = 1
		else
			data[i].logoutTmEx = 0
		end
	end 
	local function sort_(a, b)
		local r
		local al = tonumber(a.logoutTmEx)
		local bl = tonumber(b.logoutTmEx)
		local aq = tonumber(a.title)
		local bq = tonumber(b.title)
		local aid = tonumber(a.power)
		local bid = tonumber(b.power)

		if al ~= bl  then
			return al < bl
		end
		if aq ~= bq then
			return aq < bq
		end
		return aid > bid
	end   
	table.sort(data,sort_)

	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1)
end

function LegionView:update_item( item, index, data )
	-- 名字
	item:Get(1).text = data.name
	-- 职位
	item:Get(2).text = string.format("<color=%s>%s</color>",JobColor[data.title], ClientEnum.LEGION_TITLE_NAME[data.title])
	-- 等级
	item:Get(3).text = data.level
	-- 战力
	item:Get(4).text = data.power
	-- 贡献
	local temp = self.item_obj:get_info()
	gf_print_table(temp, "wtf temp")
	item:Get(5).text = (data.donation or 0).."/"..(self.item_obj:get_info().donation or 0)



	local str = ""
	local color
	if data.logoutTm == 0 then
		str = gf_localize_string("在线")
		color = gf_get_color2(gf_get_color(ServerEnum.COLOR.GREEN))
	else
		str = gf_localize_string("离线")
		color = TextColor[2]
	end

	-- 状态
	item:Get(6).text = str
	item:Get(6).color = color
end

function LegionView:update_modiy_btn()
	if self.modify_btn_flag then
		self.item_obj:modify_info_c2s(nil, self.input_field.text)
	end

	self:set_edit_box()
end

function LegionView:set_edit_box()
	self.modify_btn_flag = not self.modify_btn_flag
	if self.modify_btn_flag then
		self.modify_btn_txt.text = gf_localize_string("确定")
		self.legion_content_obj:SetActive(false)
		self.input_field_obj:SetActive(true)
	else
		self.modify_btn_txt.text = gf_localize_string("修改宗旨")
		self.legion_content_obj:SetActive(true)
		self.input_field_obj:SetActive(false)

	end
end

function LegionView:clear_sub_view()
end

function LegionView:exit_legion()
	LuaItemManager:get_item_obejct("cCMP"):add_message(
		string.format(
			gf_localize_string("是否要退出<color=%s>%s</color>军团？\n<color=%s>（军团贡献将被清空）</color>"),
			gf_get_color(ServerEnum.COLOR.BLUE),
			self.item_obj:get_name(),
			gf_get_color(ServerEnum.COLOR.RED)
		),
		function()
			self.item_obj:quit_c2s()
		end,
		nil,
		function()
			
		end
	)
end

function LegionView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetMemberListR") then
			if self.is_get_normal then
				self.is_get_member = false
				self.is_get_normal = false
				self:refresh(self.item_obj:get_member_list())
			end
			self.is_get_member = true
		elseif id2 == Net:get_id2("alliance", "GetBaseInfoR") then
			self:update_ui(self.item_obj:get_info())
			if self.is_get_member then
				self.is_get_member = false
				self.is_get_normal = false
				self:refresh(self.item_obj:get_member_list())
			end
			self.is_get_normal = true
		elseif id2 == Net:get_id2("alliance", "ModifyInfoR")   then
			if msg.err ~= 0 then
				return
			end
			self.legion_content.text = self.input_field.text

		end
	end

	-- if id1 == Net:get_id1("copy") then
	-- 	if id2 == Net:get_id2("copy", "EnterCopyR") then -- 进入副本
	-- 		self:enter_copy_s2c(msg)
	-- 	end
	-- end

end

function LegionView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "modify_btn" then -- 修改宗旨
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:update_modiy_btn()

	elseif cmd == "out_legion_btn" then -- 退出军团
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:exit_legion()

	elseif cmd == "legion_chat_btn" then -- 军团聊天
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:remove_from_state()
		LuaItemManager:get_item_obejct("chat"):open_public_chat_ui(ServerEnum.CHAT_CHANNEL.ARMY_GROUP)

	elseif cmd == "legion_notice_btn" then -- 军团公告
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("noticeView", self.item_obj)

	elseif cmd == "legion_scene_btn" then -- 军团场景
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self.copy_data = self.item_obj:enter_scene()
		gf_getItemObject("legion"):enter_scene()

	end
end

function LegionView:enter_copy_s2c( msg )
	if msg.err == 0 then
		self.item_obj:remove_from_state()
		-- LuaItemManager:get_item_obejct("copy"):set_cur_copy_data(self.copy_data)
		LuaItemManager:get_item_obejct("battle"):change_scene(150102, true)
		
	end
end

function LegionView:msg_c2s()
	if self:is_loaded() then
		self.item_obj:get_member_list_c2s()
		self.item_obj:get_base_info_c2s()
	end
end

function LegionView:register()
	StateManager:register_view( self )
end

function LegionView:cancel_register()
	StateManager:remove_register_view( self )
end

function LegionView:on_showed()
	self:register()
	self:msg_c2s()
end

function LegionView:on_hided()
	self:cancel_register()
end

-- 释放资源
function LegionView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return LegionView

