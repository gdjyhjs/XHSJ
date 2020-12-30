--场景协议

local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

.Buff
{
	buffId 		0 : integer 	#
	updateType 	1 : integer 	#更新类型 enum.buff_update_type
	casterId 	2 : integer 	#释放者id
	ownerId 	3 : integer 	#buff承受者id
	expireTime 	4 : string 	    #过期时间 由精确到秒改成了精确到0.1秒
	duration 	5 : integer 	#持续时间 暂时只用在需要显示特效的buff上 精确到0.1秒
	cumulateEffect 6 : integer     #效果叠加次数 
}

.Player
{
	name 0 : string     #名字
						#公会
	buffList 1 : *Buff  #buff
	    
}

.Creature
{
	buffList 0 : *Buff  #buff
	title 1 : integer   #称号id
	name 2 : string     #名字
	cloneInfo 3 : *integer  #对应enum.PLAYER_CLONE_FIELDS，克隆怪（竞技场）才有
}

#地图加载完成
.OnMapLoaded
{
}


#需要同步的数据
.Object 
{
	updateType  0 : integer     #变更类型，对应enum.OBJECT_UPDATE_TYPE, 为1的话不发下列的(2-9)
	guid        1 : integer     #唯一id
	objType     2 : integer     #obj类型，对应enum.OBJ_TYPE
	x			3 : integer     #坐标x
	y			4 : integer     #坐标y
	dir         5 : integer(2)  #方向
	moveMode    6 : boolean     #false 为不动，true为移动中
	dstX        7 : integer     #若dstX和dstY都为0则表示没有目的点
	dstY        8 : integer    
	playerInfo  9 : Player      #如果objType是player才有此数据
	creatureInfo 10 : Creature  #如果objType是怪物才有此数据
	ownerGuid 11 : integer      #主人guid（武将的数据）
	updateMask 12 : *integer    #有数据变更的数组下标，对应enum.OBJ_FIELDS,enum.UNIT_FIELDS,enum.PLAYER_FIELDS
	updateValue  13 : *integer  #变更后的数据
}

#创建,更新,移除通用协议
.UpdateObjectR
{
	objList 0 : *Object
}


#请求移动
.PlayerMove
{
	srcX 0 : integer
	srcY 1 : integer
	dir  2 : integer(2)    #角度（顺时针）
	mode 3 : boolean       #false为停止移动，true为移动中
	dstX 4 : integer       #两种方式(发dir和mode, 或dstX和dstY)
	dstY 5 : integer 
}

.MoveObj
{
	guid 0 : integer
	srcX 1 : integer        #
	srcY 2 : integer
	dir  3 : integer(2)     #角度
	mode 4 : boolean        #转发方式同上
	dstX 5 : integer
	dstY 6 : integer     
}

#对象移动广播
.ObjectMoveR
{
	objList 0 : *MoveObj   
}

#重置玩家到指定位置(防作弊拉扯）
.RelocatePlayerPosR
{
	posX 0 : integer   #
	posY 1 : integer   #	
}

#角色状态变更通知
.DynamicFlagChangedR
{
	flag 0 : integer  #状态改变对应enum.unit_dynamic_flag
	add 1 : boolean   #true为添加，false为删除
}


#切换地图
.TransferMap
{
	srcMap 0 : integer   
	dstMap 1 : integer
	dstX   2 : integer
	dstY   3 : integer
	type   4 : integer      #传送类型 对应enum.TRANSFER_MAP_TYPE
}

.TransferMapR
{
	err 0 : integer    #0返回无错误，客户端可以做切换
	dstMap 1 : integer
	dstX 2 : integer
	dstY 3 : integer
	dstCopyCode 4 : integer #如果是副本则会返回，否则为nil
}

#复活
.Respawn
{
	type 0 : integer   #1恢复点恢复，2原地复活（付费）
}

.RespawnR
{
	guid 0 : integer   #成功复活则广播
	hp   1 : integer   #当前血量
	posX 2 : integer   #复活点x
	posY 3 : integer   #复活点y
}

#设置挂机配置
.SetAutoCombatConf
{
	config 0 : *integer   #{吃药血量(百分比*100), 自动原地复活(0/1), 武将自动攻击(0/1)}
}

.SetAutoCombatConfR
{
	err 0 : integer
}

.GetAutoCombatConf
{
}

.GetAutoCombatConfR
{
	config 0 : *integer
}

.ClickAutoCombat
{
	oper 0 : integer #0为终止,1为开始
}

#客户端请求行走的下一个目标点
.AutoCombatNextPos
{
}

.AutoCombatNextPosR
{
	posX 0 : integer
	posY 1 : integer
}

#请求设置pk模式
.SetPkMode
{
	mode 0 : integer
}

.SetPkModeR
{
	err 0 : integer
	mode 1 : integer   #也可以主动推送
}

#此协议广播给周围玩家和自己
.CombatStatusChangeR
{
	guid 0 : integer    #unit的guid
	isInCombat 1 : boolean #true为在战斗状态
}

#播放转镜协议
.StopAiUpdate
{
	interval 0 : integer #时长(毫秒)
}

#取消转镜协议
.ContinueAiUpdate
{
}


#----------------------------任务相关begin---------------------------------
#到达地图上的某个点进行某个行动
.Destination
{
	type     0 : integer  #行动类型
	guid     1 : integer  #目标物guid
	taskCode 2 : integer  #任务code
}

#请求与npc对话
.GossipWithNpc
{
	code 0 : integer   #npc的原型id，注意是原型id
}

#--------------------------任务相关end------------------------------------


#-------------------------------skill begin------------------------------

#请求当前技能列表
.GetSkillList
{
}

.GetSkillListR
{
	skillList 0 : *integer  #前8个分别代表当前8个技能, 为0表示还没解锁；8之后的表示被动技能（附加技能）
}

.TagCoolDown
{
	cdType 0 : integer #对应enum.CD_TYPE
	code 1 : integer   #技能code或者物品guid
	expireTime 2 : integer #冷却完成时间
}

#技能冷却时间
.SkillCoolDownR
{
	coolDownList 0 : *TagCoolDown 
}

#技能升级
.SkillLevelUp
{
	skillIndex 0 : integer   #skillIndex
}

.SkillLevelUpR
{
	err 0 : integer
}

#全部升级
.OneKeySkillLevelUp
{
}

.OneKeySkillLevelUpR
{
	err 0 : integer	
}

#学习技能(暂时不用)
.LearnSkill
{
	skillIndex 0 : integer  #skill index
}

.LearnSkillR
{
	err 0 : integer
}

#玩家/宠物请求释放技能
.SkillCast
{
	code 0 : integer           #技能id
	posX 1 : integer           #当前坐标x
	posY 2 : integer           #当前坐标y
	dir 3 : integer            #当前方向
	target 4 : integer         #已知目标
	caster 5 : integer         #释放者
}



#通知buff更新
.BuffUpdateR
{
	buff 0 : Buff                 #buff更新
}

#失败只返回给释放者，成功则广播
.SkillCastR
{
	err 0 :     integer         #结果
	caster 1 : integer          #释放者
	skillId 2 : integer         #技能id
	posX 3 : integer            #释放者坐标x
	posY 4 : integer            #释放者坐标y
	dir 5: integer              #释放者方向
	target 6 : integer          #目标
}

#受攻击对象处理结果
.TargetResult
{
	guid 0 : integer           #对象id
	result 1 : integer         #躲闪，命中，暴击
	damage 2 : integer         #伤害值
	posX 3 : integer           #目标x
	posY 4 : integer           #目标y
	action 5 : integer         #目标的受击动作
}

#返回技能处理结果（广播）
.SkillCastResultR
{
	caster 0 : integer          #释放者code
	skillId 1 : integer         #技能id
	target 2 : *TargetResult    #技能处理结果
	leadIndex 3 : integer       #引导下标(通常为1，多段伤害则>1)
}
#-----------------------------skill end------------------------------------

#-----------------------------世界boss begin---------------------------------
.WorldBossInfo
{
	bossId 0 : integer 
}

.WorldBossInfoR
{
	refreshTime 0 : integer 
	highestHurtName 1 : string #最高伤害
	killerName 2 : string #最后一击
}

#伤害列表
.WorldBossHurtListR
{
	.TeamRankInfo
	{
		name 0 : string #队长名
		hurt 1 : integer #伤害(百分比*100)
		isLeader 2 : boolean #是否是队长
	}

	.AllianceRankInfo
	{
		name 0 : string #军团名
		hurt 1 : integer #伤害(百分比*100)
	}

	bossName 0 : string #boss名字
	bossHp 1 : integer   #boss血量(百分比*100)
	teamRank 2 : *TeamRankInfo
	allianceRank 3 : *AllianceRankInfo
}

#boss界面信息
.MagicBossInfo
{
	bossCode 0 : integer
}

.MagicBossInfoR
{
	tired 0 : integer #疲劳值
	killerNameL 1 : *string #击杀玩家
	focus 2 : boolean #关注
}

#关注/取消关注
.MagicBossFocus
{
	bossCode 0 : integer 
	focus 1 : boolean #true 为关注, false为取消
}

.MagicBossFocusR
{
	err 0 : integer
}

#boss刷新弹框
.MagicBossRefreshNotifyR
{
	bossCode 0 : integer
}

.DropInfo
{
	date 0 : integer
	playerName 1 : string
	bossCode 2 : integer   #boss原型id
	itemCode 3 : integer   #极品code
}

#掉落记录
.DropRecordL
{
}

.DropRecordLR
{
	list 0 : *DropInfo
}

.BossRefreshInfo
{
	bossCode 0 : integer
	refreshTime 1 : integer  #下次刷新时间
}

#boss刷新列表
.MagicBossRefreshList
{
}

#有变更时会主动发
.MagicBossRefreshListR
{
	list 0 : *BossRefreshInfo #刷新列表
}



#-----------------------------世界boss end---------------------------------

#-----------------------------rest begin------------------------------------
#情景：(玩家A邀请玩家B,玩家C等等 进行打坐  玩家A,B有操作 玩家C为吃瓜群众  变量名带 A,B,C为玩家A,B,C的缩写

#打坐时邀请和被邀请时双方需要展现的信息
.InviteRoleInfo
{
	roleId 0 : integer
	name 1 : string
	level 2 : integer
	bIntAutoAccept 3 : integer
	head 4 : string
	intimacy 5 : integer          #友好度  当==-1时，为非好友的好友度
}

#开始
.StartRest
{
	ARoleId 0 : integer           #当双人打坐开始时 玩家B发送此协议需带ARoleId （单人打坐发0)
}
.StartRestR
{
	err 0 : integer
	startTimeStamp 1 : integer    #开始打坐的时间轴
	ARoleId 2 : integer           #玩家A邀请玩家B进行打坐  a与b的缩写以此作为情景
}

#获取打坐获得的经验和等级(供客户定时更新,或关键时刻（如升级）时使用)
.GetRestGain
{
}
#推送时也使用这个返回
.GetRestGainR
{
	err 0 : integer
	exp 1 : integer                   #玩家经验
	level 2 : integer                 #
	gains 3 : *integer                #玩家自己的值加上打坐获得值的值  下标：(1：友好度，2：血量)
	timeStamps 4 : *integer           #最后一次计算收益的时间轴  下标：(1：友好度，2：血量,3:经验，) 如果已经停止了，那么都是0
}

#取消打坐
.EndRest
{
}
.EndRestR
{
	err 0 : integer
	exp 1 : integer
	level 2 : integer
	gains 3 : *integer                #玩家自己的值加上打坐获得值的值  下标：(1：友好度，2：血量)
	endTime 4 : integer               #结束时间(当由于攻击和被攻击或行走时服务端自行取消打坐，客户端迟一小会(大概是0~2秒)发送结束打坐时，也返回正确的协议返回。此字段正是此作用)
}

#获取附近可以为邀请的玩家列表
.GetNearRoleList
{

}

#此为GetNearRoleList的错误码返回
.GetNearRoleListR
{
	err 0 : integer
}

#此为含有InviteRoleInfo 的 GetNearRoleList的返回
.NearRoleListR
{
	roleList 0 : *InviteRoleInfo
}

#邀请打坐 
.InviteRest
{
	BRoleId 0 : integer             #玩家A邀请玩家B进行打坐  a与b的缩写以此作为情景
}

.InviteRestR
{
	err 0 : integer
}
#在玩家A邀请玩家B进行打坐时给玩家B的推送(告诉B，有人在邀请他)
.BeInvitedRestR
{
	
}

#接受某人的邀请
.AcceptInviteRest
{
	ARoleId 0 : integer
}

#接受某人的邀请的返回
#当自己设置成自动接受时，当有人邀请玩家B时，玩家B会接受到此协议的推送
.AcceptInviteRestR
{
	err 0 : integer
	mapId 1 : integer              #供自动寻路使用
	x 2 : integer                  #供自动寻路使用
	y 3 : integer                  #供自动寻路使用
	AInfo 4 : InviteRoleInfo        #供自动寻路使用 (玩家B需要玩家A的相关信息)
}

#当接受邀请时 玩家A收到的推送
.AcceptInviteRestAMsgR
{
	BRoleInfo 0 : InviteRoleInfo
}

#获取收到邀请列表
.GetBeInviteList
{

}
.GetBeInviteListR
{
	roleList 0 : *InviteRoleInfo
}

#玩家B拒绝A玩家
.BRefuseAInvite
{
	ARoleId 0 : integer
}

#一键拒绝
.OneKeyRefuseInvite
{

}

.OneKeyRefuseInviteR
{
	err 0 : integer
}

#一键邀请附近玩家
.OneKeyInviteNear
{

}

.OneKeyInviteNearR
{
	err 0 : integer
}

#设置是否自动接受    0：否 1:自动接受
.SetAutoAccept
{
	bIntAutoAccept 0 : integer
}
.SetAutoAcceptR
{
	bIntAutoAccept 0 : integer
}

#设置是否自动邀请    0：否 1:自动邀请
.SetAutoInvite
{
	bIntAutoInvite 0 : integer
}
.SetAutoInviteR
{
	bIntAutoInvite 0 : integer
}

#获取自动接受    0：否 1:自动接受
.GetAutoAccept
{

}
.GetAutoAcceptR
{
	bIntAutoAccept 0 : integer
}

#通知开始或者结束双人打坐 此推送为 双人产生“契约”之后，一方行动影响另一方的推送
#1,B已应邀，但在寻路中途A取消打坐或者B取消寻路 type=2 0为B中途退出 3为没有开始寻路的时候拒绝别人
#2,B已应邀，寻路到目的地之后，B进行打坐 给A的推送 type=1 (done)
#3,A,B在双修中  A或B取消打坐 给另一方的推送 type=2 (done)
.NoticeStartOrEndRest
{
	err 0 : integer                  #错误码只用来做提示
	type 1 : integer                 #类型：1为开始打坐，2为结束打坐
	startTimeStamp 2 : integer       #开始打坐的时间轴
	name 3 : string                  #1时B取消打坐给A发送B的名字
}

#-----------------------------rest end------------------------------------


#-----------------------------title begin------------------------------------
#称号结构体
.Title
{
	code 0      : integer #称号编号
	time 1      : integer #称号获取时间
	validTime 2 : integer #称号到期时间
}

#获取称号协议
.GetTitleList
{
}
.GetTitleListR
{
	titles 			0 : *Title 		#所有称号列表
	newCode 		1 : integer 	#需要提示新获得的称号 
	expiredCode 	2 : integer 	#需要提示过期的称号
}

#更新消息推送
#只有newTitle：传新称号，只有delCode：称号过期，两者都有：获得新称号时删除同组称号
.UpdateTitleInfoR
{
    newTitle 		0 : Title 		#可缺省 新称号
    expiredCode 	1 : integer 	#可缺省 同组需要删除的称号编号/过期称号
}

#穿戴称号
.TakeonTitle
{
	code 0 : integer #称号编号 当与当前称号一致时-卸下该称号
}
.TakeonTitleR
{
	err  0 : integer #0-成功,其他为错误码
	code 1 : integer #成功回传称号编号
}

#-----------------------------title end------------------------------------

#-----------------------------触碰怪 begin------------------------------
.Touch
{
	guid            0 : integer   #触碰到的guid
}

#-----------------------------触碰怪 end--------------------------------

#-----------------------------场景特效 begin------------------------------
#后端主动通知前端播放场景特效
.SceneSpecialEffectsR
{
	code            0 : integer   #特效id
	posX            1 : integer   #播放位置X坐标
	posY            2 : integer   #播放位置Y坐标
}

#-----------------------------场景特效 end--------------------------------

#---------------------------绝地挂机begin------------------------------
#获取魔狱绝地（挂机地图）系统消息
.GetDeathtrapInfo
{
}
.GetDeathtrapInfoR
{
	validTime 		0 : integer 	#十倍经验剩余时间
	itemUsedCount 	1 : integer 	#经验时间药今日使用次数
}

.DeathtrapInspire
{
}
.DeathtrapInspireR
{
	err 			0 : integer 	#0-成功,其余为错误码
}

#-----------------------------绝地挂机end--------------------------------
]]
