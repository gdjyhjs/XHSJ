local ret = {
	[1] = {
		reward_id = 1, --[[奖励id]]
		activity_id = 30001, --[[活动id]]
		condition = {{20010101,1},{20020101,1}}, --[[目标对象{{code1,count1},{code2,count2}}]]
		reward = {{20030102,1}}, --[[奖励物品]]
		player_times = 0, --[[个人领取次数(不限次数填0)]]
		server_times = 7, --[[全服领取次数(不限次数填0)]]
		day_times = 5, --[[每天领取次数(不限次数填0)]]
		-- 此表activity_type为3
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[2] = {
		reward_id = 2, --[[奖励id]]
		activity_id = 30001, --[[活动id]]
		condition = {{20020102,2},{20020203,3},{20030101,1}}, --[[目标对象{{code1,count1},{code2,count2}}]]
		reward = {{20041510,1}}, --[[奖励物品]]
		player_times = 10, --[[个人领取次数(不限次数填0)]]
		server_times = 1000, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
		-- 
	} ,
	[3] = {
		reward_id = 3, --[[奖励id]]
		activity_id = 30001, --[[活动id]]
		condition = {{20010102,10}}, --[[目标对象{{code1,count1},{code2,count2}}]]
		reward = {{20010101,30}}, --[[奖励物品]]
		player_times = 10, --[[个人领取次数(不限次数填0)]]
		server_times = 1000, --[[全服领取次数(不限次数填0)]]
		day_times = 0, --[[每天领取次数(不限次数填0)]]
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