local ret = {
	[0] = {
		property_type = 0, --[[属性类型]]
		name = "速度", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[1] = {
		property_type = 1, --[[属性类型]]
		name = "攻击", --[[对应文字]]
		conefficient = 20000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 20000, --[[后端战力计算系数]]
	} ,
	[2] = {
		property_type = 2, --[[属性类型]]
		name = "生命", --[[对应文字]]
		conefficient = 1000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 1000, --[[后端战力计算系数]]
	} ,
	[3] = {
		property_type = 3, --[[属性类型]]
		name = "物防", --[[对应文字]]
		conefficient = 5000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 5000, --[[后端战力计算系数]]
	} ,
	[4] = {
		property_type = 4, --[[属性类型]]
		name = "法防", --[[对应文字]]
		conefficient = 5000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 5000, --[[后端战力计算系数]]
	} ,
	[5] = {
		property_type = 5, --[[属性类型]]
		name = "暴击", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[6] = {
		property_type = 6, --[[属性类型]]
		name = "命中", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[7] = {
		property_type = 7, --[[属性类型]]
		name = "闪避", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[8] = {
		property_type = 8, --[[属性类型]]
		name = "穿透", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[9] = {
		property_type = 9, --[[属性类型]]
		name = "坚韧", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[10] = {
		property_type = 10, --[[属性类型]]
		name = "免伤", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[11] = {
		property_type = 11, --[[属性类型]]
		name = "格挡", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[12] = {
		property_type = 12, --[[属性类型]]
		name = "暴击伤害", --[[对应文字]]
		conefficient = 50000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 50000, --[[后端战力计算系数]]
	} ,
	[13] = {
		property_type = 13, --[[属性类型]]
		name = "物防率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[14] = {
		property_type = 14, --[[属性类型]]
		name = "法防率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[15] = {
		property_type = 15, --[[属性类型]]
		name = "暴击率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[16] = {
		property_type = 16, --[[属性类型]]
		name = "命中率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[17] = {
		property_type = 17, --[[属性类型]]
		name = "闪避率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[18] = {
		property_type = 18, --[[属性类型]]
		name = "穿透率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[19] = {
		property_type = 19, --[[属性类型]]
		name = "抗暴", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[20] = {
		property_type = 20, --[[属性类型]]
		name = "免伤率", --[[对应文字]]
		conefficient = 40000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[21] = {
		property_type = 21, --[[属性类型]]
		name = "格挡率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[22] = {
		property_type = 22, --[[属性类型]]
		name = "回血", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[23] = {
		property_type = 23, --[[属性类型]]
		name = "回血率", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[24] = {
		property_type = 24, --[[属性类型]]
		name = "伤害", --[[对应文字]]
		conefficient = 40000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 10000, --[[后端战力计算系数]]
	} ,
	[37] = {
		property_type = 37, --[[属性类型]]
		name = "备用", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[40] = {
		property_type = 40, --[[属性类型]]
		name = "击杀经验加成", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[41] = {
		property_type = 41, --[[属性类型]]
		name = "魔域绝地击杀十倍经验奖励", --[[对应文字]]
		conefficient = 0, --[[客户端用的评分系数]]
		is_percent = 0, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10001] = {
		property_type = 10001, --[[属性类型]]
		name = "攻击", --[[对应文字]]
		conefficient = 30000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10002] = {
		property_type = 10002, --[[属性类型]]
		name = "生命", --[[对应文字]]
		conefficient = 30000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10003] = {
		property_type = 10003, --[[属性类型]]
		name = "物防", --[[对应文字]]
		conefficient = 5000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10004] = {
		property_type = 10004, --[[属性类型]]
		name = "法防", --[[对应文字]]
		conefficient = 5000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10005] = {
		property_type = 10005, --[[属性类型]]
		name = "暴击", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10006] = {
		property_type = 10006, --[[属性类型]]
		name = "命中", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10007] = {
		property_type = 10007, --[[属性类型]]
		name = "闪避", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10008] = {
		property_type = 10008, --[[属性类型]]
		name = "穿透", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10009] = {
		property_type = 10009, --[[属性类型]]
		name = "坚韧", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10010] = {
		property_type = 10010, --[[属性类型]]
		name = "伤害减免", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10011] = {
		property_type = 10011, --[[属性类型]]
		name = "格挡", --[[对应文字]]
		conefficient = 10000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10012] = {
		property_type = 10012, --[[属性类型]]
		name = "暴击伤害系数", --[[对应文字]]
		conefficient = 5000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10024] = {
		property_type = 10024, --[[属性类型]]
		name = "伤害", --[[对应文字]]
		conefficient = 40000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
	[10022] = {
		property_type = 10022, --[[属性类型]]
		name = "回血", --[[对应文字]]
		conefficient = 20000, --[[客户端用的评分系数]]
		is_percent = 1, --[[是否按百分号显示]]
		s_coefficient = 0, --[[后端战力计算系数]]
	} ,
}
return ret