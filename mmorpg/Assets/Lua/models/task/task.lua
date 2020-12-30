--[[--
-- 任务数据类
-- @Author:Seven
-- @DateTime:2017-06-09 17:39:47
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Task = LuaItemManager:get_item_obejct("task")
--UI资源
Task.assets=
{
    View("taskView", Task) 
}

--初始化函数只会调用一次
function Task:initialize()
	self.task_list = {} -- 当前任务列表
	self.rvr_item = LuaItemManager:get_item_obejct("rvr")
end


-- 添加任务
function Task:add_task( data )
	local index = 0
	if data.type == ServerEnum.TASK_TYPE.MAIN then
		local tb = self:get_main_task()
		if tb then
			if data.code> tb.code then
				self:remove_task(tb.code)
			else
				return
			end
		end
	end
	for i,v in ipairs(self.task_list or {}) do
		if v.code == data.code then
			self.task_list[i] = data
			index = i
			break
		end
	end
	-- if self:check_daily_task(data) then
	-- 	self.task_list[#self.task_list+1] =  copy(ConfigMgr:get_config("task")[300000])
	-- end
	if index == 0 then
		self.task_list[#self.task_list+1] = data
	end

	local sortFunc = function(a, b)
		if a.type == b.type then
			return a.code < b.code
		else
       		return a.type <= b.type
       	end
    end
    table.sort(self.task_list,sortFunc)

	LuaItemManager:get_item_obejct("battle"):refresh_npc(data)
end

-- 移除任务
function Task:remove_task( task_id )
	local index = 0
	for i,v in ipairs(self.task_list or {}) do
		if v.code == task_id then
			index = i
			v.status = ServerEnum.TASK_STATUS.FINISH
			LuaItemManager:get_item_obejct("battle"):refresh_npc(v)
			break
		end
	end
	if index > 0 then
		table.remove(self.task_list,index)
	end
end

-- 获取任务
function Task:get_task( task_id )
	local task_list = self:get_task_list()
	for i,v in ipairs(task_list or {}) do
		if v.code == task_id then
			return v, i
		end
	end
	return nil, 1
end

-- 获取当前主线任务
function Task:get_main_task()
	local task_list = self:get_task_list()
	for i,v in ipairs(task_list or {}) do
		if v.type == ServerEnum.TASK_TYPE.MAIN then
			return v
		end
	end
	return nil
end
--根据类型获取任务（单一）
function Task:get_type_task(tp)
	local task_list = self:get_task_list()
	for i,v in ipairs(task_list or {}) do
		if v.type == tp then
			return v
		end
	end
	return nil
end

--检测天机任务
function Task:check_daily_task(data)
	if data.type ~= ServerEnum.TASK_TYPE.DAILY then return end
	for k,v in pairs(self.task_list) do
		if v.code == 300000 then
			return
		end
	end
	return true
end

-- 设置任务状态
function Task:set_task_status( task_id, status )
	print("设置任务状态",task_id)
	local task_data = self:get_task(task_id)
	if not task_data then
		task_data = copy(ConfigMgr:get_config("task")[task_id])
		task_data.original_sub_type = task_data.sub_type
		self:add_task(task_data)

		if not task_data then
			return
		end
	end

	if status == ServerEnum.TASK_STATUS.PROGRESS then
		task_data.sub_type = task_data.original_sub_type

	elseif status == ServerEnum.TASK_STATUS.COMPLETE then
		task_data.sub_type = ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP

	elseif status == ServerEnum.TASK_STATUS.AVAILABLE then
		task_data.original_sub_type = task_data.sub_type
		task_data.sub_type = ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP
	elseif status == ServerEnum.TASK_STATUS.NONE then
		task_data.original_sub_type = task_data.sub_type
	end
	-- print("设置任务状态1"..task_data.name..status.."/"..task_data.original_sub_type)

	task_data.status = status

	local battle_item = LuaItemManager:get_item_obejct("battle")
	battle_item:refresh_npc(task_data)
	battle_item:check_task_npc(task_data)
	battle_item:check_npc_follow(task_data)
end

-- 设置任务进度
function Task:set_task_progress( task_id, index, value )
	local task_data = self:get_task(task_id)
	if not task_data then
		return
	end
	if not task_data.schedule then
		task_data.schedule = {}
	end
	task_data.schedule[index] = value
end



-- 获取任务列表
function Task:get_task_list()
	if self.rvr_item:is_rvr() then
		local list = {}
		for i,v in ipairs(self.task_list) do
			if v.type == ServerEnum.TASK_TYPE.FACTION then
				list[#list+1] = v
			end
		end
		return list
	else
		local list = {}
		for i,v in ipairs(self.task_list) do
			if v.type ~= ServerEnum.TASK_TYPE.FACTION then
				list[#list+1] = v
			end
		end
		return list
	end
	return self.task_list
end


function Task:get_target_list( task_data )
	local target_list
	local status = task_data.status
	
	if status == ServerEnum.TASK_STATUS.AVAILABLE or status == ServerEnum.TASK_STATUS.NONE then
		return {task_data.receive_npc}, task_data.receive_map_id

	elseif status == ServerEnum.TASK_STATUS.PROGRESS then
		return task_data.condition, task_data.map_id

	elseif status == ServerEnum.TASK_STATUS.COMPLETE then
		return {task_data.finish_npc}, task_data.finish_map_id

	end

	return {}
end

-- 设置跳过剧情
function Task:set_skip_story( skip )
	self._is_skip_story = skip
end

function Task:is_skip_story()
	return self._is_skip_story
end

-- 通过npcid获取去任务数据
function Task:get_task_data( npc_id )
	for k,task_data in pairs(self.task_list) do
		local status = task_data.status
		if status == ServerEnum.TASK_STATUS.COMPLETE then
			if task_data.finish_npc == npc_id then
				return task_data
			end

		elseif status == ServerEnum.TASK_STATUS.AVAILABLE then
			if task_data.receive_npc == npc_id then
				return task_data
			end
		elseif status == ServerEnum.TASK_STATUS.PROGRESS then
			-- if task_data.sub_type == ServerEnum.TASK_SUB_TYPE.ESCORT and
				if	tonumber(task_data.condition[1])  == npc_id then
				return task_data
			end
		end

	end

	return nil
end

--获取最近完成的任务
function Task:get_recently_task()
	return self.recently_task
end


--点击事件
function Task:on_click(obj,arg)
	self:call_event("task_view_on_click",false,obj,arg)
	return true
end

function Task:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetTaskR") then -- 取任务信息,应该只需要登录的时候取一次
			self:get_task_s2c(msg)

		elseif id2 == Net:get_id2("task", "AcceptTaskR") then -- 接任务
			self:accept_task_s2c(msg)

		elseif id2 == Net:get_id2("task", "ScheduleUpdateR") then -- 通知任务进展
			self:schedule_update_s2c(msg)

		elseif id2 == Net:get_id2("task", "TaskCompleteR") then -- 通知任务完成
			self:task_complete_s2c(msg)

		elseif id2 == Net:get_id2("task", "TaskFinishR") then -- 通知任务结束
			self:task_finish_s2c(msg)

		elseif id2 == Net:get_id2("task", "TaskGiveUpR") then -- 通知任务移除
			self:task_give_up_s2c(msg)
		end
	elseif(id1==Net:get_id1("base"))then
		if id2 == Net:get_id2("base", "UpdateLvlR") then
        	-- self:update_task_status(msg.level)
        end
	end
end

-- 取任务信息,应该只需要登录的时候取一次
function Task:get_task_c2s()
	Net:send({}, "task", "GetTask")
end

function Task:get_task_s2c( msg )
	gf_print_table(msg, "获取任务返回：")
	
	local config_data = ConfigMgr:get_config("task")
	local game = LuaItemManager:get_item_obejct("game")
	local level = game:getLevel()

	self.task_list = {} -- 当前任务列表

	-- 解析完成任务卡下个任务是否可以接
	local finish_task_list = {}
	for i,v in ipairs(msg.finishTask) do
		finish_task_list[v] = v
	end

	for k,task_id in pairs(msg.finishTask) do
		local data = copy(config_data[task_id])
		
		if not finish_task_list[data.next_task] then -- 检查下一个任务是否完成
			local next_task_data = copy(config_data[data.next_task])
			if next_task_data then
				if level >= next_task_data.level then -- 可以接
					-- next_task_data.status = ServerEnum.TASK_STATUS.AVAILABLE
					-- next_task_data.original_sub_type = next_task_data.sub_type -- 保持原有的子类型
					-- -- next_task_data.sub_type = ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP
					-- self:add_task()
					self:set_task_status(next_task_data.code,ServerEnum.TASK_STATUS.AVAILABLE)
				else
					-- next_task_data.status = ServerEnum.TASK_STATUS.NONE
					-- next_task_data.original_sub_type = next_task_data.sub_type -- 保持原有的子类型
					-- -- next_task_data.sub_type = ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP
					-- self:add_task(next_task_data)
					self:set_task_status(next_task_data.code,ServerEnum.TASK_STATUS.NONE)
				end
			end
		end
		self:init_branch_task(data.code)
	end

	for k,v in pairs(msg.list) do
		local data = copy(config_data[v.code])
		local status = ServerEnum.TASK_STATUS.COMPLETE -- 任务完成，设置状态为完成
		data.original_sub_type = data.sub_type -- 保持原有的子类型
		data.sub_type = ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP
		for i,num in ipairs(data.target) do
			if v.schedule[i] < num then -- 进行中
				status = ServerEnum.TASK_STATUS.PROGRESS
				data.sub_type = data.original_sub_type
			end
		end

		data.schedule = v.schedule
		-- data.status = status
		self:add_task(data)
		self:set_task_status(data.code,status)
		self:init_branch_task(data.code)
	end
	self:check_have_every_task()
	local battle_item = LuaItemManager:get_item_obejct("battle")
	battle_item:check_task_npc_in_scene()
	battle_item:check_npc_follow_in_scene()
	
	gf_print_table(self.task_list, "当前任务列表")
end

-- 接任务
function Task:accept_task_c2s( task_id )
	local msg = {code = task_id}
	gf_print_table(msg, "接任务：")
	Net:send(msg, "task", "AcceptTask")
end

function Task:accept_task_s2c( msg )
	gf_print_table(msg, "接任务返回:")
	--更新支线
	self:init_branch_task(msg.code)
	-- 更换任务状态
	self:set_task_status(msg.code, ServerEnum.TASK_STATUS.PROGRESS)
 -- 领取任务时播放的音效 
Sound:play(ClientEnum.SOUND_KEY.GET_TASK)
end

-- 请求交任务
function Task:task_hand_up_c2s( task_id )
	local msg = {code = task_id}
	-- gf_print_table(msg, "请求交任务:")
	print("请求交任务:",task_id,"当前时间",os.time())
	Net:send(msg, "task", "TaskHandUp")
end

-- 通知任务进展
function Task:schedule_update_s2c( msg )
	gf_print_table(msg, "服务器下发任务进展：")
	self:set_task_progress(msg.code, msg.index, msg.value)
end

-- 通知任务完成
function Task:task_complete_s2c( msg )
	gf_print_table(msg, "通知完成任务:")
	-- 改变任务状态
	self:set_task_status(msg.code, ServerEnum.TASK_STATUS.COMPLETE)
 -- 完成任务时播放的音效 
Sound:play(ClientEnum.SOUND_KEY.FINISH_TASK)
end

-- 通知任务结束
function Task:task_finish_s2c( msg )
	gf_print_table(msg, "通知任务结束")
	-- 从任务列表移除任务
	local task_data = self:get_task(msg.code)
	self:set_task_status(msg.code,ServerEnum.TASK_STATUS.FINISH)
	self:remove_task(msg.code)
	if task_data then
		task_data.status = ServerEnum.TASK_STATUS.FINISH
		LuaItemManager:get_item_obejct("battle"):refresh_npc(task_data)

		local game = LuaItemManager:get_item_obejct("game")
		local level = game:getLevel()

		local next_task_data = copy(ConfigMgr:get_config("task")[task_data.next_task])
		if not next_task_data then
			-- 通知隐藏自动寻路ui特效
			Net:receive({visible = false}, ClientProto.ShowMainUIAutoPath)
			print("任务结束:id =",task_data.next_task)
			self.recently_task = nil
			-- 如果是日常任务完成，打开日常任务ui
			if task_data.type == ServerEnum.TASK_TYPE.DAILY then
				gf_create_model_view("skyTask")
			end

			return
		end

		if level >= next_task_data.level then
			self:set_task_status(next_task_data.code, ServerEnum.TASK_STATUS.AVAILABLE)
			self.recently_task = next_task_data
		else
			print("Error:玩家等级不够接取任务！！！task_id=",next_task_data.code)
			self:set_task_status(next_task_data.code, ServerEnum.TASK_STATUS.NONE)
			self.recently_task = nil
		end
		LuaItemManager:get_item_obejct("battle"):refresh_npc(next_task_data)

	else
		print("Error:找不到任务数据:id =",msg.code)
	end
end

function Task:task_give_up_s2c(msg)
	self:remove_task(msg.code)
	if self.recently_task and self.recently_task.code == msg.code then
		self.recently_task = nil
	end
end

-- 请求与npc对话
function Task:cossip_with_npc( npc_id )
	local msg = {code = npc_id}
	print("npc大对法11",npc_id)
	Net:send(msg, "scene", "GossipWithNpc")
	gf_print_table(msg, "请求与npc对话")
end

-- 采集
function Task:destination_c2s( guid, type, task_id )
	print("Task:destination_c2s",guid, type, task_id)
	Net:send({guid = guid, type = type, taskCode = task_id}, "scene", "Destination")
end
--初始化支线
function Task:init_branch_task(t_id)
	if not self.branch_task_data  then
		self.branch_task_data = copy(ConfigMgr:get_config("task_branch"))
	end
	local tb = self.branch_task_data[t_id]
	if tb then
		self.branch_task_data[t_id].open = true
	end
end
function Task:get_branch_tasks()
	return self.branch_task_data
end

function Task:get_branch_list()
	self.branch_task = {}
	local b_data = self.branch_task_data
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local fun = LuaItemManager:get_item_obejct("functionUnlock")
	-- if cur_funids == 0 then
	-- 	local data = ConfigMgr:get_config("function_unlock")
	-- 	cur_funids = #data
	-- end
	for k,v in pairs(b_data or {}) do
		if not v.open then
			if v.type == 1 then
				if v.value <= lv then
					self.branch_task[#self.branch_task+1] = v.code
				end
			elseif v.type == 2 then
				if fun:check_ishave_fun(v.value)then
					self.branch_task[#self.branch_task+1] = v.code
				end
			end
		end
	end
	return self.branch_task
end
--接取支线任务
function Task:receive_branch_task()
	for k,v in pairs(self.branch_task) do
		self:accept_task_c2s(v)
	end
end

function Task:preread_task_reward(t_id)
	Net:send({code = t_id}, "task", "PrereadTaskReward")
end

function Task:show_story(t_id)
	local data = ConfigMgr:get_config("task_section")[t_id]
	if not data then return end
	local cb = function( view )

	end
	-- 打开章节显示
	LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(true)
	local view = View("chapterView", LuaItemManager:get_item_obejct("mainui"), nil, data, {}, cb)
	view:set_touch(false)
end
--新手期间内
function Task:check_have_every_task()
	local  newcomerlevel = ConfigMgr:get_config("t_misc").guide_protect_level --新手等级限制
	local lv = LuaItemManager:get_item_obejct("game").role_info.level
	if newcomerlevel > lv then
		local data = self:get_main_task()
		if data and data.code > 100054 then
			local tb =  self:get_type_task(ServerEnum.TASK_TYPE.EVERY_DAY)
			if not tb then
				local tb = gf_get_config_table("task")[1000001]
				self:set_task_status(tb.code, ServerEnum.TASK_STATUS.AVAILABLE)
				LuaItemManager:get_item_obejct("battle"):refresh_npc(tb)
				gf_receive_client_prot({}, ClientProto.RefreshTask)
			end
		end
	end
end
--根据任务类型获取经验
function Task:exp_math_type(tp,num)
	local lv = LuaItemManager:get_item_obejct("game").role_info.level
	if tp == ServerEnum.TASK_TYPE.EVERY_DAY then
		local data = ConfigMgr:get_config("t_misc").daily_task.exp_reward_param
		return (data["A"]+((lv-data["B"])*data["C"]))
	end
end