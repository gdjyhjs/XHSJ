--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-04-06 19:30:16
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local ItemSys = LuaItemManager:get_item_obejct("itemSys")
local Enum = require "enum.enum"
local ItemDescribeParameter = require("models.itemSys.itemDescribeParameter")

--职业名称
local career_name = {
	[Enum.CAREER.SOLDER] = "修罗",
	[Enum.CAREER.MAGIC] = "阎姬",
	[Enum.CAREER.BOWMAN] = "夜狩",
}

local gem_tips_ico = {
	[Enum.GEM_TYPE.NONE] = "img_duanzao_bg_04",
	[Enum.GEM_TYPE.RED] = "img_duanzao_bg_05",
	[Enum.GEM_TYPE.GREEN] = "img_duanzao_bg_05",
	[Enum.GEM_TYPE.PURPLE] = "img_duanzao_bg_05",
	[Enum.GEM_TYPE.BLUE] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.CRIT] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.HIT] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.DODGE] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.THROUGH] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.CRIT_DEF] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.DAMAGE_DOWN] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.BLOCK] = "img_duanzao_bg_05",
	-- [Enum.GEM_TYPE.CRIT_HURT] = "img_duanzao_bg_05",
}

local item_color = {
	NONE=gf_get_text_color(ClientEnum.SET_GM_COLOR.MAIN_COMMON),
	[0]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_WHITE),
	[1]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_GREEN),
	[2]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_BLUE),
	[3]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_PURPLE),
	[4]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_GOLD),
	[5]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_ORANGE),
	[6]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_RED),
	[7]=gf_get_text_color(ClientEnum.SET_GM_COLOR.INTERFACE_RED),
	GREEN=gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),
	RED=gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN),
}

local tips_color = {
	NONE=gf_get_text_color(ClientEnum.SET_GM_COLOR.MAIN_COMMON),
	[0]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_WHITE),
	[1]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_GREEN),
	[2]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_BLUE),
	[3]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_PURPLE),
	[4]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_GOLD),
	[5]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_ORANGE),
	[6]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_RED),
	[7]=gf_get_text_color(ClientEnum.SET_GM_COLOR.TIPS_RED),
	GREEN=gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD),
	RED=gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_DOWN),
}

local color_name = {
	[0]="白色",
	[1]="绿色",
	[2]="蓝色",
	[3]="紫色",
	[4]="金色",
	[5]="橙色",
	[6]="红色",
	[7]="红色",
}

local start_color = {
	[1]={0,30,2},
	[2]={31,80,3},
	[3]={81,100,5},
}

ItemSys.priority = ClientEnum.PRIORITY.ITEM_TIPS
--UI资源
ItemSys.assets=
{
}

--初始化函数只会调用一次
function ItemSys:initialize()
	self.main_item = LuaItemManager:get_item_obejct("mainui")
	self.bag = LuaItemManager:get_item_obejct("bag")
	self.equip_sys = LuaItemManager:get_item_obejct("equip")
	self.other_player_equip={}
	print("物品系统初始化完毕 itemSysUseGuideView")
	-- self:add_to_state()
end

-- 获取物品描述
function ItemSys:get_item_desc(propId)
	local data = ConfigMgr:get_config("item")[propId]
	local parameter = ItemDescribeParameter(propId)
	local desc = string.gsub(parameter and string.format(data.desc,unpack(parameter)) or data.desc,"\\n","\n")
	return desc
end

--获取星级 值所在区间的颜色
function ItemSys:get_start_color(percentage,tips)
	local idx = 1
	for i,v in ipairs(start_color) do
		if percentage>=v[1] and percentage<=v[2] then
			idx = v[3]
			break
		end
	end
	return self:get_item_color(idx,tips)
end

--获取钱币图标
function ItemSys:get_coin_icon(coin_type)
	-- print("获取钱币图标",coin_type)
	return ConfigMgr:get_config("base_res")[coin_type].icon
end

--获取战斗属性名称
function ItemSys:get_combat_attr_name(arrt,value,separator)
	-- print("获取战斗属性名称",arrt,value,separator)
	local data = ConfigMgr:get_config("propertyname")[arrt]
	local name = data.name
	if value then
		value = math.floor(value)
		if data.is_percent==1 then
			name = name .. (separator or "+") .. value/100 .. "%"
		else
			name = name .. (separator or "+") .. value
		end
	end
	return name
end

--获取战斗属性值
function ItemSys:get_combat_attr_value(arrt,value,separator)
	-- print("获取战斗属性值",arrt,value,separator)
	local data = ConfigMgr:get_config("propertyname")[arrt]
	if value then
		value = math.floor(value)
		if data.is_percent==1 then
			return (separator or "+") .. value/100 .. "%"
		else
			return (separator or "+") .. value
		end
	end
end

--获取属性战斗力比率
function ItemSys:get_combat_attr_fcr(arrt)
	-- print("获取属性战斗力比率",arrt)
	local data = ConfigMgr:get_config("propertyname")[arrt]
	return (data and data.conefficient or 0)/10000
end

--获取装备前缀名称
function ItemSys:get_equip_prefix_name(pref)
	-- return pref and equip_prefix_name[pref] and equip_prefix_name[pref].."." or ""
	local prefix_data = ConfigMgr:get_config("equip_prefix")[pref]
	return prefix_data and prefix_data.prefix_name.."·" or ""
end

--获取职业名称
function ItemSys:get_career_name(car)
	return car and career_name[car] or "无限制"
end

--获取宝石tips图标
function ItemSys:get_gem_tips_ico(name)
	return gem_tips_ico[name] or gem_tips_ico[Enum.CAREER.NONE]
end

--获取颜色名称
function ItemSys:get_color_name(color_id)
	return color_name[color_id] or color_name[0]
end

--获取物品颜色
function ItemSys:get_item_color(color_id,is_tips)
	local d = is_tips and tips_color or item_color
	return d[color_id] or d.NONE
end

--获取有颜色的道具名称
function ItemSys:get_have_color_prop_name(data,is_tips)
	local d = is_tips and tips_color or item_color
	return "<color="..d[data.color]..">["..data.name.."]</color>"
end

--获得有颜色的装备名称
function ItemSys:get_have_color_equip_name(equip,is_tips)
	local d = is_tips and tips_color or item_color
	return "<color="..d[equip.color]..">["..self:get_equip_prefix_name(equip.prefix)..ConfigMgr:get_config("item")[equip.protoId].name.."]</color>"
end

--获得有颜色的物品名称
function ItemSys:get_have_color_item_name(protoId,is_tips)
	local d = is_tips and tips_color or item_color
	local data = ConfigMgr:get_config("item")[protoId]
	return "<color="..d[data.color]..">["..data.name.."]</color>"
end

--给字符串添加颜色
function ItemSys:give_color_for_string(str,color_id,is_tips)
	return "<color="..self:get_item_color(color_id,is_tips)..">"..str.."</color>"
end

--获取装备的套装信息
function ItemSys:get_equip_set(protoId)
	if not self.equip_protoId_relevance_set_id then
		self.equip_protoId_relevance_set_id={}
		local list = ConfigMgr:get_config("equip_set")
		for k,v in pairs(list) do
			for i,id in ipairs(v.element) do
				self.equip_protoId_relevance_set_id[id]=v
			end
		end
	end

	return self.equip_protoId_relevance_set_id[protoId]
end

--获取物品类型（原型ID）
function ItemSys:get_item_type(protoId)
	local small_type=math.floor(protoId*0.0001)%10
	local big_type=math.floor(protoId*0.0000001)
	return big_type,small_type
end

--获取某件装备可以获得多少淬火
function ItemSys:get_give_quench(level,color)
	print("等级",level or "nil","品质",color or "nil","的装备可以获取多少淬火？")
	if not self.equip_recycle_data then -- [level][color] = 淬火数量
		self.equip_recycle_data = {}
		local data = ConfigMgr:get_config("equip_recycle")
		for i,v in ipairs(data) do
			gf_print_table(v,"id"..i)
			if not self.equip_recycle_data[v.level] then
				self.equip_recycle_data[v.level] = {}
			end
			self.equip_recycle_data[v.level][v.color] = v.quench
		end
	end
	return self.equip_recycle_data[level] and self.equip_recycle_data[level][color] or 0
end

--设置物品图标
function ItemSys:set_item_ico(img,name)
	gf_setImageTexture(img, name)
end

--物品是否绑定
function ItemSys:calculate_item_is_bind(id)
	return ConfigMgr:get_config("item")[id].bind == 1
end

--点击事件
function ItemSys:on_click(obj,arg)
	print("点击了物品tips",obj,arg)
	return true
end

function ItemSys:on_press_down(obj,click_pos)
	print("物品系统按下")
	return true
end

function ItemSys:on_press_up(obj,click_pos)
	print("物品系统弹起")
	return true
end 

--根据物品id获取物品
function ItemSys:get_item_for_id(id)
	if not self.items_data then self.items_data = ConfigMgr:get_config("item") end
	--print("获取物品id=",id)
	return self.items_data[id]
end

--根据物品虚拟id 获取打造id
function ItemSys:get_formulaId_for_id(id)
	local data = ConfigMgr:get_config("item")[id]
    if data and data.type == Enum.ITEM_TYPE.VIRTUAL and data.sub_type == Enum.VIRTUAL_TYPE.EQUIP_FORMULA_CAREER then
        local career = LuaItemManager:get_item_obejct("game"):get_career()
        local formulaId = (function()
                            for i,v in ipairs(data.effect) do
                                if career == v[1] then
                                    -- print(v[1],"打造id",v[2])
                                    return v[2]
                                end
                            end
                        end)()
        return formulaId
    else
        return id
    end
end

--显示背包物品信息	use_fun=方法,p=参数
function ItemSys:show_item_info(item,btn_bool,pos,use_fun,p)
	local data = ConfigMgr:get_config("item")[item.protoId]
	if data.type == Enum.ITEM_TYPE.EQUIP then
		self:equip_tips(nil,item,pos,1)
	else
		self:prop_tips(nil,item,pos,1)
	end
end

--关闭tips
function ItemSys:hide_item_tips()
	self.assets[1].ui_array.itemSysAttributeView:hide()
end

--通用显示物品信息 至少要有原型id 或者 guid
function ItemSys:common_show_item_info(protoId,guid,player_id,pos,player_info)
	if protoId and ConfigMgr:get_config("item")[protoId].type ~= Enum.ITEM_TYPE.EQUIP then
		self:prop_tips(protoId,nil,pos)
	else
		print("<color=red>显示物品道具的tips需要穿原型id，如果是装备tips请用新接口 ItemSys:equip_tips(guid,bagItem,pos,auto_btn)</color>")
	end
	
end

--道具tips
function ItemSys:prop_tips(protoId,bagItem,pos,auto_btn)
	self.tips_pos = pos

	self.tips_mode = 1
	self.tips_protoId = protoId
	self.tips_item = bagItem
	if not bagItem and protoId then
		self.tips_item = LuaItemManager:get_item_obejct("bag"):get_item_for_protoId(protoId)
	end
	if bagItem and not protoId then
		self.tips_protoId = bagItem.protoId
	end

	if not self.tips_protoId then
		print("<color=red>没有找到此物品，请再检查</color>",guid,bagItem,pos,auto_btn)
		return
	end

	local data = ConfigMgr:get_config("item")[self.tips_protoId]
	if data.sub_type == Enum.PROP_TYPE.HERO_ITEM then -- 招募武将道具
		require("models.hero.heroItemShowView")(self.tips_protoId,bagItem.guid)
		return
	end

	if self.tips_item and auto_btn then -- 自动按钮
		if  data.sub_type == Enum.PROP_TYPE.IMMED_ADD_HP_ITEM then
			-- 添加快捷按钮
			self:add_tips_btn("快捷",function() LuaItemManager:get_item_obejct("bag"):set_immed_add_hp_item_c2s(self.tips_protoId) end)
		end
		if  bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.BAG_DIRECT)==ClientEnum.ITEM_USE_TYPE.BAG_DIRECT then
			-- 添加使用按钮
			print("data.sub_type == Enum.PROP_TYPE.RAND_GIFT_HERO:",data.sub_type , Enum.PROP_TYPE.RAND_GIFT_HERO)
			if data.sub_type == Enum.PROP_TYPE.HERO_ITEM then
				self:add_tips_btn("招募",function() self:tips_btn_fun_use() end)
			else
				self:add_tips_btn("使用",function() self:tips_btn_fun_use() end)
			end
		end
		if data.sell and data.sell==1 then
			-- 添加出售按钮
			self:add_tips_btn("出售",function() self:tips_btn_fun_sell() end)
		end
		if self.tips_item and self.tips_item.num and self.tips_item.num>1 then
			-- 添加拆分按钮
			self:add_tips_btn("拆分",function() self:tips_btn_fun_split() end)
		end
	end

	self.item_tips_ui = View("itemTips",self)
end

--道具tips
function ItemSys:prop_use_tips(protoId,callback)
	self.tips_mode = 1
	self.tips_protoId = protoId
	self.tips_item = bagItem
	if not bagItem and protoId then
		self.tips_item = LuaItemManager:get_item_obejct("bag"):get_item_for_protoId(protoId)
		gf_print_table(self.tips_item, "wtf self.tips_item:")
	end
	if bagItem and not protoId then
		self.tips_protoId = bagItem.protoId
	end

	if not self.tips_protoId then
		print("<color=red>没有找到此物品，请再检查</color>",guid,bagItem,pos,auto_btn)
		return
	end

	if self.tips_item then -- 自动按钮
		local data = ConfigMgr:get_config("item")[self.tips_protoId]
		if  bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.SPECIFIC)==ClientEnum.ITEM_USE_TYPE.SPECIFIC then
			-- 添加使用按钮
			self:add_tips_btn("使用",callback)
		end
	end

	self.item_tips_ui = View("itemTips",self)
end

--本地人物装备tips
function ItemSys:equip_tips(guid,bagItem,pos,auto_btn)
	self.tips_pos = pos
	self.tips_mode = 2
	self.tips_item = bagItem or LuaItemManager:get_item_obejct("bag"):get_item_for_guid(guid)

	if not self.tips_item then
		print("<color=red>背包没有找到此物品，请再检查</color>",guid,self.tips_item,pos,auto_btn)
		return
	else
		print("物品tips",bagItem.guid)
	end

	self.tips_protoId = self.tips_item.protoId
	local data = ConfigMgr:get_config("item")[self.tips_protoId]
	local equip = LuaItemManager:get_item_obejct("equip")

	local is_body_equip = math.floor(self.tips_item.slot/10000)==Enum.BAG_TYPE.EQUIP --是否身上的装备
	if is_body_equip then
		self.polishInfo = equip:get_polish_attr(data.sub_type)
		self.enhanceId = equip:get_enhance_id(data.sub_type)
		self.gemIds = equip:get_gem_info()[data.sub_type]
		self.setMask = LuaItemManager:get_item_obejct("bag"):get_set_mask(self.tips_item)
	end

	if auto_btn then -- 自动按钮
		if is_body_equip then
			-- self:add_tips_btn("卸下",function() self:tips_btn_fun_use() end)
			self:add_tips_btn("强化",function() 
				gf_open_model(ClientEnum.MODULE_TYPE.EQUIP,1,data.sub_type)
			end)
		elseif data.career == LuaItemManager:get_item_obejct("game"):getRoleInfo().career then
			-- 添加使用按钮
			self:add_tips_btn("装备",function() self:tips_btn_fun_use() end)
			-- self:add_tips_btn("熔炼",function() self:tips_btn_fun_smelting() end)
		end
		if not is_body_equip then
			self:add_tips_btn("喂养",function()
				print("打开了喂养界面")
				gf_create_model_view("horse",ClientEnum.HORSE_VIEW.FEED,ClientEnum.HORSE_SUB_VIEW.EQUIP_FEED)
				LuaItemManager:get_item_obejct("bag").assets[1]:hide()				
			end)
		end
	end

	View("itemTips",self)
end

-- 装备浏览
function ItemSys:equip_browse(equip,enhanceId,gemIds,polishInfo,pos)
	self.enhanceId = enhanceId
	self.gemIds = gemIds
	self.polishInfo = polishInfo
	self.tips_pos = pos
	gf_print_table(equip,"装备浏览")
	self.tips_mode = 2
	self.tips_item = equip
	self.tips_protoId = equip.protoId
	View("itemTips",self)
end

--服务器人物装备
function ItemSys:remote_equip_tips(guid,playerId,pos)
	self.tips_pos = pos
	print("guid,归属玩家",guid,playerId,pos)
	self:other_player_equip_c2s(playerId,guid)
	View("itemTips",self)
end

--显示技能tips
function ItemSys:skill_tips(skillId,pos,button_state)
	self.tips_pos = pos
	self.tips_mode = 4
	self.tips_protoId = skillId
	for i,v in ipairs(button_state or {}) do
		self:add_tips_btn(v.name,v.func)
	end
	
	if self.tips_protoId then
		View("itemTips",self)
	else
		print("<color=red>没有找到此技能，请再检查</color>",guid,bagItem,pos,auto_btn)
	end
end

function ItemSys:set_item_btn(obj,name)
	local child = obj.transform:GetChild(0)
	if not child then
		local item = UnityEngine.GameObject()
		item.transform:SetParent(obj.transform,false)
	end
	child.name = name
end

function ItemSys:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.FinishScene then -- 进入场景，刷新主ui
		self:show()
	end
end

function ItemSys:other_player_equip_c2s(roleId,guid)
	print("请求获取其他玩家装备信息")
	Net:send({roleId=roleId,guid=guid},"bag","OtherPlayerEquip")
end

--显示快速使用 set_tips_name
function ItemSys:show_quick_use(guid,pos)
	local item = LuaItemManager:get_item_obejct("bag"):get_item_for_guid(guid)
	if not item then
		return
	end
	local data = ConfigMgr:get_config("item")[item.protoId]
	local name = data.name
	local icon = data.icon
	local bg = "item_color_"..(item.color or data.color or "0")

	local is_equip = data.type == ServerEnum.ITEM_TYPE.EQUIP
	local count = item.num>1 and item.num or nil
	if not is_equip then
		count = LuaItemManager:get_item_obejct("bag"):get_item_count(item.protoId,ServerEnum.BAG_TYPE.NORMAL)
	end
	local power = nil
	if is_equip then
		power = item.color and ("评分"..LuaItemManager:get_item_obejct("equip"):calculate_equip_fighting_capacity(item)) or nil
	end
	local auto = false
	if is_equip then
		auto = LuaItemManager:get_item_obejct("game"):getLevel() < ConfigMgr:get_config("t_misc").guide_protect_level
	end
	local btn_name = is_equip and gf_localize_string("穿戴") or 
		(bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.BATCH)==ClientEnum.ITEM_USE_TYPE.BATCH and "全部使用" or "使用")
	local set_tips_name = nil
	if is_equip then
		set_tips_name = function()
			local equip = LuaItemManager:get_item_obejct("equip")
			self.tips_protoId = item.protoId
			self.tips_item = item
			self.polishInfo = equip:get_polish_attr(data.sub_type)
			self.enhanceId = equip:get_enhance_id(data.sub_type)
			self.gemIds = equip:get_gem_info()[data.sub_type]
			self.setMask = LuaItemManager:get_item_obejct("bag"):get_set_mask(item)
			self.tips_mode = 2
			self:equip_tips(guid,item,pos)
		end
	else
		set_tips_name = function()
				self.tips_protoId = item.protoId
				self.tips_item = item
				self.tips_mode = 1
				self:prop_tips(item.protoId,item,pos)
			end
	end
	local cb = function()
	print("使用的是装备吗",is_equip)
			if is_equip then
				self.tips_protoId = item.protoId
				self.tips_item = item
				self:tips_btn_fun_use()
			else
				local bag = LuaItemManager:get_item_obejct("bag")
				if bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.BATCH)==ClientEnum.ITEM_USE_TYPE.BATCH then
					local list = bag:get_item_for_protoId_type(item.protoId,ServerEnum.BAG_TYPE.NORMAL)
					for i,v in ipairs(list) do
						bag:use_item_c2s(v.item.guid,v.item.num,data.code)
						-- self:tips_btn_fun_use()
					end
				else
					bag:use_item_c2s(guid,1,data.code)
				end
			end
		end
	local view = self:get_itemSysUseGuideView()
	view:set_tips_name(set_tips_name)
	view:set_name(name)
	view:set_icon(icon)
	view:set_bg(bg)
	view:set_count(count)
	view:set_power(power)
	view:set_action(cb)
	view:set_auto(auto)
	view:set_bg_btn_show(true) -- 设置是否使用背景按钮
	view:set_exit_btn_show(true) -- 设置是否使用关闭按钮
	view:set_btn_name(btn_name)
	view:set_content()
end

function ItemSys:get_itemSysUseGuideView()
	if not self.itemSysUseGuideView then
		print("view itemSysUseGuideView")
		self.itemSysUseGuideView = View("itemSysUseGuideView",self)
	else
		print("show itemSysUseGuideView")
		self.itemSysUseGuideView:show()
	end
	return self.itemSysUseGuideView
end

--设置当前物品
function ItemSys:set_item(item,setMask,enhanceId,gemId_1)
	if item == type(item) then
		self.use_item = item
	else
		self.use_item = LuaItemManager:get_item_obejct("bag"):get_item_for_guid(item)
	end
	self.setMask = setMask
	self.enhanceId = enhanceId
	self.gemIds = gemIds
end

--添加 ClientEnum.ITEM_TIPS_CONTENT 	 tips特定情况下需要出现的项
-- add_mode：需要添加的内容		枚举可累加
function ItemSys:add_tips_content(add_mode)
	self.item_tips_content = add_mode
end

--设置tips按钮
function ItemSys:add_tips_btn(name,fun)
	if not self.tips_btn then
		self.tips_btn = {}
	end
	self.tips_btn[#self.tips_btn+1] = {name = name,fun = fun}
end

--tips 预选按钮方法
function ItemSys:tips_btn_fun_use() -- 使用
	print("使用")
	if not self.tips_item then
		return
	end
	print("使用",self.tips_item)
	local protoId = self.tips_item.protoId
	local data = ConfigMgr:get_config("item")[protoId]
	print(LuaItemManager:get_item_obejct("game"):getLevel(), data.level)
	if LuaItemManager:get_item_obejct("game"):getLevel() < data.level then
		gf_message_tips("使用等级不足")
		return
	end
	if self.tips_item then
		if data.type == Enum.ITEM_TYPE.EQUIP and data.sub_type < Enum.EQUIP_TYPE.END then -- 是装备
			local on_bag = math.floor(self.tips_item.slot/10000)
			local bag = LuaItemManager:get_item_obejct("bag")
			if on_bag == Enum.BAG_TYPE.EQUIP then -- 卸下
				print("卸下")
				local bag_pos = bag:get_bag_first_space(ClientEnum.BAG_TYPE.BAG)
				if bag_pos then
					bag:swap_item_c2s(self.tips_item.slot,bag_pos)
				else
					gf_message_tips("背包已满")
				end
			elseif on_bag == Enum.BAG_TYPE.NORMAL then -- 穿戴
				print("穿戴")
				bag:swap_item_c2s(self.tips_item.slot,ConfigMgr:get_config("item")[protoId].sub_type+20000)
			end
		else -- 使用物品
			print("使用")
			if bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.SPECIFIC)==ClientEnum.ITEM_USE_TYPE.SPECIFIC then --特定使用
				if require("models.bag.itemUseEnter")(protoId,self.tips_item.guid) then
					LuaItemManager:get_item_obejct("bag").assets[1]:hide()
				end
			elseif bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.BATCH)==ClientEnum.ITEM_USE_TYPE.BATCH --批量使用
				 and bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.BAG_DIRECT)==ClientEnum.ITEM_USE_TYPE.BAG_DIRECT --在背包直接使用
				 and self.tips_item.num>1 then --数量大于1
				-- print("是可批量使用物品4，并且数量大于1--弹出数量窗口")
				-- print("<color=yellow>弹窗</color>")
				self.cmp_mode = 2
				self.cmp_item = self.tips_item
				View("ItemCmp",self)
			elseif bit._and(data.use_type,ClientEnum.ITEM_USE_TYPE.BAG_DIRECT)==ClientEnum.ITEM_USE_TYPE.BAG_DIRECT then --在背包直接使用
				if data.type == Enum.ITEM_TYPE.PROP and data.sub_type == Enum.PROP_TYPE.ADD_EXP_GAIN_ITEM then
					print("使用多倍经验药BUFF药 ")
					LuaItemManager:get_item_obejct("buff"):check_buff(protoId,self.tips_item.guid)
				elseif data.type == Enum.ITEM_TYPE.PROP and data.sub_type == Enum.PROP_TYPE.ZORK_PRACTICE_TIME then
					print("魔域多倍经验药BUFF药 ")
					LuaItemManager:get_item_obejct("zorkPractice"):use_practice_prop(protoId,self.tips_item.guid)
				else
				print("--直接使用")
					LuaItemManager:get_item_obejct("bag"):use_item_c2s(self.tips_item.guid,1,self.tips_item.protoId)
				end
			else
				print("<color=red>暂无定义使用方法</color>")
			end
		end
	end
end
function ItemSys:tips_btn_fun_sell() -- 出售
	if not self.tips_item then
		return
	end
	print("出售")
	local item = self.tips_item
	local protoId = self.tips_item.protoId
	local data = ConfigMgr:get_config("item")[protoId]
	local f = function ()
		LuaItemManager:get_item_obejct("bag"):sell_item_c2s(item.guid,item.num)
	end
	local content = string.format("确定要出售<color=#52b44d>%s*%d</color>吗？出售可获得<color=#52b44d>%d</color>铜钱",data.name,item.num,item.num*data.sell_price)
	print("弹框",content)
	LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(content,f)
end
function ItemSys:tips_btn_fun_split() -- 拆分
	if not self.tips_item then
		return
	end
	print("拆分")
	self.cmp_mode = 1
	self.cmp_item = self.tips_item
	View("ItemCmp",self)
end
function ItemSys:tips_btn_fun_smelting() -- 熔炼
	if not self.tips_item then
		return
	end
	View("EquipSmelting",self)
end

function ItemSys:select_prop_tips(protoIdList,fn)
	self.select_prop_list = protoIdList
	self.select_prop_fn = fn
	View("SelectPropTips",self)
end