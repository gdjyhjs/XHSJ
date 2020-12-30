--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Dropdown = UnityEngine.UI.Dropdown

local WarehouseDestroy=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("warehouse")
    UIBase._ctor(self, "legion_equip_destroy.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function WarehouseDestroy:on_asset_load(key,asset)
	
end

function WarehouseDestroy:init_ui()
	self.is_show_one_star = true
	self.show_quality = -1
	self.show_lv = -1
	local list = LuaItemManager:get_item_obejct("warehouse").data
	self.hash_list = {}
	self.show_list = {}
	for k,v in pairs(list) do
		local temp = gf_deep_copy(v)
		if v.exAttr ~= nil and #v.exAttr == 1 then
			table.insert(self.show_list,temp)
		end
		self.hash_list[v.guid] = temp
	end

	self.scroll = self.refer:Get(1)
	self.scroll.data = self.show_list
	local my_career = LuaItemManager:get_item_obejct("game"):get_career()
	local item_data = ConfigMgr:get_config("item")
	local function equip_update(scroll_rect_item,index,data_item)
		local item_back = scroll_rect_item:Get(1)
		local color_img = item_back:GetComponent(UnityEngine_UI_Image)
		local item_icon_img = scroll_rect_item:Get(2)
		gf_set_equip_icon( data_item, item_icon_img, color_img)
		item_back.name = string.format("b_destroy%d",index)
		local select = scroll_rect_item:Get(3)
		if data_item.is_select == true then
			select:SetActive(true)
		else
			select:SetActive(false)
		end
		local bind = scroll_rect_item:Get(4)
		bind:SetActive(false)
		local count = scroll_rect_item:Get(5)
		count.gameObject:SetActive(false)
		local up = scroll_rect_item:Get(6)
		--up:SetActive(false)
		local down = scroll_rect_item:Get(7)
		--down:SetActive(false)
		local no_use = scroll_rect_item:Get(8)
		--no_use:SetActive(false)
		if item_data[data_item.protoId].career == my_career then
			no_use:SetActive(false)
			local value,is_level,is_career = LuaItemManager:get_item_obejct("equip"):compare_body_equip(data_item)
			if value == 1 then
				up:SetActive(true)
				down:SetActive(false)
			elseif value == -1 then
				up:SetActive(false)
				down:SetActive(true)
			else
				up:SetActive(false)
				down:SetActive(false)
			end
		else
			up:SetActive(false)
			down:SetActive(false)
		end
	end
	self.scroll.onItemRender = equip_update


	self.select_destroy_equip = self.refer:Get(3)
	self.select_destroy_quality = self.refer:Get(4)

	self.select_destroy_equip_text = self.refer:Get(2)
	self.select_destroy_quality_text = self.refer:Get(5)
	self.select_destroy_equip_text.text = gf_localize_string("筛选等级")
	self.select_destroy_quality_text.text = gf_localize_string("筛选品质")

	self.lv_list = {10,20,30,40,50,60}
	self.quality_list = {3,4,5,6}
	local quality_desc = {gf_localize_string("紫"),gf_localize_string("金"),gf_localize_string("橙"),gf_localize_string("红")}
	local options = self.select_destroy_equip.options
	options:Clear()
	for i,v in ipairs(self.lv_list) do
		local str = string.format(gf_localize_string("%d级装备"),v)
		options:Add(Dropdown.OptionData(str))
	end

	options = self.select_destroy_quality.options
	options:Clear()
	for i,v in ipairs(quality_desc) do
		options:Add(Dropdown.OptionData(v))
	end

	self.sel = self.refer:Get(6)
end

function WarehouseDestroy:show_select()
	self.show_list = {}
	local data = ConfigMgr:get_config("item")
	for i,v in pairs(self.hash_list or {}) do
		if (self.show_lv == -1 or self.show_lv == data[v.protoId].level) 
			and (self.show_quality == -1 or self.show_quality == v.color) 
			and (self.is_show_one_star == false or (v.exAttr ~= nil and #v.exAttr == 1)) then
			table.insert(self.show_list,gf_deep_copy(v))
		end 
	end
	local function sort(a,b)
		local a_lv = data[a.protoId].level
		local b_lv = data[b.protoId].level
		if a_lv ~= b_lv then
			return b_lv < a_lv
		end
		if a.color ~= b.color then
			return b.color < a.color
		end
		local a_star = 0
		local b_star = 0
		if a.exAttr ~= nil then
			a_star = #a.exAttr
		end
		if b.exAttr ~= nil then
			b_star = #b.exAttr
		end
		if a_star ~= b_star then
			return b_star < a_star
		end
		return data[a.protoId].sub_type < data[b.protoId].sub_type
	end
	table.sort(self.show_list,sort)
	self.scroll.data = self.show_list
	self.scroll:Refresh(0,#self.show_list - 1)
end

function WarehouseDestroy:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "StoreRecordUpdateR") then
			for i,v in ipairs(msg.guidList) do
				self.hash_list[v] = nil
			end
			self:show_select()
		end
	end
end

function WarehouseDestroy:on_click( obj, arg )
	local event_name = obj.name
	if string.find(event_name,"b_destroy") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"b_destroy","")
		index = tonumber(index)
		if self.scroll.data[index].is_select == true then
			self.scroll.data[index].is_select = false
		else
			self.scroll.data[index].is_select = true
		end
		self.scroll:Refresh(index - 1,index - 1)
	elseif event_name == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
	elseif event_name == "btnDestroyEquip2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local destroy_list = {}
		for i,v in ipairs(self.scroll.data) do
			if v.is_select == true then
				table.insert(destroy_list,v.guid)
			end
		end
		if 0 < #destroy_list then
			Net:send({guidList = destroy_list},"alliance","DestoryStoreItem")
		else
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("请选择要销毁的装备"))
		end
	elseif event_name == "togStar" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		if self.is_show_one_star == true then
			self.is_show_one_star = false
			self.sel:SetActive(false)
		else
			self.is_show_one_star = true
			self.sel:SetActive(true)
		end
		self:show_select()
	elseif not Seven.PublicFun.IsNull(arg) then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local name = arg.name
		if name == "selectDestroyEquip" then
			local index = arg.value + 1
			self.show_lv = self.lv_list[index]
			self:show_select()
		elseif name == "selectDestroyQuality" then
			local index = arg.value + 1
			self.show_quality = self.quality_list[index]
			self:show_select()
		end
	end
end

function WarehouseDestroy:register()
	StateManager:register_view( self )
end

function WarehouseDestroy:cancel_register()
	StateManager:remove_register_view( self )
end

function WarehouseDestroy:on_showed()
	self:register()
	self:init_ui()
end

function WarehouseDestroy:on_hided()
end

-- 释放资源
function WarehouseDestroy:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return WarehouseDestroy

