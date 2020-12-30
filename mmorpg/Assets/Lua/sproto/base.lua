--基本协议

local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[
#登陆游戏服
.Login
{
	roleId 0 : integer		#角色id
	token 1 : string		#验证串
	time 2 : integer		#时间戳
	deviceId 3 : string 	#设备id
	version 4 : string		#前端的版本号
	pkgName 5 : string 		#客户端包名 
	type 6 : integer        #0为正常登陆，1为断线重连
	reloginToken 7 : string #断线重连附带的token
}

.Role
{
	roleId 0 : integer
	name           1 : string
	head           2 : string
	level          3 : integer
	baseRes        4 : *integer     #资源
	career         5 : integer      #职业, 对应enum.CAREER
	power          6 : integer   	#战斗力
	pkMode         7 : integer      #战斗模式, 对应enum.PK_MODE
	curHp          8 : integer      #当前血量
	combatAttr     9 : *integer     #战斗属性, 对应enum.COMBAT_ATTR(CLIENT_END之前的属性，后面的不需要读取)
	createTime    10 : integer	    #创号时间
	serverId      11 : integer	    #服务器id
	dayOnlineTm   12 : integer      #当日在线时间
	onlineTm      13 : integer 	    #在线总时长
	mapId         14 : integer      #地图id
	posX          15 : integer      #x坐标
	posY          16 : integer      #y坐标
	allianceId    17 : integer      #军团id
	copyEnterTime 18 : integer      #进入副本的时刻(0为第一次进入)
	copyCode      19 : integer      #副本原型id
	title         20 : integer      #称号
	funcIds       21 : *integer     #已经开启过的功能id
	guideId       22 : integer      #正在进行中的指引id(暂时可以不管它)
	teamId        23 : integer      #队伍id
	vipLevel      24 : integer      #vip等级
	immedHpTime   25 : integer      #可使用瞬补药的时间轴
	immedProtoId  26 : integer      #设置瞬补药的protoId
	intimacy      27 : integer      #亲密度
}

#他人的
.OtherRole
{
	roleId 0 : integer
	name 1 : string
	head 2 : string
	level 3 : integer
	career 4 : integer           # 职业, 对应enum.CAREER
	power 5 : integer            # 战斗力
	curHp 6 : integer            # 当前血量
	combatAttr 7 : *integer      # 战斗属性, 对应enum.COMBAT_ATTR(END之前的属性，后面的不需要读取)
	serverId 8 : integer         # 服务器id
	mapId 9 : integer            # 地图id
	posX 10 : integer            # x坐标
	posY 11 : integer            # y坐标
	allianceId 12 : integer      # 军团id
	title 13 : integer           # 称号
	teamId 14 : integer          # 队伍id
	vipLevel 15 : integer        # vip等级
	intimacy 16 : integer        # 亲密度
	wearSurfaceIds 17 : *integer # 穿上的外观
	weaponProtoId 18 : integer   # 武器原型id
	helmetProtoId 19 : integer   # 铠甲原型id
	allianceName 20 : string     # 军团名
}

#登陆返回信息
.LoginR
{
	err 0 : integer			#错误码
	role 1 : Role 			#角色信息,当err为0的时候才有
	time 2 : integer		#时间戳
	version 3 : string		#后端的版本号
	pkgUrl 4 : string		#新包rul
	serverStartTm 5 : integer #开服务时间
	reloginToken 6 : string #断线重连附带的token
}

#设置快键补血药物品
.SetImmedAddHPItem
{
	protoId 0 : integer    #设置的物品id
}
.SetImmedAddHPItemR
{
	protoId 0 : integer    #设置的物品id
}

#心跳包，每30s发一次
.Ping
{
	time 0 : integer		#时间戳
}
.PingR
{
	time 0 : integer		#时间戳
}


#客户端主动请求战斗信息
.UpdateCombat
{
	
} 
#服务端主动推送更新
.UpdateCombatR
{
	combatAttr 0 : *integer  #战斗属性, 对应enum.COMBAT_ATTR(END之前的属性，后面的不需要读取)
}

#客户端主动请求资源信息
.UpdateRes
{
	
} 
#服务端主动推送更新，每隔10分钟，或者数量减少了
.UpdateResR
{
	baseRes 0 : *integer		#金币和资源
}

#-----------------------体力相关begin-------------------------
#体力剩余购买次数
.StrengthLeftBuyTimes
{
}

.StrengthLeftBuyTimesR
{
	leftBuyTimes 0 : integer
}

#购买体力
.BuyStrength
{
}

.BuyStrengthR
{
	err 0 : integer  
}

#重置购买体力次数
.ResetStrengthBuy
{
}

.ResetStrengthBuyR
{
	err 0 : integer
}

#----------------------体力相关end-------------------------

# 添加资源测试
.Debug
{
	cmd 0 : string  	#hotfix, addRes, addVp, deductVp, addHero, addBag, addChip,formulaEquip,onLineTest,openAllFunc
	type 1 : integer 	#具体类型
	value  2 : integer  #数量
	str 3 : string 		#字符串参数
}

# 资源添加返回
.DebugR
{
	err 0 : integer		# 0-成功,其他为错误码
}

#更新等级
.UpdateLvlR
{
	level 0 : integer
	exp 1 : integer #增加等级后还剩下的经验
}

#更新经验值
.UpdateExpR
{
	exp 0 : integer		
}

#更新战力
.UpdatePowerR
{
	power 0 : integer		
}

#查看其他玩家信息
.OtherPlayerInfo
{
	guid 0 : integer
}

.OtherPlayerInfoR
{
	err 0 : integer   #错误码
	info 1 : OtherRole
}


#聊天带的玩家信息
.RoleInfo
{
	roleId 0 : integer
	name 1 : string
	level 2 : integer
	head 3 : string           # 头像信息
	vipLevel 4 : integer      # vip等级
	allianceName 5 : string   # 联盟名
	power 6 : integer         # 战斗力
}

#聊天(服务器不会直接回复)
.Chat
{
	channel 0 : integer		#频道
	content 1 : string 		#内容
}

#系统广播也会主推这条协议
.ChatR
{
	channel 0 : integer		#频道，1国家，2联盟, 10以上是系统广播
	content 1 : string 		#内容
	roleInfo 2 : RoleInfo   #channel 10以下才会有
	chatTime 3 : integer 	#发送时间
	chatId 4 : integer 		#聊天消息id
	code 5 : integer		#内容对应的code 
	args 6 : *string 		#内容参数
	surfaceTalkBg 7 : integer #穿上去的气泡外观id
}


# 玩家刚进入游戏客户端发送请求聊天历史记录,客户端需要保证在已经接收完成队伍和军团信息之后才请求此协议
# 此外需注意有可能此协议在返回之前就已经接收到其它聊天推送了，请根据chatTime排序
.GetHistoryChat
{
}

.GetHistoryChatR
{
	list 0 : *ChatR 	#聊天记录
}

#改名
.Rename
{
	name 0 : string			#新名字
}

.RenameR
{
	err 0 : integer			#错误码
	name 1 : string			#新名字
}

#改头像
.ReHead
{
	head 0 : string 		#头像信息
}
.ReHeadR
{
	err 0 : integer			#错误码
	head 1 : string 		#头像信息
}

#服务端主动推错误码
.ErrorR
{
	err 0 : integer			#错误码
}

#服务端主推飘字
.PopUpMessageR
{
	message 0 : string    #飘字
}

#通知已到隔天
.OnNewDayR
{
	time 0 : integer		#时间戳
}


#功能系统广播
.BroadcastR
{
	code 0 : integer		#内容对应的code
	args 1 : *string 		#内容参数
}

#充值项
.RechargeItem
{
	code 0 : integer		#对应配置内容
	goodsId 1 : string		#平台计费点
	money 2 : *integer		#充值多少
	gold 3 : integer		#得到多少金币
	extra 4 : integer		#首充额外送
	displayname 5 : string  
}

#取充值计费点
.GetRecharge
{

}
.GetRechargeR
{
	itemList 0 : *RechargeItem	#充值项列表
	codeList 1 : *integer		#已经充值过的code
}

#生成定单
.CreateOrder
{
	code 0 : integer		#对应配置内容
}
.CreateOrderR
{
	err 0 : integer			#错误码
	goodsId 1 : string		#平台计费点
	orderId 2 : string		#生成的订单id(秀传参数)
}

#定单充值失败
.RechargeFailed
{
	orderId 0 : string		#生成的订单id(秀传参数)
}
.RechargeFailedR
{
	err 0 : integer			#错误码
}

#资源/道具项
.RewardItem
{
	code 0 : integer		#资源或道具、宝石..(根据范围判断)
	num 1 : integer			#数量
}

#兑换码，得到的奖励
.RedeemRewardR
{
	list 0 : *RewardItem	#兑换内容
}

#推送多件物品
.UpdateTipsItemR
{
	itemList 0 : *RewardItem 	#多件物品
	tipsType 1 : integer 	#操作类型,enum-TIPS_TYPE
}

#服务器信息
.AreaInfo
{
	area 0 : integer		#area id
	status 1 : integer		#状态对应 SERVER_STATUS
}

#取服务器列表
.GetAreaList
{

}
.GetAreaListR
{
	err 0 : integer			#错误码
	list 1 : *AreaInfo		#服务器信息列表
}

#邦定账号
.BondingAccount
{
	account 0 : string		#账号
	password 1 : string		#密码
}
.BondingAccountR
{
	err 0 : integer			#错误码
}



#更新玩家操作的步骤(没有返回)
.UpdateStage
{
	stage 0 : integer	#状态码
}

#重新玩游戏
.NewGame
{
	
}
.NewGameR
{
	err 0 : integer		#错误码
}

#玩家反馈
.Feedback
{
	content 0 : string		#内容
}
.FeedbackR
{
	err 0 : integer			#错误码
}

#合成
.Compose
{
	code 0 : integer		#需要合成的code
	num 1 : integer			#合成数量
}
.ComposeR
{
	err 0 : integer			#错误码
}

#更新计时器
.UpdateTimer
{
	timer 0 : *integer			#最后一次回复的时间[体力,精力]
}


#开启功能
.OpenFunc
{
	funcId 0 : integer  		#功能id
}
.OpenFuncR
{
	err 0 : integer
	funcId 1 : integer  		#功能id
}

#设置新手步骤 
.SetNewerStep
{
	step 0 : integer
}
.SetNewerStepR
{
}
#获取新手步骤
.GetNewerStep
{
}
.GetNewerStepR
{
	step 0 : integer
}

#充值情况
.RechargeData
{
}
.RechargeDataR
{
	monthCardEnd 0 : integer		#月卡结束时间 默认为0
	monthCardState 1: boolean 		#月卡领取情况 默认false不可领取
	permanentCardState 2: boolean 	#永久卡领取情况 默认false不可领取
	codeList 3: *integer 			#开放的充值列表跟充值情况
	codeRecord 4: *integer			#充值历史记录
}

#领取各种充值卡 月卡/永久卡
.GetCardReward
{
	cardId 0 : integer			#充值卡ID
}
.GetCardRewardR
{
	err 0 : integer				
}

#---------------------排行榜相关begin----------------------------
#排行榜单项信息
.RankInfo
{
	roleId 0 : integer		# 
	name 1 : string			# 名称
	alliName 2 : string		# 军团
	level 3 : integer		# 等级
	power 4 : integer		# 战力
	donation 5 : integer    # 个人贡献
	head 6 : string        # 头像
	rightTimes 7 : integer  # 每日答题正确次数
	costTime 8 : integer    # 每日答题消耗时间
	vipLevel 9 : integer    # vip等级
	career 10 : integer     # 职业
	horse 11 : HorseInfo    # 坐骑信息(坐骑排行)
	hero 12 : HeroInfo      # 武将信息(武将排行)
	floor 13 : integer      # 爬塔层数(爬塔排行)

	.HorseInfo
	{
		horseCode 0 : integer  #坐骑code
		horseLevel 1 : integer #坐骑等级
	} 

	.HeroInfo
	{
		heroName 0 : string  #武将名字
		heroPower 1 : integer #武将战力
		heroLevel 2 : integer #武将等级
	}
}

#取排行榜信息（最多排50）
.GetRankInfo
{
	type 0 : integer		# 排行榜类型 对应RANKING_TYPE
	page 1 : integer		# 页数
}
.GetRankInfoR
{
	type 0 : integer		# 排行榜类型
	page 1 : integer        # 页数
	list 2 : *RankInfo 		# 内容
	myRank 3 : integer		# 我的排名
	myInfo 4 : RankInfo     # 我的信息
}

#军团排行榜信息
.AllianceRankInfo
{
	id 0 : integer			# 公司id
	name 1 : string			# 公司名称
	leaderName 2 : string	# 团长名字
	fund 3 : integer        # 资金
	level 4 : integer       # 军团等级
	flag 5 : integer        # 军旗颜色
	word 6 : string         # 军旗字
}

#取公司排行榜信息
.GetAllianceRank
{
	type 0 : integer        # 排行榜类型
	page 1 : integer		# 页数
}

.GetAllianceRankR
{
	page 0 : integer		# 页数
	type 1 : integer        # 类型
	list 2 : *AllianceRankInfo 	# 内容
	myRank 3 : integer      # 自己军团的排名
	myInfo 4 : AllianceRankInfo #自己军团信息
}

#战场排行(逐鹿，3v3)
.FactionInfo
{
	roleId 0 : integer  
	name 1 : string
	head 2 : string
	power 3 : integer
	score 4 : integer
	honor 5 : integer #荣誉
}

#请求战场排行
.GetFactionRank
{
	type 0 : integer #排行榜类型
	page 1 : integer
}

.GetFactionRankR
{
	page 0 : integer
	type 1 : integer
	list 2 : *FactionInfo
	myRank 3 : integer
}

#------------------------------排行榜相关end---------------------------

#-----------------------------官职相关begin------------------------------------

#前端主动获取官职信息
.GetOfficeInfo
{
}
.GetOfficeInfoR
{
	position      0 : *integer #[1] = 文官官职code    , [2] = 武官官职code
	rewardedToday 1 : *boolean #[1] = 文官俸禄是否已领, [2] = 武官俸禄是否已领
}

#后端设置官职主动推送
.UpdateOfficeInfoR
{
	position 0 : *integer #[1] = 文官官职code, [2] = 武官官职code
}

#前端获取俸禄
.GetOfficeReward
{
	positionType 0 : integer # 1-文官俸禄 2-武官俸禄
}
.GetOfficeRewardR
{
	err 0 : integer #0-成功，其他为错误码
}

#-----------------------------官职相关end------------------------------------

#----------------------------首充相关begin-----------------------------------
#获取首充奖励信息列表
.GetFirstRechargeRewardList
{	
}
.GetFirstRechargeRewardListR
{
	firstRechargeGiftMask  0 : integer   #已经领过的礼包(二进制式)
	todayDay               1 : integer   #今天是第几天
}

#获取首充奖励
.GetFirstRechargeReward
{
	day         0 : integer     #天数
}
.GetFirstRechargeRewardR
{
	err         0 : integer     #0-成功,其他为错误码
	day         1 : integer     #领取成功的话返回所领奖励是第几天的
}

#-----------------------------首充相关end------------------------------------

#----------------------------等级礼包begin-----------------------------------
#等级礼包信息
.LevelGiftInfo
{
	level       0 : integer     #礼包需求的等级
	isRewarded  1 : integer     #是否已经领了 1-已领
	restCount   2 : integer     #剩余个数
}

#获取等级礼包信息列表
.GetLevelGiftList
{	
}
.GetLevelGiftListR
{
	levelGiftInfo 0 : *LevelGiftInfo  #首充奖励信息
}

#获取等级礼包奖励
.GetLevelGift
{
	level       0 : integer     #礼包需求的等级
}
.GetLevelGiftR
{
	err         0 : integer     #0-成功,其他为错误码
	level       1 : integer     #领取时数量不足或领取成功的话返回所领礼包的等级
	restCount 	2 : integer 	#领取时数量不足或领取成功后返回当前等级礼包剩余数量
}

#-----------------------------等级礼包end------------------------------------

#--------------------------15天登录奖励begin---------------------------------
#奖励信息
.GiftInfo
{
	day      0 : integer     #天数
	state    1 : integer     #状态 0-可领 1-已领
}

#15天登录奖励信息列表
.GetLoginGiftList
{	
}
.GetLoginGiftListR
{
	loginGiftInfo 0 : *GiftInfo  #首充奖励信息 不可领的天数直接缺省
}

#获取15天登录奖励
.GetLoginGift
{
	day         0 : integer     #天数
}
.GetLoginGiftR
{
	err         0 : integer     #0-成功,其他为错误码
	day         1 : integer     #领取成功的话返回所领奖励是第几天的
}

#---------------------------15天登录奖励end----------------------------------

#----------------------------秘境寻宝begin-----------------------------------
#奖励信息
.Item
{
	code      0 : integer     #物品编号
	num       1 : integer     #物品数量
}

#稀有奖励广播信息
.BroadcastInfo
{
	roleId 			   0 : integer 			#获奖者id
	name			   1 : string  			#获奖者名称
	code			   2 : integer 			#物品code
	num				   3 : integer 			#物品数量
	broadcastId		   4 : integer 			#广播id
}

#秘境寻宝信息列表
.GetLotteryInfo
{
}
.GetLotteryInfoR
{
	needRemind         0 : integer          #钥匙不足消耗元宝是否需要确认框 1:要确认框 0:不要 
	storehouseReward   1 : integer          #仓库是否有物品 
	broadcastList      2 : *BroadcastInfo   #全服稀有奖励记录
	isOpen             3 : integer          #活动是否开启 0-未开 1-开启
}

#参与秘境寻宝抽奖
.LotteryDraw
{
	times        0 : integer  #抽多少次
	needRemind   1 : integer  #钥匙不够自动用元宝买 今日是否需要提示确认框 1-需要提示 0-不需要提示
}
.LotteryDrawR
{
	err              0 : integer    #0-成功,其他为错误码
	rewardCodeList   1 : *integer   #奖励编号列表
}

#获取抽奖仓库物品列表
.GetLotteryStorehouseInfo
{
}
.GetLotteryStorehouseInfoR
{
	storehouse   0 : *Item    #仓库内容
}

#取出抽奖仓库物品
.GetLotteryStorehouse
{
	pos          0 : integer  #获取第几个格子的物品 (pos = 0 → 一键获取)
}
.GetLotteryStorehouseR
{
	err 		 0 : integer   #0-成功,其他为错误码
	pos 		 1 : integer   #成功取出第几个格子的物品 一键时为pos = 0
}

#-----------------------------秘境寻宝end------------------------------------

#----------------------------安全锁begin-----------------------------------

#设置安全码
.SetSaftyCode
{
	saftyCode  	0 : string 	  #安全码 md5(key..code)
}
.SetSaftyCodeR
{
	err 		0 : integer   #0-成功,其他为错误码
}

#重设安全码
.ResetSaftyCode
{
	oldCode 	0 : string 	  #旧安全码
	newCode 	1 : string 	  #新安全码
}
.ResetSaftyCodeR
{
	err 		0 : integer   #0-成功,其他为错误码
}

#锁定安全锁
.LockSaftyCode
{
}
.LockSaftyCodeR
{
	err 		0 : integer   #0-成功,其他为错误码
}

#解除安全锁
.UnlockSaftyCode
{
	saftyCode  	0 : string 	  #安全码 md5(key..code)
}
.UnlockSaftyCodeR
{
	err 		0 : integer   #0-成功,其他为错误码
}

#获取当前玩家安全锁状态
.GetSaftyState
{
}
.GetSaftyStateR
{
	state 		0 : integer   #1-未上锁，2-已上锁，3-已解锁，对应enum.ROLE_SAFTY_STATE中
}

#-----------------------------安全锁end------------------------------------

#----------------------------离线系统begin-----------------------------------
#获取离线挂机经验信息
.GetOfflineExpInfo
{
}
.GetOfflineExpInfoR
{
	totalOfflineMin 	0 : integer 	#当前累计离线时间 单位分钟
	maxOfflineMin 		1 : integer 	#可累积离线时间 单位分钟
}

#后端主动推送离线挂机时间更新
.UpdateOfflineExpMaxTimeR
{
	maxOfflineMin 		0 : integer 	#可累积离线时间 单位分钟
}

#领取离线挂机经验
.GetOfflineExpReward
{
}
.GetOfflineExpRewardR
{
	err 				0 : integer 	#0-成功,其他为错误码
}
#-----------------------------离线系统end------------------------------------
]]
