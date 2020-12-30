local pvp_info = ConfigMgr:get_config("tvt_stage")
local pvp_score_info = ConfigMgr:get_config("tvt_score")

local dataUse = 
{
	get_rank_data 			= nil,
	get_rank_data_by_score  = nil,
	get_rank_by_score  		= nil,					--获得段位 5
	get_stage 				= nil,				--获取转换过的段位
	get_left_score 			= nil,				--获取转换过的段位
}

dataUse.get_rank_data = function()
	return pvp_info
end
dataUse.get_rank_by_score = function(score)
	local data = dataUse.get_rank_data_by_score(score)
	local score_duration = score - data.score_min
	local step = math.ceil(score_duration / ((data.score_max - data.score_min) / 4) )
	step = step <= 0 and 1 or step
	return step
end
dataUse.get_rank_data_by_score = function(score)
	local rank_data = {}
	for i,v in ipairs(pvp_info or {}) do
		if score < v.score_min then
			return rank_data
		end
		rank_data = v
	end
	return rank_data
end

dataUse.get_left_score = function(score)
	local rank_data = {}
	local last 
	for i,v in ipairs(pvp_info or {}) do
		if score < v.score_max then
			return score - (last and last.score_max or 0)
		end
		last = v
	end
	return score - pvp_info[#pvp_info].score_max
end

dataUse.get_stage = function()
	if dataUse.stage_data then
		return dataUse.stage_data
	end
	local temp = {}
	for i,v in ipairs(pvp_info or {}) do
		if not temp[v.stage] then
			temp[v.stage] = {}
		end
		table.insert(temp[v.stage],v)
	end
	dataUse.stage_data = temp
	return dataUse.stage_data
end

return dataUse