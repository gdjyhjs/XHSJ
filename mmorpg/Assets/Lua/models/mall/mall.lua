--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-04 09:27:47
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Mall = LuaItemManager:get_item_obejct("mall")
local dataUse = require("models.pvp.dataUse")
Mall.priority = ClientEnum.PRIORITY.BAG
--UI资源
Mall.assets=
{
    View("mallView", Mall) 
}
local t_store = {} -- 商城列表
local t_goods = {} -- 物品表 {商店id={[分类名]={}}}

local t_data = {} -- 商品表 {商品id = 商品信息}

Mall.event_name = "mall_view_on_click"
--点击事件
function Mall:on_click(obj,arg)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

--初始化函数只会调用一次
function Mall:initialize()
	self.GetBoughtTimesList = nil -- 已购买次数列表
	self.stage = 0 -- 风云竞技场段位
	-- self:get_bought_times_list_c2s() -- 获取限购 -- 由服务器一开始下发
	self.fristPayList = {} -- 首冲情况

	if not self.init then
		self:init_shop_data()
	end
	self.init = true
end

function Mall:init_shop_data()
	local store = ConfigMgr:get_config("shop")
	local goods = ConfigMgr:get_config("goods")
	-- 获取商店列表 按模块分类，每个模块按顺序排列
	for k,v in pairs(store) do
		if v.is_mall==1 then --是商城的
			if not t_store[v.shop_mode] then t_store[v.shop_mode] = {} end
			t_store[v.shop_mode][v.order] = v
		end
	end
	for k,v in pairs(goods) do
		if not t_goods[v.shop_id] then t_goods[v.shop_id] = {} end
		local order = v.sub_type_order or 1
		if not t_goods[v.shop_id][order] then t_goods[v.shop_id][order] = {} end
		t_goods[v.shop_id][order][v.order] = v
		if not t_data[v.item_code] or t_data[v.item_code].shop_type ~= 4 then
			print(v.name,v.shop_type)
			t_data[v.item_code] = v
		end
	end
end

function Mall:get_store()
	return t_store
end

function Mall:get_goods()
	return t_goods
end

function Mall:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("shop") then
		if id2== Net:get_id2("shop", "BuyR") then
		gf_print_table(msg,"商城协议返回:买")
			self:buy_s2c(msg,sid)
		elseif id2== Net:get_id2("shop", "GetBoughtTimesListR") then
		gf_print_table(msg,"商城协议返回:买过的")
			self:get_bought_times_list_s2c(msg)
		end
	elseif id1==Net:get_id1("copy") then
		gf_print_table(msg,"排名返回")
		if id2== Net:get_id2("copy", "ArenaInfoR") then
			gf_print_table(msg,"wtf receive ArenaInfoR")
			--得到斗币排名
			self.stage = dataUse.get_stage_by_score(msg.score)
		end
	-- elseif id1==Net:get_id1("base") then
	-- 	if id2== Net:get_id2("base", "OnNewDayR") then
	-- 		self:get_bought_times_list_c2s()
	-- 	end
	end
end

function Mall:get_bought_times_list_c2s()
	print("获取已购买次数列表")
	Net:send({}, "shop", "GetBoughtTimesList")
end

function Mall:buy_c2s(goodsId,num)--sel_goods_id,sel_count
	--判断钱够不够，判断限购，判断段位 stage
	local data = ConfigMgr:get_config("goods")[goodsId]
	if LuaItemManager:get_item_obejct("game"):get_money(data.base_res_type) < data.offer*num then -- 钱不够
		local str = gf_set_text_color(ConfigMgr:get_config("base_res")[data.base_res_type].name,ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
		gf_message_tips(string.format(gf_localize_string("%s不足"),str))
		return
	elseif data.range_type==ServerEnum.SHOP_RANGE_TYPE.ARENA and self.stage<data.range_value then --段位不足
		local str = gf_set_text_color(dataUse.get_stage_name(data.range_value),ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
		gf_message_tips(string.format(gf_localize_string("段位为%s可购买"),str))
		return
	elseif data.range_type==ServerEnum.SHOP_RANGE_TYPE.VIP and LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()<data.range_value then --vip不足
		local str = gf_set_text_color(data.range_value,ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
		gf_message_tips(string.format(gf_localize_string("VIP为%s可购买"),str))
		return
	elseif data.limit_times~=0 
		and (self.GetBoughtTimesList[goodsId] or 0) + num > data.limit_times then -- 限购不足
		local str = (data.limit_interval==1 and "你今天购买次数不足") or (data.limit_interval==7 and "本周可购买数量不足！") or "购买次数不足"
		gf_message_tips(gf_localize_string(str))
		return
	end
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	

	-- if data.limit_times~=0 then
	-- 	self.GetBoughtTimesList[goodsId] = (self.GetBoughtTimesList[goodsId] or 0) + num
	-- end
	local sid = Net:set_sid_param(data,num)
	print("市场数据保存",data,num,sid)
	print("发送购买协议",goodsId,num)
	Net:send({goodsId=goodsId,num=num}, "shop", "Buy",sid)
end

function Mall:get_bought_times_list_s2c(msg)
	self.GetBoughtTimesList = {}
	for i,v in ipairs(msg.list or {}) do
		self.GetBoughtTimesList[v.goodsId] = v.times
	end
end

function Mall:buy_s2c(msg,sid)
	if msg.err==0 then
		--购买成功，刷新金币数量等
		print(sid,Net:get_sid_param(sid))
		local data,num = unpack(Net:get_sid_param(sid))
		print("市场数据获得",data,num,dis)
		if data.limit_times~=0 then
			self.GetBoughtTimesList[data.goods_id] = (self.GetBoughtTimesList[data.goods_id] or 0) + num
		end
	end
end

-- 获取商品购买力（携带的钱最多能买几个商品）
function Mall:get_goods_purchasing_power(goodsId)
	local data = ConfigMgr:get_config("goods")[goodsId]
	return math.floor(LuaItemManager:get_item_obejct("game"):get_money(data.base_res_type)/data.offer)
end

function Mall:open_model(value,page,goodsIs)
	self:set_model(value,page,goodsIs)
	self:add_to_state()
end

function Mall:open_select_goods(propId,only_gole)
	local goods_info = self:get_goods_for_prodId(propId)
	print(only_gole,goods_info.shop_type)
	if goods_info and (not only_gole or goods_info.shop_type == 4) then
		local shop_info = ConfigMgr:get_config("shop")[goods_info.shop_id]
		self:open_model(shop_info.shop_mode,shop_info.order,goods_info.goods_id)
	end
end

function Mall:set_model(value,page,goodsId_or_shopId)
	print("设置商城打开的模块",value,page,goodsId)
	self.sel_model = value
	self.sel_page = page
	self.sel_goodsId = goodsId_or_shopId

	if goodsId_or_shopId then
		local shop_data = ConfigMgr:get_config("shop")[goodsId_or_shopId]
		if not shop_data then
			local shop_id = ConfigMgr:get_config("goods")[goodsId_or_shopId].shop_id
			shop_data = ConfigMgr:get_config("shop")[shop_id]
		end
		if shop_data then
			self.sel_model = shop_data.shop_mode
			self.sel_page = shop_data.order
		end
	end
end

-- 根据物品id获取商品
function Mall:get_goods_for_prodId(prodId)
	return t_data[prodId]
end

-- 是否已经首冲
function Mall:is_frist_pay(goods_id)
	return self.fristPayList[goods_id]
end

-- 获取充值配置表
function Mall:get_recharge_data()
	if not self.recharge_data then
		self.recharge_data = {}
		for k,v in pairs(ConfigMgr:get_config("recharge_sdk")) do
			self.recharge_data[#self.recharge_data+1] = v
		end
		table.sort( self.recharge_data, function(a,b) return a.goods_id < b.goods_id end )
	end
	return self.recharge_data
end