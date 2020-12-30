--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-22 11:00:39
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local BagUserData = require("models.bag.bagUserData")

local Equip = LuaItemManager:get_item_obejct("equip")
--UI资源
Equip.assets=
{
    View("equipView", Equip) 
}
Equip.priority = ClientEnum.PRIORITY.EQUIP

--点击事件
function Equip:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event("equip_view_on_click", false, obj, arg)
	return true
end
-- 获取强化id
function Equip:get_enhance_id(type)
	return self.enhance_info and self.enhance_info[type] and self.enhance_info[type].id or 0
end
-- 获取强化经验
function Equip:get_enhance_exp(type)
	return self.enhance_info and self.enhance_info[type] and self.enhance_info[type].exp or 0
end
-- 获取打造神器值
function Equip:get_formula_point(lv)
	return self.point_list[lv] or 0
end
-- 获取镶嵌信息
function Equip:get_gem_info()
	return self.gem_info
end
-- 获取洗炼信息
function Equip:get_polish_attr(equipType)
	return equipType and self.polish_attr[equipType] or {}
end
-- 获取洗炼信息
function Equip:get_polish_info()
	return self.polish_attr or {}
end

--获取洗炼属性
function Equip:get_polish_attr_cache(equipType)
	if not self.polish_attr_cache[equipType] then
		self:get_polish_equip_c2s(equipType)
	end
	return self.polish_attr_cache[equipType] or {}
end

--初始化函数只会调用一次
function Equip:initialize()
	self.red_pos = {}

	self.enhance_info = {} --强化信息
	self.gem_info = {} --宝石镶嵌信息
	self.point_list = {} --各个等级的神器值
	self.polish_attr = {} --洗炼的属性
	self.polish_attr_cache = {} --洗炼属性缓存
	-- self.gem_count = {} --各等级的宝石的镶嵌数量
	self.main_item = LuaItemManager:get_item_obejct("mainui")
	self.bag = LuaItemManager:get_item_obejct("bag")
	self.item_sys = LuaItemManager:get_item_obejct("itemSys")
end

--服务器返回
function Equip:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("bag"))then
		if(id2== Net:get_id2("bag", "FormulaEquipR"))then	--打造装备
			gf_print_table(msg,"打造装备")
			self:formula_equip_s2c(msg)
		elseif id2 == Net:get_id2("bag", "FormulaAccumulateR") then	--获取神器值
			gf_print_table(msg,"神器值")
			gf_print_table(msg,"wtf receive FormulaAccumulateR")
			self:formula_accumulate_s2c(msg)


		elseif id2 == Net:get_id2("bag", "EnhanceInfoR") then	--强化信息
			gf_print_table(msg,"wtf receive EnhanceInfoR")
			gf_print_table(msg,"强化信息")
			self:enhance_info_s2c(msg)
		elseif id2 == Net:get_id2("bag", "EnhanceEquipR") then	--强化装备
			gf_print_table(msg,"强化装备")
			self:enhance_equip_s2c(msg,sid)


		elseif id2 == Net:get_id2("bag", "PolishEquipR") then	--洗炼装备
			gf_print_table(msg,"洗炼装备")
			self:polish_equip_s2c(msg)
		elseif id2 == Net:get_id2("bag", "GetPolishAttrR") then	--获取洗炼属性
			gf_print_table(msg,"获取洗炼属性")
			self:get_polish_equip_s2c(msg)
		elseif id2 == Net:get_id2("bag", "SavePolishR") then	--保存洗炼
			gf_print_table(msg,"保存洗炼")
			self:save_polish_s2c(msg)
		elseif id2 == Net:get_id2("bag", "GetPolishInfoR") then	--洗炼信息
			gf_print_table(msg,"wtf receive GetPolishInfoR")
			gf_print_table(msg,"洗炼信息")
			self:get_polish_info_s2c(msg)

		elseif id2 == Net:get_id2("bag", "GemInfoR") then	--获取镶嵌信息
			gf_print_table(msg,"wtf receive GemInfoR")
			gf_print_table(msg,"获取镶嵌信息")
			self:equip_gem_s2c(msg)
		elseif id2 == Net:get_id2("bag", "InlayGemR") then	--镶嵌宝石
			gf_print_table(msg,"镶嵌宝石")
			self:inlay_gem_s2c(msg)
		elseif id2 == Net:get_id2("bag", "UnloadGemR") then	--镶嵌宝石
			gf_print_table(msg,"卸载宝石")
			self:unload_gem_s2c(msg)
		elseif id2 == Net:get_id2("bag", "SmartGemLevelUpR") then	--宝石升级
			gf_print_table(msg,"宝石升级")
			self:gem_level_up_s2c(msg)
		elseif id2 == Net:get_id2("bag", "GemLevelUpInLayR") then	--升级镶嵌了的宝石
			gf_print_table(msg,"升级镶嵌了的宝石")
			self:gem_level_up_inLay_s2c(msg)
		elseif id2 == Net:get_id2("bag", "GemUpdateR") then	--当镶嵌宝石发生变化时
			gf_print_table(msg,"当镶嵌宝石发生变化时")
			self:gem_update_s2c(msg)
		end
	elseif id1 == ClientProto.UIRedPoint then -- 红点
		if msg.module == ClientEnum.MODULE_TYPE.EQUIP then
			gf_print_table(msg,"打造红点")
			local key = (msg.a or "")..(msg.b or "")..(msg.c or "")..(msg.d or "")
			self.red_pos[key] = msg.show or nil
			--主界面红点
			local show = (function()
	                    for k,v in pairs(self.red_pos) do
	                    	if v then
	                        	return true
	                        end
	                    end
	                end)()
	        Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.MAKE, visible=show or false}, ClientProto.ShowHotPoint)
		end
	end
end

function Equip:is_have_red_point()
			-- gf_print_table(self.red_pos,"获取打造红点")
	for k,v in pairs(self.red_pos or {}) do
		if v then
	    	return true
	    end
	end
	return false
end

--打造结果
function Equip:formula_equip_s2c(msg)
	----gf_print_table(msg,"打造装备结果")
	if msg.err==0 and msg.equip then
		 -- 锻造界面-强化/洗炼/打造
		Sound:play(ClientEnum.SOUND_KEY.MACHINING)
		print("bag打造成功")
		local m = {equipList={msg.equip}}
		LuaItemManager:get_item_obejct("bag"):update_equip_s2c(m,true) --更新装备
		-- 更新神器值
		local item_data = ConfigMgr:get_config("item")[msg.equip.protoId]
		local cur_point = self.point_list[item_data.level]
		local max_point = ConfigMgr:get_config("equip_formula_accumulate")[item_data.level].total
		if cur_point==max_point then
			self.point_list[item_data.level] = 0
		else
			local point = self:get_formula_point(item_data.level) + ConfigMgr:get_config("equip_formula")[msg.equip.formulaId].per_point
			if point > max_point then
				point = max_point
			end
			self.point_list[item_data.level] = point
		end
		
		-- 成功界面
		View("fusionSucceed",self):set_equip(msg.equip)
	end
end

--获取神器值
function Equip:formula_accumulate_s2c(msg)
	-- gf_print_table(msg,"获取神器值")
	for i,v in ipairs(msg.forAccPoint or {}) do
		self.point_list[v.equipLv] = v.point
	end
	
end

--返回强化信息
function Equip:enhance_info_s2c(msg)
	self.enhance_info = {}
	for i=ServerEnum.EQUIP_TYPE.BEGIN,ServerEnum.EQUIP_TYPE.END-1 do
		self.enhance_info[i] = {
			id = msg.enhanceIds[i] or 0,
			exp = msg.exp[i] or 0,
		}
	end
end

--返回强化结果 成功或失败
function Equip:enhance_equip_s2c(msg,sid)
	--print("强化结果",msg.err)
	if msg.err==0 then
		 -- 锻造界面-强化/洗炼/打造
		Sound:play(ClientEnum.SOUND_KEY.MACHINING)
		self.enhance_info[sid]={
			id = msg.enhanceId or 0,
			exp = msg.exp or 0,
		}
	end
end

--获取当前洗炼属性
function Equip:get_polish_info_s2c(msg)
	for i,v in ipairs(msg.equipTypePolishInfo or {}) do
		self.polish_attr[v.equipType] = v.attrs
	end
end

--洗炼装备
function Equip:polish_equip_s2c(msg)
	if msg.err==0 then
		 -- 锻造界面-强化/洗炼/打造
		Sound:play(ClientEnum.SOUND_KEY.MACHINING)
		self.polish_attr_cache[msg.equipType]=msg.attrs
	end
end

--获取洗炼属性
function Equip:get_polish_equip_s2c(msg)
	if msg.err==0 then
		self.polish_attr_cache[msg.equipType]=msg.attrs
	end
end

--保存洗炼属性
function Equip:save_polish_s2c(msg)
	--print("保存洗炼属性",msg)
	if msg.err==0 then
		self.polish_attr[msg.equipType]=self.polish_attr_cache[msg.equipType]
		self.polish_attr_cache[msg.equipType]=nil
	end
end

--获取镶嵌信息
function Equip:equip_gem_s2c(msg)
	--print("--获取镶嵌信息")
	--gf_print_table(msg)
	for i,v in ipairs(msg.equipTyMapGem) do
		self.gem_info[i]=v.gemIds
	end
end
--镶嵌宝石
function Equip:inlay_gem_s2c(msg)
	-- gf_print_table(msg,"镶嵌宝石返回协议")
	-- if msg.err == 0 then
 --    	self.gem_info[msg.equipType][msg.gemIdx]=msg.protoId
	-- end
end
function Equip:unload_gem_s2c(msg)
end
--宝石升级
function Equip:gem_level_up_s2c(msg)
	-- self.assets[1]:refresh_baoshihecheng_count()
end
--升级镶嵌了的宝石
function Equip:gem_level_up_inLay_s2c(msg)
	-- gf_print_table(msg,"升级镶嵌了的宝石")
	-- if msg.err == 0 then
 --    	self.gem_info[msg.equipType][msg.idx]=msg.protoId
	-- end
end
--当镶嵌宝石发生变化时
function Equip:gem_update_s2c(msg)
	if self.gem_info[msg.equipType] and self.gem_info[msg.equipType][msg.idx] then
    	self.gem_info[msg.equipType][msg.idx]=msg.protoId
    end
end
---------------------------------------------------------------------------------

--获取镶嵌信息
function Equip:equip_gem_c2s()
	print("发送协议 获取镶嵌信息")
	Net:send({},"bag","GemInfo")
end
--宝石升级
function Equip:gem_level_up_c2s(targetGemProtoId,bUseGrandsonGem)
	print("发送协议 宝石升级")
	Net:send({targetGemProtoId=targetGemProtoId,bUseGrandsonGem=bUseGrandsonGem},"bag","SmartGemLevelUp")
end
--镶嵌宝石
function Equip:inlay_gem_c2s(guid,equipType,gemIdx)
	print("发送协议 发送镶嵌宝石协议",guid,equipType,gemIdx)
	local msg = {guid=guid,equipType=equipType,gemIdx=gemIdx}
	-- if not self.gem_sid then self.gem_sid = {} end
	-- local sid = equipType*10+gemIdx
	-- self.gem_sid[sid] = {protoId = self.bag:get_item_for_guid(guid).protoId,equipType=equipType,gemIdx=gemIdx}
	Net:send(msg,"bag","InlayGem")
end
--卸载宝石
function Equip:unload_gem_c2s(equipType,gemIdx)
	print("发送协议 发送卸载宝石协议",equipType,gemIdx)
	local msg = {equipType=equipType,gemIdx=gemIdx}
	Net:send(msg,"bag","UnloadGem")
end
--升级镶嵌了的宝石
function Equip:gem_level_up_inLay_c2s(equipType,protoId,idx)
	print("发送协议 升级镶嵌了的宝石")
	Net:send({equipType=equipType,protoId=protoId,idx=idx,},"bag","GemLevelUpInLay")
end

-- 获取洗炼信息
function Equip:get_polish_info_c2s()
	print("获取洗炼信息")
	Net:send({},"bag","GetPolishInfo")
end

--保存洗炼属性
function Equip:save_polish_c2s(equipType)
	print("保存洗炼属性",equipType)
	if not LuaItemManager:get_item_obejct("setting"):is_lock() then
		Net:send({equipType=equipType},"bag","SavePolish")
	end
end

--获取洗炼属性
function Equip:get_polish_equip_c2s(equipType)
	Net:send({equipType=equipType},"bag","GetPolishAttr")
end

--洗炼装备
function Equip:polish_equip_c2s(equipType,lock,purple)
	print("发送洗炼协议，guid=",equipType,lock,purple)
	if not LuaItemManager:get_item_obejct("setting"):is_lock() then
		Net:send({equipType=equipType,lock=lock,purple=purple},"bag","PolishEquip")
	end
end

--打造装备
function Equip:formula_equip_c2s(id,protoId,starProtoId)
	-- formulaId 0 :integer    #打造id，对应config/equip_formula中的formulaId
	-- protoId 1 :integer         #用来进行品质保底打造的物品
	-- starProtoId 2 :integer         #用来进行星魂保底打造的物品
	print("发送打造协议",id,protoId,starProtoId)
	if not LuaItemManager:get_item_obejct("setting"):is_lock() then
		Net:send({formulaId=id,protoId=protoId,starProtoId=starProtoId},"bag","FormulaEquip")
	end
end

--获取神器值
function Equip:formula_accumulate_c2s()
	Net:send({},"bag","FormulaAccumulate")
end

--获取强化信息
function Equip:enhance_info_c2s()
	Net:send({},"bag","EnhanceInfo")
end

--强化装备
function Equip:enhance_equip_c2s(equip_type)
	-- --print("发送强化协议",equip_type)
	Net:send({equipType=equip_type},"bag","EnhanceEquip",equip_type)
end

-- 对比是否比身上的装备好 
--[[ 返回三个值 int bool bool
int 1：这件装备更好 -1：这件装备更差 0：评分一样
bool 是否满足等级需求
bool 是否满足职业需求
]]
function Equip:compare_body_equip(equip)
	local equip_data = ConfigMgr:get_config("item")[equip.protoId]
	local game = LuaItemManager:get_item_obejct("game")
	local level = equip_data.level<=game:getLevel()
	local career = equip_data.career==0 or equip_data.career==game:get_career()
	local bodySlot = ServerEnum.BAG_TYPE.EQUIP*10000+equip_data.sub_type
	local body_equip = LuaItemManager:get_item_obejct("bag").items[bodySlot]
	if not body_equip then 
		return 1,level,career
	else
		local body_power = self:calculate_equip_fighting_capacity(body_equip)
		local power = self:calculate_equip_fighting_capacity(equip)
		if power>body_power then
			return 1,level,career
		elseif power<body_power then
			return -1,level,career
		else
			return 0,level,career
		end
	end
end

--计算装备战力
function Equip:calculate_equip_fighting_capacity(equip,enhance_id,gem_data,polish_attr)
	if not equip then
		return 0,0,0,0,0,0,0
	end
	-- gf_print_table(equip,"要计算战力啦")
    local game = LuaItemManager:get_item_obejct("game")

	--获取装备原型数据
	local item_info = ConfigMgr:get_config("item")[equip.protoId]
	local count = 0

	-- 前缀战力
	local prefixPower = 0
	local prefix = ConfigMgr:get_config("equip_prefix")[equip.prefix or 0]
	if prefix and prefix.power then
		prefixPower = prefix.power
	end
	-- print("--基础属性")
	local baseAttrPower = 0
	for k,v in pairs(equip and equip.baseAttr or {}) do
		local power = v.value*self.item_sys:get_combat_attr_fcr(v.attr)
		if prefix and not prefix.power then
			prefixPower = power/10000*prefix.rate
		end
		baseAttrPower = baseAttrPower + power
	end
	-- print("基础--战力--",baseAttrPower)
	baseAttrPower = math.floor(baseAttrPower)
	prefixPower = math.floor(prefixPower)

	--

	-- print("--星级属性")
	local extraAttrPower = 0
	for k,v in pairs(equip and equip.exAttr or {}) do
		-- print("属性"..v.attr,ConfigMgr:get_config("propertyname")[v.attr].name,"值",v.value,"系数",self.item_sys:get_combat_attr_fcr(v.attr),"战力",v.value*self.item_sys:get_combat_attr_fcr(v.attr))
		extraAttrPower = extraAttrPower+v.value*self.item_sys:get_combat_attr_fcr(v.attr)
	end
	-- print("星级--战力--",extraAttrPower)
	extraAttrPower = math.floor(extraAttrPower)

	-- print("--强化属性")
	local enhancePower = 0
	if enhance_id then
		local enhance_data =ConfigMgr:get_config("equip_enhance")[enhance_id]
		for k,v in pairs(enhance_data.add_attr) do
			-- print("属性"..v[1],ConfigMgr:get_config("propertyname")[v[1]].name,"值",v[2],"系数",self.item_sys:get_combat_attr_fcr(v[1]),"战力",v[2]*self.item_sys:get_combat_attr_fcr(v[1]))
			enhancePower = enhancePower+v[2]*self.item_sys:get_combat_attr_fcr(v[1])
		end
		enhancePower = enhancePower
	end
	-- print("强化--战力--",enhancePower)
	enhancePower = math.floor(enhancePower)
	
	--对应部位的镶嵌属性
	local gemPower = 0
	for k,gem_id in pairs(gem_data or {}) do
		if gem_id~=0 then
			local gem_data = self.item_sys:get_item_for_id(gem_id)	--根据原型id获取宝石物品数据
			for i,v in ipairs(gem_data.effect) do
				gemPower = gemPower+v[2]*self.item_sys:get_combat_attr_fcr(v[1])
			end
		end
	end
	-- print("镶嵌--战力--",gemPower)
	gemPower = math.floor(gemPower)

	--洗炼--战力--
	local polishPower = 0
	for i,attrs in ipairs(polish_attr or {}) do
		polishPower = polishPower + attrs.value*self.item_sys:get_combat_attr_fcr(attrs.attr)
	end
	-- print("洗炼--战力--",polishPower)
	polishPower = math.floor(polishPower)

	local power=prefixPower+baseAttrPower+extraAttrPower+enhancePower+gemPower+polishPower

	return power,prefixPower,baseAttrPower,extraAttrPower,enhancePower,gemPower,polishPower
end

--获取下一级宝石(原型ID)
function Equip:get_next_level_gem(gem_id)
	return (gem_id + (gem_id % 2 == 0 and 101 or 1))
end

--获取上一级宝石(原型ID)
function Equip:get_last_level_gem(gem_id)
	return (gem_id - (gem_id % 2 == 1 and 101 or 1))
end

--根据类型获取宝石id（类型，等级）
function Equip:get_gem_for_type(gem_type,level)
	level = level or 1
	return (20000000 + gem_type * 10000 + math.ceil ( level * 0.5 ) * 100 + level)
end

--获取宝石的等级
function Equip:get_gem_level(gemId)
	return gemId%100
end

-- 获取镶嵌宝石等级
function Equip:get_inlay_gem_level()
	local lv = 0
	for i,v in ipairs(self.gem_info) do
		for i,gemId in ipairs(v) do
			if gemId>0 then
				lv = lv + ConfigMgr:get_config("item")[gemId].item_level
			end
		end
	end
	return lv
end

-- 获取可用于升级宝石的宝石id
function Equip:get_level_up_gem(gemId)
	local gem_data = ConfigMgr:get_config("item")[gemId]
	local list = BagUserData:get_item_for_type(gem_data.type,gem_data.sub_type)
	local bag = LuaItemManager:get_item_obejct("bag")
	table.sort( list, function(a,b) return a.item_level>b.item_level end )
	for i,v in ipairs(list) do
		local left_lv = gem_data.item_level - v.item_level
		if left_lv>=0 then
			local have_count = bag:get_item_count(v.code,ServerEnum.BAG_TYPE.NORMAL)
			local need_count = 2
			for i=1,left_lv do
				need_count = need_count * 3
			end
			if have_count>=need_count then
				return v.code,need_count
			end
		end
	end
	return 0,0
end


function Equip:get_gem_target()
	local gem_lv = self:get_inlay_gem_level()
	local cur_attr_level = 0
	local target_attr_level = 9999999
	for lv,attr in pairs(ConfigMgr:get_config("equip_gem_totalLv")) do
		if lv<=gem_lv and cur_attr_level<lv then
			cur_attr_level = lv
		end
		if lv>gem_lv and target_attr_level>lv then
			target_attr_level = lv
		end
	end
	return cur_attr_level,target_attr_level~=9999999 and target_attr_level or 0
end

function Equip:set_open_mode(page1,page2,page3)
	print("设置打开模块",page1,page2,page3)
	self.open_page1 = page1
	self.open_page2 = page2
	self.open_page3 = page3
end

-- 打造浏览
function Equip:formula_browse(formulaId,titleName,min_color)
	print("打造浏览",formulaId,titleName,min_color)
	local list = {}
	local formula_data = ConfigMgr:get_config("equip_formula")[formulaId]
	local item_data = ConfigMgr:get_config("item")[formula_data.code]
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local EquipUserData = require("models.equip.equipUserData")
	local base_attr = {}
	for i,v in ipairs(formula_data.base_attr or {}) do
		base_attr[v[1]] = v[3]
	end
	local ex_attr = {}
	local star_data =ConfigMgr:get_config("equip_star")
	for i,start_id in ipairs(formula_data.star_prob_id or {}) do

		local prob = star_data[start_id].prob[1]
		local prob = (function()
					for _,p in ipairs(star_data[start_id].prob) do
						-- print("星级库判断",p[2],ConfigMgr:get_config("t_misc").formula_browse_star[item_data.sub_type][i],p[2] == ConfigMgr:get_config("t_misc").formula_browse_star[item_data.sub_type][i])
						if p[2] == ConfigMgr:get_config("t_misc").formula_browse_star[item_data.sub_type][i] then
							return p
						end
					end
				end)()
		-- gf_print_table(prob or {},"星级库A"..start_id.." "..ConfigMgr:get_config("t_misc").formula_browse_star[item_data.sub_type][i])
		prob = prob or star_data[start_id].prob[1]
		-- gf_print_table(prob or {},"星级库B"..start_id)
		ex_attr[#ex_attr+1] = {attr=prob[2],value=prob[4]}
	end

	local baseAttr = {}
	local exAttr = {}
	local protoId = formula_data.code
	local color = 1
	local name = string.format("%s\n%d级%s",item_data.name,item_data.level,EquipUserData:get_equip_type_name(item_data.sub_type))
	min_color = min_color or 0
	for i,v in ipairs(formula_data.color_prob or {}) do
		color = v[2]
		if color >= min_color then
			print("品质",color)
			baseAttr = {}
			local color_tax = formula_data["color"..color.."_base_attr"]/10000
			for k,v in pairs(base_attr or {}) do
				print("基础属性",k,"=",v,"*",color_tax,"=",v*color_tax)
				baseAttr[#baseAttr+1] = {attr=k,value=v*color_tax}
			end

			exAttr = color>=formula_data.star_need_color and ex_attr or {}

			list[#list+1] = {
				propId = protoId,
				color = color,
				count = "",
				des = itemSys:give_color_for_string(name,color),
				star = #exAttr,
				equip = {
					protoId = protoId,
					formulaId = formulaId,
					color = color,
					baseAttr = baseAttr,
					exAttr = exAttr,
				},
			}
		end
	end
	-- 增加一件最大品质有特效的装备
	local prefix = formula_data.prefix_prob_t[1]
	if prefix and prefix[2] then
		--前缀加基础属性
		local prefix = ConfigMgr:get_config("equip_prefix")[prefix[2]]
		if prefix and not prefix.power then
			baseAttr = {}
			local color_tax = formula_data["color"..color.."_base_attr"]/10000
			for k,v in pairs(base_attr or {}) do
				print("基础属性",k,"=",v,"*",color_tax,"=",v*color_tax * (1 + prefix.rate / 10000))
				baseAttr[#baseAttr+1] = {attr=k,value=v*color_tax * (1 + prefix.rate / 10000)}
			end
		end

		list[#list+1] = {
			propId = protoId,
			color = color,
			count = "",
			des = itemSys:give_color_for_string(itemSys:get_equip_prefix_name(prefix[2])..name,color),
			star = #exAttr,
			equip = {
				protoId = protoId,
				formulaId = formulaId,
				color = color,
				baseAttr = baseAttr,
				exAttr = ex_attr,
				prefix = prefix[2],
			},
		}
	end
	local result = {}
	for i=#list,1,-1 do
		result[#result+1] = list[i]
	end

	local sel_fn = function(data,pos)
		itemSys:equip_browse(data.equip,nil,nil,nil,pos)
	end
	local view = View("itemList",LuaItemManager:get_item_obejct("itemSys"))
	view:set_data(result,sel_fn,gf_localize_string(titleName or "打造预览"))
end

--[[
formulaId 打造id
color 颜色品质
star 星级
]]
function Equip:formula_tips(formulaId,color,star,pos)
	print(formulaId,color,star,pos)
	local formula_data = ConfigMgr:get_config("equip_formula")[formulaId]
	local item_data = ConfigMgr:get_config("item")[formula_data.code]
	local itemSys = LuaItemManager:get_item_obejct("itemSys")
	local EquipUserData = require("models.equip.equipUserData")
	local color = color or formula_data.color_prob[#formula_data.color_prob][2]

	local ex_attr = {}
	if star or color>=formula_data.star_need_color then
		local star_data =ConfigMgr:get_config("equip_star")
		for i,start_id in ipairs(formula_data.star_prob_id or {}) do
			if star and tonumber(i)>tonumber(star) then
				break
			end
			local prob = star_data[start_id].prob[1]
			local prob = (function()
						for _,p in ipairs(star_data[start_id].prob) do
							if p[2] == ConfigMgr:get_config("t_misc").formula_browse_star[item_data.sub_type][i] then
								return p
							end
						end
					end)()
			prob = prob or star_data[start_id].prob[1]
			ex_attr[#ex_attr+1] = {attr=prob[2],value=prob[4]}
		end
	end

	local baseAttr = {}
	local attr = {}
	local base_attr = {}
	for i,v in ipairs(formula_data.base_attr or {}) do
		base_attr[v[1]] = v[3]
	end
	local color_tax = formula_data["color"..color.."_base_attr"]/10000
	for k,v in pairs(base_attr or {}) do
		baseAttr[#baseAttr+1] = {attr=k,value=v*color_tax}
	end

	local equip = {
		protoId = formula_data.code,
		formulaId = formulaId,
		color = color,
		baseAttr = baseAttr,
		exAttr = ex_attr,
	}
	itemSys:equip_browse(equip,nil,nil,nil,pos)
end

-- 获取装备孔是否开启
function Equip:get_gem_lock_str(equip,index,vipLv)
	local value = ConfigMgr:get_config("t_misc").gem_slot_cond[index]
	if not equip or index == 1 then
		return not equip and gf_localize_string("需穿戴装备") or nil
	elseif index == 2 then
		return ConfigMgr:get_config("item")[equip.protoId].level<value and string.format(gf_localize_string("装备%d级解锁"),value) or nil
	elseif index == 3 then
		return ConfigMgr:get_config("item")[equip.protoId].level<value and string.format(gf_localize_string("装备%d级解锁"),value) or nil
	elseif index == 4 then
		return equip.color<value and string.format(gf_localize_string("%s装备解锁"),LuaItemManager:get_item_obejct("itemSys"):get_color_name(value)) or nil
	elseif index == 5 then
		return equip.color<value and string.format(gf_localize_string("%s装备解锁"),LuaItemManager:get_item_obejct("itemSys"):get_color_name(value)) or nil
	elseif index == 6 then
		return (vipLv or LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv())<value and string.format(gf_localize_string("成为VIP%d解锁"),value) or nil
	end
end

-- 获取装备名称
function Equip:get_equip_name(equip,enhance_id)
	local data = ConfigMgr:get_config("item")[equip.protoId]
	local is_max_enhance = false
	if enhance_id then
		local real_enhance_data = ConfigMgr:get_config("equip_enhance")[enhance_id]
		local left_level = real_enhance_data.level - ConfigMgr:get_config("equip_formula_accumulate")[data.level].max_level
		is_max_enhance = left_level>=0
		enhance_id = left_level<=0 and enhance_id or (enhance_id-left_level)
	end
	local name = (equip and equip.prefix~=0 and LuaItemManager:get_item_obejct("itemSys"):get_equip_prefix_name(equip.prefix) or "")..data.name
	if enhance_id then
		local enhance_info = ConfigMgr:get_config("equip_enhance")[enhance_id]
		name = name .. (is_max_enhance and "+MAX" or (enhance_info.level>0 and string.format("+%d",enhance_info.level)) or "")
	end
	return name
end