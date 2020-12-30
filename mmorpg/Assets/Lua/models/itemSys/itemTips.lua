--[[--
-- self.item_obj
-- @Author:Seven
-- @DateTime:2017-08-23 09:43:13
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local UIModel = require("common.UI3dModel")
local EquipUserData = require("models.equip.equipUserData")

local game = LuaItemManager:get_item_obejct("game")
local itemSys = LuaItemManager:get_item_obejct("itemSys")
local bag = LuaItemManager:get_item_obejct("bag")
local equip = LuaItemManager:get_item_obejct("equip")
local ItemTips=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "item_tips.u3d", item_obj) -- 资源名字全部是小写
end)

local model_height,model_attribute_height = 366,249

-- 资源加载完成
function ItemTips:on_asset_load(key,asset)
	-- print("资源加载完成")
	self.itemCache = {}
	self.active_obj = {}
	self.init = true
	self:show()
end

function ItemTips:init_show()
	self.refer:Get("canvasGroup").alpha = 0
	if self.item_obj_tips_pos then
		self.tips_pos = self.item_obj_tips_pos
		-- print("有传入位置",self.tips_pos)
	elseif not Seven.PublicFun.IsNull(LuaHelper.eventSystemCurrentSelectedGameObject) then
		self.tips_pos = LuaHelper.eventSystemCurrentSelectedGameObject.transform.position
	else
		self.tips_pos = nil
		-- local g = UnityEngine.EventSystem.current.currentSelectedGameObject
		-- self.tips_pos = g.transform.position
		-- print("没有传入位置",self.tips_pos)
	end
	-- print("显示物品tips",self.item_obj_tips_protoId)
	local data = ConfigMgr:get_config( "item" )[self.item_obj_tips_protoId]
	self:set_model(data)

	self.mode = self.item_obj_tips_mode
	if self.mode == 1 then
		self:set_prop_tips(data)
	elseif self.mode == 2 then
		self:set_role_equip_tips(data)
	elseif self.mode == 3 then
		self:set_hero_equip_tips(data)
	elseif self.mode == 4 then
		self:set_skill_tips()
	end
	-- print("显示方式",self.mode)
end

--设置模型 1
function ItemTips:set_model(data)
	-- 判断是否需要显示模型
	self.show_mode = false
	if data and data.type == ServerEnum.ITEM_TYPE.PROP then
		if data.sub_type == ServerEnum.PROP_TYPE.SURFACE_CLOTHES then -- 时装
			self.show_mode = true
			self.ui_model = UIModel(self.refer:Get("model_obj"))
			self.ui_model:set_player(true) -- 设置是玩家模型
			self.ui_model:set_career() -- 设置职业
			self.ui_model:set_local_position(Vector3(0,-1.5,3)) -- 设置位置
			self.ui_model:set_model(ConfigMgr:get_config("surface")[data.effect[1]].model) -- 设置模型id
			self.ui_model:set_weapon()
			self.ui_model:set_wing()
			self.ui_model:set_surround()
			self.ui_model:load_model() -- 加载模型
			-- print("ItemTips:set_model(data)加载模型",ConfigMgr:get_config("surface")[data.effect[1]].model)
		elseif data.sub_type == ServerEnum.PROP_TYPE.SURFACE_WEAPON then -- 武饰
			self.show_mode = true
			self.ui_model = UIModel(self.refer:Get("model_obj"))
			self.ui_model:set_player(true) -- 设置是玩家模型
			self.ui_model:set_career() -- 设置职业
			self.ui_model:set_local_position(Vector3(0,-1.5,3)) -- 设置位置
			self.ui_model:set_model() -- 设置模型id
			self.ui_model:set_weapon(ConfigMgr:get_config("surface")[data.effect[1]].model) -- 设置武器
			self.ui_model:set_wing()
			self.ui_model:set_surround()
			self.ui_model:load_model() -- 加载模型
			-- print("ItemTips:set_model(data)加载武器",ConfigMgr:get_config("surface")[data.effect[1]].model)
		elseif data.sub_type == ServerEnum.PROP_TYPE.SURFACE_CARRY_ON_BACK then -- 背饰
			self.show_mode = true
			self.ui_model = UIModel(self.refer:Get("model_obj"))
			self.ui_model:set_player(true) -- 设置是玩家模型
			self.ui_model:set_career() -- 设置职业
			self.ui_model:set_local_position(Vector3(0,-1.5,3)) -- 设置位置
			self.ui_model:set_model() -- 设置模型id
			self.ui_model:set_weapon()
			self.ui_model:set_wing(ConfigMgr:get_config("surface")[data.effect[1]].model) -- 设置背饰
			self.ui_model:set_surround()
			self.ui_model:load_model() -- 加载模型
			-- print("ItemTips:set_model(data)加载翅膀",ConfigMgr:get_config("surface")[data.effect[1]].model)
		elseif data.sub_type == ServerEnum.PROP_TYPE.SURFACE_SURROUND then -- 气息
			self.show_mode = true
			self.ui_model = UIModel(self.refer:Get("model_obj"))
			self.ui_model:set_player(true) -- 设置是玩家模型
			self.ui_model:set_career() -- 设置职业
			self.ui_model:set_local_position(Vector3(0,-1.5,3)) -- 设置位置
			self.ui_model:set_model() -- 设置模型id
			self.ui_model:set_weapon()
			self.ui_model:set_wing()
			self.ui_model:set_surround(ConfigMgr:get_config("surface")[data.effect[1]].model) -- 设置气息
			self.ui_model:load_model() -- 加载模型
			-- print("ItemTips:set_model(data)加载气息",ConfigMgr:get_config("surface")[data.effect[1]].model)
		elseif data.sub_type == ServerEnum.PROP_TYPE.HORSE_FROM_ITEM then -- 坐骑模型
			self.show_mode = true

			local horse_id = data.effect[1]
			local scale = ConfigMgr:get_config("horse")[horse_id].item_model_scale or 1
			local angle = -142.3953
			self.ui_model = gf_set_model(horse_id,self.refer:Get("model_obj"),scale,angle)

			local power = 0

			local horse_data = ConfigMgr:get_config("horse")[horse_id]
			attr_list = {{ServerEnum.COMBAT_ATTR.NONE,horse_data.speed}, -- 速度 标记
						{ServerEnum.COMBAT_ATTR.ATTACK,horse_data.attack}, -- 攻击
						{ServerEnum.COMBAT_ATTR.PHY_DEF,horse_data.physical_defense}, -- 物防
						{ServerEnum.COMBAT_ATTR.MAGIC_DEF,horse_data.magic_defense}, -- 法防
						{ServerEnum.COMBAT_ATTR.DODGE,horse_data.dodge}, -- 闪避
						{ServerEnum.COMBAT_ATTR.HP,horse_data.hp}, -- 生命
						}
			for k,v in pairs(attr_list or {}) do
				power = power + self.item_obj:get_combat_attr_fcr(v[1])*v[2]
			end

			self.refer:Get("modelCombatPowerNum").text = power
			self.active_obj[#self.active_obj+1] = self.refer:Get("zhangLiBg")
		end
	end

	-- self.refer:Get("myControl").open = not self.show_mode
	self.refer:Get("model"):SetActive(self.show_mode)
	self.refer:Get("control1").childControlHeight = self.show_mode
	self.refer:Get("control2").verticalFit = self.show_mode and 0 or 2
	if self.show_mode then
		local control = self.refer:Get("control")
		control.sizeDelta = Vector2(control.sizeDelta.x,model_height);
	end
end

function ItemTips:set_role_equip_tips(data,ref) -- self.refer
	local role_equip = self.item_obj_tips_item
	local propId = self.item_obj_tips_protoId
	local polish_info = self.item_obj_polishInfo
	local enhance_id = self.item_obj_enhanceId
	local gem_ids = self.item_obj_gemIds
	local set_mask = self.item_obj_setMask
	gf_print_table(data,"---------显示人物装备:"..tostring(ref).."物品id:"..propId.." guid:"..(role_equip.guid or 0).."--------------------------------")
	-- print("显示人物装备",propId,role_equip and role_equip.guid or nil)
	if not propId then self:hide() return end
	if not data then data = ConfigMgr:get_config( "item" )[propId] end
	local ref = ref or self.refer

	local my_equip = bag:get_bag_item()[ServerEnum.BAG_TYPE.EQUIP*10000+data.sub_type]
	local is_body_equip = my_equip and role_equip.guid==my_equip.guid or false
	my_equip = my_equip and my_equip.num>0 and role_equip.guid~=my_equip.guid and my_equip or nil

	if is_body_equip then
		self.active_obj[#self.active_obj+1] = ref:Get("using")
	end
		print("这件是身上的装备 是否身上的装备",is_body_equip,"身上装备的guid:",my_equip and my_equip.guid)
		
	-- local bg = ref:Get("bg")
	-- self.active_obj[#self.active_obj+1] = bg.gameObject
	-- gf_setImageTexture(bg,"item_color_"..(role_equip.color or "0"))

	local is_max_enhance = false
	if enhance_id then
		print("强化id",enhance_id)
		local real_enhance_data = ConfigMgr:get_config("equip_enhance")[enhance_id]
		local left_level = real_enhance_data.level - ConfigMgr:get_config("equip_formula_accumulate")[data.level].max_level
		is_max_enhance = left_level>=0
		enhance_id = left_level<=0 and enhance_id or (enhance_id-left_level)
	end

	-- 战力信息  （底部信息）
	if role_equip then
		-- 等级
		local isNeedLv = game:getLevel()>=data.level
		local s = gf_localize_string("<color=%s>使用等级：%s</color>")
		local lv = string.format(s,isNeedLv and gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD) or gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN),data.level)
		-- 职业
		local isCareer = data.career==0 or game:getRoleInfo()==data.career
		local s = gf_localize_string("<color=%s>职业：%s</color>")
		local career = string.format(s,isCareer and gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN) or gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),self.item_obj:get_career_name(data.career))

		-- 前缀
		local prefix = ""
		if role_equip.prefix and role_equip.prefix~=0 then
			local prefix_data = ConfigMgr:get_config("equip_prefix")[role_equip.prefix]
			local name = self.item_obj:get_equip_prefix_name(role_equip.prefix)
			prefix = string.format("\n%s:%s",prefix_data.prefix_name,prefix_data.desc) 
		end
		-- 职业：战士		使用等级：60
		-- 稀世：基础属性+15%
		local str = string.format("%s\t%s%s",career,lv,prefix)
		ref:Get("power").text = str
		self.active_obj[#self.active_obj+1] = ref:Get("powerObj")
	end

	gf_setImageTexture(ref:Get("head"),"img_tips_levels_"..(role_equip and role_equip.color or data.color))
	-- gf_setImageTexture(ref:Get("icon"),data.icon)
	gf_set_equip_icon(role_equip,ref:Get("icon"))

	local name = (role_equip and role_equip.prefix~=0 and self.item_obj:get_equip_prefix_name(role_equip.prefix) or "")..data.name
	if enhance_id then
		local enhance_info = ConfigMgr:get_config("equip_enhance")[enhance_id]
		name = name .. (is_max_enhance and "+MAX" or (enhance_info.level>0 and string.format("+%d",enhance_info.level)) or "")
	end
	ref:Get("name").text =name

	-- 装备评分
	local power,prefixPower,baseAttrPower,extraAttrPower = self.item_obj.equip_sys:calculate_equip_fighting_capacity(role_equip,enhance_id,gem_ids,polish_info)

	local base_power = prefixPower+baseAttrPower+extraAttrPower
	local needLv = ref:Get("needLv")
	local s = gf_localize_string("<color=%s>装备评分\t%s</color>")
	needLv.text = string.format(s,gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),base_power)
	self.active_obj[#self.active_obj+1] = needLv.gameObject

	local binding = ref:Get("binding")
	local s = gf_localize_string("<color=%s>综合评分\t%s</color>")
	binding.text = string.format(s,gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),power)
	self.active_obj[#self.active_obj+1] = binding.gameObject

	if my_equip then
		local my_base_power = self.item_obj.equip_sys:calculate_equip_fighting_capacity(my_equip)
		if base_power>my_base_power then
			self.active_obj[#self.active_obj+1] = ref:Get("power_up")
		end
		if base_power<my_base_power then
			self.active_obj[#self.active_obj+1] = ref:Get("power_down")
		end
	elseif not is_body_equip then
		self.active_obj[#self.active_obj+1] = ref:Get("power_up")
	end


	--  (洗炼属性)
	if role_equip and polish_info and #polish_info>0 then
		gf_print_table(role_equip,"洗炼属性")
		local t_misc = ConfigMgr:get_config("t_misc")
		local attr_max_count = t_misc.polish_count[role_equip.color] or 0 -- 最大属性条数
		local str = "洗炼属性"
		for i=1,attr_max_count do
			local attrs = polish_info[i] or {}
			if attrs.attr and attrs.value then
				local attr_interval = EquipUserData:get_polish_attr_interval(data.level,data.sub_type,attrs.attr) -- 属性区间
				local percentage = (attrs.value - attr_interval[1])/(attr_interval[2] - attr_interval[1]) -- 所在区间百分比
				percentage = percentage>1 and 1 or percentage -- 避免超出最大
				local attr_name = itemSys:get_combat_attr_name(attrs.attr) -- 属性名
				local attr_value = attrs.value>attr_interval[2] and attr_interval[2] or attrs.value -- 属性数值
				local color_id = (function() 
											for i,v in ipairs(t_misc.polish_color_range) do
												if percentage*10000<=v then
													return i
												end
											end
										 end)()
				local attr_str = string.format("\n%s",itemSys:get_combat_attr_name(attrs.attr,attr_value))
				str = str..itemSys:give_color_for_string(attr_str,color_id,true)
			end
		end
		if str~="洗炼属性" then
			local enhanceAttr = ref:Get("enhanceAttr")
			enhanceAttr.text = str
			self.active_obj[#self.active_obj+1] = enhanceAttr.gameObject
		end
	end

	-- 基础属性 attr
	if role_equip and role_equip.baseAttr and #role_equip.baseAttr>0 then
		gf_print_table(role_equip.baseAttr,"基础属性")
		local describe = ref:Get("describe")
		local str = LuaItemManager:get_item_obejct("itemSys"):get_item_desc(data.code)
		local attr = ""
		for i,v in ipairs(role_equip.baseAttr) do
			local enhance_attr_str = ""
			if enhance_id then
				local enhance_attr = ConfigMgr:get_config("equip_enhance")[enhance_id].add_attr[i]
				enhance_attr_str = enhance_attr and enhance_attr[2] and string.format("<color=%s>（强化+%d）</color>",gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),enhance_attr[2]) or ""
			end
			local attr_name = self.item_obj:get_combat_attr_name(v.attr).."："..math.floor(v.value)..enhance_attr_str
			attr=attr.."\n"..attr_name
		end
		describe.text = str.."<color=#25d2d4>"..attr.."</color>"
		self.active_obj[#self.active_obj+1] = describe.gameObject
	end

	-- 星级属性
	if role_equip and role_equip.exAttr and #role_equip.exAttr>0 then
		gf_print_table(role_equip.exAttr,"星级属性")
		local formula_date = ConfigMgr:get_config("equip_formula")[role_equip.formulaId]
		if formula_date then
			local star_data = ConfigMgr:get_config("equip_star")
			local exAttr = ref:Get("exAttr")
			local str = "<color=#1b9e05>星级属性</color>"
			for i,v in ipairs(role_equip.exAttr) do
				local data = star_data[formula_date.star_prob_id[i]] -- 拿到对应的星级库
				local min,max = 0,1
				if data then
					for _,v2 in ipairs(data.prob or {}) do
						if v.attr == v2[2] then
							min,max = v2[3],v2[4]
							break
						end
					end
				end
				local color = self.item_obj:get_start_color((v.value-min)/(max-min)*100,true)
				str=str.."\n"
				local attr_name = self.item_obj:get_combat_attr_name(v.attr,v.value)
				str=str.."<color="..color..">"..attr_name.."</color>"
			end
			exAttr.text = str
			self.active_obj[#self.active_obj+1] = exAttr.gameObject
		else
			gf_error_tips("缺少打造id"..role_equip.formulaId)
		end
	end
	-- 镶嵌信息 img_duanzao_bg_04
	if gem_ids then
		gf_print_table(gem_ids,"镶嵌属性")
		local gemAttr = ref:Get("gemAttr")
		-- local str = "镶嵌\n"
		local all_gem_item = LuaHelper.GetAllChild(gemAttr)
		local attr_count = 0
		for i=1,#all_gem_item do
			local str = equip:get_gem_lock_str(role_equip,i) -- vip等级 到时候获取
			local obj = all_gem_item[i].gameObject
			local r = obj:GetComponent("ReferGameObjects")
			local gemId = gem_ids[i] or 0
			if not str and gemId~=0 then
				obj:SetActive(true)
				local gem_data = ConfigMgr:get_config("item")[gemId]
				local icon = r:Get("gem_icon")
				-- icon.gameObject:SetActive(true)
				gf_setImageTexture(icon,gem_data.icon)
				r:Get("gem_name").text = "<color=#3CD918FF>"..gem_data.name.."</color>"
				local attr = {}
				for i,v in ipairs(gem_data.effect) do
					attr[v[1]] = v[2]
				end
				local str = ""
				local i = 0
				for k,v in pairs(attr) do
					i=i+1
					if not (k==ServerEnum.COMBAT_ATTR.MAGIC_DEF and v == attr[ServerEnum.COMBAT_ATTR.PHY_DEF]) then -- 如果不符合条件无视（已经和双防一起显示了）
						if i>1 then
							str = str.."\t"
						end
						if k==ServerEnum.COMBAT_ATTR.PHY_DEF and v == attr[ServerEnum.COMBAT_ATTR.MAGIC_DEF] then -- 显示双防
							str = string.format("%s%s+%d",str,gf_localize_string("双防"),v)
						else -- 显示单属性
							str = string.format("%s%s+%d",str,itemSys:get_combat_attr_name(k),v)
						end
					end
				end
				local attr_obj = r:Get("gem_attr")
				attr_obj.gameObject:SetActive(true)
				attr_obj.text = str
				attr_count = attr_count + 1
			else
				obj:SetActive(false)
				-- local icon = r:Get("gem_icon")
				-- icon.gameObject:SetActive(false)
				-- -- gf_setImageTexture(icon,"img_duanzao_bg_04")
				-- r:Get("gem_attr").gameObject:SetActive(false)
				-- r:Get("gem_name").text = str or gf_localize_string("未镶嵌")
			end
		end
		if attr_count > 0 then
			self.active_obj[#self.active_obj+1] = gemAttr
		end
	end

	-- 获得途径
	if data.gain then
		local acquireWay = ref:Get("acquireWay")
		acquireWay.text = "<color=#73D675>获得途径</color>\n"..data.gain
		self.active_obj[#self.active_obj+1] = acquireWay.gameObject
	end

	-- 出售物品
	if data.sell and data.sell==1 then
		local iconame = self.item_obj:get_coin_icon(data.sell_unit)
		gf_set_money_ico(ref:Get("sellTypeIco"),data.sell_unit)	--货币图标 sell_unit
		ref:Get("sellPrice").text = data.sell_price	--价格
		self.active_obj[#self.active_obj+1] = ref:Get("sell")
	end

	-- 处理额外添加的内容
	if self.item_obj_item_tips_content then
		if bit._and(self.item_obj_item_tips_content,ClientEnum.ITEM_TIPS_CONTENT.DEPOT_SCORE)==ClientEnum.ITEM_TIPS_CONTENT.DEPOT_SCORE then
			-- 仓库积分
			if not is_body_equip then
				local t_misc = ConfigMgr:get_config("t_misc")
				local t = ref:Get("power")
				local score = data.level * t_misc.alliance.equipLevel2StorePoint -- 等级*10
				if role_equip.prefix and role_equip.prefix>0 then -- 前缀 等级*10+2500
					score = score + data.level * t_misc.alliance.equipPrefix2StorePoint[1] + t_misc.alliance.equipPrefix2StorePoint[2]
				end
				if role_equip.exAttr and #role_equip.exAttr>0 and #role_equip.exAttr<=#t_misc.alliance.equipStar2StorePoint then -- 星 等级*5+500
					score = score + data.level * t_misc.alliance.equipStar2StorePoint[#role_equip.exAttr][1] + t_misc.alliance.equipStar2StorePoint[#role_equip.exAttr][2]
				end
				if role_equip.color then -- 品质系数
					score = score * t_misc.alliance.equipColor2StorePoint[role_equip.color] or 1
				end
				t.text = string.format("仓库积分：%d\n",score)..t.text
			end
		end
	end

	-- 如果不是自己的装备，要加对比自己的装备
	local compare = ref:Get("compare")
	if compare~=ref then
		if my_equip then -- 身上有装备 并且数量大于1 并且不是设置的 需要显示装备对比

			self.active_obj[#self.active_obj+1] = compare.gameObject

			local data = ConfigMgr:get_config("item")[my_equip.protoId]
			self.item_obj_tips_item = my_equip
			self.item_obj_enhanceId = equip:get_enhance_id(data.sub_type)
			self.item_obj_gemIds = equip:get_gem_info()[data.sub_type]
			self.item_obj_setMask = bag:get_set_mask(my_equip)
			self.item_obj_polishInfo = equip:get_polish_attr(data.sub_type)

			self:set_role_equip_tips(data,compare)
		else
			-- 本来就是身上的装备
			self:set_layout()
		end
	else
		-- 是对比完装备了
		self:set_layout({self.refer,compare})
	end

	self.item_obj_tips_item = role_equip
end

function ItemTips:set_hero_equip_tips(data)
	-- print("显示武将装备")
	local hero_equip = self.item_obj_tips_item
	local propId = self.item_obj_tips_protoId
	if not propId then self:hide() return end
	if not data then data = ConfigMgr:get_config( "item" )[propId] end
	local ref = self.refer

	gf_setImageTexture(ref:Get("head"),"img_tips_levels_"..data.color)
	-- gf_setImageTexture(ref:Get("icon"),data.icon)
	gf_set_item(propId,ref:Get("icon"))
	ref:Get("name").text = data.name

	if data.level then
		local needLv = ref:Get("needLv")
		needLv.text = string.format("<color=%s>使用等级：%s</color>",gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),data.level)
		self.active_obj[#self.active_obj+1] = needLv.gameObject
	end
	if data.bind then
		local isBind = data.bind == 1
		local binding = ref:Get("binding")
		binding.text = string.format("<color=%s>%s</color>",isBind and gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN) or gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),isBind and "已绑定" or "未绑定")
		self.active_obj[#self.active_obj+1] = binding.gameObject
	end
	if hero_equip then
		local describe = ref:Get("describe")
		local desc = LuaItemManager:get_item_obejct("itemSys"):get_item_desc(data.code)
		for k,v in pairs(hero_equip.heroEquipAttr or {}) do
			if desc~="" or desc~=nil then desc=desc.."\n" end
			desc=desc..self.item_obj:get_combat_attr_name(v.attr,v.value)
		end
		describe.text = desc
		self.active_obj[#self.active_obj+1] = describe.gameObject
	end
	if data.gain then
		local acquireWay = ref:Get("acquireWay")
		acquireWay.text = "<color=#73D675>获得途径</color>\n"..data.gain
		self.active_obj[#self.active_obj+1] = acquireWay.gameObject
	end
	if data.sell and data.sell==1 then
		local iconame = self.item_obj:get_coin_icon(data.sell_unit)
		gf_set_money_ico(ref:Get("sellTypeIco"),data.sell_unit)	--货币图标 sell_unit
		ref:Get("sellPrice").text = data.sell_price	--价格
		self.active_obj[#self.active_obj+1] = ref:Get("sell")
	end
	self:set_layout()
end

function ItemTips:set_prop_tips(data)
	-- print("显示道具")
	-- local prop = self.item_obj_tips_item
	local propId = self.item_obj_tips_protoId
	if not propId then self:hide() return end
	if not data then data = ConfigMgr:get_config( "item" )[propId] end
	local ref = self.refer

	gf_setImageTexture(ref:Get("head"),"img_tips_levels_"..data.color)
	-- gf_setImageTexture(ref:Get("icon"),data.icon)
	gf_set_item(propId,ref:Get("icon"))
	ref:Get("name").text = data.name
	if self.show_mode then
		local bg = ref:Get("bg")
		self.active_obj[#self.active_obj+1] = bg.gameObject
		gf_setImageTexture(bg,"item_color_"..(data.color or "0"))
	end
	if data.level then
		local isNeedLv = game:getLevel()>=data.level
		local needLv = ref:Get("needLv")
		needLv.text = string.format("<color=%s>使用等级：%s</color>",isNeedLv and gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD) or gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN),data.level)
		self.active_obj[#self.active_obj+1] = needLv.gameObject
	end
	if data.bind then
		local isBind = data.bind == 1
		local binding = ref:Get("binding")
		binding.text = string.format("<color=%s>%s</color>",isBind and gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN) or gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),isBind and "已绑定" or "未绑定")
		self.active_obj[#self.active_obj+1] = binding.gameObject
	end
	if data.desc then
		local describe = ref:Get("describe")
		local str = "<color=#6ED372FF>道具描述</color>\n"..self.item_obj:get_item_desc(data.code)

		-- 额外属性
		local attr_list = nil
		if data.type == ServerEnum.ITEM_TYPE.PROP and 
			(data.sub_type == ServerEnum.PROP_TYPE.SURFACE_CLOTHES -- 外观
			or data.sub_type == ServerEnum.PROP_TYPE.SURFACE_WEAPON  -- 外观
			or data.sub_type == ServerEnum.PROP_TYPE.SURFACE_CARRY_ON_BACK  -- 外观
			or data.sub_type == ServerEnum.PROP_TYPE.SURFACE_SURROUND  -- 外观
			or data.sub_type == ServerEnum.PROP_TYPE.SURFACE_TALK_BG  -- 外观
			or data.sub_type == ServerEnum.PROP_TYPE.SURFACE_TRACE  -- 外观
			--or data.sub_type == ServerEnum.PROP_TYPE.SURFACE_GRADE_UP_ITEM -- 外观 七彩染料 没有属性
			-- or data.sub_type == ServerEnum.PROP_TYPE.HORSE_FROM_ITEM  -- 开出坐骑的道具
			)
			then

			local surface_id = ConfigMgr:get_config("item")[propId].effect[1]
			local surface_data = ConfigMgr:get_config("surface")[surface_id]
			attr_list = surface_data.attr

			-- 气泡展示
			if data.sub_type == ServerEnum.PROP_TYPE.SURFACE_TALK_BG then
				gf_setImageTexture(ref:Get("chat_img"),surface_data.chat_img)
				self.active_obj[#self.active_obj+1] = ref:Get("chat_frame_skin")
				local str = surface_data.chat_text or ""
				if surface_data.font_color then
					str = "<color=#"..surface_data.font_color..">"..str.."</color>"
				end
				ref:Get("chat_text").text = str
				local root = ref:Get("chat_text").transform.parent
				local obj = root:FindChild(surface_data.chat_prefab)
				if root.childCount>1 then
					root:GetChild(1).gameObject:SetActive(false)
				end
				if obj then
					obj.gameObject:SetActive(true)
					obj:SetSiblingIndex(1)
				else
					Loader:get_resource(surface_data.chat_prefab..".u3d",nil,"UnityEngine.GameObject",function(s)
						obj = LuaHelper.InstantiateLocal(s.data)
						obj.transform:SetParent(root,false)
						obj.name = surface_data.chat_prefab
						obj.transform:SetSiblingIndex(1)
					end,function()
						-- print("<color=red>使用气泡外观装饰出错</color> 外观id：",message.surfaceTalkBg,surface_data.chat_prefab)
					end)
				end
			end
		end
		if data.type == ServerEnum.ITEM_TYPE.PROP and 
			data.sub_type == ServerEnum.PROP_TYPE.HORSE_FROM_ITEM  -- 开出坐骑的道具
			then
			local horse_id = ConfigMgr:get_config("item")[propId].effect[1]
			local horse_data = ConfigMgr:get_config("horse")[horse_id]
			attr_list = {{0,horse_data.speed}, -- 速度 标记
						{ServerEnum.COMBAT_ATTR.ATTACK,horse_data.attack}, -- 攻击
						{ServerEnum.COMBAT_ATTR.PHY_DEF,horse_data.physical_defense}, -- 物防
						{ServerEnum.COMBAT_ATTR.MAGIC_DEF,horse_data.magic_defense}, -- 法防
						{ServerEnum.COMBAT_ATTR.DODGE,horse_data.dodge}, -- 闪避
						{ServerEnum.COMBAT_ATTR.HP,horse_data.hp}, -- 生命
						}
		end
		if attr_list and #attr_list>1 then
			local attr = "\n<color=#6ED372FF>基础属性</color>"
			local i = 0
			for k,v in pairs(attr_list or {}) do
				local attr_name = self.item_obj:get_combat_attr_name(v[1],v[2])
				attr = attr..( (i%2==1) and "\t\t\t" or "\n")..attr_name
				i = i + 1
			end
			str = str.."<color=#25d2d4>"..attr.."</color>"
		end

		describe.text = str
		self.active_obj[#self.active_obj+1] = describe.gameObject
	end



	if data.gain then
		local acquireWay = ref:Get("acquireWay")
		acquireWay.text = "<color=#73D675>获得途径</color>\n"..data.gain
		self.active_obj[#self.active_obj+1] = acquireWay.gameObject
	end
	if data.sell and data.sell==1 then
		local iconame = self.item_obj:get_coin_icon(data.sell_unit)
		gf_set_money_ico(ref:Get("sellTypeIco"),data.sell_unit)	--货币图标 sell_unit
		ref:Get("sellPrice").text = data.sell_price	--价格
		self.active_obj[#self.active_obj+1] = ref:Get("sell")
	end
	self:set_layout()
end

function ItemTips:set_skill_tips()
	-- print("显示技能")
	local skillId = self.item_obj_tips_protoId
	if not skillId then self:hide() return end
	local data = ConfigMgr:get_config("skill")[skillId]
	local ref = self.refer

	gf_setImageTexture(ref:Get("head"),"img_tips_levels_"..data.color)
	local icon = ref:Get("icon")
	gf_setImageTexture(icon,data.icon)
	local star = icon.transform:Find("star")
    if star then
        star.gameObject:SetActive(false)
    end
	local debris = icon.transform:Find("debris")
    if debris then
        debris.gameObject:SetActive(false)
    end

	ref:Get("name").text = data.name
	if data.color then
		local needLv = ref:Get("needLv")
		needLv.text = string.format("<color=%s>%s</color>",data.color==1 and "#F34248" or "#D465F9",data.color==1 and "初级技能" or "高级技能")
		self.active_obj[#self.active_obj+1] = needLv.gameObject

		local bg = ref:Get("bg")
		self.active_obj[#self.active_obj+1] = bg.gameObject
		gf_setImageTexture(bg,"item_color_"..(data.color or "0"))
	end
	if data.desc then
		local describe = ref:Get("describe")
		describe.text = data.desc
		self.active_obj[#self.active_obj+1] = describe.gameObject
	end
	self:set_layout()
end

function ItemTips:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	-- print("点击物品tips",obj,arg)
	if cmd == "cancleBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	else
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		for i,v in ipairs(self.btns or {}) do
			if cmd == v.name then
				-- print("执行方法",v.name)
				v.fun()
				self:hide()
			end
		end
	end
end

function ItemTips:get_item(key,obj,root)
    -- print("获取item",key,obj,root)
    if not self.itemCache[key] then self.itemCache[key] = {} end
    local item = self.itemCache[key][1]
    if item then
        table.remove(self.itemCache[key],1)
    else
        item = LuaHelper.Instantiate(obj)
    end
    item:SetActive(true)
    item.transform:SetParent(root.transform,false)
    return item
end

function ItemTips:repay_item(key,item)
    item:SetActive(false)
    item.transform:SetParent(self.root.transform,false)
    if self.itemCache[key] then
    	self.itemCache[key][#self.itemCache[key]+1] = item
    else
    	LuaHelper.Destroy(item)
    end
end

function ItemTips:on_showed()
	print("显示tips")
    if self.init then
    	StateManager:register_view( self )
		self.active_obj = {}
		self:init_show()
    end
	self.item_obj_tips_mode = self.item_obj.tips_mode
	self.item_obj_tips_item = self.item_obj.tips_item
	self.item_obj_tips_protoId = self.item_obj.tips_protoId
	self.item_obj_enhanceId = self.item_obj.enhanceId
	self.item_obj_gemIds = self.item_obj.gemIds
	self.item_obj_setMask = self.item_obj.setMask
	self.item_obj_polishInfo = self.item_obj.polishInfo
	self.item_obj_item_tips_content = self.item_obj.item_tips_content
	self.item_obj_tips_pos = self.item_obj.tips_pos

	if self.ui_model then
		self.ui_model:on_showed()
	end
end

function ItemTips:on_hided()
	print("隐藏tips")
	if self.ui_model then
		-- print("销毁一个模型")
		self.ui_model:dispose()
		self.ui_model = nil
	end	

	self.item_obj.tips_mode = nil
	self.item_obj.tips_item = nil
	self.item_obj.tips_protoId = nil
	self.item_obj.enhanceId = nil
	self.item_obj.gemIds = nil
	self.item_obj.setMask = nil
	self.item_obj.polishInfo = nil
	self.item_obj.item_tips_content = nil
	self.item_obj.tips_pos = nil

	for i,v in ipairs(self.active_obj or {}) do
		v:SetActive(false)
	end
	self.active_obj = {}
	StateManager:remove_register_view( self )
	self.item_obj.item_tips_ui = nil
end

-- 释放资源
function ItemTips:dispose()
	print("销毁tips")
	self:hide()
    self._base.dispose(self)
 end

 function ItemTips:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("bag") then
		if id2== Net:get_id2("bag", "OtherPlayerEquipR") then
			gf_print_table(msg,"服务器获得的玩家装备")
			--获取到其他玩家装备
			if msg.err == 0 then
				self.item_obj_tips_mode = 2
				self.item_obj_tips_item = msg.equip
				self.item_obj_tips_protoId = self.item_obj_tips_item.protoId
				self.item_obj_polishInfo = msg.attrs
				self.item_obj_enhanceId = msg.enhanceId
				self.item_obj_gemIds = msg.gemIds
				self.item_obj_setMask = msg.setMask
			    if self.init then
					self.active_obj = {}
					self:init_show()
			    end
			else
				self:hide()
			end
		end
	end
end

function ItemTips:set_layout(refs)
	local refs = refs or {self.refer}

	-- 激活显示的内容
	for i,v in ipairs(self.active_obj or {}) do
		v:SetActive(true)
	end
	for i,v in ipairs(self.active_obj or {}) do
		UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (v.transform) -- 立即重建布局
	end
	
	for i,ref in ipairs(refs) do
		-- 设置位置和大小
		local view_layout_element = ref:Get("itemInfoView")
		if self.show_mode then
			view_layout_element.minHeight = model_attribute_height
			view_layout_element.preferredHeight = model_attribute_height
		else
			local head_height = ref:Get("head"):GetComponent("UnityEngine.UI.LayoutElement").preferredHeight

			local content_tf = ref:Get("mainInfo")
			local powerObj = ref:Get("powerObj")
			local chat_frame_skin = ref:Get("chat_frame_skin")

			UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (content_tf) -- 立即重建布局

			local content_size_y = content_tf.sizeDelta.y
			local max_height = 720 - head_height
			 - (powerObj.activeSelf and powerObj.transform.sizeDelta.y or 0)
			 - (chat_frame_skin.activeSelf and chat_frame_skin.transform.sizeDelta.y or 0)
			 - 22
			-- print(720,"-", head_height,"-",powerObj.activeSelf and powerObj.transform.sizeDelta.y or 0,"-",chat_frame_skin.activeSelf and chat_frame_skin.transform.sizeDelta.y or 0,"-",40)
			-- print(content_size_y,max_height)
			local height = content_size_y > max_height and max_height or content_size_y
			view_layout_element.minHeight = height
			view_layout_element.preferredHeight = height
			UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (view_layout_element.transform) -- 立即重建布局
			-- print("~~~~~~~**",powerObj.transform.sizeDelta.y)
			UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (powerObj.transform) -- 立即重建布局
			-- print("~~~~~~~**",powerObj.transform.sizeDelta.y)
			UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (ref.transform) -- 立即重建布局
			-- print("~~~~~~~**",powerObj.transform.sizeDelta.y)
		end
	end
	self:set_btn()

	local set_pos_fun = function()
		-- 设置位置 self.tips_pos
		local root = self.root.transform
		local windows_width = root.sizeDelta.x
		local windows_height = root.sizeDelta.y
		-- print("窗口大小",root.sizeDelta)
		local x = self.tips_pos and self.tips_pos.x/root.localScale.x or windows_width/2
		local y = self.tips_pos and self.tips_pos.y/root.localScale.y or windows_height/2
		local control = self.refer:Get("control")
		UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (control) -- 立即重建布局
		local ui_width = control.sizeDelta.x
		local ui_height = control.sizeDelta.y
		-- print("ui大小",control.sizeDelta)
		-- 垂直位置
		local ui_y = 0
		local min_y = ui_height/2
		local max_y = windows_height - ui_height/2
		if y>max_y and y<min_y then
			-- print("高度 ---------- 超最高最低",max_y,min_y,"得0",0)
			ui_y = 0
		elseif y>max_y then
			ui_y = max_y - windows_height/2
			-- print("高度 ---------- 超最高",max_y,"得",ui_y)
		elseif y<min_y then
			ui_y = min_y - windows_height/2
			-- print("高度 ---------- 超最低",min_y,"得",ui_y)
		else
			ui_y = y - windows_height/2
			-- print("高度 ---------- 在范围内",min_y,"得",ui_y)
		end
		-- 水平位置 height
		local ui_x = 0
		if x <= windows_width/2 then
			-- print(x,"位置靠左,显示在右方 结果：",string.format("%s+%s/2+50 = ",x,ui_width),x + ui_width/2 + 50)
			x = x + ui_width/2 + 50
		else
			-- print(x,"位置靠右,显示在左方 结果：",string.format("%s-%s/2-50 = ",x,ui_width),x - ui_width/2 - 50)
			x = x - ui_width/2 - 50
		end
		local min_x = ui_width/2
		local max_x = windows_width - ui_width/2
		if x>max_x and x<min_x then
			-- print("水平 ################ 超最右最左",max_x,min_x,"得0",0)
			ui_x = 0
		elseif x>max_x then
			ui_x = max_x - windows_width/2
			-- print("水平 ################ 超最右",max_y,"得",ui_y)
		elseif x<min_x then
			ui_x = min_x - windows_width/2
			-- print("水平 ################ 超最左",min_y,"得",ui_y)
		else
			ui_x = x - windows_width/2
			-- print("水平 ################ 在范围内",min_y,"得",ui_y)
		end
		-- print("最终位置",Vector3(ui_x,ui_y))
		control.localPosition = Vector3(ui_x,ui_y)
		self.refer:Get("canvasGroup").alpha = 1
	end
	-- set_pos_fun()
	PLua.Delay(set_pos_fun,0.01)
end

function ItemTips:set_btn()
	local ref = self.refer
	-- 按钮
	self.btns = self.item_obj.tips_btn or {}
	self.item_obj.tips_btn = nil
	-- print("设置按钮个数",#self.btns)

	local root = ref:Get("btnGroup")
	local item = ref:Get("btn")
	for i=root.transform.childCount-1,0,-1 do
		self:repay_item("btn",root.transform:GetChild(i).gameObject)
	end
	for i,v in ipairs(self.btns or {}) do
		-- print("设置按钮",v.name)
		local btn = self:get_item("btn",item,root)
		btn:GetComponentInChildren("UnityEngine.UI.Text").text = v.name
		btn.name = v.name
	end
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (ref:Get("control")) -- 立即重建布局
	UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate (root.transform) -- 立即重建布局
end

return ItemTips