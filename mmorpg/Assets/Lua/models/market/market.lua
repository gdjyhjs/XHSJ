--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-19 18:27:52
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Market = LuaItemManager:get_item_obejct("market")
local MarketTools = require("models.market.marketTools")
--UI资源
Market.assets=
{
    View("marketView", Market) 
}

-- 获取是否有红点
function Market:is_have_red_point()
	return false
end

--初始化函数只会调用一次
function Market:initialize()
	self.sellGoods = {} --正在出售的商品列表
	self.sellSize = 0 --出售容量
	self.historys = {} --历史记录
end

--点击事件
function Market:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event("market_view_on_click", false, obj, arg)
end

--服务器返回
function Market:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("shop") then
		-- gf_print_table(msg,"--收到shop协议")
		if id2== Net:get_id2("shop", "BuyMarketItemR") then
			gf_print_table(msg,"收到协议-- 购买市场上的物品 Update")
			self:buy_market_item_s2c(msg)
		elseif id2== Net:get_id2("shop", "GetMarketItemInfoListR") then
			gf_print_table(msg,"收到协议--获取市场上的挂售商品")
			self:get_market_item_info_list_s2c(msg)
		elseif id2== Net:get_id2("shop", "GetMarketTypeCountsR") then
			gf_print_table(msg,"收到协议--获取哪个大类的在售数")
			self:get_market_type_counts_s2c(msg)
		elseif id2== Net:get_id2("shop", "SearchMarketR") then
			gf_print_table(msg,"收到协议--搜索")
			self:search_market_s2c(msg)

		-- 出售
		elseif id2== Net:get_id2("shop", "UnlockMarketR") then
			gf_print_table(msg,"收到协议-- 解锁店铺容量")
			self:unlock_market_s2c(msg)
		elseif id2== Net:get_id2("shop", "GetMarketInfoR") then
			gf_print_table(msg,"wtf receive GetMarketInfoR")
			gf_print_table(msg,"收到协议-- 获取自己的市场信息")
			self:get_market_info_s2c(msg)
		elseif id2== Net:get_id2("shop", "SellMarketItemsR") then
			gf_print_table(msg,"收到协议-- 自己将物品挂售出去")
			self:sell_market_items_s2c(msg)
		elseif id2== Net:get_id2("shop", "CancelSellMarketItemR") then
			gf_print_table(msg,"收到协议-- 取消挂售")
			self:cancel_sell_mark_item_s2c(msg,sid)
		elseif id2 == Net:get_id2("shop", "SellItemR") then
			gf_print_table(msg,"收到协议-- 当别人购买了自己的物品，自己又在线上的时候，会有一个推送")
			self:sell_item_s2c(msg)
		elseif id2 == Net:get_id2("shop", "TheCheapestR") then
			gf_print_table(msg,"收到协议-- 获得其他玩家的参考价格")
		end
	end
end

--购买 协议
--购买市场上的物品
function Market:buy_market_item_s2c(msg)
	-- 添加一条历史记录
	if msg.err == 0 then
		local item = msg.marketItemInfo.item or msg.marketItemInfo.equip
		local history = {
			protoId = item.protoId,
			star = item.exAttr and #item.exAttr or 0,
			color = item.color or 0,
			timestamp = Net:get_server_time_s(),
			price = -msg.marketItemInfo.price or 0,
			prefix = item.prefix or 0,
			num = item.num,
		}
		table.insert(self.historys,1,history)
		
		if #self.historys>20 then
			table.remove(self.historys,#self.historys)
		end
	end
	gf_mask_show(false)
end

--清空一个大类的商品缓存
function Market:clear_type_market(type)
	for k,v in pairs(marketPageName[type]) do
		marketGoods[type][k]={}
	end
end

--获取挂售的商品
function Market:get_market_item_info_list_s2c(msg)

end

-- 获取哪个大类的在售数
function Market:get_market_type_counts_s2c(msg)

end

-- 搜索
function Market:search_market_s2c(msg)

end



-- 搜索
function Market:search_market_c2s(type,unit_type,protoIds,prefixs)
	local msg = {type=type,unit_type=unit_type,protoIds=protoIds,prefixs=prefixs}
	gf_print_table(msg,"发送搜索协议")
	Net:send(msg,"shop","SearchMarket")
end

function Market:get_market_type_counts_c2s(type)
	print("--获取哪个大类的在售数",type)
	Net:send({type=type},"shop","GetMarketTypeCounts")
end

function Market:get_market_item_info_list_c2s(type,unit_type,sort,page)
	print("--获取市场上的挂售商品",type,unit_type,sort,page)
	Net:send({type=type,unit_type=unit_type,sort=sort,page=page},"shop","GetMarketItemInfoList")
end

	
function Market:buy_market_item_c2s(guid,protoId)
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end
	print("--购买市场上的物品")
	print("购买",guid,protoId)
	Net:send({guid=guid,protoId=protoId},"shop","BuyMarketItem")
	gf_mask_show(true)
end

--解锁店铺货架数量
function Market:unlock_market_s2c(msg)
	if msg.err == 0 then
		self.sellSize = msg.capacity
	end
end

--获取自己的市场信息
function Market:get_market_info_s2c(msg)
	if msg.err==0 then
		self.sellSize = msg.capacity
		self.sellGoods = msg.list
		self.historys = msg.historys
		table.sort(self.historys,function(a,b) return a.timestamp>b.timestamp end)
	end
end

--自己将物品挂售出去
function Market:sell_market_items_s2c(msg)
	if msg.err == 0 then
		self.sellGoods[#self.sellGoods+1] = msg.sellItemInfo
	end
end

--取消挂售
function Market:cancel_sell_mark_item_s2c(msg)
	if msg.err == 0 then
		for i,v in ipairs(self.sellGoods) do
			local item = v.item or v.equip
			if item.guid==msg.guid then
				table.remove(self.sellGoods,i)
				return
			end
		end
	end
end

function Market:sell_item_s2c(msg)
	-- 添加一条历史记录
	local goods,idx = (function()
			for i,v in ipairs(self.sellGoods) do
				local item = v.item or v.equip
				if item.guid==msg.guid then
					return self.sellGoods[i],i
				end
			end
		end)()

	local item = goods.item or goods.equip
	local history = {
		protoId = item.protoId,
		star = item.exAttr and #item.exAttr or 0,
		color = item.color or 0,
		timestamp = Net:get_server_time_s(),
		price = goods.price,
		tax = math.ceil(goods.price*(self:get_tax())),
		prefix = item.prefix or 0,
		num = item.num,
	}
	table.insert(self.historys,1,history)
	
	if #self.historys>20 then
		table.remove(self.historys,#self.historys)
	end
	table.remove(self.sellGoods,idx)
end
	
function Market:unlock_market_c2s()
	print("--解锁店铺货架数量")
	Net:send({},"shop","UnlockMarket")
end
	
function Market:get_market_info_c2s()
	print("--获取自己的市场信息")
	if LuaItemManager:get_item_obejct("game"):getLevel() >= 30 then
		Net:send({},"shop","GetMarketInfo")
	end
end
	
function Market:sell_market_items_c2s(guid,num,price)
	print("--自己将物品挂售出去",guid,num,price)
	if not LuaItemManager:get_item_obejct("setting"):is_lock() then
		Net:send({guid=guid,num=num,price=price},"shop","SellMarketItems",sid)
	end
end
	
function Market:cancel_sell_mark_item_c2s(guid)
	print("--取消挂售  ",guid)
	local msg = {guid=guid}
	Net:send(msg,"shop","CancelSellMarketItem")
end
	
function Market:the_cheapst_c2s(protoId)
	print("--获得其他玩家的参考价格",protoId)
	Net:send({protoId=protoId},"shop","TheCheapest",sid)
end

function Market:set_open_mode(page1,page2,page3)
	self.open_page1 = page1
	self.open_page2 = page2
	self.open_page3 = page3
end

function Market:get_tax()
	local vip_lv = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
	return ConfigMgr:get_config("t_misc").gold_market.gain_mul[vip_lv]
end


--- set get
-- 保存最近搜索词语
function Market:save_search_keys(list)
	local s = serpent.dump(list)
	PlayerPrefs.SetString("search_keys",s)
end
-- 读取最近搜索词语
function Market:load_search_keys()
	local s = PlayerPrefs.GetString("search_keys", serpent.dump({}))
	local list = loadstring(s)()
	return list
end
