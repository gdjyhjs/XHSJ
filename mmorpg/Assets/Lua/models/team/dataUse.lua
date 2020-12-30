local teamTable = ConfigMgr:get_config("team")
local teamCopyTable = gf_get_config_table("team_copy")

local dataUse = 
{
	getTeamConfig = nil,					--获取组队配置
	getTeamTable  = nil,					--获取组队标签
	getTargetNameById = nil,				--获取目标名字
	getGotoNameById   = nil,				--获取前往名字
	getLimitLevel = nil,					--获取目标限制等级
	getTargetDataById = nil,				--获得目标数据
	getTeamPageCopy = nil,					--获得目标数据
	get_lower_enter_level = nil 			--获取组队副本最低进入等级
}

dataUse.getTeamConfig = function()
	return teamTable
end

dataUse.getTeamPageCopy = function()
	if dataUse.teamCopyTable then
		return dataUse.teamCopyTable
	end
	

	local table_ex = {}

	for k,v in pairs(teamCopyTable or {}) do
		table.insert(table_ex,v)
	end

	table.sort(table_ex,function(a,b)return a.code < b.code end)

	dataUse.teamCopyTable = {}
	local page = {}
	for i,v in ipairs(table_ex) do
		table.insert(page,v)
		if #page == 3 then
			table.insert(dataUse.teamCopyTable,page)
			page = {}
		end
	end

	return dataUse.teamCopyTable
end

dataUse.get_lower_enter_level = function()
	local data = dataUse.getTeamPageCopy()
	local level = 999999
	for i,v in ipairs(data or {}) do
		for ii,vv in ipairs(v or {}) do
			if vv.level_limit <= level then
				level = vv.level_limit
			end
		end
	end
	return level
end

dataUse.getTeamTable = function()
	local data = dataUse.getTeamConfig()
	local tb = {}
	local index = 0
	for i,v in ipairs(data or {}) do
		if not tb[index] then
			index = index + 1
			tb[index] = {}
			tb[index].sort = v.sort
		end
		table.insert(tb[index],v)
	end
	table.sort(tb,function(a,b)return a.sort<b.sort end)
	return tb
end
--根据等级获取tag 
dataUse.getTeamTableEx = function(level)
	print("level:",level)
	local data = dataUse.getTeamConfig()
	local tb = {}
	local index = 0
	for i,v in ipairs(data or {}) do
		--如果等级符合
		if v.lv == nil or (v.lv and v.lv <= level) then
			if not tb[v.sort] then
				tb[v.sort] = {}
				tb[v.sort].sort = v.sort
			end
			table.insert(tb[v.sort],v)
		end
	end
	local temp = {}
	for k,v in pairs(tb or {}) do
		table.insert(temp,v)
	end
	tb = temp
	-- gf_print_table(tb, "getTeamTableEx")
	table.sort(tb,function(a,b)return a.sort<b.sort end)
	
	return tb
end
dataUse.getTargetNameById = function(id)
	id = id or 1
	local data = dataUse.getTeamConfig()
	return data[id].sname,data[id].name
end
dataUse.getTargetDataById = function(id)
	id = id or 1
	local data = dataUse.getTeamConfig()
	return data[id]
end

dataUse.getTargetByCopyId = function(copyId)
	print("copyId:",copyId,type(copyId))
	local data = dataUse.getTeamConfig()
	for i,v in ipairs(data or {}) do
		if v.open_param and v.open_param[1]  == copyId then
			return v.code
		end
	end
	return 0
end

dataUse.getGotoNameById = function(id)
	local data = dataUse.getTeamConfig()
	return data[id].goto_name
end
dataUse.getTargetLimitLevel = function(id)
print("targetId:",id)
	local data = dataUse.getTeamConfig()
	return data[id].lv or 0
end 
return dataUse