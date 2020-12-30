local ret = {
	[0] = {
		id = 0, --[[自增id]]
		name = "主界面", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 999, --[[参与等级]]
		cool = 0, --[[发言冷却]]
		send_channel = {0,1,2,3,4,8,9,11}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#FF0000", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_01", --[[标签图标]]
	} ,
	[1] = {
		id = 1, --[[自增id]]
		name = "世界", --[[频道名称]]
		page_level = 0, --[[页签开启等级]]
		level = 30, --[[参与等级]]
		cool = 10, --[[发言冷却]]
		send_channel = {1,9}, --[[该频道要接收哪些频道的信息]]
		save_count = 30, --[[保存信息条数]]
		font_color = "#ffe63f", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_01", --[[标签图标]]
	} ,
	[2] = {
		id = 2, --[[自增id]]
		name = "当前", --[[频道名称]]
		page_level = 0, --[[页签开启等级]]
		level = 0, --[[参与等级]]
		cool = 1, --[[发言冷却]]
		send_channel = {2}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#d9d4c2", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_02", --[[标签图标]]
	} ,
	[3] = {
		id = 3, --[[自增id]]
		name = "军团", --[[频道名称]]
		page_level = 0, --[[页签开启等级]]
		level = 30, --[[参与等级]]
		cool = 1, --[[发言冷却]]
		send_channel = {3}, --[[该频道要接收哪些频道的信息]]
		save_count = 30, --[[保存信息条数]]
		font_color = "#79d6f4", --[[字体颜色]]
		use_function = 29, --[[可使用的功能]]
		label_cion = "chat_label_04", --[[标签图标]]
	} ,
	[4] = {
		id = 4, --[[自增id]]
		name = "队伍", --[[频道名称]]
		page_level = 0, --[[页签开启等级]]
		level = 0, --[[参与等级]]
		cool = 1, --[[发言冷却]]
		send_channel = {4}, --[[该频道要接收哪些频道的信息]]
		save_count = 30, --[[保存信息条数]]
		font_color = "#9df276", --[[字体颜色]]
		use_function = 29, --[[可使用的功能]]
		label_cion = "chat_label_03", --[[标签图标]]
	} ,
	[5] = {
		id = 5, --[[自增id]]
		name = "副本", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 30, --[[参与等级]]
		cool = 1, --[[发言冷却]]
		send_channel = {5}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#FF0005", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_03", --[[标签图标]]
	} ,
	[6] = {
		id = 6, --[[自增id]]
		name = "战场", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 30, --[[参与等级]]
		cool = 1, --[[发言冷却]]
		send_channel = {6}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#FF0006", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_03", --[[标签图标]]
	} ,
	[7] = {
		id = 7, --[[自增id]]
		name = "场景", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 30, --[[参与等级]]
		cool = 1, --[[发言冷却]]
		send_channel = {7}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#FF0007", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_03", --[[标签图标]]
	} ,
	[8] = {
		id = 8, --[[自增id]]
		name = "系统", --[[频道名称]]
		page_level = 0, --[[页签开启等级]]
		level = 999, --[[参与等级]]
		cool = 0, --[[发言冷却]]
		send_channel = {8,11}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#FB535E", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_05", --[[标签图标]]
	} ,
	[9] = {
		id = 9, --[[自增id]]
		name = "喇叭", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 0, --[[参与等级]]
		cool = 0, --[[发言冷却]]
		send_channel = {}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#ff6363", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_05", --[[标签图标]]
	} ,
	[10] = {
		id = 10, --[[自增id]]
		name = "走马灯", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 999, --[[参与等级]]
		cool = 0, --[[发言冷却]]
		send_channel = {}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#FF0010", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_05", --[[标签图标]]
	} ,
	[11] = {
		id = 11, --[[自增id]]
		name = "系统", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 999, --[[参与等级]]
		cool = 0, --[[发言冷却]]
		send_channel = {}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#f85e5e", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_05", --[[标签图标]]
	} ,
	[12] = {
		id = 12, --[[自增id]]
		name = "联盟", --[[频道名称]]
		page_level = 999, --[[页签开启等级]]
		level = 999, --[[参与等级]]
		cool = 0, --[[发言冷却]]
		send_channel = {}, --[[该频道要接收哪些频道的信息]]
		save_count = 999, --[[保存信息条数]]
		font_color = "#FF0012", --[[字体颜色]]
		use_function = 28, --[[可使用的功能]]
		label_cion = "chat_label_05", --[[标签图标]]
	} ,
}
return ret