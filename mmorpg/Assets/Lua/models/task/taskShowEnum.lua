local taskShowEnum = {}
--日常活动类型
taskShowEnum.TaskTitleString = 
{
	[ServerEnum.TASK_TYPE.MAIN] 			= gf_localize_string("[主]"),
	[ServerEnum.TASK_TYPE.BRANCH] 			= gf_localize_string("[支]"),
	[ServerEnum.TASK_TYPE.DAILY] 			= gf_localize_string("[日]"),
	[ServerEnum.TASK_TYPE.ALLIANCE_DAILY] 	= gf_localize_string("[军]"),
	[ServerEnum.TASK_TYPE.ESCORT] 			= gf_localize_string("[护]"),
	[ServerEnum.TASK_TYPE.ALLIANCE_REPEAT] 	= gf_localize_string("[军]"),
	[ServerEnum.TASK_TYPE.FACTION] 			= gf_localize_string("[战]"),
	[ServerEnum.TASK_TYPE.ALLIANCE_PARTY] 	= gf_localize_string("[宴]"),
	[ServerEnum.TASK_TYPE.ALLIANCE_GUILD] 	= gf_localize_string("[军]"),
	[ServerEnum.TASK_TYPE.EVERY_DAY] 		= gf_localize_string("[日]"),
	[ServerEnum.TASK_TYPE.EVERY_DAY_GUILD] 	= gf_localize_string("[日]"),
}

taskShowEnum.SubTypeString =
{
	[ServerEnum.TASK_SUB_TYPE.KILL_CREATURE] 		= gf_localize_string("击败<color=#67f858>%s</color> %d/%d"),  		-- 怪物
	[ServerEnum.TASK_SUB_TYPE.COLLECT]       		= gf_localize_string("采集<color=#67f858>%s</color> %d/%d"),  		-- 采集
	[ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP]    		= gf_localize_string("找<color=#67f858>%s</color>对话"),       	-- 找npc对话
	[ServerEnum.TASK_SUB_TYPE.NPC_HAND_UP]   		= gf_localize_string("将<color=#67f858>%s</color>交给<color=#67f858>%s</color>"), 		-- 上交道具给npc
	[ServerEnum.TASK_SUB_TYPE.CHALLENGECOPY] 		= gf_localize_string("通关<color=#67f858>%s</color>"),     	-- 挑战副本
	[ServerEnum.TASK_SUB_TYPE.LEVEL_UP]      		= gf_localize_string("等级提升到<color=#67f858>%s</color>"),  		-- 升级
	[ServerEnum.TASK_SUB_TYPE.DESTINATION]   		= gf_localize_string("前往<color=#67f858>%s</color>[%d,%d]"),    	-- 到达地图上的某个点
	[ServerEnum.TASK_SUB_TYPE.ENTER_COPY]   		= gf_localize_string("进入<color=#67f858>%s</color>副本"),    		-- 进入副本
	[ServerEnum.TASK_SUB_TYPE.ALLIANCE_DAILY]	 	= gf_localize_string("收集资源(点击查看)"), --军团任务
	[ServerEnum.TASK_SUB_TYPE.ESCORT]   			= gf_localize_string("护送<color=#67f858>%s</color>"), 			--护送任务
	[ServerEnum.TASK_SUB_TYPE.ENHANCE_EQUIP]		= gf_localize_string("强化装备到10级 %d/%d个"), 	-- 强化装备
	[ServerEnum.TASK_SUB_TYPE.FORMULA_EQUIP]		= gf_localize_string("打造紫色装备 %d/%d件"), 	-- 打造装备
	[ServerEnum.TASK_SUB_TYPE.POLISH_EQUIP]			= gf_localize_string("洗练装备 %d/%d次"), 	-- 洗练装备
	[ServerEnum.TASK_SUB_TYPE.INLAY_GEM]			= gf_localize_string("镶嵌宝石 %d/%d颗"), 	-- 镶嵌宝石
	[ServerEnum.TASK_SUB_TYPE.STAGE_UP_HORSE]		= gf_localize_string("坐骑进阶到1阶5星"), 	-- 坐骑进阶
	[ServerEnum.TASK_SUB_TYPE.POLISH_HERO]			= gf_localize_string("武将洗练 %d/%d次"), 	-- 武将洗练
	[ServerEnum.TASK_SUB_TYPE.UPGRADE_SOUL_HOURSE]	= gf_localize_string("坐骑封灵 %d/%d次"),-- 坐骑封灵
	[ServerEnum.TASK_SUB_TYPE.SKILL_LEVEL_UP]		= gf_localize_string("升级 %d/%d次技能"), 	-- 升级技能
	[ServerEnum.TASK_SUB_TYPE.FACTION_HAND_UP]		= gf_localize_string("上交<color=#67f858>3颗</color>能量珠 %d/%d"),
	[ServerEnum.TASK_SUB_TYPE.FACTION_KILL]			= gf_localize_string("击败<color=#67f858>3人</color> %d/%d\n助攻<color=#67f858>5人</color> %d/%d\n死亡<color=#67f858>3次</color> %d/%d"),
	[ServerEnum.TASK_SUB_TYPE.ALLIANCE_JOIN]		= gf_localize_string("创建/加入军团"),
	[ServerEnum.TASK_SUB_TYPE.SHAKE_MONEY_TREE]		= gf_localize_string("累计摇钱 %d/%d次"),
	[ServerEnum.TASK_SUB_TYPE.HERO_LEVEL_UP]		= gf_localize_string("任意武将升级到 %d/%d级"),
	[ServerEnum.TASK_SUB_TYPE.DEATHTRAP_EXP]		= gf_localize_string("10倍经验击杀 %d/%d"),
	[ServerEnum.TASK_SUB_TYPE.TOWER_COPY_FLOOR]		= gf_localize_string("通关爬塔副本 %d层"),

}
taskShowEnum.SubTypeStringView =
{
	[ServerEnum.TASK_SUB_TYPE.KILL_CREATURE] 		= gf_localize_string("到<color=#B85200>%s</color>击败<color=#3FA734>%s</color> %d/%d"),  		-- 怪物
	[ServerEnum.TASK_SUB_TYPE.COLLECT]       		= gf_localize_string("到<color=#B85200>%s</color>采集<color=#3FA734>%s</color> %d/%d"),  		-- 采集
	[ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP]    		= gf_localize_string("到<color=#B85200>%s</color>找<color=#3FA734>%s</color>对话"),       	-- 找npc对话
	[ServerEnum.TASK_SUB_TYPE.NPC_HAND_UP]   		= gf_localize_string("将<color=#B85200>%s</color>交给<color=#3FA734>%s</color>"), 		-- 上交道具给npc
	[ServerEnum.TASK_SUB_TYPE.CHALLENGECOPY] 		= gf_localize_string("通关<color=#B85200>%s</color>"),     	-- 挑战副本
	[ServerEnum.TASK_SUB_TYPE.LEVEL_UP]      		= gf_localize_string("等级提升到<color=#B85200>%s</color>"),  		-- 升级
	[ServerEnum.TASK_SUB_TYPE.DESTINATION]   		= gf_localize_string("前往<color=#B85200>%s</color>[%d,%d]"),    	-- 到达地图上的某个点
	[ServerEnum.TASK_SUB_TYPE.ENTER_COPY]   		= gf_localize_string("进入<color=#B85200>%s</color>副本"),    		-- 进入副本
	[ServerEnum.TASK_SUB_TYPE.ALLIANCE_DAILY]	 	= gf_localize_string("收集资源(点击查看)"), --军团任务
	[ServerEnum.TASK_SUB_TYPE.ESCORT]   			= gf_localize_string("护送<color=#67f858>%s</color>"), 			--护送任务
	[ServerEnum.TASK_SUB_TYPE.ENHANCE_EQUIP]		= gf_localize_string("强化装备到10级 %d/%d个"), 	-- 强化装备
	[ServerEnum.TASK_SUB_TYPE.FORMULA_EQUIP]		= gf_localize_string("打造紫色装备 %d/%d件"), 	-- 打造装备
	[ServerEnum.TASK_SUB_TYPE.POLISH_EQUIP]			= gf_localize_string("洗练装备 %d/%d次"), 	-- 洗练装备
	[ServerEnum.TASK_SUB_TYPE.INLAY_GEM]			= gf_localize_string("镶嵌宝石 %d/%d颗"), 	-- 镶嵌宝石
	[ServerEnum.TASK_SUB_TYPE.STAGE_UP_HORSE]		= gf_localize_string("坐骑进阶到1阶5星"), 	-- 坐骑进阶
	[ServerEnum.TASK_SUB_TYPE.POLISH_HERO]			= gf_localize_string("武将洗练 %d/%d次"), 	-- 武将洗练
	[ServerEnum.TASK_SUB_TYPE.UPGRADE_SOUL_HOURSE]	= gf_localize_string("坐骑封灵 %d/%d次"),-- 坐骑封灵
	[ServerEnum.TASK_SUB_TYPE.SKILL_LEVEL_UP]		= gf_localize_string("升级 %d/%d次技能"), 	-- 升级技能
	[ServerEnum.TASK_SUB_TYPE.FACTION_HAND_UP]		= gf_localize_string("上交<color=#67f858>3颗</color>能量珠 %d/%d"),
	[ServerEnum.TASK_SUB_TYPE.FACTION_KILL]			= gf_localize_string("击败<color=#67f858>3人</color> %d/%d\n助攻<color=#67f858>5人</color> %d/%d\n死亡<color=#67f858>3次</color> %d/%d"),
	[ServerEnum.TASK_SUB_TYPE.ALLIANCE_JOIN]		= gf_localize_string("创建/加入军团"),
	[ServerEnum.TASK_SUB_TYPE.SHAKE_MONEY_TREE]		= gf_localize_string("累计摇钱 %d/%d次"),
	[ServerEnum.TASK_SUB_TYPE.HERO_LEVEL_UP]		= gf_localize_string("任意武将升级到 %d/%d级"),
	[ServerEnum.TASK_SUB_TYPE.DEATHTRAP_EXP]		= gf_localize_string("10倍经验击杀 %d/%d"),
	[ServerEnum.TASK_SUB_TYPE.TOWER_COPY_FLOOR]		= gf_localize_string("通关爬塔副本 %d层"),
}
taskShowEnum.TaskTitle = {
	[ServerEnum.TASK_TYPE.MAIN] =gf_localize_string("主线任务"),
	[ServerEnum.TASK_TYPE.BRANCH] =gf_localize_string("支线任务"),
	[ServerEnum.TASK_TYPE.DAILY] =gf_localize_string("日常任务"),
	[ServerEnum.TASK_TYPE.ALLIANCE_DAILY] =gf_localize_string("军团任务"),
	[ServerEnum.TASK_TYPE.ESCORT]  =gf_localize_string("护送任务"),
	[ServerEnum.TASK_TYPE.ALLIANCE_REPEAT] 	= gf_localize_string("军团任务"),
	[ServerEnum.TASK_TYPE.FACTION] 		= gf_localize_string("战场任务"),
	[ServerEnum.TASK_TYPE.ALLIANCE_PARTY] 	= gf_localize_string("军团任务"),
	[ServerEnum.TASK_TYPE.ALLIANCE_GUILD] 	= gf_localize_string("军团任务"),
	[ServerEnum.TASK_TYPE.EVERY_DAY] 	= gf_localize_string("每日任务"),
	[ServerEnum.TASK_TYPE.EVERY_DAY_GUILD] 	= gf_localize_string("每日任务"),
}
return taskShowEnum