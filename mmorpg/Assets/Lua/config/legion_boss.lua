local ret = {
	[1] = {
		code = 1, --[[id]]
		proto_id = 50102101, --[[兽神编号]]
		boss_code = 50102101, --[[怪物刷新表编号]]
		valid_time = {{20,15},{23,0}}, --[[可挑战时间]]
		time_limit = 300, --[[存在时间]]
		food_code = 40481201, --[[口粮物品编号]]
		need_food = 7000, --[[挑战需要口粮]]
		week_count = 5, --[[每周刷新只数]]
		reward_times_max = 5, --[[每周奖励次数]]
		combat_param = {{0.147,-3.32,77.5},{0.147,-3.32,77.5}}, --[[兽神属性变化]]
		npc_id = 50102003, --[[寻路npc]]
		model_scale = 0.3, --[[模型大小]]
	} ,
}
return ret