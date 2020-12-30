local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

#军团信息
.Alliance
{
	id 				0 : integer			#军团id
	name 			1 : string 			#军团名字
	flag 			2 : integer			#军团旗帜(颜色)
	leader 			3 : string 			#盟主
	level 			4 : integer 		#军团等级
	memberSize 		5 : integer 		#军团成员数量  
	fund 			6 : integer 		#军团资金
	qqGroup 		7 : integer 		#军团Q群
	upGradestatu 	8 : integer 		#军团升级状态
	auctionFlag 	9 : integer 		#军团仓库拍卖状态
	word 			10 : string 		#军团字号
	totalPower 		11 : integer 		#军团总战力
	announcement 	12 : string 		#军团公告
	levelLimit      13 : integer        #申请等级限制
	powerLimit      14 : integer        #申请等级限制
	introduction    15 : string         #军团宗旨
	warFlagLevel    16 : integer        #军团战旗等级
	isImpeaching    17 : integer        #是否正在弹劾阶段
	leaderId  		18 : integer 		#盟主id
}

#军团基本信息
.AllianceBaseInfo
{
	id  			0 : integer 		#军团id
	name  			1 : string 			#军团名字
	level  			2 : integer 		#军团等级
	leader  		3 : string 			#盟主
	fund  			4 : integer 		#军团资金
	announcement 	5 : string 			#军团公告
	introduction    6 : string          #军团宗旨
	totalPower 		7 : integer 		#军团总战力
	memberSize 		8 : integer 		#军团成员数量
	leaderId  		9 : integer 		#盟主id
}

#军团成员
.Member
{
	roleId 			0 : integer 	#角色id
	name 			1 : string 		#角色名字
	power 			2 : integer		#角色战斗力
	level 			3 : integer 	#角色等级
	title 			4 : integer		#我的title(职位)
    donation 		5 : integer		#军团贡献
    logoutTm 		6 : integer		#上次下线时间，在线为0
    totalDonation 	7 : integer		#在这个军团期间获得过的军团贡献值
    vipLevel		8 : integer		#vip等级
    head 			9 : string 		#头像
}

#军团每日任务结构体
.DailyTask{
	isDone       0 : integer  #0-未完成，1-已完成
	taskCodeList 1 : *integer #军团每日任务code列表 对应军团表output_alliance_daily_task的code字段
}

#获取角色相关的信息
.GetMyInfo
{
}

.GetMyInfoR
{
	id              0 : integer      #玩家军团id 如果不在军团则为0
	title           1 : integer      #玩家职位
	dailyTask       2 : DailyTask    #军团每日任务信息
	repeatTaskTimes 3 : integer      #军团重复任务今天做到第几个了
	devoteTimes     4 : integer      #今日已捐献次数
	inspireTimes    5 : integer 	 #今日鼓舞次数
	inspireExpiredTime 6 : integer 	 #鼓舞到期时间
}

.UpdateMyInfoR
{
	title 0 : integer 			#我的title
}

#查找军团
.SearchAlliance
{
	keyWord 0 : string 			#关键字
}

.SearchAllianceR
{
	list 0 : *Alliance 			#军团列表.
}

#获取军团列表
.AllianceList
{
	page    0 : integer           #分页拿，每次发6个
	canJoin 1 : integer           #是否只显示可加入
}

.AllianceListR
{
	list 0 : *AllianceBaseInfo #军团列表
}

#获取军团基础信息
.GetBaseInfo
{
}

.GetBaseInfoR
{
	alliance        0 : Alliance 	#军团信息
	titleList       1 : *string 	#军团称号对应名称
	autoAllow       2 : integer 	#是否自动允许 1-自动允许 0-否
	legionBossTimes 3 : integer 	#兽神boss本周已挑战次数
	foodCount		4 : integer 	#军团剩余口粮数
	legionBossCurHP 5 : integer		#兽神boss当前血量
	legionBossMaxHP 6 : integer		#兽神boss总血量
	legionBossLeaveTime 7 : integer #兽神boss本次离开时间
}


#获取成员列表
.GetMemberList
{
}

.GetMemberListR
{	
	memberList 0 : *Member 		#成员列表
}

#建立军团
.Build
{
	name         0 : string 		#军团名字
	flag         1 : integer 		#军团旗帜
	word         2 : string         #军团字号
	resType      3 : integer 		#消耗货币种类
	introduction 4 : string 		#军团宗旨
}

.BuildR
{
	id 0 : string				#军团id
	err 1 : integer 			#0为正常，其它为错误码
}

#申请
.Apply
{
	roleId 0 : integer 			#角色id
	name 1 : string 			#角色名字
	power 2 : integer			#角色战斗力
	career 3 : integer 			#职业	
	level 4 : integer           #等级	
}

#获取申请列表
.GetApplyList
{
}

.GetApplyListR
{
	applyList 0 : *Apply   	    #请求列表
}

#获取自己的申请列表
.MyApply
{
}

.MyApplyR
{
	idList 0 : *string              #军团list
}

#申请加入军团
.ApplyJoin
{
	id 0 : integer    	    	#军团id, 一键申请发0过来
}

.ApplyJoinR
{
	err 0 : integer 			#0为正常，其它为错误码
}



#回复申请
.ApplyReply
{
	roleId 0 : integer 			#角色id 0-一键同意
	result 1 : boolean  		#回复结果 true 为同意，false为拒绝
}

.ApplyReplyR
{
	err       0 : integer 		#0为正常，其它为错误码
	roleId    1 : integer       #返回同意的roleid 一键同意返0 
}

#一键拒绝
.OneKeyReject
{
}

#退出军团
.Quit
{
}

.QuitR
{
	err 0 : integer 			#0为正常，其它为错误码
}

#解散军团
.Dissolve
{	
}

.DissolveR
{
	err 0 : integer 			#0为正常，其它为错误码	
}

#踢出军团
.KickOut
{
	roleId 0 : integer 			#踢出的角色
}

.KickOutR
{
	err 0 : integer 			#0为正常，其它为错误码
}


#设置职位
.SetTitle
{
	roleId 0 : integer  	    
	title 1 : integer 			#title
}

.SetTitleR
{
	err 0 : integer 			#0为正常，其它为错误码
}

.Announcement
{
	time 0 : integer           #时间戳
	name 1 : string            # 
	content 2 : string        
}

#军团公告
.GetAnnouncement
{
}

.GetAnnouncementR
{
	announcement 0 : *Announcement
}

.TitleInfo
{
	titleCode    0 : integer    #职务编号 enum.TITLE_NAME
	titleName    1 : string     #职务名
}

#修改军团信息
.ModifyInfo
{
	announcement 0 : string 	#军团公告
	qqGroup      1 : integer 	#qq群
	titleList    2 : *TitleInfo #军团职务信息
	introduction 3 : string     #军团宗旨
}

.ModifyInfoR
{
	err 0 : integer 			#0为正常，其它为错误码	
}

#修改军团申请限制
.ModifyJoinLimit
{
	levelLimit    0 : integer    #等级限制
	powerLimit    1 : integer    #战力限制
	autoAllow     2 : integer    #自动允许申请
}
.ModifyJoinLimitR
{
	err 0 : integer 			#0为正常，其它为错误码	
}



#红点更新
.SendRedPointR
{
	flag 0 : integer  			#红点标识  0表示撤销申请列表红点，1表示添加申请列表红点
}


#---------------------------以下暂时不用
#刷新军团
.UpdateBaseInfoR
{
	alliance 1 : Alliance 		#军团信息
}


#军团视角的邀请
.InviteA
{
	roleId 0 : integer 			#角色id
	name 1 : string 			#角色名字
	power 2 : integer			#角色战斗力
	head 3 : string 			#头像	
	inviteTime 4 : integer 		#邀请时间	
}

#获取邀请列表(军团视角)
.GetInviteListA
{
}

.GetInviteListAR
{
	inviteList 0 : *InviteA		#邀请列表
}

#玩家视角的邀请
.InviteP
{
	fromName 0 : string 		#发出邀请的角色名字
	inviteTime 1 : integer 		#邀请时间
	alliance 2 : Alliance 		#邀请的军团信息
}

#获取邀请列表(玩家视角)
.GetInviteListP
{
}

.GetInviteListPR
{
	inviteList 0 : *InviteP		#邀请列表
}

#查找玩家
.SearchPlayer
{
	keyWord 0 : string 			#关键字
}

.SearchPlayerR
{
	roleId 0 : integer 			#角色id
	name 1 : string 			#角色名字
	power 2 : integer			#角色战斗力
	head 3 : string 			#头像
	id 4 : string 				#军团id
	isInvite 5 : boolean		#是否邀请过
}

#邀请玩家加入军团
.InviteJoin
{
	name 0 : string 			#邀请的角色名字
}

.InviteJoinR
{
	err 0 : integer 			#0为正常，其它为错误码
}

#撤销邀请
.CancelInvite
{
	roleId 0 : integer 			#玩家id
}

.CancelInviteR
{
	err 0 : integer 			#0为正常，其它为错误码
}

#回复邀请
.InviteReply
{
	id 0 : string   			#军团id
	result 1 : boolean  		#回复结果
}

.InviteReplyR
{
	err 0 : integer 			#0为正常，其它为错误码
}




#检测名字
.CheckName
{
	name 0 : string				#军团名字
	shortName 1 : string 		#军团缩写
}

.CheckNameR
{
	err 0 : integer 			#0为正常，其它为错误码		
}

.CollectTaskItem
{
	itemCode 0 : integer 		#物品id
	itemNum 1 : integer 		#所需数量
	currNum 2 : integer 		#当前数量
	rewardDonate 3 : integer 	#奖励贡献
	rewardExp 4 : integer 		#奖励经验
	rewardCoin 5 : integer 		#奖励铜币
}

#升级军团
.UpGrade
{

}

.UpGradeR
{
	err 0 : integer 			#0为正常，其它为错误码	
}

.GetTrainInfo
{
	
}

.Train
{
	type    0 : integer 		#修炼类型
	addType 1 : integer			#增加类型 1:单次 2:一键
}

#修炼升级
.TrainR
{
	trainLevel 1 : *integer
	trainExp 2 : *integer
}

#修炼结果
.TrainResultR
{
	err 0 : integer 			#0为正常，其它为错误码
	type 1 : integer 			#类型
	addExp 2 : integer 			#增加的经验
	currExp 3 : integer 		#当前经验
	currLevel 4 : integer 		#当前等级
	addTimes 5 : integer        #成功修炼的次数
}

#使用物品修炼升级
.TrainInItem
{
	type 0 : integer 			#类型
}

#装备属性构造体
.EquipAttrR
{
	attr 0 : integer  #属性 为enum.COMBAT_ATTR 中的值
	value 1 : integer #数值
}

#军团仓库装备构造体
.Equip
{
	guid 			0 : integer 			#唯一id
	num 			1 : integer				#数量（一般情况下=1)
	protoId 		2 : integer				#对应物品表中的code
	formulaId 		3 : integer				#打造id，对应config/equip_formula中的formulaId
	slot 			4 : integer				#槽
	color 			5 : integer				#品质
	spec 			6 : integer				#特效 为 equip_spec表中的id
	prefix 			7 : integer				#前缀 为 enum.EQUIP_PREFIX_TYPE 中的值
	baseAttr 		8 : *EquipAttrR			#基础属性
	exAttr 			9 : *EquipAttrR			#额外属性(HJS)
	needStorePoint	10: integer				#兑换所需仓库积分
}

#兑换/捐献记录构造体
.StoreRecordR
{
	type 		0 : integer 		#记录类型 1捐献 2兑换 3销毁 enum.ALLIANCE_STORE_RECORD_TYPE
	time 		1 : integer 		#时间戳
	roleName 	2 : string 			#角色名
	protoId 	3 : integer 		#装备id
	color 		4 : integer 		#装备颜色
}

#获取军团仓库
.GetStoreItemList
{
}
.GetStoreItemListR
{
	items 		0 : *Equip
}

#获取军团仓库记录
.GetStoreRecord
{
}
.GetStoreRecordR
{
	record 		0 : *StoreRecordR 	#兑换/捐献记录 最多100条
}

#后端主动推仓库更新
.StoreRecordUpdateR
{
	record 		0 : *StoreRecordR 	#兑换/捐献记录
	items 		1 : *Equip 			#更新捐献时 需要把装备整个发过去
	guidList 	2 : *integer 		#更新兑换时 只需要发送guid
}

#捐献物品到军团仓库
.AddItemToStore
{
	guidList 	0 : *integer 		#物品唯一id列表
}
.AddItemToStoreR
{
	err 		0 : integer 		#0-成功，其他为错误码
	guidList 	1 : *integer 		#物品唯一id列表
}

#兑换仓库里的装备
.ExchangeStoreItem
{
	guid 		0 : integer 		#物品唯一id
}
.ExchangeStoreItemR
{
	err 		0 : integer 		#0-成功，其他为错误码
	guid 		1 : integer 		#兑换成功返还guid
}

#销毁仓库里的装备
.DestoryStoreItem
{
	guidList 	0 : *integer 		#物品唯一id列表
}
.DestoryStoreItemR
{
	err 		0 : integer 		#0-成功，其他为错误码
	guidList 	1 : *integer 		#物品唯一id列表
}

#提交军团每日任务
.HandInDailyTask
{
}

.HandInDailyTaskR
{
	err 0 : integer #0-成功,其他为错误码
}

#军团仓库竞拍出价
.AllianceAuctionOffer
{
	index 0 : integer    #竞拍物品序号
	price 1 : integer    #竞拍出价
}
.AllianceAuctionOfferR
{
	err   0 : integer    #0-成功,其他为错误码
}

#接受军团重复任务
.AllianceAcceptRepeatTask
{
}
.AllianceAcceptRepeatTaskR
{
	err             0 : integer    #0-成功,其他为错误码
	repeatTaskTimes 1 : integer    #当前是第几个任务 上限10
}

#军团篝火晚会请客喝酒
.AllianceNeedfireDrink
{
}
.AllianceNeedfireDrinkR
{
	err             0 : integer    #0-成功,其他为错误码
}

#军团宴会放烟花
.AlliancePartyFirework
{
}
.AlliancePartyFireworkR
{
	err             0 : integer    #0-成功,其他为错误码
}

#篝火晚会问题构造体
.NeedfireQuestionObj
{
	code            1 : integer    #问题编号
	answer_1        2 : string     #答案1
	answer_2        3 : string     #答案2
	answer_3        4 : string     #答案3
	answer_4        5 : string     #答案4
	questionNo      6 : integer    #当前题目是本次篝火晚会的第几题
	endTime         7 : integer    #当前题目结束时间
	chooseCode      8 : integer    #这一题已经回答过 所选的项
	rightIndex      9 : integer    #这一题已经回答过 正确答案
}

#军团篝火晚会请求问题
.AllianceNeedfireGetQuestion
{
}
.AllianceNeedfireGetQuestionR
{
	err             0 : integer                #0-成功，其他为错误码
	questionObj     1 : NeedfireQuestionObj    #篝火晚会问题构造体
}

#军团篝火晚会回答问题
.AllianceNeedfireAnswerQuestion
{
	questionNo      0 : integer #回答第几题
	chooseCode      1 : integer #玩家选的序号 1234
}
.AllianceNeedfireAnswerQuestionR
{
	err             0 : integer #0-成功，其他为错误码
	rightIndex      1 : integer #正确答案序号 1234
}

#军团篝火晚会投骰子
.AllianceNeedfireDice
{
}
.AllianceNeedfireDiceR
{
	err             0 : integer #0-成功，其他为错误码
	diceNo          1 : integer #点数
}

#开始活动或者活动期间进入领地 主动推需要显示在任务栏的内容
.AllianceLegionActInfoR
{
	actType         0 : integer    #活动类型 1-篝火晚会 2-宴会 enum.ALLIANCE_LEGION_ACT_TYPE
	legionPlrCount  1 : integer    #当前领地内人数
	expCoef         2 : integer    #当前经验加成系数
	endTime         3 : integer    #结束时间
	questionNo      4 : integer    #答题进度 当前是第几题
	rightTimes      5 : integer    #答题正确次数
	diceNo          6 : integer    #骰子点数 3个数字直接拼起来
	eatTimes        7 : integer    #已吃佳肴次数
	diliverTimes    8 : integer    #送菜次数
}

#更新领地活动信息 各字段都可缺省
.AllianceUpdateLegionActInfoR
{
	actType         0 : integer    #活动类型 1-篝火晚会 2-宴会 enum.ALLIANCE_LEGION_ACT_TYPE
	legionPlrCount  1 : integer    #当前领地内人数
	expCoef         2 : integer    #当前经验加成系数
	questionNo      3 : integer    #答题进度
	rightTimes      4 : integer    #回答正确次数
	eatTimes        5 : integer    #已吃佳肴次数
	diliverTimes    6 : integer    #送菜次数
}

#尝试采集领地活动地图元素 宝箱 食物 散财童子等
.AllianceCollect
{
	type            0 : integer    #采集物类型 1-宝箱 2-食物 3-散财童子
	guid            1 : integer    #采集物guid
}
.AllianceCollectR
{
	err             0 : integer    #0-可采集, 其他为错误码
	guid            1 : integer    #采集物guid
}

#尝试接取宴会送菜任务
.AlliancePartyGetTask
{
}

#军团捐献
.AllianceDevote
{
	code            0 : integer    #捐献类型
}
.AllianceDevoteR
{
	err             0 : integer    #0-成功，其他为错误码
	devoteTimes     1 : integer    #今日已捐献次数
	fund            2 : integer    #捐献后军团贡献值
}

#军团战旗鼓舞
.WarFlagInspire
{
}
.WarFlagInspireR
{
	err                0 : integer    #0-成功，其他为错误码
	inspireTimes       1 : integer 	 #今日鼓舞次数
	inspireExpiredTime 2 : integer 	 #鼓舞到期时间
}

#军团战旗升级
.WarFlagLevelUp
{
}
.WarFlagLevelUpR
{
	err             0 : integer   #0-成功，其他为错误码
}

#增加军团资金
.AllianceAddFundR
{
	addFund         0 : integer   #增加的值
	curFund         1 : integer   #增加后当前军团资金
}

#弹劾统帅
.Impeach
{
}
.ImpeachR
{
	err 			0 : integer   #0-成功，其他为错误码
}

#上交口粮
.HandInLegionBossFood
{
}
.HandInLegionBossFoodR
{
	err 			0 : integer   #0-成功，其他为错误码
}

#后端主动推口粮更新
.UpdateLegionBossFoodR
{
	food 			0 : integer	  #当前口粮数
}

#开启军团兽神boss
.StartLegionBoss
{
}
.StartLegionBossR
{
	err 			0 : integer   #0-成功，其他为错误码
}

#后端主动推兽神出现给所有本军团玩家
.AnnounceLegionBossStartR
{
}


]]