--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-19 20:16:33
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local marketEnum = require("models.market.marketEnum")
local MarketTools = require("models.market.marketTools")
local Enum = require("enum.enum")
local bag_min_count = 24
local bag_line_count = 4

local MarketSell=class(UIBase,function(self, item_obj)
    UIBase._ctor(self, "market_sell.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)
local maxCellSize = #(ConfigMgr:get_config("market_unlock") or {}) -- 最大栏位

-- 资源加载完成
function MarketSell:on_asset_load(key,asset)
	self.myMoneyText = self.refer:Get("myMoneyText")
	local sellItemRoot = self.refer:Get("sellItemRoot")
	local sellItem = self.refer:Get("sellItem")
	self.sell_list = {}
	for i=1,maxCellSize do
		local obj = LuaHelper.Instantiate(sellItem)
		local item = obj.transform
		item:SetParent(sellItemRoot,false)
		local cost_text = item:Find("cost_text"):GetComponent("UnityEngine.UI.Text")
		local bg = item:Find("bg"):GetComponent(UnityEngine_UI_Image)
		self.sell_list[i] = {
			obj = obj,
			bg = bg,
			icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
			lock = item:Find("lock").gameObject,
			count = item:Find("count"):GetComponent("UnityEngine.UI.Text"),
			add = item:Find("add").gameObject,
			name = item:Find("name"):GetComponent("UnityEngine.UI.Text"),
			cost_text = cost_text,
			is_lock = true,
		}
		cost_text.text = ConfigMgr:get_config("market_unlock")[i].gold
		bg.name = "goodsItem"
		obj:SetActive(true)
		obj.name = "sellItem"
	end

	self.bagItemRoot = self.refer:Get("bagItemRoot")
	self.bagItem = self.refer:Get("bagItem")
	self.bag_list = {}

	self:init_ui()
	self.init = true
end

function MarketSell:init_ui()
	print("初始化界面")
	self.myMoneyText.text = gf_format_count(LuaItemManager:get_item_obejct("game"):get_money(Enum.BASE_RES.GOLD))
	self:set_goods_list()
	self:set_up_list()
end

-- 设置出售列表
function MarketSell:set_goods_list()
	print("设置出售列表")
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	for i,v in ipairs(self.sell_list) do
		local goods = self.item_obj.sellGoods[i]
		if goods then
			-- 设置商品
			local item = goods.item or goods.equip
			local item_data = ConfigMgr:get_config("item")[item.protoId]
			if goods.item then
				gf_set_item(item.protoId,v.icon,v.bg)
				v.name.text = item_data.name
			elseif goods.equip then
				gf_set_equip_icon(item,v.icon,v.bg)
				local prefix = itemSys:get_equip_prefix_name(item.prefix)
				v.name.text = string.format("%s%s",prefix,item_data.name)
			end
			if v.is_lock then
				v.is_lock = nil
				v.lock:SetActive(false)
			end
			if not v.goods then
				v.add:SetActive(false)
			end
			v.count.text = item.num
			v.cost_text.text = goods.price
			v.goods = goods
			v.icon.gameObject:SetActive(true)
		elseif i <= self.item_obj.sellSize then
			-- 设置加号
			if v.is_lock then
				v.is_lock = nil
				v.icon.gameObject:SetActive(false)
				v.lock:SetActive(false)
				v.add:SetActive(true)
				v.name.text = gf_localize_string("空栏位")
				v.cost_text.text = nil
			elseif v.goods then
				v.add:SetActive(true)
				v.icon.gameObject:SetActive(false)
				gf_set_quality_bg(v.bg,0)
				v.name.text = gf_localize_string("空栏位")
				v.cost_text.text = nil
				v.count.text = nil
				v.goods = nil
			end
		end
	end
end

-- 设置上架列表
function MarketSell:set_up_list()
	print("设置上架列表")
	local items = LuaItemManager:get_item_obejct("bag"):get_item_list(ServerEnum.BAG_TYPE.NORMAL)
	local idx = 0
	for i,v in ipairs(items) do
		local item_data = MarketTools:get_goods_item(v.protoId)
		if item_data and (not v.color or v.color>=3) and ConfigMgr:get_config("item")[v.protoId].bind==0 then -- 类型正确，如果是装备还需要满足品质紫色以上
			idx = idx + 1
			if not self.bag_list[idx] then
				local obj = LuaHelper.Instantiate(self.bagItem)
				local item = obj.transform
				item:SetParent(self.bagItemRoot,false)
				self.bag_list[idx] = {
					obj = obj,
					bg = item:GetComponent(UnityEngine_UI_Image),
					icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
					count = item:Find("count"):GetComponent("UnityEngine.UI.Text"),
				}
			end
			local item = self.bag_list[idx]
			item.icon.gameObject:SetActive(true)
			if item_data.type == ServerEnum.ITEM_TYPE.EQUIP then
				print("设置待上架装备图标",v.protoId,item.icon,item.bg,item_data.sub_type)
				gf_set_equip_icon(v,item.icon,item.bg)
			else
				print("设置待上架物品图标",v.protoId,item.icon,item.bg,item_data.sub_type)
				gf_set_item(v.protoId,item.icon,item.bg)
			end
			item.count.text = v.num > 1 and v.num or nil
			item.item = v
			item.obj.name = "bagItem"
			item.obj:SetActive(true)
		end
	end
	local supp_count = (bag_min_count>idx and bag_min_count-idx) or (idx%bag_line_count>0 and bag_line_count-idx%bag_line_count) or 0
	for i=1,supp_count do
		idx = idx + 1
		if not self.bag_list[idx] then
			local obj = LuaHelper.Instantiate(self.bagItem)
			local item = obj.transform
			item:SetParent(self.bagItemRoot,false)
			self.bag_list[idx] = {
				obj = obj,
				bg = item:GetComponent(UnityEngine_UI_Image),
				icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
				count = item:Find("count"):GetComponent("UnityEngine.UI.Text"),
			}
		end
		local item = self.bag_list[idx]
		item.icon.gameObject:SetActive(false)
		gf_set_quality_bg(item.bg,0)
		item.count.text = nil
		item.item = nil
		item.obj.name = nil
		item.obj:SetActive(true)
	end
	for i=idx+1,#self.bag_list do
		self.bag_list[i].obj:SetActive(false)
	end
end

function MarketSell:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btnHelp" then                  
		gf_show_doubt(1181)
	elseif cmd == "add" then
	elseif cmd == "goodsItem" then
	elseif cmd == "bagItem" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local idx = obj.transform:GetSiblingIndex()
		self:bag_item_tips(idx)
	elseif cmd == "sellItem" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local idx = obj.transform:GetSiblingIndex()
		self:goods_item_tips(idx)
	end
end

-- 添加上架
function MarketSell:add_up(item)
	View("sellGoods",self.item_obj):set_data(item)

end

-- 点击已上架的商品
function MarketSell:goods_item_tips(idx)
	local goods = self.sell_list[idx].goods
	if goods then
		-- 下架tips
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local item = goods.item or goods.equip
		local down_fn = function()
			self.item_obj:cancel_sell_mark_item_c2s(item.guid)
		end
		itemSys:add_tips_btn("下架",down_fn)
		if goods.item then
			itemSys:prop_tips(item.protoId)
		else
			itemSys:equip_browse(item)
		end
	elseif self.sell_list[idx].is_lock then
		-- 解锁
		local lock_idx = self.item_obj.sellSize+1
		local need_gole = ConfigMgr:get_config("market_unlock")[lock_idx].gold
		local str = string.format("是否消耗%d元宝解锁当前栏位",need_gole)
		local sure_func = function()
			self.item_obj:unlock_market_c2s()
		end
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(str,sure_func)
	else
		gf_message_tips(gf_localize_string("请在右侧选择上架的商品"))
	end
end

-- 点击背包可上架的物品
function MarketSell:bag_item_tips(idx)
	local item = self.bag_list[idx].item
	if item then
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local up_fn = function()
			self:add_up(item)
		end
		itemSys:add_tips_btn("上架",up_fn)
		if item.color then
			itemSys:equip_browse(item)
		else
			itemSys:prop_tips(item.protoId)
		end
	end
end

-- 点击上架项
function MarketSell:click_sell_item(idx)

end


--服务器返回
function MarketSell:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("shop"))then
		-- 出售
		if id2== Net:get_id2("shop", "SellMarketItemsR") then -- 出售
			if self.init then
				self:init_ui()
			end
		elseif id2== Net:get_id2("shop", "CancelSellMarketItemR") then -- 取消挂售
			if self.init then
				self:init_ui()
			end
		elseif id2== Net:get_id2("shop", "UnlockMarketR") then -- 解锁
			if self.init then
				self:init_ui()
			end
		elseif id2 == Net:get_id2("shop", "SellItemR") then -- 别人买了我的东西
			if self.init then
				self:init_ui()
			end
		end
	elseif(id1==Net:get_id1("base"))then
		if id2 == Net:get_id2("base", "UpdateResR") then
			if self.init then
				self.refer:Get("myMoneyText").text = gf_format_count(LuaItemManager:get_item_obejct("game"):get_money(Enum.BASE_RES.GOLD))
			end
		end
	end
end

function MarketSell:on_showed()
	StateManager:register_view( self )
	if self.init then
		self:init_ui()
	end
end

function MarketSell:on_hide()
	StateManager:remove_register_view( self )

end

-- 释放资源
function MarketSell:dispose()
	self:hide()
    self._base.dispose(self)
 end

return MarketSell

