--过关斩将数据表接口
local holyTable 	= ConfigMgr:get_config("holy_strengthen")
local holyTableEx 	= ConfigMgr:get_config("holy")
local copyTable 	= ConfigMgr:get_config("holy_copy")

local dataUse = 
{
	getHolyInfoById 				= nil,				--获取组队配置
	getHolyLevelInfo 				= nil,		
	getIsHolyMaxLevel 				= nil,
	getHolyInfo 					= nil,
	getCopyInfo 					= nil,
	getNextCopyCode 				= nil,				--获取下一章code
}


dataUse.getHolyInfo = function(id)
	assert(holyTableEx[id],"读表错误 id,level:"..id)
	return holyTableEx[id]
end
dataUse.getHolyLevelInfo = function(id)
	assert(dataUse.holyLevel2Table[id],"读表错误 id,level:"..id)
	return dataUse.holyLevel2Table[id]
end

dataUse.getHolyInfoById = function(id,level)
	local tb = dataUse.getHolyLevelInfo(id)
	-- assert(tb[level],"读表错误 level:"..level)
	return tb[level]
end
dataUse.getIsHolyMaxLevel = function(id,level)
	local tb = dataUse.getHolyLevelInfo(id)
	local maxLevel = tb[#tb].level
	
	return maxLevel == level
end

dataUse.getCopyInfo = function(id)
	-- assert(copyTable[id],"读表错误 id:"..id)
	return copyTable[id]
end

dataUse.getNextCopyCode = function(id)
	if copyTable[id + 1] then
		return true
	end
	return false
end

local function ex()
	print("wtf 过关斩将开始转表")

	--圣物
	local temp = {}
	for i,v in ipairs(holyTable or {}) do
		if not temp[v.code] then
			temp[v.code] = {}
		end
		temp[v.code][v.level] = v
	end
	gf_print_table(temp,"wtf temp:" )
	dataUse.holyLevel2Table = temp
end

ex()

return dataUse