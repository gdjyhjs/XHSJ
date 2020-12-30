--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-17 17:57:59
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SkyTask = LuaItemManager:get_item_obejct("skyTask")
SkyTask.priority = ClientEnum.PRIORITY.TWO

--UI资源
SkyTask.assets=
{
    View("skyTaskView", SkyTask) 
}

--点击事件
function SkyTask:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end

--每次显示时候调用
function SkyTask:on_showed( ... )

end

--初始化函数只会调用一次
function SkyTask:initialize()
	self.task_list = {}
end

-- 获取剩余刷新次数
function SkyTask:get_left_times()
	return self.left_times
end

-- 获取任务列表
function SkyTask:get_task_list()
	return self.task_list
end

function SkyTask:set_task_list( task_list )
	self.task_list = {}

	for k,v in pairs(task_list or {}) do
		local data = ConfigMgr:get_config("task")[v.code]
		data.pos = v.pos
		data.state = v.state
		self.task_list[k] = data
	end
end

function SkyTask:set_tast_state( state, pos )
	self.task_list[pos].state = state
end

function SkyTask:get_data( pos )
	return self.task_list[pos]
end

function SkyTask:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetDailyTaskInfoR") then
			gf_print_table(msg,"wtf receive GetDailyTaskInfoR")
			self:get_daily_task_info_s2c(msg)

		elseif id2 == Net:get_id2("task", "DailyTaskAcceptR") then
			self:daily_task_accept_s2c(msg, sid)

		elseif id2 == Net:get_id2("task", "DailyTaskRefreshR") then
			self:daily_task_refresh_s2c(msg)

		elseif id2 == Net:get_id2("task", "DailyTaskGetRewardR") then
			self:daily_task_get_reward_s2c(msg, sid)

		elseif id2 == Net:get_id2("task", "DailyTaskBuyValidTimesR") then
			self:daily_task_buy_valid_times_s2c(msg)

		elseif id2 == Net:get_id2("task", "UpdateDailyTaskInfoR") then
			self:update_choice_info_s2c(msg)

		end
	end
end

--获取天机任务信息
function SkyTask:get_daily_task_info_c2s()
	print("获取天机任务信息")
	Net:send({}, "task", "GetDailyTaskInfo")
end

function SkyTask:get_daily_task_info_s2c( msg )
	gf_print_table(msg,"获取天机任务信息返回")
	self.left_times = msg.validTimes
	self:set_task_list(msg.taskList)
end

-- 领取天机任务
function SkyTask:daily_task_accept_c2s( pos )
	print("领取天机任务",pos)
	Net:send({pos = pos}, "task", "DailyTaskAccept", pos)
end

function SkyTask:daily_task_accept_s2c( msg, pos )
	gf_print_table(msg, "领取天机任务返回")
	if msg.err ~= 0 then
		return
	end
	self.left_times = self.left_times - 1
	if self.left_times < 0 then
		self.left_times = 0 
	end
end

-- 刷新天机任务
function SkyTask:daily_task_refresh_c2s()
	Net:send({}, "task", "DailyTaskRefresh")
end

function SkyTask:daily_task_refresh_s2c( msg )
	gf_print_table(msg, "刷新天机任务:")
	if msg.err ~= 0 then
		return
	end
	self:set_task_list(msg.taskList)
end

-- 领取任务奖励
function SkyTask:daily_task_get_reward_c2s( pos )
	print("领取任务奖励",pos)
	Net:send({pos = pos}, "task", "DailyTaskGetReward", pos)
end

function SkyTask:daily_task_get_reward_s2c( msg, pos )
	gf_print_table(msg, "领取任务奖励返回")
	if msg.err ~= 0 then
		return
	end
end

-- 购买次数
function SkyTask:daily_task_buy_valid_times_c2s()
	Net:send({}, "task", "DailyTaskBuyValidTimes")
end

function SkyTask:daily_task_buy_valid_times_s2c( msg )
	gf_print_table(msg, "购买次数返回")
	if msg.err ~= 0 then
		return
	end
	self.left_times = msg.validTimes
end

function SkyTask:update_choice_info_s2c( msg )
	gf_print_table(msg, "后端主动更新任务状态:")
	for k,v in pairs(msg.taskList) do
		local data = self:get_data(v.pos)
		data.state = v.state
	end
end
