--[[--
-- 市场列表
-- @Author:HuangJunShan
-- @DateTime:2017-07-19 20:16:46
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Dropdown = UnityEngine.UI.Dropdown
local MarketTools = require("models.market.marketTools")
local BatchBuy = require("models.market.batchBuy")

local MarketBuy=class(UIBase,function(self, item_obj)
    UIBase._ctor(self, "market_buy.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)
local search_interval_time = 5
local last_search_time = 0
local kess_max_count = 10

-- 资源加载完成
function MarketBuy:on_asset_load(key,asset)
	self.bigTypeRoot = self.refer:Get("bigTypeRoot")
	self.smallTypeRoot = self.refer:Get("smallTypeRoot")
	self.goodsRoot = self.refer:Get("goodsRoot")
	self.bigTypeItem = self.refer:Get("bigTypeItem")
	self.smallTypeItem = self.refer:Get("smallTypeItem")
	self.goodsItem = self.refer:Get("goodsItem")
	self.typeScrollView = self.refer:Get("typeScrollView")
	self.goodsScrollView = self.refer:Get("goodsScrollView")

	self.bigTypeSel = {}
	self.smallTypeObjs = {}
	self.goodsObjs = {}
	self.searchObjs = {}

	self.buy_type = self.refer:Get("buy_type")
	self.buy_item = self.refer:Get("buy_item")
	self.selectEquip = self.refer:Get("selectEquip")
	self.selectQuality = self.refer:Get("selectQuality")
	self.unitPriceArrow = self.refer:Get("unitPriceArrow")
	self.totalPriceArrow = self.refer:Get("totalPriceArrow")
	self.searchGoods = self.refer:Get("searchGoods")
	self.selectEquipText = self.refer:Get("selectEquipText")
	self.selectLevelText = self.refer:Get("selectLevelText")
	self.qi_e = self.refer:Get("qi_e")
	self.goldCountTxt = self.refer:Get("goldCountTxt")

	-- self.searchBtn = self.refer:Get("searchBtn")
	self.searchBg = self.refer:Get("searchBg")
	self.searchContent = self.refer:Get("searchContent")
	self.searchImg = self.refer:Get("searchImg")
	self.no_search = self.refer:Get("no_search") -- 暂时没有关于"1级攻击宝石"的商品供卖买，换个词搜搜看吧！

	self.search_key = {}
	self.search_list = {}
	self.not_exist_guid = {}

	self.search_keys = self.item_obj:load_search_keys()

	-- 初始化设置大类
	local classification = MarketTools:get_classification()
	for i,v in ipairs(classification) do
		local obj = LuaHelper.Instantiate(self.bigTypeItem)
		local item = obj.transform
		item:SetParent(self.bigTypeRoot,false)
		item:Find("noselname"):GetComponent("UnityEngine.UI.Text").text = v.name
		local sel = item:Find("sel")
		sel:Find("selname"):GetComponent("UnityEngine.UI.Text").text = v.name
		self.bigTypeSel[i] = sel.gameObject
		obj:SetActive(true)
		item.name = "bigTypeItem"
	end
	self:set_gold_count()

	self:init_ui()
	self.init = true
end

-- 初始化
function MarketBuy:init_ui()
	self:select_big_type(self.item_obj.open_page2 or 1)
	self.item_obj.open_page2 = nil
end

-- 选择大类
function MarketBuy:select_big_type(idx)
	if self.big_type_sel then
		self.bigTypeSel[self.big_type_sel]:SetActive(false)
	end
	self.big_type_sel = idx
	self.bigTypeSel[self.big_type_sel]:SetActive(true)
	self.qi_e:SetActive(false)

	if self.item_obj.open_page3 then

		self.item_obj.open_page3 = nil
	else
		self:set_small_type()
	end
	-- 设置搜索键库
	self.search_key = MarketTools:get_search(self.big_type_sel)
	-- self.searchBtn.interactable = self.search_key[self.searchGoods.text] and true or false
end

-- 设置小类
function MarketBuy:set_small_type()
	self.small_type_sel = nil
	local classification = MarketTools:get_classification()
	for i=#classification[self.big_type_sel]+1,#self.smallTypeObjs do
		self.smallTypeObjs[i].obj:SetActive(false)
	end
	local data = ConfigMgr:get_config("market_exist_all")[self.big_type_sel]
	if data then
		if not self.smallTypeObjs[0] then
			local obj = self.smallTypeItem
			local item = obj.transform
			self.smallTypeObjs[0] = {
				obj=obj,
				bg = item:Find("bg"):GetComponent(UnityEngine_UI_Image),
				icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
				name = item:Find("name"):GetComponent("UnityEngine.UI.Text"),
				item_name = "全部",
			}
		end
		local item = self.smallTypeObjs[0]
		gf_setImageTexture(item.icon,data.icon)
		gf_set_quality_bg(item.bg,data.color)
		item.obj:SetActive(true)
	else
		self.smallTypeItem:SetActive(false)
	end
	for i,v in ipairs(classification[self.big_type_sel]) do
		if not self.smallTypeObjs[i] then
			local obj = LuaHelper.Instantiate(self.smallTypeItem)
			local item = obj.transform
			item:SetParent(self.smallTypeRoot,false)
			self.smallTypeObjs[i] = {
				obj = obj,
				bg = item:Find("bg"):GetComponent(UnityEngine_UI_Image),
				icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
				name = item:Find("name"):GetComponent("UnityEngine.UI.Text"),
			}
			item.name = "smallTypeItem"
		end
		local item = self.smallTypeObjs[i]
		gf_setImageTexture(item.icon,v.icon)
		gf_set_quality_bg(item.bg,v.color)
		item.item_name = v.name
		item.name.text = v.name
		item.obj:SetActive(true)
	end
	self.qi_e:SetActive(false)
	self.buy_type:SetActive(true)
	self.buy_item:SetActive(false)
	self.searchBg:SetActive(false)
	self.item_obj:get_market_type_counts_c2s(self.big_type_sel)

	self.typeScrollView.verticalNormalizedPosition = 1
end

-- 设置小类的物品数量
function MarketBuy:set_market_type_counts(sub_typesArr,countsArr,big_type)
	if self.big_type_sel == big_type then
		local count = 0
		for i,v in ipairs(sub_typesArr) do
			local item = self.smallTypeObjs[v]
			item.name.text = string.format("%s\n<color=#90281AFF><size=22>在售：%d</size></color>",item.item_name,countsArr[i])
			count = count + countsArr[i]
		end
		if ConfigMgr:get_config("market_exist_all")[self.big_type_sel] then
			local item = self.smallTypeObjs[0]
			item.name.text = string.format("%s\n<color=#90281AFF><size=22>在售：%d</size></color>",item.item_name,count)
		end
	end
end

-- 选择小类
function MarketBuy:select_small_type(idx)
	self.small_type_sel = idx
	self:get_market_item_info_list()

	-- 设置搜索键库
	self.search_key = MarketTools:get_search(self.big_type_sel,self.small_type_sel)
	-- self.searchBtn.interactable = self.search_key[self.searchGoods.text] and true or false
end

-- 向服务器获取商品
function MarketBuy:get_market_item_info_list(sort,page)
	self.search_str = nil
	local big_type = self.small_type_sel==0 and self.big_type_sel or 0
	local unit_type = self.small_type_sel>0 and MarketTools:get_classification()[self.big_type_sel][self.small_type_sel].unit_type or 0
	self.sort_type = sort or 1
	self.loading_page = page or 1
	self.item_obj:get_market_item_info_list_c2s(big_type,unit_type,self.sort_type,self.loading_page)
	gf_mask_show(true)
end

function MarketBuy:set_goods(list,page)
	print("设置商品",list,page)
	if page == 1 then
		print("第一页的初始化")
		self:init_filter()
		self.goods_cache = {}
		self.goods_list = {}
		self.goods_count = 0
		self.show_count = 0

		-- 隐藏多余的项
		for i=#list+1,#self.goodsObjs do
			self.goodsObjs[i].obj:SetActive(false)
		end

		-- 设置排序标签
		self.unitPriceArrow.localEulerAngles = Vector3(0,0,self.sort_type==2 and 180 or 0)
		self.totalPriceArrow.localEulerAngles = Vector3(0,0,self.sort_type==4 and 180 or 0)
	end

	if #list>0 then
		local Equip = LuaItemManager:get_item_obejct("equip")
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		for i,v in ipairs(list) do
			self.goods_cache[#self.goods_cache+1] = v
			local goods = v.item or v.equip
			if goods and not self.goods_list[goods.guid] then
				-- gf_print_table(goods)
				self.goods_list[goods.guid] = v
				self.goods_count = self.goods_count + 1
				if not self.goodsObjs[self.goods_count] then
					local obj = LuaHelper.Instantiate(self.goodsItem)
					local item = obj.transform
					item:SetParent(self.goodsRoot,false)
					self.goodsObjs[self.goods_count] = {
						obj = obj,
						bg = item:Find("bg"):GetComponent(UnityEngine_UI_Image),
						icon = item:Find("icon"):GetComponent(UnityEngine_UI_Image),
						count = item:Find("count"):GetComponent("UnityEngine.UI.Text"),
						name = item:Find("name"):GetComponent("UnityEngine.UI.Text"),
						level = item:Find("level"):GetComponent("UnityEngine.UI.Text"),
						unitPrice = item:Find("unitPrice"):GetComponent("UnityEngine.UI.Text"),
						totalPrice = item:Find("totalPrice"):GetComponent("UnityEngine.UI.Text"),
						up = item:Find("up").gameObject,
						down = item:Find("down").gameObject,
						no_use = item:Find("no_use").gameObject,
					}
					item.name = "goodsItem"
				end
				local item = self.goodsObjs[self.goods_count]
				local item_data = ConfigMgr:get_config("item")[goods.protoId]
				local item_name = item_data.name
				if v.item then
					gf_set_item(v.item.protoId,item.icon,item.bg)
					item.count.text = v.item.num
					item.up:SetActive(false)
					item.down:SetActive(false)
					item.no_use:SetActive(false)
				elseif v.equip then
					gf_set_equip_icon(v.equip,item.icon,item.bg)
					item.count.text = nil
					local power = Equip:calculate_equip_fighting_capacity(v.equip)
					local prefix = itemSys:get_equip_prefix_name(v.equip.prefix)
					item_name = string.format("%s%s\n<color=#90281AFF><size=22>装备战力：%d</size></color>",prefix,item_name,power)
					local is_career = item_data.career == LuaItemManager:get_item_obejct("game"):get_career()
					item.no_use:SetActive(not is_career)
					if is_career then
						local my_power = Equip:calculate_equip_fighting_capacity(LuaItemManager:get_item_obejct("bag"):get_bag_item()[ServerEnum.BAG_TYPE.EQUIP*10000+item_data.sub_type])
						item.up:SetActive(power>my_power)
						item.down:SetActive(power<my_power)
					end

				end
				item.name.text = item_name
				item.level.text = item_data.item_level
				item.guid = goods.guid
				item.unitPrice.text = string.format("%0.1f",v.price/(goods.num or 1))
				item.totalPrice.text = v.price
				print("显示物品",v.price,item_name)

				if self:is_filter(v) then
					self.show_count = self.show_count + 1
					item.obj:SetActive(true)
				else
					item.obj:SetActive(false)
				end
			end
		end
	end
	if self.show_count < 50 and not self.is_load_all_goods then
		print("~~~~~~~~~~~~~~~~~~~~显示数量不足50，还有货，继续获取")
		self:get_market_item_info_list(self.sort_type,self.load_page+1)
	elseif self.show_count>0 then
		print("~~~~~~~~~~~~~~~~~~~~显示数量大于0，显示货物")
		self.qi_e:SetActive(false)
		self.buy_type:SetActive(false)
		self.buy_item:SetActive(true)
		self.searchBg:SetActive(false)
	else
		print("~~~~~~~~~~~~~~~~~~~~没有货，设置历史搜索记录")
			self:set_search_keys()
	end
	if page == 1 then
		self.goodsScrollView.verticalNormalizedPosition = 1
	end
end

-- 选择商品
function MarketBuy:select_goods(idx)
	local goods = self.goods_list[self.goodsObjs[idx].guid]
	local itemSys = LuaItemManager:get_item_obejct("itemSys")

	local item = goods.item or goods.equip
	local buy_fun = function()
		self.item_obj:buy_market_item_c2s(item.guid,item.protoId)
	end
	itemSys:add_tips_btn("购买",buy_fun)

	if goods.item then
		itemSys:common_show_item_info(item.protoId)
	elseif goods.equip then
		itemSys:equip_browse(item)
	end
end

function MarketBuy:on_click(obj,arg)
	print("点击了市场 MarketBuy:on_click ",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if arg == self.goodsScrollView then -- 滑动
		if self.goodsScrollView.verticalNormalizedPosition < 0.1 then
			if not self.is_load_all_goods and self.loading_page==self.load_page then
				self:get_market_item_info_list(self.sort_type,self.load_page+1)
			end
			if self.goodsScrollView.verticalNormalizedPosition < 0 then
				self.goodsScrollView.verticalNormalizedPosition = 0
			end
		end
	elseif cmd == "bigTypeItem" then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
		print("-- 选择大类")
		self.searchGoods.text = nil
		local idx = obj.transform:GetSiblingIndex()
		self:select_big_type(idx)
	elseif cmd == "smallTypeItem" then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换3级页签音效
		print("-- 选择小类")
		self.searchGoods.text = nil
		local idx = obj.transform:GetSiblingIndex()
		self:select_small_type(idx)
	elseif cmd == "goodsItem" then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换3级页签音效
		print("-- 选择商品")
		local idx = obj.transform:GetSiblingIndex()
		self:select_goods(idx)
	elseif cmd == "searchBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("-- 搜索按钮")
		self:fuzzy_search()
	elseif cmd == "searchItem" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("-- 选择搜索关键词")
		self.searchGoods.text = arg.text
		self:fuzzy_search()
	elseif cmd == "unitPriceSort" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("-- 单价排序")
		if self.search_str then
			if #self.goods_cache>0 and last_search_time+search_interval_time>Net:get_server_time_s() then
				print("自行排序")
				local list = self.goods_cache
				self.sort_type = self.sort_type==2 and 3 or 2
				self:sort_goods(list)
				self:set_goods(list,1)
			else
				print("请求服务器更新数据",#self.goods_cache,last_search_time+search_interval_time,Net:get_server_time_s(),last_search_time+search_interval_time-Net:get_server_time_s())
				self.sort_type = self.sort_type==2 and 3 or 2
				self:fuzzy_search()
			end
		else
			self:get_market_item_info_list(self.sort_type==2 and 3 or 2,1)
		end
	elseif cmd == "totalPriceSort" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print("-- 总价排序")
		if self.search_str then
			if #self.goods_cache>0 and last_search_time+search_interval_time>Net:get_server_time_s() then
				print("自行排序")
				local list = self.goods_cache
				self.sort_type = self.sort_type==4 and 5 or 4
				self:sort_goods(list)
				self:set_goods(list,1)
			else
				print("请求服务器更新数据",#self.goods_cache,last_search_time+search_interval_time,Net:get_server_time_s(),last_search_time+search_interval_time-Net:get_server_time_s())
				self.sort_type = self.sort_type==4 and 5 or 4
				self:fuzzy_search()
			end
		else
			self:get_market_item_info_list(self.sort_type==4 and 5 or 4,1)
		end
	elseif arg == self.selectEquip then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print(" -- 筛选等级",self.selectEquip.value,self.level_filter_list[self.selectEquip.value])
		self.level_filter_sel = self.selectEquip.value
		self:set_filter()
	elseif arg == self.selectQuality then -- 筛选品质
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		print(" -- 筛选品质",self.selectQuality.value, self.color_filter_list[self.selectQuality.value])
		self.color_filter_sel = self.selectQuality.value
		self:set_filter()
	end
end

--服务器返回
function MarketBuy:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("shop") then
		if id2== Net:get_id2("shop", "BuyMarketItemR") then-- 购买市场上的物品
			if msg.err == 1006 then
				-- 元宝不足
			elseif msg.err == 8640 then
				-- 背包不够
			else
				for i,v in ipairs(self.goodsObjs) do
					if v.guid==msg.guid then
						v.obj:SetActive(false)
						break
					end
				end
				self.not_exist_guid[msg.guid] = msg.guid
			end
		elseif id2== Net:get_id2("shop", "GetMarketItemInfoListR") then-- 获取市场上的挂售商品
			if msg.err==0 then
				self.not_exist_guid = {}
				if msg.sort==0 then -- 排序
					self:sort_goods(msg.list)
				else
					self.sort_type = msg.sort
				end
				self.load_page = msg.page or 1
				self.is_load_all_goods = msg.finalPage == 1
				self:set_goods(msg.list,self.load_page)
			end
			gf_mask_show(false)
		elseif id2== Net:get_id2("shop", "GetMarketTypeCountsR") then-- 获取哪个大类的在售数
			if msg.err==0 then
				self:set_market_type_counts(msg.sub_types,msg.counts,msg.type)
			end
		elseif id2== Net:get_id2("shop", "SearchMarketR") then-- 搜索
			if msg.err==0 then
				self.not_exist_guid = {}
				self:sort_goods(msg.list)
				self.load_page = 1
				self.is_load_all_goods = true
				self:set_goods(msg.list,1)
			end
			gf_mask_show(false)
		end
	elseif id1==Net:get_id1("base") then
		if id2 == Net:get_id2("base", "UpdateResR") then
			self:set_gold_count()
		end
	end
end

-- 对商品进行排序
function MarketBuy:sort_goods(list)
	if self.sort_type==1 then
		table.sort(list,function(a,b) return a.timestamp>b.timestamp end)
	elseif self.sort_type==4 then
		table.sort(list,function(a,b) return a.price<b.price end)
	elseif self.sort_type==5 then
		table.sort(list,function(a,b) return a.price>b.price end)
	elseif self.sort_type==2 then
		table.sort(list,function(a,b)
			_a = a.item or a.equip
			_b = b.item or b.equip
			return (a.price/(_a.num or 1)) < (b.price/(_b.num or 1)) end)
	elseif self.sort_type==3 then
		table.sort(list,function(a,b)
			_a = a.item or a.equip
			_b = b.item or b.equip
			return (a.price/(_a.num or 1)) > (b.price/(_b.num or 1)) end)
	end
end

-- 设置元宝数量
function MarketBuy:set_gold_count()
	self.goldCountTxt.text = LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.GOLD)
end

-- 初始化筛选
function MarketBuy:init_filter()
	-- 设置筛选项
	if not self.small_type_sel or self.small_type_sel==0 then
		local data = ConfigMgr:get_config("market_exist_all")[self.big_type_sel]
		self.color_filter_list = data and data.color_filter or {}
		self.level_filter_list = data and data.level_filter or {}
	else
		local data = ConfigMgr:get_config("market_type")[MarketTools:get_classification()[self.big_type_sel][self.small_type_sel].unit_type]
		self.color_filter_list = data and data.color_filter or {}
		self.level_filter_list = data and data.level_filter or {}
	end

	if #self.level_filter_list>0 then
		local options = self.selectEquip.options
		options:Clear()
		options:Add(Dropdown.OptionData("筛选等级")) -- 小类名字
		for i,v in ipairs(self.level_filter_list) do
			options:Add(Dropdown.OptionData("等级:"..v)) -- 小类名字
		end
		self.selectEquip.value = 0
		self.level_filter_sel = 0
		self.selectEquipText.text = "筛选等级"
		self.selectEquip.gameObject:SetActive(true)
	else
		self.selectEquip.gameObject:SetActive(false)
	end

	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	if #self.color_filter_list>0 then
		local options = self.selectQuality.options
		options:Clear()
		options:Add(Dropdown.OptionData("筛选品质")) -- 小类名字
		for i,v in ipairs(self.color_filter_list) do
			options:Add(Dropdown.OptionData(itemSys:give_color_for_string("品质:"..itemSys:get_color_name(v),v))) -- 小类名字
		end
		self.selectQuality.value = 0
		self.color_filter_sel = 0
		self.selectLevelText.text = "筛选品质"
		self.selectQuality.gameObject:SetActive(true)
	else
		self.selectQuality.gameObject:SetActive(false)
	end
end

-- 筛选
function MarketBuy:set_filter()
	self.show_count = 0
	for i,v in ipairs(self.goodsObjs) do
		local goods = self.goods_list[v.guid]
		if goods then
			if self:is_filter(goods) then
				self.show_count = self.show_count + 1
				v.obj:SetActive(true)
			else
				v.obj:SetActive(false)
			end
		end
	end
	if self.show_count < 50 and not self.is_load_all_goods then
		self:get_market_item_info_list(self.sort_type,self.load_page+1)
	end
	self.goodsScrollView.verticalNormalizedPosition = 1
end

-- 判断是否被筛选
function MarketBuy:is_filter(goods)
	local goods_item = goods.item or goods.equip
	local item_data = ConfigMgr:get_config("item")[goods_item.protoId]
	if self.level_filter_list[self.level_filter_sel] and self.level_filter_list[self.level_filter_sel]~=item_data.item_level then
		-- print("筛选等级 隐藏",item_data.name,"物品等级",item_data.item_level)
		return false
	elseif self.color_filter_list[self.color_filter_sel] and self.color_filter_list[self.color_filter_sel]~=(goods_item.color or item_data.color) then
		-- print("筛选等级 隐藏",item_data.name,"物品品质",goods_item.color or item_data.color)
		return false
	elseif self.not_exist_guid[goods_item.guid] then
		-- 物品不存在 被买了
		return false
	else
		-- print("--------------------筛选通过 显示",item_data.name,"物品等级",item_data.item_level,"物品品质",goods_item.color or item_data.color)
		return true
	end
end

function MarketBuy:on_showed()
	StateManager:register_view( self )
	if self.init then
		self:init_ui()
	end
end

function MarketBuy:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function MarketBuy:dispose()
	self:hide()
    self._base.dispose(self)
 end

-- 模糊搜索
 function MarketBuy:fuzzy_search()
 	self.search_str = (string.gsub(self.searchGoods.text, "^%s*(.-)%s*$", "%1")) -- 去前后空格
 	if not self.search_str or self.search_str=="" then
 		self.search_str = nil
 		self:set_search_keys()
 		return
 	else
 		self:save_new_key(self.search_str)
 	end

	if last_search_time+search_interval_time>Net:get_server_time_s() then
		gf_message_tips("操作过于频繁")
		return
	else
		last_search_time = Net:get_server_time_s()
	end

	local big_type = self.small_type_sel and self.small_type_sel>0 and 0 or self.big_type_sel
	local unit_type = big_type==0 and MarketTools:get_classification()[self.big_type_sel][self.small_type_sel].unit_type or 0

 	local list = MarketTools:get_keys(self.search_str,self.big_type_sel,self.small_type_sel)

 	local send = {}
 	local only_prefixs = {}
 	local only_protoIds = {}
 	local prefix_list = {} -- ConfigMgr:get_config("equip_prefix")
 	local protoId_list = {}
 	for i,v in ipairs(list) do
		local search_item = self.search_key[v.key]
		if search_item then
			if not search_item.protoId then
				only_prefixs[search_item.prefix] = search_item.prefix
			elseif not search_item.prefix then
				only_protoIds[search_item.protoId] = search_item.protoId
			else
				prefix_list[search_item.prefix] = search_item.prefix
				protoId_list[search_item.protoId] = search_item.protoId
			end
		end
 	end
 	local protoIds = {}
 	local prefixs = {}
 	-- print("只物品名的")
 	for k,v in pairs(only_protoIds) do -- 先拿只搜物品名的
 		-- print("物品id",k,v,ConfigMgr:get_config("item")[v].name)
 		protoIds[#protoIds+1] = v
 	end
 	-- print("只搜前缀的")
 	if #protoIds==0 then -- 没有只搜物品名，才要拿只搜前缀名
	 	for k,v in pairs(only_prefixs) do
	 		-- print("前缀",k,v)
	 		prefixs[#prefixs+1] = v
	 	end
	 end
	 if #prefixs==0 and #protoIds==0 then
 		-- print("物品名+前缀")
	 	for k,v in pairs(prefix_list) do
	 		-- print("前缀",k,v)
	 		prefixs[#prefixs+1] = v
	 	end
	 	for k,v in pairs(protoId_list) do -- 先拿只搜物品名的
	 		-- print("物品id",k,v,ConfigMgr:get_config("item")[v].name)
	 		protoIds[#protoIds+1] = v
	 	end
	 end
	 if #protoIds==0 and #prefixs==0 then
 		self:set_search_keys()
	 else
		self.item_obj:search_market_c2s(big_type,unit_type,protoIds,prefixs)
		gf_mask_show(true)
	end
 end

 -- 设置最近搜索关键词
 function MarketBuy:set_search_keys()
 	if #self.search_keys>0 then
		self.qi_e:SetActive(false)
		self.buy_type:SetActive(false)
		self.buy_item:SetActive(false)
		self.searchBg:SetActive(true)

		for i,v in ipairs(self.search_keys) do
			if not self.searchObjs[i] then
				local obj = LuaHelper.Instantiate(self.searchImg)
				local item = obj.transform
				item:SetParent(self.searchContent,false)
				self.searchObjs[i] = {
					obj = obj,
					name = item:Find("searchItem"):GetComponent("UnityEngine.UI.Text"),
				}
				item.name = "searchImg"
			end
			local item = self.searchObjs[i]
			item.name.text = v
			item.obj:SetActive(true)
		end

		-- 设置提示语
		local tips = nil
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local have_small_type = self.small_type_sel~=0 and self.small_type_sel~=nil
		print("是否有选择小类",have_small_type,self.big_type_sel , self.small_type_sel)
		local unit_type = MarketTools:get_classification()[self.big_type_sel][have_small_type and self.small_type_sel or 1].unit_type
		print("unit_type 类别id ",unit_type)
		local data = ConfigMgr:get_config("market_type")[unit_type]
		local color = "#90281A"
		if self.search_str and self.search_str~="" then -- 暂时没有关于"xxx"的商品供卖买，换个词搜搜看吧！
			tips = string.format("暂时没有关于<color=%s>“%s”</color>的商品供卖买，换个词搜搜看吧！",color,self.search_str)
		elseif self.big_type_sel and self.small_type_sel then -- 暂时没有"xxx"的商品供卖买，去其他类别看看吧！
			tips = string.format("<color=%s>“%s”</color>暂时没有商品供卖买，去其他类别看看吧！",color,have_small_type and data.sub_type_name or data.type_name)
		else -- 历史搜索 --
			tips = nil
		end
		self.no_search.text = tips

 	else
		self.qi_e:SetActive(true)
		self.buy_type:SetActive(false)
		self.buy_item:SetActive(false)
		self.searchBg:SetActive(false)
 	end

 end

 -- 添加一个最新搜索关键词
 function MarketBuy:save_new_key(key)
 	for i,v in ipairs(self.search_keys) do
 		if v==key then
 			table.remove(self.search_keys,i)
 			break
 		end
 	end
 	table.insert(self.search_keys,1,key)
 	if #self.search_keys>kess_max_count then
 		table.remove(self.search_keys,#self.search_keys)
 	end
 	self.item_obj:save_search_keys(self.search_keys)
 end

return MarketBuy

