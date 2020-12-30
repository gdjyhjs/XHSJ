--[[
	pvp数据模块
	create at 17.8.1
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local pvp = LuaItemManager:get_item_obejct("pvp")

local model_name = "copy"
--UI资源
pvp.assets=
{
    View("pvpView", pvp) ,
}

--点击事件
function pvp:on_click(obj,arg)
	--通知事件(点击事件)
	return self:call_event("pvp_view_on_click", false, obj, arg)
end


--初始化函数只会调用一次
function pvp:initialize()
end



--get ***********************************************************************************
function pvp:get_my_pvp_data()
	return self.my_pvp_data
end
function pvp:get_left_buy_count()
	return self.leftTimes or 0
end

function pvp:get_left_challenge_count()
	return self.my_pvp_data and self.my_pvp_data.leftTime or 0
end


--set ***********************************************************************************
function pvp:set_my_left_time(left)
	self.my_pvp_data.leftTime = left
end


--send ***********************************************************************************
function pvp:send_to_challenge_first()
	local enemy_list = self.my_pvp_data.enemyList
	if next(enemy_list or {}) then
		gf_getItemObject("copy"):enter_copy_c2s(ConfigMgr:get_config("t_misc").special_copy_code.arena,nil,enemy_list[1].roleId,enemy_list[1])
	end 
end
--获取对手数据
function pvp:send_to_get_pvp_data()
	local msg = {}
	Net:send(msg,model_name,"ArenaInfo")
	gf_print_table(msg, "ArenaInfo:")
end
--获取对战记录
function pvp:send_to_get_record()
	local msg = {}
	Net:send(msg,model_name,"ArenaFightRecord")
end
-- function pvp:send_to_get_rank()
-- 	local msg = {}
-- 	Net:send(msg,model_name,"ArenaRankInfo")
-- end
function pvp:send_to_refresh()
	local msg = {}
	Net:send(msg,model_name,"RefreshMatch")
end
function pvp:send_to_get_reward()
	local msg = {}
	Net:send(msg,model_name,"GetArenaDailyReward")
end
function pvp:send_to_add_challenge_count()
	local msg = {}
	Net:send(msg,model_name,"AddChallengeTimes")
end
function pvp:send_to_get_rank_list(page)
	local msg = {}
	msg.page = page
	local sid = Net:set_sid_param(page)
	Net:send(msg,model_name,"ArenaRankList",sid)
end
--获取剩余购买次数
function pvp:send_to_get_left_buy()
	local msg = {}
	Net:send(msg,model_name,"GetAddTimesLeft")
end



--rec ***********************************************************************************
function pvp:rec_my_pvp_data(msg)
	self.my_pvp_data = msg
end


function pvp:rec_add_success(msg)
	gf_print_table(msg, "wtf 次数增加")
	if msg.err == 0 then
		local count = self.my_pvp_data.leftTime
		count = count + 1
		self:set_my_left_time(count)
	end
end

function pvp:rec_buy_count(msg)
	gf_print_table(msg, "GetAddTimesLeftR:")
	self.leftTimes = msg.leftTimes
end

function pvp:enter_copy_s2c( msg,sid )
	gf_print_table(msg, "wtf pvp enter copy =====:"..sid)
	if msg.err == 0 then
		if gf_getItemObject("copy"):is_pvp() then 
			self.my_pvp_data.leftTime =  self.my_pvp_data.leftTime - 1
		end
	end
end

--服务器返回
function pvp:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1(model_name))then
        if id2 == Net:get_id2(model_name, "ArenaInfoR") then
        	self:rec_my_pvp_data(msg)

        elseif id2 == Net:get_id2(model_name,"ArenaFightRecordR") then
        	gf_print_table(msg, "ArenaFightRecordR:")

        elseif id2 == Net:get_id2(model_name,"AddChallengeTimesR") then
        	self:rec_add_success(msg)

        elseif id2 == Net:get_id2(model_name,"GetAddTimesLeftR") then
        	self:rec_buy_count(msg)

        end
    end
    if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "EnterCopyR") then -- 进入副本
			self:enter_copy_s2c(msg,sid)
		end
	end

    if id1 == ClientProto.AllLoaderFinish then
    	if self.is_have_review then
    		gf_create_model_view("pvp")
    	end
    	self.is_have_review = gf_getItemObject("copy"):is_pvp()
    end
    
end


