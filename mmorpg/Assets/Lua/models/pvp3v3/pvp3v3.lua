--[[
	3v3系统数据模块
	create at 17.9.19
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local pvp3v3 = LuaItemManager:get_item_obejct("pvp3v3")

local Enum = require("enum.enum")
local model_name = "team"
--UI资源
pvp3v3.assets=
{
    View("pvp3v3View", pvp3v3) ,
}

--点击事件
function pvp3v3:on_click(obj,arg)
	--通知事件(点击事件)
	return self:call_event("pvp3v3_view_on_click", false, obj, arg)
end


--初始化函数只会调用一次
function pvp3v3:initialize()
end

--启动定时器刷新状态
function pvp3v3:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local function update()
		--刷新战场pvp特效
	    local zero_time = gf_get_server_zero_time()
	    local sever_time = Net:get_server_time_s()
	    --如果是在提醒阶段 展示红点
	    local show_red = sever_time >= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time - ConfigMgr:get_config("t_misc").pvp_3v3_wait_time - ConfigMgr:get_config("t_misc").pvp_3v3_wait_effect_time and sever_time <= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time 
	    Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.WARPVP ,visible = show_red}, ClientProto.ShowHotPoint)

	    local show = sever_time >= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time + ConfigMgr:get_config("t_misc").pvp_3v3_wait_effect_time and sever_time <= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time + ConfigMgr:get_config("t_misc").pvp_3v3_duration_time
	    Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.WARPVP ,visible = show}, ClientProto.ShowAwardEffect)
	end
	
	self.schedule_id = Schedule(update, 1)
end

function pvp3v3:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end




--set ***********************************************************************************



--send ***********************************************************************************
--开始匹配
function pvp3v3:send_to_enter_fight_c2s()
	local msg = {}
	Net:send(msg,model_name,"TeamVsCopyMatch")

	-- msg.expire = Net:get_server_time_s() + 30
	-- gf_send_and_receive(msg, model_name, "TeamVsCopyEnterMatchNotifyR", sid)
end
function pvp3v3:send_to_enter_fight_s2c(msg)
end

function pvp3v3:send_to_reject_pvp_c2s(agree)
	local msg = {}
	msg.agree = agree
	Net:send(msg,model_name,"TeamVsCopyAgree")

	-- local msg = {}
	-- msg.name = "test xin"
	-- gf_send_and_receive(msg, model_name, "TeamVsCopyRejectNotifyR", sid)
end

function pvp3v3:send_to_get_record_c2s()
	local msg = {}
	Net:send(msg,"copy","TeamRecordList")
end

function pvp3v3:send_to_get_record_s2c(msg)
	self.record_data = msg
end

function pvp3v3:send_to_get_myscore_c2s()
	local msg = {}
	Net:send(msg,"copy","TeamVsCopyInfo")
end

function pvp3v3:send_to_get_myscore_s2c(msg)
	self.my_score = msg.score
end

function pvp3v3:rec_team_member_data(msg)
	self.team_data = msg.member
end

function pvp3v3:rec_pvp_3v3_members(msg)
	self.pvp_tvt_members = msg.teamInfo
end

function pvp3v3:rec_matching_start(time)
	self.matching_time = time 
end

--取消匹配
function pvp3v3:send_to_cancel_match()
	local msg = {}
	Net:send(msg,"team","TeamVsCopyCancelMatch")
	
end


--通知进度
function pvp3v3:send_to_post_progress(progress)
	local msg = {}
	msg.progress = progress
	Net:send(msg,"copy","TeamVsCopyLoadProgress")
	
end

--get ***********************************************************************************
function pvp3v3:get_record_data()
	return self.record_data
end
function pvp3v3:get_team_members()
	return self.team_data
end
function pvp3v3:get_my_score()
	return self.my_score
end
function pvp3v3:get_pvp_tvt_members()
	return self.pvp_tvt_members
end
function pvp3v3:get_matching_time()
	return self.matching_time or 0
end
--判断是否是自己的队员
function pvp3v3:get_is_my_member(role_id)
	for i,v in ipairs(self.team_data or {}) do
		if v.roleId == role_id then
			return true
		end
	end
	return false
end

function pvp3v3:rec_score(msg)
	self.score = msg.scoreL
end

function pvp3v3:get_score()
	return self.score
end

function pvp3v3:test_rec_kill1()
	local is_myself = math.random(0,1) == 0 and true or false
	local msg = 
	{
		killerHead 	 = "img_head_114101",
		victimHead 	 = "img_head_114101",
		killerRoleId = is_myself and gf_getItemObject("game"):getId() or 11111,
		victimRoleId = is_myself and 11111 or gf_getItemObject("game"):getId(),
		killerName 	 = "击杀者",
		victimName 	 = "被击杀者",
		firstBlood 	 =	math.random(0,1) == 0 and true or false,
	}

	gf_send_and_receive(msg, "copy", "KillEnemyR", sid)

end
function pvp3v3:test_rec_kill2()

	local MemberResultInfo1 = 
	{
		name 		= "测试1",
		head 		= "img_head_112101",
		level		= 99,
		score		= 100,
		feats		= 10,
		emblem 		= 10,
		mvp 		= math.random(0,1) == 1,
	}
	local MemberResultInfo2 = 
	{
		name 		= "测试1",
		head 		= "img_head_112101",
		level		= 99,
		score		= 100,
		feats		= 10,
		emblem 		= 10,
		mvp 		= math.random(0,1) == 1,
	}
	local msg = 
	{
		costTime  					= 100,
		itemDrops 					= {},
		holyCode  					= -1,
		passFloors					= -1,
		arenaInfo 					= -1,
		teamVsCopyInfo 				= {MemberResultInfo1,MemberResultInfo2,MemberResultInfo1,MemberResultInfo2,MemberResultInfo1,MemberResultInfo2},
	}
	gf_send_and_receive(msg, "copy", "PassCopyR", sid)

end


--服务器返回
function pvp3v3:on_receive( msg, id1, id2, sid )
    if (id1==Net:get_id1(model_name)) then
        if id2 == Net:get_id2(model_name, "TeamVsCopyMatchR") then
        	gf_print_table(msg, "TeamVsCopyMatchR:")
        	self:rec_matching_start(msg.expireTime)

        --开始进入匹配 
        elseif id2 == Net:get_id2(model_name,"TeamVsCopyEnterMatchNotifyR") then
        	gf_print_table(msg, "TeamVsCopyEnterMatchNotifyR:")
        	self:rec_matching_start(msg.expire)

        elseif id2 == Net:get_id2(model_name,"TeamVsCopyMatchNotifyR") then
        	gf_print_table(msg, "TeamVsCopyMatchNotifyR")

       	elseif id2 == Net:get_id2(model_name,"TeamVsCopyMatchSuccessNotifyR") then
       		gf_print_table(msg, "wtf TeamVsCopyMatchSuccessNotifyR")
       		self:rec_pvp_3v3_members(msg)	

   		elseif id2 == Net:get_id2(model_name, "TeamVsCopyCancelMatchR") then -- 
   			self.matching_time = 0

        end
    end
    if (id1==Net:get_id1("copy")) then
        if id2 == Net:get_id2("copy", "MemberListR") then
        	gf_print_table(msg, "wtf MemberListR")
        	self:rec_team_member_data(msg)

        elseif id2 == Net:get_id2("copy","TeamVsCopyInfoR") then
        	gf_print_table(msg, "TeamVsCopyInfoR wtf")
        	self:send_to_get_myscore_s2c(msg)

        elseif id2 == Net:get_id2("copy","TeamScoreR") then
        	gf_print_table(msg, "wtf TeamScoreR:")
        	self:rec_score(msg)

        elseif id2 == Net:get_id2("copy","TeamRecordListR") then
        	gf_print_table(msg, "wtf TeamRecordListR:")
        	self:send_to_get_record_s2c(msg)
        	
        end
    end

    

end














-------------------------------------------------------------------------------------------------------------------
--测试
-------------------------------------------------------------------------------------------------------------------

function pvp3v3:test_end()
	local teamVsCopyInfo = {    
	    ["memberInfo"] = {    
	        [1] = {    
	            ["feats"] = 0,    
	            ["name"] = "robot1_1",    
	            ["head"] = "111101",    
	            ["emblem"] = 0,    
	            ["level"] = 1,    
	            ["kill"] = 0,    
	            ["score"] = 0,    
	            ["dead"] = 9,    
	        },    
	        [2] = {    
	            ["feats"] = 0,    
	            ["name"] = "robot1_2",    
	            ["head"] = "111101",    
	            ["emblem"] = 0,    
	            ["level"] = 1,    
	            ["kill"] = 0,    
	            ["score"] = 0,  
	            ["dead"] = 9,      
	        },    
	        [3] = {    
	            ["feats"] = 0,    
	            ["name"] = "robot1_3",    
	            ["head"] = "111101",    
	            ["emblem"] = 0,    
	            ["level"] = 1,    
	            ["kill"] = 0,    
	            ["score"] = 0, 
	            ["dead"] = 9,       
	        },    
	        [4] = {    
	            ["feats"] = 0,    
	            ["name"] = "阎姿蒨",    
	            ["head"] = "111101",    
	            ["emblem"] = 40,    
	            ["level"] = 60,    
	            ["kill"] = 4,    
	            ["score"] = 8,   
	            ["dead"] = 9,     
	        },    
	        [5] = {    
	            ["mvp"] = true,    
	            ["feats"] = 0,    
	            ["name"] = "雍问玉",    
	            ["head"] = "111101",    
	            ["emblem"] = 110,    
	            ["level"] = 60,    
	            ["kill"] = 6,    
	            ["score"] = 17,  
	            ["dead"] = 9,      
	        },    
	        [6] = {    
	            ["feats"] = 0,    
	            ["name"] = "robot1_4",    
	            ["head"] = "111101",    
	            ["emblem"] = 0,    
	            ["level"] = 1,    
	            ["kill"] = 0,    
	            ["score"] = 0,   
	            ["dead"] = 99,     
	        },    
	    },    
	    ["totalKill"] = {    
	        [1] = 0,    
	        [2] = 10,    
	    },    
	    ["win"] = true,    
	},    
	gf_print_table(teamVsCopyInfo, "wtf teamVsCopyInfo:")
	require("models.copyEnd.tvtEnd")(teamVsCopyInfo)

end


