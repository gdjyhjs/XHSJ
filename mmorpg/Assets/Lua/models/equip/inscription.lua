--[[--
--	--	铭刻 就是洗炼
-- @Author:HuangJunShan
-- @DateTime:2017-07-29 16:58:43

每个部位装备对应一个整数 来保存锁定/保底紫属性勾选
第1位 是否勾选保底紫属性
2-5位 分别对应是否锁定1-4条属性
key = ROLEID_equip_washes_lock_SUBTYPE
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local EquipUserData = require("models.equip.equipUserData")
local fill_max_width = 193
local washes_check_key = "washes_check_"..LuaItemManager:get_item_obejct("game"):getId()
local percentage_list = {}

local Inscription=class(UIBase,function(self,item_obj,ui)
    UIBase._ctor(self, "washes.u3d", item_obj) -- 资源名字全部是小写
    self.ui = ui
    self.item_obj = item_obj
    self.curPage = page or 1
end)

-- 资源加载完成
function Inscription:on_asset_load(key,asset)
	print("洗炼加载完毕")
	self.cure_lock_attr = 0
	self.equip_list = {}
	self.cur_sel_index = nil
	self.sel_index = 1
	self:init_ui()
	self:set_left_list()
	self:sel_equip()
	self.init = true
end

-- 初始化ui
function Inscription:init_ui()
	self.one_btn = self.refer:Get("one_btn") -- 左侧装备项的根
	self.two_btn = self.refer:Get("two_btn") -- 左侧装备项的根

	self.washes_item_ico = self.refer:Get("washes_item_ico") -- 洗炼物品图标
	self.washes_item_bg = self.refer:Get("washes_item_bg") -- 洗炼物品品质

	self.left_scroll_item = self.refer:Get("left_scroll_item") -- 左滑动
	self.washesItemRoot = self.refer:Get("washesItemRoot") -- 洗炼装备项根
	self.before_score = self.refer:Get("before_score") -- 左得分
	self.after_score = self.refer:Get("after_score") -- 右得分
	self.power_up = self.refer:Get("power_up")
	self.power_down = self.refer:Get("power_down")
	local beforeRoot = self.refer:Get("beforeRoot") -- 左洗炼根
	self.before_attr = {}
	for i=1,beforeRoot.childCount-1 do
		local item = beforeRoot:GetChild(i)
		local attr = item:Find("attr")
		local color = item:Find("color")
		local lock = item:Find("lock")
		self.before_attr[i] = {
			lock = lock.gameObject,
			lock_mark = lock:Find("mark").gameObject,
			attr = attr.gameObject,
			fill = attr:Find("fill"),
			name = 	attr:Find("name"):GetComponent("UnityEngine.UI.Text"),
			value = attr:Find("value"):GetComponent("UnityEngine.UI.Text"),
			color = color.gameObject,
			color_text = color:Find("color_text"):GetComponent("UnityEngine.UI.Text"),
		}
	end
	local afterRoot = self.refer:Get("afterRoot") -- 右洗炼根
	self.after_attr = {}
	for i=1,afterRoot.childCount-1 do
		local item = afterRoot:GetChild(i)
		local attr = item:Find("attr")
		local color = item:Find("color")
		self.after_attr[i] = {
			attr = attr.gameObject,
			fill = attr:Find("fill"),
			name = 	attr:Find("name"):GetComponent("UnityEngine.UI.Text"),
			value = attr:Find("value"):GetComponent("UnityEngine.UI.Text"),
			color = color.gameObject,
			color_text = color:Find("color_text"):GetComponent("UnityEngine.UI.Text"),
			up = item:Find("up").gameObject,
			down = item:Find("down").gameObject,
		}
	end

	local material = self.refer:Get("material") -- 洗炼材料
	self.material_icon = material:Find("icon"):GetComponent(UnityEngine_UI_Image)
	self.material_bg = material:GetComponent(UnityEngine_UI_Image)
	self.material_count = material:Find("count"):GetComponent("UnityEngine.UI.Text")
	local money = self.refer:Get("money") -- 洗炼花费
	self.money_icon = money:Find("icon"):GetComponent(UnityEngine_UI_Image)
	self.money_bg = money:GetComponent(UnityEngine_UI_Image)
	self.money_count = money:Find("count"):GetComponent("UnityEngine.UI.Text")
	
	self.gold_mark = self.refer:Get("gold_mark") -- 使用元宝提升保底属性
	self.goldCost = self.refer:Get("goldCost") -- 使用元宝花费消耗提示

	self.washesEff = self.refer:Get("washesEff") -- 使用元宝花费消耗提示
end

function Inscription:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
		if id2 == Net:get_id2("bag", "PolishEquipR") then	--洗炼装备
			print(err,msg.equipType,self.equip_list[self.cur_sel_index].sub_type)
			if msg.err==0 and msg.equipType==self.equip_list[self.cur_sel_index].sub_type then
				self:update_left_sel_equip()
				self.washesEff:SetActive(false)
				self.washesEff:SetActive(true)
			end
			gf_mask_show(false)
		elseif id2 == Net:get_id2("bag", "GetPolishAttrR") then	--获取洗炼属性
			if msg.err==0 and msg.equipType==self.equip_list[self.cur_sel_index].sub_type then
				self:update_left_sel_equip()
			end
		elseif id2 == Net:get_id2("bag", "SavePolishR") then	--保存洗炼
			if msg.err==0 and msg.equipType==self.equip_list[self.cur_sel_index].sub_type then
				self:update_left_sel_equip()
				self.washesEff:SetActive(false)
				self.washesEff:SetActive(true)
			end
			gf_mask_show(false)
		end
	end
end

function Inscription:on_click(obj,arg)
	print("on_click(equipView-Inscription)",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or "" 
	if cmd=="washesBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local obj = self.equip_list[self.cur_sel_index]
		if obj.equip then
			local washes_fn = function(_,check)
				if check then
					UnityEngine.PlayerPrefs.SetInt(washes_check_key,tonumber(os.date("%Y%m%d")))
				end
				local equipType = obj.sub_type
				local lock = {}
				if bit._and(self.cure_lock_attr,2)==2 then
					lock[#lock+1] = 1
				end
				if bit._and(self.cure_lock_attr,4)==4 then
					lock[#lock+1] = 2
				end
				if bit._and(self.cure_lock_attr,8)==8 then
					lock[#lock+1] = 3
				end
				if bit._and(self.cure_lock_attr,16)==16 then
					lock[#lock+1] = 4
				end
				local purple = bit._and(self.cure_lock_attr,1)==1 and 1 or 0
				self.item_obj:polish_equip_c2s(equipType,lock,purple) --洗炼
				gf_mask_show(true)
			end
			if self.body_power_score<self.new_power_score and UnityEngine.PlayerPrefs.GetInt(washes_check_key,0)~=tonumber(os.date("%Y%m%d")) then
				local content = gf_localize_string("已洗出较好的属性，确定继续洗炼？")
				LuaItemManager:get_item_obejct("cCMP"):toggle_message(content,false,"今日不再提示",washes_fn)
			elseif (function() 
				-- gf_print_table(percentage_list,"洗炼列表")
					for i,v in ipairs(percentage_list) do 
						local pos = bit._rshift(0x80000000,31-i)
						print("第几条属性",i,"区间",percentage_list[i],"位置pos",pos,"锁住的属性",self.cure_lock_attr)
						if bit._and(self.cure_lock_attr,pos)~=pos and v==1 then
							return true
						end
					end
				end)() then
				local content = gf_localize_string("您洗出了百年难得一遇的满属性噢，确定继续洗炼？")
				LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,washes_fn)
			else
				washes_fn()
			end
		else
			print("需穿戴装备")
		end
	elseif cmd == "btnHelp" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1162)
	elseif cmd=="washesItem" then -- 装备项
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.sel_index = obj.transform:GetSiblingIndex()+1
		self:sel_equip()
	elseif cmd=="replaceBtn" then -- 替换洗炼
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local item = self.equip_list[self.cur_sel_index]
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if item.equip then
			self.item_obj:save_polish_c2s(item.sub_type)
			gf_mask_show(true)
		else
			print("需穿戴装备")
		end
	elseif cmd=="gold" then -- 勾选必出紫
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local is_check = bit._and(self.cure_lock_attr,1)==1
		local item = self.equip_list[self.cur_sel_index]
		local sub_type = item.sub_type
		if is_check then
			self.cure_lock_attr = self.cure_lock_attr - 1
		else
			self.cure_lock_attr = self.cure_lock_attr + 1
		end
		local key = string.format("%s_equip_washes_lock_%d",LuaItemManager:get_item_obejct("game"):getId(),sub_type)
		UnityEngine.PlayerPrefs.SetInt(key,self.cure_lock_attr)
		print("保存数据",key,self.cure_lock_attr)
		self:set_equip()

	elseif cmd=="lock" then -- 勾选锁定属性
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local item = self.equip_list[self.cur_sel_index]
		if item.equip then
			local lock_attr_count = (bit._and(self.cure_lock_attr,2)==2 and 1 or 0)
				+ (bit._and(self.cure_lock_attr,4)==4 and 1 or 0)
				+ (bit._and(self.cure_lock_attr,8)==8 and 1 or 0)
				+ (bit._and(self.cure_lock_attr,16)==16 and 1 or 0)
			local t_misc = ConfigMgr:get_config("t_misc")
			if t_misc.polish_count[item.equip.color] < lock_attr_count then
				self.cure_lock_attr = bit._and(self.cure_lock_attr,1)
			end

			local sub_type = item.sub_type
			local index = obj.transform.parent:GetSiblingIndex()
			local pos = bit._rshift(0x80000000,31-index)
			if bit._and(self.cure_lock_attr,pos)==pos then
				self.cure_lock_attr = self.cure_lock_attr - pos
			else
				self.cure_lock_attr = self.cure_lock_attr + pos
			end
			local key = string.format("%s_equip_washes_lock_%d",LuaItemManager:get_item_obejct("game"):getId(),sub_type)
			UnityEngine.PlayerPrefs.SetInt(key,self.cure_lock_attr)
			print("保存数据",key,self.cure_lock_attr)
			self:set_equip()

		end
	end
end

-- 设置右侧属性栏
function Inscription:update_right_polish()
	percentage_list = {}
	-- 属性(右)
	local obj = self.equip_list[self.cur_sel_index]
	local sub_type = obj.sub_type
	local equip = obj.equip
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	if equip then
		local t_misc = ConfigMgr:get_config("t_misc")
		local item_data = ConfigMgr:get_config("item")[equip.protoId]
		local polish_attr_cache = self.item_obj:get_polish_attr_cache(sub_type) -- 洗炼属性
		local polish_attr = self.item_obj:get_polish_attr(sub_type) -- 洗炼属性
		local attr_max_count = t_misc.polish_count[equip.color] or 0 -- 最大属性条数
		self.new_power_score = 0
		for i,v in ipairs(self.after_attr) do
			local item = v
			if attr_max_count<i then -- 不显示
				item.fill.gameObject:SetActive(false)
				item.name.gameObject:SetActive(false)
				item.value.gameObject:SetActive(false)
				item.color:SetActive(true)
				item.color_text.text = itemSys:get_color_name(i+2).."装备解锁"
				item.up:SetActive(false)
				item.down:SetActive(false)
			else -- 显示属性
				-- item.attr:SetActive(true)
				item.fill.gameObject:SetActive(true)
				item.name.gameObject:SetActive(true)
				item.value.gameObject:SetActive(true)
				item.color:SetActive(false)
				local attrs = polish_attr_cache[i] or {}
				local compare_attrs = polish_attr[i] or {}
				if attrs.attr and attrs.value then
					local attr_interval = EquipUserData:get_polish_attr_interval(item_data.level,sub_type,attrs.attr)
					local percentage = (attrs.value - attr_interval[1])/(attr_interval[2] - attr_interval[1])
					percentage = percentage>1 and 1 or percentage
					percentage_list[i] = percentage
					item.fill.sizeDelta = Vector2(fill_max_width*percentage,item.fill.sizeDelta.y) -- 属性进度条
					local attr_name = itemSys:get_combat_attr_name(attrs.attr)..(ConfigMgr:get_config("propertyname")[attrs.attr]==1 and "加成" or "") -- 属性名
					local attr_value = attrs.value>attr_interval[2] and attr_interval[2] or attrs.value -- 属性数值
					local color_id = (function() 
											for i,v in ipairs(t_misc.polish_color_range) do
												if percentage*10000<=v then
													print(i,v,"区间",percentage)
													return i
												end
											end
										 end)()
					item.name.text = itemSys:give_color_for_string(attr_name,color_id)
					item.value.text = itemSys:give_color_for_string(itemSys:get_combat_attr_value(attrs.attr,attr_value,""),color_id)


					local power_up = false
					local power_down = false
					local washes_attr_power = itemSys:get_combat_attr_fcr(attrs.attr)*attrs.value
					self.new_power_score = self.new_power_score + washes_attr_power
					if compare_attrs.attr or compare_attrs.value then
						local body_attr_power = itemSys:get_combat_attr_fcr(compare_attrs.attr)*compare_attrs.value
						if washes_attr_power > body_attr_power then
							power_up = true
							power_down = false
						elseif washes_attr_power < body_attr_power then
							power_up = false
							power_down = true
						end
					end
					item.up:SetActive(power_up)
					item.down:SetActive(power_down)
				else
					item.fill.sizeDelta = Vector2(0,item.fill.sizeDelta.y) -- 属性进度条
					item.name.text = nil -- 属性名
					item.value.text = nil -- 属性数值
					item.up:SetActive(false)
					item.down:SetActive(false)
				end
			end
		end
		self.after_score.text = math.floor(self.new_power_score)
		-- 总评分对比
		if self.body_power_score > self.new_power_score then
			self.power_up:SetActive(false)
			self.power_down:SetActive(true)
		elseif self.body_power_score < self.new_power_score then
			self.power_up:SetActive(true)
			self.power_down:SetActive(false)
		else
			self.power_up:SetActive(false)
			self.power_down:SetActive(false)
		end
		
		self.one_btn:SetActive(#polish_attr_cache==0)
		self.two_btn:SetActive(#polish_attr_cache>0)

	else
	end

end

--更新左边选择的装备
function Inscription:update_left_sel_equip()
	local bag = LuaItemManager:get_item_obejct("bag")
	local obj = self.equip_list[self.cur_sel_index]
	local item = obj.item
	local equip = obj.equip
	if equip then
		local ref = item:GetComponent("ReferGameObjects")
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local itemInfo = ConfigMgr:get_config("item")[equip.protoId]
		gf_set_equip_icon(equip,icon,ref:Get("bg"))
			ref:Get("name").text = self.item_obj:get_equip_name(equip)
			ref:Get("lv").text = string.format("%d级%s",itemInfo.level,EquipUserData:get_equip_type_name(obj.sub_type))
	end
	self:set_equip()
end

--设置打造左边列表
function Inscription:set_left_list()
	self.equip_list = {}
	print("设置左侧列表")
	local bag = LuaItemManager:get_item_obejct("bag")
	local allChild = LuaHelper.GetAllChild(self.washesItemRoot)
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local list = {}
	for i=1,#allChild do
		local slot = ServerEnum.BAG_TYPE.EQUIP*10000+i
		local equip = bag:get_bag_item()[slot]
		local enhanceItem = allChild[i].gameObject
		local ref  = enhanceItem:GetComponent("ReferGameObjects")
		local sel = ref:Get("sel")
		if equip then -- 有装备
			local itemInfo = ConfigMgr:get_config("item")[equip.protoId]
			local icon = ref:Get("icon")
			icon.gameObject:SetActive(true)
			gf_set_equip_icon(equip,icon,ref:Get("bg"))
			local name = ref:Get("name")
			name.gameObject:SetActive(true)
			name.text = self.item_obj:get_equip_name(equip)
			ref:Get("lv").text = string.format("%d级%s",itemInfo.level,EquipUserData:get_equip_type_name(i))
			local obj = {
				item = enhanceItem,
				ref = ref,
				sel = sel,
				slot = slot,
				sub_type = i,
				equip = equip,
			}
			self.equip_list[#self.equip_list+1] = obj
			if self.item_obj.open_page2 == i then
				self.sel_index = #self.equip_list
			end
		else
			local icon = ref:Get("icon")
			icon.gameObject:SetActive(false)
			gf_set_item(nil,nil,ref:Get("bg"),0)
			local name = ref:Get("name")
			name.gameObject:SetActive(false)
			ref:Get("lv").text = string.format("%s\n%s",EquipUserData:get_equip_type_name(i),gf_localize_string("未装备")) 	--文字
			enhanceItem.transform:SetAsLastSibling()
			local obj = {
				item = enhanceItem,
				ref = ref,
				sel = sel,
				slot = slot,
				sub_type = i,
			}
			list[#list+1] = obj
		end
		sel:SetActive(false)
	end
	for i,v in ipairs(list) do
		self.equip_list[#self.equip_list+1] = v
	end
	self.item_obj.open_page2 = nil
end

--选择装备
function Inscription:sel_equip()
	if self.cur_sel_index then
		local obj = self.equip_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(false)
		end
	end
	self.cur_sel_index = self.sel_index
	if self.cur_sel_index then
		local obj = self.equip_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(true)
		end
		local key = string.format("%s_equip_washes_lock_%d",LuaItemManager:get_item_obejct("game"):getId(),obj.sub_type)
		self.cure_lock_attr = UnityEngine.PlayerPrefs.GetInt(key,0)
		print("读取数据",key,self.cure_lock_attr)
	end
	self:set_equip()
end

-- 设置洗炼的装备
function Inscription:set_equip()
	local obj = self.equip_list[self.cur_sel_index]
	local sub_type = obj.sub_type
	local equip = obj.equip
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	if equip then
		local bag = LuaItemManager:get_item_obejct("bag")
		local t_misc = ConfigMgr:get_config("t_misc")
		local item_data = ConfigMgr:get_config("item")[equip.protoId]
		local enhanceId = self.item_obj:get_enhance_id(sub_type)
		local real_enhance_data = ConfigMgr:get_config("equip_enhance")[enhanceId]
		local left_level = real_enhance_data.level - ConfigMgr:get_config("equip_formula_accumulate")[item_data.level].max_level
		local is_max_level = left_level>=0
		local enhance_data = left_level<=0 and real_enhance_data or ConfigMgr:get_config("equip_enhance")[enhanceId-left_level] 
		local next_enhance_data = ConfigMgr:get_config("equip_enhance")[enhance_data.next_id]
		-- 物品图标-- 物品品质
		self.washes_item_ico.gameObject:SetActive(true)
		gf_set_equip_icon(equip,self.washes_item_ico,self.washes_item_bg)
		
		-- 设置属性(左)
		local polish_attr = self.item_obj:get_polish_attr(sub_type) -- 洗炼属性
		local attr_max_count = t_misc.polish_count[equip.color] or 0 -- 最大属性条数
		local lock_attr_count = (bit._and(self.cure_lock_attr,2)==2 and 1 or 0)
				+ (bit._and(self.cure_lock_attr,4)==4 and 1 or 0)
				+ (bit._and(self.cure_lock_attr,8)==8 and 1 or 0)
				+ (bit._and(self.cure_lock_attr,16)==16 and 1 or 0)

		if lock_attr_count > attr_max_count - 1 then
			self.cure_lock_attr = bit._and(self.cure_lock_attr,1)
			lock_attr_count = 0
		end
		self.body_power_score = 0
		for i,v in ipairs(self.before_attr) do
			local item = v
			if attr_max_count<i then
				print(" -- 不显示")
				item.lock:SetActive(false)
				-- item.attr:SetActive(false)
				item.fill.gameObject:SetActive(false)
				item.name.gameObject:SetActive(false)
				item.value.gameObject:SetActive(false)
				item.color:SetActive(true)
				item.color_text.text = itemSys:get_color_name(i+2).."装备解锁"
			else
				print(" -- 显示属性")
				-- item.attr:SetActive(true)
				item.fill.gameObject:SetActive(true)
				item.name.gameObject:SetActive(true)
				item.value.gameObject:SetActive(true)
				item.color:SetActive(false)
				local pos = bit._rshift(0x80000000,31-i)
				print("pos",pos)
				local is_lock = (bit._and(self.cure_lock_attr,pos)==pos)
				print(i,"判断第几位",pos,"是否锁定",is_lock)
				item.lock_mark:SetActive(is_lock)
				local attrs = polish_attr[i] or {}

				if attrs.attr and attrs.value then
					if lock_attr_count == attr_max_count - 1 and not is_lock then
						item.lock:SetActive(false)
					else
						item.lock:SetActive(true)
					end
					local attr_interval = EquipUserData:get_polish_attr_interval(item_data.level,sub_type,attrs.attr)
					local percentage = (attrs.value - attr_interval[1])/(attr_interval[2] - attr_interval[1])
					percentage = percentage>1 and 1 or percentage
					item.fill.sizeDelta = Vector2(fill_max_width*percentage,item.fill.sizeDelta.y) -- 属性进度条
					local attr_name = itemSys:get_combat_attr_name(attrs.attr)..(ConfigMgr:get_config("propertyname")[attrs.attr]==1  and "加成" or "") -- 属性名
					local attr_value = attrs.value>attr_interval[2] and attr_interval[2] or attrs.value -- 属性数值
					local color_id = (function() 
											for i,v in ipairs(t_misc.polish_color_range) do
												if percentage*10000<=v then
													return i
												end
											end
										 end)()
					item.name.text = itemSys:give_color_for_string(attr_name,color_id)
					item.value.text = itemSys:give_color_for_string(itemSys:get_combat_attr_value(attrs.attr,attr_value,""),color_id)
					self.body_power_score = self.body_power_score + itemSys:get_combat_attr_fcr(attrs.attr)*attrs.value
				else
					item.lock:SetActive(false)
					item.fill.sizeDelta = Vector2(0,item.fill.sizeDelta.y) -- 属性进度条
					item.name.text = nil -- 属性名
					item.value.text = nil -- 属性数值
				end
			end
		end
		self.before_score.text = math.floor(self.body_power_score)
		self:update_right_polish()
		print("已锁定的属性条数",lock_attr_count)
		-- 消耗材料
		self.material_icon.gameObject:SetActive(true)
		gf_set_item(t_misc.polish_equip_lock_need_item,self.material_icon,self.material_bg)
		local count = bag:get_item_count(t_misc.polish_equip_lock_need_item,ServerEnum.BAG_TYPE.NORMAL) or 0
		local need_count = t_misc.polish_equip_lock_need_item_count[lock_attr_count]
		self.material_count.text = string.format("<color=%s>%d</color>/%d",
			count>=need_count and "#50FC4A" or "#d01212",count,need_count)
		gf_set_click_prop_tips(self.material_icon,t_misc.polish_equip_lock_need_item)
		-- 消耗铜币数量
		self.money_icon.gameObject:SetActive(true)
		gf_set_money_ico(self.money_icon,ServerEnum.BASE_RES.COIN,self.money_bg)
		self.money_count.text = t_misc.polish_equip_need_coin

		-- 勾选必出紫和消耗元宝数量
		self.gold_mark:SetActive(bit._and(self.cure_lock_attr,1)==1)
		local need_gold = t_misc.polish_equip_purple_need_gold[lock_attr_count]
		self.goldCost.text = string.format(
			"消耗<color=#C61AE5FF>%d</color>元宝必出1条<color=#C61AE5FF>紫色</color>以上属性",
			need_gold>0 and need_gold or 0)
	else
		self.washes_item_ico.gameObject:SetActive(false)
		gf_set_item(nil,nil,self.washes_item_bg,0)
		self.money_icon.gameObject:SetActive(false)
		gf_set_item(nil,nil,self.money_bg,0)
		self.material_icon.gameObject:SetActive(false)
		gf_set_item(nil,nil,self.material_bg,0)
		self.before_score.text = 0
		self.after_score.text = 0
		self.material_count.text = nil
		self.money_count.text = nil
		self.goldCost.text = string.format(
			"消耗元宝必出1条<color=#C61AE5FF>紫色</color>以上属性")
		self.gold_mark:SetActive(bit._and(self.cure_lock_attr,1)==1)

		for i,v in ipairs(self.before_attr) do
			local item = v
			item.lock:SetActive(false)
			item.fill.gameObject:SetActive(false)
			item.name.gameObject:SetActive(false)
			item.value.gameObject:SetActive(false)
			item.color:SetActive(true)
			item.color_text.text = itemSys:get_color_name(i+2).."装备解锁"
		end
		for i,v in ipairs(self.after_attr) do
			local item = v
			item.fill.gameObject:SetActive(false)
			item.name.gameObject:SetActive(false)
			item.value.gameObject:SetActive(false)
			item.color:SetActive(true)
			item.color_text.text = itemSys:get_color_name(i+2).."装备解锁"
			item.up:SetActive(false)
			item.down:SetActive(false)
		end
		-- 按钮
		self.one_btn:SetActive(false)
		self.two_btn:SetActive(false)
	end
end

function Inscription:on_showed()
	StateManager:register_view( self )
	if self.init then
		self.sel_index = 1
		self:set_left_list()
		self:sel_equip()
	end
end

function Inscription:on_hided()
	StateManager:remove_register_view( self )
	if self.init then
		self.washesEff:SetActive(false)
	end
end

-- 释放资源
function Inscription:dispose()
	self.cur_sel_index = nil
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return Inscription