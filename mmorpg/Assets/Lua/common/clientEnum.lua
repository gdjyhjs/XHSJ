--[[--
-- 客户端枚举
-- @Author:Seven
-- @DateTime:2017-04-28 16:11:20
--]]

ClientEnum = {}

-- 优先级
ClientEnum.PRIORITY = 
{
	MAIN_UI 				= -1, 		-- 主ui
	TWO 					= 1,
	CHAT 					= 1,
	BAG 					= 2, 		-- 背包
	EQUIP 					= 3, 		--装备
	HERO 					= 4, 		--武将
	HORSE 					= 5, 		-- 坐骑
	TRAIN 					= 6, 		--修炼
	RANK 					= 7,		--排行版
	TEAM 					= 8,		--组队
	ITEM_TIPS 				= 50, 		--物品
	LOADING 				= 200, 		-- 加载界面
	HOT_UPDATE 				= 200, 		-- 热更界面
	GUIDE 					= 201, 		-- 新手引导
	KEYBOARD 				= 300, 		-- 小键盘
	ACHIEVEMENT				= 900,		--成就
	LOADING_MASK 			= 1000, 	-- 等待遮罩
	CCMP 					= 1001, 		-- 二次确认快框
}

--聊天
ClientEnum.CHAT_FUNCTION =
{
	POSITION = 1, 	-- 位置
	RED_PAGE = 2, 	-- 红包
	EMOJI = 4,		-- 表情
	ITEM = 8,		--物品
	HERO = 16,		--武将
}

--聊天类型  1-89是表情
ClientEnum.CHAT_TYPE =
{
	PLAYER = 901, -- 玩家(玩家id)
	PROP = 902, --道具(原型id)
	EQUIP = 903, --装备(guid,归属玩家)
	HERO = 904, --武将(guid,归属玩家)
	POSITION = 905, --位置（地图id,x,y)
	PLAYMSG = 906, -- 播放语音(语音id)
	SPEECH_TO_TEX = 907, -- 音转字(语音id)
	MONSTER = 908, --怪物(怪物名字)monster
	HORSE = 909, --坐骑
	VALUE = 910, --数值
	APPLY_INTO_TEAM = 911, --申请入队
	GIVE_FLOWER = 912 , --赠送鲜花
	FACTION = 913 , --3v3阵营 1：星宇 2：落阳
	APPLY_INTO_ALLIANCE = 914, --申入军团
}
--[[
关于按钮点击
	玩家名 playerInfo,玩家id
	物品 prop,原型id
	装备 equip,guid,玩家id
	播语音 playVoice,频道,录音id

]]

-- guid
ClientEnum.GUID = 
{
	NPC = 90000,
	TRANSPORT = 90100,
}

ClientEnum.BAG_TYPE = 
{
	BAG = 1, --背包
	EQUIP = 2, --装备
	WAREHOUSE = 3, --仓库
} 	 

ClientEnum.MAINUI_SHOW_TYPE = 
{
	NORMAL 	= 1,			--普通模式
	PVP		= 2,			--pvp模式
	STORY 	= 3,			--剧情模式
}

ClientEnum.Layer = 
{
	DEFAULT = 0, -- 默认
	UI = 5, --ui层
	CHARACTER = 8, -- 角色层
	EFFECT = 9, -- 特效层
	UI3DEFFECT = 10, -- ui3d特效层
	XP = 11, 
	FLOOR = 12,
}	

ClientEnum.COPY_TYPE = 
{
	PLOT = 1, -- 剧情副本
	TEAM = 2, -- 组队副本
	ELITE = 3, -- 精英副本
}
ClientEnum.SHOW_TYPE = 
{	
	HERO 	= 1,
	HORSE 	= 2,
}
ClientEnum.SKILL_STATE = 
{
	LOCK = 0, -- 没解锁
	OPEN = 1, -- 解锁
}

--使用方式
ClientEnum.ITEM_USE_TYPE = 
{
	NONE = 0,	--无法使用
	BAG_DIRECT = 1,	--在背包中直接使用
	SPECIFIC = 2,	--特定功能 跳转 
	BATCH = 4,	--可批量使用
	PET = 8,	--宠物使用
}

--UI跳转
ClientEnum.UI_SKIP = 
{
	NONE = 0, 
	PET = 1,		--宠物
	PET_MAP = 2,	--宠物图鉴
	FORMULA = 3,	--打造Formula
	POLISH = 4,		--洗炼Polish
	INLAY_GEM = 5,	--镶嵌宝石InlayGem
	ENHANCE = 6,	--强化Enhance
}

-- 物体状态
ClientEnum.MODEL_STATE =
{
	NONE = 0,
	MOVING = 1, -- 移动中
	NO_TARGET = 2, -- 没有攻击目标
	MOVE_TO_TARGET = 3, -- 移动到攻击目标
	ATK = 5, -- 攻击中
	EXC = 6, -- 异常
}
--护送刷新品质
ClientEnum.HUSONG_TYPE=
{
	ONCE =0,--刷新一次
	ONE_KEY=1,--一键刷新
}

--主界面按钮
ClientEnum.MAIN_UI_BTN=
{
	SIGN = 1, --福利
	BAG = 2, --背包
	COPY = 3, --副本
	WELFARE = 4, --商城
	BOSS = 5, --BOSS
	FESTIVAL = 6, --节日活动
	ACTIVITY = 7, --日常活动
	ESCOR = 8, --双倍护送
	MARK = 9, --市场
	RANK = 10, --排行
	MAIL = 11, --社交
	MAKE = 12, --打造
	PARTNER = 13, --设置
	MOUNT = 14, --坐骑
	COURTYARD = 15, --外观
	FAMILY = 16, --军团
	SWITCH = 17, --切换面板的按钮
	SPRIVATE_CHAT = 18, --私聊按钮
	LEAVE = 19, -- 离开场景
	VIP=20,--vip
	AUTO_ATK = 21, -- 挂机
	TOWER = 22, -- 爬塔仓库未领提示
	TeamMain = 23, -- 组队
	HERO = 24, --武将伙伴
	NEW_EMAIL= 25, --新邮件
	NEW_FRIEND= 26, --新好友申请
	SIT =27,--打坐
	LOGIN =28,--15天登录
	FIRSTTIME =29,--首充
	WARPVP =30,-- pvp
	LUCKY_DRAW =31,--秘境寻宝
	BATTLE_GROUND = 32,--战场
	STRENGTHEN = 33,--变强
	DEFENSE = 34, --魔族围城
	ACHIEVEMENR = 35, -- 成就
	USE_TREASURE = 36, -- 自动寻宝中
	ACTIVITY_SERVER = 37,	--开服活动
	CARD = 38,  		--卡牌
	HEAD = 39,    		--人物信息
	ASTROLABE = 40,		--星盘
	BONFIRE = 41,		--篝火
	BANQUET = 42,		--宴会
}
--指引方向
ClientEnum.GUIDE_DIRECTION=
{
	LEFT=1,
	RIGHT=2,
}

-- 获取职业名字
ClientEnum.JOB_NAME = 
{
	[ServerEnum.CAREER.SOLDER] = gf_localize_string("修罗"),
   	[ServerEnum.CAREER.MAGIC] = gf_localize_string("阎姬"),
    [ServerEnum.CAREER.BOWMAN] = gf_localize_string("夜狩"),
}

--军团职位
ClientEnum.LEGION_TITLE_NAME = 
{
	[ServerEnum.ALLIANCE_TITLE.LEADER] = gf_localize_string("统帅"),
	[ServerEnum.ALLIANCE_TITLE.VICE_LEADER] = gf_localize_string("副统帅"),
	[ServerEnum.ALLIANCE_TITLE.STRATEGIST] = gf_localize_string("军师"),
	[ServerEnum.ALLIANCE_TITLE.ADVISER] = gf_localize_string("谋士"),
	[ServerEnum.ALLIANCE_TITLE.PIONEER] = gf_localize_string("先锋"),
	[ServerEnum.ALLIANCE_TITLE.MEMBER] = gf_localize_string("成员"),
}

ClientEnum.ERR_CODE_TYPE = 
{
	FLOAT = 0, -- 飘字
	BOX   = 1, -- 弹框
	NOT_SHOW = 2, --不显示
	SHOW_LOGIN = 3, -- 回到登录界面弹框
}
--称号类型
ClientEnum.TITLE_TYPE = 
{
	VIP = 1,
	RANKING = 2, --排名称号
	ACHIEVEMENT = 3,--成就称号
	ACTIVITY = 4, --活动称号
	CUT_WILL = 5, --斩将称号
	SELF = 6, --总览
}

--称号显示类型
ClientEnum.TITLE_SHOW_TYPE = 
{
	TEXT = 1,--文本称号
	STATIC =2,--静态称号
	DYNAMIC = 3,--动态称号
}

ClientEnum.SKILL_POS = 
{
	ONE    = ServerEnum.SKILL_POS.ONE,    -- 技能1
	TWO    = ServerEnum.SKILL_POS.TWO,    -- 技能2
	THREE  = ServerEnum.SKILL_POS.THREE,    -- 技能3
	FOUR   = ServerEnum.SKILL_POS.FOUR,    -- 技能4
	XP     = ServerEnum.SKILL_POS.XP,    -- xp技能
	NORMAL_1 = ServerEnum.SKILL_POS.NORMAL_1,    -- 技能5
	NORMAL_2 = ServerEnum.SKILL_POS.NORMAL_2,    -- 技能5
	NORMAL_3 = ServerEnum.SKILL_POS.NORMAL_3,    -- 技能5
}
--日常活跃完成
ClientEnum.DAILY_NAME = 
{
	MONEYOFTREE = 1,--摇钱树
}
--商品类别
ClientEnum.SHOP_TYPE = 
{
	NAME_CHANGE_CARD = 3,--改名卡
	GIFT = 5   --礼物
}

ClientEnum.EMOJI_TYPE = {
	POSITION = 1,	--位置
	RED_PAGE = 2,	--红包
	EMOJI = 4,		--表情
	ITEM = 8,		--物品
	HERO = 16,		--武将
}

-- 每个职业的拥有的技能id
ClientEnum.SKILL_ID_LIST = 
{
	[ServerEnum.CAREER.SOLDER] = {11401001, 11402001, 11403001, 11404001, 11405001, 11406001, 11406002, 11406003},
	[ServerEnum.CAREER.MAGIC]  = {11101001, 11102001, 11103001, 11104001, 11105001, 11106001, 11106002, 11106003},
	[ServerEnum.CAREER.BOWMAN] = {11201001, 11202001, 11203001, 11204001, 11205001, 11206001, 11206002, 11206003},
}

-- 通用模型对应的枚举
ClientEnum.NORMAL_MODEL = 
{
	TARGET_SELECT = 1, -- 敌方选中特效
	FRIEND_SELECT = 2, -- 友方选中特效
}

-- 模型身上特效下标
ClientEnum.EFFECT_INDEX = 
{
	SELECT        = 1, -- 选中特效
	FLOWER        = 2, -- 送花特效
	TRANSPORT     = 3, -- 传送
	UPLEVEL		  = 4,-- 升级
	COLLECT       = 5, -- 挖宝采集特效
}

-- npc 事件
ClientEnum.NPC_EVNET = 
{
	LEVEL          = 1,         -- 等级
	TASK_AVAILABLE = 2,         -- 可接
	TASK_PROGRESS  = 3,         -- 进行中
	TASK_COMPLETE  = 4,         -- 完成
}

-- npc 内容触发事件
ClientEnum.NPC_CONTENT_TY = 
{
	TOUCH = 0,				--是否触发
	COPY = 1,               -- 副本
	TASK = 2,               -- 任务
	MAP  = 3,               -- 传送到某张地图
	HUSONG = 4,             -- 打开护送界面
	FACTION = 5,            -- 提交采集珠给军需官
}

ClientEnum.SET_GM_COLOR =
{
	NAME_OWN = 1,				--玩家姓名	
	NAME_ENEMY = 2,				--敌方/怪物姓名
	NAME_HERO = 3,				--武将姓名
	NAME_NPC = 4,				--NPC姓名
	NAME_BOSS = 5,				--boss姓名
	NAME_LEGION = 6,			--军团职业
	NAME_NPC_TITLE = 7,			--NPC身份
	MAIN_COMMON = 8,			--主界面通用文字
	FIGHT_VALUE	= 9,			--主界面战力
	INTERFACE_SELECT = 10,		--界面选中
	INTERFACE_UNSELECT = 11,	--界面非选中
 	INTERFACE_WHITE=12,			--界面品质颜色白
	INTERFACE_GREEN=13,			--界面品质颜色绿
	INTERFACE_BLUE=14,			--界面品质颜色蓝
	INTERFACE_PURPLE=15,		--界面品质颜色紫
	INTERFACE_GOLD=16,			--界面品质颜色金
	INTERFACE_ORANGE=17,		--界面品质颜色橙色
	INTERFACE_RED=18,			--界面品质颜色红
	TIPS_WHITE=19,				--tips品质颜色白
	TIPS_GREEN=20,				--tips品质颜色绿
	TIPS_BLUE=21,				--tips品质颜色蓝
	TIPS_PURPLE=22,				--tips品质颜色紫
	TIPS_GOLD=23,				--tips品质颜色金
	TIPS_ORANGE=24,				--tips品质颜色橙
	TIPS_RED=25,				--tips品质颜色红
	DAY_LIFT1=26,				--天命1
	DAY_LIFT2=27,				--天命2
	DAY_LIFT3=28,				--天命3
	DAY_LIFT4=29,				--天命4
	DAY_LIFT5=30,				--天命5
	DAY_LIFT6=31,				--天命6
	GM_INTERFACE_ADD=32,		--通用界面颜色属性加
	GM_INTERFACE_DOWN=33,		--通用界面颜色属性减
	INTERFACE_CONDITION=34,		--界面条件、状态
	VALUE_ADD=35,				--结算界面数值增
	VALUE_DOWN=36,				--结算界面数值减
	MAINUI_CHAT_PAGE_SYS=37,	--主界面聊天系统标签
	MAINUI_CHAT_PAGE_LEGION=38,	--主界面聊天军团标签
	MAINUI_CHAT_PAGE_TEAM=39,	--主界面聊天队伍标签
	MAINUI_CHAT_PAGE_WORLD=40,	--主界面聊天世界标签
	MAINUI_CHAT_NAME=41,		--主界面聊天玩家名
	MAINUI_PLAYER_CHAT=42,		--主界面玩家发言文字
	MAINUI_SYS_CHAT=43,			--主界面系统广播文字
	OUT_LINE=44,				--玩家不在线 头像
	
}

--特效红点枚举
ClientEnum.Copy_Box_Effect 		= 1


--功能模块跳转
ClientEnum.MODULE_TYPE = {
	KRYPTON_GOLD = 1, -- 氪金 充钱 充值
	PVP = 2, -- 风云竞技场
    ACTIVE_DAILY = 3, -- 日常活跃
    SMELTING = 4, -- 熔炼
    MONEY_TREE = 5, -- 摇钱树
    MALL = 6, -- 商城
    TEAM = 7, -- 队伍
    LEGION = 8, -- 军团
    PLAYER_INFO = 9, -- 玩家信息
    EQUIP = 10, -- 装备强化
    HORSE = 11, -- 坐骑
    HERO = 12, -- 武将
    PUBLIC_CHAT = 13, -- 公共聊天
    PRIVATE_CHAT = 14, -- 私聊
    SURFACE = 15, -- 外观 surface
    MARKET = 16, -- 市场
    VIP = 17, -- VIP
}
--功能属性枚举
ClientEnum.MODULE_ATTR = {
	ROLE_LEVEL = 1, -- 人物等级
	EQUIP_ENHANCE_LEVEL = 2, -- 装备强化等级
	HORSE_LEVEL = 3, -- 坐骑进阶等阶
	SKILL_LEVEL = 4, -- 技能等级
	PRACTICE_LEVEL = 5, -- 军团修炼等级
	CURR_HERO_LEVEL = 6, -- 当前出战武将等级
	SURFACE_UNLOCK = 7, -- 外观id是否解锁 ==1 已解锁	==0 未解锁 Surface:is_unlock
	BODY_EQUIP_LEVEL = 8, -- 身上装备的等级
	MODEL_UNLOCK = 9, -- 模块解锁
	


	-- HORSE_LEVEL_UP_EXP = 4, -- 坐骑进阶所需经验
	-- PRACTICE_LEVEL_UP_COIN = 6, -- 军团修炼升级所需铜钱
	-- PRACTICE_LEVEL_UP_DONATE = 7, -- 军团修炼升级所需贡献
	-- CURR_HERO_LEVEL_UP_EXP = 9, -- 当前出战武将升级所需经验
	-- CURR_HERO_AWAKEN = 10, -- 当前出战武将觉醒
	-- CURR_HERO_CHIP = 11, -- 获取当前出战的武将碎片数量（包括已经消耗用于觉醒的）
	-- HERO_EXP_PROP_VALUE = 101, -- 拥有武将经验道具总经验值
}

ClientEnum.SOUND_KEY = {
	COMMON_BTN = 1, -- 【通用按钮】全游戏通用的按钮点击音效，非特殊说明的均用该音效
	CLOSE_BTN = 2, -- 【关闭按钮】全游戏通用的关闭按钮音效，取消、X、关闭等字眼的音效
	BUY_BTN = 3, -- 【购买按钮】全游戏通用的购买、充值按钮音效
	SWITCH_MAINUI_TASK_BASE_BTN = 4, -- 【切换按钮】主界面任务/队伍/打坐界面的切换页签音效
	SWITCH_ROLE_BTN = 5, -- 【切换按钮】创建角色界面，切换角色按钮音效
	SWITCH_PAGE_ONE_BTN = 6, -- 【切换按钮】切换一级页签
	SWITCH_PAGE_TWO_BTN = 7, -- 【切换按钮】切换二级页签
	SWITCH_PAGE_THREE_BTN = 8, -- 【切换按钮】切换三级页签
	INTO_COPY_BTN = 9, -- 【进入按钮】挑战/进入副本等进入副本的按钮音效
	LEVEL_UP = 10, -- 【升级】角色、坐骑、武将升级时播放的音效
	CHANGE_EQUIP = 11, -- 【装备】更换装备时播放的音效
	USE_PROP = 12, -- 【道具】使用血瓶时播放的音效
	UNLOCK = 13, -- 【解锁】技能、武将伙伴库、背包仓库等解锁时播放的音效
	NEW_MESSAGE = 14, -- 【新消息图标】友/聊/修/队/团等出现提示音效
	GET_ITEMS = 15, -- 【获得】获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
	SIT = 16, -- 【打坐】下滑打坐或取消打坐时播放的音效
	MOUNTS = 17, -- 【上坐骑】上滑上坐骑或在坐骑界面点击骑乘上坐骑的时候播放的音效，取消坐骑同理
	PROCESS = 18, -- 【合成】背包-合成、副本-过关斩将-圣物强化、锻造-镶嵌播放的音效
	MACHINING = 19, -- 【锻造】锻造界面-强化/洗炼/打造
	READLINE_EVENT = 20, -- 【事件】传送/采集/钓鱼等等读条事件的音效
	DROP_ITEMS = 21, -- 【掉落】怪物死亡掉落奖励时的音效
	GET_PARTNER = 22, -- 【获得2】获得坐骑、武将时的专用音效
	SORT_BAG = 23, -- 【整理】整理背包时播放的音效
	GET_TASK = 24, -- 【领取任务】领取任务时播放的音效
	FINISH_TASK = 25, -- 【完成任务】完成任务时播放的音效
	ROLE_SHOW_1 = 26, -- 法师 选择角色入场声效
	ROLE_SHOW_2 = 27, -- 弓手 选择角色入场声效
	ROLE_SHOW_4 = 28, -- 战士 选择角色入场声效
	HUNT_DESTINY = 38, -- 抽取天命
}

--坐骑一级界面
ClientEnum.HORSE_VIEW = 
{
	MAIN 	=1, 		--主界面
	FEED 	=2,			--喂养界面
	MAGIC 	=3,			--幻化界面
}
--坐骑二级界面
ClientEnum.HORSE_SUB_VIEW = 
{
	NORMAL 		=1, 	--普通幻化
	SPECIAL 	=2,		--特殊幻化
	SOUL 		=3,		--注灵
	ITEM_FEED   =4,		--道具喂养
	EQUIP_FEED  = 5	,	--装备喂养
}
--武将一级界面
ClientEnum.HERO_VIEW = 
{
	BATTLE 	=1, 				--出战
	LIST 	=2,					--图鉴
	FRONT 	=3,					--布阵
}

--武将二级界面
ClientEnum.HERO_SUB_VIEW = 
{
	TALENTGROUP 	=1, 				--天资增加
	HEROWASH 		=2,					--洗练
	HEROAWAKEN 		=3,					--觉醒
	HEROEQUIP 		=4,					--装备
	HEROREBORN 		=5,					--重生
	HEROEXP 		=6,					--经验
}

--军团一级界面
ClientEnum.LEGION_VIEW = 
{
	INFO 		=1, 				--信息
	GIFT 		=2,					--福利
	ACTIVEITY 	=3,					--活动
	MEMBER	 	=4,					--成员

}
ClientEnum.LEGION_SUB_VIEW = 
{
	TRAIN 		=1, 				--修炼
	FLAG 		=2,					--战旗
	NEEDFIRE 		=3,					--篝火
	PART 		=4,					--宴会
	BOSS 		=5,					--兽神
}
--新手功能枚举
ClientEnum.FUNC_BIG_STEP =
{
	HERO = 4, --武将
	MOUNT = 5,--坐骑
}
--游戏设置
ClientEnum.SETTING = 
{
	DISPLAY_NUMBER = 1, 			--同屏幕显示人数
	WORLD_CHAT = 2,					--世界语音
	LEGION_CHAT = 3, 				--军团语音
	TEAM_CHAT  = 4, 				--团队语音
	SHIELD_OTHER_PLAYER = 5, 		--屏蔽他人
	SHIELD_MONSTER = 6,  			--屏蔽怪物
	SHIELD_OTHER_EFFECTS  = 7, 		--屏蔽他人特效
	SHIELD_OTHER_HERO = 8, 			--屏蔽他人武将
	SHIELD_TITLE  = 9, 				--屏蔽称号
	SHAKE_OFF = 10,					--关闭震动
	REVIVE = 11, 					--自动原地恢复
	AUTO_ATK = 12, 					--武将自动攻击
	FOLLOW = 13,					--自动跟随
	TAKE_MEDICINE = 14,				--自动吃药百分比
	MESSAGE_PUSH = 15,				--推送
}
--推送通知
ClientEnum.MESSAGEPUSH =
{
	HPFULL = 1,						--体力回满
	RVR = 2,						--逐鹿战场
	BONFIRE = 3,					--军团篝火
	DOUBLEHUSONG = 4,				--双倍护送
	INPRIVATECHAT = 5,				--好友私聊
	GETVP = 6,						--体力领取
	FIRE3V3 = 7,					--烽火3v3
	BANQUET = 8,					--军团宴会
	SIEGE = 9,						--怪物攻城
}

-- tips CONTENT 显示tips特定情况下需要出现的内容
ClientEnum.ITEM_TIPS_CONTENT =
{
	DEPOT_SCORE = 1, -- 仓库积分
}

ClientEnum.ACTIVITY_SERVER = {
	LOGIN = 1,
	RANK = 2,
	EXCHANGE = 3,
	TASK = 4,
	WHEEL = 5,
}

ClientEnum.LeftPanelType = 
{
	Task  					= 1,		--任务
	Copy 					= 2,		--副本
	Sit 					= 3,		--打坐
	LegionBonFire 			= 4,		--篝火
	Zork 					= 5,		--魔域
	Boss 					= 6,		--boss
	Husong 					= 7,		--护送
	Rvr 					= 8,		--战场
	MeterialCopy 			= 9,		--材料副本
	MagicBoss 				= 10,		--魔域boss
	TeamCopy 				= 11,		--组队副本
	SmallGame 				= 12,		--小游戏副本
	Team 					= 13,		--组队
}

ClientEnum.CENTER_MAP_SHOW_TYPE = 
{
	NODE 					= 0,		--不显示
	MAP  					= 1,		--显示在地图
	LIST 					= 2,		--显示在右侧列表
}
ClientEnum.GUIDE_BIG_STEP = 
{
	AUTO_ATK				= 3,
	HERO 					= 4,
	HORSE 					= 5,
}
ClientEnum.GUIDE_FEEBLE = 
{
	ADD_MY_TIME 			= 1001,	--添加魔域时间
	ADD_MY_HARM 			= 1002,	--添加魔域鼓舞伤害
	ADD_MY_EXP_MEDICINE 	= 1003,	--添加魔域经验药
	TASK_100001_3			= 1004, --提交任务
	TASK_100002_1			= 1005, --提交任务
	TASK_100002_3			= 1006, --提交任务
}

ClientEnum.DAILY_ACTIVE = 
{
	PVP  					=1005,--竞技场
	BONFIRE                 =2004,--篝火
	BANQUET                 =2005,--宴会
}