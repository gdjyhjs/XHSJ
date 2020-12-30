--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 09:57:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Dropdown = UnityEngine.UI.Dropdown
local kouliang_shop_id = 20010001
local WarehouseView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "legion_depot.u3d") -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function WarehouseView:on_asset_load(key,asset)
end

function WarehouseView:init_ui()
	self.is_show_self_career = true
	self.show_quality = -1
	self.show_lv = -1
	self.origin_list = {}
	self.show_list = {}
	self.donate_list = {}
	self.record_list = {}
	self.guid_value = {}
	self.left_scroll = self.refer:Get(1)
	self.right_scroll = self.refer:Get(2)
	self.select_equip = self.refer:Get(5)
	self.select_quality = self.refer:Get(6)
	self.sel = self.refer:Get(9)
	self.sel:SetActive(true)

	self.txt_score = self.refer:Get(8)

	self.select_equip_text = self.refer:Get(4)
	self.select_quality_text = self.refer:Get(7)
	self.select_equip_text.text = gf_localize_string("筛选等级")
	self.select_quality_text.text = gf_localize_string("筛选品质")
	self.left_scroll.data = self.record_list
	self.right_scroll.data = {}

	--self.bag_equip_list = LuaItemManager:get_item_obejct("warehouse"):get_equips_list()

	self.select_index = 0

	local function donate_update(scroll_rect_item,index,data_item)
		local text = scroll_rect_item:Get(1)
		text.text = data_item
	end    

	local my_career = LuaItemManager:get_item_obejct("game"):get_career()
	local item_data = ConfigMgr:get_config("item")
	local function equip_update(scroll_rect_item,index,data_item)
		if data_item.is_empty ~= true then
			local item_back = scroll_rect_item:Get(1)
			local color_img = item_back:GetComponent(UnityEngine_UI_Image)
			local item_icon_img = scroll_rect_item:Get(2)
			item_icon_img.gameObject:SetActive(true)
			if index ~= 1 then
				gf_set_equip_icon( data_item, item_icon_img, color_img)
			else
				local code = ConfigMgr:get_config("goods")[data_item.goods_id].item_code
				gf_set_item( code, item_icon_img, color_img)
			end
			item_back.name = string.format("item%d",index)
			--item_back.guid = data_item.guid
			local select = scroll_rect_item:Get(3)
			if self.select_index == index then
				select:SetActive(true)
			else
				select:SetActive(false)
			end
			local binding = scroll_rect_item:Get(4)
			binding:SetActive(false)
			local count = scroll_rect_item:Get(5)
			count.gameObject:SetActive(false)
			local up = scroll_rect_item:Get(6)
			local down = scroll_rect_item:Get(7)
			local no_use = scroll_rect_item:Get(8)
			if index ~= 1 then
				if item_data[data_item.protoId].career == my_career then
					no_use:SetActive(false)
					--[[local value,is_level,is_career = LuaItemManager:get_item_obejct("equip"):compare_body_equip(data_item)
					if value == 1 then
						up:SetActive(true)
						down:SetActive(false)
					elseif value == -1 then
						up:SetActive(false)
						down:SetActive(true)
					else
						up:SetActive(false)
						down:SetActive(false)
					end]]
					local guid = data_item.guid
					--[[if self.guid_value[guid] == nil then
						local value,is_level,is_career = LuaItemManager:get_item_obejct("equip"):compare_body_equip(data_item)
						self.guid_value[guid] = value
					end]]
					if self.guid_value[guid] == 1 then
						up:SetActive(true)
						down:SetActive(false)
					elseif self.guid_value[guid] == -1 then
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
			else
				up:SetActive(false)
				down:SetActive(false)
				no_use:SetActive(false)
			end
		else
			local item_back = scroll_rect_item:Get(1)
			gf_setImageTexture(item_back,"item_color_0")
			local color_img = item_back:GetComponent(UnityEngine_UI_Image)
			local item_icon_img = scroll_rect_item:Get(2)
			item_icon_img.gameObject:SetActive(false)
			local select = scroll_rect_item:Get(3)
			select:SetActive(false)
			local binding = scroll_rect_item:Get(4)
			binding:SetActive(false)
			local count = scroll_rect_item:Get(5)
			count.gameObject:SetActive(false)
			local up = scroll_rect_item:Get(6)
			local down = scroll_rect_item:Get(7)
			local no_use = scroll_rect_item:Get(8)
			up:SetActive(false)
			down:SetActive(false)
			no_use:SetActive(false)
			item_back.name = ""
			if #self.show_list < index then
				scroll_rect_item.gameObject:SetActive(false)
			else
				scroll_rect_item.gameObject:SetActive(true)
			end
		end
	end

	self.left_scroll.onItemRender = donate_update
	self.right_scroll.onItemRender = equip_update

	--self.lv_list = {10,20,30,40,50,60}
	--self.quality_list = {3,4,5,6}
	self.lv_list = {}
	self.quality_list = {}
	for i,v in ipairs(ConfigMgr:get_config("equip_lv")[1].level_filter) do
		table.insert(self.lv_list,v)
	end

	for i,v in ipairs(ConfigMgr:get_config("equip_lv")[1].color_filter) do
		table.insert(self.quality_list,v)
	end
	local quality_desc = {gf_localize_string("紫"),gf_localize_string("金"),gf_localize_string("橙"),gf_localize_string("红")}
	local options = self.select_equip.options
	options:Clear()
	for i,v in ipairs(self.lv_list) do
		local str = string.format(gf_localize_string("%d级装备"),v)
		options:Add(Dropdown.OptionData(str))
	end

	options = self.select_quality.options
	options:Clear()
	for i,v in ipairs(quality_desc) do
		options:Add(Dropdown.OptionData(v))
	end

	local title = LuaItemManager:get_item_obejct("legion"):get_title()
	if LuaItemManager:get_item_obejct("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.DESTORY_EQUIP ,title) == false then
		self.refer:Get(10):SetActive(false)
	else
		self.refer:Get(10):SetActive(true)
	end
	--self.left_scroll:Refresh(0,#self.record_list - 1)
	--local test_data = {}
	--test_data.items = {}
	--[[for i,v in pairs(self.bag_equip_list) do
		table.insert(test_data.items,gf_deep_copy(v))
	end]]
	--[[for i = 1,9 do
		local item = LuaItemManager:get_item_obejct("bag"):get_bag_item()[ServerEnum.BAG_TYPE.EQUIP*10000+i]
		if item ~= nil then
			gf_print_table(item)
			table.insert(test_data.items,gf_deep_copy(item))
		end
	end
	gf_send_and_receive(test_data, "alliance", "GetStoreItemListR")]]

	self.record_list = LuaItemManager:get_item_obejct("warehouse"):get_record_list()
	self.origin_list = LuaItemManager:get_item_obejct("warehouse"):get_item_list()
	if LuaItemManager:get_item_obejct("warehouse"):is_had_requested() == false then
		LuaItemManager:get_item_obejct("warehouse"):request_item_list() 
	else
		self.left_scroll.data = self.record_list
		self.left_scroll:Refresh(0,#self.left_scroll.data)
		self:show_select()
	end
end

function WarehouseView:on_click( item_obj, obj, arg )
	local event_name = obj.name
	if string.find(event_name,"item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"item","")
		index = tonumber(index)
		if self.select_index ~= 0 and self.select_index ~= index then
			self.right_scroll:Refresh(self.select_index - 1,self.select_index - 1)
		end
		self.select_index = index
		self.right_scroll:Refresh(self.select_index - 1,self.select_index - 1)
		if index ~= 1 then
			local guid = self.right_scroll.data[index].guid
			local function click_exchange()
				if self.origin_list[guid] ~= nil then
					local need_score = LuaItemManager:get_item_obejct("warehouse"):get_score(self.origin_list[guid])
					if need_score <= LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.ALLIANCE_STORE_POINT) then
						Net:send({guid = guid},"alliance","ExchangeStoreItem")
					else
						LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("您的积分不足，无法兑换该装备"))
					end
				else
					LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("该装备已经被兑换或销毁"))
				end
			end

			local function click_destroy()
				if self.origin_list[guid] ~= nil then
					Net:send({guidList = {guid,}},"alliance","DestoryStoreItem")
				else
					LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("该装备已经被兑换或销毁"))
				end
			end
			LuaItemManager:get_item_obejct("itemSys"):add_tips_btn(gf_localize_string("兑换"),click_exchange)
			local title = LuaItemManager:get_item_obejct("legion"):get_title()
			if LuaItemManager:get_item_obejct("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.DESTORY_EQUIP ,title) == true then
				LuaItemManager:get_item_obejct("itemSys"):add_tips_btn(gf_localize_string("销毁"),click_destroy)
			end
			LuaItemManager:get_item_obejct("itemSys"):add_tips_content(ClientEnum.ITEM_TIPS_CONTENT.DEPOT_SCORE)
			LuaItemManager:get_item_obejct("itemSys"):equip_browse(self.show_list[index])
		else
			require("models.warehouse.warehouseExchange")()
		end	
	elseif event_name == "btnDestroyEquip" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		LuaItemManager:get_item_obejct("warehouse").data = self.origin_list
		require("models.warehouse.warehouseDestroy")()
	elseif event_name == "btnDonateEquip" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		--self.bag_equip_list = LuaItemManager:get_item_obejct("warehouse"):get_equips_list()
		require("models.warehouse.warehouseDonate")()
	elseif event_name == "tog" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		if self.is_show_self_career == true then
			self.is_show_self_career = false
			self.sel:SetActive(false)
		else
			self.is_show_self_career = true
			self.sel:SetActive(true)
		end
		self:show_select()
	elseif event_name == "closeSocialBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
	elseif not Seven.PublicFun.IsNull(arg) then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local name = arg.name
		if name == "selectEquip" then
			local index = arg.value + 1
			self.show_lv = self.lv_list[index]
			self:show_select()
		elseif name == "selectQuality" then
			local index = arg.value + 1
			self.show_quality = self.quality_list[index]
			self:show_select()
		end
	end
end
		
function WarehouseView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function WarehouseView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function WarehouseView:on_showed()
	self:register()
	self:init_ui()
end

function WarehouseView:on_hided( )
	self:cancel_register()
	--self:dispose()
end

function WarehouseView:show_select()
	self.select_index = 0
	self.show_list = {{goods_id = kouliang_shop_id}}
	local data = ConfigMgr:get_config("item")
	local my_career = LuaItemManager:get_item_obejct("game"):get_career()
	self.origin_list = LuaItemManager:get_item_obejct("warehouse"):get_item_list()
	local sub_pos_count = 0
	for i,v in pairs(self.origin_list or {}) do
		if (self.show_lv == -1 or self.show_lv == data[v.protoId].level) 
			and (self.show_quality == -1 or self.show_quality == v.color) 
			and (self.is_show_self_career == false or data[v.protoId].career == 0 or data[v.protoId].career == my_career) then
			table.insert(self.show_list,v)
		else
			sub_pos_count = sub_pos_count + 1
		end 
	end
	local function sort(a,b)
		local a_is_goods = 0
		local b_is_goods = 0
		if a.goods_id ~= nil then
			a_is_goods = 1
		end
		if b.goods_id ~= nil then
			b_is_goods = 1
		end
		if a_is_goods ~= b_is_goods then
			return b_is_goods < a_is_goods
		end
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
	local index = #self.show_list + 1
	local lv = LuaItemManager:get_item_obejct("legion"):get_level()
	local store_size = ConfigMgr:get_config("alliance")[lv].store_size - sub_pos_count
	while index <= store_size do
		table.insert(self.show_list,{is_empty = true})
		index = index + 1
	end

	self.right_scroll.data = self.show_list
	self.right_scroll:ScrollTo(0)
	self.right_scroll:Refresh(0,#self.show_list - 1)
	self.begin_index = 1
	if self.schedule_id == nil then
		local update = function(dt)
			if #self.show_list < self.begin_index then
				self.schedule_id:stop()
				self.schedule_id = nil
			else
				local data = self.show_list[self.begin_index]
				if data.goods_id == nil and self.guid_value[data.guid] == nil and data.is_empty ~= true  then
					local value,is_level,is_career = LuaItemManager:get_item_obejct("equip"):compare_body_equip(data)
					self.guid_value[data.guid] = value
					self.right_scroll:Refresh(self.begin_index - 1,self.begin_index - 1)
				end
			end
			self.begin_index = self.begin_index + 1
		end
		self.schedule_id = Schedule(update, 1/30)
	end
	self.txt_score.text = tostring(LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.ALLIANCE_STORE_POINT))
end
function WarehouseView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetStoreItemListR") then
			--self.origin_list = gf_deep_copy(msg.items)
			print("GetStoreItemListR")
			--[[self.origin_list = {}
			for i,v in ipairs(msg.items) do
				self.origin_list[v.guid] = gf_deep_copy(v)
			end]]
			self:show_select()
		elseif id2 == Net:get_id2("alliance", "DestoryStoreItemR") then
			print("DestoryStoreItemR")
			--[[for i,v in ipairs(msg.guidList) do
				self.origin_list[v] = nil
			end
			self:show_select()]]
		elseif id2 == Net:get_id2("alliance", "AddItemToStoreR") then
			--[[for i,v in ipairs(msg.guidList) do
				if self.bag_equip_list[v] ~= nil then
					self.origin_list[v] = self.bag_equip_list[v]
					self.bag_equip_list[v] = nil
				end
			end]]
			--self:show_select()
		elseif id2 == Net:get_id2("alliance", "ExchangeStoreItemR") then
			--self.origin_list[msg.guid] = nil
			--self:show_select()
		elseif id2 == Net:get_id2("alliance", "GetStoreRecordR") then
			--[[self.record_list = {}
			for i,v in ipairs(msg.record) do
				local str = LuaItemManager:get_item_obejct("warehouse"):getRecord(v)
				table.insert(self.record_list,str)
			end]]
			self.record_list = LuaItemManager:get_item_obejct("warehouse"):get_record_list()
			self.left_scroll.data = self.record_list
			self.left_scroll:Refresh(0,#self.left_scroll.data)
		elseif id2 == Net:get_id2("alliance", "StoreRecordUpdateR") then
			print("StoreRecordUpdateR")
			--[[for i,v in ipairs(msg.record) do
				local str = LuaItemManager:get_item_obejct("warehouse"):getRecord(v)
				table.insert(self.record_list,1,str)
			end]]
			self.record_list = LuaItemManager:get_item_obejct("warehouse"):get_record_list()
			self.left_scroll.data = self.record_list
			self.left_scroll:Refresh(0,#self.record_list - 1)
			--[[for i,v in ipairs(msg.items or {}) do
				if self.origin_list[v.guid] == nil then
					local temp = gf_deep_copy(v)
					self.origin_list[v.guid] = temp
				end
			end

			for i,v in ipairs(msg.guidList or {}) do
				self.origin_list[v] = nil
			end]]
			self:show_select()
		end
	end
	if id1==Net:get_id1("base") then
        if id2 == Net:get_id2("base", "UpdateResR") then
        	self.txt_score.text = tostring(LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.ALLIANCE_STORE_POINT))
        end
    end
end

-- 释放资源
function WarehouseView:dispose()	
	self:cancel_register()
    self._base.dispose(self)
end

return WarehouseView

