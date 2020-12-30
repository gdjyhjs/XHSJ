--军旗对应图标
local flag = 
{
	"legion_color_01","legion_color_02","legion_color_03","legion_color_04","legion_color_05",
}

local allianceTable = ConfigMgr:get_config("alliance")
local buffTable = ConfigMgr:get_config("buff")
local flagTable = ConfigMgr:get_config("alliance_war_flag")
local rewardTable = ConfigMgr:get_config("legion_boss_reward")
local itemTable = ConfigMgr:get_config("item")
local formulaTable = ConfigMgr:get_config("equip_formula")

local dataUse  = 
{
	getFlagByColor 			= 	nil,
	getFlagMaxLevel 		= 	nil,
	getFlagInfo  			= 	nil,
	getLegionBossBoxReward  	= 	nil,
}

dataUse.getFlagByColor = function(color)
	return flag[color]
end

dataUse.getLegionBossBoxReward = function(level,career)
	local data = rewardTable[1]
	for i,v in ipairs(rewardTable) do
		if level >= v.level_range[1] then
			data = v
		end
	end
	local temp = {}

	table.insert(temp,{ServerEnum.BASE_RES.ALLIANCE_DONATE})

	local function get(data,_career)
		for i,v in ipairs(data or {}) do
			if v[1] == _career then
				return v[2]
			end
		end
	end

	for i,v in ipairs(data.reward_career) do
		local id = dataUse.getCareerItem(v[1],career)--get(item.effect,career)

		--获取打造id对应的道具id
		local item_id = formulaTable[id].code

		table.insert(temp,{id,item_id,v[2],v[3]})
	end

	return temp
end

--根据虚拟道具获取对应职业的打造id
dataUse.getCareerItem = function(item_id,career)
	local function get(data,_career)
		for i,v in ipairs(data or {}) do
			if v[1] == _career then
				return v[2]
			end
		end
	end
	--打造id
	local m_id = get(itemTable[item_id].effect,career)
	return m_id
end

dataUse.getAllianceData = function(level)
	return allianceTable[level]
end
dataUse.getFlagInfo = function(level)
	return flagTable[level]
end
dataUse.getFlagMaxLevel = function(alliance_level)
	return allianceTable[#allianceTable].flag_level_max
end

dataUse.getAllianceMaxLevel = function(level)
	local level = 0
	for k,v in pairs(allianceTable or {}) do
		level = level + 1
	end
	return level
end

dataUse.get_flag_attr = function(level)
	local buff_id  = flagTable[level].buffId
	local data = buffTable[buff_id].state_effect
	return data
end

return dataUse
