local train_data = ConfigMgr:get_config("alliance_train")
local alliance_data = ConfigMgr:get_config("alliance")
local limit_data = ConfigMgr:get_config("alliance_train_limit")

require("models.train.trainConfig")

local type_name = 
{
	[ServerEnum.ALLIANCE_TRAIN_TYPE.PLAYER_DAMAGE] = gf_localize_string("人物攻击"),
	[ServerEnum.ALLIANCE_TRAIN_TYPE.PLAYER_PROTECT] = gf_localize_string("人物防御"),
	[ServerEnum.ALLIANCE_TRAIN_TYPE.PLAYER_HEALTH] = gf_localize_string("人物生命"),
	[ServerEnum.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE] = gf_localize_string("武将攻击"),
	[ServerEnum.ALLIANCE_TRAIN_TYPE.HERO_PROTECT] = gf_localize_string("武将防御"),
	[ServerEnum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH] = gf_localize_string("武将生命"),
}

local dataUse = 
{
	get_train_data 						= nil,			
	get_alliance_train_data 			= nil,	
	get_max_exp 						= nil,		
	get_cur_exp 						= nil,		
	get_is_max_level 					= nil,	
	get_train_max_level 				= nil,				--根据人物等级获取最高可修炼等级
	get_icon 							= nil,
	get_name 							= nil,	
	get_next_level_cost  	= nil,				--获取升级到下一等级需要的贡献值跟铜币
}	

dataUse.get_alliance_train_data = function(level)
	local data = alliance_data[level]
	assert(data,"error 数据表读取错误,alliance level :",level)
	return data
end

dataUse.get_train_data = function(type)
	local data = dataUse.type_data[type]
	assert(data,"error 数据表读取错误,dataUse.get_train_data type :"..type)
	return data
end

--@type 			修炼类型
--@level 			修炼等级
--@exp 				当前经验
--@legion_level 	军团等级
--@return 需要消耗的铜币，贡献
dataUse.get_next_level_cost = function(type,level,exp,legion_level)
	local train_data = dataUse.get_train_data_by_level(type,level)
	local total_exp =train_data.need_exp
	local need = total_exp - exp 
	local alliance_data = dataUse.get_alliance_train_data(legion_level)
	local need_coin,need_donation = 0,0

	if need > 0 then
		local count = math.ceil(need / alliance_data.train_exp)
		need_coin = count * train_data.cost_coin
		need_donation = count * train_data.cost_donate
	end

	return need_coin,need_donation
end

dataUse.get_max_exp = function(type,stage)
	local data = dataUse.get_train_data(type)
	local exp = 0
	for i,v in pairs(data or {}) do
		local cstage = math.floor(v.level / RANK_LEVEL)
		if cstage == stage then
			exp = exp + v.need_exp
		end
	end
	return exp
end

dataUse.get_icon = function(type)
	local data = dataUse.get_train_data(type)
	return data[1].icon
end
dataUse.get_name = function(type)
	return type_name[type]
end
dataUse.get_cur_exp = function(type,level)
	local cstage = math.floor(level / RANK_LEVEL)
	local cexp = 0
	for i=cstage*RANK_LEVEL,(cstage + 1) * RANK_LEVEL -1 do
		if i < level then
			local exp = dataUse.get_train_data_by_level(type,i).need_exp
			cexp = cexp + exp
		end
	end
	return cexp
end
dataUse.get_train_data_by_level = function(type,level)
	local data = dataUse.get_train_data(type)
	assert(data[level],"error 数据表读取错误 level:"..level)
	return data[level]
end
dataUse.get_train_max_level = function(alliance_level,type)
	print("alliance_level,type:",alliance_level,type)
	return limit_data[alliance_level]["train_level_"..type]
end
dataUse.get_is_max_level = function(type)
	local data = dataUse.get_train_data(type)
	local max_level = 1
	for k,v in pairs(data or {}) do
		if v.level >= max_level then
			max_level = v.level
		end
	end
	return max_level
end

local function ex()
	print("wtf 转表开始")
	local data = {}
	for i,v in pairs(train_data or {}) do
		if not data[v.type] then
			data[v.type] = {}
		end
		data[v.type][v.level] = v
	end
	dataUse.type_data = data
end

ex()


return dataUse