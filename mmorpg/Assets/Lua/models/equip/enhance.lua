--[[--
--
-- @Author:HuangJunShan gf_set_item get_equip_prefix_name
-- @DateTime:2017-07-29 17:00:23
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local EquipUserData = require("models.equip.equipUserData")

local auto_enhance_time = 0.5 -- 自动强化间隔时间
local exp_add_speed = 0.15 -- 经验增加插值速度
local min_exp_change = 0.01 -- 经验增加最小值
local left_count = 5

local Enhance=class(UIBase,function(self,item_obj,ui)
    UIBase._ctor(self, "enhance.u3d", item_obj) -- 资源名字全部是小写
    self.ui = ui
    self.item_obj = item_obj
    self.curPage = page or 1
    print("强化界面")
end)

-- 资源加载完成
function Enhance:on_asset_load(key,asset)
    print("强化界面加载完成")
	self.last_enhance_id = nil -- 上一次
	self.cur_enhance_exp_target = 0
	self.equip_list = {}
	self.cur_sel_index = nil
	self.sel_index = 1
	self.init = true
	self:init_ui()
	self:set_left_list()
	self:sel_equip()

end

-- 初始化ui
function Enhance:init_ui()
	self.qianghua_item_ico = self.refer:Get("qianghua_item_ico") -- 强化物品图标
	self.qianghua_item_bg = self.refer:Get("qianghua_item_bg") -- 强化物品品质
	self.item_name = self.refer:Get("item_name") -- 强化物品名称
	self.expLine = self.refer:Get("expLine") -- 强化经验条
	self.left_content = self.refer:Get("left_content") -- 左侧属性内容（当前属性）
	self.right_content = self.refer:Get("right_content") -- 右侧属性内容（下一级属性）
	self.cailiaoCost = self.refer:Get("cailiaoCost") -- 消耗文本
	self.cailiaoBg = self.refer:Get("cailiaoBg") -- 消耗品质
	self.cailiaoLock = self.refer:Get("cailiaoLock") -- 消耗锁
	self.qianghuaBtn = self.refer:Get("qianghuaBtn") -- 强化按钮
	self.cailiaoIcon = self.refer:Get("cailiaoIcon") -- 消耗图标
	self.FullLevel = self.refer:Get("FullLevel") -- 已满级
	self.expValue = self.refer:Get("expValue") -- 强化经验数值
	self.left_scroll_item = self.refer:Get("left_scroll_item") -- 左侧滑动
	self.qianghuaEff = self.refer:Get("qianghuaEff") -- 强化特效
	self.enhanceItemRoot = self.refer:Get("enhanceItemRoot") -- 左侧装备项的根
	self.left_title = self.refer:Get("left_title") -- 左侧属性标题
	self.right_title = self.refer:Get("right_title") -- 右侧属性标题
	self.haveMoney = self.refer:Get("haveMoney") -- 左侧属性标题
	self.haveMoneyIcon = self.refer:Get("haveMoneyIcon") -- 右侧属性标题
	self.autoQianghuaTxt = self.refer:Get("autoQianghuaTxt") -- 自动强化按钮文本
	self.autoQianghuaBtn = self.refer:Get("autoQianghuaBtn") -- 自动强化按钮
	self.addValueTxt = self.refer:Get("addValueTxt") -- 增加数值
	self.baojiAddValueTxt = self.refer:Get("baojiAddValueTxt") -- 暴击
end

function Enhance:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("bag"))then
		if(id2== Net:get_id2("bag", "EnhanceEquipR"))then --强化装备
			if msg.err == 0 then
				self.qianghuaEff:SetActive(false)
				self.qianghuaEff:SetActive(true)
				self:update_left_sel_equip()
			elseif self.auto_enhance_timer then
				self.auto_enhance_timer:stop()
				self.auto_enhance_timer = nil
				self.autoQianghuaTxt.text = "自动强化"
				self.autoQianghuaBtn.name = "autoQianghuaBtn"
			end
			gf_mask_show(false)
		end
	elseif(id1==Net:get_id1("base"))then
        if(id2== Net:get_id2("base", "UpdateResR"))then
            self:update_money()
        end
	elseif id1 == ClientProto.UIRedPoint then -- 红点
        if msg.module == ClientEnum.MODULE_TYPE.EQUIP then
            self:update_red_point()
        end
	end
end

function Enhance:update_money()
	if not self.init then
		return
	end
	local have_money = LuaItemManager:get_item_obejct("game"):get_money(self.cost_money_type) or 0
	local need_money_str = self.need_money>have_money and string.format("<color=#CE3636>%d</color>",self.need_money) or self.need_money
	self.cailiaoCost.text = need_money_str
	self.haveMoney.text = gf_format_count(have_money)
end

function Enhance:on_click(obj,arg)
	print("on_click(equipView-Enhance)",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if self.auto_enhance_timer then
		self.auto_enhance_timer:stop()
		self.auto_enhance_timer = nil
		self.autoQianghuaTxt.text = "自动强化"
		self.autoQianghuaBtn.name = "autoQianghuaBtn"
	end

	if cmd=="qianghuaBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local obj = self.equip_list[self.cur_sel_index]
		if obj.equip then
			self.item_obj:enhance_equip_c2s(obj.sub_type) --强化
			gf_mask_show(true)
		end
	elseif cmd=="enhanceItem" then -- 装备项
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.sel_index = obj.transform:GetSiblingIndex()+1
		self:sel_equip()
	elseif cmd == "addMoney" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_open_model(ConfigMgr:get_config("base_res")[ServerEnum.BASE_RES.COIN].get_way)
	elseif cmd=="enhanceTips" then -- 强化tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1161)
	elseif cmd=="autoQianghuaBtn" then -- 自动强化
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local obj = self.equip_list[self.cur_sel_index]
		-- gf_print_table(obj,self.cur_sel_index)
		if obj.equip and not self.auto_enhance_timer then
			local auto_enhance_fn = function()
				self.item_obj:enhance_equip_c2s(obj.sub_type) --强化
			end
			self.autoQianghuaTxt.text = "停止强化"
			self.autoQianghuaBtn.name = nil
			self.auto_enhance_timer = Schedule(auto_enhance_fn,auto_enhance_time)
		end
	elseif cmd=="qianghua_item_bg" then -- 装备tips
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local data = self.equip_list[self.cur_sel_index]
		local equip = data.equip
		if equip then
			LuaItemManager:get_item_obejct("itemSys"):equip_browse(equip,self.item_obj:get_enhance_id(data.sub_type),self.item_obj:get_gem_info()[data.sub_type],self.item_obj:get_polish_attr(data.sub_type),obj.transform.position)
		end
	end

end

--更新左边选择的装备
function Enhance:update_left_sel_equip()
	local bag = LuaItemManager:get_item_obejct("bag")
	local obj = self.equip_list[self.cur_sel_index]
	local item = obj.item
	local equip = obj.equip
	if equip then
		local ref = item:GetComponent("ReferGameObjects")
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local itemInfo = ConfigMgr:get_config("item")[equip.protoId]
		-- gf_set_item(equip.protoId,icon,ref:Get("bg"),equip.color)
		gf_set_equip_icon(equip,icon,ref:Get("bg"))
		ref:Get("name").text = self.item_obj:get_equip_name(equip)
		local data = ConfigMgr:get_config("item")[equip.protoId]
		local enhance_id = self.item_obj:get_enhance_id(obj.sub_type)
		local real_enhance_data = ConfigMgr:get_config("equip_enhance")[enhance_id]
		local max_level = ConfigMgr:get_config("equip_formula_accumulate")[data.level].max_level
		local left_level = real_enhance_data.level - max_level
		ref:Get("lv").text = string.format("%s<color=%s>+%d%s</color>",gf_localize_string("强化"),gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),
			left_level>=0 and max_level or real_enhance_data.level,left_level>=0 and "(max)" or "")
		ref:Get("power").text = string.format("%s %d",gf_localize_string("评分："),self.item_obj:calculate_equip_fighting_capacity(equip))
	end
	self:set_equip()
end

--设置打造左边列表
function Enhance:set_left_list()
	self.equip_list = {}
	print("设置左侧列表")
	local bag = LuaItemManager:get_item_obejct("bag")
	local allChild = LuaHelper.GetAllChild(self.enhanceItemRoot)
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local list = {}
	for i=1,#allChild  do
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
			ref:Get("name").text = self.item_obj:get_equip_name(equip)
			local data = ConfigMgr:get_config("item")[equip.protoId]
			local enhance_id = self.item_obj:get_enhance_id(i)
			local real_enhance_data = ConfigMgr:get_config("equip_enhance")[enhance_id]
			local max_level = ConfigMgr:get_config("equip_formula_accumulate")[data.level].max_level
			local left_level = real_enhance_data.level - max_level
			ref:Get("lv").text = string.format("%s<color=%s>+%d%s</color>",gf_localize_string("强化"),gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),
				left_level>=0 and max_level or real_enhance_data.level,left_level>=0 and "(max)" or "")
			ref:Get("power").text = string.format("%s %d",gf_localize_string("评分："),self.item_obj:calculate_equip_fighting_capacity(equip))
			local red_point = ref:Get("red_point")
			local obj = {
				item = enhanceItem,
				ref = ref,
				sel = sel,
				slot = slot,
				sub_type = i,
				equip = equip,
				red_point = red_point,
			}
			self.equip_list[#self.equip_list+1] = obj
			if self.item_obj.open_page2 == i then
				self.sel_index = #self.equip_list
			end
		else
			local icon = ref:Get("icon")
			icon.gameObject:SetActive(false)
			gf_set_item(nil,nil,ref:Get("bg"),0)
			ref:Get("name").text = EquipUserData:get_equip_type_name(i)
			ref:Get("lv").text = gf_localize_string("未装备")
			ref:Get("power").text = nil
			enhanceItem.transform:SetAsLastSibling()
			local red_point = ref:Get("red_point")
			local obj = {
				item = enhanceItem,
				ref = ref,
				sel = sel,
				slot = slot,
				sub_type = i,
				red_point = red_point,
			}
			list[#list+1] = obj
		end
		sel:SetActive(false)
	end
	for i,v in ipairs(list) do
		self.equip_list[#self.equip_list+1] = v
	end
	local pos = self.sel_index > left_count and (1 - (self.sel_index-left_count)/(#allChild-left_count)) or 1
	self.left_scroll_item.verticalNormalizedPosition = pos
	self:update_red_point()
	self.item_obj.open_page2 = nil
end

--选择装备
function Enhance:sel_equip()
	if self.cur_sel_index then
		local obj = self.equip_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(false)
		end
	end
	print("选择页签",self.sel_index)
	self.cur_sel_index = self.sel_index
	self.last_enhance_id = nil
	if self.cur_sel_index then
		local obj = self.equip_list[self.cur_sel_index]
		if obj then
			obj.sel:SetActive(true)
		end
	end
	self:set_equip()
end

-- 设置强化的装备
function Enhance:set_equip()
	local obj = self.equip_list[self.cur_sel_index]
	local equip = obj.equip
	if equip then
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local item_data = ConfigMgr:get_config("item")[equip.protoId]
		local enhanceId = self.item_obj:get_enhance_id(item_data.sub_type)
		local real_enhance_data = ConfigMgr:get_config("equip_enhance")[enhanceId]
		local left_level = real_enhance_data.level - ConfigMgr:get_config("equip_formula_accumulate")[item_data.level].max_level
		local is_max_level = left_level>=0
		local enhance_data = left_level<=0 and real_enhance_data or ConfigMgr:get_config("equip_enhance")[enhanceId-left_level] 
		local next_enhance_data = ConfigMgr:get_config("equip_enhance")[enhance_data.next_id]
		-- 物品图标-- 物品品质
		self.qianghua_item_ico.gameObject:SetActive(true)
		-- gf_set_item(equip.protoId,self.qianghua_item_ico,self.qianghua_item_bg,equip.color)
		gf_set_equip_icon(equip,self.qianghua_item_ico,self.qianghua_item_bg)
		-- 物品名称
		self.item_name.text = self.item_obj:get_equip_name(equip)
		-- 经验条	-- 经验数值
		local max_exp = is_max_level and 0 or enhance_data.levelup_exp
		local cur_exp = is_max_level and 0 or self.item_obj:get_enhance_exp(item_data.sub_type)
		self:enhance_exp_to(enhance_data.enhance_id,cur_exp,is_max_level)
		self.expValue.text = string.format("%s/%d",is_max_level and "超出"..self.item_obj:get_enhance_exp(item_data.sub_type) or cur_exp,max_exp)
		-- 左属性
		self.left_title.text = string.format("%s<color=%s>+%d</color>",gf_localize_string("强化"),gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),enhance_data.level)
		local attr = ""
		for i,v in ipairs(equip.baseAttr or {}) do
			if i>1 then
				attr = attr.."\n"
			end
			local enhance_attr = ConfigMgr:get_config("equip_enhance")[enhance_data.enhance_id].add_attr[i]
			attr = attr..itemSys:get_combat_attr_name(v.attr).."："..v.value+(enhance_attr and enhance_attr[2] or 0)
		end
		self.left_content.text = attr
		-- 右属性
		if is_max_level then
			self.right_title.text = self.left_title.text
			self.right_content.text = self.left_content.text
		else
			self.right_title.text = string.format("%s<color=%s>+%d</color>",gf_localize_string("强化"),gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),next_enhance_data.level)
			local attr = ""
			for i,v in ipairs(equip.baseAttr or {}) do
				if i>1 then
					attr = attr.."\n"
				end
				local enhance_attr = ConfigMgr:get_config("equip_enhance")[enhance_data.enhance_id].add_attr[i]
				local next_enhance_attr = next_enhance_data.attr[i]
				local next_enhance_value = next_enhance_attr and next_enhance_attr[2] or 0
				local next_add_attr_str = (next_enhance_value>0 and string.format("<color=%s>+%d</color>",gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),next_enhance_value) or "")
				attr = attr..itemSys:get_combat_attr_name(v.attr).."："..v.value+(enhance_attr and enhance_attr[2] or 0)..next_add_attr_str
			end
			self.right_content.text = attr
		end
		-- 消耗图标
		self.cost_money_type = enhance_data.need_money[1]
		self.cailiaoIcon.gameObject:SetActive(true)
		gf_set_money_ico(self.cailiaoIcon,self.cost_money_type,self.cailiaoBg,true)
		gf_set_money_ico(self.haveMoneyIcon,self.cost_money_type)
		-- 消耗数值
		local need_money = enhance_data.need_money[2] or 0
		local have_money = LuaItemManager:get_item_obejct("game"):get_money(self.cost_money_type) or 0
		local need_money_str = need_money>have_money and string.format("<color=#CE3636>%d</color>",need_money) or need_money
		self.need_money = need_money
		self.cailiaoCost.text = need_money_str
		self.haveMoney.text = gf_format_count(have_money)
	else
		self.qianghua_item_ico.gameObject:SetActive(false)
		gf_set_item(nil,nil,self.qianghua_item_bg,0)
		self.item_name.text = EquipUserData:get_equip_type_name(obj.sub_type)
		self.expLine.fillAmount = 0
		self.expValue.text = ""
		self.left_title.text = ""
		self.left_content.text = ""
		self.right_title.text = ""
		self.right_content.text = ""
		self.cailiaoCost.text = ""
		self.cailiaoIcon.gameObject:SetActive(false)
	end
end

-- 将强化的经验变化至xxx
-- function Enhance:enhance_exp_to(exp,lv,enhance_id)
function Enhance:enhance_exp_to(enhance_id,cur_exp,is_max_level)
	print("丫丫丫-----","当前强化",enhance_id,"当前经验",cur_exp,"上一次经验进度",self.last_exp,"上一次强化id",self.last_enhance_id)
	local cur_data = ConfigMgr:get_config("equip_enhance")[enhance_id]
	local add_value = 0
	local one_add_exp = 0
	self.exp_fill = is_max_level and 1 or cur_exp/cur_data.levelup_exp
	print("目标经验进度",self.exp_fill)
	local last_data = nil
	local last_exp_fill = nil
	if self.last_enhance_id then
		last_data = ConfigMgr:get_config("equip_enhance")[self.last_enhance_id]
		last_exp_fill = self.last_exp/last_data.levelup_exp
	end
	if not self.last_enhance_id then
		self.cur_enhance_exp_target = self.exp_fill
		self.expLine.fillAmount = self.exp_fill

		self.last_enhance_id = enhance_id
		self.last_exp = cur_exp
		return
	elseif last_data.level<cur_data.level then
		self.cur_enhance_exp_target = math.floor(self.cur_enhance_exp_target) + self.exp_fill
		local up_lv = cur_data.level - last_data.level
		print("丫丫丫~~~升级了 升了几级：",up_lv)
		add_value = cur_exp
		local data = nil
		for i=1,up_lv do
			self.cur_enhance_exp_target = self.cur_enhance_exp_target + 1
			data = ConfigMgr:get_config("equip_enhance")[enhance_id-1]
			if data then
				add_value = add_value + data.levelup_exp
			end
		end
		add_value = add_value - self.last_exp
		one_add_exp = data.exp
	else
		print("丫丫丫~~~没有升级")
		add_value = (cur_exp-self.last_exp)
		one_add_exp = cur_data.exp
		self.cur_enhance_exp_target = math.floor(self.cur_enhance_exp_target) + self.exp_fill
	end
	local is_baoji = add_value>(one_add_exp*1.1)
	if self.add_value_text then
		self.add_value_text.gameObject:SetActive(false)
	end
	self.add_value_text = is_baoji and self.baojiAddValueTxt or self.addValueTxt
	self.add_value_text:GetComponent("UnityEngine.UI.Text").text = string.format("%s+%d",is_baoji and "暴击" or "",add_value)
	self.add_value_text.gameObject:SetActive(true)
	self.add_value_text:ResetToBeginning()
	self.add_value_text:Play()
	local change_fn = function()
		local cur = self.expLine.fillAmount
		cur = cur + (self.cur_enhance_exp_target - cur) * exp_add_speed
		print("现在是多少",cur,"此次加了多少",(self.cur_enhance_exp_target - cur) * exp_add_speed,"目标是加到多少",self.cur_enhance_exp_target,"丫丫丫")
		if cur>1 then
			cur = cur - 1
			self.cur_enhance_exp_target = self.cur_enhance_exp_target - 1
		end
		

		if self.cur_enhance_exp_target - cur < min_exp_change then
			print("!!!!~~~~设置最终进度",self.exp_fill)
			self.expLine.fillAmount = self.exp_fill
			self:exit_exp_timer()
		else
			print("!!!!~~~~设置当前进度",cur)
			self.expLine.fillAmount = cur
		end
	end

	if not self.enhance_exp_to_timer then
		self.enhance_exp_to_timer = Schedule(change_fn,0.02)
	end

	self.last_enhance_id = enhance_id
	self.last_exp = cur_exp
end

-- 关闭定时器
function Enhance:exit_exp_timer()
	if self.enhance_exp_to_timer then
		self.enhance_exp_to_timer:stop()
		self.enhance_exp_to_timer = nil
		self.add_value_text.gameObject:SetActive(false)
	end
end

function Enhance:on_showed()
	StateManager:register_view( self )
	if self.init then
		self.sel_index = 1
		self:set_left_list()
		self:sel_equip()
	end
end

function Enhance:on_hided()
	StateManager:remove_register_view( self )
	if self.init then
		self.qianghuaEff:SetActive(false)
	end
	if self.auto_enhance_timer then
		self.auto_enhance_timer:stop()
		self.auto_enhance_timer = nil
		self.autoQianghuaTxt.text = "自动强化"
		self.autoQianghuaBtn.name = "autoQianghuaBtn"
	end
	self:exit_exp_timer()
	self.cur_sel_index = nil
end

-- 释放资源
function Enhance:dispose()
	self:hide()
    self._base.dispose(self)
end

function Enhance:update_red_point()
	if not self.init then return end
    for i,obj in ipairs(self.equip_list or {}) do
        local show = (function()
                    for k,v in pairs(self.item_obj.red_pos) do
                        if v and tonumber(string.sub(k,1,1)) == 1 and tonumber(string.sub(k,2,2)) == obj.sub_type then
                            return true
                        end
                    end
                end)()
        obj.red_point:SetActive(show or false)
    end
end

return Enhance