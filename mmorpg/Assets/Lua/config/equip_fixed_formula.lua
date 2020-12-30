local ret = {
	[100001] = {
		formulaId = 100001, --[[打造id  请区分与 equip_formula的id的不同]]
		code = 14010002, --[[装备原型]]
		level = 1, --[[等级]]
		base_attr = 
		{
			
			{
				1,200
			}
		}, --[[基础属性]]
		color = 1, --[[品质]]
		ex_attr = 
		{
			
			{
				1,200
			}
		}, --[[额外属性]]
		spec = 1, --[[特效]]
		prefix = 1, --[[前缀]]
		need_item = 
		{
			
			{
				40080201,1
			}
		}, --[[打造需要物品]]
		need_money = 1111, --[[需要金钱]]
	} ,
}
return ret