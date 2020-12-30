-- 好友相关协议

local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

.Friend
{
	roleId 0 : integer		# 
	name 1 : string			# 名称
	head 2 : integer		# 头像
	level 3 : integer		# 等级
	power 4 : integer		# 战力
	logoutTm 5 : integer	# 下线时间
	intimacy 6 : integer    # 亲密度
	animosity 7 : integer   # 仇恨度
	vipLevel 8 : integer    #vip等级
}


#取好友列表,应该只需要打开面板的时候取一次
.GetFriendList
{
}
.GetFriendListR
{
	list 0 : *Friend			# 好友列表
	strengthGivens 1 : *integer	# 已赠送体力的好友id
}

#推荐好友列表
.GetRecommendList
{
}
.GetRecommendListR
{
	list 0 : *Friend			# 推荐列表
}

#好友申请列表
.GetApplyList
{
}
.GetApplyListR
{
	list 0 : *Friend			# 申请列表

}

#仇人列表
.GetEnemyList
{
}

.GetEnemyListR
{
	list 0 : *Friend
}

#黑名单列表
.GetBlackList
{
}

.GetBlackListR
{
	list 0 : *Friend			# 好友列表
}

#可领体力列表
.StrengthList
{

}

.StrengthListR
{
	todayGet 0 : integer   #今日已领
	leftCount 1 : integer  #当前可领
}

#申请好友
.ApplyFriend
{
	roleIdList 0 : *integer		# 一次可以申请多个
}

.ApplyFriendR
{
	err 0 : integer		
}

#申请好友推送
.ApplyFriendNotifyR
{
	friend 0 : Friend 			#别人申请好友
}

#回复答应申请好友
.ReplyApply
{
	agreeId 0 : integer			#同意列表, 0全部同意
	rejectId 1 : integer		#拒绝列表, 0全部拒绝
}
.ReplyApplyR
{
	err 0 : integer
}

#删除好友
.DeleteFriend
{
	roleId 0 : integer			
}
.DeleteFriendR
{
	err 0 : integer	
	roleId 1 : integer			#删除的好友	
}

#拉黑好友
.BlackFriend
{
	roleId 0 : integer		
}
.BlackFriendR
{
	err 0 : integer
}

#解除黑名单
.RelieveBlackList
{
	roleId 0 : integer
}
.RelieveBlackListR
{
	err 0 : integer
}

#赠送体力
.GiveStrength
{
	roleId 0 : integer			#0全部赠送
}
.GiveStrengthR
{
	err 0 : integer
}

#领取体力
.GetStrength
{
}
.GetStrengthR
{
	err 0 : integer
}

#删除仇人
.DeleteEnemy
{
	roleId 0 : integer
}

.DeleteEnemyR
{
	err 0 : integer
}

#查找玩家
.FindPlayer
{
	name 0 : string				#玩家名字
}
.FindPlayerR
{
	friend 0 : *Friend			#查到的玩家
}

#添加好友成功推送
.AddFriendR
{
	friend 0 : Friend 			
	give 1 : integer			#0可以赠送，1已赠送
}

#好友系统预读
.FriendPreread
{
}
.FriendPrereadR
{
	give 0 : integer 			#1有赠送,0无
	apply 1 : integer			#1有申请,0无
	dailyGet 2 : integer        #今天领取体力次数
	offlineNew 3 : integer      #离线时是否有人添加好友
}

#被赠送体力提示
.BeGiveR
{
	roleId 0 : integer			#赠送者id
}

#私聊
.Chat
{
	roleId 0 : integer			#对谁说
	content 1 : string			#内容
}

#也可以推送
.ChatR
{
	err 0 : integer
	friend 1 : Friend 			#说话人信息
	content 2 : string			#内容
	tm 3 : integer				#时间
	toRoleId 4 : integer        #说话对象id
	surfaceTalkBg 5 : integer   #说话人使用的气泡
}

#聊天记录项
.ContentItem
{
	tm      0 : integer				#时间戳
	content 1 : string				#内容
	roleId  2 : integer             #说话的roleId
	surfaceTalkBg 5 : integer       #说话人使用的气泡
}

#取聊天记录
.GetChatRecord
{
	roleId 0 : integer			#和谁的聊天记录
}
.GetChatRecordR
{
	roleId 0 : integer			 #和谁的聊天记录
	contentList 1 : *ContentItem #聊天记录
}

#取聊天列表
.GetChatList
{
}

.GetChatListR
{
	list 0 : *Friend 
	num 1 : *integer     #未读条数
}

#取多个玩家信息
.GetFriendInfo
{
	roleId 0 : *integer
}

.GetFriendInfoR
{
	list 0 : *Friend
}

.HasRead
{
	roleId 0 : integer   #和谁的聊天记录
}

.HasReadR
{
}

#赠送鲜花
.GiveFlower
{
	roleId 0 : integer         #给谁
	flowerColor 1 : integer    #鲜花品质
	num 2 : integer            #鲜花数量
	autoBuy 3 : boolean        #是否自动购买
}

#返回给赠送者
.GiveFlowerR  
{
	err      0 : integer
	intimacy 1 : integer       #亲密度 A送花给B 返回A对B的亲密度
}

#推送给受赠者
.GetFlowerNoticeR
{
	roleId 0 : integer #赠送者id
	name 1 : string #赠送者名字
	head 2 : integer #头像
	level 3 : integer 
	flowerCode 4 : integer #鲜花code
	num 5 : integer  
}

#鲜花特效广播给附近玩家
.FlowerEffectBroadcastR
{
	flowerCode 0 : integer
	roleId 1 : integer
}


]]