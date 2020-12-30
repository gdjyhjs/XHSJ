local rank_data = ConfigMgr:get_config("rank")
local show_data = ConfigMgr:get_config("show_name")

local dataUse = 
{
	get_rank_data    			= nil,			
	get_rank_data_by_index 		= nil,				--根据双层索引获取数据
	get_rank_info 				= nil,
	get_index_by_id 			= nil,	
	get_show_name_by_type 		= nil,				--获取排行榜显示名字配置		
}

dataUse.get_show_name_by_type = function(type)
	return dataUse.rank_show_name[type]
end



dataUse.get_rank_info = function(id)
	assert(rank_data[id],"error dataUse.get_rank_info 数据为空:",id)
	return rank_data[id]
end
dataUse.get_index_by_id = function(id)
	for i,v in ipairs(rank_data or {}) do
		if v.type == id then
			return v.id
		end
	end
	return 1
end
dataUse.get_rank_data_ex = function()
	if rank_data then
		return rank_data
	end
	print("error dataUse.get_rank_data_ex 数据为空")
end

dataUse.get_rank_data_by_index = function(sindex)
	return rank_data[sindex]
end

dataUse.get_level_open = function(type)
	return ConfigMgr:get_config("t_misc").rank.unlock_level[type]
end

--开始转表
local ex = function()
	--大类为key
	local show_name_temp = {}
	for i,v in ipairs(show_data) do
		if not show_name_temp[v.rank_type] then
			show_name_temp[v.rank_type] = {}
		end
		table.insert(show_name_temp[v.rank_type],v)
	end

	--分类
	dataUse.rank_show_name = show_name_temp

end
ex()

return dataUse