--[[
	武将系统数据模块
	create at 17.6.1
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

require("models.hero.heroConfig")
local dataUse = require("models.hero.dataUse")
local dataUse2 = require("models.train.dataUse")
local dataUse3 = require("models.horse.dataUse")


local hero = LuaItemManager:get_item_obejct("hero")

hero.priority = ClientEnum.PRIORITY.HERO 

local Enum = require("enum.enum")
local modelName = "hero"
--UI资源
hero.assets=
{
    View("heroView", hero) ,
}

--点击事件
function hero:on_click(obj,arg)
	--通知事件(点击事件)
	return self:call_event("hero_view_on_click", false, obj, arg)
end


--初始化函数只会调用一次
function hero:initialize()
	print("wtf initialize")
	--武将列表
	self.heroList = {}
	--出战武将
	self.fightIdList = {}
	--
	self.fightingId = -1
	--出战数量
	self.prepareSize = -1
	--阵法数据
	self.frontData = {}
	--生效阵法
	self.effectiveId = 1 					--生效阵法 需求删除 现保留 兼容模式
	--名将录数据
	self.heroBook = {}
	--武将装备
	self.equips = {}
	-- self:add_to_state()
end



--get set *******************************************************************
function hero:get_view_param()
	return self.page_index
end
function hero:set_view_param(index)
	self.page_index = index
end
--获取武将列表
function hero:getHeroList()
	return self.heroList
end

--获取武将是否可觉醒
function hero:get_hero_is_awaken(hero_info)
	if type(hero_info) == "number" then
		hero_info = self:getHeroInfo(hero_info)
	end
	if hero_info then
		local left_chip = gf_getItemObject("hero"):getHeroLeftChip(hero_info.heroId)
		local max_data = dataUse.get_awake_max_data(hero_info.heroId)
		if max_data.awaken_level and hero_info.awakenLevel and max_data.awaken_level > hero_info.awakenLevel then
			local awake_info = dataUse.getHeroAwakeData(hero_info.heroId,hero_info.awakenLevel+1)
			if left_chip >= awake_info.chip_count then
				return true
			end
		end
	end
end

--获取武将是否可升级
function hero:get_hero_can_level_up(hero_info)
	if type(hero_info) == "number" then
		hero_info = self:getHeroInfo(hero_info)
	end
	if hero_info then
		local bag = LuaItemManager:get_item_obejct("bag")
		local data_list = require("models.bag.bagUserData"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.HERO_EXP_BOOK)
		local prop_exp = 0
		for i,v in ipairs(data_list) do
			local count = bag:get_item_count(v.code,ServerEnum.BAG_TYPE.NORMAL,true)
			prop_exp = prop_exp + count*v.effect[1]
		end
		local max_exp = dataUse.getHeroLevelExp(hero_info.level)
		if max_exp==0 then
			return false
		end
		local need_exp = max_exp - hero_info.exp
		return prop_exp>0 and prop_exp>=need_exp
	end
end

--拥有的
function hero:get_hero_have()
	local temp = {}
	for i,v in ipairs(self.heroList or {}) do
		if v.level > 0 then
			table.insert(temp,v)
		end
	end
	return temp
end

--根据战力排序
function hero:getHeroListBySort()
	local fightId = self:getFightId()
	local tb = {}
	if fightId > 0 then
		tb[1] = {}
	end
	
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId ~= fightId then
			table.insert(tb,v)
		elseif v.heroId == fightId then
			tb[1] = v
		end
	end
	return tb
end

--从出战列表或者仓库获取武将天资总值
function hero:getHeroTalentTotal(heroId)
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == heroId then
			return v.talent[Enum.HERO_TALENT_TYPE.FORCE] + v.talent[Enum.HERO_TALENT_TYPE.PHYSIQUE] + v.talent[Enum.HERO_TALENT_TYPE.FLEXABLE]
		end
	end
end


--在出战队列中找到heroid
--@return {heroId,heroId,talent,skill,level,exp .....}
function hero:getHeroIdByHeroByUid(heroId)
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == heroId then
			return v
		end
	end
	print("error get data hero:getHeroIdByHeroByUid ",heroId)
	return nil
end
--获取武将数据 
--@isDelete   是否从列表中删除
function hero:getHeroInfo(id,isDelete) 
	-- gf_print_table(self.heroList, "wtf heroList:")
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == id then
			if isDelete then
				table.remove(self.heroList,i)
			end
			return v
		end
	end
	-- print("error 找不到该武将",id)
	return nil
end
--获取武将阵法加成
function hero:getHeroFrontPropertyAdd(heroId)
	if self.effectiveId > 0 then
		for i,v in ipairs(self.frontData or {}) do
			if v.squareId == self.effectiveId then
				for ii,vv in ipairs(v.posInfo) do
					if vv.heroId == heroId then
						local temp = {}
						temp.posId = vv.posId
						temp.frontId = v.squareId
						temp.level = vv.level
						return temp
					end
				end
			end
		end
	end
	print("erro can not find data hero:getHeroFrontPropertyAdd")
	return nil
end

--获取出战中武将 并且不在阵法中 获取空闲状态的武将 待优化
function hero:getHeroFree()
	local temp = {}
	local frontHeroList = {}
	for ii,vv in ipairs(self.frontData or {}) do
		for iii,vvv in ipairs(vv.posInfo or {}) do
			if vvv.heroId > 0 then
				table.insert(frontHeroList,vvv.heroId)
			end
		end
	end



	for i,v in ipairs(self.heroList or {}) do
		if v.level > 0 then
			table.insert(temp,v)
			for ii,vv in ipairs(frontHeroList or {}) do
				if v.heroId == vv then
					table.remove(temp,#temp)
					break
				end
			end
		end
		
	end 
	return temp
end

--获取战力最高的武将id 跟 战力
--@return power hero_id
function hero:get_top_power()
	local hero_id,power = -1,-1
	local hero_list = self:get_hero_have()
	for i,v in ipairs(hero_list or {}) do
		local d_power = self:get_hero_power(v.heroId)
		if d_power > power then
			hero_id = v.heroId 
			power = d_power
		end
	end
	return power,hero_id
end
--计算武将战力
--@hero_id  武将id
--@talent   需要覆盖计算的天赋
--@skill  	需要覆盖计算的技能
function hero:get_hero_power(hero_id,talent,skill)

	local heroInfo = self:getHeroIdByHeroByUid(hero_id)

	talent = talent and talent or dataUse.getHeroTalentIncludeAwake(hero_id,heroInfo.talent,heroInfo.awakenLevel)
	local property = self:getHeroProperty(hero_id,talent)

	local skill = skill and skill or heroInfo.skill

	local value = self:get_power(property,skill,true)

	return value
end

function hero:getHeroProperty(heroId,talent_ex)
	local heroInfo = self:getHeroIdByHeroByUid(heroId)
	talent_ex = talent_ex and talent_ex or dataUse.getHeroTalentIncludeAwake(heroId,heroInfo.talent,heroInfo.awakenLevel)

	local level = heroInfo.level
	local heroProperty = dataUse.getHeroProperty(heroInfo.heroId)
	--阵眼加成
	local frontAdd = self:getHeroFrontPropertyAdd(heroId) 
	local holeData = frontAdd and dataUse.getHoleDataByIndex(frontAdd.frontId,frontAdd.posId,frontAdd.level) or nil

	--装备加成
	local equipAdd = self:getHeroEquipPropertyAdd(heroId)
	--修炼加成 不计算免伤率 伤害率
	local trainAdd = self:getHeroTrainAdd(heroId)

	local property = {}

	--基础加上其他加成 天资计算公式 攻击=（等级*武力*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3
	for i,v in ipairs(heroProperty) do
		--天资加成
		local rate = dataUse.getHeroTalentRate(v[1])
		local hero_info_talent = heroInfo.talent and heroInfo.talent[rate[2]] or 0 	
		local talent = talent_ex and talent_ex[rate[2]] or hero_info_talent
		hero_info_talent = heroInfo.talent and  heroInfo.talent[4] or 0
		local r_talent = talent_ex and talent_ex[4] or hero_info_talent
		local value = rate[1]
		local addValue = (level * talent * value[1] * 0.01 + level * value[2]) * r_talent * 0.001 + level * (level - 1)  / 2 * value[3]

		--基础加成
		addValue = addValue + v[2]
		--阵法提供加成
		if frontAdd then
			for ii,vv in ipairs(holeData.attr_fixed) do
				if vv[1] == v[1] then
					addValue = addValue + vv[2]
				end
			end
		end

		--装备
		if next(equipAdd or {}) then
			addValue = addValue + (equipAdd[v[1]] or 0)
		end

		--修炼
		addValue = addValue + (trainAdd[v[1]] or 0)
		property[v[1]] = math.floor(addValue)
	end
	--武将生命额外加成
	local train_data = gf_getItemObject("train"):get_train_data_by_type(Enum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH)
	if next(train_data or {}) then
		local train_info = dataUse2.get_train_data_by_level(Enum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH,train_data.level)
		local key = train_info.combat_attr[3][1]
		local value = train_info.combat_attr[3][2]
		local real_key = key % 10000
		if property[real_key] then
			property[real_key] = property[real_key] + property[real_key] * value / 10000
		end
	end
	-- gf_print_table(property, "wtf property2:")
	return property
end
function hero:getHeroTrainAdd(heroId)
	-- local dataUse = require("models.train.dataUse")
	local type = {Enum.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE,Enum.ALLIANCE_TRAIN_TYPE.HERO_PROTECT,Enum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH}
	local property = {}

	
	for i,v in ipairs(type) do
		local train_data = gf_getItemObject("train"):get_train_data_by_type(v)
		local train_info = dataUse2.get_train_data_by_level(v,train_data.level)
		local attr = train_info.combat_attr
		-- local value = train_info.base_add
		for kk,vv in pairs(attr or {}) do
			if not property[vv[1]] then
				property[vv[1]] = 0
			end
			property[vv[1]] = property[vv[1]] + vv[2]
		end
		
	end
	
	return property
end


function hero:getHeroEquipPropertyAdd(heroId)
	local heroInfo = self:getHeroIdByHeroByUid(heroId)
	-- gf_print_table(heroInfo,"wtf heroInfo:")
	local attr = {}
	--如果有装备 
	for k,v in pairs(heroInfo.heroEquipInfo or {}) do
		for ii,vv in ipairs(v.heroEquipAttr or {}) do
			if not attr[vv.attr] then  
				attr[vv.attr] = 0
			end
			attr[vv.attr] = attr[vv.attr] + vv.value
		end
	end
	return attr
end

--获取武将在阵法中给人物的属性加成
function hero:getRoleHeroPropertyAdd()
	local propertyInfo = dataUse.getRoleHeroPropertyAdd()
	local temp = {}
	local frontPropertyAdd = self:getRoleFrontPropertyAdd()
	for i,v in pairs(propertyInfo or {}) do
		local temp2 = {}
		temp2.attr = v
		temp2.value = frontPropertyAdd[temp2.attr] or 0
		table.insert(temp,temp2)
	end
	return temp
end
function hero:getEquipData()
	return self.equips
end
function hero:getRoleFrontPropertyAdd()
	local temp = {}
	-- local dataUse = require("models.hero.dataUse")
	for i,v in ipairs(self.frontData or {}) do
		if v.squareId == self.effectiveId then
			for ii,vv in ipairs(v.posInfo or {}) do
				if vv.heroId > 0 then
					local heroData = self:getHeroProperty(vv.heroId)
					--阵位装入的武将属性给人物进行加成--
					--加成属性 和万分比
					local attr = dataUse.getHoleDataByIndex(v.squareId,vv.posId,vv.level).attr_mul

					for i,v in ipairs(attr) do
						if not temp[v[1]] then
							temp[v[1]] = 0
						end
					end

					for i,v in ipairs(attr) do
						temp[v[1]] = temp[v[1]] + (heroData[v[1]] and (heroData[v[1]] * v[2] / 10000) or 0)
					end
					
				end
			end
		end
	end

	return temp
end

function hero:get_available_skill_item(hero_id)
	local items = gf_getItemObject("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.HERO_SKILL_BOOK,ServerEnum.BAG_TYPE.NORMAL)
	--筛选
	local temp = {}
	for i,v in ipairs(items or {}) do
		if not gf_getItemObject("hero"):is_have_skill(hero_id,v.data.effect[1]) then
			table.insert(temp,v)
		end
	end

	return temp
end

--获取布阵数据
function hero:getFrontData()
	return self.frontData
end
function hero:getFrontDataById(id)
	for i,v in ipairs(self.frontData or {}) do
		if v.squareId == id then
			return v
		end
	end
	print("error 找不到该阵的数据",id)
	return nil
end
--阵法id
--孔位 位置index
function hero:isHoleUnLock(frontId,index)
	for i,v in ipairs(self.frontData or {}) do
		if v.squareId == frontId then
			for ii,vv in ipairs(v.posInfo or {}) do
				if vv.posId == index then
					return true
				end
			end
		end
	end
	return false
end
--获取武将在阵法中的阵位数据
function hero:getHeroHoleData(heroId)
	for i,v in ipairs(self.frontData or {}) do
		for ii,vv in ipairs(v.posInfo or {}) do
			if vv.heroId == heroId then
				return vv
			end
		end
	end
	return nil
end
function hero:getHoleData(frontId,index)
	for i,v in ipairs(self.frontData or {}) do
		if v.squareId == frontId then
			for ii,vv in ipairs(v.posInfo or {}) do
				if vv.posId == index then
					return vv
				end
			end
		end
	end
	print("error:找不到此孔位数据 还未开孔")
	return nil
end
--获取名将录
function hero:getHeroBook()
	return self.heroBook
end
function hero:getBookHeroInfo(id)
	for i,v in ipairs(self.heroBook or {}) do
		if v.heroId == id then
			return v
		end
	end
	print("error 找不到该武将",id)
	return nil
end

function hero:getFightId()
	return self.fightingId--self.fightId
end

function hero:get_fight_hero_info()
	if self:is_fight() then
		local fightId = self:getFightId()
		return self:getHeroInfo(fightId)
	end
	return nil
end

-- 是否出战
function hero:is_fight()
	return self.fightingId > 0
end

function hero:getEffectiveId()
	return self.effectiveId
end
function hero:getHeroPrepareSize()
	return self.prepareSize
end
--获取武将相关道具 
function hero:getHeroTypeBagItem(bag_type)
	local condition = 
	{
		--武将道具
		{Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.POLISH_HERO},
		{Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HERO_EXP_BOOK},
		{Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.HERO_SKILL_BOOK},
		{Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.UNLOCK_HERO_SLOT},
		{Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.WAKE_HERO},
		--武将装备
		{Enum.ITEM_TYPE.EQUIP,Enum.HERO_EQUIP_TYPE.WEAPON},
		{Enum.ITEM_TYPE.EQUIP,Enum.HERO_EQUIP_TYPE.ARMOR},
		{Enum.ITEM_TYPE.EQUIP,Enum.HERO_EQUIP_TYPE.DECORATION},
	}

	local getCondition = function(item,info)
		local bt,st = gf_getItemObject("bag"):get_type_for_protoId(item.protoId)
		if (	(bt == condition[1][1] and st == condition[1][2] ) or 
			(bt == condition[2][1] and st == condition[2][2] ) or 
			(bt == condition[3][1] and st == condition[3][2] ) or 
			(bt == condition[4][1] and st == condition[4][2] ) or 
			(bt == condition[5][1] and st == condition[5][2] ) or 
			(bt == condition[6][1] and st == condition[6][2] ) or 
			(bt == condition[7][1] and st == condition[7][2] ) or 
			(bt == condition[8][1] and st == condition[8][2] )  )
			and (not bag_type or bag_type==math.floor(item.slot/10000)) then
			return true
		else
			return false
		end
	end

	local itemList = gf_getItemObject("bag"):get_item_for_condition_fun(getCondition)
	return itemList
end
--获取武将装备 
--@return {[装备类型type] = 装备数据}
function hero:getHeroEquip(heroId)
	local temp = {}
	for i,v in ipairs(self.heroList or {}) do
		if heroId == v.heroId then
			for ii,vv in ipairs(v.heroEquipInfo or {}) do
				local bt,st = gf_getItemObject("bag"):get_type_for_protoId(vv.protoId)
				temp[st] = vv
			end
		end
	end
	return temp
end


--判断武将是否有次技能
function hero:is_have_skill(hero_id,skill_id)
	local hero_info = self:getHeroInfo(hero_id) 
	for i,v in ipairs(hero_info.skill or {}) do
		if v == skill_id then
			return true
		end
	end
	return false
end

function hero:get_prepare_hero()
	local temp = {}
	for i,v in ipairs(self.heroList or {}) do
		if v.level > 0 then
			table.insert(temp,v)
			for ii,vv in ipairs(self.fightIdList or {}) do
				if vv == v.heroId then
					table.remove(temp,#temp)
				end
			end
		end
	end
	return temp

end

--如果仓库没有 在出战中的武将装备中查找
function hero:get_equip_for_guid(guid)
	for i,v in ipairs(self.equips or {}) do
		if v.guid == guid then
			return v
		end
	end
	for i,v in ipairs(self.fightIdList or {}) do
		local heroInfo = self:getHeroInfo(v)
		for ii,vv in ipairs(heroInfo.heroEquipInfo or {}) do
			if vv.guid == guid then
				return vv
			end
		end
	end
	return nil
end

--获取武将开启技能栏
function hero:get_hero_skill_slot(hero_id)
	local total_count = 8 
	local skill = {}
	local temp = {}

	if not hero_id then
		for i=1,total_count do
			local skill_temp = {}
			skill_temp.skill = -1
			skill_temp.type = -1
			table.insert(skill,skill_temp)
		end
		return skill
	end

	local hero_info = self:getHeroInfo(hero_id) 

	--判断是否30级 
	if hero_info.level < 100 then
		table.insert(temp,1)
	end
	--判断是否一觉
	if hero_info.awakenLevel < 1 then
		table.insert(temp,2)
	end
	--判断是否二觉
	if hero_info.awakenLevel < 2 then
		table.insert(temp,3)
	end

	for i=1,total_count do
		local skill_temp = {}
		if hero_info.skill[i] then   						--有技能
			skill_temp.skill = hero_info.skill[i]
			skill_temp.type = 0 		
		elseif i > total_count - #temp then     			--未解锁
			skill_temp.type = temp[#temp - total_count + i]
		else 												--没放技能
			skill_temp.skill = -1
			skill_temp.type = -1
		end
		table.insert(skill,skill_temp)
	end
	return skill
end



function hero:getFightIdList()
	return self.fightIdList
end

--获取当前武将的碎片 
function hero:getHeroLeftChip(heroId)
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == heroId then
			local total_chip = dataUse.getHeroTotalChip(heroId,v.awakenLevel or 0) or 0
			if v.chip >= dataUse.getHeroAwakeData(heroId,0).chip_count then
				return v.chip - total_chip - dataUse.getHeroAwakeData(heroId,0).chip_count
			end
			return v.chip - total_chip
		end
	end
	return 0
end

--获得cd 出战时间
function hero:get_fight_cd_time()
	return self.fight_cd_time or 0
end

------set -------------------------------------------------------------------------------------
function hero:setHeroWashProperty(msg)
	for i,v in ipairs(self.heroList) do
		if v.heroId == msg.heroId then
			self.heroList[i].polishTalent = msg.talent or {}
			self.heroList[i].polishSkill = msg.skill or {}
			break
		end
	end
end

function hero:set_arg(tag,view,view_param)
	self.view_param = {tag,view,view_param}
end
function hero:get_arg()
	return self.view_param
end
--保存洗炼属性
function hero:setHeroProperty(heroId)
	for i,v in ipairs(self.heroList) do
		if v.heroId == heroId then
			self.heroList[i].talent = self.heroList[i].polishTalent
			self.heroList[i].skill = self.heroList[i].polishSkill
			break
		end
	end
end
function hero:setHeroList(heroList)
	self.heroList = heroList 
end
function hero:setEquipData(equips)
	self.equips = equips
end
function hero:setHeroFightIdList(list)
	self.fightIdList = list
end
-- function hero:setHeroFightId(fightId)
-- 	self.fightingId = fightId
-- end
-- function hero:setHeroStore(heroStore)
-- 	self.heroStore = heroStore
-- end
function hero:setHeorFightingId(fightId)
	print("wtf set HeorFightingId:",fightId)
	self.fightingId = fightId
end
function hero:set_param(...)
	self.param = {...}
end
function hero:get_param()
	return self.param
end
function hero:setFrontData(frontData)
	self.frontData = frontData
end
function hero:setEffectiveId(effectiveId)
	self.effectiveId = effectiveId
end
function hero:setHeroBook(book)
	self.heroBook = book
end
--设置武将出战列表
function hero:setHerPrepareoSize(size)
	self.prepareSize = size
end
--接收到阵位升级或者解锁
function hero:setHole(frontId,index)
	--如果没有找到次孔 添加 有升级
	local holeData = self:getHoleData(frontId, index)
	if holeData then
		holeData.level = holeData.level + 1
	else
		local squarePosInfo = 
		{
			posId = index,
			level = 1,
			heroId  = 0,
		}
		--找到那个frontId 没有创建
		local frontTb = self:getFrontDataById(frontId)
		if not frontTb then
			frontTb  = 
			{
				squareId  = frontId,
				posInfo  = {},
			}
			table.insert(self.frontData,frontTb)
		end
		table.insert(frontTb.posInfo,squarePosInfo)
	end
end




--send ********************************************************************************************************************
--获取武将数据
function hero:sendToGetHeroInfo()
	print("sendToGetHeroInfo")
	local msg = {}
	Net:send(msg,modelName,"GetHeroInfo")
	-- testReceive(msg, modelName, "GetHeroInfoR", sid)
end 
--武将出战
function hero:sendToHeroGotoAttack(heroId)
	print("sendToHeroGotoAttack",heroId)
	local msg = {}
	msg.heroId = heroId
	Net:send(msg,modelName,"SetHeroFight")
end 

--给武将使用经验书
function hero:sendToUseHeroExBook(list,heroId)
	print("sendToUseHeroExBook")
	local msg = {}
	msg.heroId = heroId
	msg.bookList = list

	local sid = Net:set_sid_param(list)

	Net:send(msg,modelName,"AddHeroExpByBook",sid)
end
--开锁
function hero:sendToUnLockHeroSlot()
	local msg = {}
	Net:send(msg,modelName,"UnlockHeroSlot")
	-- local size = self:getHeroPrepareSize()
	-- testReceive(msg, modelName, "UnlockHeroSlotR", size + 1)
end
--解锁或者升级阵法槽位
function hero:sendToUnlockFrontHold(frontId,posId)
	if not frontId or not posId then
		return
	end
	local msg = {}
	msg.squareId = frontId
	msg.pos = posId
	Net:send(msg,modelName,"UnlockSquarePos")
end

function hero:sendToAwakenHero(heroId)
	local msg = {}
	msg.heroId = heroId
	local hero_data = self:getHeroInfo(heroId)
	local chip = dataUse.getHeroAwakeData(heroId,hero_data.awakenLevel).chip_count
	local sid = Net:set_sid_param(heroId,chip)
	Net:send(msg,modelName,"AwakenHero",sid)
end

function hero:sendToGetTalentItemHistory(heroId)
	local msg = {}
	msg.heroId = heroId
	Net:send(msg,modelName,"GetTalentItemHistory")
	
end
--唤魂
function hero:sendToCreateHero(heroId,guid)
	print("sendToCreateHero")
	if not heroId then
		return
	end
	local msg = {}
	msg.guid = guid
	msg.heroId = heroId
	Net:send(msg,modelName,"WakeUpHero")
	-- if not self.testUid then
	-- 	self.testUid =0
	-- end
	-- self.testUid = self.testUid + 1
	-- testReceive(msg, modelName, "WakeUpHeroR",{self.testUid,heroId,{1,1,1},{1,2,3}})
end

function hero:send_to_rest()
	local msg = {}
	Net:send(msg,modelName,"Rest")
end
--为武将穿上装备
function hero:sendToEquip(heroId,guid)
	local msg = {}
	msg.guid = guid
	msg.heroId = heroId
	Net:send(msg,modelName,"SetHeroEquip")
end
--使用技能书
function hero:sendToUseSkillBook(heroId,guid,index)
	if not heroId then
		return
	end
	local msg = {}
	msg.guid = guid
	msg.heroId = heroId
	msg.skillIdx = index
	Net:send(msg,modelName,"GainSkillByBook")
end
--放生 炼魂
function hero:sendToLetItGo(heroId)
	local msg = {}
	msg.heroId = heroId
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	
	Net:send(msg,modelName,"RecycleHero")
	gf_print_table(msg, "sendToLetItGo:")
end
--设置阵法
function hero:sendToSetEffectiveFront(frontId)
	if not frontId then
		return
	end
	local msg = {}
	msg.squareId = frontId
	Net:send(msg,modelName,"SetSquare")
end
--洗炼
function hero:sendToPolishHero(heroId,lockSkillIdArr,bIntAutoBuy)
	if not heroId then
		return
	end
	local msg = {}
	msg.heroId = heroId
	msg.lockSkillIdArr = lockSkillIdArr
	msg.bIntAutoBuy = bIntAutoBuy and 1 or 0
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	
	Net:send(msg,modelName,"PolishHero")
	gf_print_table(msg, "sendToPolishHero")
end
--将武将放到阵位上
function hero:sendToPushHeroOnHole(heroId,squareId,pos)
	local msg = {}
	msg.heroId = heroId
	msg.squareId = squareId
	msg.pos = pos
	Net:send(msg,modelName,"PutHeroToSquarePos")
end
--将武将放入仓库
function hero:sendToPushHeroToStore(heroId)
	local msg = {}
	msg.heroId = heroId
	Net:send(msg,modelName,"SlotHeroToWare")
end

--将武将放入待战队列
function hero:sendToPushHeroToList(heroId)
	local msg = {}
	msg.heroId = heroId
	Net:send(msg,modelName,"WareHeroToSlot")
end

--查看别人的武将
function hero:sendToCheckOtherHero(roleId,heroId)
	local msg = {} 
	msg.roleId = roleId
	msg.heroId = heroId
	-- gf_print_table(msg, "sendToCheckOtherHero")
	Net:send(msg,"hero","OtherPlayerHero")
end
--保存洗炼
function hero:sendToSaveWash(heroId)
	local msg = {} 
	msg.heroId = heroId
	if LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end	
	Net:send(msg,"hero","SavePolishHero")
	gf_print_table(msg, "SavePolishHero")
end
--修改名字
function hero:sendToNameHero(heroId,name)
	local msg = {} 
	msg.heroId = heroId
	msg.name = name
	Net:send(msg,modelName,"RenameHero")
	gf_print_table(msg, "RenameHero")
end


--使用添加天赋道具
function hero:send_to_add_talent(heroId,talentType,countType)
	local msg = {} 
	msg.heroId = heroId
	msg.talentType = talentType
	msg.countType = countType
	Net:send(msg,modelName,"AddTalentByItem")
end


function hero:send_to_add_to_fight_list(heroId,action)
	local msg = {} 
	msg.heroId = heroId
	msg.action = action
	Net:send(msg,modelName,"SetHeroToFightList")
end

function hero:sendUnloadHeroEquip(heroId,guid)
	local msg = {} 
	msg.heroId = heroId
	msg.guid = guid
	Net:send(msg,modelName,"UnloadHeroEquip")
end



--rec ************************************************************************
function hero:recHeroInfo(msg)
	self:setHeroList(msg.hero)
	self:setHeroFightIdList(msg.fightHeroIdList)
	self:setHeorFightingId(msg.fightIngHeroId)
	self:setFrontData(msg.square)
	-- self:setEffectiveId(msg.squareId)
	self:setHerPrepareoSize(msg.size)
	self:setEquipData(msg.heroEquips)
	-- self:setHeroStore(msg.wareHero)
end
--接收到返回数据 如果待战列表没满放入待战列表 否则 放入仓库
--isCallUp  是否是召唤  
function hero:recCreateHeroBack(msg,isCallUp)
	local heroInfo = 
	{
		chip 			= 	msg.chip,
		heroId     		=   msg.heroId,
		level     		=   1,
		awakenLevel 	= 	0,
		exp     		=   0,
		deadTime     	=   0,
		talent     		=   msg.talent,
		heroEquipInfo   =   {},
		skill    		=   msg.skills,
		name 			= 	""
	} 
	if msg.fightIdx > 0 then
		self.fightIdList[msg.fightIdx] = msg.heroId	
	end	

	table.insert(self.heroList,heroInfo)
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == msg.heroId and i ~= #self.heroList then
			self.heroList[i] = heroInfo
			table.remove(self.heroList,#self.heroList)
		end
	end
	--如果没有武将 设置为出战
	-- if #self.heroList == 1 then
	-- 	self:setHeorFightingId(msg.heroId)
	-- end
	
	--弹框提醒 
	if isCallUp then
		require("models.horse.showTips")(1,msg.heroId)
	end
end

function hero:find_equip(guid)
	for i,v in ipairs(self.equips or {}) do
		if v.guid == guid then
			return v
		end
	end
end
function hero:find_hero_equip(heroId,guid)
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == heroId then
			for i,v in ipairs(v.heroEquipInfo or {}) do
				if v.guid == guid then
					return v
				end
			end
		end
	end
end
function hero:remove_equip(guid)
	for i,v in ipairs(self.equips or {}) do
		if v.guid == guid then
			local temp = self.equips[i]
			table.remove(self.equips,i)
			return temp
		end
	end
end
function hero:add_equip(equip)
	table.insert(self.equips,equip)
end


function hero:recUnloadHeroEquipR(msg)
	if msg.err ~= 0 then
		return
	end
	--删除武将身上的装备
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == msg.heroId then
			--找到这个装备 如果没有加入table 如果有替换
			local protoId = self:find_hero_equip(msg.heroId,msg.guid).protoId
			local cBt,cSt = gf_getItemObject("bag"):get_type_for_protoId(protoId)
			
			for ii,vv in ipairs(v.heroEquipInfo or {}) do
				local bt,st = gf_getItemObject("bag"):get_type_for_protoId(vv.protoId)
				if cBt == bt and cSt == st then
					self:add_equip(v.heroEquipInfo[ii])
					-- v.heroEquipInfo[ii] = {}
					table.remove(v.heroEquipInfo,ii)
					
					return
				end
			end
			return
		end
	end
end

function hero:recEquipBack(msg)
	if msg.err ~= 0 then
		return
	end
	--设置武将身上的装备
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == msg.heroId then
			--找到这个装备 如果没有加入table 如果有替换
			local protoId = self:find_equip(msg.guid).protoId
			local cBt,cSt = gf_getItemObject("bag"):get_type_for_protoId(protoId)
			local temp = self:remove_equip(msg.guid)
			for ii,vv in ipairs(v.heroEquipInfo or {}) do
				local bt,st = gf_getItemObject("bag"):get_type_for_protoId(vv.protoId)
				if cBt == bt and cSt == st then
					local bag_temp = self.heroList[i].heroEquipInfo[ii]
					self.heroList[i].heroEquipInfo[ii] = temp
					--放回仓库
					self:add_equip(bag_temp)
					return
				end
			end
			
			table.insert(v.heroEquipInfo,temp)
			
			return
		end
	end
end
function hero:recUseSkillBookBack(msg)
	--武将技能修改
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == msg.heroId then
			--替换掉技能
			v.skill[msg.skillIdx] = msg.skillId
		end
	end
end

function hero:recFrontSwitch(msg)
	if msg.err ~= 0 then
		return
	end
end
function hero:recHoleUnlockOrLevelUp(msg)
	if msg.err == 0 then
		self:setHole(msg.squareId,msg.pos)
	end
end
--接收到使用经验书返还
function hero:recUseExBook(msg)
	--不管成功失败 都要同步一下数据
	-- if msg.err == 0 then
		--修改武将经验
		for i,v in ipairs(self.heroList or {}) do
			if v.heroId == msg.heroId then
				v.exp = msg.exp
				if msg.level>v.level then
					 -- 角色、坐骑、武将升级时播放的音效
					 Sound:play(ClientEnum.SOUND_KEY.LEVEL_UP)
				end
				v.level = msg.level
			end
		end
	-- end
end
--接收到洗炼返回
function hero:recPolishHero(msg)
	if msg.err == 0 then
		--修改武将天赋
		self:setHeroWashProperty(msg)
	end
end

--接收到武将装入阵法孔返回
function hero:recHeroPushOnHoleBack(msg)
	if msg.err == 0 then
		--修改阵法阵位武将
		for i,v in ipairs(self.frontData or {}) do
			if v.squareId == msg.squareId then
				for ii,vv in ipairs(v.posInfo or {}) do
					if vv.posId == msg.pos then
						vv.heroId = msg.heroId
						break
					end
				end
			end
		end
	end
end

--炼魂返回
function hero:recRecycleBack(msg)
	if msg.err == 0 then
		for i,v in ipairs(self.heroList or {}) do
			if v.heroId == msg.heroId then
				self.heroList[i].talent = msg.talent
				self.heroList[i].skill 	= msg.skill
				self.heroList[i].polishTalent = {}
				self.heroList[i].polishSkill  = {}
				self.heroList[i].heroEquipInfo  = {}
				self.heroList[i].level  = 1
				self.heroList[i].exp  = 0
				self.heroList[i].awakenLevel  = 0
				return
			end
		end
	end

end

function hero:removeHeroFromHole(heroId)
	--从阵位中删除
	for i,v in ipairs(self.frontData or {}) do
		for ii,vv in ipairs(v.posInfo or {}) do
			if vv.heroId ==  heroId then
				v.posInfo[ii].heroId = 0
				return 
			end
		end
	end
end


function hero:recRemoveToList(msg)
	if msg.err == 0 then
		local heroInfo = self:getHeroInfoFromStore(msg.heroId,true)
		table.insert(self.heroList,heroInfo) 
	end
end
 
function hero:rec_save_wash(msg)
    if msg.err == 0 then
		self:setHeroProperty(msg.heroId)
		self:setHeroWashProperty(msg)
    end
end
function hero:rec_hero_name(msg)
    if msg.err == 0 then
		for i,v in ipairs(self.heroList or {}) do
			if v.heroId == msg.heroId then
				self.heroList[i].name = msg.name
			end
		end
    end
end

function hero:rec_hero_talent_add(msg)
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == msg.heroId then
			v.talent[msg.talentType] = msg.talentValue
		end
	end
end

function hero:remove_fight_list(hero_id)
	for i,v in ipairs(self.fightIdList or {}) do
		if v == hero_id then
			table.remove(self.fightIdList,i)
			break
		end
	end
end

function hero:rec_hero_awaken(msg,sid)
	--觉醒成功后 觉醒等级加1 碎片减掉觉醒的消耗
	if msg.err == 0 then
		local hero_id,chip = unpack(Net:get_sid_param(sid))
		for i,v in ipairs(self.heroList or {}) do
			if v.heroId == hero_id then
				self.heroList[i].awakenLevel = self.heroList[i].awakenLevel + 1
				-- self.heroList[i].chip = self.heroList[i].chip - chip
				return
			end
		end
	end
end

function hero:rec_hero_add_to_fight(msg)
	if msg.err == 0 then
		if msg.action == 1 then
			table.insert(self.fightIdList,msg.heroId)
		else
			self:remove_fight_list(msg.heroId)
		end
	end
end

function hero:gain_hero_chip_r(msg)

	local hero_name = dataUse.getHeroName(msg.heroId)
	local color = gf_getItemObject("itemSys"):get_item_color(dataUse.getHeroQuality(msg.heroId))
	print("color:",color)

	local get_chip = 0

	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == msg.heroId then
			get_chip = msg.chip - self.heroList[i].chip
			self.heroList[i].chip = msg.chip
			if get_chip > 0 then
				gf_message_tips(string.format("获得<color=%s>%s</color>碎片*%d",color,hero_name,get_chip))
			end
			
			return
		end
	end 
	get_chip = msg.chip
	if get_chip > 0 then
		gf_message_tips(string.format("获得<color=%s>%s</color>碎片*%d",color,hero_name,get_chip))
	end
	--如果没有此武将碎片 构造一个武将数据
	local HeroInfo = 
	{ 
		chip					=msg.chip,
		heroId 					=msg.heroId,
		level 					=0,
	}
	table.insert(self.heroList,HeroInfo)
end

function hero:get_power(attr,skillIdList,bCeil)
	-- gf_print_table(attr,"wtf attr:")
	--特殊计算的属性
	local hero_attr_ex = 
	{
		[ServerEnum.COMBAT_ATTR.FINAL_DAMAGE_PROB] 		={ServerEnum.COMBAT_ATTR.ATTACK},
		[ServerEnum.COMBAT_ATTR.DAMAGE_DOWN_PROB]		={ServerEnum.COMBAT_ATTR.PHY_DEF,ServerEnum.COMBAT_ATTR.MAGIC_DEF},
	}

	local rate_attr = gf_get_config_table("propertyname")
  	local power = 0
	 
	for i,v in pairs(attr or {}) do 
		power = power + v * rate_attr[i].conefficient / 10000
	end

	local get_ex_power = function(type)
		local train_data = gf_getItemObject("train"):get_train_data_by_type(type)
		local train_info = dataUse2.get_train_data_by_level(type,train_data.level)
		local key = train_info.combat_attr[3][1]
		local value = train_info.combat_attr[3][2]
		print("wtf add value:",key)
		if hero_attr_ex[key] then
			local pw = 0
			for i,v in ipairs(hero_attr_ex[key]) do
				if attr[v] then
					pw = pw + attr[v] * rate_attr[v].conefficient / 10000 * value / 10000
				end
			end
			power = power + pw
		end
		
	end

	--额外计算的伤害率
	get_ex_power(Enum.ALLIANCE_TRAIN_TYPE.HERO_PROTECT)
	--额外计算的免伤率
	get_ex_power(Enum.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE)
	
	local skillCfg = ConfigMgr:get_config("skill")
	for i,v in ipairs(skillIdList or {}) do
	    if v > 0 then
	      	power = power + skillCfg[v].power
	    end
	end

	if bCeil then
	    power = math.ceil(power)
	end

	return power
end

function hero:get_name(hero_id)
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == hero_id then
			return v.name or ""
		end
	end
end

--如果全部武将死掉了 获取最短的那个倒计时
function hero:get_relive_timestamp()
	if not next(self.fightIdList or {}) then
		return 0
	end
	local temp = {}
	for i,v in ipairs(self.fightIdList or {}) do
		local heroData = self:getHeroInfo(v)
		if (heroData.deadTime + ConfigMgr:get_config("t_misc").hero.relive_time) <= Net:get_server_time_s() then
			return 0
		end
		table.insert(temp,heroData.deadTime)
	end
	
	table.sort(temp,function(a,b)return a < b end)
	local relive_time = next(temp or {}) and temp[1] + ConfigMgr:get_config("t_misc").hero.relive_time
	print("最小复活时间",relive_time)
	return relive_time
end

--判断是否有武将死掉了 
function hero:get_is_have_hero_dead()
	for i,v in ipairs(self.fightIdList or {}) do
		local heroData = self:getHeroInfo(v)
		if (heroData.deadTime + ConfigMgr:get_config("t_misc").hero.relive_time) > Net:get_server_time_s() then
			return true
		end
	end
	return false
end
function hero:get_hero_is_dead(heroId)
	for i,v in ipairs(self.fightIdList or {}) do
		if heroId == v then
			local heroData = self:getHeroInfo(v)
			if (heroData.deadTime + ConfigMgr:get_config("t_misc").hero.relive_time) > Net:get_server_time_s() then
				return true
			end
			return false
		end
		
	end
	return false
end
--重新获取出战武将id
function hero:reset_hero_fighting()
	local temp = {}
	for i,v in ipairs(self.fightIdList or {}) do
		local heroData = self:getHeroInfo(v)
		table.insert(temp,{v,heroData.deadTime})
	end
	table.sort(temp,function(a,b)return a[2] < b[2] end)
	--如果是出战中 重新获取出战武将id
	if self:getFightId() > 0 then
		self:setHeorFightingId(temp[1][1])
	end
	
	gf_receive_client_prot(nil,ClientProto.HeroFightOrRest)
end


function hero:rec_hero_dead(msg)
	if msg.heroId > 0 then
		self:setHeorFightingId(msg.heroId)
	end
	for i,v in ipairs(self.heroList or {}) do
		if v.heroId == msg.deadHeroId then
			self.heroList[i].deadTime = msg.deadTime
		end
	end
	gf_print_table(self.heroList, "wtf deadHeroId")
	gf_receive_client_prot(nil,ClientProto.HeroFightOrRest)
end


function hero:rec_equip_list(msg)
	for i,v in ipairs(msg.list or {}) do
		local item = ConfigMgr:get_config("item")[v.protoId]
		local color = gf_getItemObject("itemSys"):get_item_color(item.color)
		gf_message_tips(string.format("获得武将装备<color=%s>%s</color>",color,item.name))
		table.insert(self.equips,v)
	end
end

--人物复活时 清空所有武将死亡时间
function hero:reset_hero_dead_time()
	for i,v in ipairs(self.fightIdList or {}) do
		local heroData = self:getHeroInfo(v)
		heroData.deadTime = 0
	end
	self:reset_hero_fighting()
end

--服务器返回
function hero:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1(modelName))then
        if id2 == Net:get_id2(modelName, "GetHeroInfoR") then
       		gf_print_table(msg,"wtf receive GetHeroInfoR")
       		self:recHeroInfo(msg)
       		--发送客户端协议
       		gf_receive_client_prot(nil,ClientProto.HeroFightOrRest)

       	elseif id2== Net:get_id2(modelName, "SetHeroFightR") then
       		gf_print_table(msg, "接收到武将出战返回协议")
       		if msg.err == 0 then
       			--设置cd
       			self.fight_cd_time = Net:get_server_time_s() + 10
       			self:setHeorFightingId(msg.heroId)
       		end
       		--发送客户端协议
       		gf_receive_client_prot(nil,ClientProto.HeroFightOrRest)

       	elseif id2== Net:get_id2(modelName, "UnlockHeroSlotR") then
			gf_print_table(msg, "接收到出战开锁返回协议")
       		if msg.err == 0 then
       			self:setHerPrepareoSize(msg.size)
       		end

        elseif id2 == Net:get_id2(modelName,"SetHeroEquipR") then
        	gf_print_table(msg, "接收到武将装备上装备返回")
        	self:recEquipBack(msg)

        elseif id2 == Net:get_id2(modelName,"GainSkillByBookR") then
        	gf_print_table(msg, "接收到武将使用技能书返回")
        	self:recUseSkillBookBack(msg)

        elseif id2 == Net:get_id2(modelName,"GainHeroR") then
 			-- 获得坐骑、武将时的专用音效
 			Sound:play(ClientEnum.SOUND_KEY.GET_PARTNER)
        	gf_print_table(msg, "GainHeroR接收到召唤返回数据")
        	self:recCreateHeroBack(msg,true)
        	self:setHeroWashProperty({talent = {},skill = {}})
        	gf_receive_client_prot(nil,ClientProto.HeroFightOrRest)

        elseif id2 == Net:get_id2(modelName,"CurrentFightHeroR") then
        	gf_print_table(msg, "接收到武将出战切换")
        	self:setHeorFightingId(msg.heroId)
        	gf_receive_client_prot(nil,ClientProto.HeroFightOrRest)

        elseif id2 == Net:get_id2(modelName,"SetSquareR") then
        	gf_print_table(msg, "接收到阵法切换")
        	self:recFrontSwitch(msg)

        elseif id2 == Net:get_id2(modelName,"UnlockSquarePosR") then
        	gf_print_table(msg, "接收到阵位解锁或者升级")
        	self:recHoleUnlockOrLevelUp(msg)

        elseif id2 == Net:get_id2(modelName,"AddHeroExpByBookR") then
        	gf_print_table(msg, "接收到使用经验书")
        	self:recUseExBook(msg)

        elseif id2 == Net:get_id2(modelName,"PolishHeroR") then
        	gf_print_table(msg, "接收到洗炼武将")
        	self:recPolishHero(msg)

        elseif id2 == Net:get_id2(modelName,"PutHeroToSquarePosR") then
        	gf_print_table(msg, "接收到武将装入阵法返回")
        	self:recHeroPushOnHoleBack(msg)

        elseif id2 == Net:get_id2(modelName,"RecycleHeroR") then
        	gf_print_table(msg, "接收到武将炼魂返回")
        	self:recRecycleBack(msg)

        elseif id2 == Net:get_id2(modelName,"SlotHeroToWareR") then
        	gf_print_table(msg, "接收到武将从战斗队列移到仓库")
        	self:recRemoveToStore(msg)

        elseif id2 == Net:get_id2(modelName,"WareHeroToSlotR") then
        	gf_print_table(msg, "接收到武将从仓库移到战斗队列")
        	self:recRemoveToList(msg)

        elseif id2 == Net:get_id2(modelName ,"SavePolishHeroR") then
        	gf_print_table(msg, "SavePolishHeroR")
        	self:rec_save_wash(msg)
        	
        elseif id2 == Net:get_id2(modelName ,"RenameHeroR") then
        	gf_print_table(msg, "RenameHeroR")
        	self:rec_hero_name(msg)


       	elseif id2 == Net:get_id2(modelName ,"AddTalentByItemR") then
       		gf_print_table(msg, "RenaAddTalentByItemRmeHeroR")
        	self:rec_hero_talent_add(msg)

        elseif id2 == Net:get_id2(modelName ,"SetHeroToFightListR") then
		   	gf_print_table(msg, "SetHeroToFightListR")
        	self:rec_hero_add_to_fight(msg)    	

        elseif id2 == Net:get_id2(modelName ,"AwakenHeroR") then
        	gf_print_table(msg, "AwakenHeroR")
        	self:rec_hero_awaken(msg,sid)    

        elseif id2 == Net:get_id2(modelName ,"GainHeroChipR") then
        	gf_print_table(msg, "wtf GainHeroChipR")
        	self:gain_hero_chip_r(msg)

        elseif id2 == Net:get_id2(modelName ,"UnloadHeroEquipR") then
        	gf_print_table(msg, "UnloadHeroEquipR wtf")
        	self:recUnloadHeroEquipR(msg)

        elseif id2 == Net:get_id2(modelName ,"RestR") then
			self:setHeorFightingId(-1)
			gf_receive_client_prot(nil,ClientProto.HeroFightOrRest)

		elseif id2 == Net:get_id2(modelName ,"HeroDieR") then
			gf_print_table(msg, "HeroDieR wtf")
			self:rec_hero_dead(msg)

		elseif id2 == Net:get_id2(modelName ,"UpdateHeroEquipR") then
			gf_print_table(msg, "UpdateHeroEquipR wtf")
			self:rec_equip_list(msg)

        end

    end

    if id1 == ClientProto.PlayerRelive then
		self:reset_hero_dead_time()
	end
end















------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--测试
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function hero:test_rec_hero_info()

	local EquipAttrR1 = 
	{
		attr = 1,
		value = 100,
	}
	local EquipAttrR2 = 
	{
		attr = 2,
		value = 100,
	}
	local HeroEquip = 
	{
		guid 				=1,
		num 				=1,
		protoId 			=14910001,
		createId 			=1,
		slot 				=1,   
		heroEquipAttr 		={EquipAttrR1,EquipAttrR2},	
		skills 				={},
	}

	--#武将信息
	local HeroInfo = 
	{ 
		chip					=10,
		heroId 					=440001,
		level 					=1,
		awakenLevel 			=3, 
		exp 					=32000/0.8,
		deadTime				=0,
		talent					={1800,1300,1000,1500},
		skill					={12001001,}, 
		heroEquipInfo 			={HeroEquip,},
		name 					="wtf",
		polishTalent 			= {1801,1301,1001,1501},
		polishSkill 			= {12002001,}, 
	}
	local HeroInfo2 = 
	{ 
		chip					=10,
		heroId 					=440004,
		level 					=1,
		awakenLevel 			=0,
		exp 					=100,
		deadTime				=0,
		talent					={3000,3000,3000,1500},
		skill					={12001001,}, 
		heroEquipInfo 			={HeroEquip,},
		name 					="wtf",
		polishTalent 			= {1801,1301,1001,1501},
		polishSkill 			= {12002001,}, 
	}
	local HeroInfo3 = 
	{ 
		chip					=10,
		heroId 					=410001,
		level 					=1,
		awakenLevel 			=0,
		exp 					=100,
		deadTime				=0,
		talent					={1800,1300,1000,1500},
		skill					={12001001,}, 
		heroEquipInfo 			={HeroEquip,},
		name 					="wtf",
		polishTalent 			= {1801,1301,1001,1501},
		polishSkill 			= {12002001,}, 
	}
	local HeroInfo4 = 
	{ 
		chip					=10,
		heroId 					=410007,
		level 					=99,
		awakenLevel 			=0,
		exp 					=100,
		deadTime				=0,
		talent					={1800,1300,1000,1500},
		skill					={12001001,}, 
		heroEquipInfo 			={HeroEquip,},
		name 					="wtf",
		polishTalent 			= {1801,1301,1001,1501},
		polishSkill 			= {12002001,}, 
	}
	local HeroInfo5 = 
	{ 
		chip					=10,
		heroId 					=410005,
		level 					=1,
		awakenLevel 			=2,
		exp 					=100,
		deadTime				=0,
		talent					={1800,1300,1000,1500},
		skill					={12001001,}, 
		heroEquipInfo 			={HeroEquip,},
		name 					="wtf",
		polishTalent 			= {1801,1301,1001,1501},
		polishSkill 			= {12002001,}, 
	}
	local HeroInfo6 = 
	{ 
		chip					=10,
		heroId 					=440007,
		level 					=1,
		awakenLevel 			=0,
		exp 					=100,
		deadTime				=0,
		talent					={1800,1300,1000,1500},
		skill					={12001001,}, 
		heroEquipInfo 			={HeroEquip,},
		name 					="wtf",
		polishTalent 			= {1801,1301,1001,1501},
		polishSkill 			= {12002001,}, 
	}
    local GetHeroInfoR = 
	{
		hero 					= {HeroInfo2,HeroInfo6,HeroInfo5,HeroInfo,HeroInfo3,HeroInfo4},
		size 					= 6,
		fightHeroIdList 		= {440004,440007,410005,440001,410001,410007},
		fightIngHeroId 			= 440001,
		square 					= {},
		squareId 				= 1,
		rest					= 0,
		heroEquips				= {HeroEquip,HeroEquip,HeroEquip},
	}

	gf_send_and_receive(GetHeroInfoR, "hero", "GetHeroInfoR", sid)


end



function hero:test_hero_dead(heroId,heroId21)
	local msg = {}
	msg.heroId = heroId21
	msg.deadHeroId = heroId
	msg.deadTime = Net:get_server_time_s()
	gf_send_and_receive(msg, "hero", "HeroDieR", sid)
end

function hero:test_rename(hero_id,name)
	--修改名字
	local msg = {}
	msg.heroId = hero_id
	msg.err = 0
	msg.name = name
	gf_send_and_receive(msg, "hero", "RenameHeroR", sid)
end

function hero:test_add_talent(heroId,type)
	local msg = {}
	msg.heroId = heroId
	msg.err = 0
	msg.talentType = type
	msg.talentValue = math.random(1,100)
	gf_send_and_receive(msg, "hero", "AddTalentByItemR", sid)
end

function hero:test_add_to_fight(heroId,action)
	local msg = {}
	msg.heroId = heroId
	msg.err = 0
	msg.action = action
	gf_send_and_receive(msg, "hero", "SetHeroToFightListR", sid)
end

function hero:test_add_to_unlock()
	local msg = {}
	msg.err = 0
	msg.size = self:getHeroPrepareSize() + 1
	gf_send_and_receive(msg, "hero", "UnlockHeroSlotR", sid)
end


--[[
		-- local function cal_power(key)
	-- 	if hero_attr_ex[key] then
	-- 		local pw = 0
	-- 		for i,v in ipairs(hero_attr_ex[key]) do
	-- 			pw = pw + attr[v] * rate_attr[v].conefficient / 10000
	-- 		end
	-- 		return pw
	-- 	else
	-- 		return attr[key] * rate_attr[key].conefficient / 10000
	-- 	end
		
	-- end

 --  	for i,v in pairs(hero_attr1 or {}) do
 --    	if attr[v] then
 --    		power = power + cal_power(v)
 --    	end
 --  	end
   	
 --   	for i,v in pairs(hero_attr2 or {}) do
 --    	if attr[v] then
	--       	power = power + cal_power(v)
 --    	end
 --  	end
]]