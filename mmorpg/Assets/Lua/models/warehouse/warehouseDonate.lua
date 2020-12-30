--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local WarehouseDonate=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("warehouse")
    UIBase._ctor(self, "legion_equip_donate.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function WarehouseDonate:on_asset_load(key,asset)
	
end

function WarehouseDonate:init_ui()
	print("cao sb")
	local list = LuaItemManager:get_item_obejct("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.EQUIP,nil,ServerEnum.BAG_TYPE.NORMAL)
	self.bag_list = {}
	self.hash_bag_list = {}
	local data = ConfigMgr:get_config("item")
	for k,v in pairs(list) do
		if v.item.exAttr ~= nil and 1 <= #v.item.exAttr and 150 <= data[v.item.protoId].level and require("enum.enum").COLOR.PURPLE <= v.item.color then
			local temp = gf_deep_copy(v.item)
			table.insert(self.bag_list,temp)
			self.hash_bag_list[v.item.guid] = temp
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
	table.sort(self.bag_list,sort)

	self.scroll = self.refer:Get(1)
	self.scroll.data = self.bag_list
	local my_career = LuaItemManager:get_item_obejct("game"):get_career()
	local item_data = ConfigMgr:get_config("item")
	local function equip_update(scroll_rect_item,index,data_item)
		local item_back = scroll_rect_item:Get(1)
		local color_img = item_back:GetComponent(UnityEngine_UI_Image)
		local item_icon_img = scroll_rect_item:Get(2)
		gf_set_equip_icon( data_item, item_icon_img, color_img)
		item_back.name = string.format("b_donate%d",index)
		local select = scroll_rect_item:Get(7)
		if data_item.is_select == true then
			select:SetActive(true)
		else
			select:SetActive(false)
		end
		local count = scroll_rect_item:Get(3)
		count.gameObject:SetActive(false)
		local up = scroll_rect_item:Get(4)
		--up:SetActive(false)
		local down = scroll_rect_item:Get(5)
		--down:SetActive(false)
		local no_use = scroll_rect_item:Get(6)
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
	self.score = 0

	self.text_score = self.refer:Get(2)
	self.text_score.text = tostring(self.score)

	self.image1 = self.refer:Get(5)
	self.image2 = self.refer:Get(6)

	if #self.bag_list ~= 0 then
		self.image1:SetActive(false)
		self.image2:SetActive(false)
	end
end

function WarehouseDonate:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "AddItemToStoreR") then
			--[[for i,v in ipairs(msg.guidList) do
				self.hash_bag_list[v] = nil
			end
			self.bag_list = {}
			for k,v in pairs(self.hash_bag_list) do
				table.insert(self.bag_list,gf_deep_copy(v))
			end
			self.scroll.data = self.bag_list
			self.scroll:Refresh(0,#self.scroll.data - 1)]]
			self:dispose()
		end
	end
end

function WarehouseDonate:on_click( obj, arg )
	local event_name = obj.name
	if string.find(event_name,"b_donate") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"b_donate","")
		index = tonumber(index)
		if self.scroll.data[index].is_select == true then
			self.scroll.data[index].is_select = false
		else
			self.scroll.data[index].is_select = true
		end
		self.scroll:Refresh(index - 1,index - 1)
		if self.scroll.data[index].is_select == true then
			self.score = self.score + LuaItemManager:get_item_obejct("warehouse"):get_score(self.scroll.data[index])
		else
			self.score = self.score - LuaItemManager:get_item_obejct("warehouse"):get_score(self.scroll.data[index])
		end
		self.text_score.text = tostring(self.score)
	elseif event_name == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
	elseif event_name == "btnDonateEquip2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local donate_list = {}
		for i,v in ipairs(self.scroll.data) do
			if v.is_select == true then
				table.insert(donate_list,v.guid)
			end
		end
		if 0 < #donate_list then
			for i,v in ipairs(donate_list) do
				print("sjfdksjdfsfjsldf",v)
			end
			Net:send({guidList = donate_list},"alliance","AddItemToStore")
		else
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("请选择要捐献的装备"))
		end
	end
end

function WarehouseDonate:register()
	StateManager:register_view( self )
end

function WarehouseDonate:cancel_register()
	StateManager:remove_register_view( self )
end

function WarehouseDonate:on_showed()
	self:register()
	self:init_ui()
end

function WarehouseDonate:on_hided()
end

-- 释放资源
function WarehouseDonate:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return WarehouseDonate

