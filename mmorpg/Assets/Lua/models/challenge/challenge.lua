--[[
	过关斩将系统数据模块
	create at 17.7.17
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local challenge = LuaItemManager:get_item_obejct("challenge")

local model_name = "copy"
--UI资源
challenge.assets=
{
    View("challengeView", challenge) ,
}

--点击事件
function challenge:on_click(obj,arg)
	--通知事件(点击事件)
	return self:call_event("challenge_view_on_click", false, obj, arg)
end


--初始化函数只会调用一次
function challenge:initialize()
	print("wtf challenge init")
end



--get ***********************************************************************************

function challenge:get_copy_code()
	return self.copy_code or 1
end

--set ***********************************************************************************

function challenge:set_copy_code(code)
	self.copy_code = code
end

--send ***********************************************************************************
function challenge:send_to_get_challenge_data()	
	local msg = {}
	Net:send(msg,model_name,"GetHolyCopyInfo")
	-- testReceive(msg, model_name, "GetHolyCopyInfoR")
end
function challenge:send_to_get_reward()	
	local msg = {}
	Net:send(msg,model_name,"DailyReward")
	gf_print_table(msg, "wtf DailyReward")
	-- testReceive(msg, model_name, "DailyRewardR")
end
function challenge:send_to_get_holy_data()
	local msg = {}
	Net:send(msg,model_name,"GetHolyInfo")
	-- testReceive(msg, model_name, "GetHolyInfoR")
end
function challenge:send_to_get_strenght(holy_id)
	local msg = {}
	msg.holyCode = holy_id
	Net:send(msg,model_name,"StrengthenHoly")
	gf_print_table(msg, "wtf send_to_get_strenght:")
	-- testReceive(msg, model_name, "StrengthenHolyR")
end


function challenge:send_to_enter_challenge()
	print("send_to_enter_challenge")
	gf_getItemObject("copy"):enter_copy_c2s(ConfigMgr:get_config("t_misc").copy.holy_copy_code)
end
--rec ***********************************************************************************


function challenge:recGetHolyCopyInfoR(msg)
	self.copy_code = msg.code
end

function challenge:rec_scene_tran_back(sid)
	print("继续挑战副本")
	--继续挑战副本
	if gf_getItemObject("copy"):is_challenge() then
		self.copy_code = unpack(Net:get_sid_param(sid))
		gf_getItemObject("copy"):set_time(Net:get_server_time_s())
		gf_receive_client_prot(msg,ClientProto.EnterChallengeCopy)
	end

end

--服务器返回
function challenge:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1(model_name))then
        if id2 == Net:get_id2(model_name, "GetHolyCopyInfoR") then
        	gf_print_table(msg, "GetHolyCopyInfoR:")
        	self:recGetHolyCopyInfoR(msg)

		elseif id2 == Net:get_id2(model_name, "DailyRewardR") then
			gf_print_table(msg, "DailyRewardR:")

		elseif id2 == Net:get_id2(model_name, "GetHolyInfoR") then
			gf_print_table(msg, "GetHolyInfoR:")
			
		end
    end
    if id1 == Net:get_id1("copy") then
    	if id2 == Net:get_id2("copy", "ContinueChallengeR") then -- 切换场景返回
    		self:rec_scene_tran_back(sid)

		end
    end
end


