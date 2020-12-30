prepareHoleCount = 6 				--预备出战槽位数量

heroType = 
{
	property 		= 1, 			-- 属性
	list    		= 2,			-- 名将录
	front 			= 3,			-- 布阵 
	wash 			= 4,			-- 洗炼 
}
hero_item_skill_book_id = 40120201

mutate_property_add_rate = 0.1


local Enum = require("enum.enum")



POWER_EX_RATE = 
{
	[Enum.COMBAT_ATTR.ATTACK] 		= 0.8,
	[Enum.COMBAT_ATTR.HP] 			= 0.05,
	[Enum.COMBAT_ATTR.PHY_DEF] 		= 0.4,
	[Enum.COMBAT_ATTR.MAGIC_DEF] 	= 0.4,
	[Enum.COMBAT_ATTR.CRIT] 		= 0.6,
	[Enum.COMBAT_ATTR.THROUGH] 		= 0.6,
	[Enum.COMBAT_ATTR.HIT] 			= 0.5,
	[Enum.COMBAT_ATTR.DODGE] 		= 0.5,
	[Enum.COMBAT_ATTR.CRIT_DEF] 	= 0.6,
	[Enum.COMBAT_ATTR.CRIT_DEF] 	= 0.6,
	[Enum.COMBAT_ATTR.CRIT_DEF] 	= 0.6,
	[Enum.COMBAT_ATTR.CRIT_DEF] 	= 0.6,
}

SKILL_POWER_LOW = 1000
SKILL_POWER_HIG = 5000
