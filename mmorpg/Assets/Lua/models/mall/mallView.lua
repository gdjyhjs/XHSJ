--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-04 09:45:32
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local MallEnum = require("models.mall.mallEnum")
local StoreTools = require("models.mall.mallTools")
local PageMgr = require("common.pageMgr")
local Enum = require("enum.enum")
local dataUse = require("models.pvp.dataUse")

local MallView=class(Asset,function(self,item_obj)
	self:set_bg_visible( true )
    Asset._ctor(self, "mall.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)



local sel_count = 1 -- 选择数量
local max_count = 1 -- 最大数量
local sel_goods_id = 1 -- 选择商品id
local sel_goods_price = 1 -- 选择商品价格
local sel_goods_res_type = 0 -- 选择商品所需资源类型

-- 资源加载完成
function MallView:on_asset_load(key,asset)
	self.career = LuaItemManager:get_item_obejct("game"):get_career()
	self.store_content_title = {} -- 商店标题缓存
	self.store_content_root = {} -- 小分类根缓存
	self.store_content_goods = {} -- 商店商品缓存
	self.goods_title_list = {}
	self.goods_root_list = {}
	self.goods_sample_list = {}

    
	self:init_ui()
	self.init = true
	self:show()
end

function MallView:init_ui()
	local ref = self.refer:Get("store_content")
	self.store_content={
		titleItems={
			group = ref:Get("titleRoot"), 
			root = ref:Get("titleRoot").gameObject,
			sample = ref:Get("titleSample"),
			items = {},
		},
		goodsItems={
			shopRoot = ref:Get("shopRoot"),
			goodsTitle = ref:Get("goodsTitle").gameObject,
			goodsSample = ref:Get("goodsSample"),
			goodsRoot = ref:Get("goodsRoot"),
			goodsGroup = ref:Get("goodsGroup"),
			items = {},
		},
		selGoodsColor = ref:Get("selGoodsColor"),
		selGoodsIcon = ref:Get("selGoodsIcon"),
		selGoodsBinding = ref:Get("selGoodsBinding"),
		selGoodsName = ref:Get("selGoodsName"),
		selGoodsPrice = ref:Get("selGoodsPrice"),
		selGoodsPriceIcon = ref:Get("selGoodsPriceIcon"),
		selGoodsOffer = ref:Get("selGoodsOffer"),
		selGoodsOfferIcon = ref:Get("selGoodsOfferIcon"),
		selGoodsDes = ref:Get("selGoodsDes"),
		buyCount = ref:Get("buyCount"),
		bugPrice = ref:Get("bugPrice"),
		bugPriceIcon = ref:Get("bugPriceIcon"),
		haveMoney = ref:Get("haveMoney"),
		haveMoneyIcon = ref:Get("haveMoneyIcon"),
		obj = ref:Get("obj"),
		moneyGetWay = ref:Get("moneyGetWay"),
		getWayDes = ref:Get("getWayDes"),
		curRanking = ref:Get("curRanking"),
		addMoney = ref:Get("addMoney"),
		goToGet = ref:Get("goToGet"),
		purchaseRestriction = ref:Get("purchaseRestriction"),
		pricePbj = ref:Get("pricePbj"),
		offerObj = ref:Get("offerObj"),
	}
	-----------------------------------------------------+++++++++++++++++++++++++++++++++++++++++

    self.page_mgr = PageMgr(self.refer:Get("yeqian"))
end

function MallView:select_page(value)
	print("选择页签",value)
    if not self.page_mgr then
        return
    end
    self.page_mgr:select_page(value)

    if value < 4 then
    	self:set_store(value)
    	if not self.store_content.obj.activeSelf then
	    	self.store_content.obj:SetActive(true)
	    	-- self.refer:Get("top_ups"):SetActive(false)
	    	if self.payView then
	    		self.payView:hide()
	    	end
	    end
    else
    	if self.store_content.obj.activeSelf then
	    	self.store_content.obj:SetActive(false)
	    	-- self.refer:Get("top_ups"):SetActive(true)
	    	if not self.payView then
		    	self.payView = require("models.mall.payGold")(self.item_obj)
		    	self:add_child(self.payView)
		    else
		    	self.payView:show()
		    end
	    end
    end
end

function MallView:on_click(item_obj,obj,arg)
	print("点击了商城系统",item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "mall_close" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif string.find(cmd, "page_") then -- 选择页签
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
		self:select_page(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd, "shop_") then -- 选择商店
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
		self:select_store(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd, "goods_") then -- 选择商品
		local goods_index = tonumber(string.split(cmd,"_")[2])
		-- print("选择商品",goods_index,"是否重复点击",sel_goods_id == goods_index,"是否已达最大购买数量",sel_count+1 < max_count)
		if sel_goods_id == self.store_content_goods[goods_index].goodInfo.goods_id then
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			if sel_count+1 <= max_count then
				self:sel_count_change(sel_count+1)
			end
		else
			Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换3级页签音效
			-- print("原选择商品",sel_goods_id,"新的选择商品",goods_index)
			self:select_goods(goods_index)
		end
		self.rand_sel = nil
		print("set_rand_sel",self.rand_sel)
	elseif string.find(cmd, "toModule_") then -- 功能跳转
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local model_id = tonumber(string.split(cmd,"_")[2])
		if gf_open_model(model_id) then
			self:hide()
		end
	elseif cmd == "buyGoodsBtn" then --购买商品
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:buy_goods()
	elseif cmd == "addBuyCount" then --添加数量
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sel_count_change(sel_count+1)
	elseif cmd == "cutBuyCount" then --减少数量
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sel_count_change(sel_count-1)
	elseif cmd == "buyCount" then --输入数量
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:show_number_keyboard(arg)
	-- elseif string.find(cmd,"topUps_") then
	-- 	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
	-- 	Net:send({gold=tonumber(string.split(cmd,"_")[2])},"shop","FakeCharge") --模拟充值
	-- 	SdkMgr:pay("1001","充值10元宝",1,1,"1001_qick")
	end
end

--购买商品
function MallView:buy_goods()
	--判断钱够不够，判断限购，判断段位 stage
	local data = ConfigMgr:get_config("goods")[sel_goods_id]
	-- if LuaItemManager:get_item_obejct("game"):get_money(data.base_res_type) < data.offer*sel_count then -- 钱不够
	-- 	local str = gf_set_text_color(ConfigMgr:get_config("base_res")[data.base_res_type].name,ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
	-- 	gf_message_tips(string.format(gf_localize_string("%s不足"),str))
	-- 	return
	-- elseif data.range_value~=0 and stage<data.range_value then --段位不足
		-- local str = gf_set_text_color(dataUse.get_stage_name(data.range_value),ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
		-- gf_message_tips(string.format(gf_localize_string("段位为%s可购买"),str))
		-- return
	-- elseif data.limit_times~=0 
	-- 	and (self.item_obj.GetBoughtTimesList[sel_goods_id] or 0) + sel_count > data.limit_times then -- 限购不足
	-- local str = (data.limit_interval==1 and "你今天购买次数不足") or (data.limit_interval==7 and "本周可购买数量不足！") or "购买次数不足"
	-- 	gf_message_tips(gf_localize_string(str))
	-- 	return
	-- end
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	
	self.item_obj:buy_c2s(sel_goods_id,sel_count)

	-- -- 判断限购
	-- if ConfigMgr:get_config("goods")[sel_goods_id].limit_times~=0 then
	-- 	self.item_obj.GetBoughtTimesList[sel_goods_id] = self.item_obj.GetBoughtTimesList[sel_goods_id] + sel_count
	-- end
end

function MallView:show_number_keyboard(text)
	-- print("打开小键盘协助输入",text)
	StateManager:remove_register_view( self )
	local exit_kb = function(result)
		-- print("结果：",result)
		sel_count = tonumber(result)~=0 and tonumber(result) or 1
		text.text = sel_count
		self.store_content.bugPrice.text = sel_goods_price*sel_count
		StateManager:register_view( self )		
	end
	LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(text,max_count,nil,nil,nil,nil,nil,exit_kb)
end
--选择数量变化时 判断是否超最大或者小于0
function MallView:sel_count_change(count)
	if count > max_count then
		count = 1
	elseif count < 1 then
		count = max_count~=0 and max_count or 1
	end
	sel_count = count
	local list = self.store_content
	local need_money = sel_count*sel_goods_price
	print("货币类型",sel_goods_res_type)
	if need_money > LuaItemManager:get_item_obejct("game"):get_money(sel_goods_res_type) then
		list.buyCount.text = gf_set_text_color(sel_count,ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN)
	else
		list.buyCount.text = sel_count
	end
	list.bugPrice.text = sel_count*sel_goods_price
end
--设置商店列表
function MallView:set_store(shop_mode)
	self.stores = self.item_obj:get_store()[shop_mode] or {} -- 获取当前的商店列表
	for i,v in ipairs(self.stores) do
		if not self.store_content.titleItems[i] then
			local obj = LuaHelper.InstantiateLocal(self.store_content.titleItems.sample,self.store_content.titleItems.root)
			local ref = obj:GetComponent("ReferGameObjects")
			self.store_content.titleItems[i] = {
				ref = ref,
				obj = obj,
				text = ref:Get("text"),
				sel = ref:Get("sel"),
			}
		end
		local item = self.store_content.titleItems[i]
		item.obj:SetActive(true)
		item.obj.name = "shop_"..i
		item.sel:SetActive(false)
		item.text.text = v.name
		item.text.color = StoreTools.noselShopColor
	end
	self.sel_shop_index = nil
	for i=#self.stores+1,#self.store_content.titleItems do --隐藏多余的项
		self.store_content.titleItems[i].obj:SetActive(false)
	end
	-- 默认选择第一个商店
	self:select_store(self.item_obj.sel_page or 1)
	self.item_obj.sel_page = nil
end
--选择商店
function MallView:select_store(sel_shop_index)
	-- print("选择商店",sel_shop_index)
	if self.sel_shop_index then
		self.store_content.titleItems[self.sel_shop_index].sel:SetActive(false)
		self.store_content.titleItems[self.sel_shop_index].text.color = StoreTools.noselShopColor
	end
	self.sel_shop_index = sel_shop_index
	self.store_content.titleItems[self.sel_shop_index].sel:SetActive(true)
	self.store_content.titleItems[self.sel_shop_index].text.color = StoreTools.selShopColor
	-- 设置当前商店的物品
	self:set_goods(self.stores[sel_shop_index].shop_id)
end
--设置商品列表
function MallView:set_goods(shop_id)
	--清空旧的商店
	for i,v in ipairs(self.store_content_title or {}) do
		self:repay_goods_title(v)
	end
	self.store_content_title = {} -- 商店标题缓存
	for i,v in ipairs(self.store_content_root or {}) do
		self:repay_goods_root(v)
	end
	self.store_content_root = {} -- 小分类根缓存
	for i,v in ipairs(self.store_content_goods or {}) do
		self:repay_goods_sample(v.obj)
	end
	self.store_content_goods = {} -- 商店商品缓存

	local have_type_name_data = nil
	local goods = self.item_obj:get_goods()[shop_id] or {}
	-- gf_print_table(goods,"所有商品")

	-- for i,t in ipairs(goods or {}) do
		-- print("标题",i,t[1].sub_type)
	-- end
	local game = LuaItemManager:get_item_obejct("game")

	local sel_idx = nil -- 默认选择的商品序号
	for i,t in ipairs(goods or {}) do
		-- print("--判断:需要加标题",i,t[1].sub_type)
		if t[1] and t[1].sub_type then -- 有标题的添加一个标题
			local title = self:get_goods_title()
			title.transform:SetParent(self.store_content.goodsItems.shopRoot,false)
			title:GetComponentInChildren("UnityEngine.UI.Text").text = t[1].sub_type
			self.store_content_title[#self.store_content_title+1]=title
		end
			have_type_name_data = t[1]
		--添加一个根
		local root = self:get_goods_root()
		root.transform:SetParent(self.store_content.goodsItems.shopRoot,false)
		self.store_content_root[#self.store_content_root+1] = root

		for i,v in ipairs(t) do
			if v.career == 0 or v.career == self.career then
				print("设置商品",v.goods_id,v.name)
				local goods = self:get_goods_sample()
				goods.transform:SetParent(root.transform,false)
				local item = {}
				self.store_content_goods[#self.store_content_goods+1] = item
				item.obj = goods
				local ref = goods:GetComponent("ReferGameObjects")
				goods.name = "goods_"..#self.store_content_goods
				item.goodInfo = v
				ref:Get("name").text = v.name
				ref:Get("moneyCount").text = v.offer
				gf_set_money_ico(ref:Get("moneyIcon"),v.base_res_type)
				gf_set_item(v.item_code,ref:Get("icon"),ref:Get("color"))
				local bind = LuaItemManager:get_item_obejct("itemSys"):calculate_item_is_bind(v.item_code)
				if ref:Get("binding").activeSelf~=bind then
					ref:Get("binding"):SetActive(bind)
				end
				local show = v.label and true or false
				local label = ref:Get("label")
				label:SetActive(show)
				if show then
					ref:Get("labelTxt").text = v.label
					gf_setImageTexture(label:GetComponent(UnityEngine_UI_Image),v.lable_icon)
				end
				item.sel = ref:Get("select")
				item.sel:SetActive(false)

				if v.goods_id == sel_goods_id then -- 默认要选择的
					sel_idx = #self.store_content_goods
				end

				-- 限购
				item.limit_times = ref:Get("limit_times")
				if v.limit_times~=0 then -- 是限购商品 需要显示限购数量
					print("商品",v.goods_id,"限购",v.limit_times,"已购",self.item_obj.GetBoughtTimesList and self.item_obj.GetBoughtTimesList[v.goods_id] or 0)
					local count = v.limit_times - (self.item_obj.GetBoughtTimesList and self.item_obj.GetBoughtTimesList[v.goods_id] or 0)
					if not self.item_obj.GetBoughtTimesList or not self.item_obj.GetBoughtTimesList[v.goods_id] then
						gf_print_table(self.item_obj.GetBoughtTimesList or {},"没有商品购买记录")
					end
					local str = count > 0 and "(%d/%d)" or "<color=#d01212>(%d/%d)</color>"
					item.limit_times.text = string.format(str,
						 count,v.limit_times)
				else
					item.limit_times.text = nil
				end
			end
		end
	end


	self.rand_sel = nil
	print("set_rand_sel",self.rand_sel)
	--设置货币描述 获取途径 排名
	local goodInfo = self.store_content_goods[1].goodInfo
	local shop = ConfigMgr:get_config("shop")[shop_id]
	local des = shop.des
	
	local money_data = have_type_name_data and ConfigMgr:get_config("base_res")[have_type_name_data.base_res_type] or nil
	if money_data and money_data.get_way>0 and money_data.get_way_desc then
		print("有标题")
		self.store_content.moneyGetWay:SetActive(true)
		self.store_content.goToGet.gameObject:SetActive(true)
		self.store_content.goToGet.name = "toModule_"..money_data.get_way
		self.store_content.getWayDes.text = des or money_data.get_way_desc
		if money_data.money_id == ServerEnum.BASE_RES.ARENA_COIN then -- 斗币排名
			self.store_content.curRanking.text = string.format(gf_localize_string("当前段位：%s"),"未参与")
		else
			self.store_content.curRanking.text = nil
		end
	elseif des then
		print("有描述")
		self.store_content.moneyGetWay:SetActive(true)
		self.store_content.goToGet.gameObject:SetActive(false)
		self.store_content.curRanking.text = nil
		self.store_content.getWayDes.text = des
	else
		self.store_content.moneyGetWay:SetActive(false)
	end

	print("排名类型",goodInfo.range_type)
	if goodInfo.range_type == ServerEnum.SHOP_RANGE_TYPE.ARENA then -- 斗币排名
		if not sel_idx then
			sel_idx = 1
			self.rand_sel = true
			print("set_rand_sel",self.rand_sel)
		end
		LuaItemManager:get_item_obejct("pvp"):send_to_get_pvp_data()

	elseif goodInfo.range_type == ServerEnum.SHOP_RANGE_TYPE.VIP then -- vip排名
		local vip_level = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
		if not sel_idx then
			self.rand_sel = true
			sel_idx = 0
			local goodInfo = self.item_obj:get_goods()[shop_id] or {}
			for i,t in ipairs(goodInfo or {}) do
				for i,v in ipairs(t) do
					if v.career == 0 or v.career == self.career then
						sel_idx = sel_idx + 1
						if v.range_value <= vip_level then
							self.rand_sel = nil
							break
						end
					end
				end
				if not self.rand_sel then
					break
				end
			end
		end
		if self.rand_sel then
			self.rand_sel = nil
		end
	end

	--选择商品
	self.select_goods_index = nil
	if not sel_idx or sel_idx<1 then
		sel_idx = 1
	end
	self:select_goods(sel_idx)
	local left_count = goodInfo.sub_type and 3 or 4
	local move_count = math.ceil(#self.store_content_goods/2)-left_count
	local pos = 1 - (math.ceil(sel_idx/2)-1)/(move_count>0 and move_count or 1)
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (self.refer:Get("goosContent")) -- 立即重建布局
	self.refer:Get("goodsScrollRect").verticalNormalizedPosition = (pos < 0 and 0) or (pos > 1 and 1) or pos
end

--设置服务器返回的排名
function MallView:set_rank()
	print("设置服务器返回的排名",self.rand_sel)
	print("set_rand_sel",self.rand_sel)
	if not self.rand_sel then
		print("set_rand_sel",self.rand_sel)
		return
	end
	print("set_rand_sel",self.rand_sel)
	local rank = self.item_obj.stage or 0
    print("排名",rank)
    local name = dataUse.get_stage_name(rank)
    local text = string.format(gf_localize_string("当前段位：%s"),name)
    print("排名名称",name)
    self.store_content.curRanking.text = name
    print("商店id",self.stores[self.sel_shop_index].shop_id)
	local goods = self.item_obj:get_goods()[self.stores[self.sel_shop_index].shop_id] or {}
	sel_idx = 0
	for i,t in ipairs(goods or {}) do
		for i,v in ipairs(t) do
			if v.career == 0 or v.career == self.career then
				sel_idx = sel_idx + 1
				if v.range_value <= rank then
					self.rand_sel = nil
					break
				end
			end
		end
		if not self.rand_sel then
			break
		end
	end
	if self.rand_sel then
		self.rand_sel = nil
	end
	self:select_goods(sel_idx)

	local left_count = 3
	local move_count = math.ceil(#self.store_content_goods/2)-left_count
	local pos = 1 - (math.ceil(sel_idx/2)-1)/(move_count>0 and move_count or 1)
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (self.refer:Get("goosContent")) -- 立即重建布局
	self.refer:Get("goodsScrollRect").verticalNormalizedPosition = (pos < 0 and 0) or (pos > 1 and 1) or pos
end

--选择商品
function MallView:select_goods(index)
	print("----------------------选择商品",index)
	if self.select_goods_index then
		print("隐藏",self.select_goods_index)
		self.store_content_goods[self.select_goods_index].sel:SetActive(false)
	end
	self.select_goods_index = index
	print("显示",index)
	local item = self.store_content_goods[index]
	item.sel:SetActive(true)
	self:set_right(item.goodInfo)
end


--设置右边，设置选择商品的各种属性
function MallView:set_right(goodInfo)
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	self.select_goodInfo = goodInfo
	sel_goods_id = goodInfo.goods_id
	local list = self.store_content
	gf_set_item(goodInfo.item_code,list.selGoodsIcon,list.selGoodsColor)
	gf_set_click_prop_tips(list.selGoodsColor,goodInfo.item_code)
	local bind = itemSys:calculate_item_is_bind(goodInfo.item_code)
	if list.selGoodsBinding.activeSelf~=bind then
		list.selGoodsBinding:SetActive(bind)
	end
	local have_money = LuaItemManager:get_item_obejct("game"):get_money(goodInfo.base_res_type)
	list.selGoodsName.text = goodInfo.name
	-- 设置售价或限购

	list.pricePbj:SetActive(goodInfo.price ~= 0)
	list.offerObj:SetActive(goodInfo.price ~= 0)
	sel_goods_price = goodInfo.offer
	if goodInfo.price ~= 0 then -- 是特价商品 需要显示原价和特价
		list.selGoodsPrice.text = goodInfo.price
		gf_set_money_ico(list.selGoodsPriceIcon,goodInfo.base_res_type)
		list.selGoodsOffer.text = sel_goods_price
		gf_set_money_ico(list.selGoodsOfferIcon,goodInfo.base_res_type)
	end
	list.purchaseRestriction.gameObject:SetActive(goodInfo.limit_times~=0)
	if goodInfo.limit_times~=0 then -- 是限购商品 需要显示限购数量
		local str = (goodInfo.limit_interval==1 and "每天限购：%d") or (goodInfo.limit_interval==7 and "每周限购：%d") or "限购：%d"
		list.purchaseRestriction.text = string.format(gf_localize_string(str),
			 goodInfo.limit_times - (self.item_obj.GetBoughtTimesList and self.item_obj.GetBoughtTimesList[sel_goods_id] or 0))
	end
	-- list.buyCount.text = sel_count
	-- list.bugPrice.text = sel_goods_price
	gf_set_money_ico(list.bugPriceIcon,goodInfo.base_res_type)
	list.haveMoney.text = gf_format_count(have_money)
	gf_set_money_ico(list.haveMoneyIcon,goodInfo.base_res_type)
	list.selGoodsDes.text = itemSys:get_item_desc(goodInfo.item_code)
	-- 拥有货币 及 获取途径 -- 
	local money_data = ConfigMgr:get_config("base_res")[goodInfo.base_res_type]
	list.addMoney:SetActive(money_data.get_way~=0)
	if not money_data.get_way~=0 then
		list.addMoney.name = "toModule_"..money_data.get_way
	end
	sel_count = 1
	local can_buy_count = math.floor(have_money/sel_goods_price)
	-- 要加上已购买的判断
	if goodInfo.limit_times~=0 and goodInfo.limit_times - (self.item_obj.GetBoughtTimesList and self.item_obj.GetBoughtTimesList[goodInfo.goods_id] or 0)<can_buy_count then
		max_count = goodInfo.limit_times
	else
		max_count = can_buy_count
	end
	sel_goods_res_type = goodInfo.base_res_type -- 保存当前选中的道具的货币类型
	self:sel_count_change(sel_count)
end

--购买成功返回结果之后调用这个方法，重新设置金币和选择购买数量
function MallView:buy_result()
	local list = self.store_content
	local goods = ConfigMgr:get_config("goods")[sel_goods_id]
	local have_money = LuaItemManager:get_item_obejct("game"):get_money(goods.base_res_type)
	list.selGoodsDes.text =  LuaItemManager:get_item_obejct("itemSys"):get_item_desc(goods.item_code)
	list.haveMoney.text = gf_format_count(have_money)
	local can_buy_count = math.floor(have_money/sel_goods_price)
	-- 要加上已购买的判断
	if goods.limit_times~=0 and goods.limit_times - (self.item_obj.GetBoughtTimesList and self.item_obj.GetBoughtTimesList[goods.goods_id] or 0)<can_buy_count then
		max_count = goods.limit_times
	else
		max_count = can_buy_count
	end
	self:sel_count_change(sel_count)
	--限购
	if self.select_goodInfo then
		local str = (goods.limit_interval==1 and "每天限购：%d") or (goods.limit_interval==7 and "每周限购：%d") or "限购：%d"
		local count = self.select_goodInfo.limit_times - (self.item_obj.GetBoughtTimesList and self.item_obj.GetBoughtTimesList[sel_goods_id] or 0)
		list.purchaseRestriction.text = string.format(gf_localize_string(str),count)
		-- 刷新左侧的数量
		if self.select_goodInfo.limit_times~=0 then
			local str = count > 0 and "(%d/%d)" or "<color=#d01212>(%d/%d)</color>"
			self.store_content_goods[self.select_goods_index].limit_times.text = string.format(str,count,self.select_goodInfo.limit_times)
		end
	end
end

-- 关系商店内容部分的  获取子UI
-- UI 获取一个标题
function MallView:get_goods_title()
	if #self.goods_title_list>0 then
		local goods_title = self.goods_title_list[1]
		table.remove(self.goods_title_list,1)
		return goods_title
	else
		local goods_title = LuaHelper.Instantiate(self.store_content.goodsItems.goodsTitle)
		return 	goods_title
	end
end
-- UI 返还一个标题
function MallView:repay_goods_title(g)
	g.transform:SetParent(self.refer:Get("cache"),false)
	self.goods_title_list[#self.goods_title_list+1] = g
end

-- UI 获取一类物品的根
function MallView:get_goods_root()
	if #self.goods_root_list>0 then
		local goods_root = self.goods_root_list[1]
		table.remove(self.goods_root_list,1)
		return goods_root
	else
		local goods_root = LuaHelper.Instantiate(self.store_content.goodsItems.goodsRoot)
		return 	goods_root
	end
end
-- UI 返还一类物品的根
function MallView:repay_goods_root(g)
	-- print(g)
	g.transform:SetParent(self.refer:Get("cache"),false)
	self.goods_root_list[#self.goods_root_list+1] = g
end

-- UI 获取一个物品的样本
function MallView:get_goods_sample()
	if #self.goods_sample_list>0 then
		local goods_sample = self.goods_sample_list[1]
		table.remove(self.goods_sample_list,1)
		return goods_sample
	else
		local goods_sample = LuaHelper.Instantiate(self.store_content.goodsItems.goodsSample)
		return 	goods_sample
	end
end
-- UI 返还一类物品的根
function MallView:repay_goods_sample(g)
	g.transform:SetParent(self.refer:Get("cache"),false)
	self.goods_sample_list[#self.goods_sample_list+1] = g
end

function MallView:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("shop") then
		if id2== Net:get_id2("shop", "BuyR") then
			if msg.err==0 then
				--购买成功，刷新金币数量等
				-- if ConfigMgr:get_config("goods")[sel_goods_id].limit_times>0 then -- 限购的商品
					-- self:set_goods(self.stores[self.sel_shop_index].shop_id)
				-- else
					self:buy_result()
				-- end
			end
		end
	elseif id1==Net:get_id1("copy") then
		if id2== Net:get_id2("copy", "ArenaInfoR") then
			--得到斗币排名
			self:set_rank()
		end
	end
end

function MallView:on_showed()
	if self.init then
		sel_goods_id = self.item_obj.sel_goodsId or 1
		self.item_obj.sel_goodsId = nil

		self:select_page(self.item_obj.sel_model or 1)
		self.item_obj.sel_model = nil
		self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
	end
end

function MallView:on_hided()
	self:dispose()
end

-- 释放资源
function MallView:dispose()
	self.init = nil
	self.item_obj.sel_page = nil
	self.item_obj.sel_model = nil
	self.item_obj.sel_goodsId = nil
	self.item_obj:register_event(self.item_obj.event_name, nil)
	if self.payView then
		self.payView:dispose()
		self.payView = nil
	end
    self._base.dispose(self)
 end

return MallView

