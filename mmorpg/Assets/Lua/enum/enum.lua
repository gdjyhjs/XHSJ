-- 一些公共定义
local tb = {}

tb.TEN_THOUSAND = 10000
tb.PROP_ATTR_OFFSET = 10000   -- 计算战斗属性比率的时候，万分比属性的偏移量

--服务器状态
tb.SERVER_STATUS = {
	NORMAL = 0,		--正常(无状态)
	NEW = 1,		--新服
	HOT = 2,		--热服
	MAINTAIN = 3,	--维护中
	OLD = 4,		--旧服
}

--对象的域
tb.OBJ_FIELDS = {
	OBJ_GUID         = 1,      -- 唯一id
	OBJ_TYPE         = 2,      -- 类型,对应enum.OBJ_TYPE
    OBJ_PROTO_ID     = 3,      -- 原型

    OBJ_END          = 4            -- 
}

-- 用于生成唯一的下标
tb.GUID_TYPE = {
	ITEM = 1,    -- 物品

	CARDS_GAME = 7, -- 牌局
	EMAIL = 8,    -- 邮件
	ALLIANCE = 9, -- 军团
	END = 10,     -- 
}


---------------------------------人物相关begin------------------------------------
--职业
tb.CAREER = {
	COMMON = 0,         --通用
	MAGIC = 1,          --法师
	BOWMAN = 2,         --弓手
	SOLDER = 4,         --战士
}

--攻击伤害类型
tb.DAMAGE_TYPE = {
	PHY        = 1, --物理伤害
	MAGIC      = 2, --法术伤害
}

--pk模式
tb.PK_MODE = {
	--NEW_PLAYER = 0,     --新手模式
	PEACE = 0,          --和平模式
	ALLIANCE = 1,       --军团模式
	SERVER = 2,         --本服模式
	WORLD = 3,          --全体模式
	FACTION = 4,        --阵营模式
}

--战场里获得奖励类型
tb.TVT_PK_TYPE = {
	KILL 				= 1,			--破敌
	FIRSTBLOOD 			= 2,			--一血
	MVP 				= 3,			--mvp
	WIN 				= 4,			--胜利
	LOSE 				= 5,			--失败
}

--玩家属性字段
tb.PLAYER_BASE_ATTR = {
	HEAD            = tb.OBJ_FIELDS.OBJ_END + 0x001,      -- 头像
	CAREER          = tb.OBJ_FIELDS.OBJ_END + 0x002,      -- 职业
	CUR_HP          = tb.OBJ_FIELDS.OBJ_END + 0x003,      -- 当前生命值
	LEVEL           = tb.OBJ_FIELDS.OBJ_END + 0x004,      -- 当前等级
	EXP             = tb.OBJ_FIELDS.OBJ_END + 0x005,      -- 当前经验
	MAP_ID          = tb.OBJ_FIELDS.OBJ_END + 0x006,      -- 当前mapid
	MAP_POSX        = tb.OBJ_FIELDS.OBJ_END + 0x007,      -- 当前位置x
	MAP_POSY        = tb.OBJ_FIELDS.OBJ_END + 0x008,      -- 当前位置y
	DYNAMIC_FLAG    = tb.OBJ_FIELDS.OBJ_END + 0x009,      -- 动态标记（护送,打坐，骑乘）
	ALLIANCE_ID     = tb.OBJ_FIELDS.OBJ_END + 0x010,      -- 公会id
	SPAUSE_ID       = tb.OBJ_FIELDS.OBJ_END + 0x011,      -- 配偶id
	CUR_TEAM_ID     = tb.OBJ_FIELDS.OBJ_END + 0x011,      -- 队伍id
	CUR_TITLE_ID    = tb.OBJ_FIELDS.OBJ_END + 0x012,      -- 当前称号id
	VIP_LEVEL       = tb.OBJ_FIELDS.OBJ_END + 0x013,      -- vip等级
	LAST_MAP_POSX   = tb.OBJ_FIELDS.OBJ_END + 0x014,      -- 

	END             = tb.OBJ_FIELDS.OBJ_END + 0x014,      
}

--主界面显示组件枚举
tb.MAINUI_UI_MODLE = 
{
	MAP           	= 1,        -- 地图
	BUTTON         	= 2,        -- 功能按钮组
	BOTTLE         	= 3,        -- 血瓶
	EP        		= 4,        -- ep技能
	TASK        	= 5,        -- 任务栏
	HEAD        	= 6,        -- 头像
	FUNCOPEN        = 7,        -- 功能开启
	AUTOATTACK      = 8,        -- 自动挂机按钮
	LEAVEBUTTON     = 9,        -- 离开副本按钮
	SWITCHBUTTON    = 10,       -- 功能按钮组切换按钮
}

-- 玩家位置信息枚举
tb.PLAYER_MAP_FIELDS = {
	MAP_ID           = 1,        -- 当前地图id
	MAP_POSX         = 2,        -- 当前坐标x
	MAP_POSY         = 3,        -- 当前坐标y
	COPY_CODE        = 4,        -- 当前副本id
	COPY_GUID        = 5,        -- 当前副本guid
	LAST_MAP_ID      = 6,        -- 前一地图id
	LAST_MAP_POSX    = 7,        -- 前一地图坐标x
	LAST_MAP_POSY    = 8,        -- 前一地图坐标y
	COPY_ENTER_TIME = 9,         -- 进入副本时刻

	END              = 10, 
}

-- 玩家动态状态标志
tb.UNIT_DYNAMIC_FLAGS = {
	NONE              = 0x0,      
	RIDING            = 0x01,     -- 骑乘状态
	RESTING           = 0x02,     -- 打坐状态
	PROTECT_BEAUTY    = 0x04,     -- 护送美人状态
	AUTO_COMBAT       = 0x08,     -- 挂机状态
	PAIR_RESTING      = 0x10,     -- 双打坐状态
	HERO_SERVER_CONTROL = 0x20,   -- 1宠物服务端控制,0客户端控制
	SING              = 0x40,     -- 吟唱状态
}

tb.SEX_TYPE = {
	MAN   = 1,
	WOMAN = 2,
}

tb.CAREER_2_SEX_TYPE = {
	[tb.CAREER.SOLDER] = tb.SEX_TYPE.MAN,
	[tb.CAREER.BOWMAN] = tb.SEX_TYPE.WOMAN, 
	[tb.CAREER.MAGIC]  = tb.SEX_TYPE.WOMAN,
}

--------------------------------人物相关end---------------------------------------

------------------------------------物品相关begin----------------------------------

--基础资源
tb.BASE_RES = {
	COIN            = 1,           --铜钱
	GOLD            = 2,           --元宝
	BIND_GOLD       = 3,           --绑定元宝
	STRENGTH        = 4,           --体力
	EXP             = 5,           --经验
	ALLIANCE_DONATE = 6,           --军团贡献
	FAME            = 7,           --名望 用于文官官职
	FEATS           = 8,           --战功 用于武官官职
	ARENA_COIN      = 9,           --斗币
	QUENCH          = 10,          --淬火 由装备淬取后得出的物品
	HONOR           = 11,          --荣誉
	LOTTERY_POINT   = 12,          --秘境寻宝积分
	EMBLEM          = 13,          --纹章
	ALLIANCE_STORE_POINT = 14,     --军团仓库积分
	SPIRIT 			= 15, 		   --天命分解精髓
	END             = 99,		   -- END以下表示货币类型，用来区别邮件奖励的是物品还是货币
}

--背包类型
tb.BAG_TYPE = {
	NORMAL  = 1,          --普通背包
	EQUIP   = 2,          --装备栏
	DEPOT   = 3,          --仓库
	ONE_KEY = 4,          --一键使用
}

--物品大类
tb.ITEM_TYPE = {
	BASE     = 0, -- 基础资源
	EQUIP    = 1, -- 装备
	GEM      = 2, -- 镶嵌的宝石
	MEDICINE = 3, -- 药品
	PROP     = 4, -- 道具
	VIRTUAL  = 5, -- 虚拟道具 此类物品它并不是物品，但是又因为物品表的功能需要将其填在物品表中
			    	--或者简单认为无论什么情况都不会出现在背包中的物品(除基础资源)

	END      = 6, -- 结束
}
	
tb.SPACE_TYPE = {
	NORMAL_BAG = 1,
}

tb.VIRTUAL_TYPE = {
	HERO_CHIP = 1,   --武将碎片的物品形式 effect[1] 为heroId
	--EQUIP_FORMULA = 2,   --配方表的物品形式  effect[1] 为formulaId   （废弃）
	-- 这个为暂定effect_ex[1]为固定打造 formulaId  当玩家得到这个物品时，会立即给玩家打造一个装备，不消耗need_item和need_money，然后再将装备给到背包上
	EQUIP_FORMULA_CAREER = 3,--配方表的物品形式  effect 这样填 {{career,formulaId },{career2,formulaId2 }}
	--这个为暂定 effect_ex[1]为固定打造 formulaId  当玩家得到这个物品时，会立即给玩家打造一个装备，不消耗need_item和need_money，然后再将装备给到背包上
	ALLIANCE_FUND = 4, -- 军团资金 在军团中就直接增加军团资金
}

-- 道具小类
tb.PROP_TYPE = {
	FIXED_GIFT               = 1,  -- 固定礼包
	RANDOM_GIFT              = 2,  -- 随机礼包
	COIN_CARD                = 3,  -- 货币卡
	SKILL_BOOK               = 4,  -- 技能书
	FLOWER                   = 5,  -- 鲜花
	SPEAKER                  = 6,  -- 大喇叭
	RE_LIVE                  = 7,  -- 复活道具
	-- 装备用
	EQUIP_MATERIAL           = 8,  -- 打造装备需要的材料
	ENHANCE_MATERIAL         = 9,  -- 强化装备用的材料
	POLISTH_MATERIAL         = 10, -- 洗练装备用的材料
   -- 武将用
	HERO_EXP_BOOK            = 11, -- 给武将加经验的书
	HERO_SKILL_BOOK          = 12, -- 给武将加技能的书
	UNLOCK_HERO_SLOT         = 13, -- 给武将增加槽的道具
	UNLOCK_HERO_SQUARE       = 14, -- 给武将阵位开槽的道具
	WAKE_HERO                = 15, -- 给武将唤魂的道具
	POLISH_HERO              = 16, -- 给武将洗炼的道具
	RAND_GIFT_HERO           = 17, -- 有概率产出武将的随机道具
   -- 坐骑用
	HORSE_STAGE_UP           = 18, -- 给坐骑进阶的道具 加的经验8~12写死的随机范围
	HORSE_FROM_ITEM          = 19, -- 开出坐骑的道具 effect 坐骑 effect_ex 分解 {code,num}
	HORSE_SOUL_ITEM          = 20, -- 坐骑封灵道具

   -- 军团用
	ALLIANCE_DONATE_ITEM     = 21, -- 军团贡献道具

   -- 称号
	TITLE                    = 22, -- 使用后获得称号
	SMELT_ADD_RATE           = 23, -- 提升熔炼概率的物品
	ALLIANCE_TRAIN_ITEM      = 24, -- 提升修炼的道具
	TREASURE_MAP             = 25, -- 藏宝图
	TREASURE_MAP_CHIP        = 26, -- 神谕宝图碎片
   -- 天命
	BREAK_THROUGH            = 27, -- 突破石
	IMMED_ADD_HP_ITEM        = 28, -- 瞬补药 effect[1]为补血万分比 effect_ex[1] 为 cd(以秒为单位)
	ADD_EXP_GAIN_ITEM        = 29, -- 在战斗中获取经验有加成的道具 effectVal[1] 为buffId

	ADD_HERO_TALENT_FORCE    = 30, -- 增加武将天命武力属性道具 effect[1] 为增加的属性值
	ADD_HERO_TALENT_PHYSIQUE = 31, -- 增加武将天命体魄属性道具 effect[1] 为增加的属性值
	ADD_HERO_TALENT_FLEXABLE = 32, -- 增加武将天命灵动属性道具 effect[1] 为增加的属性值

	FORMULA_EQUIP_BASE_COLOR = 33, -- 打造装备时，进行品质保底的道具类型1  effect[1] 为保底的品质值 effect_ex为 装备类型

	ZORK_PRACTICE_TIME       = 34, -- 增加魔域修炼时间的道具

	--外观时装 effect填{surfaceId}  effect_ex填{protoId,count}  <--当外观已经存在的时候开出的物品和个数
	SURFACE_CLOTHES          = 35,         --外观 衣服
	SURFACE_WEAPON           = 36,         --外观 武饰
	SURFACE_CARRY_ON_BACK    = 37,         --外观 背饰
	SURFACE_SURROUND         = 38,         --外观 气息
	SURFACE_TALK_BG          = 39,         --外观 气泡
	SURFACE_TRACE            = 40,         --外观 足迹
	SURFACE_GRADE_UP_ITEM    = 41,         --外观 七彩染料

	LEVEL_UP_MEDICINE        = 42, -- 升级丹 15-59级使用直接升一级 并保留升级前的经验 60级以后用 获取固定经验值
	TREASURE_KEY             = 43, -- 寻宝钥匙
	ADD_HERO_TALENT_MULTIPLE = 44, -- 增加武将天命天资属性道具 effect[1] 为增加的属性值
	HERO_ITEM                = 45, --武将的物品形式 effect[1] 为heroId 当使用的时候直接变成武将
	POLISH_HERO_LOCK_SKILL   = 46, --给武将洗炼时锁住技能的道具
	EQUIP_STAR_STONE         = 47, --打造装备时增加星魂的石头 effect[1]为星级，effect[2]为加成万分比  effect_ex[1] 为 打造多少级装备才能使用
	ALLIANCE_BOSS_FOOD       = 48, --军团兽神boss口粮 用来召唤兽神
	HORSE_FOOD               = 49, --坐骑口粮
	NAME_CHANGE_CARD 		 = 50, --改名卡
	OFFLINE_EXP_TIME         = 51, --增加离线挂机时间上限

	BASE_RES_ITEM            = 999,-- 此类物品只是为了方便客户端处理而将基础属性填在物品表中的作显示用
}

--品质
tb.COLOR = {
	BEGIN  = 0,		--白
	WHITE  = 0,		--白
	GREEN  = 1,		--绿
	BLUE   = 2,		--蓝
	PURPLE = 3,		--紫
	GOLD   = 4,		--金
	ORANGE = 5,		--橙
	RED    = 6,     --红
	END    = 6,		
}

--宝石类型(物品小类)
tb.GEM_TYPE = {
	NONE   = 0,
	RED    = 1,--红宝石
	GREEN  = 2,--绿宝石
	PURPLE = 3,--紫宝石
	BLUE   = 4,--蓝宝石
	--ATTACK      = 1,  -- 攻击
	--HP          = 2,  -- 生命
	--PHY_DEF     = 3,  -- 物防
	--MAGIC_DEF   = 4,  -- 法防
	--CRIT        = 5,  -- 暴击
	--HIT         = 6,  -- 命中
	--DODGE       = 7,  -- 闪避
	--THROUGH     = 8,  -- 穿透
	--CRIT_DEF    = 9,  -- 坚韧值（抗暴值）
	--DAMAGE_DOWN = 10, -- 免伤值（伤害减免）
	--BLOCK       = 11, -- 格档
	--CRIT_HURT   = 12, -- 暴击伤害
}

--宝物穿戴部位
tb.TREASURE_TYPE = {
	ATTACK  = 1,          --攻击类宝物
	DEFENSE = 2,          --防御类宝物
	EXP     = 3,          --经验宝物，不可穿戴
}

--装备、宝物大师
tb.MASTER_TYPE = {
	EQUIP_ENHANCE = 1, 		--装备强化大师
	EQUIP_REFINE = 2, 		--装备洗练
	TREASURE_ENHANCE = 3,	--宝物强化
	TREASURE_REFINE = 4,	--宝物精炼
}

tb.EQUIP_TYPE = {
	BEGIN           = 1,  -- 开始
	WEAPON          = 1,  -- 武器
	CAP             = 2,  -- 头盔(帽子)
	HELMET          = 3,  -- 铠甲
	BELT            = 4,  -- 腰带
	BOOTS           = 5,  -- 鞋靴
	SHOULDER_HELMET = 6,  -- 肩甲
	BRACERS         = 7,  -- 护腕
	NECKLACE        = 8,  -- 项链
	RING            = 9,  -- 戒指
	WEDDING_RING    = 10, -- 婚戒
	END             = 11,
}


tb.EQUIP_PREFIX_TYPE={
	BEGIN = 1,
	NONE            = 0,  -- 没有
	BASE_ATTR_ADD_1 = 1,  -- 稀世
	BASE_ATTR_ADD_2 = 2,  -- 传承
	BASE_ATTR_ADD_3 = 3,  -- 精炼
	EXATTR_ADD      = 4,  -- 匠心
	GEM_UP          = 5,  -- 辉煌
	BATTLE_BURNING  = 6, --祝融
	PVE_HURT_ADD    = 7,--灭魔
	PVP_HURT_ADD    = 8,--武魂
	HURT_ADD        = 9, --狂战
	DEFENCE_ADD     = 10,--盘石
	RECOVER_ADD     = 11,--回血增加 5%
	HIT_ADD         = 12,--神射
	DODGE_ADD       = 13,--凌波
	END = 13,
}

--场景服需要知道的前缀值
tb.SCENE_NEED_EQUIP_PREFIX_TYPE={
	[tb.EQUIP_PREFIX_TYPE.BATTLE_BURNING] = 1,
	[tb.EQUIP_PREFIX_TYPE.PVE_HURT_ADD]=1,
	[tb.EQUIP_PREFIX_TYPE.PVP_HURT_ADD]=1,
	[tb.EQUIP_PREFIX_TYPE.HURT_ADD]=1,
	[tb.EQUIP_PREFIX_TYPE.DEFENCE_ADD]=1,
}

tb.EQUIP_PREFIX_COMBAT_ADD_MUL = 1.2

tb.MEDICINE_TYPE= {
	GOOD_BUFFER = 1,			--增益类buffer
	EXP = 2,        			--经验药
	MULTIPLY_EXP = 3,			--多倍经验药
	HERO_EXP = 4,   			--武将经验药
	EXP_PERCENT = 5, 			--百分比经验丹(effect为万分比)
}

tb.SHOP_TYPE = {
	GIFT = 1, --礼物
	QUICK_SHOP = 3, --礼物
}

tb.LOCATION_TYPE = {
	NONE       = 0, -- 背包
	NORMAL_BAG = 1, -- 背包
	BASE_RES   = 2, -- 基础属性
	GIFT       = 3, -- 帮玩家开礼包
	HERO       = 4, -- 会走生成武将流程
	HERO_EQUIP = 5, -- 会走生成武将装备流程
	EQUIP      = 6, -- 会走生成装备流程
	HORSE      = 7, -- 会走坐骑幻化流程
	DESTINY    = 8, -- 会走天命获得的随机流程 id为moneyType
}

tb.ALLIANCE_TRAIN_TYPE = {
	PLAYER_DAMAGE = 1,		--人物伤害增加
	PLAYER_PROTECT = 2,		--人物受伤减免
	PLAYER_HEALTH = 3,		--人物生命增加
	HERO_DAMAGE = 4,		--武将伤害增加
	HERO_PROTECT = 5,		--武将受伤减免
	HERO_HEALTH = 6,		--武将生命增加
}

tb.ALLIANCE_TRAIN_PLAYER = {
	tb.ALLIANCE_TRAIN_TYPE.PLAYER_DAMAGE,	--人物攻击增加
	tb.ALLIANCE_TRAIN_TYPE.PLAYER_PROTECT,	--人物防御增加
	tb.ALLIANCE_TRAIN_TYPE.PLAYER_HEALTH,	--人物生命增加
}

tb.ALLIANCE_TRAIN_HERO = {
	tb.ALLIANCE_TRAIN_TYPE.HERO_DAMAGE,		--武将攻击增加
	tb.ALLIANCE_TRAIN_TYPE.HERO_PROTECT,	--武将防御增加
	tb.ALLIANCE_TRAIN_TYPE.HERO_HEALTH,		--武将生命增加
}

------------------------------------物品相关end----------------------------------
------------------------------------外观时装系统 begin
tb.SURFACE_TYPE = {
	BEGIN = 1,
	CLOTHES       = 1, -- 时装
	WEAPON        = 2, -- 武饰
	CARRY_ON_BACK = 3, -- 背饰
	SURROUND      = 4, -- 气息
	TALK_BG       = 5, -- 气泡
	TRACE         = 6,
	END = 6
}
------------------------------------外观时装系统 end
------------------------------------天命系统 begin
--天命品质 注：有可能跟COLOR合并
tb.DESTINY_COLOR = {
	GREEN  = 1,		--绿
	BLUE   = 2,		--蓝
	PURPLE = 3,		--紫
	ORANGE = 4,		--橙
	RED    = 5,     --红
}
tb.DESTINY_CONTIANER_TYPE = {
	BAG = 1, --天命仓库
	DRAW = 2, --奖励面板
	BODY = 3, --身上
}


------------------------------------天命系统 end
--
------------------------------------武将相关 begin --------------------------------------
tb.HERO_TYPE = {
	NORMAL   = 1, -- 凡将
	FAMOUS   = 2, -- 名将
	SOUL     = 3, -- 魂将
	GOD_LIKE = 4, -- 神将(活动产出)
}

--武将的功能类型
--1-战将
--2-法师
--3-肉盾
--4-辅助
tb.HERO_FUNC_TYPE = {
	PALADIN   = 1, --战将
	WIZARD    = 2, --法师
	MUSCLEMAN = 3, --肉盾
	SUPPORT   = 4, --辅助
}

tb.HERO_TALENT_TYPE = {
	BEGIN = 1, -- 武力
	FORCE    = 1, -- 武力
	PHYSIQUE = 2, -- 体魄
	FLEXABLE = 3, -- 灵动
	MULTIPLE = 4, -- 比率 该值/1000
	END = 4, -- 武力
}

tb.HERO_EQUIP_TYPE = {
	BEGIN      = 91, -- 开始
	WEAPON     = 91, -- 武器
	ARMOR      = 92, -- 防器
	DECORATION = 93, -- 饰品
	END        = 94, -- 结束
}
tb.HERO_RECYLE_CALC_TYPE = {
	LEVEL       = 1,
	TALENT      = 2,
	SKILL_COUNT = 3,
}

-------------------------------------武将相关 end --------------------------------------

-------------------------------------功能开启 begin--------------------------------------
tb.FUNC_CONDITION_TYPE = {
	PLAYER_LEVEL = 1,          --当玩家等级满足条件时
	TASK         = 2,          --当玩家接了或者完成了某个任务时
	MAP          = 3,          --当玩家进入了某个地图
	CLICK		 = 4,		   --关于显示点击的弱指引
}
-------------------------------------功能开启 end--------------------------------------
-------------------------------------坐骑 begin--------------------------------------
tb.HORSE_ADD_EXP_TYPE = {
	ONE_ITEM = 1,
	ONE_KEY = 2,
}
tb.HORSE_TYPE = {
	NORMAL = 0,				--普通坐骑 通过进阶获得
	SPECIAL = 1,			--特殊坐骑 通过道具获得
}
-------------------------------------坐骑 end--------------------------------------
-------------------------------------打坐相关---------------------------------------
tb.REST_OP_CODE = {
	STOP_REST = 0,
	SINGLE_REST = 1,
	PAIR_REST = 2,
}



------------------------------------战斗相关begin--------------------------------
-- cd类型
tb.CD_TYPE = {
	SKILL  = 1, -- 技能
	ITEM   = 2, -- 物品
}

--攻击类型
tb.ATTACK_TYPE = {
	PHYS = 1,		--物理攻击
	MAGIC = 2,		--法术攻击
}

--目前所使用到的场景是在洗炼装备，和星级在增加万分比的时候
--在Polish_mgr那里也有可能会保存有这些值
--使用 也就是attr
tb.COMBAT_ATTR_MUL_DIS = 10000
tb.COMBAT_ATTR_MUL = {
	BEGIN = 10001,   
	ATTACK   	    = 10001,     -- 攻击
	HP           	= 10002,     -- 生命值
	PHY_DEF      	= 10003,	 -- 物防
	MAGIC_DEF    	= 10004,	 -- 法防
	CRIT         	= 10005,     -- 暴击值
	HIT          	= 10006,     -- 命中值
	DODGE        	= 10007,     -- 闪避值
	THROUGH         = 10008,     -- 穿透值(破防)
	CRIT_DEF     	= 10009,     -- 坚韧值（抗暴值）
	DAMAGE_DOWN  	= 10010,    -- 免伤值（伤害减免）
	BLOCK        	= 10011,    -- 格挡值
	CRIT_HURT_PROB  = 10012,    -- 暴击伤害值
	RECOVER         = 10022,    -- 回血率
	FINAL_DAMAGE_PROB = 10024,  -- 伤害率
}

--战斗属性
tb.COMBAT_ATTR = {
	ATTACK   	    = 1,     -- 攻击
	HP           	= 2,     -- 生命值
	PHY_DEF      	= 3,	 -- 物防
	MAGIC_DEF    	= 4,	 -- 法防
	CRIT         	= 5,     -- 暴击值
	HIT          	= 6,     -- 命中值
	DODGE        	= 7,     -- 闪避值
	THROUGH         = 8,     -- 穿透值(破防)
	CRIT_DEF     	= 9,     -- 坚韧值（抗暴值）
	DAMAGE_DOWN  	= 10,    -- 免伤值（伤害减免）
	BLOCK        	= 11,    -- 格挡值
	CRIT_HURT_PROB  = 12,    -- 暴击伤害率

	PHY_DEF_PROB 	= 13,    -- 物防率（废弃）
	MAGIC_DEF_PROB  = 14,	 -- 法防率（废弃）
	CRIT_PROB 		= 15,	 -- 暴击率
	HIT_PROB 		= 16, 	 -- 命中率
	DODGE_PROB 		= 17,    -- 闪避率
	THROUGH_PROB    = 18,    -- 穿透率
	CRIT_DEF_PROB   = 19,    -- 坚韧率（抗暴）
	DAMAGE_DOWN_PROB = 20,   -- 免伤率（伤害减免率） 
	BLOCK_PROB 		= 21,    -- 格挡率（计算是否格挡）
	RECOVER         = 22,    -- 回血值
	RECOVER_PROB    = 23,    -- 回血率
    FINAL_DAMAGE_PROB = 24,  -- 伤害率
	CLIENT_END      = 24,    -- 客户端读取结束
	-- DIZZY_ABSOLVE_PROB = 22, 	  --免晕率
	-- DIZZY_DEF_PROB = 23,	      --眩晕抵抗率

	-- IMMOBILIZE_ABSOLVE_PROB = 24,  --定身抵抗率
	-- IMMOBILIZE_DEF_PROB = 25,      --定身抵抗率

	-- SILENCE_ABSOLVE_PROB = 26,     --沉默免疫率
	-- SLIENCE_DEF_PROB = 27,         --沉默抵抗率


	-- DECELERATE_ABSOLVE_PROB = 28,   --减速免疫率
	-- DECELERATE_DEF_PROB = 29,       --减速抵抗率

	-- DEF_DOWN = 35,                  --护甲削弱

	
	--FINAL_DAMAGE_DOWN_PROB = 37,    --伤害减免率(与免伤率无关)

	EXP_ADD_ON_KILL = 40,           --击杀经验加成（万分比）
	EXP_ADD_IN_DEATHTRAP = 41,      --魔地狱绝地击杀十倍经验奖励



	END = 41,    -- 不知道有没有用
}

--根据基础属性根据公式计算出的延伸属性(通常是根据数值属性计算出百分比属性)
tb.COMBAT_ATTR_TO_EXTEND = {
	[tb.COMBAT_ATTR.PHY_DEF] 		= tb.COMBAT_ATTR.PHY_DEF_PROB,		--物防率 * 10000
	[tb.COMBAT_ATTR.MAGIC_DEF] 		= tb.COMBAT_ATTR.MAGIC_DEF_PROB,	--法防率
	[tb.COMBAT_ATTR.CRIT] 			= tb.COMBAT_ATTR.CRIT_PROB,			--暴击率
	[tb.COMBAT_ATTR.HIT] 			= tb.COMBAT_ATTR.HIT_PROB,			--命中率
	[tb.COMBAT_ATTR.DODGE] 			= tb.COMBAT_ATTR.DODGE_PROB,		--闪避率
	[tb.COMBAT_ATTR.THROUGH] 		= tb.COMBAT_ATTR.THROUGH_PROB,		--穿透率
	[tb.COMBAT_ATTR.CRIT_DEF] 		= tb.COMBAT_ATTR.CRIT_DEF_PROB,		--暴击抵抗率
	[tb.COMBAT_ATTR.DAMAGE_DOWN] 	= tb.COMBAT_ATTR.DAMAGE_DOWN_PROB,	--免伤率
	[tb.COMBAT_ATTR.BLOCK] 			= tb.COMBAT_ATTR.BLOCK_PROB,		--格挡率
}

--技能释放结果（圆桌理论顺序）
tb.SKILL_RESULT = {
	DODGE           = 1,     -- 闪避
	BLOCK           = 2,     -- 格挡
	CRIT            = 3,     -- 暴击伤害
	NORMAL          = 4,     -- 普通伤害
}

tb.SKILL_POS = {
	ONE    = 1,    -- 技能1
	TWO    = 2,    -- 技能2
	THREE  = 3,    -- 技能3
	FOUR   = 4,    -- 技能4
	XP     = 5,    -- xp技能
	NORMAL_1 = 6,    -- 普攻
	NORMAL_2 = 7,  -- 普攻2
	NORMAL_3 = 8,  -- 普攻3
}

--技能分类
tb.SKILL_TYPE = {
	NONE      = 1,   
}

--技能子类
tb.SKILL_SUBTYPE = {
	PHY_ATTACK = 1,			--物攻型
	MAGIC_ATTACK = 2,		--法攻型
}

--目标选择
tb.SKILL_TARGET_SELECT = {
	AUTO_SELECT = 1,        -- 自动寻找目标(如果没有则可以空放)
	TARGET      = 2,        -- 指定目标
	SELF_POS    = 3,        -- 以自我为中心
	-- 4 以触摸点为中心
}

-- 操作方式(和target_select可能会冲突)
tb.OPERATE_TYPE = {
	NONE        = 0, 
	CASTER      = 1,   -- 对自己，或者原地释放
	TARGET      = 2,   -- 对目标，必须指定目标

	DIRECTION   = 3,   -- 以方向为参数，对指定方向放箭
}

-- 作用范围
tb.AOE = {
	SINGLE      = 1,    -- 单体
	CIRCLE      = 2,    -- 圆形（扇形）
	LINE        = 3,    -- 直线型群体
}

-- 作用对象
tb.TARGET_OF_EFFECT = {
	ENEMY       = 1,    -- 敌人
	SELF        = 2,	-- 自己
	MASTER      = 3,    -- 主人
	FRIEND      = 4,    -- 友方
}

-- 目标实体类型
tb.TARGET_ENTITY_TYPE = {
	ALL    = 0,      -- 全部实体
	PLAYER = 1,      -- 玩家
	CREATURE = 2,    -- 怪物
	HERO      = 4,    -- 武将
}

-- 目标受击后的表现
tb.TARGET_ACTION = {
	NONE		= 0,
	KNOCKBACK	= 6,	-- 击退
	PULLIN		= 7,	-- 拉近
	--RESIST		= 1,	-- 反抗
	--IMMUNE		= 2,	-- 免疫
	--BOUNCE		= 3,	-- 反弹
	--SPRINT		= 4,	-- 冲刺
	--JUMP		= 5,	-- 跳跃
	--ROLL		= 8,	-- 翻滚
	--TRANSPORT	= 9,	-- 传送
};

--技能分类
tb.SKILL_EFFECT = {
	NONE             = 0,    -- 无效果
	PROB_DAMAGE      = 1,    -- 百分比伤害
	COMBO_DAMAGE     = 2,    -- 多次伤害（瞬间对目标造成N次伤害，如2连击
	VALUE_DAMAGE     = 3,    -- 附加值伤害
	CLEAVE_DAMAGE    = 4,    -- 分裂伤害（对目标周围范围一定敌对目标造成一定比例伤害）
	LEAP_DAMAGE      = 5,    -- 跳跃伤害（闪电链伤害）
	BUFF             = 6,    -- 附加状态
	CURE             = 7,    -- 治疗（瞬间恢复友方目标的生命，不能对敌方目标释放）
	STEAL_HP         = 8,    -- 吸血（攻击目标后吸收一定百分比的伤害转为自己生命）
--	      = 9,    -- 吸血（持续偷取目标生命化为自己的）
	KNOCK_BACK       = 10,   -- 击退（使目标后退一段距离）
	CHARGE           = 11,   -- 冲锋（瞬移到目标面前）
	PULLIN           = 12,   -- 拉人（将目标拉到自己面前）
	TELEPORT         = 13,   -- 传送
	SELF_EXPLODE     = 14,   -- 自爆（自杀并对周围目标造成一定伤害）
	SEPRATE_BODY     = 15,   -- 分身（分出1个真身和N个假身，分身解除所有控制状态）
	TRANSFORM_BODY   = 16,   -- 变身（变成另一个怪物，包括技能也全部改变）
	CLEAR            = 17,   -- 净化，清除一切异常状态
	CLEAN_BUFF       = 18,   -- 驱散己方目标损益状态或者敌对目标增益状态
	SUMMON           = 19,   -- 召唤（召唤怪物帮自己战斗）
	SUMMON_EX        = 20,   -- 召唤刷怪方案
	TAUNT            = 21,   -- 嘲讽
	RELIVE           = 22,   -- 复活
	AVERAGE_HP       = 23,   -- 平分血量（n个怪物血量平分）
	DISTRUST         = 24,   -- 反间(转化目标怪物为己方阵营)
	FOG              = 25,   -- 黑幕（迷雾）将一定范围的所有玩家都加上黑幕，可视范围变小
	ADD_ATTR         = 26,   -- 被动技能，给自己加永久属性
	TRAP             = 27,   -- 陷阱，安置一个陷阱，敌方移动到触发范围则触发陷阱
	INTERRUPT        = 28,   -- 打断，中断别人施法并且使打断的技能处于冷却状态N秒
	LARGE_DAMGE      = 29,   -- 召唤怪造成大量伤害
	HP_PROB_DAMAGE   = 30,   -- 基于玩家最大生命值百分比的伤害
	HP_RPOB_CURE     = 31,   -- 基于目标最大生命值百分比的治疗

	END              = 32,     
	-- 最大生命值, 当前生命值，击退，复活，拉近，嘲讽。。。

	-- EFFECT_TYPE_STEAL_HEALTH		= 4,	//生命窃取(上个目标伤害值)
	-- EFFECT_TYPE_RESTORE_HEALTH		= 5,	//恢复生命上限(攻击者生命值)
	-- EFFECT_TYPE_GENERATE_ENERGY		= 6,	//生成能量(生成值)
	-- EFFECT_TYPE_DECREASE_COOLDOWN	= 7,	//减少冷却(减少值)
	-- EFFECT_TYPE_KNOCKBACK			= 8,	//击退
	-- EFFECT_TYPE_RELIVE				= 9,	//复活
	-- EFFECT_TYPE_SUMMON				= 10,	//召唤(坐标、id)
	-- EFFECT_TYPE_SHOOT				= 11,	//射击(坐标)
	-- EFFECT_TYPE_TRAP				= 12,	//陷阱(坐标)
	-- EFFECT_TYPE_TELEPORT			= 13,	//瞬移(跳跃、冲刺、翻滚等)
	-- EFFECT_TYPE_TAUNT				= 14,	//嘲讽
	-- EFFECT_TYPE_PULLIN				= 15,	//拉近
	-- EFFECT_TYPE_ILLUSION			= 16,	//幻象(或召唤小怪)
	-- EFFECT_TYPE_PUTBARRIER			= 17,	//放置障碍物(比如怪物的墙）
	-- EFFECT_TYPE_ELEMENT_DAMAGE      = 18,   //造成元素伤害（随机金/木/水/火/土一种）
	-- EFFECT_TYPE_FOUR_DIR_SHOUT      = 19,   //四个方向施放
	-- EFFECT_TYPE_WAIT_TRAP           = 20,   //延迟陷阱(target_ext_value中的延迟时间)
	-- EFFECT_TYPE_SPEC_DAMAGE		    = 21,	//特定伤害(effect_value_flag的伤害类型)
	-- EFFECT_TYPE_RANDOM_DAMAGE		= 22,	//伤害区间技能(例如某个技能固定造成100~200的伤害值)
	-- EFFECT_TYPE_ADD_HEALTH			= 23,	//增加生命值(如增加100点生命)
	-- EFFECT_TYPE_PERCENT_DAMAGE		= 24,	//造成百分比伤害(不计算护甲，身法，抗性减免)
	-- EFFECT_TYPE_RANDOM_MUL_TRAP		= 25,	//施放多个陷阱(target_ext_value中的个数)
	-- EFFECT_TYPE_IGN_RESIS_DAMAGE    = 26,   //造成威力伤害（无视百分比护甲，身法，抗性）
	-- EFFECT_TYPE_COUNT,
}

-- 使用方式
tb.TRIGGER_TYPE = {
	ACTIVE = 1,       -- 主动释放
	BE_ATTACKED = 2,  -- 被攻击触发
	ATTACKED = 3,     -- 攻击触发
	HP_PERCENT = 4,   -- 生命处于x%到y%时触发
	DEAD = 5,         -- 死亡触发
	SUMMON = 6,       -- 召唤触发
	LEARN = 7,        -- 学习(获得)触发
	--SCRIPT = 8,       -- 脚本触发 放在各脚本的copyScript里触发
}

-- buff更新类型
tb.BUFF_UPDATE_TYPE = {
	CREATE  = 1,       -- 创建
	UPDATE  = 2,       -- 更新
	REMOVE  = 3,       -- 移除
}

-- buff移除原因
tb.BUFF_REMOVE_REASON = {
	NULL       = 0, 
	TITMEOUT   = 1,     -- 时间到了
	RECOVERY   = 2,     -- 被别的覆盖了
	DEATH      = 3,     -- 死亡
	REMOVE_FROM_WORLD = 4, -- 从场景中移除
}

-- buff移除类型
tb.BUFF_REMOVE_TYPE = {
	NONE              = 0, -- 不可驱散
	ATTACKED          = 1, -- 被攻击驱散
	SKILL             = 2, -- 技能驱散
	DEAD              = 4, -- 死亡驱散
	TRANSFER          = 8, -- 切图驱散
}

tb.BUFF_ATTR = {
	--NONE            = 0x0, 
	BUFF            = 0x0,    -- 增益效果 
	DEBUFF          = 0x1,    -- 减益效果
	--DEBUFF_CONTROL  = 0x4,    -- 控制debuff, attributesEx为控制类型
	--DOT             = 0x8,    -- dot, attributesEx为元素类型
}

-- buff 计时方式
tb.BUFF_DURATION_TYPE = {
	SECOND = 1,     -- 按照秒计时
	MSECOND = 2,    -- 按照毫秒计时
}

-- cd类型
tb.CD_TYPE = {
	ITEM = 1,       -- 物品cd
	SKILL = 2,      -- 技能cd
	BUFF = 3,       -- buff cd
	GLOBAL = 4,     -- 公共cd
}

--胜负条件PVE
tb.BATTLE_RESULT_CONDITION = {
	DEAD_NUM = 1,			--死亡人数少于等于
	ROUND_NUM = 2,			--战斗回合数少于等于
	HP_PER = 3,				--队伍总血量剩余大于等于x%百分比
}

--胜负
tb.BATTLE_RESULT = {
	WIN = 1,			--胜
	LOSE = 2,			--输
}

--死亡状态
tb.DEATH_STATE = {
	ALIVE = 1,      -- Unit is alive and well
	JUST_DIED = 2,  -- Unit has JUST died
	CORPSE = 3,		-- Unit has died but remains in the world as a corpse
	DEAD = 4,		-- Unit is dead and his corpse is gone from the world
}

--buff 类型
-- tb.BUFF_TYPE = {
-- 	NONE             = 0,	-- 木有效果
-- 	DOT_DAMAGE       = 1,   -- 持续伤害（流血，灼烧）
-- 	SILENCE          = 2,   -- 沉默（不可释放任何技能，只能用普通攻击）
-- 	IMMOBILIZE       = 3,   -- 定身（不移动，只能普通攻击）
-- 	DIZZY            = 4,   -- 眩晕 (使目标不可控制，无法进行任何战斗操作)
-- 	CHAOS            = 5,   -- 混乱 (使目标在一定范围内无规则移动，不可控制)
-- 	SLEEP            = 6,   -- 睡眠（使目标不受控制，受击则解除此效果）
-- 	IMMUNE           = 7,   -- 免疫 （免疫某些状态，可主动附加也可被动附加，不可被驱散）
-- 	UNBEATABLE		 = 8,	-- 无敌状态（免疫一些伤害和状态，不可被驱散）
-- 	ABSORB_DAMAGE 	 = 9,   -- 伤害吸收
-- 	RESILE_DAMAGE    = 10,  -- 伤害反弹,攻击的目标也会受到反噬         
-- 	REFLECT_DAMAGE   = 11,  -- 伤害反射,自己不受伤害，攻击的目标受到伤害
-- 	REVERSE_DAMAGE   = 12,  -- 伤害转治疗（将受到的伤害转化为治疗值，即减血变加血）
-- 	INVISIBLE        = 13,  -- 隐身，别人看不到自己，受到伤害或者攻击别人都会脱离这个状态
-- 	AURA             = 14,  -- 光环， 激活一个光环，持续存在，对光环内的所有目标都持续产生效果，同类效果不可叠加，只取最高值
-- 	DOUBLE_EXP       = 15,  -- 经验加倍
-- 	STEAL_HP         = 16,  -- 攻击目标后吸取一定伤害转化为生命
-- 	DOT_RECOVER      = 17,  -- 持续恢复生命
-- 	PROTECT          = 18,  -- 保护, 一段时间帮助目标承受攻击，防御等按照实施帮助的目标角色计算
--     SPEED_CHANGE     = 19,  -- 速度改变
--     CURE_CHANGE      = 20,  -- 治疗量改变
--     OUTPUT_DAMAGE    = 21,  -- 输出伤害
--     SUFFER_DAMAGE    = 22,  -- 承受伤害
--     ATTACK_CHANGE    = 23,  -- 攻击改变
--     MAX_HP_CHANGE    = 24,  -- 最大生命改变
--     PHY_DEF_CHANGE   = 25,  -- 物防改变
--     MAGIC_DEF_CHANGE = 26,  -- 法防改变
--     CRIT_CHANGE      = 27,  -- 暴击改变
--     HIT_CHANGE       = 28,  -- 命中改变
--     DODGE_CHANGE     = 29,  -- 闪避改变
--     THROUGH_CHANGE   = 30,  -- 穿透改变
--     CRIT_DEF_CHANGE  = 31,  -- 坚韧改变
--     DAMAGE_DOWN_CHANGE = 32,-- 免伤改变
--     BLOCK_CHANGE     = 33,  -- 格挡改变
--     CRIT_HURT_CHANGE = 34,  -- 暴击伤害
--     NIRVANA          = 35,  -- 死亡后等待一段时间复活,并恢复X%的血量

--     END              = 36, 
	-- debuff
	--DEBUFF_CONTROL   = 60,  -- 控制，除减速特殊处理，其他通用

	--dot或者技能的效果
	--DOT_BLEEDING     = 70,  -- 流血

	--END              = 71,
	-- CLEAN = 1,			--清除指定效果
	-- BUFF = 2,			--修改属性(有回合数)
	-- DIZZY = 3,			--眩晕
	-- BURNING	= 4,		--灼烧(施法者攻击力万分比伤害)
	-- ADD_HP	= 5,		--立即回血(永久)
	-- ANGER_UP = 6,		--怒气回复
	-- SHIELD = 7,			--护盾(增加buff持有者免伤)
	-- RECOVER	= 8,		--持续回血(施法者攻击力万分比加血)
	-- IMMUNE = 9,			--免疫(不中效果）
	-- INVINCIBLE	= 10,	--无敌
--}

tb.BUFF_EFFECT_TYPE = {
	NONE             = 0,  -- 木有效果
	DOT_DAMAGE       = 1,  -- 持续伤害
	ADD_STATE        = 2,  -- 附加状态（如冰冻，沉默，定身）
	DOT_RECOVER      = 3,  -- 持续恢复生命
	SPEED_CHANGE     = 4,  -- 速度改变
	ATTR_CHANGE      = 5,  -- 属性改变
	END              = 6,
}

--各种战斗用的状态
tb.COMBAT_STATE = {
	NONE             = 0,	-- 木有效果
	SILENCE          = 0x01,   -- 沉默
	IMMOBILIZE       = 0x02,   -- 定身
	DIZZY            = 0x04,   -- 眩晕(冰冻)
	SLEEP            = 0x08,   -- 睡眠
	CHAOS            = 0x10,   -- 混乱
	IMMUNE           = 0x20,   -- 免疫 （免疫某些状态，可主动附加也可被动附加，不可被驱散）
	UNBEATABLE		 = 0x40,   -- 无敌状态（免疫一些伤害和状态，不可被驱散）
	ABSORB_DAMAGE 	 = 0x80,   -- 伤害吸收
	RESILE_DAMAGE    = 0x100,  -- 伤害反弹,攻击的目标也会受到反噬         
	REVERSE_DAMAGE   = 0x200,  -- 伤害转治疗（将受到的伤害转化为治疗值，即减血变加血）
	INVISIBLE        = 0x400,  -- 隐身，别人看不到自己，受到伤害或者攻击别人都会脱离这个状态
	AURA             = 0x800,  -- 光环， 激活一个光环，持续存在，对光环内的所有目标都持续产生效果，同类效果不可叠加，只取最高值
	EXP_ADD_ON_KILL  = 0x1000, -- 击杀经验加成
	STEAL_HP         = 0x2000,  -- 攻击目标后吸取一定伤害转化为生命
	PROTECT          = 0x4000,  -- 保护, 一段时间帮助目标承受攻击，防御等按照实施帮助的目标角色计算
	--BLIND            = 0x8000, -- 致盲

    --END              = 6, 
	

	-- SLOWDOWN				= 0x10,		-- 减速	p
	-- REPULSE					= 0x20,		-- 击退	d
	-- COMA					= 0x02,		-- 昏迷	t
	-- FREEZA					= 0x04,		-- 冻结	t
	-- STARSHARDS				= 0x40,		-- 星陨标记
	-- DRAGONDANCING			= 0x80,		-- 苍龙狂舞
	-- SPIRITCURSE				= 0x100,	-- 冷月灵咒
	-- WANJUNROAR				= 0x200,	-- 万钧轰鸣
	-- ROARSMOUNTAINS			= 0x400,	-- 虎啸山林
	-- SEASINGING				= 0x800,	-- 大海龙吟
	-- TSINGYI					= 0x1000,	-- 青衣护体
	-- NIMBUS					= 0x2000,	-- 玄云护体
	-- SPIRIT					= 0x4000,	-- 灵力护体

	-- INVISIBLE				= 0x8000,	-- 隐身

	-- DURANCE					= 0x10000,	-- 禁锢
	-- SLEEPD					= 0x20000,	-- 沉睡状态(通用的模型沉睡状态)
	-- FASTING					= 0x40000,	-- 禁食(不能使用血瓶)
	
	-- SHIELD					= 0x80000,	-- 护盾
	-- UNARM					= 0x100000,	-- 缴械
	-- INTERTWINE				= 0x200000,	-- 缠绕	
}

------------------------------------------战斗相关end-----------------------------------


--------------------------------------地图副本相关begin---------------------------------------

tb.MAP_TYPE = {
	NORMAL         = 1,   -- 普通场景
	COPY_SINGLE    = 2,   -- 剧情副本
	COPY_TEAM      = 3,   -- 组队副本
	COPY_TOWER     = 4,   -- 爬塔副本
	COPY_ALLIANCE  = 5,   -- 军团副本
	COPY_HOLY      = 6,   -- 过关斩将副本
	ARENA          = 7,   -- 竞技场副本
	SHORTCUT       = 8,   -- 快捷副本
	ALLIANCE_LEGION = 9,  -- 军团领地
	GUIDE          = 10,  -- 开场引导地图
	WILD_BOSS      = 11,  -- 野外boss副本
	FACTION        = 12,  -- 战场
	COPY_MATERIAL  = 13,  -- 材料副本 兵来将挡
	TEAM_VS        = 14,  -- 组队3v3
	PROTECT_CITY   = 15,  -- 魔族围城
	SMALL_GAME     = 16,  -- 玩法副本（小副本）
	COPY_MATERIAL2 = 17,  -- 材料副本 时空宝藏
}

-- 地图子类型
tb.MAP_SUB_TYPE = {
	HOLE_BOSS = 1,   -- 地洞boss
	WILD_BOSS = 2,   -- 野外boss
	DEATHTRAP = 3,   -- 魔狱绝地系列
	MAGIC_BOSS = 4,  -- 魔域领主
}
--boss类型
tb.BOSS_TYPE = {
	HOLE_BOSS = 1,   -- 地洞boss
	WILD_BOSS = 2,   -- 野外boss
	MAGIC_BOSS = 3,  -- 魔域领主
}
--副本类型
tb.COPY_TYPE = {
	NONE 			= 0, 	 -- 无
	STORY 			= 1, 	 -- 剧情
	TEAM 			= 2, 	 -- 组队
	TOWER 			= 3, 	 -- 爬塔

	HOLY 			= 4, 	 -- 过关斩将
	ARENA 			= 5, 	 -- 竞技场

	ALLIANCE 		= 6, 	 -- 军团
	SHORTCUT 		= 7, 	 -- 快捷副本
	GUIDE 			= 8, 	 -- 开场引导副本
	WILD_BOSS 		= 9, 	 -- 野外地图副本
	MATERIAL 		= 10, 	 -- 材料副本1 兵来将挡
	FACTION 		= 11, 	 -- 战场
	TEAM_VS 		= 12, 	 -- 组队3v3
	PROTECT_CITY 	= 13, 	 -- 魔族围城
	SMALL_GAME 		= 14, 	 -- 玩法副本(小副本)
	MATERIAL2 		= 15, 	 -- 材料副本2 时空宝库
}

tb.COPY_TYPE_VIEW = {
	STORY 		= 1,		-- 剧情
	HOLY  		= 2,      -- 过关斩将
	TOWER 		= 3,      -- 爬塔
	TEAM 		= 4,      -- 组队
	MATERIAL 	= 5,      -- 兵来将挡
	MATERIAL2 	= 6,      -- 时空宝库
}
tb.LEGION_TYPE_VIEW = {
	INFO 		= 1,		--信息
	MANAGER 	= 2,		--管理
	ACTIVITY 	= 3,		--活动
}
--副本关卡宝箱状态
tb.COPY_BOX_STAGE = {
	CLOSE = 1,		--不可领取
	OPEN = 2,		--可以领取
	GOT = 3,		--已领取
}

-- 副本进度
tb.COPY_PROGRESS = {
	UNSTART = 1,    -- 还没开始(准备过程)
	PROCESS = 2,	--进行中
	END = 3,		--已结束
}



-- 地图挂机类型
tb.MAP_AUTO_COMBAT_TYPE = {
	RANGE     = 1,                     -- 范围挂机
	ALL       = 2,                     -- 全图挂机
}

-- 地图标志
tb.MAP_FLAG = {
	NULL         = 0,	   -- 无标志
	PK_PEACE     = 0x01,   -- 和平模式
	PK_ALLIANCE  = 0x02,   -- 军团模式
	PK_SERVER    = 0x04,   -- 本服模式
	PK_WORLD     = 0x08,   -- 全体模式
	TRANSPORT_OUT = 0x10,   -- 允许传送
	FORBID_RIDE  = 0x20,    -- 禁止坐骑
	FORBID_REST  = 0x40,    -- 禁止打坐
	PK_FACTION   = 0x80,   -- 阵营模式
	-- 禁止坐骑，禁止飞行
}

-- 特殊的地图id
tb.SPECIAL_MAP_CODE = {
	XIN_SHOU_CUN    = 111101,  -- 新手村
	ARENA      = 150201,       -- 竞技场地图
}

--------------------------------------地图副本相关end------------------------------------------

--邮件类型
tb.EMAIL_TYPE = {
	SYS_MAINTAIN                = 1,  -- 系统维护
	SYS_FAULT                   = 2,  -- 系统故障
	ARENA_RANK                  = 3,  -- 竞技场排名
	DICE_ZERO                   = 4,  -- 寻宝系统0圈奖励
	PATROL_HELP                 = 5,  -- 巡逻系统好友帮忙
	INBREAK_KILL                = 6,  -- 入侵boss击杀奖励
	INBREAK_FIND                = 7,  -- 入侵boss发现奖励
	INBREAK_DAMAGE              = 8,  -- 入侵boss伤害排行奖励
	INBREAK_POINT               = 9,  -- 入侵boss积分（点赞)排行奖励
	RECHARGE_MESSAGE            = 10, -- 充值通知提醒
	SUPER_SIGN                  = 11, -- 豪华签到奖励
	GM                          = 12, -- 后端邮件
	MONTH_CARD_MESSAGE          = 13, -- 月卡充值通知
	PERMANENT_CARD_MESSAGE      = 14, -- 永久充值通知
	BAG_FULL                    = 15, -- 背包已满
	COPY_TOWER_OFFLINE_REWARD   = 16, -- 爬塔副本奖励补发
	ALLIANCE_ANNOUNCEMENT       = 17, -- 军团公告
	ALLIANCE_AUCTION_SUCCEED    = 18, -- 军团竞拍成功 发送竞拍物品
	ALLIANCE_AUCTION_FAIL       = 19, -- 军团竞拍失败 返还竞拍出价的军团贡献
	ONLINEGIFT_WEEK             = 20, -- 在线时长上周奖励
	WEEK_CARD                   = 21, -- 在线时长上周奖励
	MONTH_CARD                  = 22, -- 在线时长上周奖励
	ALLIANCE_NEEDFIRE_DICE      = 23, -- 军团篝火掷骰子排名奖励
	ALLIANCE_DISSOLVE           = 24, -- 军团解散
	ALLIANCE_BE_KICKED          = 25, -- 军团 被踢出
	ALLIANCE_BE_ACCEPT          = 26, -- 军团 申请加入成功
	ALLIANCE_LEADER_AUTO_CHANGE = 27, -- 统帅自动转让
	ALLIANCE_IMPEACH_LEADER     = 28, -- 弹劾统帅
	ALLIANCE_IMPEACH_FAIL       = 29, -- 弹劾失败
	ALLIANCE_IMPEACH_SUCCEED    = 30, -- 弹劾成功
	ALLIANCE_LEGION_BOSS_REWARD = 31, -- 军团兽神奖励
	MARKET_ITEM_SELL_SUC        = 32, --市场上成功把东西卖出去
	MARKET_ITEM_BUY_SUC         = 33, --市场上成功把东西买到
	MARKET_ITEM_SELL_FAIL       = 34, --市场上没有把东西卖出去
	COPY_TOWER_DAILY_REWARD 	= 35, --虚无之塔每日奖励
	PLAYER_CHANGE_NAME 			= 36, --好友改名通知
	ALLIANCE_CHANGE_NAME 		= 37, --所在军团改名通知
	ACTIVITY_RANK_REWARD 		= 38, --排行榜奖励邮件
	GM_EMAIL 					= 39, --GM邮件
	PROTECT_CITY_WIN_1          = 40, --魔族围城成功第一名
	PROTECT_CITY_WIN_2          = 41, --魔族围城成功第二名
	PROTECT_CITY_WIN_3          = 42, --魔族围城成功第三名
	PROTECT_CITY_WIN_10         = 43, --魔族围城成功第4-10名
	PROTECT_CITY_WIN_20         = 44, --魔族围城成功第11-20名
	PROTECT_CITY_WIN_50         = 45, --魔族围城成功第21-50名
	PROTECT_CITY_WIN_100        = 46, --魔族围城成功第51-100名
	--PROTECT_CITY_WIN_1000          = 47, --魔族围城成功第51 - 100名
	PROTECT_CITY_FAIL_1         = 48, --魔族围城失败第一名
	PROTECT_CITY_FAIL_2         = 49, --魔族围城失败第二名
	PROTECT_CITY_FAIL_3         = 50, --魔族围城失败第三名
	PROTECT_CITY_FAIL_10        = 51, --魔族围城失败第4-10名
	PROTECT_CITY_FAIL_20        = 52, --魔族围城失败第11-20名
	PROTECT_CITY_FAIL_50        = 53, --魔族围城失败第21-50名
	PROTECT_CITY_FAIL_100       = 54, --魔族围城失败第51-100名
	--PROTECT_CITY_WIN_1000     = 55, --魔族围城失败第51 - 100名
	PROTECT_CITY_KILLER         = 56, --魔族围城boss击杀
	ARENA_WEEKLY_REWARD         = 57, --竞技场每周排名奖励
}

tb.CHAT_HISTORY={
	COUNT = 10,
	TIME = 5 * 60,
}
--聊天频道
tb.CHAT_CHANNEL = {
	MAIN_UI      = 0,  -- 主界面
	WORLD        = 1,  -- 世界
	CURRENT      = 2,  -- 当前
	ARMY_GROUP   = 3,  -- 军团
	TEAM         = 4,  -- 队伍
	COPY         = 5,  -- 副本
	BATTLEFIELD  = 6,  -- 战场
	COUNTRY      = 7,  -- 场景
	SYSTEM       = 8,  -- 系统:显示在聊天框内的信息
	SPEAKER      = 9,  -- 大喇叭

	BAR          = 10, -- 走马灯:显示位于界面上方显示的信息
	SYSTEM_BAR   = 11, -- 系统+走马灯:都显示
	ALLIANCE_SYS = 12, -- 联盟系统

	END          = 99  -- 客户端用于判断 发送消息频道小于此值则是发送到公共聊天，大于则是人物id，属私聊信息
						--可以END使用此值来获取不需要自动发送，只需要转文字的语音
}


--任务类型
tb.TASK_TYPE= {
	MAIN           = 1,   -- 主线
	BRANCH         = 2,   -- 支线
	DAILY          = 3,	  -- 日常(又叫天机任务又叫循环任务)
	ALLIANCE_DAILY = 4,   -- 军团收集物资
	ESCORT         = 5,   -- 护送任务
	ALLIANCE_REPEAT= 6,   -- 军团重复任务
	FACTION        = 7,   -- 战场
	ALLIANCE_PARTY = 8,   -- 军团宴会任务
	ALLIANCE_GUILD = 9,   -- 军团引导任务 
	EVERY_DAY 	   = 10,  -- 每日任务
	EVERY_DAY_GUILD= 11,  -- 每日引导任务
}

--任务状态
tb.TASK_STATUS = {
	NONE       = 0,  -- 不可领取
	AVAILABLE  = 1,  -- 可领取     
	PROGRESS   = 2,	 -- 进行中
	COMPLETE   = 3,	 -- 已完成
	FINISH     = 4,	 -- 已结束
}

tb.TASK_LOG_STATE = {
	ACCEPTED	= 1, 	-- 已接取
	COMPLETED 	= 2, 	-- 已完成
	HANDED_UP 	= 3, 	-- 已提交
}

--任务完成条件类型
tb.TASK_SUB_TYPE = {
	KILL_CREATURE       = 1,	-- 击杀怪物
	COLLECT             = 2,	-- 采集
	NPC_GOSSIP          = 3,    -- 找npc对话
	NPC_HAND_UP         = 4,	-- 上交道具给npc
	CHALLENGECOPY       = 5,    -- 通关副本
	LEVEL_UP            = 6,    -- 升级
	DESTINATION         = 7,    -- 到达地图上的某个点
	ENTER_COPY          = 8,    -- 进入副本
	ALLIANCE_DAILY      = 9,    -- 军团每日任务
	ESCORT              = 10,   -- 护送完成
	ENHANCE_EQUIP       = 11,   -- 强化装备
	FORMULA_EQUIP       = 12,   -- 打造装备
	POLISH_EQUIP        = 13,   -- 洗练装备
	INLAY_GEM           = 14,   -- 镶嵌宝石
	STAGE_UP_HORSE      = 15,   -- 坐骑进阶
	POLISH_HERO         = 16,   -- 武将洗练
	UPGRADE_SOUL_HOURSE = 17,   -- 坐骑封灵
	SKILL_LEVEL_UP      = 18,   -- 升级技能
	FACTION_HAND_UP     = 19,   -- 提交采集珠给军需官
	FACTION_KILL        = 20,   -- 击败3人or助攻5人or死亡3次
	ALLIANCE_JOIN       = 21,   -- 加入军团
	SHAKE_MONEY_TREE    = 22,   -- 摇摇钱树
	HERO_LEVEL_UP       = 23,   -- 武将升级
	DEATHTRAP_EXP       = 24,   -- 魔狱10倍经验击杀
	TOWER_COPY_FLOOR    = 25,   -- 通关爬塔副本层数
}

--任务提交方式
tb.TASK_HANDUP_TYPE = {
	FIND_NPC            = 1,   -- 找npc交任务 默认
	FINISH_AT_ONCE      = 2,   -- 达成条件立刻自动完成
	FINISH_CLICK_TASK   = 3,   -- 达成条件 点击任务栏中的任务
}

--活动状态
tb.ACTIVITY_STATUS = {
	PROGRESS = 1,	--进行中
	END = 2,		--已结束
	UNSTART = 3,	--未到开启时间
	DEL = 4,		--删除
}

--活动开启方式（弃用）
tb.ACTIVITY_TTYPE = {
	OPENSERVER = 1,		--按照开服时间
	CREATE = 2,			--按照创号时间
	TIME = 3,			--按照给定时间
}

tb.ACTIVITY_TYPE = {
	LOGIN = 1,  	--累计登录活动
	RANK  = 2, 		--排行榜活动
	EXCHANGE = 3, 	--兑换活动
	TASK 	 = 4, 	--任务活动
	WHEEL 	 = 5, 	--转盘活动
	-- 以下弃用
	-- DAILY_SIGN = 1, --每日签到
	-- SUPER_SIGN = 2, --豪华签到
	-- LEVEL_BAG = 3,  --等级礼包
	-- STRENGTH_GET= 4, --体力领取
}

--公告类型
tb.NOTICE_TYPE = {
	ALL = 1,			--全服
	LOCAL = 2, 			--本服
}

--登录活动类型
tb.LOGIN_TYPE = {
	ONCE = 1,			--单词循环
	CIRCLE = 2,			--多次循环
}


--活动累计类型
tb.ACCUMULATE_TYPE = {
	DAY = 1,		--每日
	FOREVERY = 2,	--永久
}


--提示类型
tb.TIPS_TYPE = {
	SHOW_TIPS = 1, 	--飘字
	SHOW_WINDOW = 2,--弹窗
}

--服务端推送
tb.PUSH_TYPE = {
	BEATTACK = 1, 	--有攻击行军
	COLLECT = 2, 	--采集完成
	BACKCITY = 3, 	--所有队伍都已回城
}

-- 玩法副本任务条件
tb.SMALL_GAME_CONDITION_TYPE = {
	KILL_CREATURE = 1, --击杀怪物
	PROTECT_NPC = 2,   --守卫npc
}



--功能模块
tb.MODULE = {
	
}

--商店购买排名限制类型
tb.SHOP_RANGE_TYPE = {
	NONE = 0,        --无限制
	ARENA = 1,       --竞技场段位限制
	VIP = 2,         --VIP等级限制
}

--商店限购种类
tb.SHOP_LIMIT_TYPE = {
	DAY = 1, 		 --每日限制
	WEEK = 7, 		 --每周限制（每周一0点刷新）
	MONTH = 30, 	 --每月限制（每月1号刷新）,暂不支持,有需求再加
}

tb.FREE_STRENGTH_TYPE = {
	LUNCH = 1,
	DINNER = 2,
}


tb.SHOP_BASE_RES_EX = {
	BEGIN = 100,
	BOTH_GOLD_BIND_GOLD = 100,
	ITEM = 101,
}

--军团职位
tb.ALLIANCE_TITLE = { 
	LEADER      = 1,   -- 统帅
	VICE_LEADER = 2,   -- 副统帅
	STRATEGIST  = 3,   -- 军师
	ADVISER     = 4,   -- 谋士
	PIONEER     = 5,   -- 先锋
	MEMBER      = 6,   -- 成员
}

--军团权限
tb.ALLIANCE_MANAGE = { 
	ALLIANCE_LEVELUP    = 1, 	-- 升级军团
	WAR_FLAG_LEVELUP    = 2, 	-- 升级战旗
	MODIFY_INFO         = 3, 	-- 修改信息
	TITLE_MANAGE        = 4, 	-- 职位管理
	DESTORY_EQUIP       = 5, 	-- 销毁装备
	OPEN_ACTIVITY       = 6, 	-- 开启活动
	ACCEPT_APPLY        = 7, 	-- 通过申请
	MODIFY_JOIN_LIMIT   = 8, 	-- 修改申请限制
	DISSOLVE            = 9, 	-- 解散军团
	IMPEACH             = 10,	-- 弹劾统帅
}

--军团活动
tb.ALLIANCE_ACTIVITY = { 
	DAILY_TASK    			= 1, -- 1. 收集物资
	ANCIENT_BOSS        	= 2, -- 2. 上古妖王
	LEGION_COPY       		= 3, -- 3. 军团副本
	LEGION_WAR         		= 4, -- 4. 军团战
	LEGION_PARTY        	= 5, -- 5. 军团宴会（暂不开启）
	LEGION_TRAIN        	= 6, -- 6. 军团训练
	LEGION_TASK        		= 7, -- 7. 军团任务
	LEGION_NEEDFIRE         = 8, -- 8. 军团篝火
}
--公司副本状态
tb.ALLIANCE_COPY_STATE = { 
	BEGIN = 1,     	--还未打过
	BATTLE = 2,    	--可以开打
	FINISH = 3,   	--打完可以领奖励
}

--军团仓库拍卖状态
tb.ALLIANCE_AUCTION_STATU = {
	NONE = 1,		--无
	AUCTIONING = 2,	--正在拍卖
}

--公司副本通关设置
tb.ALLIANCE_COPY_PASS_SET = { 
	CURRENT = 1,    --当前的关卡
	LAST = 2,     	--最后通关的关
}


tb.RANKING_TYPE = {
	POWER 				= 1,        -- 	战力排行
	HERO 				= 2,		--	玩家武将排行
	LEVEL 				= 3,		--	玩家等级排行
	ALLIANCE_FUND 		= 4,  		--	军团资金
	ALLIANCE_DONATE 	= 5, 		-- 	军团贡献(排个人)
	ALLIANCE_LEVEL 		= 6, 		--	军团等级排行
	QUESTION_DAILY 		= 7, 		--	每日答题
	TVT            		= 8, 		-- 	烽火对决 	3V3
	HORSE          		= 9, 		-- 	坐骑排行
	ACHIEVEMENT         = 10, 		-- 	成就排行
	GEM         		= 11, 		-- 	宝石排行
	TOWER         		= 12, 		-- 	爬塔排行
	DEFENSE 			= 13, 		--	魔族围城
}

--一次性新手记录
tb.GUIDE_RECORD = {
	BUY_HERO = 1, --已经招募过英雄
	UPGRADE_HERO = 2, --已经强化过英雄
}

--充值卡类型
tb.RECHARGE_TYPE = {
	WEEK_CARD = 1, 		--周卡
	MONTH_CARD = 2, 		--月卡
	NORMAL = 3,
}

tb.BROADCAST_DATA = {
	PLAYER = 1, --玩家
	ITEM = 2, --物品
	NUM = 3, --数字
}

-- object类型
tb.MAP_OBJECT_TYPE = {
	CREATURE        = 1, -- 怪物
	NPC             = 2, -- npc
	TRANPORT        = 3, -- 传送点
	WALL            = 4, -- 阻挡
	CREATURE_CENTER = 5, -- 怪物中心点
	PATH_POINT		= 6, -- 寻路路径点 客户端界面显示用
	REFRESH_CREATURE  = 7, -- 动态刷怪表，对应creature_refresh
	SCENE_OBJ       = 8, -- 场景的某些模型可被破坏：木箱，酒缸之类的 
	SCENE_EFFECT    = 9, -- 场景特效
}

-- 怪物标志
-- tb.CREATURE_FLAG = {
-- 	NO_RESET_HP     = 1, --脱战不回血
	
-- }

-- 怪物类型
tb.CREATURE_TYPE = {
	NORMAL          = 1, -- 普通怪
	COLLECT         = 2, -- 采集怪
	BLOCK           = 3, -- 阻挡怪
	TOUCH           = 4, -- 触碰怪
	HP              = 5, -- 生命怪物
	BOSS            = 6, -- boss
	WORLD_BOSS      = 7, -- 世界boss
	BEAUTY          = 8, -- 美人
}

-- object类型
tb.OBJ_TYPE = {
	OBJECT			= 0,
	CREATURE		= 1, -- 怪物或宠物
	PLAYER			= 2, -- 玩家
	ITEM			= 3, -- 是否用这个做掉落
	CONTAINER		= 4, -- 容器？包裹？
	GAMEOBJECT		= 5, -- 采集点？
	DYNAMICOBJECT	= 6, -- 释放的动态物体，光环？
	COMBAT_ATTR 	= 7, -- 战斗属性
	AREATRIGGER	    = 8, -- 传送点
	TREASURE		= 9,
	HERO			= 10, -- 武将
	QUEST			= 11, -- 任务
	COLLECTION		= 12, -- 采集物
	LOOTITEM		= 13, -- 掉落物
	MISSILE		    = 14, -- 发射物
	PLAYER_ATTR	    = 15, -- 玩家通用属性
	SIMPLE_ITEM	    = 16, -- 简单道具
	BARRIER		    = 17, -- 障碍物
	PLAYER_CLONE	= 18, -- 玩家的召唤，从CREATURE继承过来
	PROHIBIT_AREA	= 19, -- 禁止区域
	DAILY_RECORD	= 20, -- 日常记录对象
	PERMANENT_RECORD = 21, -- 永久记录对象
	NPC              = 22, -- npc
	--TYPEID_NONE,				-- used to signal invalid reference (object dealocated but someone is still using it)
}

-- 召唤怪的字段
tb.PLAYER_CLONE_FIELDS = {
	-- 召唤者
	--GENDER = 1,		-- 性别
	CAREER = 1,		-- 职业
	--WEAPON_ENTRY = 2,	-- 武器
	--HELMET_ENTRY = 3,	-- 头盔
	--SHOULDER_ENTRY = 4,	-- 肩甲
	--BODY_ENTRY = 5,		-- 胸甲
	--SHOE_ENTRY = 6,		-- 鞋子
	--ARTIFACE_ENTRY = 7,	-- 神器
	--MOUNT_ENTRY = 8,	-- 坐骑
	--WING_ENTRY = 9,		-- 翅膀
	--ADORN_ENTRY = 10,	-- 时装
	END = 2,
}

--player和creature的基类域
tb.UNIT_FIELDS = {
	UNIT_HP           = tb.OBJ_FIELDS.OBJ_END + 0x000,       -- 当前生命
	UNIT_MAX_HP       = tb.OBJ_FIELDS.OBJ_END + 0x001,       -- 最大生命
	UNIT_LEVEL        = tb.OBJ_FIELDS.OBJ_END + 0x002,       -- 当前等级
	UNIT_ICON         = tb.OBJ_FIELDS.OBJ_END + 0x003,       -- 头像
	UNIT_COMBAT_STATE = tb.OBJ_FIELDS.OBJ_END + 0x004,       -- 战斗状态
	UNIT_SPEED        = tb.OBJ_FIELDS.OBJ_END + 0x005,       -- 移动速度
	UNIT_DYNAMIC_FLAGS = tb.OBJ_FIELDS.OBJ_END + 0x006,      -- 动态标记(骑乘，打坐，护送等状态的显示)
	UNIT_FACTION      = tb.OBJ_FIELDS.OBJ_END + 0x007,       -- 阵营

	UNIT_END          = tb.OBJ_FIELDS.OBJ_END + 0x008, 
}

--player域
tb.PLAYER_FIELDS = {
	PLAYER_CAREER      = tb.UNIT_FIELDS.UNIT_END + 0x000,           -- 职业
	PLAYER_EXP   	   = tb.UNIT_FIELDS.UNIT_END + 0x001,           -- 经验
	PLAYER_GOLD        = tb.UNIT_FIELDS.UNIT_END + 0x002,           -- 金币
	PLAYER_DIAMOND     = tb.UNIT_FIELDS.UNIT_END + 0x003,           -- 钻石
	PLAYER_TITLE       = tb.UNIT_FIELDS.UNIT_END + 0x004,           -- 称号
	PLAYER_ALLIANCE_ID = tb.UNIT_FIELDS.UNIT_END + 0x005,           -- 军团
	PLAYER_VIP_LEVEL   = tb.UNIT_FIELDS.UNIT_END + 0x006,           -- vip等级
	--队伍相关
	PLAYER_TEAM_ID     = tb.UNIT_FIELDS.UNIT_END + 0x007,           -- 队伍id
	PLAYER_PK_MODE     = tb.UNIT_FIELDS.UNIT_END + 0x008,           -- pk mode
	PLAYER_ISTEAMLEADER = tb.UNIT_FIELDS.UNIT_END + 0x009,          -- 0为非队长1为队长
	PLAYER_HORSE_CODE  = tb.UNIT_FIELDS.UNIT_END + 0x00a,           -- 坐骑原型code

	-- 装备相关
	PLAYER_EQUIP_WEAPON = tb.UNIT_FIELDS.UNIT_END + 0x00b,          -- 武器
	PLAYER_EQUIP_HELMET = tb.UNIT_FIELDS.UNIT_END + 0x00c,          -- 铠甲

	-- 能量珠三个空
	PLAYER_ENERGY_BEAD1 = tb.UNIT_FIELDS.UNIT_END + 0x00d,           -- 能量珠坑1品质
	PLAYER_ENERGY_BEAD2 = tb.UNIT_FIELDS.UNIT_END + 0x00e,           -- 能量珠坑2品质  
	PLAYER_ENERGY_BEAD3 = tb.UNIT_FIELDS.UNIT_END + 0x00f,           -- 能量珠坑3品质 

	--战斗力
	PLAYER_POWER        = tb.UNIT_FIELDS.UNIT_END + 0x010,           -- 战力

	--外观时装
	PLAYER_SURFACE_CLOTHES       = tb.UNIT_FIELDS.UNIT_END + 0x011,           -- 时装_衣服
	PLAYER_SURFACE_WEAPON        = tb.UNIT_FIELDS.UNIT_END + 0x012,           -- 时装_武饰
	PLAYER_SURFACE_CARRY_ON_BACK = tb.UNIT_FIELDS.UNIT_END + 0x013,           -- 时装_背饰
	PLAYER_SURFACE_SURROUND      = tb.UNIT_FIELDS.UNIT_END + 0x014,           -- 时装_气息
	PLAYER_SURFACE_TALK_BG       = tb.UNIT_FIELDS.UNIT_END + 0x015,           -- 时装_气泡
	PLAYER_DROP_BELONG           = tb.UNIT_FIELDS.UNIT_END + 0x016,           -- 掉落归属

	PLAYER_HP_RECOVER            = tb.UNIT_FIELDS.UNIT_END + 0x017,           -- 回血值飘字

	PLAYER_END         = tb.UNIT_FIELDS.UNIT_END + 0x018,           -- end                         
}

tb.CREATURE_FIELDS = {
	ATTACK_SPEED      = tb.UNIT_FIELDS.UNIT_END + 0x001,           -- 攻击速度
	ATTACK_RANGE      = tb.UNIT_FIELDS.UNIT_END + 0x002,           -- 攻击范围
}

--更新类型
tb.OBJECT_UPDATE_TYPE = {
	VALUES          = 1,      -- 属性变化
	CREATE_OBJECT   = 2,      -- 创建对象
	CREATE_YOURSELF = 3,      -- 创建自己
	OUT_OF_RANGE_OBJECTS = 4, -- 移除
}

--战斗属性域
tb.COMBAT_PROP_FIELDS = {
}



-- 宠物行为控制
tb.HERO_CONTROL_FLAG = {
	HERO_CLIENT_CONTROL = 0,  -- 客户端控制
	HERO_SERVER_CONTROL = 1,  -- 服务端控制
}

--对象数据同步
tb.DATA_SYNC_TYPE = {
	NONE			= 0,	-- 无类型
	CREATE		    = 1,	-- 创建对象
	VALUPDATE	    = 2,	-- 值更新
	REMOVE		    = 3,	-- 对象移除

	END             = 4,    
}

--移动类型
tb.OBJ_MOVE_TYPE = {
	STOP_MOVING      = false,           -- 不动
	START_MOVING     = true,           -- 移动中
}

--怪物移动类型
tb.MOVE_TYPE = {
	NONE         = 0,  -- 不移动
	RANDOM       = 1,  -- 随机移动
	WAY_POINT    = 2,  -- 路径移动
	FOLLOW       = 3,  -- 跟随某目标移动
}

-- 这里配置一些特殊的怪物，如护送女神，竞技场冠军等
tb.CREATRURE_FAMILY = {
	NONE            = 0,
	PROTECT_BEAUTY  = 1,    -- 护送女神
	ARENA_CHAMPION  = 2,    -- 竞技场冠军
}

-- 特殊ai
tb.AI_FLAG = {
	FLEE          = 0x01,  -- 逃跑
	NO_RESET_HP   = 0x02,  -- 不恢复生命值
	STAY          = 0x04,  -- 不回到出生点
	ATTACK_PLAYER_ONLY = 0x08, -- 只打玩家和武将
}

-- ai状态
tb.AI_STATE = {
	IDLE          = 0,  -- 空闲
	ATTACKING     = 1,  -- 攻击
	RIGIDITY      = 2,  -- 僵直
	FLEEING       = 3,  -- 逃跑
	FOLLOWING     = 4,  -- 跟随
	EVADE         = 5,  -- 超出战斗范围回到行动点
	MOVEWP        = 6,  -- 沿路点行走
	FEAR          = 7,  -- 被恐惧
	WANDER        = 8,  -- 游荡
	STOPPED       = 9   
}

-- ai攻击类型
tb.AI_TYPE = {
	PASSIVE       = 1, -- 被动
	ACTIVE        = 2, -- 主动
	PEACE         = 3, -- 不还手
}

-- ai代理
tb.AI_AGENT = {
	NULL          = 0, 
	MELEE         = 1, -- 近程攻击
	RANGED        = 2, -- 远程攻击
	FLEE          = 3, -- 逃跑
	SPELL         = 4, -- 固定技能
	IMMUNE        = 5, -- 免疫某种技能效果
	NPC_ATTACKER  = 6, -- 进攻npc的怪物
}

tb.AI_RANGE = {
	NORMAL       = 1,  -- 普通视野
	COMBAT       = 2,  -- 战斗视野
	CALL_HELP    = 3,  -- 呼叫救援视野
}

-- 切换地图类型
tb.TRANSFER_MAP_TYPE = {
	TRANSPORT_POINT = 1,   -- 传送点传送
	WORLD_MAP       = 2,   -- 点世界地图传送
	REVIVE          = 3,   -- 普通复活
	-- ...后续请补充
}

-- 玩家服和场景服之间的交互协议
tb.SERVER_MESSAGE = {
	PLAYER_TO_SCENE_ENTERGAME     = 1,    -- 玩家请求进入游戏
	SCENE_TO_PLAYER_ENTERGAME     = 2,    -- 玩家请求进入游戏结果

	PLAYER_TO_SCENE_CHANGESCENE = 3,  -- 玩家切换地图
	GATE_CHANGESCENE  = 4,  -- 网关通知中央服切换场景，暂时终止部分消息处理

	SCENE_SAVE_PLAYER_DATA    = 5,  -- 场景服请求中央服存储玩家数据

	PLAYER_TO_SCENE_SYNC_OBJECT_DATAS  = 6,  -- 玩家服到场景服的对象数据同步
	SCENE_TO_PLAYER_SYNC_OBJECT_DATAS  = 7,  -- 场景到玩家服的服务端消息

	SCENE_TO_PLAYER_SYNC_POSITION      = 8,  -- 场景服向玩家服同步玩家坐标数据

	PLAYER_TO_SCENE_ENTER_COPY         = 9,  -- 玩家请求进入副本
	PLAYER_TO_SCENE_EXIT_COPY          = 10, -- 玩家请求退出副本

	PLAYER_TO_SCENE_SYNC_TEAMINFO      = 11, -- 玩家服向场景服同步队伍信息

	SCENE_TO_PLAYER_SYNC_OPERATION     = 12, -- 场景服向玩家服同步玩家行为
	PLAYER_TO_SCENE_SYNC_OPERATION     = 13, -- 玩家服向场景服同步玩家行为

	PLAYER_TO_SCENE_MAP_LOADED         = 14, -- 地图加载完成

	END = 15, 
}

tb.TITLE_EVENT = {
	TASK_DONE             = 1,   -- 完成某一章节的所有任务
	PVP_KILL              = 2,   -- PVP击杀玩家达到指定数目
	ACTIVITY_DONE         = 3,   -- 完成一个活动的所有内容
	PVE_KILL_IN_TIME      = 4,   -- 限时N怪斩
	PVP_KILL_DAY          = 6,   -- 当天PVP击杀玩家达到指定数目
	ACTIVITY_DONE_IN_TIME = 5,   -- 完成一个限时活动
	LEVEL_UP              = 7,   -- 等级达到
	GET_COIN              = 8,   -- 铜币获得总数达到一定数值（总数，不是当前值）
	NOW_GOLD              = 9,   -- 元宝总数达到一定数值
	GET_BINDGOLD          = 10,  -- 绑元获得总数达到一定数值（总数，不是当前值）
	RECHARGE_WEEK         = 11,  -- 充钱周排名
	BAG_SIZE              = 12,  -- 背包格子数达到一定数目
	FRIEND_COUNT          = 13,  -- 拥有好友数达到一定数目
}

tb.TITLE_SCHEDULE_TYPE = {
	TOTOL      = 1,  -- 当前总数
	SUM        = 2,  -- 累加
	TIME_LIMIT = 3,  -- 有时间限制的累加
	MATCH      = 4,  -- 匹配类型
}

-- 日常活跃 日期类型
tb.DAILY_DATE_TYPE = {
	DAILY         = 1,
	WEEKLY        = 2,
	SINGLE_WEEKLY = 3,
	DOUBLE_WEEKLY = 4,
	MONTHLY       = 5,
}

tb.RED_POINT_TYPE = {
	DAILY = 1,
}

-- 日常活跃事件
tb.DAILY_EVENT = {
    TASK_DONE 				= 1, -- 完成任务
    ENTER_SCENE 			= 2, -- 进入场景
    ENTER_COPY 				= 3, -- 进入副本
    ENTER_COPY_TYPE 		= 4, -- 进入副本类型
    CHALLENGECOPY 			= 5, -- 通关副本
    CHALLENGECOPY_TYPE 		= 6, -- 通关副本类型
    SHAKE_MONEY_TREE 		= 7, -- 摇摇钱树
    DAILY_ANSWER 			= 8, -- 每日答题
    EXAMINATION 			= 9, -- 完成科举
    GET_DAILY_TASK_REWARD 	= 10, -- 领取每日任务奖励
    TASK_DONE_TYPE 			= 11, -- 完成某类型任务 对应enum.TASK_TYPE
    ARENA_CHALLENGE 		= 12, -- 挑战竞技场
    ALLIANCE_REPEAT_TASK 	= 13, -- 完成军团重复任务
    ALLIANCE_LEGION_EXP 	= 14, -- 军团领地活动每10s经验奖励
    MAGIC_BOSS_DROP 		= 15, -- 魔域领主boss掉落
    DOUBLE_ESCORT 			= 16, -- 双倍护送
    CARDS_GAME 				= 17, -- 卡牌游戏匹配成功
    DEATHTRAP_EXP 			= 18, -- 魔狱获得十倍经验
    EVERY_DAY_TASK_DONE     = 19, -- 完成每日任务
    GAIN_FREE_STRENGTH      = 20, -- 获取每日免费体力
    ENHANCE_EQUIP           = 21, -- 强化装备
    DRAW_DESTINY            = 22, -- 猎取天命
}

-- 日常刷新周期
tb.DAILY_REFRESH_TYPE = {
	DAILY  = 1,  -- 每天0点刷新
	WEEKLY = 2,  -- 每周一0点刷新
}

-- 爬塔副本各难度状态
tb.COPY_TOWER_STATE = {
	OPEN       = 0,    -- 或nil :  可扫荡  可挑战
	SWEPT      = 1,    -- 扫荡过: 不可扫荡 可挑战
	CHALLENGED = 2,    -- 挑战过: 不可扫荡 不可挑战
}

-- 天机任务状态
tb.DAILY_TASK_STATE = {
	NONE     = 0, -- 无状态 可接         会被刷新
	DOING    = 1, -- 已接 正在做         不会被刷新
	DONE     = 2, -- 已接 已完成 未领奖  刷新时自动领奖并刷新
	REWARDED = 3, -- 已接 已完成 已领奖  会被刷新 三个都已领奖时会自动免费刷新出三个任务
}

-- 官职类型
tb.POSITION_TYPE = {
    CIVIL    = 1, -- 文官
    MILITARY = 2, -- 武官
}

-- 宝图事件
tb.TREASURE_EVENT_TYPE = {
	EQUIP    = 1, -- 装备奖励
	ITEM     = 2, -- 物品奖励
	MONSTER  = 3, -- 刷怪
	NONE     = 4, -- 啥都没
}

-- 任务小类 enum.TASK_SUB_TYPE.DESTINATION 的下级类型
tb.TASK_DESTINATION_TYPE = {
	COLLECT = 1, -- 采集
	ARRIVE  = 2, -- 到达
	-- 
}

-- 鼓励类型
tb.INSPIRE_TYPE = {
	ATTACK  = 1, -- 冲锋
	DEFENSE = 2, -- 固守
	ENERGY  = 3, -- 活力
}

-- 鼓舞属性对应类型
tb.INSPIRE_COMBAT_2_INSPIRE_TYPE = {
	[tb.COMBAT_ATTR.ATTACK   ] = tb.INSPIRE_TYPE.ATTACK,     -- 1 攻击           -- 冲锋
	[tb.COMBAT_ATTR.CRIT     ] = tb.INSPIRE_TYPE.ATTACK,     -- 5 暴击值         -- 冲锋
	[tb.COMBAT_ATTR.THROUGH  ] = tb.INSPIRE_TYPE.ATTACK,     -- 8 穿透值(破防)   -- 冲锋
	[tb.COMBAT_ATTR.HP       ] = tb.INSPIRE_TYPE.DEFENSE,    -- 2 生命值         -- 固守
	[tb.COMBAT_ATTR.PHY_DEF  ] = tb.INSPIRE_TYPE.DEFENSE,	 -- 3 物防           -- 固守
	[tb.COMBAT_ATTR.MAGIC_DEF] = tb.INSPIRE_TYPE.DEFENSE,	 -- 4 法防           -- 固守
	[tb.COMBAT_ATTR.HIT      ] = tb.INSPIRE_TYPE.ENERGY,     -- 6 命中值         -- 活力
	[tb.COMBAT_ATTR.DODGE    ] = tb.INSPIRE_TYPE.ENERGY,     -- 7 闪避值         -- 活力
	[tb.COMBAT_ATTR.CRIT_DEF ] = tb.INSPIRE_TYPE.ENERGY,     -- 9 坚韧值(抗暴值) -- 活力
}

-- 阵营
tb.FACTION_TYPE = {
	NONE     = 0,  -- 无
	STAR     = 1,  -- 星宇
	SUN      = 2,  -- 落阳
}

tb.FACTION_OPER = {
	KILL                        = 1, -- 击杀
	ASSIST                      = 2, -- 助攻
	FIRST_DESTROY_TOWER         = 3, -- 首次摧毁守护之塔
	FIRST_ASSIST_DESTROY_TOWER  = 4, -- 首次助攻摧毁守护之塔
	DESTROY_FLAG                = 5, -- 摧毁战旗
	ASSIST_DESTROY_FLAG         = 6, -- 辅助摧毁战旗
	HANDUP_ENERGY_BEAD_1        = 7, -- 提交能量珠绿色
	HANDUP_ENERGY_BEAD_2        = 8, -- 提交能量珠蓝色
	HANDUP_ENERGY_BEAD_3        = 9, -- 提交能量珠紫色
	FINISH_COLLECT              = 10,-- 完成采集任务
	FINISH_KILL_ASSIT_DEAD      = 11,-- 完成击杀/助攻/死亡任务
	SERIAL_KILL_5               = 12,-- 连破5额外奖励
	SERIAL_KILL_10              = 13,-- 连破10额外奖励
	SERIAL_KILL_20              = 14,-- 连破20额外奖励
	SERIAL_KILL_30              = 15,-- 连破30额外奖励
	SERIAL_KILL_50              = 16,-- 连破50额外奖励
	WINER                       = 17,-- 胜利方
	LOSER                       = 18,-- 失败方
}

-- 领地活动类型
tb.ALLIANCE_LEGION_ACT_TYPE = {
	NEEDFIRE     = 1,     --篝火晚会  
	PARTY        = 2,     --宴会
}

-- 领地活动采集物类型
tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE = {
	CHEST        = 1,     --宝箱
	FOOD         = 2,     --食物
	CHILD        = 3,     --散财童子
	NEEDFIRE     = 4,     --篝火
}

-- 领地活动采集物类型对应的刷怪code 50102304
tb.ALLIANCE_LEGION_COLLECTION_TYPE_TO_REFRESH_CODE = {
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHEST]    = {50102301},
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.FOOD]     = {50102302, 50102305, 50102306},
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHILD]    = {50102303},
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.NEEDFIRE] = {50102304},
}

tb.ALLIANCE_LEGION_COLLECTION_TYPE_TO_ACT_TYPE = {
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHEST]    = tb.ALLIANCE_LEGION_ACT_TYPE.NEEDFIRE,
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.FOOD]     = tb.ALLIANCE_LEGION_ACT_TYPE.PARTY,
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.CHILD]    = tb.ALLIANCE_LEGION_ACT_TYPE.PARTY,
	[tb.ALLIANCE_LEGION_ACT_COLLECTION_TYPE.NEEDFIRE] = tb.ALLIANCE_LEGION_ACT_TYPE.NEEDFIRE,
}

-- 一局牌局的阶段
tb.CARDS_GAME_STATE = {
	NONE     	= 1, 	--待机
	MATCHING 	= 2, 	--匹配中
	CHOOSING 	= 3, 	--选牌中
	BATTLE   	= 4, 	--牌局对战动画
	RESULT   	= 5, 	--结算
	ENEMY_RUN   = 6,    --对方逃跑
}

-- 玩法小副本提示类型
tb.SMALL_GAME_COPY_TIPS_TYPE = {
	ABOVE         = 1,    --在界面上方
	BELOW         = 2,    --在界面下方
	CREATURE_HEAD = 3,    --怪物头顶
}

-- 角色安全锁状态
tb.ROLE_SAFTY_STATE = {
	NONE 		  = 1, 	  --未上锁
	LOCK 		  = 2, 	  --已锁定
	UNLOCK 		  = 3, 	  --已解锁
}

tb.ALLIANCE_STORE_RECORD_TYPE = {
	DONATE 		= 1, 	-- 捐献
	EXCHANGE 	= 2, 	-- 兑换
	DESTORY 	= 3, 	-- 销毁
}

--更名卡种类
tb.CHANGE_NAME_TYPE = {
	PLAYER 	    = 1,  	-- 玩家更名
	ALLIANCE 	= 2, 	-- 军团更名
}
return tb
