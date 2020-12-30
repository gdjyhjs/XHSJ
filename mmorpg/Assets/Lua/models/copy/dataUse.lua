local materialCopyTable = ConfigMgr:get_config("material")
local copyTable = ConfigMgr:get_config("copy")
local storyCopyTable = ConfigMgr:get_config("story_copy")
local towerCopyTable = ConfigMgr:get_config("copy_tower")
local materialTable = ConfigMgr:get_config("material")

local TowerIdList = {30001,30002,30003}

local dataUse = 
{
	getCopyData 					= nil,					--获取副本数据
	getTypeMaterialCopy 			= nil,					--获取类别材料副本
	getLevelMaterialCopy			= nil,					--根据等级获得数据
	getCopyType 	 				= nil,					--判断副本类型
	getStoryCopyData 	 			= nil,					--获取剧情副本数据
	getTowerMax 					= nil,					--获取爬塔最高层
	getTowerData 					= nil,					--获取爬塔一层的数据
	get_defence_copy_data 			= nil,					--兵来将挡数据
	get_time_treasury 				= nil,					--时空宝库
}


dataUse.get_defence_copy_by_id = function(id)
	for i,v in ipairs(dataUse.defence_data or {}) do
		if v.copy_code == id then
			return v
		end
	end
	return nil
end
dataUse.get_defence_copy_by_index = function(index)
	return dataUse.get_defence_copy()[index]
end
dataUse.get_treasury_copy_by_index = function(index)
	return dataUse.get_treasury_copy()[index]
end
dataUse.get_defence_copy = function()
	if not dataUse.defence_data then
		local temp = {}
		for k,v in pairs(materialTable or {}) do
			if v.copy_type == ServerEnum.COPY_TYPE.MATERIAL then
				table.insert(temp,v)
			end
		end
		table.sort(temp,function(a,b)return a.copy_code < b.copy_code end)
		dataUse.defence_data = temp
	end
	return dataUse.defence_data
end

dataUse.get_treasury_copy = function()
	if not dataUse.time_treasury_data then
		local temp = {}
		for k,v in pairs(materialTable or {}) do
			if v.copy_type == ServerEnum.COPY_TYPE.MATERIAL2 then
				table.insert(temp,v)
			end
		end
		table.sort(temp,function(a,b)return a.copy_code < b.copy_code end)
		dataUse.time_treasury_data = temp
	end
	return dataUse.time_treasury_data
end

dataUse.getCopyData = function(copy_code)
	if not copyTable[copy_code] then
		gf_error_tips("没有次副本数据 :"..(copy_code or nil))
	end
	
	return copyTable[copy_code]
end
dataUse.getStoryCopyData = function(copy_code)
	if not storyCopyTable[copy_code] then
		gf_error_tips("没有次副本数据 :"..(copy_code or nil))
	end
	
	return storyCopyTable[copy_code]
end
dataUse.getTypeMaterialCopy = function()
	return dataUse.typeMaterialCopy
end

dataUse.getCopyType = function(copy_code)
	local copyData = dataUse.getCopyData(copy_code)
	return copyData.type
end

dataUse.getTowerMax = function(copy_code)
	if dataUse.floorTowerCopy[copy_code] then
		return dataUse.floorTowerCopy[copy_code][#dataUse.floorTowerCopy[copy_code]].floor
	end
	return 100
end
dataUse.getTowerData = function(copy_code)
	if towerCopyTable[copy_code] then
		return towerCopyTable[copy_code]
	end
	gf_error_tips("没有爬塔这一层的数据 "..copy_code)
	return {}
end
-- dataUse.getStoryCopyData = function(copy_code)
-- 	local copyData = dataUse.getCopyData(copy_code)
-- 	return copyData.type
-- end


dataUse.getLevelMaterialCopy = function(copy_code,level)
	for i,v in ipairs(dataUse.typeMaterialCopy or {}) do
		for ii,vv in ipairs(v or {}) do
			if vv.copy_code == copy_code and (vv.level_grade[1] <= level and vv.level_grade[2] >= level) then
				return vv
			end
		end
	end
	gf_error_tips(string.format("error 没有找到次等级的数据 %d %d",copy_code,level))
end

local function ex()
	local temp = {}
	for i,v in ipairs(materialCopyTable or {}) do
		if not temp[v.copy_code] then
			temp[v.copy_code] = {}
		end
		table.insert(temp[v.copy_code],v)
	end

	--排序
	local tempex = {}
	for k,v in pairs(temp or {}) do
		table.insert(tempex,v)
	end
	table.sort(tempex,function(a,b)return a[1].copy_code < b[1].copy_code end)

	-- local temp_tower = {}

	-- for k,v in pairs(towerCopyTable or {}) do
	-- 	-- print("math.floor(v.code / 1000):",math.floor(v.code / 1000))
	-- 	local copy_id = TowerIdList[math.floor(v.code / 1000)]
	-- 	if not temp_tower[copy_id] then
	-- 		temp_tower[copy_id] = {}
	-- 	end
	-- 	temp_tower[copy_id][v.floor] = v
	-- end

	--兵来将挡 时空宝库

	dataUse.typeMaterialCopy 	= tempex
	-- dataUse.floorTowerCopy 		= temp_tower
end

ex()

return dataUse