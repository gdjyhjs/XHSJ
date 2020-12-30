--副本协议

local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

#---------------------------副本相关-----------------------------

#mgr->story->chapter->stage

#物品
.Item
{
	code 0 : integer      #物品原型
	num  1 : integer      #物品数量
}

#进入副本
.EnterCopy
{
	copyCode 0 : integer
	enemyGuid 1 : integer #竞技场字段
}

.EnterCopyR
{
	err       0 : integer
}

#退出副本
.ExitCopy
{

}

.ExitCopyR
{
	err 0 : integer
	mapId 1 : integer
	x 2 : integer
	y 3 : integer
}

#成功通关副本
.PassCopyR
{
	costTime 		0 : integer 		#消耗时间，通用
	itemDrops 		1 : *Item 			#物品, 通用
	holyCode 		2 : integer 		#过关斩将
	arenaInfo 		3 : *integer 		#竞技场特有,分别对应当前积分，增加的积分，排名，伤害
	teamVsCopyInfo 	4 : TeamPassInfo 	#3v3副本字段
	protectCityInfo 5 : *integer 		#魔族围城(排名，伤害, 铜币)
}

.ItemList
{
	itemLs    0 : *Item
}
#扫荡
.SweepCopy
{
	copyCode 0 : integer          #
	count    1 : integer
}

.SweepCopyR
{
	err       0 : integer #0-扫荡成功 其他为错误码
	itemDrops 1 : *ItemList
	challenge 2 : integer #当日挑战次数
	expDrops  3 : integer
	coinDrops 4 : integer
}

#重置小节
.ResetCopy
{
	copyCode 0 : integer          #重置副本
}

.ResetCopyR
{
	err 0 : integer				#错误码
}

#登陆通知有可领奖励
.RewardNotifyR
{
	flag 0 : boolean #true 为有可领奖励，false为无可领奖励
}

#第几波怪来袭
.CreatureWaveNotifyR
{
	wave 0 : integer #第几波怪来袭，0表示最后一波
	target 1 : integer #这波怪总数
}

#杀怪进度更新
.CopyScheduleR
{
	schedule 0 : integer #杀怪进度
}

#--------------------------剧情副本begin-------------------------
#副本信息
.StoryCopyInfo
{
	copyCode 0 : integer                #副本code
	star 1 : integer                    #历史最好成绩
	challenge 2 : integer               #今日通关(挑战)次数
	reset 3 : integer                   #今日已重置次数
}

#取章节信息
.GetStoryCopyInfo
{
}

.GetStoryCopyInfoR
{
	info 0 : *ChapterInfo             
	.ChapterInfo
	{
		chapter 0 : integer                 #章节id
		copyInfo 1 : *StoryCopyInfo	        #副本信息
		getReward 2 : *integer              #已领取的宝箱下标
	}
}

#领取宝箱
.OpenChapterBox
{
	chapter 0 : integer			#第几章节
	index 1 : integer           #第几个宝箱
	
}
.OpenChapterBoxR
{
	err 0 : integer				#错误码
}

#----------------------------剧情副本end---------------------------

#-----------------------------过关斩将begin------------------------
.GetHolyCopyInfo
{
}

.GetHolyCopyInfoR
{
	code 0 : integer   #当前所在的章节id
}

#请求昨日奖励
.DailyReward
{
}

.DailyRewardR
{
	reward 0 : *Item     #此处的itemcode为圣物货币的id
}

#圣物信息
.HolyInfo
{
	holyCode 0 : integer 
	level 1 : integer
	coinNum 2 : integer   #对应的货币的数量
}

#强化信息
.GetHolyInfo
{
}

.GetHolyInfoR
{
	holyInfo 0 : *HolyInfo 
}

#强化圣物
.StrengthenHoly
{
	holyCode 0 : integer
}

.StrengthenHolyR
{
	err 0 : integer
	holyCode 1 : integer
}

#继续挑战
.ContinueChallenge
{
}

.ContinueChallengeR
{
	err 0 : integer       #
}

#-----------------------------过关斩将end---------------------------

#----------------------------爬塔副本begin---------------------------

#获取爬塔副本信息
.GetTowerInfo
{
}

.GetTowerInfoR
{
    curFloor      0 : integer #当前要挑战的层数副本编号
}

#-----------------------------爬塔副本end------------------------

#-----------------------------竞技场begin------------------------
#对手信息
.EnemyInfo
{
	roleId 0 : integer #角色id
	head 1 : integer  #头像
	level 2 : integer #等级
	name 3 : string  #玩家名字
	score 4 : integer #积分
	heroCode 5 : integer #宠物原型id
	power 6 : integer #战力
	vipLevel 7 : integer #vip等级
}


#竞技场面板信息
.ArenaInfo
{
}

.ArenaInfoR
{
	rank 0 : integer #自己排名
	score 1 : integer #积分
	leftTime 2 : integer #剩余次数
	winStreak 3 : integer #连胜次数
	enemyList 4 : *EnemyInfo #对手列表
	rewardScore 5 : integer  #结算时的积分
	canGetReward 6 : boolean #是否能够领取奖励
}

#单条对战记录
.FightRecord
{
	win         0 : boolean      #true为赢
	score       1 : integer    #积分
	changeScore 2 : integer 
	attack      3 : boolean   #true为主动攻击
	name        4 : string
	head        5 : string
	level       6 : integer
	vipLevel    7 : integer   #vip等级
	challengeTime 8 : integer #对战时间
}

#对战记录
.ArenaFightRecord
{
}

.ArenaFightRecordR
{
	record 0 : *FightRecord
}


#排行榜
.ArenaRankList
{
	page 0 : integer    #分页，每页拿7个
}

.ArenaRankListR
{
	list 0 : *EnemyInfo  #玩家信息
	myRank 1 : integer   #我的排名
}

#换一批
.RefreshMatch
{
}

.RefreshMatchR
{
	enemyList 0: *EnemyInfo #对手列表
}

#领取每日奖励
.GetArenaDailyReward
{
}

.GetArenaDailyRewardR
{
	err 0 : integer
}

#增加挑战次数
.AddChallengeTimes
{
}

.AddChallengeTimesR
{
	err 0 : integer
}

#获取今日剩余增加次数
.GetAddTimesLeft
{
}

.GetAddTimesLeftR
{
	leftTimes 0 : integer 
}


#-----------------------------竞技场end--------------------------

#------------------------------引导副本begin--------------------------
#引导副本请求刷怪
.NextWave
{
	wave 0 : integer #请求第几波怪
}

.NextWaveR
{
	err 0 : integer
}

#----------------------------引导副本end------------------------------

#----------------------------阵营战begin------------------------------

.FactionRankInfo
{
	roleId 0 : integer
	name 1 : string
	power 2 : integer
	kill 3 : integer
	assist 4 : integer
	honor 5 : integer
	win 6 : boolean   #true ，false or nil
}

#战场统计
.FactionRank
{
}

.FactionRankR
{
	rankList 0 : *FactionRankInfo
}

#战场实时数据
.FactionStatisticsR
{
	starScore 0 : integer     #星宇积分
	sunScore 1 : integer      #落阳积分
	kill 2 : integer
	assist 3 : integer     
	honor 4 : integer           #荣誉
	feats 5 : integer           #
	energy 6 : integer          #能量储备
	starFlags 7 : *integer      #1为战旗, 2-5为防御塔
	sunFlags 8 : *integer       #同上
}

#提交采集珠给军需官
.FactionHandUp
{
}

.FactionHandUpR
{
	err 0 : integer
}


#----------------------------阵营战end--------------------------------

#----------------------------3v3begin---------------------------------

#加载进度
.TeamVsCopyLoadProgress
{
	progress 0 : integer  
}

#加载进度广播
.TeamVsCopyLoadProgressNotifyR
{
	roleId 0 : integer
	progress 1 : integer

}

#通知开始战斗
.TeamBeginBattleNotifyR
{
	beginTime 0 : integer #开始时间
}

.TeamRecord
{
	kill 0 : integer      #破敌
	score 1 : integer     #分数
	win 2 : boolean       #胜利
}

#获取本人副本信息
.TeamVsCopyInfo
{
}

.TeamVsCopyInfoR
{
	score 0 : integer
}


#队伍实时分数
.TeamScoreR
{
	scoreL 0 : *integer    #队伍分数
}

#对战记录
.TeamRecordList
{
}

.TeamRecordListR
{
	list 0 : *TeamRecord
	winCount 1 : integer  #胜场
	failCount 2 : integer #败场
	rank 3 : integer      #战场排名
}

#队员实时数据
.Member
{
	roleId 0 : integer
	name 1 : string
	level 2 : integer
	head 3 : string
	maxHp 4 : integer
	hp 5 : integer         #当前血量
}

#进入副本发送本队队伍属性
.MemberListR
{
	member 0 : *Member
}


#成员属性变化广播
.MemberAttrChangeNotifyR
{
	member 0 : Member  #Member里面的字段，哪个有变化发哪个，并不会全部都发
}

#击败玩家广播(广播给受害者和击杀着)
.KillEnemyR
{
	killerHead 0 : string
	victimHead 1 : string 
	killerRoleId 2 : integer
	victimRoleId 3 : integer
	killerName 4 : string
	victimName 5 : string
	firstBlood 6 : boolean 
}

#结算界面
.MemberResultInfo
{
	name 0 : string
	head 1 : string
	level 2 : integer
	score 3 : integer
	feats 4 : integer #战功
	honor 5 : integer #荣誉
	kill 6 : integer #击杀
	mvp 7 : boolean  #是mvp则为true,否则为nil
	dead 8 : integer #死亡次数
}

#通关信息
.TeamPassInfo
{
	memberInfo 0 : *MemberResultInfo
	totalKill 1 : *integer
	win 2 : boolean
}


#----------------------------3v3end-----------------------------------


#----------------------------材料副本begin------------------------------
#材料副本通关星级 构造体
.MaterialCopyInfo
{
	copyCode 		0 : integer 			#副本编号
	star 			1 : integer 			#通关星级
}

#获取材料副本信息
.GetMaterialCopyInfo
{
	copyType 		0 : integer 			#副本类型 兵来将挡：enum.COPY_TYPE.MATERIAL = 10, 时空宝库：enum.COPY_TYPE.MATERIAL2 = 15
}
.GetMaterialCopyInfoR
{
	copyType 		0 : integer 			#副本类型 兵来将挡：enum.COPY_TYPE.MATERIAL = 10, 时空宝库：enum.COPY_TYPE.MATERIAL2 = 15
	buyTimes 		1 : integer 			#购买次数
	validTimes 		2 : integer 			#当前可进场次数
	starList 		3 : *MaterialCopyInfo 	#材料副本通关星级 
}

#购买材料副本次数
.BuyMaterialTimes
{
	copyType 		0 : integer 			#副本类型 兵来将挡：enum.COPY_TYPE.MATERIAL = 10, 时空宝库：enum.COPY_TYPE.MATERIAL2 = 15
}
.BuyMaterialTimesR
{
	err 			0 : integer 			#错误码
}
#----------------------------材料副本end------------------------------

#----------------------------魔族围城begin---------------------------------

#魔族统领出现前
.BossBornInfoR
{
	bornTime 0 : integer #出现时间
}

#魔族统领出现后
.BossHurtListR
{
	hurtList 0 : *BossHurtInfo
	myHurt   1 : integer
	myRank   2 : integer
	coin     3 : integer

	.BossHurtInfo
	{
		name 0 : string
		value 1 : integer
	}
}

#对建筑的伤害广播
.BuildingHurtR
{
	hurt 0 : integer
}


#----------------------------魔族围城end-----------------------------------

#----------------------------玩法副本begin--------------------------------


#面板信息
.SmallGameInfoR
{
	schedule 0 : *integer #进度
}

#文字提示
.SmallGameTipsR
{
	tipCode  0 : integer  #提示code
	args     1 : *string  #提示中的动态内容
	guid     2 : integer  #如果是怪物 发送guid
}

#----------------------------玩法副本end----------------------------------

#-----------------------------副本相关end------------------------



]]
