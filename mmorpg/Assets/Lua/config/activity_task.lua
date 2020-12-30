local ret = {
	[1] = {
		reward_id = 1, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "战力达到5000", --[[任务描述]]
		condition = {0,5000}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 46, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 1, --[[个人领取次数(不限次数填0)]]
		server_times = 1000, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		is_daily = 0, --[[是否日常(是否每日刷新进度)]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[2] = {
		reward_id = 2, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "累计答题答对10次", --[[任务描述]]
		condition = {0,10}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 47, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 1, --[[个人领取次数(不限次数填0)]]
		server_times = 1000, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		is_daily = 0, --[[是否日常(是否每日刷新进度)]]
		-- 此表activity_type为4
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[3] = {
		reward_id = 3, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "活跃度达到20", --[[任务描述]]
		condition = {0,20}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 48, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 1, --[[个人领取次数(不限次数填0)]]
		server_times = 1000, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		is_daily = 0, --[[是否日常(是否每日刷新进度)]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[4] = {
		reward_id = 4, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "登录", --[[任务描述]]
		condition = {0,1}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 0, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 0, --[[个人领取次数(不限次数填0)]]
		server_times = 1000, --[[全服领取次数(不限次数填0)]]
		day_times = 1, --[[每天领取次数(不限次数填0)]]
		is_daily = 1, --[[是否日常(是否每日刷新进度)]]
		remark = "登录获得奖励", --[[备注]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[5] = {
		reward_id = 5, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "每日完成剧情副本5次", --[[任务描述]]
		condition = {1,5}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 5, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 0, --[[个人领取次数(不限次数填0)]]
		server_times = 0, --[[全服领取次数(不限次数填0)]]
		day_times = 1, --[[每天领取次数(不限次数填0)]]
		is_daily = 1, --[[是否日常(是否每日刷新进度)]]
		remark = "condition为副本类型", --[[备注]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[6] = {
		reward_id = 6, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "通关力压张宝副本", --[[任务描述]]
		condition = {10001,1}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 5, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 1, --[[个人领取次数(不限次数填0)]]
		server_times = 0, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		is_daily = 0, --[[是否日常(是否每日刷新进度)]]
		remark = "condition为副本id", --[[备注]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[7] = {
		reward_id = 7, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "参加2次魔族围城", --[[任务描述]]
		condition = {13,2}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 5, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 1, --[[个人领取次数(不限次数填0)]]
		server_times = 0, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		is_daily = 0, --[[是否日常(是否每日刷新进度)]]
		remark = "condition为副本类型", --[[备注]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[8] = {
		reward_id = 8, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "加入军团", --[[任务描述]]
		condition = {0,1}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 65, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 1, --[[个人领取次数(不限次数填0)]]
		server_times = 0, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		is_daily = 0, --[[是否日常(是否每日刷新进度)]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[9] = {
		reward_id = 9, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "每日完成5次天机任务", --[[任务描述]]
		condition = {0,5}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 22, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 0, --[[个人领取次数(不限次数填0)]]
		server_times = 0, --[[全服领取次数(不限次数填0)]]
		day_times = 1, --[[每天领取次数(不限次数填0)]]
		is_daily = 1, --[[是否日常(是否每日刷新进度)]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[10] = {
		reward_id = 10, --[[奖励id]]
		activity_id = 40001, --[[活动id]]
		description = "攻击属性达到1000点", --[[任务描述]]
		condition = {1,1000}, --[[目标对象]]
		level = 20, --[[跳转界面等级]]
		event = 76, --[[事件触发(对应enum_ser.EVENT)]]
		reward = {{40121501,1},{40140201,1}}, --[[奖励物品]]
		player_times = 1, --[[个人领取次数(不限次数填0)]]
		server_times = 0, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		is_daily = 0, --[[是否日常(是否每日刷新进度)]]
		remark = "condition为属性id", --[[备注]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
}
return ret