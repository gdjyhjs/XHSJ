--武将数据表接口
local heroTable = ConfigMgr:get_config("hero")
local extendTable = ConfigMgr:get_config("hero_inherit")
local holeTable = ConfigMgr:get_config("hero_square")
local frontTable = ConfigMgr:get_config("total_square")
local lvExpTable = ConfigMgr:get_config("hero_level")
local recycleTable = ConfigMgr:get_config("hero_recycle")
local openTable = ConfigMgr:get_config("hero_open")
local awakeTable = ConfigMgr:get_config("hero_awaken")
local itemTable = ConfigMgr:get_config("item")

local data = ConfigMgr:get_config("t_misc").hero.combat_coefficient

local Enum = require("enum.enum")
--天资对换比例  
local talentRate =
{	--类型										--加成比例    加成主体
	[Enum.COMBAT_ATTR.ATTACK]     	 			= {data[1],			Enum.HERO_TALENT_TYPE.FORCE},
	[Enum.COMBAT_ATTR.CRIT]     	 			= {data[2],			Enum.HERO_TALENT_TYPE.FORCE},
	[Enum.COMBAT_ATTR.HIT]     	 				= {data[3],			Enum.HERO_TALENT_TYPE.FORCE},
	[Enum.COMBAT_ATTR.THROUGH]     	 			= {data[4],			Enum.HERO_TALENT_TYPE.FORCE},
	[Enum.COMBAT_ATTR.HP]     	 				= {data[5],			Enum.HERO_TALENT_TYPE.PHYSIQUE},
	[Enum.COMBAT_ATTR.CRIT_DEF]     	 		= {data[6],			Enum.HERO_TALENT_TYPE.PHYSIQUE},
	[Enum.COMBAT_ATTR.DAMAGE_DOWN]     	 		= {data[7],			Enum.HERO_TALENT_TYPE.PHYSIQUE},
	[Enum.COMBAT_ATTR.BLOCK]     	 			= {data[8],			Enum.HERO_TALENT_TYPE.PHYSIQUE},
	[Enum.COMBAT_ATTR.DODGE]     	 			= {data[9],			Enum.HERO_TALENT_TYPE.FLEXABLE},
	[Enum.COMBAT_ATTR.PHY_DEF]     	 			= {data[10],		Enum.HERO_TALENT_TYPE.FLEXABLE},
	[Enum.COMBAT_ATTR.MAGIC_DEF]     	 		= {data[11],		Enum.HERO_TALENT_TYPE.FLEXABLE},
	[Enum.COMBAT_ATTR.RECOVER]     	 			= {data[12],		Enum.HERO_TALENT_TYPE.FLEXABLE},
}

--武将类型对应icon 
-- local heroIconTagType = 
-- {
-- 	[Enum.HERO_TYPE.NORMAL] 			= "img_wujiang_level_01",          	--凡将
-- 	[Enum.HERO_TYPE.FAMOUS] 			= "img_wujiang_level_02",          	--名将
-- 	[Enum.HERO_TYPE.SOUL]				= "img_wujiang_level_01",        	--魂将
-- 	[Enum.HERO_TYPE.GOD_LIKE] 			= "img_wujiang_level_03",        	--神将
-- }
--武将类型对应icon 
local heroIconType = 
{
	[Enum.HERO_TYPE.NORMAL] 			= "hero_grade_high_01",          	--凡将
	[Enum.HERO_TYPE.FAMOUS] 			= "hero_grade_high_02",          	--名将
	[Enum.HERO_TYPE.SOUL]				= "hero_grade_high_03",        		--魂将
	[Enum.HERO_TYPE.GOD_LIKE] 			= "hero_grade_high_04",        		--神将
}
--武将品质icon 
local heroQualityIconType = 
{
	[Enum.HERO_TYPE.NORMAL] 			= "item_color_1",          	--凡将
	[Enum.HERO_TYPE.FAMOUS] 			= "item_color_2",          	--名将
	[Enum.HERO_TYPE.SOUL]				= "item_color_3",        	--魂将
	[Enum.HERO_TYPE.GOD_LIKE] 			= "item_color_4",        	--神将
}

local string_config = 
{
	[Enum.HERO_TALENT_TYPE.FORCE]       =gf_localize_string("武力"),
	[Enum.HERO_TALENT_TYPE.PHYSIQUE]	=gf_localize_string("体魄"),
	[Enum.HERO_TALENT_TYPE.FLEXABLE] 	=gf_localize_string("灵力"),
	[Enum.HERO_TALENT_TYPE.MULTIPLE] 	=gf_localize_string("天资"),
}
local dataUse = 
{
	getHeroConfig 				= nil,				--获取组队配置
	getHeroInfoById   			= nil,				--获取武将数
	getHeroName  				= nil,				--获取武将名字
	getHeroTalentPower     		= nil,				--获取武将武力资历区间
	getHeroTalentStrength     	= nil,				--获取武将体魄资历区间
	getHeroTalentSpirit     	= nil,				--获取武将灵力资历区间
	getHeroTalent 		     	= nil,				--获取武将灵力资历区间
	getHeroProperty     		= nil,				--获取武将属性
	getHeroOneProperty     		= nil,				--获取武将单一属性
	getHeroTalentRate 			= nil,				--获取武将天赋转换比例和影响主体
	getHeroExtendProperty		= nil,				--获取武将继承属性类型
	getHeroExtendData 			= nil,				--获取武将继承数据
	getFrontList 				= nil,				--获取阵法列表
	getFront 					= nil,				--获取阵法数据
	getHoleData 				= nil,				--获取阵法孔位数据
	getHeroSkill 				= nil,				--获取英雄技能
	getHeroTagIcon 				= nil,				--获取武将tag icon
	getHeroIcon 				= nil,				--获取武将iocn
	getHeroQualityIcon 			= nil,				--获取武将品质iocn
	getHeroHeadIcon 			= nil,				--获取武将头像iocn
	getHeroQuality 				= nil,				--获取武将品质
	getHeroLvOnExp  			= nil,				--根据武将经验获取武将等级 和剩余经验
	getHeroModel 				= nil,				--获取武将模型
	getHeroLevelExp 			= nil,				--获取武将等级经验
	getRoleHeroPropertyAdd 		= nil,				--获取武将阵法给予人物加成的属性
	getTypeHero	 				= nil,				--获取所有类型武将{type = {}}
	getFuncTypeHero	 			= nil,				--获取所有功能类型武将{type = {}}
	getHeroByType 				= nil,				--根据类型获取武将
	getAllHero 					= nil,				--获取所有武将
	getAtkRange                 = nil,              --获取攻击距离
	getHeroScaleProperty        = nil,              --获取模型显示比例属性界面
	getHeroScaleList            = nil,              --获取模型显示比例图鉴界面
	getHeroScaleShow            = nil,              --获取模型显示比例查看界面
	getHeroScaleGet             = nil,              --获取模型显示比例召唤界面
	getHeroAngle             	= nil,              --获取模型显示角度
	getOpenPrice 				= nil,				--获取开启武将出战槽位需要的道具
	getHeroSkillId              = nil,              --获取武将普攻技能id
	getHeroAttackCount 			= nil,				--获取武将出战栏数目
	getHeroAwakeData 			= nil,				--获取武将觉醒数据
	getHeroTalentAwakeAdd 		= nil,				--获取武将觉醒后的天赋加成
	getHeroTalentIncludeAwake	= nil,				--获取武将觉醒后的天赋值
	getHeroTotalExp				= nil,				--获取武将等级所有经验
	getHeroPolishItem			= nil,				--获取武将等级所有经验
	getOwnSkill					= nil,				--获取专属技能id
	getHoleOpenPirce 			= nil,				--获取开启武将阵法位需要的元宝
}

dataUse.getHeroAttackCount = function()
	return #openTable
end
dataUse.getHeroAwakeData = function(hero_id,level)
	print("hero_id,level:",hero_id,level)
	local type = dataUse.getHeroQuality(hero_id)
	local func_type = dataUse.getFuncTypeHero(hero_id)
	return dataUse.awake_data[type][func_type][level]
end
dataUse.getHeroTotalExp = function(hero_id,level)
	local total = 0
	for i=1,level - 1 do
		total = total + dataUse.getHeroLevelExp(i)
	end
	return total
end
dataUse.getTalentName = function(type)
	return string_config[type]
end
dataUse.getHeroTotalChip = function(hero_id,level)
	local type = dataUse.getHeroQuality(hero_id)
	local func_type = dataUse.getFuncTypeHero(hero_id)
	local data = dataUse.awake_data[type][func_type]
	local total = 0
	for i=1,level do
		total = total + data[i].chip_count
	end 
	return total
end

dataUse.getHeroTalentAwakeAdd = function(hero_id,level)
	local type = dataUse.getHeroQuality(hero_id)
	local func_type = dataUse.getFuncTypeHero(hero_id)
	local data = dataUse.awake_data[type][func_type]
	local temp = {}
	for k,v in pairs(data or {}) do
		if v.awaken_level <= level then
			table.insert(temp , v)
		end
	end
	return temp
end
--@return 当前值，上限值 
dataUse.getHeroTalentIncludeAwake = function(hero_id,talent,level)
	local limit_power = dataUse.getHeroTalentPower(hero_id)
	local limit_strength = dataUse.getHeroTalentStrength(hero_id)
	local limit_spirit= dataUse.getHeroTalentSpirit(hero_id)
	local limit_talent = dataUse.getHeroTalent(hero_id)

	local temp1 = {}
	temp1[ServerEnum.HERO_TALENT_TYPE.FORCE]		= {limit_power[1],limit_power[2]}
	temp1[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]		= {limit_strength[1],limit_strength[2]}
	temp1[ServerEnum.HERO_TALENT_TYPE.FLEXABLE]		= {limit_spirit[1],limit_spirit[2]}
	temp1[ServerEnum.HERO_TALENT_TYPE.MULTIPLE]		= {limit_talent[1],limit_talent[2]}

	local talent_add = dataUse.getHeroTalentAwakeAdd(hero_id,level)
	for i,v in ipairs(talent_add) do
		temp1[ServerEnum.HERO_TALENT_TYPE.FORCE][2] 	= temp1[ServerEnum.HERO_TALENT_TYPE.FORCE][2] 	 + v.force_limit

		temp1[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE][2] 	= temp1[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE][2] + v.physique_limit
	
		temp1[ServerEnum.HERO_TALENT_TYPE.FLEXABLE][2] 	= temp1[ServerEnum.HERO_TALENT_TYPE.FLEXABLE][2] + v.flexable_limit
	
		temp1[ServerEnum.HERO_TALENT_TYPE.MULTIPLE][2] 	= temp1[ServerEnum.HERO_TALENT_TYPE.MULTIPLE][2] + v.multiple_limit
	end

	local temp2 = {}
	temp2[ServerEnum.HERO_TALENT_TYPE.FORCE]		= talent and talent[ServerEnum.HERO_TALENT_TYPE.FORCE]     or 0
	temp2[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]		= talent and talent[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]  or 0
	temp2[ServerEnum.HERO_TALENT_TYPE.FLEXABLE]		= talent and talent[ServerEnum.HERO_TALENT_TYPE.FLEXABLE]  or 0
	temp2[ServerEnum.HERO_TALENT_TYPE.MULTIPLE]		= talent and talent[ServerEnum.HERO_TALENT_TYPE.MULTIPLE]  or 0

	for i,v in ipairs(talent_add) do
		temp2[ServerEnum.HERO_TALENT_TYPE.FORCE] 	= temp2[ServerEnum.HERO_TALENT_TYPE.FORCE] 		+ v.force
		temp2[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE] = temp2[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE] 	+ v.physique
		temp2[ServerEnum.HERO_TALENT_TYPE.FLEXABLE] = temp2[ServerEnum.HERO_TALENT_TYPE.FLEXABLE] 	+ v.flexable
		temp2[ServerEnum.HERO_TALENT_TYPE.MULTIPLE] = temp2[ServerEnum.HERO_TALENT_TYPE.MULTIPLE] 	+ v.multiple
	end
	return temp2,temp1
end

dataUse.get_awake_max_data = function(hero_id)
	local type = dataUse.getHeroQuality(hero_id)
	local func_type = dataUse.getFuncTypeHero(hero_id)
	return dataUse.awake_max_data[type][func_type]
end

dataUse.getOpenPrice = function(id)
	assert(openTable[id],"error getOpenPrice index :"..id)
	return openTable[id].need_money
end
dataUse.getHoleOpenPirce = function(id)
	assert(openTable[id],"error getOpenPrice index :"..id)
	return openTable[id].need_money
end

dataUse.getHeroConfig = function()
	if not dataUse.sortHeroList then
		dataUse.sortHeroList = {}
		for k,v in pairs(heroTable or {}) do
			table.insert(dataUse.sortHeroList,v)
		end
		table.sort(dataUse.sortHeroList,function(a,b)return a.hero_id < b.hero_id end)
	end

	return dataUse.sortHeroList
end
dataUse.getHeroInfoById = function(id)
	assert(heroTable[id],"error getHeroInfoById id :"..id)
	return heroTable[id]
end
dataUse.getHeroTalentPower = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.force
end
dataUse.getHeroPolishItem = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.polish_item
end

dataUse.getHeroTalent = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.multiple
end
dataUse.getHeroTalentStrength = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.physique
end
dataUse.getHeroTalentSpirit = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.flexable
end
dataUse.getHeroName = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.name
end
dataUse.getHeroProperty = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.base_attr
end
dataUse.getHeroOneProperty = function(id,pType)
	local attr = dataUse.getHeroProperty(id)
	for i,v in ipairs(attr or {}) do
		if v[1] == pType then
			return v[2]
		end
	end
	return 0
end
dataUse.getHeroTalentRate = function(propertyType)
	return talentRate[propertyType]
end
dataUse.getHeroExtendProperty = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.inherit_attr
end
dataUse.getHeroSkill = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.skill
end
dataUse.getOwnSkill = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.own_skill
end

dataUse.getHeroExtendData = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.inherit_attr_value
end
dataUse.getFrontList = function()
	return frontTable
end
dataUse.getFront = function(id)
	local fronts = dataUse.getFrontList()
	return fronts[id]
end
dataUse.getHoleData = function(fId,id)
	print("fId,id,level:",fId,id,level)
	return dataUse.propertyAdd[fId][id]
end
--fId  阵法id
--index  孔位
dataUse.getHoleDataByIndex = function(fId,index,level)
	print("get index,level:",index,level)
	--添加表
	-- if not dataUse.indexToIdTable then
	-- 	print("is not table")
	-- 	local tb = {}
	-- 	for i,v in ipairs(holeTable) do
	-- 		if not tb[v.square_id] then
	-- 			tb[v.square_id] = {}
	-- 		end
	-- 		tb[v.square_id][v.pos_id] = v
	-- 	end
	-- 	dataUse.indexToIdTable = tb
	-- end
	
	-- return dataUse.indexToIdTable[fId][index]

	return dataUse.propertyAdd[fId][index][level]

end

-- dataUse.getHeroTagIcon = function(id)
-- 	return heroIconTagType[id]
-- end
dataUse.getHeroIcon = function(id)
	return heroIconType[id]
end
dataUse.getHeroQualityIcon = function(id)
	return heroQualityIconType[id]
end
dataUse.getHeroHeadIcon = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.icon
end		
dataUse.getHeroQuality = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.hero_type
end		
dataUse.getFuncTypeHero = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.func_type	
end	
dataUse.getHeroModel = function(id)
	local heroInfo = dataUse.getHeroInfoById(id)
	return heroInfo.image
end

dataUse.getHeroLvOnExp = function(exp)
	local lv = 1
	for i,v in ipairs(lvExpTable or {}) do
		if v.exp > exp then
			exp = exp - v.exp
		else
			lv = v.level
		end
	end
	return lv,exp
end

dataUse.get_hero_level_max = function()
	return lvExpTable[#lvExpTable].level
end

dataUse.getHeroCurrentExp = function(level,curExp,addExp)
	if curExp + addExp - lvExpTable[level].exp >= 0 then
		return level + 1,curExp + addExp - lvExpTable[level].exp
	end
	return level ,curExp + addExp 
end

dataUse.getHeroLevelExp = function(level)
	assert(lvExpTable[level],"读取配置表错误 hero_level :",level)
	return lvExpTable[level].exp
end
--获取武将回收返还道具
dataUse.getHeroRecycleItem = function(heroLevel,heroTalent,heroSkillCount)
	print("heroLevel,heroTalent,heroSkillCount:",heroLevel,heroTalent,heroSkillCount)
	local items = {}
	if dataUse.recycleItem then
		-- gf_print_table(dataUse.recycleItem, "dataUse.recycleItem:")
		--等级
		for i,v in ipairs(dataUse.recycleItem[1][heroLevel] or {}) do
			table.insert(items,v)
		end
		for i,v in ipairs(dataUse.recycleItem[2] or {}) do
			if v[1] <= heroTalent and heroTalent <= v[2] then
				for ii,vv in ipairs(v[3] or {}) do
					table.insert(items,vv)
				end
			end
		end
		for i,v in ipairs(dataUse.recycleItem[3][heroSkillCount] or {}) do
			table.insert(items,v)
		end
		return items
	end
	for i,v in ipairs(recycleTable) do
		if not dataUse.recycleItem then
			dataUse.recycleItem = {}
		end
		if not dataUse.recycleItem[v.calc_type] then
			dataUse.recycleItem[v.calc_type] = {}
		end
		--等级
		if v.calc_type == 1 then
			dataUse.recycleItem[v.calc_type][v.level] = v.item
			if v.level == heroLevel then
				for ii,vv in ipairs(v.item or {}) do
					table.insert(items,vv)
				end
			end
		elseif v.calc_type == 2 then
			table.insert(dataUse.recycleItem[v.calc_type],{v.talent_sum_begin,v.talent_sum_end,v.item})
			if v.talent_sum_begin <= heroTalent and heroTalent <= v.talent_sum_end then
				for ii,vv in ipairs(v.item or {}) do
					table.insert(items,vv)
				end
			end
		elseif v.calc_type == 3 then
			dataUse.recycleItem[v.calc_type][v.skill_count] = v.item
			if heroSkillCount == v.skill_count then
				for ii,vv in ipairs(v.item or {}) do
					table.insert(items,vv)
				end
			end
		end
	end
	return items
end

dataUse.getRoleHeroPropertyAdd = function()
	if dataUse.property_array then
		return dataUse.property_array
	end
end

dataUse.getTypeHero = function()
	if dataUse.type_hero then
		return dataUse.type_hero
	end
end

dataUse.getHeroByType = function(type)
	if dataUse.type_hero[type] then
		return dataUse.type_hero[type]
	end
end

dataUse.getAllHero = function()
	if dataUse.all_hero then
		return dataUse.all_hero
	end
	if dataUse.type_hero then
		local temp = {}
		for k,v in pairs(dataUse.type_hero or {}) do
			for ii,vv in ipairs(v or {}) do
				table.insert(temp,vv)
			end
		end
		-- gf_print_table(temp, "wtf temp data:")
		--排序
		table.sort(temp,function(a,b)return a.hero_id < b.hero_id end)
		dataUse.all_hero = temp
		return temp
	end
	return {}
end

      

dataUse.getHeroScaleProperty = function(heroId)
	local heroInfo = dataUse.getHeroInfoById(heroId)
	return heroInfo.scale_rate1
end
dataUse.getHeroScaleList = function(heroId)
	local heroInfo = dataUse.getHeroInfoById(heroId)
	return heroInfo.scale_rate2
end
dataUse.getHeroScaleShow = function(heroId)
	local heroInfo = dataUse.getHeroInfoById(heroId)
	return heroInfo.scale_rate3
end
dataUse.getHeroAngle = function(heroId)
	local heroInfo = dataUse.getHeroInfoById(heroId)
	return heroInfo.angle
end

dataUse.getHeroScaleGet = function(heroId)
	local heroInfo = dataUse.getHeroInfoById(heroId)
	return heroInfo.scale_rate4
end
 
dataUse.getAtkRange = function(heroId)
	return heroTable[heroId].attack_range
end

dataUse.getHeroSkillId = function( heroId )
	return heroTable[heroId].skill_id
end



dataUse.getHeroChipId = function(heroId)
	local heroInfo = dataUse.getHeroInfoById(heroId)
	return heroInfo.chip_id
end

--根据道具大小类获取道具
-- dataUse.getItemByBtAndSt = function(bt,st)
-- 	if dataUse.item_data[bt][st] then
-- 		return dataUse.item_data[bt][st]
-- 	end
-- end
local function ex()
	print("wtf 转表开始")
	local propertyAdd = {}
	--筛选项
	local type_hero = {}
	local property_array = {}
	for i,v in pairs(holeTable or {}) do
		if not propertyAdd[v.square_id] then
			propertyAdd[v.square_id] = {}
		end
		if not propertyAdd[v.square_id][v.pos_id] then
			propertyAdd[v.square_id][v.pos_id] = {}
		end
		propertyAdd[v.square_id][v.pos_id][v.level] = v

		for ii,vv in ipairs(v.attr_mul or {}) do
			if not property_array[vv[1]] then
				property_array[vv[1]] = 1
			end
		end

	end

	local temp = {}
	for k,v in pairs(property_array) do
		table.insert(temp,k)
	end
	table.sort(temp,function(a,b)return a < b end)
	property_array = temp

	-- gf_print_table(heroTable, "heroTable wtf:")
	for i,v in pairs(heroTable or {}) do
		--筛选项提取
		if not type_hero[v.func_type] then
			type_hero[v.func_type] = {}
		end
		table.insert(type_hero[v.func_type],v)
	end

	for i,v in pairs(type_hero or {}) do
		table.sort(v,function(a,b) return a.hero_id < b.hero_id end)
	end
	
	local awake_data = {}
	local awake_max_data = {}
	for k,v in pairs(awakeTable or {}) do
		if not awake_data[v.hero_type] then
			awake_data[v.hero_type] = {}
		end
		if not awake_data[v.hero_type][v.func_type] then
			awake_data[v.hero_type][v.func_type] = {}
		end
		awake_data[v.hero_type][v.func_type][v.awaken_level] = v

		if not awake_max_data[v.hero_type] then
			awake_max_data[v.hero_type] = {}
		end
		if not awake_max_data[v.hero_type][v.func_type] then
			awake_max_data[v.hero_type][v.func_type] = v
		end
		if v.awaken_level > awake_max_data[v.hero_type][v.func_type].awaken_level then
			awake_max_data[v.hero_type][v.func_type] = v
		end
	end

	-- local item_data = {}
	-- for k,v in pairs(itemTable or {}) do
	-- 	if not item_data[v.type] then
	-- 		item_data[v.type] = {}
	-- 	end
	-- 	if not item_data[v.type][v.sub_type] then
	-- 		item_data[v.type][v.sub_type] = {}
	-- 	end
	-- 	table.insert(item_data[v.type][v.sub_type],v)
	-- end

	-- gf_print_table(type_hero, "wtf type_hero:")
	-- gf_print_table(propertyAdd, "wtf propertyAdd:")
	-- gf_print_table(awake_data, "wtf awake_data:")
	-- gf_print_table(awake_max_data, "wtf awake_max_data:")

	dataUse.awake_data = awake_data
	dataUse.awake_max_data = awake_max_data
	dataUse.propertyAdd = propertyAdd
	dataUse.type_hero = type_hero
	dataUse.property_array = property_array
	-- dataUse.item_data = item_data
end
 
ex()

return dataUse