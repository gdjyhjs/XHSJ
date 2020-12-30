function testReceive(msg, id1, id2, sid)
	local _id1 = Net:get_id1(id1)
	local _id2 = Net:get_id2(id1, id2)
	if true then
		return
	end
	local msg = {}
	if id1 == "team" then
		if id2 == "CreateTeamR" then
			local Member = 
			{
				roleId = 1,
				name = 1,
				level = 1,
				career = 1,
				head = 1,
			}

			local Team = 
			{
				teamId  = 1,
				leader  = 1,
				members  = {Member,},
				target  = 1,
				powerLimit  = 1,
			}

			msg = Team
		
		elseif id2 == "GetNearTeamR" then
			local team = 
			{
				teamId  = 1,
				leaderName  = 2,
				leaderLevel  = 2,
				memberNum  = 2,
				leaderHead = 2,
				target = 2,
				powerLimit = 2,
			}
			-- msg = {}
			msg = {team,team,team,}
		elseif id2 == "GetApplyListR" then
			local team = 
 			{
				roleId  =1,
				name  =1,
				level  =1,
				power  =1,
				head  =1,
			}
			-- msg = {}
			msg = {team,team,team,}
		elseif id2 == "GetInviteListR" then
			local team = 
			{
				teamId  = 1,
				leaderName  = 2,
				leaderLevel  = 2,
				memberNum  = 2,
				leaderHead = 2,
				target = 2,
				powerLimit = 2,
			}
			-- msg = {}
			msg = {team,team,team,}
		elseif id2 == "LeaveTeamR" then
			local roleId = LuaItemManager:get_item_obejct("game").role_info.roleId
			msg.roleId = roleId
		elseif id2 == "TargetTeamListR" then
			local Member = 
			{
				roleId = 2,
				name = 1,
				level = 1,
				career = 1,
				head = 1,
			}
			local leader = 
			{
				roleId = 1,
				name = 1,
				level = 1,
				career = 1,
				head = 1,
			}
			local Team = 
			{
				teamId  = 1,
				leader  = 1,
				members  = {Member,leader,Member},
				target  = 1,
				powerLimit  = 1,
			}

			msg.team = math.random(0,1) == 1 and {Team,Team,Team} or {}
		elseif id2 == "ChangePowerLimitR" then
			msg.newLimit = math.random(1,10000000)
		elseif id2 == "ChangeLeaderR" then
			msg.newLeader = math.random(0,1) == 1 and 2000065 or 2000066
		end
	elseif id1 == "horse" then 
		if id2 == "GetHorseInfoR" then 
			local Horse = 
			{
				horseId 	= 320002,
				soulLevel	= 2,
				slotLevel	= {1,0,1,1,0},
			}
			local Horse1 = 
			{
				horseId 	= 320001,
				soulLevel	= 0,
				slotLevel	= {0,0,0,0,0},
			}
			
			local data = 
			{
				level 					= 1,
				exp 					= 0,
				bHorse 					= 1,
				viewHorseId 			= 320001,
				feedLevel 				= 0,
				feedExp 				= 0,
				horse 					= {Horse,Horse1},
			}
			msg = data
		elseif id2 == "SetHorseRidingR" then
			msg.err = 0
			msg.bHorse = sid == 0 and 1 or 0

		elseif id2 == "AddExpByItemR" then
			local dataUse = require("models.horse.dataUse")
			msg.expArr = 80
			msg.err = 0
			msg.exp = sid.exp + 80

			local level,cur_exp_ex,max_exp = dataUse.get_transform_exp(msg.exp)

			msg.level = level
		elseif id2 == "HorseR" then

			local Horse = 
			{
				horseId     =     310001,
				soulLevel     =     1,
				slotLevel     =    {0,0,0,0,0} ,
			}
			msg.horse = Horse
		elseif id2 == "ChangeHorseViewR" then
			msg.err = 0
			msg.horseId = sid
		elseif id2 == "HorseSlotLevelUpR" then
			msg.err = 0
			msg.horseId = sid[1]
			msg.slot = sid[2]
			msg.level = 1
		elseif id2 == "FeedHorseByMemoryR" then
			local dataUse = require("models.horse.dataUse")
			msg.err = 0
			msg.feedexp = sid + 80
			local level = dataUse.get_level_and_left_exp(msg.feedexp)
			msg.feedlevel = level
		elseif id2 == "GetItemToFeedMemoryR" then
			msg.protoIdArr = {30020303,}

		elseif id2 == "SaveItemToFeedMemoryR" then
			msg.err = 0
			msg.protoIdArr = {}

		end

	elseif id1 == "base" then
		if id2 == "GetRankInfoR" then
			local RankInfo = 
			{
				roleId			=  	1,
				name 			= 	1,
				alliName		= 	1,
				level			=  	1,
				power			=  	1,
				donation		=  	1,
			}
			msg.type  = sid
			msg.list = {RankInfo,RankInfo,RankInfo}
			msg.myRank = 100
		end

	elseif id1 == "copy" then
		if id2 == "GetHolyCopyInfoR" then
			msg.copyCode = 1
			msg.cdTime = Net:get_server_time_s() + 10
		elseif id2 == "DailyRewardR" then
			local Item = 
			{
				code = 1,
				num  = 1,
			}
			msg.reward = {Item,Item,Item,}
		
		elseif id2 == "GetHolyInfoR" then
			local HolyInfo = 
			{
				holyCode 			=1,
				level 				=12,
				coinNum 			=1,
			}
			msg.holyInfo = {HolyInfo,}
		elseif id2 == "StrengthenHolyR" then
			msg.err = 0
			msg.holyCode = 1
		end
	elseif id1 == "scene" then
		if id2 == "WorldBossInfoR" then
			msg.refreshTime 		= Net:get_server_time_s() + math.random(1,10000)
			msg.highestHurtName 	= "xin1"
			msg.lastHurtName 		= "xin2"
		end
	end
	print("(msg,_id1,_id2,sid:",msg,_id1,_id2,sid)
	Net:receive(msg,_id1,_id2,sid)
end
