--[[--
-- 成就
-- @Author:xcb
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper

local ActiveEx = LuaItemManager:get_item_obejct("activeEx")
--UI资源
ActiveEx.assets=
{
    View("activeExView", ActiveEx) 
}

function ActiveEx:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetRewardGroupR") then
			if msg.err == 0 then
				gf_print_table(msg)
				self.data_list[msg.activityId] = gf_deep_copy(msg.schedule)
				local function sort(a,b)
					return a.rewardId < b.rewardId
				end
				table.sort(self.data_list[msg.activityId],sort)
			end
		elseif id2 == Net:get_id2("task", "GetNormalRewardR") then
			if msg.err == 0 then
				local data = {}
				for i,v in ipairs(self.data_list[msg.activityId]) do
					if msg.rewardId == v.rewardId then
						v.times = msg.times
						v.serverLeft = msg.serverLeft
						v.timesToday = msg.timesToday
						data = v
						break
					end
				end
				local activity_type = ConfigMgr:get_config("activity_server_start")[msg.activityId].activity_type
				if activity_type == ClientEnum.ACTIVITY_SERVER.EXCHANGE then	--兑换活动
					local config = self:get_config(msg.activityId)[msg.rewardId].condition
					for i,v in ipairs(self.data_list[msg.activityId]) do
						for ii,vv in ipairs(v.schedule) do
							for iii,vvv in ipairs(config) do
								if vv.code == vvv[1] then
									vv.count = math.max(vv.count - vvv[2],0)
								end
							end
						end
					end
				elseif activity_type == ClientEnum.ACTIVITY_SERVER.LOGIN then
					local is_finished = true
					for i,v in ipairs(self.data_list[msg.activityId]) do
						if v.times == 0 then
							is_finished = false
							break
						end
					end
					self.is_login_rewarded = is_finished
				end
				local config = self:get_config(msg.activityId)
				local has_red_point = false
				for i,v in ipairs(self.data_list[msg.activityId]) do
					if self:is_finished(v.schedule,msg.activityId,v.rewardId) == true then
						if activity_type == ClientEnum.ACTIVITY_SERVER.LOGIN then
							if v.times == 0 then
								has_red_point = true
							end
						else
							local player_times = config[v.rewardId].player_times
							local day_times = config[v.rewardId].day_times
							local server_times = config[v.rewardId].server_times
							if not ( ( 0 < server_times and v.serverLeft <= 0 ) 
										or (0 < player_times and player_times <= v.times ) 
										or ( 0 < day_times and day_times <= v.timesToday ) )then
								has_red_point = true
							end
						end
					end
				end
				self.red_point[msg.activityId] = has_red_point
				local red_point = self:is_show_red_point()
				Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=red_point}, ClientProto.ShowHotPoint)
				Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER ,visible = red_point}, ClientProto.ShowAwardEffect)
			else
				print("GetNormalRewardR",msg.err)
			--	LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("领取失败"))
			end
		elseif id2 == Net:get_id2("task", "PushLoginActivityR") then
			local activity_type = ConfigMgr:get_config("activity_server_start")[msg.activityId].activity_type
			if activity_type == 1 then			--登录活动
				if msg.allRewarded == 0 then
					self.is_login_rewarded = true
				else
					self.is_login_rewarded = false
				end
			end
		elseif id2 == Net:get_id2("task", "ActivityRedPointR") then
			print("ActivityRedPointR")
			gf_print_table(msg)
			self.red_point = {}
			for i,v in pairs(msg.activityId) do
				self.red_point[v] = true
			end
			local red_point = self:is_show_red_point()
			Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=red_point}, ClientProto.ShowHotPoint)
			Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER ,visible = red_point}, ClientProto.ShowAwardEffect)
		elseif id2 == Net:get_id2("task","FinishRewardRedPointR") then
			self.red_point[msg.activityId] = true
			local red_point = self:is_show_red_point()
			Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=red_point}, ClientProto.ShowHotPoint)
			Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER ,visible = red_point}, ClientProto.ShowAwardEffect)
		elseif id2 == Net:get_id2("task", "TurnWheelR") then
			if msg.err == 0 then
				--[[self.wheel_left[msg.activityId] = self.wheel_left[msg.activityId] - 1
				local data = self:get_wheel_table(msg.activityId)--ConfigMgr:get_config("activity_wheel")
				local index = #data - self.wheel_left[msg.activityId]
				if 0 < index and index < #data then
					local next_time = Net:get_server_time_s() + data[index + 1].condition
					self.next_refresh_time[msg.activityId] = next_time
				else
					self.next_refresh_time[msg.activityId] = 0
				end]]
				self.red_point[msg.activityId] = false
				local red_point = self:is_show_red_point()
				Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=red_point}, ClientProto.ShowHotPoint)
				Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER ,visible = red_point}, ClientProto.ShowAwardEffect)
			end
		elseif id2 == Net:get_id2("task", "GetWheelActivityR") then
			if msg.err == 0 then
			--	self.wheel_left[msg.activityId] = #msg.leftReward
			end
		end
	end
	--if id1 == Net:get_id1("base") then
	--	if id2 == Net:get_id2("base","LoginR") then
	if id1 == ClientProto.PlayerLoaderFinish and self.is_loaded == false then		--为什么要监听这条而不监听loginr呢，因为loginr返回时还没获得服务器时间
		self.is_loaded = true
		self.active_time_list = {}
		local has_activity = false
		local is_need_show_ui = false
		local server_open_time = LuaItemManager:get_item_obejct("game"):get_server_open_time()--Net:get_server_time_s()--msg.serverStartTm
		local activity_main = ConfigMgr:get_config("activity_server_start")
		for k,v in pairs(activity_main) do
			local begin_time = server_open_time
			local end_time = begin_time + v.duration * 24 * 3600
			local is_open = false
			local activity_type = ConfigMgr:get_config("activity_server_start")[k].activity_type
			if begin_time <= Net:get_server_time_s() 
				and Net:get_server_time_s() <= end_time 
				and ( activity_type ~= ClientEnum.ACTIVITY_SERVER.LOGIN or self.is_login_rewarded == false) then
				is_open = true
				is_need_show_ui = true
				--[[if activity_type == ClientEnum.ACTIVITY_SERVER.LOGIN 
					or activity_type == ClientEnum.ACTIVITY_SERVER.WHEEL then
					self.next_refresh_time[k] = self:get_next_refresh_time(Net:get_server_time_s())
				end]]
			end
			if Net:get_server_time_s() <= end_time and ( activity_type ~= ClientEnum.ACTIVITY_SERVER.LOGIN or self.is_login_rewarded == false) then
				has_activity = true
			end
			self.active_time_list[k] = {begin_time = begin_time,end_time = end_time,is_open = is_open}

		end
		if has_activity == true then
			self:start_scheduler()
		end
		if is_need_show_ui == false then
			Net:receive({id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=is_need_show_ui}, ClientProto.ShowOrHideMainuiBtn)
		end
		local red_point = self:is_show_red_point()
		Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=red_point}, ClientProto.ShowHotPoint)
		Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER ,visible = red_point}, ClientProto.ShowAwardEffect)
	end
end

function ActiveEx:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
	return true
end
--初始化函数只会调用一次
function ActiveEx:initialize()
	self.active_time_list = {}
	self.red_point = {}
	self.next_refresh_time = {}
	self.wheel_left = {}	--今日转盘剩余的次数
	--[[local activity_main = ConfigMgr:get_config("activity_server_start")
	for k,v in pairs(activity_main) do
		local info = v.begin_time
		local begin_time = os.time({year=info[1],month=info[2],day=info[3],hour=info[4], minute=info[5], second=info[6]})
		info = v.end_time
		local end_time = os.time({year=info[1],month=info[2],day=info[3],hour=info[4], minute=info[5], second=info[6]})

		self.active_time_list[k] = {begin_time = begin_time,end_time = end_time} 
	end]]
	self.is_loaded = false
	self.data_list = {}

	self.activity_rank_enum = {
							[20001] = require("enum.enum").RANKING_TYPE.POWER,
							[20002] = require("enum.enum").RANKING_TYPE.LEVEL,
							[20003] = require("enum.enum").RANKING_TYPE.HORSE,
							[20004] = require("enum.enum").RANKING_TYPE.HERO,
							[20005] = require("enum.enum").RANKING_TYPE.ALLIANCE_LEVEL,
						}
	self.activity_rank_list = {}
	self.is_login_rewarded = false
	self.activity_wheel = {}
	for k,v in pairs(ConfigMgr:get_config("activity_server_start")) do
		if v.activity_type == ClientEnum.ACTIVITY_SERVER.WHEEL then
			local data = ConfigMgr:get_config("activity_wheel")
			self.activity_wheel[k] = {}
			for kk,vv in pairs(data) do
				if vv.activity_id == k then
					table.insert(self.activity_wheel[k],vv)
				end
			end
			local function sort(a,b)
				return a.index < b.index
			end
			table.sort(self.activity_wheel[k],sort)
		end
	end
end

function ActiveEx:get_time_info(activityId)
	return self.active_time_list[activityId]
end
function ActiveEx:get_time_list()
	local temp = {}
	for k,v in pairs(self.active_time_list) do
		if v.begin_time < Net:get_server_time_s() and Net:get_server_time_s() < v.end_time then
			table.insert(temp,k)
		end
	end
	local function sort(a,b)
		return a < b
	end
	table.sort(temp,sort)
	return temp
end

function ActiveEx:get_config(activity_id)
	local activity_type = ConfigMgr:get_config("activity_server_start")[activity_id].activity_type
	if activity_type == ClientEnum.ACTIVITY_SERVER.LOGIN then	--登录活动
		return ConfigMgr:get_config("activity_login")
	elseif activity_type == ClientEnum.ACTIVITY_SERVER.RANK then	--排行活动
		return ConfigMgr:get_config("activity_rank")
	elseif activity_type == ClientEnum.ACTIVITY_SERVER.EXCHANGE then	--兑换活动
		return ConfigMgr:get_config("activity_exchange")
	elseif activity_type == ClientEnum.ACTIVITY_SERVER.TASK then	--任务活动
		return ConfigMgr:get_config("activity_task")
	elseif activity_type == ClientEnum.ACTIVITY_SERVER.WHEEL then	--转盘活动
		return ConfigMgr:get_config("activity_wheel")
	end
end

function ActiveEx:get_data(activity_id)
	return self.data_list[activity_id]
end

function ActiveEx:is_finished(schedule,activity_id,reward_id)
	local activity_type = ConfigMgr:get_config("activity_server_start")[activity_id].activity_type
	local config = self:get_config(activity_id)[reward_id]
	if activity_type == ClientEnum.ACTIVITY_SERVER.LOGIN then
		if schedule[1].code < config.login_times then
			return false
		end
		return true
	else
		local activity_type = ConfigMgr:get_config("activity_server_start")[activity_id].activity_type
		for i,v in ipairs(schedule) do
			if activity_type == ClientEnum.ACTIVITY_SERVER.EXCHANGE then
				for ii,vv in ipairs(config.condition) do
					if v.code == vv[1] and v.count < vv[2] then
						return false
					end
				end
			else
				if v.code == config.condition[1] and v.count < config.condition[2] then
					return false
				end
			end
		end
		return true
	end
end

function ActiveEx:get_rank_type(activity_id)
	return self.activity_rank_enum[activity_id]
end

function ActiveEx:get_rank_acivity(rank_type)
	for k,v in pairs(self.activity_rank_enum) do
		if v == rank_type then
			return k
		end
	end
end

function ActiveEx:start_scheduler()
	if self.schedule_id then
		self:stop_scheduler()
	end
	local update = function()
		local is_need_stop = true
		for k,v in pairs(self.active_time_list) do
			if v.end_time < Net:get_server_time_s() then
				if v.is_open == true then
					self.red_point[k] = false
					local red_point = self:is_show_red_point()
					Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible = red_point}, ClientProto.ShowHotPoint)
					Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER ,visible = red_point}, ClientProto.ShowAwardEffect)
				end
				v.is_open = false
			end
			local activity_type = ConfigMgr:get_config("activity_server_start")[k].activity_type
			if Net:get_server_time_s() <= v.end_time and ( activity_type ~= ClientEnum.ACTIVITY_SERVER.LOGIN or self.is_login_rewarded == false) then
				is_need_stop = false
			end
			if v.is_open == false 
				and v.begin_time <= Net:get_server_time_s() and Net:get_server_time_s() <= v.end_time 
				and ( activity_type ~= ClientEnum.ACTIVITY_SERVER.LOGIN or self.is_login_rewarded == false) then
				v.is_open = true
				--Net:receive({id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=true}, ClientProto.ShowOrHideMainuiBtn)
				local red_point = self:is_show_red_point()
				Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=red_point}, ClientProto.ShowHotPoint)
				Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER ,visible = red_point}, ClientProto.ShowAwardEffect)
			end
			--转盘服务器会自己推红点，不自己算了
			--[[if v.is_open == true then
				if activity_type == ClientEnum.ACTIVITY_SERVER.WHEEL then
					if self.next_refresh_time[k] ~= nil and self.next_refresh_time[k] ~= 0 and self.next_refresh_time[k] < Net:get_server_time_s() then
						self.next_refresh_time[k] = 0--self:get_next_refresh_time(Net:get_server_time_s())
						self.red_point[k] = true
						Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=true}, ClientProto.ShowHotPoint)
					end
				end
			end]]
		end
		if is_need_stop == true then
			Net:receive({id=ClientEnum.MAIN_UI_BTN.ACTIVITY_SERVER, visible=false}, ClientProto.ShowOrHideMainuiBtn)
			self:stop_scheduler()
		end
	end
	self.schedule_id = Schedule(update, 1)
end

function ActiveEx:stop_scheduler()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function ActiveEx:is_show_active()
	for k,v in pairs(self.active_time_list) do
		if v.is_open == true then
			return true
		end
	end
	return false
end

function ActiveEx:get_next_refresh_time(cur_time)
	local date = os.date("%H:%M:%S",math.floor(cur_time))
	date = string.split(date,":")
	local second = date[1] * 3600 + date[2] * 60 + date[3]
	local dis = 24 * 3600 - second
	return math.floor(cur_time) + dis
end

function ActiveEx:is_show_red_point()
	for k,v in pairs(self.red_point) do
		if v == true then
			return true
		end
	end
	return false
end

function ActiveEx:get_red_point(activity_id)
	return self.red_point[activity_id] or false
end

function ActiveEx:get_wheel_table(activity_id)
	return self.activity_wheel[activity_id] or {}
end

function ActiveEx:get_is_open()
	local is_need_show_ui = false
	local server_open_time = LuaItemManager:get_item_obejct("game"):get_server_open_time() or Net:get_server_time_s()
	local activity_main = ConfigMgr:get_config("activity_server_start")
	for k,v in pairs(activity_main) do
		local begin_time = server_open_time
		local end_time = begin_time + v.duration * 24 * 3600
		local activity_type = ConfigMgr:get_config("activity_server_start")[k].activity_type
		if begin_time <= Net:get_server_time_s() 
			and Net:get_server_time_s() <= end_time 
			and ( activity_type ~= ClientEnum.ACTIVITY_SERVER.LOGIN or self.is_login_rewarded == false) then
			is_need_show_ui = true
		end
	end
	return is_need_show_ui
end




