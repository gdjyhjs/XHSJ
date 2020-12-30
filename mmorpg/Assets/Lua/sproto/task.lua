-- 英雄相关协议

local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

.Task
{
	code 0 : integer		# 任务的codeid
	schedule 1 : *integer	# 任务详细进度
}


#取任务信息,应该只需要登录的时候取一次
.GetTask
{
}
.GetTaskR
{
	list 0 : *Task			# 任务的列表
	finishTask 1 : *integer # 已结束的任务(完成并领取)
}

#请求接取任务
.AcceptTask
{
	code 0 : integer   #任务id
}

.AcceptTaskR
{
	code 0 : integer    #服务端发送接取任务
}

#通知任务进展
.ScheduleUpdateR
{
	code 0 : integer      #任务的codeid
	index 1 : integer     #值下标
	value 2 : integer     #值
}

#通知任务完成
.TaskCompleteR
{
	code 0 : integer
}

#请求交任务
.TaskHandUp
{
	code 0 : integer
}

#通知任务结束
.TaskFinishR
{
	code 0 : integer
}

#通知任务移除 暂时只有后端根据规则删除任务 通知前端
.TaskGiveUpR
{
	code 0 : integer
}

#护送任务打开界面
.EscortOpenUI
{
}

.EscortOpenUIR
{
	quality      0 : integer   #当前品质
	onekeyRemind 1 : integer   #一键橙色是否出确认框 1:要确认框 0:不要
	refreshTimes 2 : integer   #今天用免费次数刷新了几次 
	todayTimes   3 : integer   #今天已经参加了多少次
	quality5Times 4 : integer  #历史护送过几次金色美人
}

#护送任务刷新美人品质
.EscortFreshQuality
{
	isOnekey 0 : integer      #1:一键橙色 0:刷新一次 可缺省 默认为0
}

.EscortFreshQualityR
{
	err 		 0 : integer 	#0-成功，其他为错误码
	quality      1 : integer 	#当前品质
	refreshTimes 2 : integer 	#今天用免费次数刷新了几次
}

#护送任务设置今日一键橙色不再出现确认框
.EscortSetOnekeyRemind
{
	onekeyRemind 0 : integer   #一键橙色是否出确认框 1:要确认框 0:不要
}

.EscortSetOnekeyRemindR
{
	onekeyRemind 0 : integer   #一键橙色是否出确认框 1:要确认框 0:不要
}

#护送任务信息
.EscortTaskInfo
{
}
.EscortTaskInfoR
{
	endTime    0 : integer   #结束时间
	quality    1 : integer   #美人等级 1~5 绿蓝紫金橙
	isFail     2 : integer   #是否已经失败 1失败0还没失败
	taskCode   3 : integer   #任务code 用来取目标
}

#接受护送任务
.EscortAcceptTask
{
}
.EscortAcceptTaskR
{
	err      0 : integer         #0成功 其他为错误码
	taskInfo 1 : EscortTaskInfoR #任务信息
}

#完成护送
.EscortFinish
{
}
.EscortFinishR
{
	err           0 : integer #0成功,其他为错误码
	isDouble      1 : integer #是否双倍 1-是 0否
	isExpired     2 : integer #是否超时 1-是 0否
	code          3 : integer #任务编号
}

#公告
.Notice
{
	type 0 : integer		# 类型对应NOTICE_TYPE
	title 1 : string		# 标题
	content 2 : string		# 内容
}

#取公告信息
.GetNotice
{
}
.GetNoticeR
{
	noticeList 0 : *Notice  # 公告列表
}

.Item
{
	code 		0 : integer
	num 		1 : integer
	formuleId 	2 : integer #打造id
}

#前端预读任务奖励
.PrereadTaskReward
{
	code 		0 : integer 	#任务code
}
.PrereadTaskRewardR
{
	reward 		0 : *Item 		#奖励列表
}

#-----------------------------活动begin---------------------------------

#请求每日签到info
.DailySignInfo
{
}

.DailySignInfoR
{
	code 0 : integer          #本轮签到对应的配置code
	schedule 1 : *integer      #签到进度当（含今天），0为当日没签到，1为签到，2为vip只领了单倍
}

.DailySign
{
}

.DailySignR
{
	err 0 : integer          #
}

#请求豪华签到info
.SuperSignInfo
{
}

.SuperSignInfoR
{
	reward 0 : *Item          #获得道具
	get 1 : integer           #0为没领，1为已领，2为可领
}

.SuperSign
{
}

.SuperSignR
{
	err 0 : integer
}

#等级礼包
.LevelBagInfo
{
	code 0 : integer       #礼包id
}

.LevelBagInfoR
{
	expired 0 : integer      #领取过期时间
	schedule 1 : *integer    #领取次数，按下标获取
}

.GetLevelBag
{
	code 0 : integer       #礼包id
	index 1 : integer      #对应的下标
	num 2 : integer        #购买数量
}

.GetLevelBagR
{
	err 0 : integer    
}

.RedPointR
{
	list 0 : *integer      #配置code
	type 1 : integer       #红点类型 enum.RED_POINT_TYPE
}

.GetStrength
{
}

.GetStrengthR
{
	err 0 : integer         #当err为0才发送如下奖励
	reward 1 : *Item         #获得的物品
}

.OpenActivityList
{
}

.OpenActivityListR
{
	list 0 : *integer        #当前开启的活动
}

#----------------------活动end--------------------------

#----------------------日常活跃begin---------------------------------

#日常结构体
.Daily
{
	code      0 : integer   #日常编号
    times     1 : integer   #现完成次数
    activeVal 3 : integer   #此日常已获得的活跃
}

.DailyReward
{
	activeNum   0 : integer #活跃度奖励档次 直接用所需要的活跃度作档次号
	isRewarded 1 : integer #是否已领取 1-已经领过 缺省-没领过
}

#获取日常协议
.GetDailyList
{
}

.GetDailyListR
{
	activeVal        0 : integer      #总活跃度
	dailyList        1 : *Daily       #所有日常列表
	activeRewardList 2 : *DailyReward #日常活跃奖励领取状态列表
	nowOpeningList   3 : *integer     #现在正开的活动列表
}

.UpdateDailyInfoR
{
	activeVal 0 : integer #总活跃度
	daily     1 : Daily   #日常信息
}

#前端点击参与 检查是否可以参加活动
.DailyCheckJoin
{
	code 0 : integer #日常编号
}
.DailyCheckJoinR
{
	err 0  : integer #0-成功 其他为错误码
}

#获取日常活跃度奖励
.GetDailyActiveReward
{
	activeNum 0 : integer  #活跃度奖励档次
}
.GetDailyActiveRewardR
{
	err       0 : integer  #0-成功 其他为错误码
	activeNum 1 : integer  #活跃度奖励档次 只有err=0领取成功才返回
}

#日常活动开启
.DailyActivityStartR
{
	code      0 : integer  #日常活动code
}

#日常活动结束 时间到 或者提前结束(例如世界boss未到时间就被击杀)
.DailyActivityEndR
{
	code      0 : integer  #日常活动code
}

#----------------------日常活跃end---------------------------------

#----------------------天机任务begin---------------------------------

#备选任务结构体
.choiceObj
{
	pos   0 : integer   #位置     1 2 3
	code  1 : integer   #任务编号
    state 2 : integer   #任务状态 0-未接, 1-已接, 2-已完成, 3-已领奖
}

#前端获取天机任务信息
.GetDailyTaskInfo
{	
}
.GetDailyTaskInfoR
{
    validTimes    0 : integer    #剩余可做次数
    taskList      1 : *choiceObj #备选任务结构体
}

#领取天机任务
.DailyTaskAccept
{
	pos 0 : integer #位置
}
.DailyTaskAcceptR
{
	err 0 : integer # 0-成功 其他为错误码
}

#刷新天机任务
.DailyTaskRefresh
{
}
.DailyTaskRefreshR
{
	err      0 : integer    # 0-成功 其他为错误码
    taskList 1 : *choiceObj #备选任务结构体
}

#领取任务奖励
.DailyTaskGetReward
{
	pos 0 : integer #位置
}
.DailyTaskGetRewardR
{
	err 0 : integer # 0-成功 其他为错误码
}

#购买天机任务可做次数
.DailyTaskBuyValidTimes
{
}
.DailyTaskBuyValidTimesR
{
	err        0 : integer # 0-成功 其他为错误码
	validTimes 1 : integer #剩余可做次数
}

#后端主动更新任务状态
.UpdateDailyTaskInfoR
{
	taskList 0 : *choiceObj #备选任务结构体
}

#----------------------天机任务end--------------------------

#----------------------每日任务begin------------------------

#前端获取每日任务信息
.GetEveryDayTaskInfo
{
}
.GetEveryDayTaskInfoR
{
	curTimes 	0 : integer 	#当前是第几个每日任务 上限20
}

#接受每日任务
.AcceptEveryDayTask
{
}
.AcceptEveryDayTaskR
{
	err 		0 : integer 	#0-成功,其他为错误码
	curTimes 	1 : integer 	#当前是第几个每日任务 上限20
}

#-----------------------每日任务end-------------------------

#----------------------每日答题begin------------------------
#今日答题状态结构体
.TodayQuestionState
{
    curIndex     0 : integer  #现在答到第几题
    todayCoin    1 : integer  #今天总共获得铜币
    todayExp     2 : integer  #今天总共获得经验
    rightTimes   3 : integer  #今天答对次数
    costTime     4 : integer  #可缺省，当今天题目已答完才发
    todayFame    5 : integer  #今天总共获得名望
}

#获取每日答题数据
.GetQuestionInfo
{
}
.GetQuestionInfoR
{
	err           0 : integer  #0-成功，其他为错误码
	questionList  1 : *integer #今日题目列表
	startTime     2 : integer  #今日开始时间
	questionState 3 : TodayQuestionState
}

#回答问题
.AnswerQuestion
{
	questionCode 0 : integer #回答的题目编号
	chooseCode   1 : integer #玩家选的序号 1234
}
.AnswerQuestionR
{
	err           0 : integer #0答错，1答对，其他为错误码
	rightIndex    1 : integer #正确答案序号 1234
	questionState 2 : TodayQuestionState
}

#牌局开始匹配
.CardsGameMatch
{
}
.CardsGameMatchR
{
	err           0 : integer  #0-进入匹配成功，其他为错误码
}

#牌局取消匹配
.CardsGameMatchCancel
{
}

#牌局选手信息 构造体
.CardGamePlayerInfo
{
	head          0 : integer			#头像
	name          1 : string 			#昵称
	winTimesWeek  2 : integer			#本周胜利次数
	timesWeek     3 : integer			#本周场次
	winTimesToday 4 : integer           #本日胜场                    是对手信息时缺省
	roundWinTimes 5 : integer			#这局游戏三回合中赢了几回合  不在对局中时缺省
	cardsList     6 : *integer 			#剩余可用卡牌列表 对应五种牌 不在对局中时缺省
}

#回合对战信息记录 构造体
.RoundInfoRecord
{
	roundNo       0 : integer			#第几回合 1,2,3
	myScore       1 : integer			#我的得分
	hisScore      2 : integer			#对手得分
}

#打开界面获取需要显示的信息
.GetCardsGameInfo
{
}
.GetCardsGameInfoR
{
	state         0 : integer              #当前状态 enum.CARDS_GAME_STATE
	myInfo        1 : CardGamePlayerInfo   #我的信息
	hisInfo       2 : CardGamePlayerInfo   #对手信息
	dailyRewards  3 : integer              #每日胜场奖励领取情况 二进制
	scoreList     4 : *RoundInfoRecord     #这局游戏对战记录
	roundEndTime  5 : integer              #本回合结束时间
	lastDiscard   6 : DiscardInfo          #当前出牌信息
}

#出牌信息构造体
.DiscardInfo
{
	myDiscard     0 : *integer             #我的出牌信息
	hisDiscard    1 : *integer             #对手出牌信息
}

#更新牌局游戏信息(全部都可缺省,只修改有内容的字段)
.UpdateCardsGameInfo
{
	state         0 : integer              #当前状态 enum.CARDS_GAME_STATE
	myInfo        1 : CardGamePlayerInfo   #我的信息
	hisInfo       2 : CardGamePlayerInfo   #对手信息
	dailyRewards  3 : integer              #每日胜场奖励领取情况 二进制
	scoreList     4 : *RoundInfoRecord     #这局游戏对战记录
	roundEndTime  5 : integer              #本回合结束时间
	lastDiscard   6 : DiscardInfo          #当前出牌信息
}

#确认本次出牌
.CardsGameDiscard
{
	discardList   0 : *integer             #出牌信息
}
.CardsGameDiscardR
{
	err           0 : integer              #0-成功，其他为错误码
}

#-----------------------每日答题end-------------------------

#-----------------------成就 begin--------------------------
#成就组构造体
.Achieve
{
  	family     0 : integer    	# 成就的codeid去掉后两位
  	schedule   1 : integer    	# 成就组详细进度
  	rewarded   2 : integer    	# 成就组已领取的最大number，同组number小于等于这个数的都为已领取
}

#获取成就列表
.GetAchieveList
{
  	system      0 : integer 	# 成就所属系统
}
.GetAchieveListR
{
  	system 	   	 0 : integer 	# 请求发送的系统编码
  	achieveList  1 : *Achieve 	# 返回此系统的成就组对象
  	achievePoint 2 : *integer 	# 成就点数统计，系统为1时返回成就统计集合，顺序按system编号{1,2,3,4,5,6,7}
}

#成就完成时推送
.AchieveUpdateR
{
	achieve 0 : Achieve 		#进度更新的成就组对象
	code 	1 : integer 		#完成成就的codeid
}

#获取成就奖励
.GetAchieveReward
{
  	code         0 : integer 	#获取奖励的成就编号
}
.GetAchieveRewardR
{
  	code 		 0 : integer 	#请求发送的成就编码
  	err          1 : integer  	#0-成功，其他为错误码
  	nextAchieve  2 : Achieve 	#领取成功则返回此组成就的对象，领取失败则为nil
}

#成就红点
.AchieveRedPointR
{
	system 		 0 : *integer 	#有未获取奖励成就的system集合
}

#-----------------------成就 end--------------------------

#-----------------------七煞星盘begin-----------------------

#获取界面信息
.GetAstrolabeSchedule
{
	system 0 : integer   #页签
}

.GetAstrolabeScheduleR
{
	list 0 : *Astrolabe  #列表
	systemRewarded 1 : boolean #true为已领取被动技能
	openSystem 2 : integer     #当前可以开放的页签

	.Astrolabe
	{
		code 0 : integer
		schedule 1 : integer
		rewarded 2 : boolean  #true为已领取
		param 3 : integer #1.当为击杀boss目标时，schedule为1,则为已击杀的bossCode
	}
}

#领取星盘目标奖励
.GetAstrolabeReward
{
	code 0 : integer
}

.GetAstrolabeRewardR
{
	err 0 : integer
	code 1 : integer
}

#领取被动技能
.GetAstrolabeSkill
{
	system 0 : integer
}

.GetAstrolabeSkillR
{
	err 0 : integer
	system 1 : integer
}

.AstrolabeRedPointR
{
	list 0: *integer #有奖励的page
}

#-----------------------七煞星盘end-------------------------

#-----------------------新活动begin-------------------------

#----------新活动协议类begin---------
#进度对象（登录活动此对象只有code一个参数，表示累计登录天数）
.ScheduleObj{
	code  	  0 : integer 		#对应活动表condition中t的第一个参数
	count 	  1 : integer 		#对应活动表condition中t的第二个参数
}

#通用活动对象(转盘不适用)
.ActivityRewardObj{
	rewardId   0 : integer 		#奖励id
	schedule   1 : *ScheduleObj #奖励进度
	times 	   2 : integer 		#此奖励已领取次数
	serverLeft 3 : integer 		#全服剩余数量(不限数量为nil)
	timesToday 4 : integer  	#本日已领取次数
}
#----------新活动协议类end------------

#获取活动进度通用方法(转盘不适用)
.GetRewardGroup{
	activityId 0 : integer 				#活动id
}
.GetRewardGroupR{
	err 	   0 : integer				#获取成功返回0，其他为错误代码
	activityId 1 : integer 				#活动id
	schedule   3 : *ActivityRewardObj   #通用活动奖励组，获取错误则为nil
}

#领取活动奖励通用方法(转盘不适用)
.GetNormalReward{
	rewardId   0 : integer 		#奖励id
	activityId 1 : integer 		#活动id
}
.GetNormalRewardR{
	err 	   0 : integer	 	#0-成功，其他为错误码
	rewardId   1 : integer 		#奖励id
	activityId 2 : integer 		#活动id
	times 	   4 : integer 		#此奖励已领取次数
	serverLeft 5 : integer 		#全服剩余数量(不限数量为nil)
	timesToday 6 : integer  	#本日已领取次数
}

#获取转盘活动进度
.GetWheelActivity{
	activityId	0 : integer 	#活动id
}
.GetWheelActivityR{
	err 		 0 : integer 	  #0-成功，其他为错误码
	activityId   1 : integer 	  #活动id
	leftReward 	 2 : *integer     #剩余可抽物品
	remainTime   3 : integer	  #下次抽取剩余时间
}

#转盘活动操作
.TurnWheel{
	activityId	0 : integer 	 #活动id
}
.TurnWheelR{
	err 		0 : integer 	 #0-成功，其他为错误码
	activityId  1 : integer 	 #活动id
	reward 	 	2 : integer      #抽出的物品
}

#活动红点
.ActivityRedPointR{
	activityId 	0 : *integer	 	 #活动id
}

#完成活动奖励时红点
.FinishRewardRedPointR{
	activityId 	0 : integer	 	 #活动id
}

#登录主动推送登录活动状态(登录活动7天后至活动结束推送)
.PushLoginActivityR{
	activityId 	0 : integer		 #活动id
	allRewarded	1 : integer 	 #0-已领完，1-未领完
}

#-----------------------新活动  end-------------------------

#-----------------------滚动字幕 begin ----------------------

.RollMessageR{
	content   0 : string   		#内容
}

#-----------------------滚动字幕 end -------------------------

]]