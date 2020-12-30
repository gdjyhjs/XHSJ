
-- 一些只有服务端才用到的定义
local tb = {}

tb.ID_RESERVE = 1000000000	--一些区内唯一id保留的位数

--资源流水类型
tb.RES_LOG = {
	DEBUG                          = 1,           --外挂功能
	AUTO_ADD                       = 2,           --自动回复
	RESPAWN                        = 3,           --复活
	TASK_REWARD                    = 4,           --完成任务奖励
	WAKE_UP_HERO                   = 5,
	UNLOCK_SQUARE_POS              = 6,
	ADD_HERO_EXP                   = 7,
	SET_HERO_EQUIP                 = 8,
	RECYCLE_HERO                   = 9,
	SKILL_LEVEL_UP                 = 10,          --技能升级消耗
	POLISH_HERO                    = 11,
	UNLOCK_HERO_SLOT               = 12,
	SET_HERO_EQUIP                 = 13,
	GAIN_SKILL_BY_BOOK             = 14,
    COPY_PASS                      = 15,          --副本通关奖励
	ENTER_COPY                     = 16,          --进入副本消耗
	COPY_BOX                       = 17,          --副本宝箱
	COPY_RESET                     = 18,          --副本重置
	CREATURE_DROP                  = 19,          --怪物掉落
	COPY_SWEEP                     = 20,          --扫荡副本
	ALLIANCE_BUILD                 = 21,          --创建军团
	FRIEND_GIVE                    = 22,          --朋友赠送
	ALLIANCE_FORBIND_CHAT          = 23,          --禁言军团成员
	ALLIANCE_UPGRADE_COMMIT        = 24,          --军团升级上交物资
	ALLIANCE_DEVOTE                = 25,          --军团捐献
	ALLIANCE_ANNOUNCEMENT          = 26,          --发送公告
	ALLIANCE_GETWEEKREWARD         = 27,          --军团每周奖励
	ALLIANCE_TRAIN                 = 28,          --军团修炼
	GET_EMAIL_REWARD               = 29,          --邮件奖励
	DAILY_ACTIVE_REWARD            = 30,          --日常活跃奖励
	FLOWER_GIVE                    = 31,          --赠送鲜花
	DAILY_TASK_REWARD              = 32,          --天机任务奖励
	DAILY_TASK_REFRESH             = 33,          --天机任务刷新消耗
	DAILY_TASK_BUY_TIMES           = 34,          --天机任务购买次数
	QUESTION_DAILY_PER             = 35,          --每日答题回答一题奖励
	STRENGTH_BUY                   = 36,          --购买体力
	STRENGTH_BUY_RESET             = 37,          --重置购买体力次数
	HOLY_COPY_DAILY_REWARD         = 38,          --过关斩将每日奖励
	ARENA_ADD_CHALLENGE            = 39,          --添加竞技场挑战次数
	HORSE_TURN_ITEM                = 40,          --因已存在该坐骑开出来的变成物品
	OPEN_FUNC                      = 41,          --功能开启
	BUY_ITEM                       = 42,          --物品购买
	MONEY_TREE                     = 43,          --物品购买
	MONEY_TREE_AWARD               = 44,          --物品购买
	SMELT                          = 45,          --熔炼物品
	SPLIT_ITEM                     = 46,          --拆分物品
	INLAY_GEM                      = 47,          --镶嵌宝石
	ADD_HORSE_EXP                  = 48,          --使用物品增加坐骑经验
	ENHANCE_EQUIP                  = 49,          --强化装备
	FORMULA_EQUIP                  = 50,          --打造装备
	POLISH_EQUIP                   = 51,          --洗炼装备
	POLISH_HERO                    = 52,          --洗炼武将
	SPEAKER                        = 53,          --聊天使用大喇叭
	UNLOCK_MARKET                  = 54,          --扩展市场位
	CANCEL_SELL                    = 55,          --取消挂售
	MARKET_SELL_ITEM               = 56,          --市场挂售获取得到的收入
	REFRESH_MARKET                 = 57,          --市场刷新
	MARKET_BUY_ITEM                = 58,          --市场购买物品获得
	VIP_LEVEL_GIFT                 = 59,          --打开vip等级礼包
	OFFICE_DAILY_REAWRD            = 60,          --官职每日俸禄
	ACTIVE_2_FAME                  = 61,          --获得活跃度增加名望值
	MARKET_SELL_ITEM_GAIN          = 62,          --市场挂售获取得到的收入
	TREASURE_MAP_REWARD            = 63,          --挖宝图奖励
	TREASURE_MAP_DEDUCT            = 64,          --挖宝图消耗宝图
	ALLIANCE_DAILY_TASK_COST       = 65,          --军团每日任务提交物品
	ALLIANCE_DAILY_TASK_REWARD     = 66,          --军团每日任务奖励
	EQUIP_RECYCLE                  = 67,          --回收装备取得淬火
	ALLIANCE_LEGION_BOSS_REWARD    = 68,          --军团领地boss奖励
	EXIT_ALLIANCE                  = 69,          --退出/被踢出 军团 贡献、仓库积分清零
	DRAW_DESTINY                   = 70,          --抽取天命
	DESTINY_BREAK_THROUGH          = 71,          --突破天命
	ALLIANCE_AUCTION_OFFER         = 72,          --军团竞拍出价扣除
	ALLIANCE_AUCTION_FAIL          = 73,          --军团竞拍失败返还竞拍出价
	ARENA_DAILY_REWARD             = 74,          --竞技场每日奖励
	WORLD_BOSS_DROP                = 75,          --地洞boss掉落
	TEAM_COPY_REWARD               = 76,          --组队副本奖励
	REDEEM                         = 77,          --兑换
	UNLOCK_SLOT                    = 78,          --解锁格子消耗
	SELL_ITEM                      = 79,          --出售物品
	ADD_HERO_EXP                   = 80,          --武将加经验
	ESCORT_FRESH_QUALITY           = 81,          --护送任务刷新品质
	ESCORT_FINISH                  = 82,          --完成护送任务奖励
	ALLIANCE_WAR_FLAG_INSPIRE      = 83,          --军团战旗激励消耗
	ADD_HERO_TALENT                = 84,          --通过使用物品来增加资质
	SIGNIN_GAIN_ITEM               = 85,          --通过签到来获得物品
	FORMULA_EQUIP_COLOR_BASE       = 86,          --打造装备时用来保底品质消耗掉的物品
	ONLINE_GIFT_GAIN               = 87,          --在线时长礼包开出来之后获得物品
	WEEK_ONLINE_GIFT_GAIN          = 88,          --每周在线时长礼包开出来之后获得绑定元宝
	REST_ADD_EXP                   = 89,          --打坐获得经验
	RESET_MATERIAL_COPY_TIMES      = 90,          --重置材料副本次数
	MATERIAL_REWARD                = 91,          --材料副本奖励
	FACTION_OPER_REWARD            = 92,          -- 战场操作奖励
	TOWER_FLOOR_PASS               = 93,          --爬塔副本通过一层
	SURFACE_USE_ITEM               = 94,          --使用外观相关物品
	ACTIVE_SURFACE                 = 95,          --激活外观消耗道具
	FIRST_RECHARGE_REWARD          = 96,          --首充奖励
	LEVEL_GIFT                     = 97,          --等级奖励
	LOGIN_15                       = 98,          --15天登录奖励
	LOTTERY_COST_ITEM              = 99,          --秘境寻宝消耗物品 秘境钥匙
	LOTTERY_REWARD                 = 100,         --秘境寻宝物品奖励
	LOTTERY_POINT                  = 101,         --秘境寻宝积分奖励
	INVEST                         = 102,         --投资
	WEEK_CARD                      = 103,         --投资
	MONTH_CARD                     = 104,         --投资
	ARENA_WIN                      = 105,         --竞技场赢
	NEEDFIRE_DRINK                 = 106,         --军团篝火晚会喝酒消耗元宝
	PARTY_FIREWORK                 = 107,         --军团宴会放烟花消耗元宝
	ALLIANCE_LEGION_COLLECTION     = 108,         --军团篝火晚会采集物奖励
	ALLIANCE_LEGION_ACT_REWARD     = 109,         --军团篝火/宴会每十秒奖励
	AWAKEN_HERO                    = 110,
	NEEDFIRE_DRINK_REWARD          = 111,         --军团篝火喝酒奖励军团贡献
	TEAM_VS_COPY_PASS              = 112,         --3v3组队副本通关奖励
	MAGIC_BOSS_DROP                = 113,         --魔域领主boss掉落
	FREE_LUNCH                     = 114,         --免费午餐
	FREE_DINNER                    = 115,         --免费晚餐
	GEM_LEVEL_UP                   = 116,         --宝石升级
	FEED_HORSE                     = 117,         --喂骑宠
	USE_ITEM_PROTOCOL              = 118,         --通过协议使用物品
	HORSE_SLOT_LEVEL_UP            = 119,         --使用坐骑灵玉
	CARDS_GAME_DAILY_REWARD        = 120,         --牌局每日胜场奖励
	BREAK_THROUGH                  = 121,         --突破消耗突破石
	MERGE_OR_SORT_BAG              = 122,         --整理或者排序引起物品数量变化
	ACHIEVE_REWARD 				   = 123,		  --成就奖励
	PROTECT_CITY_PASS              = 124,         --魔族围城通关
	SWAP_EQUIP_GEM_BACK_TO_BAG     = 125,         --因换装备换成了能装备宝石数量较少时宝石进入背包的数量变化
	INLAY_GEM_REPLACE              = 126,         --替换宝石
	HAND_IN_FOOD_REWARD_DONATE     = 127,         --上交军团口粮奖励军团贡献
	HAND_IN_ALLIANCE_STORE_LOSE_EQUIP = 128,      --捐献装备到军团仓库 失去装备
	HAND_IN_ALLIANCE_STORE_ADD_POINT  = 129,      --捐献装备到军团仓库 奖励仓库积分
	EXCHANGE_ALLIANCE_STORE_EQUIP_COST= 130,      --兑换军团仓库装备消耗仓库积分
	HAND_IN_FOOD_LOSE_FOOD         = 131,         --上交军团口粮失去口粮
	RESOLVE_DESTINY 			   = 132, 		  --分解天命
	UPGRADE_DESTINY 			   = 133, 		  --升级天命
	ASTROLABE_REWARD               = 134,         --星盘目标达成
	ACTIVITY_REWARD 			   = 135, 		  --领取活动奖励
	BUY_WEEK_MONTH_CARD            = 136,         --购买周卡/月卡
	ACITVITY_REWARD_COST 		   = 137, 		  --领取活动奖励消耗
	DEATHTRAP_INSPIRE              = 138,         --魔狱绝地鼓舞消耗
	EVERY_DAY_TASK_EX_REWARD       = 139, 		  --每日任务20环奖励
	ALLIANCE_REPEAT_TASK_EX_REWARD = 140,         --军团任务每10环额外奖励
	OFFLINE_EXP                    = 141,         --领取离线经验
	ALLIANCE_DEVOTE_REWARD         = 142,         --军团捐献奖励
	CARDS_GAME_FAME_REWARD         = 143,         --牌局每日胜场声望奖励
	GIVE_STRENGTH_RETURN           = 144,         --赠送体力返还
	EMAIL_PRE_DROP_EQUIP           = 145,         --邮件收到装备预先创建装备obj
	ANSWER_NEEDFIRE_QUESTION       = 146,         --回答军团领地篝火晚会题目
	PARTY_FIREWORK_REWARD          = 147,         --军团宴会放烟花奖励军团贡献
}


--事件管理器的事件类型
tb.EVENT = {
	KILL_CREATURE      = 1,	   -- 击杀怪物
	COLLECT            = 2,	   -- 采集
	NPC_GOSSIP         = 3,    -- 找npc对话
	NPC_HAND_UP        = 4,	   -- 上交道具给npc
	CHALLENGECOPY      = 5,    -- 挑战副本(通关副本)
	LEVEL_UP           = 6,    -- 升级
	RES_UP             = 7,    -- 资源增加
	TASK_DONE          = 8,    -- 完成任务
	PVP_KILL           = 9,    -- PVP击杀
	ACTIVITY_DONE      = 10,   -- 完成活动
	BAG_ADD_SIZE       = 11,   -- 背包格子增加
	FRIEND_ADD         = 12,   -- 新增好友
	RECHARGE           = 13,   -- 充值
	TRAIN_LEVEL_UP	   = 14,   -- 修炼升级
	ENTER_COPY         = 15,   -- 进入副本
	ENTER_SCENE        = 16,   -- 进入场景
	SHAKE_MONEY_TREE   = 17,   -- 摇摇钱树
	DAILY_ANSWER       = 18,   -- 日常答题
	EXAMINATION        = 19,   -- 完成科举
	ENTER_COPY_TYPE    = 20,   -- 进入x类型的副本
	CHALLENGECOPY_TYPE = 21,   -- 通关x类型的副本
	GET_DAILY_TASK_REWARD = 22, -- 领取天机任务奖励
	TASK_START         = 23,   -- 开始任务
	ARRIVE             = 24,   -- 到达某个地点
	COMPLETE_ALLIANCE_DAILY_TASK = 25, -- 完成军团每日任务
	ESCORT             = 26,   -- 完成护送
	ARENA_CHALLENGE    = 27,   -- 挑战竞技场
	ENHANCE_EQUIP      = 28,   -- 强化装备
	FORMULA_EQUIP      = 29,   -- 打造装备
	POLISH_EQUIP       = 30,   -- 洗练装备
	INLAY_GEM          = 31,   -- 镶嵌宝石
	STAGE_UP_HORSE     = 32,   -- 坐骑进阶
	POLISH_HERO        = 33,   -- 武将洗练
	UPGRADE_SOUL_HOURSE= 34,   -- 坐骑封灵
	SKILL_LEVEL_UP     = 35,   -- 升级技能
	FACTION_HANDUP     = 36,   -- 战场提交能量珠(采集珠)
	FACTION_KILL       = 37,   -- 战场击杀
	FACTION_ASSIST     = 38,   -- 战场助攻
	FACTION_DIED       = 39,   -- 战场死亡
	ALLIANCE_REPEAT_TASK = 40, -- 完成军团重复任务
	ALLIANCE_LEGION_EXP  = 41, -- 军团领地活动每10s经验奖励
	TOUCH_CREATURE       = 42, -- 触碰怪物
	ACHIEVE_DONE		 = 43, -- 完成成就
	ACHIEVE_REWARDED 	 = 44, -- 领取成就奖励
	POST_UNLOCK 		 = 45, -- 解锁官职
	POWER_UPDATE 		 = 46, -- 更新战斗力
	DAILY_ANSWER_ONCE 	 = 47, -- 日常答对一题
	DAILY_ACTIVE_ADD 	 = 48, -- 日常活跃度增加
	REFRESH_BY_GOLD 	 = 49, -- 元宝刷新貂蝉
	PLAYER_DIED 	 	 = 50, -- 玩家角色死亡
	PLAYER_RESURRECT  	 = 51, -- 玩家角色复活
	KILL_PLAYER 	 	 = 52, -- 击杀玩家
	CHAIN_KILL	   		 = 53, -- 战场连杀
	FACTION_WIN 	 	 = 54, -- 战场获胜
	RANKING_UPDATE 	 	 = 55, -- 排行榜更新
	TEAM_VS_CHAIN_KILL 	 = 56, -- 3V3连杀
	TEAM_VS_WIN	 		 = 57, -- 3V3获胜
	ACTIVE_HERO 		 = 58, -- 激活武将
	AWAKE_HERO	    	 = 59, -- 觉醒武将
	GET_HERO_EQUIP 		 = 60, -- 武将获得装备
	HERO_LEVEL_UP 		 = 61, -- 武将升级
	WING_ACTIVE 		 = 62, -- 激活翅膀
	HORSE_ACTIVE 		 = 63, -- 激活坐骑
	COMPOSE_GEM 		 = 64, -- 合成宝石
	ALLIANCE_JOIN 	 	 = 65, -- 加入军团
	ALLIANCE_ACTIVITY 	 = 66, -- 完成军团活动(整合到48)
	EAT_FOOD 			 = 67, -- 食用宴会菜肴
	RECEIVE_FLOWER		 = 68, -- 收到花
	PRESENT_FLOWER 		 = 69, -- 赠送花
	WAREHOUSE_ADD_SIZE 	 = 70, -- 仓库格子增加
	SIGNIN 				 = 71, -- 签到
	DAILY_TIMES_ADD 	 = 72, -- 日常次数增加
	DOUBLE_ESCORT        = 73, -- 双倍护送
	CARDS_GAME           = 74, -- 卡牌游戏匹配成功
	MAGIC_BOSS_DROP      = 75, -- 魔域领主boss掉落
	COMBAT_ATTR_UP       = 76, -- 战斗属性达到X
	PUT_ON_EQUIP         = 77, -- 穿戴装备
	TVT_TOP_RANK 		 = 78, -- 3V3达到榜首
	ACTIVITY_DROP 		 = 79, -- 活动物品掉落
	DEATHTRAP_EXP 		 = 80, -- 魔狱获得十倍经验
	EVERY_DAY_TASK_DONE  = 81, -- 完成每日任务
	GAIN_FREE_STRENGTH   = 82, -- 获取免费体力
	DRAW_DESTINY         = 83, -- 抽取天命
	KILL_CREATURE_TYPE 	 = 84, -- 杀怪触发器（仅用于成就判断杀怪类型）
	ENHANCE_EQUIP_STATE  = 85, -- 强化装备后装备状态
	INLAY_GEM_STATE      = 86, -- 镶嵌宝石后宝石状态
	STAGE_UP_HORSE_STATE = 87, -- 坐骑进阶后状态
	HERO_LEVEL_UP_STATE  = 88, -- 武将升级后状态
	ALLIANCE_STATE       = 89, -- 军团状态
	TOWER_COPY_STATE     = 90, -- 爬塔副本状态
} 

-- 场景服和玩家服之间的同步协议
tb.SYNC_MESSAGE_OPCODES = 
{

}

-- 场景服发给玩家服的消息
tb.SCENE_TO_PLAYER_OPER = {
	GET_CHAR_INFO	            = 0,	-- 玩家在场景服获取个人信息
	MAP_LOADED		           = 1,	-- 玩家在场景服第一次进入场景
	VALUE_CHANGE				= 2,	-- 玩家部分属性值在场景服被改变
	TRANSFER_MAP				= 3,	-- 玩家切换地图
	PASS_STORY_COPY				= 4,	-- 玩家通过副本
	DAILY_RECORD				= 5,    -- 玩家日常记录在场景服发生改变
	TEAM_COPY_MODIFY			= 6,	-- 玩家在组队副本内发生了改变（组队，入队，退队）
	NEXT_TOWER			        = 7,	-- 玩家试图进入下一层爬塔副本
	ENTER_COPY				    = 8,	-- 玩家进入副本
	ARENA_CHALLENGE_RESULT      = 9,    -- 玩家打完竞技场
}

-- 玩家服发给场景服消息
tb.PLAYER_TO_MAP_DATA = {
	COMBAT_ATTR     = 1,        -- 属性改变
	LEVEL           = 2,        -- 等级改变
}

-- playerd发给mapd的消息
tb.PLAYER_TO_MAP_OPER = {
	NONE                 = 0,
	HERO_FIGHT           = 1,   --宠物出战/休息
	GUILD_UPDATE         = 2,   --玩家公会信息变更
	RIDE_HORSE           = 3,   --玩家骑（下）马的通知
	--USE_ITEM             = 4,   --使用物品
	EQUIP_CHANGE         = 5,   --切换装备
	SURFACE_CHANGE       = 6,   --切换时装
	VIP_LEVEL_CHANGE     = 7,   --vip等级变更
	HERO_CHANGE_NAME     = 8,   --宠物改名 --暂时无用 但我觉得以后会有用，先留着
	SET_TITLE            = 9,   -- 改名
    PET_UPGRADE_NOTICE   = 16,  --出战宠物升级通知
    --ADD_BUF_BY_USE_ITEM  = 17,  --通过使用物品增加buff
    COPY_EXPIRED         = 18,  --通知副本过期
    ADD_BUFF             = 19,  --增加buff
    REMOVE_BUFF          = 20,  --移除buff
    --LENGTH_BUFF          = 21,  --延长buff持续时间
    CHANGE_EQUIP_PREFIX  = 22, --通知场景服需要知道前缀有更改
    CHANGE_NAME 		 = 23,  --玩家修改名称
    REST_AUTO_INVITE_NEAR = 24, --自动邀请附近玩家双休
    USE_HP_ITEM          = 25,  -- 使用回血

    CREATE_BEAUTY        = 26,  --刷新美人 
    REMOVE_BEAUTY        = 27,  --移除美人
    SKILL_UPDATE         = 38,  --更新技能
    --	START_GUILDTOWER     = 6,   --开启玲珑塔
	--	START_SWORDDEVIL     = 7,   --更改剑魂试炼时间
	--	QUEST_FINISHED       = 8,   --任务完成通知,目前只有主支线同步
	--	TITLE_UPDATE         = 9,   --通知游戏服聊天称号变更
		--SCENE_TELEPORT       = 10,  --通知游戏服进行场景传送
		--SET_INTERNAL_FLAG    = 11,  --设置内部玩家标志
	--	APPLY_GUILD_AURA     = 12,  --公会AURA
	  --  PET_SKILL_CHANGE     = 13,  --出战宠物技能变更
	--	CONVOY_START         = 14,  --开始运镖
	--	CONVOY_SET_PROC_FLAG = 15,  --设置玩家的运镖标志
}

-- playerd发给mapd的消息 没有mapAgent时转到scened 需要缓存等加载完map后再执行的列表
tb.PLAYER_TO_SCENE_OPER_LIMIT = {
	[tb.PLAYER_TO_MAP_OPER.ADD_BUFF]    = 1, --增加buff
	[tb.PLAYER_TO_MAP_OPER.REMOVE_BUFF] = 1, --移除buff
	--[tb.PLAYER_TO_MAP_OPER.LENGTH_BUFF] = 1, --延长buff时间
}

--同步对象类型
tb.SYNC_OBJECT_TYPE = {
	NONE				= 0,
	TASK_DATA			= 1,	-- 任务数据
	COLLECTION			= 2,	-- 采集物
	PLR_COMBAT_ATTR	    = 3,	-- 玩家战斗属性
	PLR_DATA_STC	    = 4,	-- 玩家实体数据（从场景服到中央服同步，经验变化量、血量、能量）
	PLR_BASE_RES		= 5,	-- 玩家基础数据（如等级、经验、金钱等改变）
	PLR_SIMPLE_ITEM		= 6,	-- 玩家简单道具数据
	PLR_SKILL_UNLOCK	= 7,	-- 玩家技能符文解锁
	LOOTITEM_DATA		= 8,	-- 掉落物数据
	PLR_SKILL_ADD_DATA	= 9,	-- 玩家技能加成数据
	HERO_DATA            = 10,  -- 武将(宠物)数据
	PASSIVE_SKILL		= 11,	-- 添加玩家的被动技能
	DAILY_RECORD		= 12,	-- 日常数据的同步
	PERMANENT_RECORD	= 13,	-- 永久数据的同步

	END                 = 14,   
}

-- 组队协议
tb.TEAM_SYNC = 
{
	CREATE = 1, 
	JOIN = 2, 
	QUIT = 3, 
	CHANGE_LEADER = 4
}

--进阶属性
tb.EXTEND_ATTR = {
	PHY_DEF_PROB = 1,   --物防率
	MAGIC_DEF_PROB = 2,	--法防率
	CRIT_PROB = 3,		--暴击率
	HIT_PROB = 4, 	    --命中率
	DODGE_PROB = 5,     --闪避率
	THROUGH_PROB = 6,   --穿透率
	CRIT_DEF_PROB = 7,  --坚韧率（抗暴）
	DAMAGE_DOWN_PROB = 8, --免伤率
	BLOCK_PROB = 9,     --格挡率
}

tb.EXP_MUL_BUFF_SET = 15001    
tb.ATK_BEATK_IN_FIGHT_CD = 10

tb.CELL_CONST = {
	MAX_X = 200,          -- 最大x
	MAX_Y = 200,          -- 最大y
	SIZE_X = 30,     --格子边长x
	SIZE_Y = 30,     -- 格子边长y
	RANGE = 400,     -- 可视范围
}

return tb
