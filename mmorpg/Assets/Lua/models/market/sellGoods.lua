--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-27 10:02:04
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local price_min = ConfigMgr:get_config("t_misc").gold_market.price_min
local price_max = ConfigMgr:get_config("t_misc").gold_market.price_max

local SellGoods=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "market_sell_goods.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    self.goods_item = nil
end)

function SellGoods:set_data(goods_item)
	 self.goods_item = goods_item
	 if self.init then
		self:init_ui()
	end
end

-- 资源加载完成
function SellGoods:on_asset_load(key,asset)
	self.references_list = {}

	self.bg = self.refer:Get("bg")
	self.icon = self.refer:Get("icon")
	self.name = self.refer:Get("name")
	self.count = self.refer:Get("count")
	self.price = self.refer:Get("price")
	self.tax = self.refer:Get("tax")
	self.unitPrice = self.refer:Get("unitPrice")

	self.referencesItems = {}

	for i=1,4 do
		self.referencesItems[i] = self.refer:Get(i)
		self.referencesItems[i]:Get("obj"):SetActive(false)
	end
	self.init = true
	self:init_ui()
end

function SellGoods:init_ui()
	if not self.goods_item then
		return
	end
	self:set_item()
	self.item_obj:the_cheapst_c2s(self.goods_item.protoId)

	self.tax.text = string.format(gf_localize_string("您当前为VIP<color=#e63e35>%d</color>，税率将至：<color=#e63e35>%d%%</color>"),
		LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv(),self.item_obj:get_tax()*100)
end

function SellGoods:set_item()
	local data = ConfigMgr:get_config("item")[self.goods_item.protoId]
	self.is_equip = data.type == ServerEnum.ITEM_TYPE.EQUIP
	if self.is_equip then
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		gf_set_equip_icon(self.goods_item,self.icon,self.bg)
		local prefix = itemSys:get_equip_prefix_name(self.goods_item.prefix)
		self.name.text = string.format("%s%s",prefix,data.name)
	else
		gf_set_item(self.goods_item.protoId,self.icon,self.bg)
		self.name.text = data.name
	end
	self.sell_count = self.goods_item.num
	self.sell_price = price_min
	self:set_sell()
end

function SellGoods:set_references()
	local list = self.references_list or {}
	local u_price = 0 -- 商品单价总和
	for i,v in ipairs(self.referencesItems) do
		local info = list[i]
		if info then
			local item = info.item or info.equip
			local data = ConfigMgr:get_config("item")[item.protoId]
			if self.is_equip then
				local itemSys = LuaItemManager:get_item_obejct("itemSys")
				gf_set_equip_icon(item,v:Get("icon"),v:Get("bg"))
				local prefix = itemSys:get_equip_prefix_name(item.prefix)
				v:Get("name").text = string.format("%s%s",prefix,data.name)
			else
				gf_set_item(item.protoId,v:Get("icon"),v:Get("bg"))
				v:Get("name").text = data.name
			end
			v:Get("money").text = info.price
			v:Get("count").text = item.num
			v:Get("obj"):SetActive(true)
			u_price = u_price + info.price/(item.num or 1)
		else
			v:Get("obj"):SetActive(false)
		end
	end
	self.recommend_unit_price = #list>0 and math.floor(u_price/#list) or price_min
	local price = self.recommend_unit_price*self.goods_item.num
	self:set_sell_price(price)
end

function SellGoods:set_sell_count(count)
	self.sell_count = count or self.goods_item.num
	if self.sell_count<1 then
		self.sell_count = self.goods_item.num
	elseif self.sell_count>self.goods_item.num then
		self.sell_count = 1
	end
	if self.recommend_unit_price then
		local price = self.recommend_unit_price*self.sell_count
		self:set_sell_price(price)
	end
	self:set_sell()
end

-- 设置出售价格
function SellGoods:set_sell_price(price)

	self.sell_price = price or price_min
	if self.sell_price<price_min then
		self.sell_price = price_min
	elseif self.sell_price>price_max then
		self.sell_price = price_max
	end
	self:set_sell()
end

-- 设置出售
function SellGoods:set_sell()
	self.count.text = self.sell_count
	self.price.text = self.sell_price
	local unit_price = self.sell_price/self.sell_count
	unit_price = unit_price < 0.1 and 0.1 or unit_price
	self.unitPrice.text = string.format("%0.1f",unit_price)
end

function SellGoods:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeSellGoods" then
		-- 关闭
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:dispose()
	elseif cmd == "cutCount" then
		-- 数量减少
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:set_sell_count(self.sell_count-1)
	elseif cmd == "count" then
		-- 设置数量
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

		local exit_kb = function(result)
			result = tonumber(result)
			self:set_sell_count(result or self.sell_count)
		end
		LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(self.count,self.goods_item.num,1,nil,nil,nil,nil,exit_kb)

	elseif cmd == "addCount" then
		-- 数量增加
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:set_sell_count(self.sell_count+1)
	elseif cmd == "cutPrice" then
		-- 价格减少
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self.recommend_unit_price = nil
		self:set_sell_price(self.sell_price-1)
	elseif cmd == "price" then
		-- 设置价格
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self.recommend_unit_price = nil
		local exit_kb = function(result)
			result = tonumber(result)
			self:set_sell_price(result or self.sell_price)
		end
		LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(self.price,price_max,price_min,nil,nil,nil,nil,exit_kb)

	elseif cmd == "addPrice" then
		-- 价格增加价格价格价格加个价格价格价格价格价格价格
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self.recommend_unit_price = nil
		self:set_sell_price(self.sell_price+1)
	elseif cmd == "sureUpBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:sell_market_items_c2s(self.goods_item.guid,self.sell_count,self.sell_price)
	elseif cmd == "bg" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.is_equip then
			LuaItemManager:get_item_obejct("itemSys"):equip_browse(self.goods_item)
		else
			LuaItemManager:get_item_obejct("itemSys"):prop_tips(self.goods_item.protoId)
		end
	elseif cmd == "referencesItem" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local idx = obj.transform:GetSiblingIndex()+1
		local goods_info = self.references_list[idx]
		if goods_info then
			local item = goods_info.item or goods_info.equip
			if self.is_equip then
				LuaItemManager:get_item_obejct("itemSys"):equip_browse(self.item)
			else
				LuaItemManager:get_item_obejct("itemSys"):prop_tips(self.item.protoId)
			end
		end
	end
end
--服务器返回
function SellGoods:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("shop"))then
		if id2== Net:get_id2("shop", "TheCheapestR") then
			if msg.err == 0 then
				self.references_list = msg.list or {}
				self:set_references()
			end
		elseif id2== Net:get_id2("shop", "SellMarketItemsR") then
			self:dispose()
		end
	end
end

function SellGoods:on_showed()
	StateManager:register_view( self )
end

function SellGoods:on_hide()
	StateManager:remove_register_view( self )
end

-- 释放资源
function SellGoods:dispose()
	self.init = nil
	self:hide()
    self._base.dispose(self)
 end

return SellGoods

