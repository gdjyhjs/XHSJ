local bossInfo 				= ConfigMgr:get_config("boss_refresh")
local bossListInfo			= ConfigMgr:get_config("world_boss")
local transformInfo 		= ConfigMgr:get_config("transport")	

local dataUse = 
{
	getBossInfo 			= nil,
	getDropRewardItem 		= nil,							--获取掉落展示列表
	getJoinRewardItem 		= nil,							--获取参与奖励
	getBossListByType 		= nil,							--根据类型获取boss列表
	getTransformPos 		= nil,							--根据地图id获取传送点位置
	getWorldBoss 			= nil,							--获取世界boss
	getWorldBossTop 		= nil,							--获取世界boss
}

dataUse.getWorldBossTop = function(level) 
	local data = dataUse.getWorldBoss()
	local boss_data = data[1][1]
	local page = 1
	for i,v in ipairs(data or {}) do
		for ii,vv in ipairs(v) do
			local boss_info = gf_get_config_table("creature")[vv.boss_code]
			if boss_info.level > level then
				return page,boss_data.boss_code
			end
			boss_data = vv
			page = i
		end
	end 
	local page = #data
	return page,data[page][#data[page]].boss_code
end

dataUse.getWorldBoss = function() 
	local boss_list = dataUse.getBossListByType(ServerEnum.BOSS_TYPE.MAGIC_BOSS)
	--分页
	if dataUse.boss_list_ex then
		return dataUse.boss_list_ex
	end
	local temp = {}
	for i,v in ipairs(boss_list) do
		local page = tonumber(string.sub(tostring(v.boss_code),5,5))
		if not temp[page] then
			temp[page] = {}
		end
		table.insert(temp[page],v)
	end
	for i,v in ipairs(temp or {}) do
		table.sort(v,function(a,b)return a.boss_code < b.boss_code end)
	end

	dataUse.boss_list_ex = temp

	return temp
end

dataUse.getBossInfo = function(bossId)
	assert(bossListInfo[bossId],"error 表boss_refresh没有此id数据:"..bossId)
	return bossListInfo[bossId]
end
dataUse.getDropRewardItem = function(bossId)
	return dataUse.getBossInfo(bossId).team_reward
end

dataUse.getJoinRewardItem = function(bossId)
	return dataUse.getBossInfo(bossId).join_reward
end

dataUse.getBossListByType = function(bType)
	assert(dataUse.bossTypeInfo,"error world_boss没有boss数据 :"..bType)
	assert(dataUse.bossTypeInfo[bType],"error world_boss没有此类型的boss数据 :"..bType)
	return dataUse.bossTypeInfo[bType]
end

dataUse.getTransformPos = function(mapId)
	assert(dataUse.mapToTransformInfo[mapId],"error transport没有此地图传送点位置 :",mapId)
	return dataUse.mapToTransformInfo[mapId]
end

local function ex()
	print("wtf 世界boss开始转表")
	local temp = {}
	for i,v in pairs(bossListInfo or {}) do
		if not temp[v.type] then
			temp[v.type] = {}
		end
		table.insert(temp[v.type],v)
	end
	for k,v in pairs(temp) do
		table.sort(v,function(a,b) return a.boss_code < b.boss_code end)
	end

	local mapToTransformInfo = {}
	for k,v in pairs(transformInfo or {}) do
		if not mapToTransformInfo[v.map_id] then
			mapToTransformInfo[v.map_id] = {}
		end
		table.insert(mapToTransformInfo[v.map_id],v)
	end

	--boss类型表 
	dataUse.bossTypeInfo = temp
	--地图对应传送点
	dataUse.mapToTransformInfo = mapToTransformInfo
end

ex()

return dataUse

