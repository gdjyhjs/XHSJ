local ret = {
	["find_target_r_1"] = {
		name = "find_target_r_1", --[[常量名字]]
		value = 15.0, --[[值]]
		-- 法师技能寻敌人范围(单位米）
	} ,
	["find_target_r_2"] = {
		name = "find_target_r_2", --[[常量名字]]
		value = 15.0, --[[值]]
		-- 弓箭手技能寻敌人范围(单位米）
	} ,
	["find_target_r_4"] = {
		name = "find_target_r_4", --[[常量名字]]
		value = 15.0, --[[值]]
		-- 战士技能寻敌人范围(单位米）
	} ,
	["select_lose_r_1"] = {
		name = "select_lose_r_1", --[[常量名字]]
		value = 25.0, --[[值]]
		-- 法师选中失效距离（单位米）
	} ,
	["select_lose_r_2"] = {
		name = "select_lose_r_2", --[[常量名字]]
		value = 25.0, --[[值]]
		-- 弓箭手选中失效距离（单位米）
	} ,
	["select_lose_r_4"] = {
		name = "select_lose_r_4", --[[常量名字]]
		value = 25.0, --[[值]]
		-- 战士选中失效距离（单位米）
	} ,
	["hero_follow_d"] = {
		name = "hero_follow_d", --[[常量名字]]
		value = 5.0, --[[值]]
		-- 武将跟随距离（单位米）
	} ,
	["hero_atk_follow_d"] = {
		name = "hero_atk_follow_d", --[[常量名字]]
		value = 15.0, --[[值]]
		-- 武将攻击跟随距离（单位米）
	} ,
	["ani_connect_t"] = {
		name = "ani_connect_t", --[[常量名字]]
		value = 0.8, --[[值]]
		-- 普攻动作连接时间（单位秒
	} ,
	["team_follow_d"] = {
		name = "team_follow_d", --[[常量名字]]
		value = 10.0, --[[值]]
		-- 组队跟随距离（单位米） 
	} ,
	["team_refollow_t"] = {
		name = "team_refollow_t", --[[常量名字]]
		value = 5.0, --[[值]]
		-- 手动操作后重新跟随队长时间（秒）
	} ,
	["team_follow_stop_d"] = {
		name = "team_follow_stop_d", --[[常量名字]]
		value = 5.0, --[[值]]
		-- 组队跟随停止距离（米）
	} ,
	["legion_boss_food_id"] = {
		name = "legion_boss_food_id", --[[常量名字]]
		value = 40481201.0, --[[值]]
		-- 兽神口粮道具id
	} ,
	["legion_donation_id"] = {
		name = "legion_donation_id", --[[常量名字]]
		value = 49990006.0, --[[值]]
		-- 军团贡献道具id
	} ,
	["equip_max_level"] = {
		name = "equip_max_level", --[[常量名字]]
		value = 60.0, --[[值]]
		-- 装备最高等级
	} ,
	["team_member_count"] = {
		name = "team_member_count", --[[常量名字]]
		value = 3.0, --[[值]]
		-- 组队最大人数
	} ,
	["team_copy_enter_count"] = {
		name = "team_copy_enter_count", --[[常量名字]]
		value = 20.0, --[[值]]
		-- 组队荣誉奖励次数
	} ,
	["team_copy_reward"] = {
		name = "team_copy_reward", --[[常量名字]]
		value = 3.0, --[[值]]
		-- 组队奖励次数
	} ,
	["repeat_task_guild_id"] = {
		name = "repeat_task_guild_id", --[[常量名字]]
		value = 600001.0, --[[值]]
		-- 军团重复任务引导任务接取id
	} ,
	["magic_boss_d_lv"] = {
		name = "magic_boss_d_lv", --[[常量名字]]
		value = 100.0, --[[值]]
		-- 人物超过魔域boss的等级（击杀无掉落）
	} ,
	["first_war_lv"] = {
		name = "first_war_lv", --[[常量名字]]
		value = 500.0, --[[值]]
		-- 首场战斗显示的人物怪物等级
	} ,
	["offline_exp_id1"] = {
		name = "offline_exp_id1", --[[常量名字]]
		value = 40510302.0, --[[值]]
		-- 非绑离线经验卡道具id
	} ,
	["offline_exp_id2"] = {
		name = "offline_exp_id2", --[[常量名字]]
		value = 40511302.0, --[[值]]
		-- 绑定离线经验卡道具id
	} ,
	["hero_wash_open_level"] = {
		name = "hero_wash_open_level", --[[常量名字]]
		value = 200.0, --[[值]]
		-- 武将洗练开放等级
	} ,
	["horse_magic_open_level "] = {
		name = "horse_magic_open_level ", --[[常量名字]]
		value = 220.0, --[[值]]
		-- 坐骑封灵开放等级
	} ,
	["shop_coin_type"] = {
		name = "shop_coin_type", --[[常量名字]]
		value = 1021.0, --[[值]]
		-- 斗币商城
	} ,
	["shop_honor_type"] = {
		name = "shop_honor_type", --[[常量名字]]
		value = 1023.0, --[[值]]
		-- 荣誉商场
	} ,
	["shop_contribution_type"] = {
		name = "shop_contribution_type", --[[常量名字]]
		value = 1025.0, --[[值]]
		-- 贡献商场
	} ,
	["hero_exp_book1"] = {
		name = "hero_exp_book1", --[[常量名字]]
		value = 40111201.0, --[[值]]
		-- 武将低级经验书
	} ,
	["hero_exp_book2"] = {
		name = "hero_exp_book2", --[[常量名字]]
		value = 40111301.0, --[[值]]
		-- 武将中级经验书
	} ,
	["hero_exp_book3"] = {
		name = "hero_exp_book3", --[[常量名字]]
		value = 40111401.0, --[[值]]
		-- 武将高级经验书
	} ,
	["monster_speed_scale"] = {
		name = "monster_speed_scale", --[[常量名字]]
		value = 2.0, --[[值]]
		-- 客户怪物位置和服务器攻击位置有偏移，以多少倍速度移动到攻击位置
	} ,
}
return ret