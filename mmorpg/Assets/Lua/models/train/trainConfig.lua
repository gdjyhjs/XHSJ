local Enum = require("enum.enum")

-- Enum.ALLIANCE_TRAIN_TYPE = {
-- 	PLAYER_DAMAGE = 1,		--人物伤害增加
-- 	PLAYER_PROTECT = 2,		--人物受伤减免
-- 	PLAYER_HEALTH = 3,		--人物生命增加
-- 	HERO_DAMAGE = 4,		--武将伤害增加
-- 	HERO_PROTECT = 5,		--武将受伤减免
-- 	HERO_HEALTH = 6,		--武将生命增加
-- }

TRAIN_YPTE_NAME = 
{
	[Enum.ALLIANCE_TRAIN_TYPE.PLAYER_DAMAGE] 	= gf_localize_string("伤害"),
	[Enum.ALLIANCE_TRAIN_TYPE.PLAYER_PROTECT] 	= gf_localize_string("免伤"),
	[Enum.ALLIANCE_TRAIN_TYPE.PLAYER_HEALTH] 	= gf_localize_string("生命"),
	[Enum.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE] 		= gf_localize_string("伤害"),
	[Enum.ALLIANCE_TRAIN_TYPE.HERO_PROTECT] 	= gf_localize_string("免伤"),
	[Enum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH] 		= gf_localize_string("生命"),
}
TRAIN_YPTE_PROPERTY_NAME = 
{
	[Enum.ALLIANCE_TRAIN_TYPE.PLAYER_DAMAGE] 	= gf_localize_string("伤害"),
	[Enum.ALLIANCE_TRAIN_TYPE.PLAYER_PROTECT] 	= gf_localize_string("伤害减免"),
	[Enum.ALLIANCE_TRAIN_TYPE.PLAYER_HEALTH] 	= gf_localize_string("生命"),
	[Enum.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE] 		= gf_localize_string("伤害"),
	[Enum.ALLIANCE_TRAIN_TYPE.HERO_PROTECT] 	= gf_localize_string("伤害减免"),
	[Enum.ALLIANCE_TRAIN_TYPE.HERO_HEALTH] 		= gf_localize_string("生命"),
}

RANK_LEVEL = 5 --每阶有几级