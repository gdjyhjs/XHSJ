--[[--
-- 成就
-- @Author:xcb
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper

local Achievement = LuaItemManager:get_item_obejct("achievement")
Achievement.priority = ClientEnum.PRIORITY.ACHIEVEMENT
--UI资源
Achievement.assets=
{
    View("achievementView", Achievement) 
}

function Achievement:is_finished(schedule,target,code)
	local data = ConfigMgr:get_config("achieve")[code]
	if schedule == 0 then
		return false
	end
	if data ~= nil and data.compare_type == 1 then
		return schedule <= target
	else
		return target <= schedule
	end 
end
function Achievement:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetAchieveRewardR") then
			if msg.err == 0 then
				print("GetAchieveRewardR",msg.code)
				local data = ConfigMgr:get_config("achieve")
				local system = data[msg.code].system
				local temp
				for i,v in ipairs(self.data[system] or {}) do
					if v.id == msg.code then
						temp = {id = v.id,count = v.count,receive = 1,target = v.target}
						table.remove(self.data[system],i)
						break
					end
				end
				if temp ~= nil then
					local insert_index
					for i,v in ipairs(self.data[system]) do
						if temp.id < v.id and v.receive == 1 then
							insert_index = i
							break
						end
					end
					if insert_index ~= nil then
						table.insert(self.data[system],insert_index,temp)
					else
						table.insert(self.data[system],temp)
					end
				end
				if msg.nextAchieve ~= nil then

					local str = msg.nextAchieve.family .. "%02d"
					local reward_id = tonumber(string.format(str,msg.nextAchieve.rewarded))
					local next_id = reward_id + 1
					local rewarded = 0
					if data[next_id] ~= nil then		--表示还有未领取的成就
						local id = next_id
						local target = 0--data[id].target[1]
						if data[id] ~= nil then
							if type(data[id].target) == "table" then
								target = data[id].target[1]
							else
								target = data[id].target
							end
						end
						local insert_index
						for i,v in ipairs(self.data[system]) do
							if not self:is_finished(msg.nextAchieve.schedule,target,id) then		--如果还未达到可领取奖励的条件，则选择插在未领取且id比自己大的前面
								if id < v.id and not self:is_finished(v.count,v.target,v.id) then
									insert_index = i
									break
								end
							else--如果达到了可领取条件
								if not self:is_finished(v.count,v.target,v.id) then		--碰到了未达到可领取条件，则插在改记录前面
									insert_index = i
									break
								elseif id < v.id  then			--如果碰到了id比自己大，且也达到了可领取的条件，则排在它前面
									insert_index = i
									break
								end
							end
							if v.receive == 1 then
								insert_index = i
								break
							end
						end
						--local temp = {id = id,count = msg.nextAchieve.schedule,receive = msg.nextAchieve.rewarded,target = data[id].target[1]}
						local temp = {id = id,count = msg.nextAchieve.schedule,receive = 0,target = target}
						if insert_index ~= nil then
							table.insert(self.data[system],insert_index,temp)
						else
							table.insert(self.data[system],temp)
						end
					end
				end
				local has_red_point = false
				local first = self.data[system][1]
				if first ~= nil and self:is_finished(first.count,first.target,first.id) and first.receive == 0 then		--因为可领取的排前面，所以是否有红点，判断第一个是否可领取就可以了
					has_red_point = true
				end
				self.red_point[system] = has_red_point
				local is_need_show_red_point = false
				for k,v in pairs(self.red_point) do
					if v == true then
						is_need_show_red_point = true
					end
				end
				print("GetAchieveRewardR red_point",has_red_point,system,msg.code)
				Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACHIEVEMENR, visible=is_need_show_red_point}, ClientProto.ShowHotPoint)
				--[[local big_class = data[msg.code].type
				local sub_class = data[msg.code].sub_type
				if self.cur_rewarded[big_class] ~= nil then
					self.cur_rewarded[big_class][sub_class] = nil
					if msg.nextAchieve ~= nil and msg.nextAchieve.family ~= nil then
						local target = 0--data[id].target[1]
						local str = msg.nextAchieve.family .. "%02d"
						local reward_id = tonumber(string.format(str,msg.nextAchieve.rewarded))
						local id = reward_id + 1
						if data[id] ~= nil then
							if type(data[id].target) == "table" then
								target = data[id].target[1]
							else
								target = data[id].target
							end
							if target <= msg.nextAchieve.schedule then
								self.cur_rewarded[big_class][sub_class] = id
							end
						end
					end
				end]]
			end
		elseif id2 == Net:get_id2("task", "GetAchieveListR") then
			self.data[msg.system] = {}
			local finished_all = {}
			local data = ConfigMgr:get_config("achieve")
			for i,v in ipairs(msg.achieveList) do
				local str = v.family .. "%02d"
				local reward_id = tonumber(string.format(str,v.rewarded))
				local next_id = reward_id + 1
				local id = reward_id
				local rewarded = 0
				if data[next_id] ~= nil then		--表示还有未领取的成就
					id = next_id
				else 								--没有下一条成就可领取，说明已领取了所有成就
					rewarded = 1
				end
				local target = 0--data[id].target[1]
				if data[id] ~= nil then
					if type(data[id].target) == "table" then
						target = data[id].target[1]
					else
						target = data[id].target
					end
				end
				local temp = {id = id,count = v.schedule,receive = rewarded,target = target}
				if rewarded == 0 then
					table.insert(self.data[msg.system],temp)
				else
					finished_all[v.family] = temp
				end
			end
			--可领取的排在最前面
			local function sort(a,b)
				local is_can_rewarded_a = 1
				local is_can_rewarded_b = 1
				if not self:is_finished(a.count,a.target,a.id) then
					is_can_rewarded_a = 0
				end
				if not self:is_finished(b.count,b.target,b.id) then
					is_can_rewarded_b = 0
				end
				if is_can_rewarded_a ~= is_can_rewarded_b then
					return is_can_rewarded_b < is_can_rewarded_a
				end
				return a.id < b.id
			end
			table.sort(self.data[msg.system],sort)
			--[[for i,v in ipairs(self.data[msg.system]) do
				print("sdfhskjdhfksdf",v.count,v.target,ConfigMgr:get_config("achieve")[v.id].compare_type)
			end]]
			for i,v in ipairs(msg.achieveList) do
				local str = v.family .. "%02d"
				local reward_id = tonumber(string.format(str,v.rewarded))
				local next_id = reward_id + 1
				local id = reward_id
				if data[next_id] ~= nil then		--表示还有未领取的成就
					id = next_id
				else 					--没有下一条成就可领取，说明已领取了所有成就
				end
				if data[id] ~= nil then	
					local big_class = data[id].type
					local sub_class = data[id].sub_type
					local id_list = {}
					id = id - 1
					while data[id] ~= nil do
						if big_class == data[id].type and sub_class == data[id].sub_type then
							table.insert(id_list,id)
							id = id - 1
						else
							break
						end
					end
					if finished_all[v.family] ~= nil then
						table.insert(id_list,finished_all[v.family].id)
					end
					--排序
					local len = #id_list			
					while 0 < len do
						local id = id_list[len]
						local target = 0--data[id].target[1]
						if data[id] ~= nil then
							if type(data[id].target) == "table" then
								target = data[id].target[1]
							else
								target = data[id].target
							end
						end
						local temp = {id = id,count = target,receive = 1,target = target}
						table.insert(self.data[msg.system],temp)
						len = len - 1
					end
				end
			end
			if msg.achievePoint ~= nil then
				self.achieve_point = gf_deep_copy(msg.achievePoint)
			end
		elseif id2 == Net:get_id2("task", "AchieveUpdateR") then
			--[[local data = ConfigMgr:get_config("achieve")

			local str = msg.achieve.family .. "%02d"
			local reward_id = tonumber(string.format(str,msg.achieve.rewarded))
			local next_id = reward_id + 1
			local id = msg.achieve.family
			local rewarded = 0
			if data[next_id] ~= nil then		--表示还有未领取的成就
				id = next_id
			else 								--没有下一条成就可领取，说明已领取了所有成就
				return
			end
			local target = 0--data[id].target[1]
			if data[id] ~= nil then
				if type(data[id].target) == "table" then
					target = data[id].target[1]
				else
					target = data[id].target
				end
			end
			print("AchieveUpdateR",msg.achieve.schedule,target,msg.achieve.rewarded)
			if msg.achieve.schedule >= target then

				--只弹一次框
				local big_class = data[id].type
				local sub_class = data[id].sub_type
				if self.cur_rewarded[big_class] == nil or self.cur_rewarded[big_class][sub_class] == nil then
					if self.cur_rewarded[big_class] == nil then
						self.cur_rewarded[big_class] = {}
					end
					if LuaItemManager:get_item_obejct("achievementTips").achievement_id == nil then
						LuaItemManager:get_item_obejct("achievementTips").achievement_id = id
						gf_create_model_view("achievementTips")
					end
					self.cur_rewarded[big_class][sub_class] = id
				end
			end]]
			print("AchieveUpdateR",msg.code)
			local data = ConfigMgr:get_config("level_open")
			local play_lv = LuaItemManager:get_item_obejct("game"):getLevel()
			if LuaItemManager:get_item_obejct("achievementTips").achievement_id == nil and data[8].open_need_id <= play_lv then
				local id = msg.code
				LuaItemManager:get_item_obejct("achievementTips").achievement_id = id
				--gf_create_model_view("achievementTips")
				require("models.achievementTips.achievementTipsView")()
			end
			local str = msg.achieve.family .. "%02d"
			local reward_id = tonumber(string.format(str,msg.achieve.rewarded))
			if reward_id < msg.code then
				local data = ConfigMgr:get_config("achieve")
				local target = 0
				if data[msg.code] ~= nil then
					if type(data[msg.code].target) == "table" then
						target = data[msg.code].target[1]
					else
						target = data[msg.code].target
					end
				end
				if self:is_finished(msg.achieve.schedule,target,msg.code) then
					print("AchieveUpdateR red_point",msg.code)
					local system = data[msg.code].system
					self.red_point[system] = true
					Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACHIEVEMENR, visible=true}, ClientProto.ShowHotPoint)
				end
			end
		elseif id2 == Net:get_id2("task","AchieveRedPointR") then
			print("AchieveRedPointR")
			gf_print_table(msg.system)
			local is_red_point = false
			for i,v in ipairs(msg.system or {}) do
				if 0 < v then
					self.red_point[v] = true
					is_red_point = true
				else
					self.red_point[v] = false
				end
			end
			Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ACHIEVEMENR, visible=is_red_point}, ClientProto.ShowHotPoint)
		end
	end
end

function Achievement:get_data(system_type)
	return self.data[system_type]
end

function Achievement:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
	return true
end

function Achievement:get_process(system_type)
	local info = self.data[system_type]
	local count = 0
	local achieve_value = 0
	if self.achieve_point ~= nil then
		count = self.achieve_point[system_type]
	end
	achieve_value = ConfigMgr:get_config("achieve_point")[system_type].point
	return count,achieve_value
end
function Achievement:get_red_point(system)
	return self.red_point[system] or false
end
function Achievement:show_red_point()
	for k,v in pairs(self.red_point) do
		if v == true then
			return true
		end
	end
	return false
end
--初始化函数只会调用一次
function Achievement:initialize()
	self.data = {}
	self.achieve_point = {}
	self.cur_rewarded = {}
	self.red_point = {}
	--[[
	self.test_data = {[1] = {system = 1,achieveList = {{family = 10101,schedule = 0,rewarded = 13}},achievePoint = {1,1,1,1,1,1,1}},
						[2] = {system = 2, 
								achieveList = {{family = 20101,schedule = 50,rewarded = 4},
												{family = 20201,schedule = 0,rewarded = 8},
												{family = 20202,schedule = 0,rewarded = 8},
												{family = 20301,schedule = 0,rewarded = 3},
												{family = 20302,schedule = 0,rewarded = 3},
												{family = 20303,schedule = 0,rewarded = 3},
												{family = 20304,schedule = 0,rewarded = 3},
												{family = 20305,schedule = 1,rewarded = 7},
												{family = 20306,schedule = 1,rewarded = 12},
												{family = 20401,schedule = 1,rewarded = 0},
												{family = 20402,schedule = 0,rewarded = 0},
												{family = 20403,schedule = 0,rewarded = 0},
												{family = 20404,schedule = 0,rewarded = 0},
												{family = 20405,schedule = 0,rewarded = 0},
												{family = 20501,schedule = 0,rewarded = 21},
											},
							},
						[3] = {system = 3,
								achieveList = {{family = 30101,schedule = 0,rewarded = 12},
												{family = 30201,schedule = 0,rewarded = 10},
												{family = 30301,schedule = 0,rewarded = 6},
												{family = 30401,schedule = 0,rewarded = 14},
												{family = 30501,schedule = 0,rewarded = 9},
												{family = 30502,schedule = 0,rewarded = 7},
												{family = 30503,schedule = 0,rewarded = 4},
											},
							},
						[4] = {system = 4,
								achieveList = {{family = 40101,schedule = 0,rewarded = 7},
												{family = 40102,schedule = 0,rewarded = 6},
												{family = 40201,schedule = 0,rewarded = 3},
												{family = 40301,schedule = 0,rewarded = 3},
												{family = 40401,schedule = 0,rewarded = 3},
												{family = 40501,schedule = 0,rewarded = 0},
												{family = 40502,schedule = 0,rewarded = 3},
												{family = 40503,schedule = 0,rewarded = 3},
												{family = 40504,schedule = 0,rewarded = 6},
												{family = 40505,schedule = 0,rewarded = 3},
												{family = 40601,schedule = 0,rewarded = 6},
												{family = 40602,schedule = 0,rewarded = 2},
												{family = 40603,schedule = 0,rewarded = 5},
												{family = 40701,schedule = 0,rewarded = 6},
												{family = 40702,schedule = 0,rewarded = 6},
												{family = 40703,schedule = 0,rewarded = 6},
												{family = 40704,schedule = 0,rewarded = 6},
												{family = 40705,schedule = 0,rewarded = 6},
											},
							},
						[5] = {system = 5,
								achieveList = {{family = 50101,schedule = 0,rewarded = 11},
												{family = 50201,schedule = 0,rewarded = 11},
												{family = 50202,schedule = 0,rewarded = 11},
												{family = 50203,schedule = 0,rewarded = 11},
												{family = 50301,schedule = 0,rewarded = 2},
												{family = 50401,schedule = 0,rewarded = 0}, --
												{family = 50501,schedule = 0,rewarded = 9},
												{family = 50502,schedule = 0,rewarded = 9},
												{family = 50503,schedule = 0,rewarded = 9},
												{family = 50504,schedule = 0,rewarded = 9},
												{family = 50601,schedule = 0,rewarded = 0},
												{family = 50602,schedule = 0,rewarded = 0},
												{family = 50603,schedule = 0,rewarded = 0},
												{family = 50604,schedule = 0,rewarded = 0},
												{family = 50605,schedule = 0,rewarded = 0},
												{family = 50606,schedule = 0,rewarded = 0},
												{family = 50607,schedule = 0,rewarded = 0},
												{family = 50701,schedule = 0,rewarded = 7},
												{family = 50801,schedule = 0,rewarded = 8},
												{family = 50901,schedule = 0,rewarded = 8},
												{family = 50902,schedule = 0,rewarded = 8},
												{family = 50903,schedule = 0,rewarded = 8},
												{family = 51001,schedule = 0,rewarded = 8},
											},
							},
						[6] = {system = 6,
								achieveList = {{family = 60101,schedule = 0,rewarded = 0},
												{family = 60102,schedule = 0,rewarded = 5},
												{family = 60103,schedule = 0,rewarded = 5},
												{family = 60201,schedule = 0,rewarded = 3},
												{family = 60202,schedule = 0,rewarded = 3},
												{family = 60301,schedule = 0,rewarded = 3}, --
												{family = 60302,schedule = 0,rewarded = 3},
											},
							},
						[7] = {system = 7,
								achieveList = {{family = 70101,schedule = 0,rewarded = 4},
												{family = 70201,schedule = 0,rewarded = 4},
												{family = 70301,schedule = 0,rewarded = 14},
												{family = 70401,schedule = 0,rewarded = 7},
											},

						},
				}
			]]
end



