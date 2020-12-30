

local root = {
	
	init_res = {0, 0, 0, 120, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},	--初始化资源
	
	init_position = {111101,370,1780, 0, 0, 111101, 370, 1780, 0}, -- 新手村的id以及进入x，y
	guide_protect_level = 80,	-- 新手保护等级
	leader_max_level = 700,		-- 队伍等级上限
	pk_mode_open_level = 80,	-- pk模式开启等级
	active_statu_need = 3, 		--活跃玩家需要连续登录三天
	open_auto_task = 50,		--开启自动做任务等待时间（秒）
	auto_task = 0.1,				--自动做任务等待时间（秒）
	player_speed = 100,         --玩家基础行走速度

	player = {  --玩家个人相关
		head = {"111101", "112101", "111101","114101"},	--默认头像
	},

	-- 体力相关
	strength = {
		max_strength = 120,          -- 所有玩家的体力上限
		strength_time = 720,			--多少秒加一点体力
		buy_num = 20,                -- 购买一次体力增加的数值
		buy_cost = {2, 10},          -- 购买一次体力消耗的货币
		daily_buy_times = 2,        -- 每天可以购买体力的次数
		reset_cost = {2, 20},        -- 重置的消耗
	},

	activity = {
		init = {1001,2001,3001,3002,3003,3004,3005,3006,3007,3008},
	},

	bag = {
		-- normalMaxSize = 100,    --普通背包最大容量 不再使用
		-- equipMaxSize = 10,      --装备背包最大容量 不再使用
		-- depotMaxSize = 100,     --仓库最大容量 不再使用

		-- normalInitSize = 20,    --普通背包初始容量 不再使用
		-- equipInitSize = 10,     --装备背包初始容量 不再使用
		-- depotInitSize = 20,     --仓库初始容量 不再使用

		
		treasureInitSize = 80, 	--宝物初始化容量
		equipEnhanceN = 2, 	--强化等级是队长等级N倍
		treasureRefineItemCode = 31205001, --宝物精炼石id
	},

	copy = {	--副本相关
		pass_wait_time = 0.5,		--结算界面停留时间
		holy_copy_code = 40001,     -- 过关斩将副本id
		tower_copy_top_floor = 100, -- 爬塔副本最高层
		materialCopyResetMax = 2, 		--材料副本次数每日重置时的上限
		materialCopyBuyCost = 40, 		--每次购买次数花费绑元
		auto_exit_time = 8 				--自动退出副本倒计时
	},

	arena = {
		daily_challenge_times = 10, -- 每日10次
		add_challenge_cost = {2, 10},  -- 增加次数的消耗
	},

	email = {
		emailBoxValidTime = 30*60,  --在线时邮箱常驻 角色不在线时只保留30分钟 到时间了就进行保存并释放掉内存
		validTime 	 = 7*24*60*60,	--过期时间 7天
		maxItemCount = 5,           --单个邮件附件上限 5个 超出则用新邮件发
		maxCount     = 50,          --邮箱上限
	},
	
	shop = { --商城
		refreshCostItem = 314001,	--刷新令
		refreshCostResN = 20,		--没有刷新令，消耗相应魂魄数量
		refreshCostBaseResN = 20,	--刷新一次消耗砖石数量
		maxFreeRefreshN = 10,		--免费刷新次数上限
		recoveryTimePerOne = 7200, 	--恢复一点需要的时间,单位：秒
		allianceSRefreshTime = {{8,0},{12,0},{16,0},{22,0}},  --军团商店刷新时间（12点30分）
		arenaShopExItem = {1,11},	--竞技场商城兑换使用的道具
		cityShopFreeTimes = {3,1},   --商城抽将免费次数（普通，高级）
		drawCardFirstTime = {1005}, --高级抽将首次和第二次固定武将抽取的奖池code
		-- 废弃 次数转到unlock表vip0的情况
		dailyMaxRefreshN = { --每日刷新上限
			[4] = 20,	--将魂
			[5] = 20,	--觉醒
			[9] = 20,	--升华
		},
		resNumShow = { 
			--资源数量显示
			[1] = {5,30805001},  --竞技场商店
			[2] = {10,1},		 --爬塔商店
			[3] = {12},          --叛军商店
			[4] = {8,31405001},  --角色商店
			[5] = {9,31405001},  --觉醒商店
			[6] = {11,1},       --公司商店
			[7] = {1,2},         --测试商店
			[9] = {13,31405001}, --升华商店
		},
		refreshCost = {
			--刷新消耗（排在前面的优先扣除）
			[4] = {{31405001,1},{8,20},{1,20}},  --角色商店（刷新令，将魂，钻石）
			[5] = {{31405001,1},{9,20},{1,20}},  --觉醒商店（刷新令，神魂，钻石）
			[9] = {{31405001,1},{13,20},{1,20}},  --升华商店（刷新令，去污粉，钻石）
		},
	},

	friend = {	--好友相关
		maxNumber = 100,			--好友数上限
		blackMaxNum = 20,			--黑名单上限
		giveStrengthVar = 1,		--每次赠送的体力值
		maxBeGiven = 25,            --被赠送未领取上限
		maxGetStrength = 25,		--领取好友赠送体力上限
		maxGiveStrengthReturn = 25, --赠送体力返还上限
	},
	
	alliance = { --军团
		copyTimes = 3,					--副本每天重置次数
		copyOpenTime = {10, 22},		--副本开启时间
		copyBuyCost = {10,20,30,40,50},	--购买次数所需要
		unlock = {copy = 3},			--功能解锁等级
		
		allianceTask = 150,				--军团任务开启等级
		buildLevel = 40, 				--创建军团等级
		buildCost = {
			[1] = 1000000, 				--创建军团花费金币 [enum.BASE_RES.GOIN] = 1000000
			[2] = 100, 					--创建军团花费元宝 [enum.BASE_RES.GOLD] = 100
		},
		
		joinLevel = 40,                 --申请/被邀请加入军团等级限制
		applyJoinMax = 10,              --申请加入列表最多10人
		onekeyApplyCount = 10,          --一键申请加入军团一次申请10个
		donateRate = 1,				    --贡献值和军团资金的比例
		cycleDays = 7,					--7天为一个周期
		activePlayerLimit = 3,			--至少需要活跃玩家数量

		lastLogoutTmToImpeach      = 5*24*60*60, --统帅5天不上线 开始弹劾
		impeachTime                = 2*24*60*60, --弹劾时间

		upGradeCost = 50,				--升级军团消耗资金上限百分比

		nameFromSystem = "系统",		--系统公告署名
		nameFromAlliance = "军团",      --军团公告署名
		upGradeFaild = "由于没有在指定时间内收集足够的物资，施工队罢工不干啦！没办法只有等下次了 TAT",
		upGradeSuccess = "在全体成员的努力下，军团等级提升到了%d级！",
		legionBossRefresh = "上古封印力量衰弱，魔王们从深渊中逃出来了！在领地内到处找吃的，粮仓快被发现了！请速速回来抵抗，不然下个月吃土了！",

		auctionBeginDay = 5,			--每周星期几开始拍卖 [1-7]
		auctionBeginHour = 20,			--几点开始拍卖[0-23]
		auctionEndDay = 7,				--每周星期几开始拍卖 [1-7]
		auctionEndHour = 20,			--几点开始拍卖[0-23]

		weekRewardDay = 1,				--每周几刷新奖励[1-7]

		activeBossRefreshTimeRate = 100,	--军团领地刷新妖王的概率
		activeBossRefreshTimesLimit = 100,--军团领地每日刷新次数限制
		
		copyCode = 60001,				--军团copyid

		activeBossRefreshBeginH = 10,	--军团领地刷新妖王起始时间
		activeBossRefreshEndH = 23,		--军团领地刷新妖王结束时间
		activeBossLeave = 5,			--存在时长 (分钟)

		trainDailyTimesLimit = 999,		--每日修炼次数限制
		trainItemId = 40240301, 		--修炼道具物品

		legionMapId = 150102,           --军团领地地图

		dailyTaskCode = 400001,         --军团每日任务code
		dailyTaskNeedItemTypeCount = 4, --军团每日任务需要物品种类数

		repeatTaskTimesMax = 70,        --军团任务每天次数上限
		repeatTaskExReward = {          --军团任务每10环额外奖励
			{40031402, 1},
		},

		warFlagInspireCostDonation   = 10,       --军团战旗鼓舞消耗贡献
		warFlagInspireTimesLimit     = 3,        --军团战旗鼓舞每日次数上限

		legionActCollectToType = {
			[50102301] = 1, --tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHEST,
			[50102302] = 2, --tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.FOOD,
			[50102303] = 3, --tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHILD,
			[50102304] = 4, --tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.NEEDFIRE,
			[50102305] = 2, --tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.FOOD,
			[50102306] = 2, --tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.FOOD,
        },
        legionActCollectTypeToBroadcast = {
            [1] = 52, -- [tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHEST] = broadcastId
            [3] = 53, -- [tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHILD] = broadcastId
        },
        legionActStartTime = {          -- 活动开始时间 20:30
            hour = 20,
            min  = 30,
        },
        legionActOpenTime = 15*60,      -- 领地活动时长
        legionActExpRewardInteval = 10, -- 领地活动经验奖励间隔时间
        legionActConf = {               -- 详细配置
            [1] = {                       -- 篝火晚会
                questionInteval = 60,       -- 问题间隔
                firstChestTime  = 10*60,    -- 开始活动后过多久刷宝箱
                chestInteval    = 30,       -- 后续刷宝箱间隔时间
                maxQuestionNo   = 5,        -- 题号上限 总共只有4题 5作为特殊值 代表答题环节结束
            },
            [2] = {                       -- 宴会
            	firstChildTime  = 10*60,    -- 开始活动后过多久刷散财童子
            	childInteval    = 30,     -- 后续刷散财童子间隔时间
            },
        },
        legionActCollectRefreshCount = {
        	[3] = 15,                      -- 散财童子每次刷新数量 [tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE] = 10
        },
        legionActCollectMax = {
        	[1] = 5,                       -- 篝火晚会最多开5个宝箱   -- tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHEST
        	[2] = 5,                       -- 宴会最多吃5次佳肴       -- tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.FOOD
        },
        legionCollectErrCode = {
        	[1] = {10800, 10809, 10810, 10812},
        	[2] = {10801, 10813, 10814, 10815},
        	[3] = {10801, 10816, 10817}
        },
        dayDevoteTimesMax = 3,

		-- 积分规则
		-- 1.同一件装备，捐献获得的积分，与兑换所需的积分，是相同的。
		-- 2.装备的积分计算规则如下（不考虑品质的情况下）：
		--		等级	等级x10
		--		前缀	等级x10+2500
		--		1星	等级x5+500
		--		2星	等级x10+1000
		--		3星	等级x20+2500
		--		其中1星、2星、3星的计算方式，是直接根据星数计算1次。
		-- 3.在计算出上面积分的基础上，还需要乘以一个品质系数，才是最终的积分，具体如下：
		--		品质	白	  绿	蓝	  紫	金	  橙	红
		--		系数	0.2	  0.5	1	  1.5	2	  3	    5

        equipLevel2StorePoint = 10,
        equipPrefix2StorePoint = {10, 2500},
        equipStar2StorePoint = {
        	[1] = {5, 500},
        	[2] = {10, 1000},
        	[3] = {20, 2500},
        },
        equipColor2StorePoint = {
			[0] = 0.2,		--白
			[1] = 0.5,		--绿
			[2] = 1,		--蓝
			[3] = 1.5,		--紫
			[4] = 2,		--金
			[5] = 3,		--橙
			[6] = 5, 		--红
        },
        storeColorLimit = 3, -- 至少紫色才可以捐献
        storeStarLimit  = 1, -- 至少一星才可以捐献

        storeRecordMaxCount = 100,
	},

	recycle = { --回收系统
		openLevel = 1,         --开启等级
		recyclePercent = 100,   --回收比率

		rebornCost = 10,       --消耗钻石
		rebornPercent = 100,    --重生比率
	},

	--补充资源对应的背包道具和购买道具
	--key值为缺失的资源
	--数组第1位，背包道具
	--数组第2位，商城道具
	itemTips = {
		[3] = {30135001, 82002}, --体力
		[4] = {30145001, 82003}, --精力
		[7] = {30175001, 82006}, --行动力
	},

	--价格比例（1钻石等于多少个这样的物品）
	--[资源code] = 对应数量
	priceRate = {
		[1] = 1,		--钻石
		[2] = 1000,		--钞票
	},

	-- 职业和仇恨的关系
	threat = {
		careerValue = {   --进入视野仇恨值
			[1] = 50,     -- 职业1
			[2] = 51,
			[3] = 52,
			[4] = 52,
			--[4] = 45,
			--[5] = 100
		},

		careerHurt = {  -- 职业对应的仇恨系数
			[1] = 1,
			[2] = 1,
			[3] = 1,
			[4] = 1, 
		},

		heroHurt = {  -- 武将对应的仇恨系数
            [1] = 1,  -- 战将
            [2] = 1,  -- 法师
            [3] = 1,  -- 肉盾
            [4] = 1,  -- 辅助
		},

		monsterHurt = 1, -- 怪物对应的仇恨系数
	},

	-- 特殊物品id
	special_item_code = {
		respawnItem = 40071301,    --回魂丹
		speaker_code = 40060001,           --大喇叭的原型id（对应物品表中的code)
		flower_code = {40050101, 40050201, 40050301, 40050401}, 
	},

	skill = {
		--normalSkillId = {11100001, 11100001, 11100001, 11100001},
	},

	rank = {
		unlock_level = {1, 1, 1, 1, 1}, -- 开启等级
		refreshInterval = 10 * 60,      -- 10 分钟
	},
	
	---------------------cds add begin
	rest = {
		player_level   = 55, --打坐需要的玩家等级
		intimacy_value = 1,  --打坐亲密度增加点数
		intimacy_cycle = 60, --打坐亲密度增加周期(单位秒）
		hp_percent     = 10, --打坐每周期增加血量%比
		hp_cycle       = 10, --打坐血量增加周期(单位秒）
		exp_cycle      = 10, --打坐增加经验周期(单位秒）
	},
	horse_functionId    = 4,
	horse_add_exp_price = 10,
	horse_equip_feed_coeff = 0.2,
	money_tree = {
		--gain_base       = 9900, --能获得金钱数公式的 y = a* level + b 中的 a
		gain_level      = 100,  --能获得金钱数公式的 y = a* level + b 中的 a
		gain_coin       = 100000, --摇钱一次掉落的金钱
		shake_max_times = 10,   --非vip能摇次数
		--ceshi
	},
	gold_market= {
		func_id            = 1, --功能开启id
		sell_time          = 24*3600,       --挂售时间长度
		--sell_time          = 60,       --挂售时间长度
		gain_mul           = {
			[0] = 0.2,
			[1] = 0.15,
			[2] = 0.15,
			[3] = 0.15,
			[4] = 0.15,
			[5] = 0.15,
			[6] = 0.1,
			[7] = 0.1,
			[8] = 0.1,
			[9] = 0.1,
			[10] = 0.1,
		},
		price_min          = 2,          --最低价格
		price_max          = 99999,     --最高价格
		auto_add_price_mul = 1.2,  --自动补货是前100个货的平均价格的1.2倍
	},
	market= {
		--sell_time              = 24*3600,       --挂售时间长度
		sell_time              = 60,       --挂售时间长度
		player_level           = 30,            --市场开放等级
		tax_rate               = 0.12,          --正常税
		tax_rate_add           = 0.24,          --高税
		tax_rate_sub           = 0.06,          --低税
		refresh_interval       = 60,            --更新时间长度
		refresh_money_type     = 1,             --刷新需要的货币类型
		refresh_money_value    = 5000,         --刷新需要的货币值
		not_allow_refresh_time = 30,            --当只剩下30秒就自动刷新时不允许玩家刷新
		not_show_time          = 60,      	     --当只剩下60秒中时，不再随机给玩家
		rand_type_count        = 60,      		    --每个子类随机60如果需要自己的不显示+16个
		rand_type_total_count  = 300,     		    --   每个子类最多从300个中去随机
		price_balance_num      = 500,           --计算新价格的公式平衡因子
		price_wave_max         = 1.2,           --计算新价格的公式最大倍数
		price_wave_min         = 0.8,           --计算新价格的公式最小倍数
		auto_comp_count        = 5,       				  --系统补货的数量
		auto_comp_time         = 25*3600, 	    	--系统补货的时间长度
		auto_comp_price_mul    = 1.2,           --系统补货的价钱比率(110%)
	},
	hero={
		--先留着，以后再删 begin
		skill_low_power  = 1000,
		skill_high_power = 2000,
		skill_high_level = 2,
		--先留着，以后再删 end

		--增加天资的物品原型id  index为enum.HERO_TALENT_TYPE的值
		add_talent_item_code={40300301, 40310301, 40320301, 40440301, },

		polish_range = 0.03,
		polish_range_half = 0.015,
		polish_code = 40160201,  --洗髓丹 即洗炼需要的物品原型id
		polish_lock_code = 40460201,  --洗练锁原型id
		recycle_pecent = { --万分比
			exp = 8000,
			chip = 10000,
			talent = 9000,
		},
		recycle_need_coin = 1000000, --重生要100w
		--[[ 文档中的
		攻击=（等级*武力*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 (这个是最新的需求)
		
暴击=（等级*武力*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
命中=（等级*武力*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
穿透=（等级*武力*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 


生命=（等级*体魄*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
坚韧=（等级*体魄*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
免伤=（等级*体魄*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
格挡=（等级*体魄*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 


闪避=（等级*灵动*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
物防=（等级*灵动*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
法防=（等级*灵动*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
回血=（等级*灵动*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3 
]]
		--此系数与上面那个注释一一对应
		combat_coefficient = {
			--武力影响
			{2,2,0.4},--攻击=（等级*武力*系数1/100+等级*系数2）*天资/1000+等级*(等级-1)/2*系数3
			{1,1,0.2},
			{1,1,0.2},
			{1,1,0.2},
			--体魄影响
			{40,40,8},
			{1,1,0.2},
			{1,1,0.2},
			{1,1,0.2},
			--灵动影响
			{1,1,0.2},
			{2,2,0.4},
			{2,2,0.4},
			{2,2,0.4},
		},
		--二维数组的下标-->应该不会变
		combat_coefficient_idxs={1,5,9},
		relive_time = 60,					--武将复活时间
	},
	destiny={
		bag_max_size       = 200,      --天命背包数量
		draw_max_size      = 54,       --抽奖页面数量
		break_through_code = 40270001, --突破所需物品原型id
		draw_max_index     = 5, 	   --单抽天命升级最大目录
		destiny_color_max  = 5, 	   --天命最高品质
		gold_pool_level    = 6, 	   --元宝池等级
		gold_min_pool 	   = 7, 	   --元宝保底池，10连第10次从这个level的池中抽取
		-- need_money = {  				 --【v1.0.5】以后不再使用
		-- 	[1] = {                      --抽一次时
		-- 		[1] = 1000,              --用铜钱抽奖需要数额
		-- 		[2] = 10,                --用元宝抽奖需要数额
		-- 	},
			
		-- 	[10] = {                     --抽10次时
		-- 		[1] = 9000,              --用铜钱抽奖需要数额
		-- 		[2] = 90,                --用元宝抽奖需要数额
		-- 	},
		-- },
		need_coin = {                --用铜钱抽时费用(读表，弃用)
			[1] = 1100,              --1级
			[2] = 1200,              --2级
			[3] = 1300,  			 --3级
			[4] = 1400,  			 --4级
			[5] = 1500,     		 --5级
		},
		need_head = {                --用铜钱抽时头像(读表，弃用)
			[1] = "img_head_112101",              --1级
			[2] = "img_head_112101",              --2级
			[3] = "img_head_112101",  			 --3级
			[4] = "img_head_112101",  			 --4级
			[5] = "img_head_112101",     		 --5级
		},
		need_gold = {                --用元宝抽时费用(读表，弃用)
			[1]  = 10,               --单抽
			[10] = 90,               --十连
		},
		experience_ball = 0,		--天命经验球类别
		free_times = 10, 			--免费次数(前n次不扣铜钱)
	},
	--人物战斗力系数
	--注：下面这个战斗力系数已经弃用！！！！统一读取属性文字表！！！！！
	player_power_coefficient = {	
		attack         = 2,   --攻击系数
		phy_def        = 0.5,   --物防系数
		mag_def        = 0.5,   --法防系数
		hp             = 0.1, --生命系数
		crit           = 1,   --暴击系数
		hit            = 1,   --命中系数
		dodge          = 1,   --闪避系数
		through        = 1,   --穿透系数
		crit_def       = 1,   --坚韧系数
		damage_down    = 1,   --免伤系数
		block          = 1,   --格挡系数
		crit_hurt_prob = 0.5,    --暴击伤害系数(万分比，即：增加1%就是500战斗力)
		recover        = 1,    --回血系数
		skill_1        = 400,  --技能1系数
		skill_2        = 450,  --技能2系数
		skill_3        = 500,  --技能3系数
		skill_4        = 500,  --技能4系数
		skill_xp       = 1000, --技能xp系数
	},
	--回血量= A + (level-B) * C
	player_hp_recover_conefficient = {
		A = 100,
		B = 2,
		C = 50,
	},
	player_hp_add_interval = 10000,
	--策划不用管
	player_power_coefficient_idx = {
		"attack", "hp","phy_def", "mag_def",
		"crit","hit", "dodge", "through", 
		"crit_def", "damage_down", "block",
		beginIdx = 1,
		endIdx = 11,
		[22] = "recover", --22对应enum.COMBAT_ATTR.RECOVER 的值
		skillIdx = {"skill_1", "skill_2" , "skill_3",
		"skill_4", "skill_xp"},
		crit_hurt_prob_base = 15000,
	},
	online_gift = {
		player_level = 15,    --在线时长礼包开始等级
		week_bind_gold_interval=5*60,   --周礼包时间间隔
		week_limit = 500,      -- 每周在线累计绑元奖励上限
		week_bind_gold = 2,    -- 每个时间段奖励
	},
	invest = {
		price = 888,
	},
	recharge_id={
		week_card = 10001,
		month_card = 10002,
	},
	free_strenght={
		time_region_hour = {
			{12,14},
			{18,20}
		},--时间间隔  12点到14点 18点到20点
		strength = {50,50 },    --第一个为午餐获得的体力值，第二个为晚餐
		needgold = {10,10 },    --补领 第一个为午餐，第二个为晚餐
	},
	gem_slot_cond = {
		[1] = 0,       --宝石孔直接解锁
		[2] = 150,     --150级装备解锁
		[3] = 240,     --240级装备解锁
		[4] = 5,       --橙色装备
		[5] = 6,       --红色装备
		[6] = 5,       --成为vip5
	},
	--装备需求宝石跳转
	equip_need_gem_path = { -- [部位] = {1级页签，2级页签，商品id}
		[1] = {1,2,10020001}, -- 
		[2] = {1,2,10020003}, -- 
		[3] = {1,2,10020003}, -- 
		[4] = {1,2,10020003}, -- 
		[5] = {1,2,10020003}, -- 
		[6] = {1,2,10020003}, -- 
		[7] = {1,2,10020003}, -- 
		[8] = {1,2,10020001}, -- 
		[9] = {1,2,10020001}, -- 
	},
	--打造浏览显示的星级属性
	formula_browse_star = { -- [部位] = {属性1，属性2，属性3}
		[1] = {10008,10001,24}, -- 武器 穿透%、攻击%、伤害%
		[2] = {10003,10002,20}, -- 头盔 物防%、生命%、伤害减免%
		[3] = {10003,10002,20}, -- 铠甲 物防%、生命%、伤害减免%
		[4] = {10004,10002,20}, -- 腰带 法防%、生命%、伤害减免%
		[5] = {10003,10002,20}, -- 鞋靴 物防%、生命%、伤害减免%
		[6] = {10004,10002,20}, -- 肩甲 法防%、生命%、伤害减免%
		[7] = {10004,10002,20}, -- 护腕 法防%、生命%、伤害减免%
		[8] = {10008,10001,24}, -- 项链 穿透%、攻击%、伤害%
		[9] = {10008,10001,24}, -- 戒指 穿透%、攻击%、伤害%
	},
	--洗炼装备需要玩家等级240级
	polish_equip_need_player_level = 240,
	polish_color_range = {
		2000, --0~20%为绿色  COLOR.GREEN
		5000, --20~50%为蓝色  COLOR.BLUE
		7000, --50~70%为紫色  COLOR.PURPLE
		7000, --50~70%为金色（没有金色）  COLOR.GOLD
		9000, --70~90%为橙色  COLOR.ORANGE
		10000, --90~100%为红色  COLOR.RED
	},
	polish_equip_need_coin = 10000,
	polish_equip_lock_need_item = 40100201,
	polish_equip_lock_need_item_count = {
		[0] = 4,            --锁0个需要4个洗炼石
		[1] = 10,           --锁1个需要10个洗炼石
		[2] = 20,           --锁2个需要20洗炼石
		[3] = 40,           --锁3个需要40个洗炼石
	},
	--必出紫色元宝消耗
	polish_equip_purple_need_gold = {
		[0] = 50,            --锁0个需要50个元宝
		[1] = 100,           --锁1个需要100个元宝
		[2] = 150,           --锁2个需要150元宝
		[3] = 200,           --锁3个需要200个元宝
	},
	--
	polish_count = {
		[3] = 1,   --紫开1
		[4] = 2,   --金开2
		[5] = 3,   --橙开3
		[6] = 4,   --红开4
	},
	surface = {
		--初始玩家就会拥有的外观
		init_surface={
			[1] = {11001,21001},   --前面那个1表示职业 后面那个是外观id 指这个职业在被创建之后就会有这个外观
			[2] = {12001,22001},   --前面那个1表示职业 后面那个是外观id 指这个职业在被创建之后就会有这个外观
			[4] = {14001,24001},   --前面那个1表示职业 后面那个是外观id 指这个职业在被创建之后就会有这个外观
		},
		weapon_active_surface={
			[1] = {   --这个1表示了职业
				[11300501] = 11002,--前面那个是装备原型id 后面那个是外观id 指 穿上那个装备之后就会获得这个外观
				[11100501] = 21002,
				[11350501] = 11002,
				[11150501] = 21002,
				[11302401] = 11003,
				[11102401] = 21003,
				[11352401] = 11003,
				[11152401] = 21003,
											},
			[2] = {   --这个2表示了职业
				[12300501] = 12002,
				[12100501] = 22002,
				[12350501] = 12002,
				[12150501] = 22002,
				[12302401] = 12003,
				[12102401] = 22003,    
				[12352401] = 12003,
				[12152401] = 22003,
			},
			[4] = {--这个4表示了职业
				[14300501] = 14002,
				[14100501] = 24002,
				[14350501] = 14002,
				[14150501] = 24002,
				[14302401] = 14003,
				[14102401] = 24003,
				[14352401] = 14003,
				[14152401] = 24003,
			},
		},
		--需要金色品质的装备原型id
		weapon_gold_color_requrie = {
			14010001,14010001,14010001,14010001,
		},
		weapon_color_requrie = {
			[2] = {11300501,11100501,12300501,12100501,14300501,14100501,11350501,11150501,12350501,12150501,14350501,14150501},  --前面那个2是品质，后面那个是装备原型id
			[4] = {11302401,11102401,12302401,12102401,14302401,14102401,11352401,11152401,12352401,12152401,14352401,14152401},
		},
		surface_set_effect = {
			[2] = "exist2_attr",
			[3] = "exist3_attr",
			[4] = "exist4_attr",
		}
	},
	---------------------cds add-end

	-- 护送任务
	escort = {
		task_code                  = 513001,  -- 任务id
		daily_code                 = 1002,    -- 日常活跃表 用来获取等级限制
		max_day_times              = 3,       -- 一天最多可以参加三次
		refresh_quality_free_times = 3,       -- 默认免费刷新次数
		refresh_quality_cost       = 10,      -- 刷新一次花费绑定元宝
		time_limit                 = 30*60,   -- 任务显示30分钟 超时奖励减半
		quality5_title             = 323001,  -- 护送金色美人N次给的称号
		quality5_title_times       = 15,      -- 给称号需N次
		stopDistance               = 150,     -- 超过150距离就停止/过地图时小于此距离才能一起传送 否则停在原地
		restartDistance            = 75,      -- 停止后距离需要缩短为75一下才重新跟随
	},

	daily_task = {
		default_valid_times = 10,
		default_buy_valid_times = 5,
		buy_valid_times_cost = {
			code = 2,   -- enum.BASE_RES.GOLD, 
			num  = 10,
		},
		refresh_task_cost = {
			code = 1,   -- enum.BASE_RES.COIN, 
			num  = 500,
		},
		exp_reward_param = { -- 经验 = A + [(level - B ) * C * 任务品级系数]	
			A = 7500, 
			B = 25, 
			C = 2000
		},
		coin_reward_param = { -- 铜钱 = A + [(level - B ) * C * 任务品级系数]	
			A = 1000, 
			B = 40, 
			C = 20
		},
		quality_coef = { -- 任务品级系数
			[1] = 1,
			[2] = 1.5,
			[3] = 2,
		},
		without_quality1_day = 1, -- 建号第1天内 只会刷新到品质为2 3的任务
	},

	task_every_day = {
		default_valid_times = 20, -- 每天可以接20个每日任务
		ex_reward_times = 20,     -- 每日额外奖励需要完成的每日任务次数
		ex_reward = {             -- 每日额外奖励
			{40031108, 1},
		},
	},

	office = {
		res_type_2_position_type = {
			[7] = 1, -- [enum.BASE_RES.FAME]  = enum.POSITION_TYPE.CIVIL,    -- [7] = 1, [名望] - 文官
			[8] = 2, -- [enum.BASE_RES.FEATS] = enum.POSITION_TYPE.MILITARY, -- [8] = 2, [战功] - 武官
		},
		position_type_2_name = {
			[1] = "fame",  -- [enum.POSITION_TYPE.CIVIL]    = "fame" , -- [1] = xxx, [名望] - fame
			[2] = "feats", -- [enum.POSITION_TYPE.MILITARY] = "feats", -- [2] = xxx, [名望] - feats
		},
	},

	question_daily = {
		max_count = 10,
	},

	--竞技场 奖励发放时间
	pvp_reward_refresh_time = 60 * 60 * 21,
	pvp_total_time 			= 60 * 3,
	
	--NPC 对话距离
	npc_talk_distance = 50,

	-- 特殊的副本id
	special_copy_code = {
		xin_shou_cun   = 111101,  -- 新手村
		arena          = 50001,   -- 竞技场副本
		faction        = 110001,  -- 逐鹿战场
		team_vs        = 120001,  -- 3v3对决
		protect_city   = 130001,  -- 魔族围城
	},

	legion_task = 400001,

	-- 逐鹿战场
	faction = {
		energy_bead = {  -- 能量珠配置
			[1] = {
				color = 1, -- 品质
				get_percent = 20, -- 获得概率
				add_energy = 10,    -- 增加能量
			},

			[2] = {
				color = 2, -- 品质
				get_percent = 40, -- 获得概率
				add_energy = 20,    -- 增加能量
			},

			[3] = {
				color = 3, -- 品质
				get_percent = 40, -- 获得概率
				add_energy = 30,    -- 增加能量
			},
		},

		flag_ = 1000,  -- 每点能量补充的血
	},

-- 魔狱修炼挂机
	deathtrap = {
		daily_add_time = 30*60,       -- 每天给多少十倍时间
		max_time       = 1*60*60,     -- 十倍时间上限
		exp_buff_id    = 13600001,    -- buff编号
		item_count_max = 2,           -- 增加修炼时间的物品每日使用上限
		logout_exit_map = 111201,     -- 退出游戏时如果在绝地副本 则传送到景流城复活点
		DMG_buff_set   = 21001,       -- 伤害buff系列号
	},
	
	--3v3 
	pvp_3v3_open_time 			= 60 * 60 * 21,					--竞技场3v3开始时间
	pvp_3v3_duration_time 		= 60 * 30,						--竞技场3v3持续时间
	pvp_3v3_wait_time 			= 60 * 10,						--竞技场等待开启时间
	pvp_3v3_wait_effect_time	= 60 * 2,						--竞技场等待显示特效时间
	pvp_3v3_copy_limit			= 60 * 2,						--竞技场限制时间
	pvp_3v3_prepare_limit		= 5,							--竞技场准备时间

	-- 世界boss
	boss = {
		magic_boss_max_tired = 3,                               -- 魔域领主最大疲劳值
		map_code = 111701,                                      -- 魔域领主地图
		magic_boss_drop_limit_level = 100,                      -- 魔域boss掉落等级（playerLevel < bossLevel + 此值）
	},

	cards_game = {
		result = {
			win  = 1,
			draw = 2,
			lose = 3,
		},
		result_to_fame = {
			[1] = 100, -- cards_game.result.win  -- 赢得100名望
			[2] = 75,  -- cards_game.result.draw -- 平得75名望
			[3] = 50,  -- cards_game.result.lose -- 输得50名望
		},
		fame_reward_times_limit = 2,             -- 每天最多获得2次名望奖励
		choosing_time = 20,
		battle_time = 14,
	},

	-- 场景中不定位置的特效播放
	scene_special_effect_by_position = {
		alliance_party_firework 	= 41000100, 	-- 军团宴会烟花
		alliance_party_child 		= 41000120, 	-- 军团宴会散财童子特效
	},

	protect_city = {
		building_target_damage = 231000,           -- 城池目标伤害量
	},

	daily = {
		close_earlier = {			-- 日常活跃 可提早结束活动的列表（例如世界boss 魔族围城等）
			protect_city = 2007, 	-- 对应日常活跃系统code
		}
	},

	-- 聊天表情大小
	chat_emoji_size = 45,

	-- 地图上寻路路径点间距（单位：米）
	map_path_dis = 10000,

	offline = {                           -- 离线系统
		level_limit 		 = 55,           -- 等级限制
		init_offline_exp_min = 20*60,        -- 离线经验初始额度20小时 1200分钟
		power_to_exp_coef    = 500,          -- 每分钟根据战力计算经验奖励的系数  power/500向下取整
	},

	activity_rank_name = {
		[1] = "战力",
		[2] = "武将",
		[3] = "等级",
		[4] = "军团资金",
		[5] = "军团贡献",
		[6] = "军团等级",
		[7] = "每日答题",
		[8] = "烽火对决",
		[9] = "坐骑",
		[10] = "成就",
		[11] = "宝石",
		[12] = "爬塔",
		[13] = "魔族围城",
	},

	treasureMapRange = 500,

	roll_message = {
		roll_rate = 120 --滚动频率,秒
	},

	creature_team_drop = {
		{1, 3, 4},
		{1, 2, 3},
		{1, 1, 2},
	},
	attribute_change = {
		show_attr = { -- 那些属性会显示
			[1]=1,
			[2]=2,
			[3]=3,
			[4]=4,
			[5]=5,
			[6]=6,
			[7]=7,
			[8]=8,
			[9]=9,
			[10]=10,
			[11]=11,
			[22]=22,
		},
		max_ui = 15, -- 最大数量
		item_time = 0.05, -- 多久出来一条
		hide_time = 1.3, -- 隐藏时间（包括行动时间）
		max_cache = 30, -- 最大缓存属性条数
	},
}
return root
