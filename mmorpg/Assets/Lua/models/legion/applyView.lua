--[[--
-- 第一个申请界面
-- @Author:Seven
-- @DateTime:2017-06-20 12:30:45
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local save_key = "%d_legion_check"

require("models.legion.publicFunc")

local commom_string = 
{
	[1] = gf_localize_string("你已经在军团中"),
	[2] = gf_localize_string("申请成功"),
	[3] = gf_localize_string("暂时还没有任何军团，赶快来成为第一个军团的统帅吧！"),
	[4] = gf_localize_string("没有找到军团哦"),
}


local dataUse = require("models.legion.dataUse")

local ApplyView=class(UIBase,function(self)
	self:set_bg_visible(true)
	local item_obj = gf_getItemObject("legion")
    UIBase._ctor(self, "legion_apply_list.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ApplyView:on_asset_load(key,asset)
	self.page = 1
	self:init_ui()

	local my_role_id = gf_getItemObject("game"):getId()

	self.is_check = PlayerPrefs.GetInt(string.format(save_key,my_role_id),1) or 1

	self.refer:Get(6):SetActive(self.is_check == 1)
	print("self.is_check :",self.is_check)

	self.item_obj:my_apply_c2s()
	self.item_obj:alliance_list_c2s(self.page,self.is_check)
end

function ApplyView:init_ui()
	self.scroll_table = self.root:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)
	self.scroll_table.onBottom = handler(self, self.on_bottom)
	self:update_ui()
	self:refresh({},true)
end

function ApplyView:update_ui( data )
	self.refer:Get(5).text = data and data.leader or ""
	-- self.refer:Get(4).text = data and data.introduction or ""

	if data and data.introduction ~= "" then
		gf_update_introduction(data.introduction,self.refer:Get(7),self.refer:Get(8))
	else
		self.refer:Get(7).text = ""
	end

	self.refer:Get(3).text = data and data.name or ""
	self.refer:Get(2).text = data and data.announcement or "" 
end

function ApplyView:set_select_item( item,is_click )
	self.choose_index = item:GetComponent("Hugula.UGUIExtend.ScrollRectItem").index + 1
	self:update_ui(item.data)
	if self.select_item then
		self.select_item:Get(7):SetActive(false) -- 高亮图片
	end
	item:Get(7):SetActive(true) -- 高亮图片
	self.select_item = item
end

function ApplyView:refresh( data, first,force )
	gf_print_table(data, "wtf data refresh:")

	self.refer:Get(9):SetActive(false)
	if not first and not next(data) then
		self.refer:Get(9):SetActive(true)
		self.refer:Get(10).text = force and commom_string[3] or commom_string[4]
	end

	self.choose_index = 1
	self.first_choose = true
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function ApplyView:update_item( item, index, data )
	item.name = "preItem_"..index
	-- 名字
	item:Get(1).text = data.name
	-- 等级
	item:Get(2).text = data.level
	-- 人数
	item:Get(3).text = data.memberSize.."/"..dataUse.getAllianceData(data.level).max_member_size
	-- 战力
	item:Get(4).text = data.totalPower or 0
	-- 统帅 
	item:Get(8).text = data.leader 

	--是否被选中
	print("self.choose_index == index:",self.choose_index == index,self.choose_index , index)
	if self.choose_index == index then
		item:Get(7):SetActive(true) -- 高亮图片
		self.select_item = item

		if self.first_choose then
			self:set_select_item(item)
			self.first_choose = false
		end
	else
		item:Get(7):SetActive(false) -- 高亮图片
	end
	

	local apply = self.item_obj:get_had_apply(data.id)
	self:set_item_status(item, apply)
end

-- 滚动到底端
function ApplyView:on_bottom( item, index, data )
	self.begin_idx = index-1
	local page = math.floor(index/6) + 1
	if page > 1 and self.page < page then
		self.page = page
		self.item_obj:alliance_list_c2s(page,self.is_check)
	end
end

-- 刷新状态
function ApplyView:refresh_item_status( item )
	local data = item.data
	local apply = self.item_obj:get_had_apply(data.id)
	self:set_item_status(item, apply)
end

function ApplyView:set_item_status( item, status )
	item:Get(6):SetActive(not status)
	item:Get(5):SetActive(status)
end

-- function ApplyView:set_input_field_img(flag)
-- 	self.items.search_img:SetActive(flag)
-- 	self.items.del_btn:SetActive(not flag)
-- 	if flag then
-- 		self:refresh(self.item_obj:get_legion_list())
-- 	end
-- end

function ApplyView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "AllianceListR") then
			if #msg.list > 0 then -- 有数据才去刷新
				if sid == 1 then -- 第一页
					self:refresh(copy(self.item_obj:get_legion_list()),false,true)
				else
					for i,v in ipairs(msg.list) do
						local index = self.scroll_table:InsertData(v, -1)
						self.scroll_table:Refresh(index-1, -1)
					end
				end
			end
		
		elseif id2 == Net:get_id2("alliance", "ApplyJoinR") then
			if msg.err == 0 then
				if self.item_obj.apply_legion_id > 0 then -- 单个申请
					self:refresh_item_status(self.select_item)
				end
			end
			

		elseif id2 == Net:get_id2("alliance", "SearchAllianceR") then
			self:refresh(msg.list)

		elseif id2 == Net:get_id2("alliance", "MyApplyR") then
			self.scroll_table:Refresh(self.scroll_table.currFirstIndex, -1)


		elseif id2 == Net:get_id2("alliance", "BuildR") then
			if msg.err == 0 then
				self:dispose()
				gf_getItemObject("legion"):open_view()
			end

		elseif id2 == Net:get_id2("alliance", "GetMyInfoR") then
			self:dispose()
			gf_getItemObject("legion"):open_view()	

		end
	end
end
function ApplyView:create_click()
	if gf_getItemObject("legion"):is_in() then
		gf_message_tips(commom_string[1])
		return
	end
	require("models.legion.legionCreate")()
end
function ApplyView:check_availble_click(arg)
	arg:SetActive(not arg.activeSelf)
	self.is_availble = arg.activeSelf
		
	self.is_check = self.is_availble and 1 or 0

	local my_role_id = gf_getItemObject("game"):getId()

	PlayerPrefs.SetInt(string.format(save_key,my_role_id),self.is_check) 


	self.page = 1
	self:refresh({},true)
	self.item_obj:alliance_list_c2s(self.page,self.is_check)
end
function ApplyView:chat_click()
	if self.select_item then
		print("self.select_item.data.id:",self.select_item.data.id)
		gf_open_model(ClientEnum.MODULE_TYPE.PRIVATE_CHAT,self.select_item.data.leaderId)
	end
	
end

function ApplyView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("cmd:",cmd)
	if cmd == "legion_apply_close" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif cmd == "create_legion_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:create_click()

	elseif cmd == "one_key_apply_btn" then -- 一健申请
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:apply_join_c2s(0)

	elseif cmd == "application_btn" then -- 申请
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- self:set_select_item(arg)
		if self.select_item then
			self.item_obj:apply_join_c2s(self.select_item.data.id)
		end
		

	elseif string.find(cmd , "preItem_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:set_select_item(arg)

	elseif cmd == "check_availble" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:check_availble_click(arg)

    elseif cmd == "search_img" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:search_click()

	elseif cmd == "chat_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:chat_click()

	end

end

-- 输入结束
function ApplyView:search_click()
	print("wtf self.refer:Get(2).text:",self.refer:Get(2).text)
	self.item_obj:search_alliance_c2s(self.refer:Get(2).text)
end

function ApplyView:register()
	StateManager:register_view( self )
end

function ApplyView:cancel_register()
	StateManager:remove_register_view( self )
end

function ApplyView:on_showed()
	StateManager:register_view( self )
end

function ApplyView:clear()
	self.scroll_table.data = {}
end

function ApplyView:on_hided()
	self:clear()
	self:register()
end

-- 释放资源
function ApplyView:dispose()
	self:clear()
	self.select_item = nil
	self:cancel_register()
    self._base.dispose(self)
end

return ApplyView

