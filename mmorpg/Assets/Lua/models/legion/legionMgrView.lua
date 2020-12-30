--[[--
-- 军团职位管理界面
-- @Author:Seven
-- @DateTime:2017-06-19 21:07:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local commom_string =
{
	[1] = gf_localize_string("请选择成员"),
	[2] = gf_localize_string("离线"),
	[3] = gf_localize_string("<color=#36C548>在线</color>"),
	[4] = gf_localize_string("退出军团后，<color=#B01FE5>军团贡献和军团仓库积分将会被清空</color>，确定要退出军团吗？"),
	[5] = gf_localize_string("解散军团后，军团将会<color=#B01FE5>永久消失</color>，<color=#B01FE5>所有军团成员</color>将会<color=#B01FE5>退出军团</color>，确定要解散军团吗？"),
	[6] = gf_localize_string("<color=#585858>%s在线</color>"),
	[7] = gf_localize_string("踢出军团"),
	[8] = gf_localize_string("设为"),
	[9] = gf_localize_string("确定要弹劾统帅，自荐成为新统帅吗？若统帅在48小时内仍未上线，你将会成为新的统帅！"),
	[10] = gf_localize_string("转让"),
}

local sort_type_enum = 
{
	"get_sort_normal"       	,
	"get_sort_donation"     	,
	"get_sort_power"      	,
	"get_sort_online"       	,
}

local LegionMgrView=class(UIBase,function(self)
	local item_obj = gf_getItemObject("legion")	
    UIBase._ctor(self, "legion_job_mgr.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function LegionMgrView:on_asset_load(key,asset)

	self.rec_member_info = false
	self.rec_my_info = false
	self.item_obj:get_member_list_c2s()
	self.item_obj:get_apply_list_c2s() 					--可以做成缓存模式 不用重新获取
	LuaItemManager:get_item_obejct("legion"):get_my_info_c2s()
end

function LegionMgrView:init_online_count()
	local now = gf_getItemObject("legion"):get_on_line_member_count()
	local total = #gf_getItemObject("legion"):get_member_list()
	self.refer:Get(2).text = string.format("%d/%d",now,total)
end

function LegionMgrView:init_ui()
	self:init_online_count()
	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)
	self:permission_view_init()
	self:refresh(self.item_obj:get_member_list())
	self:rank_view_init()
end

function LegionMgrView:permission_view_init()
	local can_dispose = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.DISSOLVE)
	local can_add = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.ACCEPT_APPLY)
	local can_edit_add = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.MODIFY_JOIN_LIMIT)
	--弹劾
	local can_tick = gf_getItemObject("legion"):get_info().isImpeaching == 1

	self.refer:Get(3):SetActive(can_dispose)
	self.refer:Get(6):SetActive(can_add)
	self.refer:Get(5):SetActive(can_edit_add)
	self.refer:Get(7):SetActive(can_tick)
	
end
function LegionMgrView:refresh( data ,sort_type)
	sort_type = sort_type or 1
	local temp = gf_deep_copy(data)

	local time = Net:get_server_time_s()

	for i,v in ipairs(temp) do
		if v.logoutTm == 0 then
			temp[i].logoutTmEx = time
		else
			temp[i].logoutTmEx = time + 1
		end
	end

	local sort_func = self[sort_type_enum[sort_type]]
	if sort_func then
		sort_func(self,temp)
	end
	self.temp = temp

	self.scroll_table.data = temp
	self.scroll_table:Refresh(-1,-1)

end

--按总规则排序
function LegionMgrView:get_sort_normal(temp)
	local function sort_(ai, bi)
		if ai.logoutTmEx ~= bi.logoutTmEx then
			return ai.logoutTmEx < bi.logoutTmEx
		end
		if ai.title ~= bi.title then
			return ai.title < bi.title
		end
		if ai.donation ~= bi.donation then
			return ai.donation > bi.donation
		end
		if ai.power ~= bi.power then
			return ai.power > bi.power
		end
		if ai.level ~= bi.level then
			return ai.level > bi.level
		end
		return ai.logoutTm < bi.logoutTm
		-- --在线
		-- if ai.logoutTmEx == bi.logoutTmEx then
		-- 	--职位
		--     if ai.title == bi.title then
		--     	--贡献
		--       	if ai.donation == bi.donation then
		--       		--战力
		--       		if ai.power == bi.power then
		--       			--等级
		-- 	      		if ai.level == bi.level then
		-- 		      		r = ai.logoutTm > bi.logoutTm
		-- 	      		else
		-- 	      			r = ai.level > bi.level
		-- 	      		end
		--       		else
		--       			r = ai.power > bi.power
		--       		end
		--       	else
		--       		r = ai.donation > bi.donation
		--       	end
		--     else
		--      	r = ai.title < bi.title
		--     end 
		-- else
		--     r = ai.logoutTmEx < bi.logoutTmEx
		-- end
		-- return r
	end   

	table.sort(temp,sort_)
end
function LegionMgrView:get_sort_donation(temp)
	local function sort_(ai, bi)
		return ai.donation > bi.donation
	end   

	table.sort(temp,sort_)
end
function LegionMgrView:get_sort_online(temp)
	local function sort_(ai, bi)
		return ai.logoutTm < bi.logoutTm
	end   

	table.sort(temp,sort_)
end
function LegionMgrView:get_sort_power(temp)
	local function sort_(ai, bi)
		return ai.power > bi.power
	end   

	table.sort(temp,sort_)
end

function LegionMgrView:rank_view_init()
	self.refer:Get(12).transform.localRotation = Vector3(0,0,180)
	self.refer:Get(13).transform.localRotation = Vector3(0,0,180)
	self.refer:Get(14).transform.localRotation = Vector3(0,0,180)
end

function LegionMgrView:sort_member(type)
	self.refer:Get(12).transform.localRotation = Vector3(0,0,type == 2 and 0 or 180 )
	self.refer:Get(13).transform.localRotation = Vector3(0,0,type == 3 and 0 or 180 )
	self.refer:Get(14).transform.localRotation = Vector3(0,0,type == 4 and 0 or 180 )

	self:refresh(self.item_obj:get_member_list(),type)

end

-- 初始化下拉列表
function LegionMgrView:init_dropdown(dropdown,data)

	dropdown.options:Clear()

	local temp = self:get_drowdownl_list()
	gf_print_table(temp, "wtf temp temp:")
	for i,v in ipairs(temp or {}) do
		local option = UnityEngine.UI.Dropdown.OptionData()
		
		if v > 0 then
			if v == data.title then
				option.text = gf_getItemObject("legion"):get_title_name(v)
			else
				option.text = v > 0 and (v == ServerEnum.ALLIANCE_TITLE.LEADER and commom_string[10] or commom_string[8])..gf_getItemObject("legion"):get_title_name(v)
			end
		else
			option.text = commom_string[7]
		end

		dropdown.options:Add(option)
	end

	dropdown.value = self:get_drowdownl_list_index(data.title) - 1
	dropdown.captionText.text = gf_getItemObject("legion"):get_title_name(data.title)

end

function LegionMgrView:get_drowdownl_list()
	if self.temp_title_data then
		return self.temp_title_data
	end

	local temp = {}
	for i,v in pairs(ServerEnum.ALLIANCE_TITLE) do
		if v > gf_getItemObject("legion"):get_title() or v == ServerEnum.ALLIANCE_TITLE.LEADER then
			table.insert(temp,v)
		end
		-- table.insert(temp,v)
	end
	table.sort(temp,function(a,b)return a < b end)
	table.insert(temp,-1)
	self.temp_title_data = temp
	return temp

end

function LegionMgrView:get_drowdownl_list_index(title)
	for i,v in ipairs(self.temp_title_data) do
		if v == title then
			return i
		end
	end
	return 1
end

function LegionMgrView:update_item( item, index, data )

	-- item:Get(1)
	gf_print_table(data, "wtf data:"..index)
	-- 名字
	item:Get(2).text = data.name
	-- 等级
	item:Get(3).text = data.level
	-- 职位
	-- item:Get(4).text = ClientEnum.LEGION_TITLE_NAME[data.title]
	-- 贡献
	item:Get(5).text = data.donation
	item:Get(6).text = data.power

	if data.vipLevel > 0 then
		item:Get(9):SetActive(true)
		item:Get(10).text = data.vipLevel
	else
		item:Get(9):SetActive(false)
	end

	--离线时间
	local time = Net:get_server_time_s() - data.logoutTm

	item:Get(7).text = data.logoutTm == 0 and commom_string[3] or string.format(commom_string[6],gf_convert_time_dhm_ch(time,true))

	item.transform:FindChild("hl_img").gameObject:SetActive(false)

	if data.title > gf_getItemObject("legion"):get_title() then
		item:Get(11).gameObject:SetActive(true)
		self:init_dropdown(item:Get(4),data)
		item:Get(12).text = ""
	else
		item:Get(11).gameObject:SetActive(false)
		item:Get(12).text = gf_getItemObject("legion"):get_title_name(data.title)
	end
		
	item:Get(1):SetActive(self.choose_index == index) -- 高亮图片
end

function LegionMgrView:item_select(arg)

	if not arg or Seven.PublicFun.IsNull(arg) then
		return
	end
	self.arg = arg
	local index = arg.value
	index = index + 1
	
	local member_data = arg.gameObject.transform.parent:GetComponent("Hugula.UGUIExtend.ScrollRectItem").data

	--如果是-1	
	local title = self.temp_title_data[index]
	if title == -1 then
		local item = arg.gameObject.transform.parent:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
		local data = item.data
		self:update_item(item,item.index,data)

		self.member_data = item.data
		self.choose_index = item.index

		self:shot_off()

		return
	end
	self:change_title(member_data.roleId,member_data.name,member_data.title,index,arg)

end
function LegionMgrView:change_title( role_id,name,title1,index ,arg)
	print("data:",role_id,name,title1,index)

	local title2 = self.temp_title_data[index]

	local item = arg.gameObject.transform.parent:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
	local data = item.data

	self.pre_item = item 
	self.pre_data = data

	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		self:update_item(item,item.index,data)
		return
	end

	local str1 = string.format(
			gf_localize_string("确定将<color=%s>%s</color>的职位从<color=%s>%s</color>改为<color=%s>%s</color>"),
			gf_get_color(ServerEnum.COLOR.PURPLE),
			name,
			gf_get_color(ServerEnum.COLOR.PURPLE),
			gf_getItemObject("legion"):get_title_name(title1), 
			gf_get_color(ServerEnum.COLOR.PURPLE),
			gf_getItemObject("legion"):get_title_name(title2)
		)
	local str2 = string.format(
			gf_localize_string("确定将<color=%s>%s</color>的职位转让给<color=%s>%s</color>?"),
			gf_get_color(ServerEnum.COLOR.PURPLE),
			gf_getItemObject("legion"):get_title_name(title2),
			gf_get_color(ServerEnum.COLOR.PURPLE),
			name
		)

	local str = title2 == ServerEnum.ALLIANCE_TITLE.LEADER and str2 or str1
	LuaItemManager:get_item_obejct("cCMP"):add_message(
		str,
		function()
			self.set_roleId = role_id
			self.set_title = title2
			self.item_obj:set_title_c2s(role_id, title2)
		end,
		nil,
		function()
			print("取消")
			--重新刷新
			self:update_item(item,item.index,data)
		end
		,nil,nil,nil,nil,nil,nil,nil,
		function()
			print("x取消")
			self:update_item(item,item.index,data)
		end
	)
end

function LegionMgrView:shot_off(  )
	if not next(self.member_data or {}) then
		gf_message_tips(commom_string[1])
		return
	end
	local data = self.member_data
	local index = self.choose_index
	LuaItemManager:get_item_obejct("cCMP"):add_message(
		string.format(
			gf_localize_string("是否要玩家<color=%s>%s</color>踢出军团？"),
			"#B01FE5",
			data.name
		),
		function()
			self.item_obj:kick_out_c2s(data.roleId,data.name)
			
		end,
		nil,
		function()
			
		end
	)
end

function LegionMgrView:set_member_data(msg)
	gf_print_table(msg, "wtf msg :"..self.set_title)
	if msg.err ~= 0 then
		if self.pre_item then
			self:update_item(self.pre_item,self.pre_item.index,self.pre_data)
			self.pre_item = nil
			self.pre_data = nil
		end
		return
	end
	
	gf_getItemObject("legion"):set_member_title(self.set_roleId,self.set_title)

	self:update_member_data()

	if self.arg then
		local item = self.arg.gameObject.transform.parent:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
		local data = item.data
		self:update_item(item,item.index,data)
	end
end

function LegionMgrView:update_member_data()
	for i,v in ipairs(self.temp or {}) do
		if v.roleId == self.set_roleId then
			v.title = self.set_title
		end
	end
end

function LegionMgrView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetMemberListR") then
			if self.rec_my_info then
				self:init_ui()
			end
			self.rec_member_info = true
		elseif id2 == Net:get_id2("alliance", "GetMyInfoR") then
			if self.rec_member_info then
				self:init_ui()
			end
			self.rec_my_info = true
		elseif id2 == Net:get_id2("alliance", "SetTitleR") then
			self.choose_index = nil
			self.member_data = nil
			-- self:set_member_data(msg)
			self:on_asset_load()

		elseif id2 == Net:get_id2("alliance", "KickOutR") then
			if msg.err == 0 then
				-- self.scroll_table:RemoveDataAt(self.choose_index)
				-- self.scroll_table:Refresh(self.scroll_table.currFirstIndex,-1)
				self.choose_index = nil
				self.member_data = nil
				self.item_obj:get_member_list_c2s()
			end

		elseif id2 == Net:get_id2("alliance", "ModifyInfoR") then
			self.item_obj:get_member_list_c2s()

		elseif id2 == Net:get_id2("alliance", "ApplyReplyR") then
			

		end
	end
	if id1 == ClientProto.ShowHotPoint then
		self:show_red_point(msg.btn_id,msg.visible)
	end

end

function LegionMgrView:exit_click()
	local sure_fun = function()
		require("models.legion.legionConfirmDispose")()
	end
	local content = string.format(commom_string[5])
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)
end

function LegionMgrView:on_click( obj, arg )
	
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("LegionMgrView cmd:",cmd)
	if cmd == "adjustment_btn" then -- 调整职位
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

	elseif cmd == "shot_off_btn" then -- 踢出军团
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self:shot_off()
		if  LuaItemManager:get_item_obejct("setting"):is_lock() then
			return
		end
		LuaItemManager:get_item_obejct("cCMP"):add_message(
			commom_string[4]
		,
		function()
			gf_getItemObject("legion"):quit_c2s()
			
		end,
		nil,
		function()
			
		end
		)

	elseif string.find(cmd , "member_item") then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换3级页签音效
		self:item_click(arg)

	elseif string.find(cmd,"Item ") then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
		self:item_select(arg)

	elseif cmd == "legion_apply_list_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local callback = function()
			self.item_obj:get_member_list_c2s()
		end
		require("models.legion.legionApplyView")(callback)

	elseif cmd == "job_transfer_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		require("models.legion.legionPositionMgr")()

	elseif cmd == "legion_dissolution_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if not LuaItemManager:get_item_obejct("setting"):is_lock() then
			self.exit_click()
		end
	elseif cmd == "btnContribution" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sort_member(2)

	elseif cmd == "btnCombat" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sort_member(3)

	elseif cmd == "btnState" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sort_member(4)

	elseif cmd == "tick_off_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:shot_off()		

	elseif cmd == "legion_impeachment" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:impeach_click()

	end
end

--弹劾
function LegionMgrView:impeach_click()
	local sure_fun = function()
		gf_getItemObject("legion"):send_to_impeach()
	end
	gf_getItemObject("cCMP"):ok_cancle_message(commom_string[9],sure_fun,cancle_fun)

end

function LegionMgrView:item_click(arg)
	local item = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
	self.item = item
	if not item then
		return
	end
	local index = item.index 

	local member_data = item.data

	--自己不能点击
	if member_data.roleId == gf_getItemObject("game"):getId() then
		return
	end

	if self.last_bg then
		self.last_bg.gameObject:SetActive(false)
	end
	self.last_bg = arg.transform:FindChild("hl_img")
	self.last_bg.gameObject:SetActive(true)

	self:set_choose_member(index,member_data)

end

function LegionMgrView:set_choose_member(index,member_data)
	self.choose_index = index + 1
	self.member_data = member_data
	self.refer:Get(1).value = member_data.title - 1

	LuaItemManager:get_item_obejct("player"):show_player_tips(member_data.roleId)
	
end
  
function LegionMgrView:show_red_point(btn_id,visible)
	if 	btn_id == ClientEnum.MAIN_UI_BTN.FAMILY or btn_id == ClientEnum.MAIN_UI_BTN.SWITCH then
		local can_add = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.ACCEPT_APPLY)
		if can_add then
			self.refer:Get(8):SetActive(visible)
		end
	end

end


function LegionMgrView:clear()
	self.data = nil
	self.last_bg = nil
	self.choose_index = nil
	StateManager:remove_register_view( self )
	self.item = nil
end

function LegionMgrView:on_showed()
	StateManager:register_view( self )
end
 
function LegionMgrView:on_hided()
	self:clear()
end

-- 释放资源
function LegionMgrView:dispose()
	self:clear()
    self._base.dispose(self)
 end

return LegionMgrView

