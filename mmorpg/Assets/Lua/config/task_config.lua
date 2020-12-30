local ret = {
	[100001] = {
		code = 100001,
		name = "任务1",
		class = 1,
		sub_class = 1,
		level = 1,
		receive_npc = 0,
		receive_text = 
		{
			1001,1002
		},
		finish_npc = 0,
		finish_text = 
		{
			1002
		},
		target = 
		{
			30
		},
		pre_task = 0,
		next_task = 100002,
		exp_reward = 10,
		money_reward = 
		{
			1,20
		},
		disc = "任务描述",
		lottery_id = 0,
	} ,
}
return ret