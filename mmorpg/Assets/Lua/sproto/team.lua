--组队协议

local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

.Member
{
	roleId 0 : integer
	name 1 : string
	level 2 : integer
	career 3 : integer
	head 4 : string
	mapId 5 : integer
	power 6 : integer
	maxHp 7 : integer
	hp 8 : integer         #当前血量
	matching 9 : boolean   #true为组队状态中
	posX 10 : integer         #当前位置x
	posY 11 : integer         #当前位置y
}

.Team
{
	teamId 0 : integer
	leader 1 : integer
	members 2 : *Member
	target 3 : integer
	powerLimit 4 : integer
	autoAgree 5 : boolean
}

#获取所在队伍信息
.GetPlayerTeam
{
}

.GetPlayerTeamR
{
	team 0 : Team    #为nil则是还没组队
}

#创建队伍
.CreateTeam
{	
}

.CreateTeamR
{
	team 0 : Team
}

#请求入队
.JoinTeamReq
{
	teamId 0 : integer
}

.JoinTeamReqR
{
	err 0 : integer #0为申请成功
}

#入队申请通知（发送给队长）
.JoinTeamReqNoticeR
{
	name 0 : string #申请人
}

#队长回应入队请求
.ReplyJoinTeam
{
	roleId 0 : integer
	agree 1 : boolean    #false为拒绝，true为同意
}

.ReplyJoinTeamR
{
	err 0 : integer
}

#队长全部拒绝
.RejectAllApply
{
}

#拒绝加队(发送给申请人)
.RejectJoinTeamR
{
	name 0 : string     #队长名
}

#成功加入队伍
.JoinTeamResultR
{
	team 0 : Team
}

#邀请某人入队
.InviteJoinTeam
{
	roleId 0 : integer
}

.InviteJoinTeamR
{
	err 0 : integer #错误码
}

#邀请入队通知(发送给被邀请人)
.InviteNoticeR
{
	team 0 : Team
}

#回应邀请
.ReplyInvite
{
	teamId 0 : integer
	agree 1 : boolean      #0为拒绝,1为同意
}

.ReplyInviteR
{
	err 0 : integer        #错误码
}

#拒绝邀请（发送给邀请人）
.RejectInviteR
{
	name 0 : string       #玩家名
}

#玩家一键拒绝所有邀请
.RejectAllInvite
{
}

#请求离开队伍
.LeaveTeamReq
{
}

.LeaveTeamR
{
	roleId 0 : integer  #广播给所有队员
	kick 1 : boolean #true 为被踢
}


#获取周围队伍信息
.GetNearTeam
{
}

.GetNearTeamR
{
	teamList 0 : *Team
}

.RoleInfo 
{
	roleId 0 : integer
	name 1 : string
	level 2 : integer
	power 3 : integer
	head 4  : string
}

#查看申请列表
.GetApplyList
{
}

.GetApplyListR
{
	roleList 0 : *RoleInfo
}

#一键申请
.OneKeyApply
{
	target 0 : integer
}

#切换目标
.ChangeTarget
{
	target 0 : integer
}

.ChangeTargetR
{
	target 0 : integer  #广播给所有队员
}

#将队员踢出队伍
.KickMember
{
	roleId 0 : integer
}

#设置自动同意
.AutoAgree
{
	autoAgree 0 : boolean #自动同意为true, 非自动同意为false
}

#请求某一目标的队伍列表
.TargetTeamList
{
	target 0 : integer    #目标
}

.TargetTeamListR
{
	team 0 : *Team 
}

#切换队长
.ChangeLeader
{
	newLeader 0 : integer   #新队长
}

.ChangeLeaderR
{
	newLeader 0 : integer   #将来的队长（广播）
}

#切换战力限制
.ChangePowerLimit
{
	newLimit 0 : integer
}

.ChangePowerLimitR
{
	newLimit 0 : integer  #广播给所有队员
}

#附近玩家
.GetNearRoleList
{
}

.GetNearRoleListR
{
	roleList 0 : *RoleInfo  #
}

#成员属性变化广播
.MemberAttrChangeNotifyR
{
	member 0 : Member  #Member里面的字段，哪个有变化发哪个，并不会全部都发
}


#队长请求准备进入副本
.TeamCopyReady
{
	copyCode 0 : integer
}

.TeamCopyReadyR
{
	err 0 : integer
}

#广播准备进入副本通知
.TeamCopyReadNotifyR
{
	copyCode 0 : integer
	expire 1 : integer #过期时间
}

#获取今日进入组队副本次数
.TeamCopyPassTimes
{
}

.TeamCopyPassTimesR
{
	times 0 : integer
}


#队员回复是否确认
.TeamCopyAgree
{
	agree 0 : boolean  #false 为拒绝
}

.TeamCopyAgreeR
{
	err 0 : integer 
}

#队员拒绝/同意进入副本通知
.TeamCopyAgreeNotifyR
{
	agree 0 : boolean
	roleId 1 : integer  #队员id
	name 2 : string
}

#通知可以进入组队副本
.TeamCopyCanEnterNotifyR
{
	copyCode 0 : integer
}

#组队自动匹配
.TeamAutoMatch
{
	matching 0 : boolean  #组队true/取消false
	target 1 : integer
}

.TeamAutoMatchR
{
	matching 0 : boolean #组队true/取消false
}

#队长召唤跟随
.SummonFollow
{
}

.SummonFollowR
{
	err 0 : integer
}

#召唤跟随广播
.RequestFollowNotifyR
{
}

#队员同意/请求跟随
.FollowLeader
{
	agree 0 : boolean #true为跟随，false为取消跟随
}

.FollowLeaderR
{
	agree 0 : boolean #true为跟随，false为取消跟随
}

#请求队长位置
.LeaderPositionReq
{
} 

.LeaderPositionReqR
{
	err 0 : integer  #非0为不可达
	mapId 1 : integer
	posX 2 : integer
	posY 3 : integer
}


#-----------------------------------------------------------------
#请求匹配组队对战副本
.TeamVsCopyMatch
{
}

.TeamVsCopyMatchR
{
	err 0 : integer #错误码
	expireTime 1 : integer #过期时间
}

.TeamVsCopyCancelMatch
{
}

.TeamVsCopyCancelMatchR
{
	err 0 : integer
}

.MemberSimpleInfo
{
	roleId 0 : integer
	name 1 : string
	level 2 : integer
	career 3 : integer
}

#通知匹配成功
.TeamVsCopyMatchSuccessNotifyR
{
	teamInfo 0 : *MemberSimpleInfo
}


]]
