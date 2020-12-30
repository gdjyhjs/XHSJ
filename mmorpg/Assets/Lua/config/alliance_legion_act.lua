local ret = {
	[1] = {
		code = 1, --[[活动类型]]
		exp_10s = {0,100,-7000}, --[[10秒奖励经验值]]
		reward_10s = {{6,10}}, --[[10秒奖励]]
		add_cost = 10, --[[喝酒/烟花消耗元宝]]
		add_donation = 50, --[[喝酒/烟花奖励军团贡献]]
		reward_times = 5, --[[喝酒/烟花奖励次数]]
		add_exp_per = 10, --[[喝酒/烟花经验值增加百分比]]
		valid_time = 180, --[[喝酒/烟花生效时长/秒]]
		add_exp_per_max = 200, --[[喝酒/烟花经验值增加百分比上限]]
		right_reward = {{5,50000},{6,50}}, --[[答题正确奖励]]
		wrong_reward = {}, --[[答题错误奖励]]
		dice_rank_reward = {{40021301,1},{40021302,1},{40021303,1},{40021304,1}}, --[[骰子排名奖励]]
		reward_1 = {{1,20000},{3,5},{15,500}}, --[[宝箱奖励]]
		exp_reward_1 = {0,0,0}, --[[宝箱经验奖励]]
	} ,
	[2] = {
		code = 2, --[[活动类型]]
		exp_10s = {0,100,-7000}, --[[10秒奖励经验值]]
		reward_10s = {{6,10}}, --[[10秒奖励]]
		add_cost = 10, --[[喝酒/烟花消耗元宝]]
		add_donation = 50, --[[喝酒/烟花奖励军团贡献]]
		reward_times = 5, --[[喝酒/烟花奖励次数]]
		add_exp_per = 10, --[[喝酒/烟花经验值增加百分比]]
		valid_time = 180, --[[喝酒/烟花生效时长/秒]]
		add_exp_per_max = 200, --[[喝酒/烟花经验值增加百分比上限]]
		reward_2 = {{6,20}}, --[[佳肴奖励]]
		exp_reward_2 = {0,0,20000}, --[[佳肴经验奖励]]
		reward_3 = {{1,100}}, --[[散财童子奖励]]
		exp_reward_3 = {0,0,0}, --[[散财童子经验奖励]]
	} ,
}
return ret