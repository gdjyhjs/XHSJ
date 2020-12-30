--[[
	组队数据模块
	create at 17.5.22
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local CryptographHelper = Hugula.Cryptograph.CryptographHelper

local team = LuaItemManager:get_item_obejct("team")
require("models.team.teamConfig")
require("models.team.testReceive")
team.priority = ClientEnum.PRIORITY.TEAM 
local modelName = "team"


local commomString =
{
	[1] = gf_localize_string("%s拒绝加入你的队伍"),
	[2] = gf_localize_string("%s拒绝你的入队申请"),
	[3] = gf_localize_string("你加入了%s的队伍"),
	[4] = gf_localize_string("%s加入了你的队伍"),
	[5] = gf_localize_string("%s离开了你的队伍"),
	[6] = gf_localize_string("%s申请加入你的队伍"),
	[7] = gf_localize_string("%s邀请你加入队伍"),
	[8] = gf_localize_string("申请已发送"),
	[9] = gf_localize_string("邀请已发送"),
	[10] = gf_localize_string("队伍已满"),
	[11] = gf_localize_string("你的队伍已满员"),
	[12] = gf_localize_string("你已经升为队长"),
	[13] = gf_localize_string("你被踢出队伍"),
	[14] = gf_localize_string("对方已成为队长"),
	[15] = gf_localize_string("%s拒绝进入副本"),
	[16] = gf_localize_string("取消进入副本"),
	
}
 
--UI资源
team.assets=
{
    View("teamView", team),
}

--点击事件
function team:on_click(obj,arg)
	print("model onclick:",obj.name)
	return self:call_event("team_view_on_click", false, obj, arg)
end

--初始化函数只会调用一次
function team:initialize()
	-- require("models.dataUse.mapMonsterDataUse")
	self.teamInfo = {}  				--组队信息
	self.inviteList = {}
	self.jointTeamList = {}				--入队申请 用于记录当前有多少人申请加入队伍 主要是实现主界面的红点
	self.follow = false
end













--[[
	get set ****************************************************************************************************
]]

--判断队伍是否是自己的队伍
function team:is_my_team(teamId)
	local data = self:getTeamData()
	return data.teamId == teamId
end

--获取组队数据
function team:getTeamData()
	return self.teamInfo
end

function team:getLeaderInfo()
	for i,v in ipairs(self.teamInfo.members or {}) do
		if v.roleId == self.teamInfo.leader then
			return v
		end
	end
	return nil
end

--获取邀请列表
function team:getInviteList()
	return self.inviteList
end
function team:setInviteList()
	self.inviteList = {}
end
--获取队长名字
function team:getLeaderName()
	for i,v in ipairs(self.teamInfo.members or {}) do
		if v.roleId == self.teamInfo.leader then
			return v.name
		end
	end
	return ""
end
--设置自动加入属性
function team:setAutoAgreeFlag(flag)
	self.teamInfo.autoAgree = flag
end 
function team:is_one_self()
	local my_role_id = gf_getItemObject("game"):getId()
	if my_role_id == self.teamInfo.leader and #self.teamInfo.members == 1 then
		return true
	end 
	return false
end
--设置队长
function team:setLeader(leaderId,sid)
	local p_roleId = self.myChangeId
	local my_role_id = gf_getItemObject("game"):getId()
	if my_role_id == leaderId then
		gf_message_tips(commomString[12])
	end
	if p_roleId and p_roleId == my_role_id then
		self.myChangeId = nil
		gf_message_tips(commomString[14])
	end
	if next(self.teamInfo.members or {}) then
		self.teamInfo.leader = leaderId
	end

	if self:is_follow() then
		local battle = LuaItemManager:get_item_obejct("battle")
		if leaderId == battle:get_character().guid then
			self:set_follow(false)
		else
			battle:get_character():set_follow_target(battle:get_model(leaderId))
		end
	end
end

function team:set_param(...)
	self.param = {...}
end

function team:get_param()
	return self.param
end

--设置战力
function team:setPower(power)
	self.teamInfo.powerLimit = power
end
--是否是队长
function team:isLeader()
	local myRoleId = gf_getItemObject("game"):getId()
	return myRoleId == self.teamInfo.leader
end
function team:is_in_team()
	local data = self:getTeamData()
	if not next(data or {}) then
		return false
	end
	local myRoleId = gf_getItemObject("game"):getId()
	
	for i,v in ipairs(data.members or {}) do
		if v.roleId == myRoleId then
			return true
		end
	end
	return false
end

function team:set_enter_wait_time(time)
	self.wait_time = time
end
function team:get_enter_wait_time()
	return self.wait_time
end
--判断是否是我的队员
function team:is_my_teamer(roleId)
	local myRoleId = gf_getItemObject("game"):getId()
	if self:isLeader() then
		for i,v in ipairs(self.teamInfo.members or {}) do
			if v.roleId == roleId and myRoleId ~= roleId then
				return true
			end
		end
		return false
	end
	return false
end

-- 设置跟随
function team:set_follow( follow )
	self.follow = follow
	if not follow then
		local battle = LuaItemManager:get_item_obejct("battle")
		local char = battle:get_character()
		char:set_follow(false)
		char:set_follow_target(nil)
	end
end

function team:is_follow()
	return self.follow
end

function team:get_leader()
	local info = self:getLeaderInfo()
	if info then
		return LuaItemManager:get_item_obejct("battle"):get_model(info.roleId)
	end
	return nil
end


--[[
	send ****************************************************************************************************
]]

function team:sendToGetEnterCount()
	local msg = {}
	Net:send(msg,modelName,"TeamCopyPassTimes")
end

--发送创建
function team:sendToCreateTeam()
	print("sendToCreateTeam")
	local msg = {}
	Net:send(msg,modelName,"CreateTeam")
	-- testReceive(msg, modelName, "CreateTeamR", sid)
end
--发送获取附近队伍信息
function team:sendToGetNearTeam()
	local msg = {}
	Net:send(msg,modelName,"GetNearTeam",sid)
	-- testReceive(msg, modelName, "GetNearTeamR", sid)
end

--发送获取申请列表
function team:sendToGetApplyList()
	local msg = {}
	Net:send(msg,modelName,"GetApplyList",sid)
	-- testReceive(msg, modelName, "GetApplyListR", sid)
end

-- --发送获取邀请列表
-- function team:sendToGetInviteList()
-- 	local msg = {}
-- 	Net:send(msg,modelName,"GetInviteList",sid)
-- 	testReceive(msg, modelName, "GetInviteListR", sid)
-- end

--退出退伍
function team:sendToExitTeam()
	print("sendToExitTeam")
	local msg = {}
	Net:send(msg,modelName,"LeaveTeamReq",sid)
	-- testReceive(msg, modelName, "LeaveTeamR", sid)
end
--队长同意入队
--@agree   false or true
function team:sendToAgreeToTeam(roleId,agree)
	
	--判断队伍是否已经满了
	local data = self:getTeamData()
	if #data.members == teamNumberCount then
		gf_message_tips(commomString[10])
		return
	end

	local msg = {}
	msg.roleId = roleId
	msg.agree = agree
	Net:send(msg, modelName, "ReplyJoinTeam", sid)
end
--同意被邀请加入队伍
function team:sendToAgreeInvite(teamId,agree)
	local msg = {}
	msg.teamId = teamId
	msg.agree = agree
	Net:send(msg, modelName, "ReplyInvite", sid)
	gf_print_table(msg, "ReplyInvite:")
	-- testReceive(msg, modelName, "ReplyInvite", sid)
end
--邀请某人入队
function team:sendToInvite(roleId)
	--如果队伍已经满员
	local data = self:getTeamData()
	if next(data or {}) and #data.members == teamNumberCount then
		gf_message_tips(commomString[11])
		return
	end
	
	local msg = {}
	msg.roleId = roleId
	gf_print_table(msg, "InviteJoinTeam")
	Net:send(msg, modelName, "InviteJoinTeam", sid)
end

--发送申请
function team:sendToJoinTeam(teamId)
	print("发送申请入队")
	gf_message_tips(commomString[8])
	local msg = {}
	msg.teamId = teamId
	Net:send(msg,modelName,"JoinTeamReq",sid)
end
--切换目标
function team:sendToChangeTarget(targetId)
	print("sendToChangeTarget",targetId)
	local msg = {}
	msg.target = targetId
	Net:send(msg,modelName,"ChangeTarget")
end
--踢出队伍
function team:sendToKickMember(roleId)
	local msg = {}
	msg.roleId = roleId
	Net:send(msg,modelName,"KickMember")
end
--自动同意
function team:sendToAutoAgree(isAgree)
	print("isAgree:",isAgree)
	local msg = {}
	msg.autoAgree = isAgree 
	Net:send(msg,modelName,"AutoAgree")
	self:setAutoAgreeFlag(isAgree)
end
--获取队伍信息
function team:sendToGetTeamInfo()
	print("发送获取队伍信息")
	local msg = {}
	Net:send(msg,modelName,"GetPlayerTeam")
end

--发送找到目标队伍 
function team:sendToGetTeamByTargetId(targetId)
	print("sendToGetTeamByTargetId:",targetId)
	local msg = {}
	msg.target = targetId
	Net:send(msg,modelName,"TargetTeamList")
	-- testReceive(msg, modelName, "TargetTeamListR", sid)
end
--限制战力
function team:sendToChangePowerLimit(power)
	print("sendToChangePowerLimit:",power)
	local msg = {}
	msg.newLimit = power
	Net:send(msg,modelName,"ChangePowerLimit")
	-- testReceive(msg, modelName, "ChangePowerLimitR", sid)
end
--切换队长
function team:sendToChangeLeader(leaderId)
	local msg = {}
	msg.newLeader = leaderId
	self.myChangeId = gf_getItemObject("game"):getId()
	print("sid:",sid)
	Net:send(msg,modelName,"ChangeLeader",sid)
	-- testReceive(msg, modelName, "ChangeLeaderR", sid)
end
--全部拒绝入队申请
function team:sendToRejectAll()
	print("sendToRejectAll")
	local msg = {}
	Net:send(msg,modelName,"RejectAllApply")
	self.jointTeamList = {}
	self:show_main_button()
end
--拒绝全部邀请
function team:sendToRejectAllInvite()
	local msg = {}
	Net:send(msg,modelName,"RejectAllInvite")
	self.inviteList = {}
	self:show_main_button()
end
--申请全部
function team:sendToApplyAll(targetId)
	local msg = {}
	msg.target = targetId
	Net:send(msg,modelName,"OneKeyApply")
	gf_print_table(msg, "wtf OneKeyApply:")
end

--获取附近玩家
function team:sendToGetNearMan()
	local msg = {}
	Net:send(msg,modelName,"GetNearRoleList")
end

--开始匹配
function team:sendToMatch(matching,target)
	local msg = {}
	msg.target = target
	msg.matching = matching
	Net:send(msg,modelName,"TeamAutoMatch")
end

--[[
	rec ****************************************************************************************************
]]
function team:rec_test()
	gf_send_and_receive({matching = true}, "team", "TeamAutoMatchR", sid)
end
--接收到组队匹配返回
function team:recTeamMatching(msg)
	gf_print_table(msg, "wtf msg TeamAutoMatchR:")
	self.matching_state = msg.matching
end
--接收到组队创建成功
function team:recTeamCreateSuccess(teamInfo)
	self.teamInfo = teamInfo.team
	--清除所有邀请
	self.inviteList = {}
	self:show_main_button()
	--打开组队界面
	-- gf_receive_client_prot(msg,ClientProto.JointTeam)
	-- require("models.team.teamEnter")()  
end


--@return {[mapid] = {成员数据,}}
function team:get_member_map_inside()
	local temp = {}
	if not next(self.teamInfo or {}) then
		return {}
	end
	for i,v in ipairs(self.teamInfo.members or {}) do
		if not temp[v.mapId] then
			temp[v.mapId] = {}
		end
		table.insert(temp[v.mapId],v)
	end
	return temp
end

function team:get_matching_state()
	return self.matching_state or false
end

function team:get_invite_count()
	return #self.inviteList
end

function team:get_join_count()
	return #self.jointTeamList
end

function team:clear_team_red_point()
	Net:receive({id=ClientEnum.MAIN_UI_BTN.TeamMain,  visible=false}, ClientProto.ShowOrHideMainuiBtn)
end

function team:is_show_team_button()
	print("joint count :",self:get_join_count())
	print("invite count :",self:get_invite_count())
	return (self:get_join_count() + self:get_invite_count()) > 0
end

function team:enter_team_view()
	print("打开组队邀请或者申请界面")
	if self:get_invite_count() > 0 then
		require("models.team.beInviteView")()
	else
		require("models.team.applyView")()
	end
end


--接收到队员离开队伍
function team:recMemberLeave(roleId,kick)
	print("rec member level",roleId)
	--如果是自己
	if roleId == LuaItemManager:get_item_obejct("game").role_info.roleId then
		self.jointTeamList = {}
		self.teamInfo = {}
		if kick then
			gf_message_tips(commomString[13])
		end
		self:set_follow(false)
		self.matching_state = false
		return
	end
	for i,v in ipairs(self.teamInfo.members or {}) do
		if v.roleId == roleId then
			local name = self.teamInfo.members[i].name
			table.remove(self.teamInfo.members,i)
			--如果成员为空
			if not next(self.teamInfo.members or {}) then
				self.teamInfo = {}
			else
				gf_message_tips(string.format(commomString[5],name))
			end
			break
		end
	end
end

--收到加入队伍 申请加入队伍 or 同意加入队伍
function team:recJoinTeam(teamInfo)
	gf_print_table(teamInfo, "加入队伍 队伍数据")
	if next(teamInfo or {}) then
		self.teamInfo = teamInfo
	end
end

function team:recInvite(teamInfo)
	gf_print_table(teamInfo, "收到邀请")
	if next(teamInfo or {}) then

		--被邀请
		local function getLeaderName(data)
			for i,v in ipairs(data.members or {}) do
				if v.roleId == data.leader then
					return v.name
				end
			end
			return ""
		end
		gf_message_tips(string.format(commomString[7],getLeaderName(teamInfo)))
		table.insert(self.inviteList,teamInfo)

		self:show_main_button()
		-- gf_getItemObject("mainui"):btn_active(ClientEnum.MAIN_UI_BTN.TeamMain,true)
		-- Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.TeamMain ,visible = true}, ClientProto.ShowHotPoint)
	end
end

--接收到队伍信息 
function team:recTeamInfo(teamInfo)
	gf_print_table(teamInfo, "收到登陆请求的协议")
	self.teamInfo = teamInfo.team or {}
end

--接收到目标切换
function team:recTargetChange(targetId)
	if self.teamInfo then
		self.teamInfo.target = targetId
	end
end

function team:recMemberJoin(msg)
	--如果当前没有队伍 即是自己加入队伍 提醒并打开组队界面
	if not next(self.teamInfo.members or {}) then
		self:recJoinTeam(msg.team)
		--打开组队界面
		-- gf_receive_client_prot(msg,ClientProto.JointTeam)
		-- require("models.team.teamEnter")()  
		local leaderName = self:getLeaderName()
		gf_message_tips(string.format(commomString[3],leaderName))
	else
		--如果自己是队长 而且队伍满了 则打开界面
		local data = self:getTeamData()
		local function getAddOne()
			for ii,vv in ipairs(data.members or {}) do
				for i,v in ipairs(msg.team.members or {}) do
					if not (vv.roleId == v.roleId) then
						print("wtf :",vv.roleId == v.roleId,vv.roleId , v.roleId)
						return v
					end
				end
			end
		end
		
		local newOne = getAddOne()
		if not newOne then
			return
		end
		self:recJoinTeam(msg.team)
		local myRoleId = gf_getItemObject("game"):getId()
		if myRoleId == self.teamInfo.leader then
			gf_message_tips(string.format(commomString[4],newOne.name))

			--如果满人了 组队副本 弹出自动进入副本弹框
			if #self.teamInfo.members == teamNumberCount and data.target and data.target > 0  then
				local dataUse = require("models.team.dataUse")
				local target_info = dataUse.getTargetDataById(data.target)
				
				if target_info.open_type == 1 then
					CHECK_ENTER_TEAM_COPY2(target_info.open_param[1])
				end
				
			end
		end
	end
end


function team:rec_member_info_change(member)
	gf_print_table(self.teamInfo, "self.teamData1:")
	for i,v in ipairs(self.teamInfo.members or {}) do
		if v.roleId == member.roleId then
			v.level = member.level or v.level
			v.head 	= member.head  or v.head
			v.mapId = member.mapId or v.mapId
			v.power = member.power or v.power
			v.maxHp = member.maxHp or v.maxHp
			v.posX = member.posX or v.posX
			v.posY = member.posY or v.posY
			gf_print_table(v, "update set:")
		end
	end
	gf_print_table(self.teamInfo, "self.teamData2:")

end

function team:show_main_button()
	Net:receive({id=ClientEnum.MAIN_UI_BTN.TeamMain,  visible=self:is_show_team_button()}, ClientProto.ShowOrHideMainuiBtn)
end

-- 队长召唤跟随
function team:summon_follow_c2s()
	Net:send({}, modelName, "SummonFollow")
end

-- 召唤跟随广播（服务器主动下推）
function team:request_follow_notify_s2c( msg )
	--如果是自动跟随的
	if gf_getItemObject("setting"):get_setting_value(ClientEnum.SETTING.FOLLOW) then
		self:follow_leader_c2s(true)
		return
	end

	LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(
		gf_localize_string("队长向你发送跟随请求，是否跟随？"),
		function() -- 确定跟随
			self:follow_leader_c2s(true)
		end,
		function() -- 取消
			self:follow_leader_c2s(false)
		end,
		gf_localize_string("跟随"),
		gf_localize_string("取消")
	)
end


--队员同意/请求跟随 true为跟随，false为取消跟随
function team:follow_leader_c2s( follow )
	print("统一跟随",follow)
	Net:send({agree = follow}, modelName, "FollowLeader")
end

function team:follow_leader_s2c( msg )
	gf_print_table(msg, "同意跟随返回")
	self:set_follow(msg.agree)
	if msg.agree then -- 跟随，请求队长位置
		self:leader_position_req_c2s()
	end
end

--清理组队等待状态
function team:clear_team_state()
	for i,v in ipairs(self.teamInfo.members or {}) do
		v.confirm =	false
	end
end
function team:set_wait_state(msg)
	for i,v in ipairs(self.teamInfo.members or {}) do
		if msg.roleId == v.roleId then
			v.confirm = msg.agree
		end
	end
end

-- 请求队长位置
function team:leader_position_req_c2s()
	Net:send({}, modelName, "LeaderPositionReq")
end

function team:leader_position_req_s2c( msg )
	if msg.err ~= 0 then -- 队长位置不可到达
		return
	end

	gf_print_table(msg, "队长位置:")

	local battle = LuaItemManager:get_item_obejct("battle")
	local cb = function() -- 到达回调
		-- 判断队长是否在当前可视区域，不是再请求队长位置
		local leader = battle:get_model(self:getLeaderInfo().roleId)
		if not leader then
			gf_message_tips(gf_localize_string("队长在不可寻找的位置，请稍后再试"))
			-- self:leader_position_req_c2s()
		else
			local char = battle:get_character()
			if leader:is_horse() then
				char:set_follow_target(leader.horse)
			else
				char:set_follow_target(leader)
			end
			char:set_follow(true)
		end
	end

	battle:move_to(msg.mapId, msg.posX, msg.posY, cb, ConfigMgr:get_const("team_follow_d"))
end





function team:get_my_wait_state()
	local roleId = gf_getItemObject("game"):getId()
	for i,v in ipairs(self.teamInfo or {}) do
		if roleId == v.roleId then
			return v.confirm or false
		end
	end
	return false
end

function team:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "CreateTeamR") then
			gf_print_table(msg,"队伍创建成功")
			self:recTeamCreateSuccess(msg)

		elseif id2 == Net:get_id2(modelName,"LeaveTeamR") then
			self:recMemberLeave(msg.roleId,msg.kick)

		elseif id2 == Net:get_id2(modelName,"JoinTeamReqR") then
			--请求入队反馈 msg.err 0为申请成功 其他失败
		elseif id2 == Net:get_id2(modelName,"InviteNoticeR") then
			self:recInvite(msg.team)

		--有队员加入队伍(申请进入队伍 邀请进入队伍) 推送过来的数据是队伍的所有数据 全量
		elseif id2 == Net:get_id2(modelName,"JoinTeamResultR") then
			gf_print_table(msg, "JoinTeamResultR:")
			self:recMemberJoin(msg)
			      
		elseif id2 == Net:get_id2(modelName,"GetPlayerTeamR") then
			gf_print_table(msg,"wtf receive GetPlayerTeamR")
			self:recTeamInfo(msg)
			print("wtf =====")

		elseif id2 == Net:get_id2(modelName,"ChangeTargetR") then
			gf_print_table(msg, "ChangeTargetR wtf:")
			self:recTargetChange(msg.target)

		elseif id2 == Net:get_id2(modelName,"ChangeLeaderR") then
			print("接收到队长切换:",msg.newLeader,sid)
			self:setLeader(msg.newLeader,sid)

		elseif id2 == Net:get_id2(modelName,"ChangePowerLimitR") then
			gf_print_table(msg,"ChangePowerLimitR")
			self:setPower(msg.newLimit)

		elseif id2 == Net:get_id2(modelName,"RejectInviteR") then
			local str = string.format(commomString[1],msg.name)
			gf_message_tips(str)

		elseif id2 == Net:get_id2(modelName,"RejectJoinTeamR") then
			local str = string.format(commomString[2],msg.name)
			gf_message_tips(str)

		elseif id2 == Net:get_id2(modelName,"JoinTeamReqNoticeR") then
			gf_print_table(msg, "JoinTeamReqNoticeR:")
			table.insert(self.jointTeamList,1)

			self:show_main_button()
			
			local str = string.format(commomString[6],msg.name)
			gf_message_tips(str)

		elseif id2 == Net:get_id2(modelName,"ReplyJoinTeamR") then
			table.remove(self.jointTeamList,1)
			self:show_main_button()

		elseif id2 == Net:get_id2(modelName,"ReplyInviteR") then


		elseif id2 == Net:get_id2(modelName,"InviteJoinTeamR") then
			if msg.err == 0 then
				gf_message_tips(commomString[9])
			end

		elseif id2 == Net:get_id2(modelName,"MemberAttrChangeNotifyR") then
			gf_print_table(msg, "MemberAttrChangeNotifyR:")
			self:rec_member_info_change(msg.member)

		--*组队副本相关*--
		elseif id2 == Net:get_id2(modelName, "TeamCopyReadNotifyR")  then
			gf_print_table(msg, "TeamCopyReadNotifyR TeamCopyReadNotifyR:")
			self:clear_team_state()
			self.confirm_view = require("models.teamCopy.copyEnterConfirm")(msg.expire,2)
			

		elseif id2 == Net:get_id2(modelName, "TeamCopyAgreeNotifyR") then
			gf_print_table(msg, "wtf TeamCopyAgreeNotifyR")

			local team_data = gf_getItemObject("team"):getTeamData()
			local my_role_id = gf_getItemObject("game"):getId()
			if msg.roleId == team_data.leader then
				if my_role_id ~= team_data.leader then
					self:set_enter_wait_time(0) 
					gf_message_tips(commomString[16])
				end
				
				return
			end

			if not msg.agree then
				self:set_enter_wait_time(0) 
				local roleId = gf_getItemObject("game"):getId()
				if roleId ~= msg.roleId then
					gf_message_tips(string.format(commomString[15],msg.name))
				end
			else

			end
			self:set_wait_state(msg)
		elseif id2 == Net:get_id2(modelName, "FollowLeaderR") then
			self:follow_leader_s2c(msg)

		elseif id2 == Net:get_id2(modelName, "LeaderPositionReqR") then
			self:leader_position_req_s2c(msg)

		elseif id2 == Net:get_id2(modelName, "RequestFollowNotifyR") then
			self:request_follow_notify_s2c(msg)

		elseif id2 == Net:get_id2(modelName,"TeamAutoMatchR") then
			self:recTeamMatching(msg)

        end
	end

	if id1 == ClientProto.FinishScene then
		if self.confirm_view then
			self.confirm_view:dispose()
			self.confirm_view = nil
		end
	end
end


