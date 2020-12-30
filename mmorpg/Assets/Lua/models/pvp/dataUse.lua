local pvp_info = ConfigMgr:get_config("arena_stage")

local dataUse = 
{
	get_rank_reward 			= nil,
	get_stage_by_score			= nil,				--根据积分获得段位
	get_stage_name				= nil,				--根据积分获得名字
	get_stage_icon				= nil,				--根据积分获得icon
	get_stage_sicon				= nil,				--根据积分获得icon
}
dataUse.get_rank_info = function(rank)
	local data = pvp_info[rank]
	assert(data,"获取竞技场arena_stage数据错误:",rank)
	return data
end

dataUse.get_rank_reward = function(rank)
	local data = dataUse.get_rank_info(rank)
	return data.daily_reward
end
dataUse.get_stage_name = function(stage)
	local data = dataUse.get_rank_info(stage)
	return data.name
end
dataUse.get_stage_icon = function(stage)
	local data = dataUse.get_rank_info(stage)
	return data.icon
end
dataUse.get_stage_sicon = function(stage)
	local data = dataUse.get_rank_info(stage)
	return data.s_icon
end
dataUse.get_stage_by_score = function(score)
	local stage = 1
	for i,v in ipairs(pvp_info or {}) do
		if score < v.score_min then
			return stage
		end
		stage = v.stage_code
	end
	return stage
end

return dataUse