
--判断是否能进入副本
function CHECK_IN_TEAM(callback)
	local content 		= gf_localize_string("你还没有队伍，无法进入组队副本")
	local sure_btn_name 	= gf_localize_string("加入队伍")
	local cancle_btn_name 	= gf_localize_string("创建队伍")

	local sure_fun = function()
		-- gf_receive_client_prot(msg, ClientProto.CopyViewClose)
		require("models.team.teamEnter")()
		
	end
	local cancle_fun = function()
		-- gf_receive_client_prot(msg, ClientProto.CopyViewClose)
		gf_getItemObject("team"):sendToCreateTeam()
	end
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun,sure_btn_name,cancle_btn_name)
end

function ENTER_TEAM_COPY(code)
	local team_data = gf_getItemObject("team"):getTeamData()

	if not gf_getItemObject("team"):isLeader() then
		gf_message_tips(gf_localize_string("只有队长才能开启"))
		return
	end

	if #team_data.members ~= gf_get_config_const("team_member_count") then
		CHECK_ENTER_TEAM_COPY1(code)

	else
		CHECK_ENTER_TEAM_COPY2(code)

	end
end

--少人进入副本
function CHECK_ENTER_TEAM_COPY1(code)
	local count = #gf_getItemObject("team"):getTeamData().members
	-- local content 		= gf_localize_string("队伍人数不足3人，仍然要进入副本吗？<color=#53ff4f>人数越多奖励越丰厚哦!</color>")
	local content 		= gf_localize_string(string.format("队伍中只有%d个人，确定进入副本吗",count))
	local cancle_btn_name 	= gf_localize_string("进入副本")
	local sure_btn_name 	= gf_localize_string("继续组队")

	local sure_fun = function()
		
	end
	local cancle_fun = function()
		print("进入副本")
		-- if gf_getItemObject("team"):is_one_self() then
		-- 	gf_getItemObject("copy"):enter_copy_c2s(code)
		-- 	return
		-- end
		Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN)
		gf_getItemObject("copy"):enter_team_copy_c2s(code)
		gf_receive_client_prot({}, ClientProto.CopyViewClose)
	end
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun,sure_btn_name,cancle_btn_name)
end

--满人进入副本
function CHECK_ENTER_TEAM_COPY2(code)
	local content 		= gf_localize_string("队伍已经整装待发，是否立即进入副本!")
	local sure_btn_name 	= gf_localize_string("进入副本")
	local cancle_btn_name 	= gf_localize_string("稍等一下")

	local sure_fun = function()
		-- if gf_getItemObject("team"):is_one_self() then
		-- 	gf_getItemObject("copy"):enter_copy_c2s(code)
		-- 	return
		-- end
		Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN)
		gf_getItemObject("copy"):enter_team_copy_c2s(code)
		gf_receive_client_prot({}, ClientProto.CopyViewClose)
	end
	local cancle_fun = function()
	end
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun,sure_btn_name,cancle_btn_name)
end

--队长等待其他队员确认进入副本
function CHECK_WAIT_ENTER_TEAM(callback)
	local content 		= gf_localize_string("正在等待其他队员确认...\n15s")
	local sure_btn_name 	= gf_localize_string("好的")

	local sure_fun = function()
	end
	
	gf_getItemObject("cCMP"):only_ok_message(content,sure_fun,sure_btn_name)
end

--其他队员确认进入副本弹框
function CHECK_MEMBER_WAIT_ENTER_TEAM_COPY(callback)
	local content 		= gf_localize_string("队长准备进入<color=>[%d]</color>副本，是否确认")
	local sure_btn_name 	= gf_localize_string("好的")
	local cancle_btn_name 	= gf_localize_string("稍等一下")

	local sure_fun = function()
		gf_getItemObject("copy"):comfirm_enter_team_copy_c2s(true)
	end
	local cancle_fun = function()
		gf_getItemObject("copy"):comfirm_enter_team_copy_c2s(false)
	end
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun,sure_btn_name,cancle_btn_name)
end

--点击主动匹配处理逻辑
function gf_auto_match()
	
	local team_data = gf_getItemObject("team"):getTeamData()
	if #team_data.members == gf_get_config_const("team_member_count") then
		gf_message_tips(gf_localize_string("队伍已满，无需匹配"))
		return
	end
	if not gf_getItemObject("team"):isLeader() then
		gf_message_tips(gf_localize_string("你已有队伍"))
		return
	end

end

function gf_team_follow()
	--如果是队长
	if gf_getItemObject("team"):isLeader() then
		gf_message_tips("已召唤队员跟随")
		gf_getItemObject("team"):summon_follow_c2s()
	else
		follow = gf_getItemObject("team"):is_follow()
		follow = not follow
		if follow then
			gf_message_tips("已跟随队长")
		else
			gf_message_tips("已取消跟随")
		end
		gf_getItemObject("team"):follow_leader_c2s(follow)
		
	end
end
