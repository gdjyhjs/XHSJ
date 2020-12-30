--[[--
-- 寻找位置(寻路过去)
-- @Author:Seven
-- @DateTime:2017-04-20 09:44:55
--]]

local FollowNPC = require("models.battle.obj.followNpc")
local BloodLineView = require("models.bloodLine.bloodLineView")

local Battle = LuaItemManager:get_item_obejct("battle")


--[[
*寻找一个类型的怪
*code:怪物id或者npc
*map_id:地图id
]] 
function Battle:find_task_target( task_data, code, map_id, cb_fn, num )
	print("param wtf:",code, map_id,num)
	local sub_type = task_data.sub_type
	if self:is_auto_atk() then
		gf_auto_atk(false)
	end
	if self.map_id == map_id then -- 在同一张地图
		if sub_type == ServerEnum.TASK_SUB_TYPE.KILL_CREATURE or 
		   sub_type == ServerEnum.TASK_SUB_TYPE.COLLECT       then

			local target = self.character:get_target(code)
			local pos
			if not target then
				local monster_center_list = ConfigMgr:get_config("map.mapMonsters")[map_id][ServerEnum.MAP_OBJECT_TYPE.CREATURE_CENTER]
				if not monster_center_list then
					print_error("ERROR:找不到怪物中心点！地图id =",map_id)
					return false
				end

				for k,v in pairs(monster_center_list) do
					if v.code == code then
						pos = v.pos
						break
					end
				end

				if not pos then
					print_error("ERROR:找不到怪物中心点 id =",code)
					return false
				end

				pos = self:covert_s2c_position(pos.x, pos.y)
			else
				pos = target.transform.position
			end
			local end_fn = function() -- 到达怪物中心点，开始寻找怪物，打怪
				if sub_type == ServerEnum.TASK_SUB_TYPE.KILL_CREATURE then
					self.character.target = self.character:get_target(code)
					gf_auto_atk(true)
					if cb_fn then
						cb_fn()
					end
				else
					-- 采集
					self:collect(code, num, cb_fn, task_data.task_id)
				end
			end
			self:find_move(pos, end_fn, 2)

		elseif sub_type == ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP  or  
			   sub_type == ServerEnum.TASK_SUB_TYPE.NPC_HAND_UP or
			   task_data.type == ServerEnum.TASK_TYPE.ESCORT     or
			   sub_type == ServerEnum.TASK_SUB_TYPE.ESCORT then
			
			local pos = self:get_npc_pos(code)
			if not pos then
				print_error("ERROR:找不到NPC：",code)
				gf_message_tips(string.format("ERROR:找不到NPC：%d", code))
				return false
			end
			self:find_move(pos, cb_fn, 4)

		elseif sub_type == ServerEnum.TASK_SUB_TYPE.DESTINATION then -- 到达地图上的某个点
			if gf_getItemObject("horse"):get_ride_state() == 1 then
				gf_getItemObject("horse"):send_to_ride(0)
			end
			local data = ConfigMgr:get_config("task_destination")[code]
			if not data then
				print_error("找不到地图上某个点的数据 code =",code)
				return
			end

			local finish_cb = function()
				LuaItemManager:get_item_obejct("task"):destination_c2s(nil, ServerEnum.TASK_DESTINATION_TYPE.ARRIVE, task_data.code)
			end
			if self.view then
				self.view:dispose()
				self.view = nil
			end
			local arrive_cb = function()

				-- 打开采集ui
				if not self.view then
					self.view = LuaItemManager:get_item_obejct("mainui"):collect_view()
				end
				if self.view then
					self.view:set_time(data.time)
					self.view:set_name(data.title)
					self.view:set_icon2(data.icon)
					self.view:set_cancel(true)
					self.view:set_finish_cb(finish_cb)
				end

				if cb_fn then
					cb_fn()
				end
			end
			self:find_move(self:covert_s2c_position(data.pos[1], data.pos[2]), arrive_cb, 0.5)

		elseif sub_type == ServerEnum.TASK_SUB_TYPE.CHALLENGECOPY then -- 打开副本
			if cb_fn then
				cb_fn()
			end
			local arrive_cb = function()
				LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(code)
			end
			local data = ConfigMgr:get_config("task_copy")[code]
			if gf_getItemObject("copy"):is_copy() then
				Net:receive(true,ClientProto.AutoAtk)
			end
			if data and data.ty == 2 then -- 直接进入副本
				self:find_move(self:covert_s2c_position(data.pos[1], data.pos[2]), arrive_cb, 2)
			end

		end

	else -- 不在同一张地图
		
		-- 记录任务信息
		self.task_info.is_task = true
		self.task_info.task_data = task_data
		self.task_info.code = code
		self.task_info.map_id = map_id
		self.task_info.cb_fn = cb_fn

		--如果等级足够 而且不是美人任务,直接飞 
		local my_level = gf_getItemObject("game"):getLevel()
		if gf_getItemObject("copy"):is_copy() then
			return false
		end
		if my_level >= ConfigMgr:get_config("t_misc").guide_protect_level and task_data.type ~= ServerEnum.TASK_TYPE.ESCORT then
			self:transfer_map_c2s(map_id,nil,nil,true)
			return false
		end
		if not self:transport_to_map(map_id) then
			if cb_fn then
				cb_fn(true)
			end
			return false
		end

	end
	return true
end


--仅支持当前地图
function Battle:auto_find_npc(npc_id,callback)
	local pos = self:get_npc_pos(npc_id)
	if not pos then
		print_error("ERROR:找不到NPC：",npc_id)
		gf_message_tips(string.format("ERROR:找不到NPC：%d", npc_id))
		return false
	end
	
	LuaItemManager:get_item_obejct("map"):move_to_point(pos,nil,callback)

end

-- 任务移动
function Battle:find_move( pos, arrive_cb, distance )
	local cb = function()
		if arrive_cb then
			arrive_cb()
		end
		self:show_obstacle(false)
	end
	self:show_obstacle(true)
	if not self.character then
		gf_error_tips("玩家角色还没创建")
		return
	end

	self.character:task_move(pos, cb, distance, true)
end

--[[
采集
code:采集怪id
num :采集数量
is_exemption:是否免检（军团活动已通过服务器验证）
]]
function Battle:collect( code, num, cb, task_id ,is_exemption)
	if not code then
		return
	end
	print("采集 参数 ",code, num, cb, task_id )
	-- 采集
	local target
	if type(code) == "table" then
		target = code -- 不加这个 军团宴会采集佳肴会报错 transform为空
		if target.target then
			-- print("采集 参数 目标1")
			target = target.target
		end
	else
		target = self:get_target(code, true)
		-- if target.target then
		-- 	print("采集 参数 目标2")
		-- 	target = target.target
		-- end
	end

	local finish_cb = function ()
		self.character.animator:SetBool("collect", false)
		LuaItemManager:get_item_obejct("task"):destination_c2s(target.guid, ServerEnum.TASK_DESTINATION_TYPE.COLLECT, task_id)
		if num > 1 then
			self:collect(code, num-1)
		end
	end

	local cancel_cb = function()
		self.character.animator:SetBool("collect", false)
	end
	if self.view then
		self.view:dispose()
		self.view = nil
		self.character.animator:SetBool("collect", false)
	end
	local arrive_cb = function()
		-- 军团活动的采集怪 采集前需要判断锁定
		for k,v in pairs(ConfigMgr:get_config("t_misc").alliance.legionActCollectToType) do
			if target.config_data.code == k and not is_exemption then
				LuaItemManager:get_item_obejct("bonfire"):alliance_collect(v,target)
				return
			end
		end
		self.character.animator:SetBool("collect", true)

		print("-- 打开采集ui")
		if not self.view then
			self.view = LuaItemManager:get_item_obejct("mainui"):collect_view()
		end
		if self.view then
			self.view:set_time(target.config_data.attack*0.001)
			self.view:set_name(gf_localize_string("采集"))
			self.view:set_icon2("collect_bg_01")
			self.view:set_cancel(true)
			self.view:set_finish_cb(finish_cb)
			self.view:set_cancel_cb(cancel_cb)
		end
		if cb then
			cb()
		end
	end

	if target then
		self.character:move_to(target.transform.position, arrive_cb, 2, true)
	else
		print_error("找不到采集怪")
		gf_message_tips("找不到采集怪")
	end
end

-- 切换场景时候判断是否有任务寻路
function Battle:is_change_scene_finish()
	--如果还有继续寻路的传送阵
	if self:move_transport_path() then
		return
	end
	self:check_task_npc_in_scene()
	
	--是否是在场景切换完进行寻路到boss
	gf_getItemObject("boss"):is_need_move_to_boss()

	if self.task_info.is_task then
		print("切换场景完成，继续任务寻路")
		self.task_info.is_task = false
		--当前进度
		local schedule_count = self.task_info.task_data.schedule and self.task_info.task_data.schedule[1] or 0
		self:find_task_target(self.task_info.task_data, self.task_info.code, self.task_info.map_id, self.task_info.cb_fn,self.task_info.task_data.target[1] - schedule_count)
	end

	if self.find_pos_info then
		self:move_to(self.find_pos_info.map_id, self.find_pos_info.x, self.find_pos_info.y, self.find_pos_info.cb) 
		self.find_pos_info = nil
	end

	if self.auto_move_pos then
		self:auto_move_map(self.map_id,self.auto_move_pos)
		self.auto_move_pos = nil
	end
end

-- 进入场景的时候判断下有没有npc跟随
function Battle:check_npc_follow_in_scene()
	local task_list = LuaItemManager:get_item_obejct("task"):get_task_list()
	local follow_list = ConfigMgr:get_config("task_follow_npc")
	-- local show_npc_list = {}
	for k,v in pairs(task_list or {}) do
		if v.type == ServerEnum.TASK_TYPE.MAIN or v.type == ServerEnum.TASK_TYPE.ESCORT then
			-- for j,d in pairs(follow_list or {}) do
			-- 	if d.visible == 0 and v.code <= d.hide_task and v.code == d.code then
			-- 		show_npc_list[#show_npc_list+1]=d
			-- 	end
			-- end
			self:check_npc_follow( v )
		end
	end
	-- for k,v in pairs(show_npc_list) do
	-- 	self:create_follow_npc(v)
	-- end
end

-- 检查是否有npc跟随或者隐藏
function Battle:check_npc_follow( task_data )
	local data = ConfigMgr:get_config("task_follow_npc")
	for k,v in pairs(data) do
		if v.code == task_data.code then
			if task_data.status == v.status then
				self:create_follow_npc(v)
				return
			end
		end
	end
end

function Battle:create_follow_npc( data )
	print("npc显示检查"..data.npc_type)
	local config_data = {}
	if data.npc_type == 0 then
		config_data = copy( ConfigMgr:get_config("npc")[data.npc_id])
	elseif data.npc_type == 1 then
		local quality =  LuaItemManager:get_item_obejct("husong"):get_husong_beauty()
		print("npc显示",quality)
		print("npc显示",LuaItemManager:get_item_obejct("husong").isExpired == 1)
		if not quality or LuaItemManager:get_item_obejct("husong").isExpired == 1 then --失败或者没品质
			return
		end 
		local npcid = ConfigMgr:get_config("task_escort_quality")[quality].npc_id
		config_data = copy(ConfigMgr:get_config("npc")[npcid])
		config_data.is_husong = true
	end
	if data.visible == 0 then -- 显示
		print("npc显示11")
		local finish_cb = function(npc, blood)
			npc:set_speed(ConfigMgr:get_config("t_misc").player_speed/10)
			npc:set_distance(5)
			npc:set_follow_target(self.character)
			npc:set_follow(true)
			npc:set_parent(self.pool.npc_parent)
			npc:set_blood_line(blood)
			local pos = self.character.transform.position
			-- npc:set_position(pos)
			-- npc.follow_move.maxDistance = 8
			npc:set_position(gf_get_follow_pos(pos))

			if not self.follow_npc_list[config_data.code] then
				self.follow_npc_list[config_data.code] = npc
			else
				npc:dispose()
			end
		end

		local blood_cb = function( blood )
			if self.follow_npc_list[config_data.code] == nil then
				FollowNPC(config_data, finish_cb, blood)
			end
		end
		BloodLineView("blood_line_npc.u3d", blood_cb)
	else -- 隐藏
		print("npc显示隐藏11")
		local npc = self.follow_npc_list[config_data.code]
		if npc then
			npc:faraway()
			npc:set_follow(false)
			npc:dispose()
			table.remove(self.follow_npc_list,config_data.code)
		end
	end
end

-- 进入场景的是检测是否有任务需要显示的npc
function Battle:check_task_npc_in_scene()
	print("进入场景的是检测是否有任务需要显示的npc")
	local task_list = LuaItemManager:get_item_obejct("task"):get_task_list()
	local follow_list = ConfigMgr:get_config("task_npc")
	local show_npc_list = {}
	gf_print_table(task_list,"进入场景的是检测是否有任务需要显示的npc task_list")
	for k,v in pairs(task_list or {}) do
		if v.type == ServerEnum.TASK_TYPE.MAIN then
			for j,d in pairs(follow_list or {}) do
				if d.visible == 1 and self.map_id == d.map_id then
					print("进入场景的是检测是否有任务需要显示的npc",v.code,d.code,v.status,d.status,d.hide_task)
					if v.code == d.code and v.status >= d.status then
						show_npc_list[#show_npc_list+1]=copy(d)
					elseif v.code > d.code and v.code < d.hide_task then
						show_npc_list[#show_npc_list+1]=copy(d)
					elseif v.code == d.hide_task and v.status < d.status then
						show_npc_list[#show_npc_list+1]=copy(d)
					end
				end
			end
		end
		if v.finish_map_id == self.map_id then  --给npc上任务信息
			self:refresh_npc(v)
		end
	end

	gf_print_table(show_npc_list,"进入场景的是检测是否有任务需要显示的npc")
	for k,v in pairs(show_npc_list) do
		local data = {}
		data.code = v.npc_id
		data.npc_id = v.npc_id
		data.pos = {x = v.pos[1], y = v.pos[2]}
		data.dir = v.dir
		data.name = "任务npc"
		
		self:add_npc_pos(data)
		self:refresh_models_show()
	end
end


-- 检查是否有显示的任务npc
function Battle:check_task_npc( task_data )
	local tb = ConfigMgr:get_config("task_npc")
	local data = nil
	for k,v in pairs(tb) do
		if v.code == task_data.code and v.status == task_data.status  then
			data = copy(v)
			self:showorhide_npc(data)
		end
	end
	-- if not data then
	-- 	return
	-- end
	-- print("检查是否有显示的任务npc",task_data.code,task_data.status,data.status,data.visible)
	-- if task_data.status ~= data.status then
	-- 	return
	-- end
end

function Battle:showorhide_npc(data)
	if data.visible == 1 then
		print("任务npc显示",data.npc_id,self:get_npc(data.npc_id))
		local d = {}
		d.code = data.npc_id
		d.npc_id = data.npc_id
		d.pos = {x = data.pos[1], y = data.pos[2]}
		d.dir = data.dir
		d.name = "任务npc"

		self:add_npc_pos(d)
		self:refresh_models_show()
	else
		print("任务npc删除",data.npc_id,self:get_npc(data.npc_id))
		local npc = self:get_npc(data.npc_id)
		if npc then
			self:remove_model(npc.guid)
		end
		self:remove_npc_pos(data.npc_id)
	end
end

--[[
移动到某张地图的某个点
map_id   : 地图id
x,y      : 目的坐标
cb       : 到达回调函数
distance : 距离目的点多远停下（不传默认人物攻击距离)
]]

function Battle:move_to( map_id, x, y, cb, distance, is_path )
	self.move_target = {map_id = map_id,x = x,y = y}
	print("Battle:move_to",map_id,self.map_id,x,y,distance)
	map_id = map_id or self.map_id
	if self:is_auto_atk() then
		gf_auto_atk(false)
	end
	if map_id == self.map_id then
		if not self.find_pos_info then
			print("新的移动 发送停止自动移动")
			Net:receive({}, ClientProto.OnStopAutoMove)
		end
		self.character:task_move(self:covert_s2c_position(x, y), cb, distance, true )
	else
		--如果等级足够 而且不是美人任务,直接飞 
		local my_level = gf_getItemObject("game"):getLevel()
		if my_level >= ConfigMgr:get_config("t_misc").guide_protect_level then
			self:transfer_map_c2s(map_id,nil,nil,true)
		else
			self:transport_to_map(map_id)
		end
		self.find_pos_info = {x = x, y = y, map_id = map_id, cb = cb}
	end
end

-- 获取目标地图传送阵数据
function Battle:get_transport_data( map_id )
	local data = self._transport_table[map_id]
	if not data then
		print_error(string.format("找不到地图%d的传送阵，请检查transport配置表！",map_id))
		return nil
	end

	return data
end

-- 获取一条传送阵位置  寻找去到map_id的一个传送阵
function Battle:get_transport_pos( map_id )
	print("wtf map_id:",map_id)
	if gf_table_length(self.transport_list) == 0 then
		return nil
	end

	local pos

	local function caculate( dst_map_id )
		local transport_list = self:get_transport_data(dst_map_id)
		
		if not transport_list then
			return nil
		end
		for k,v in pairs(transport_list) do
			if v.belong_map == self.map_id then
				pos = self:get_transport(v.map_id).position
				return pos
			else
				-- caculate(v.belong_map)
			end
		end
	end

	caculate(map_id)

	return pos
end

--寻找传送阵路径 不是最优
function Battle:get_transform_path(map_id,target_map_id)
	local tf = Battle._transport_table_belong[map_id]

	local t_list = {} 				--当前正在找的
	local h_list = {}  				--已经找的
	local find_list = nil
	local index = 0


	--寻找出所有的路径 选择一条最短路径 
	local function find(transform)
		--如果此传送阵属于这个地图 寻找到 返回
		for k,v in pairs(transform or {}) do
			--没有找过
			if not t_list[v.code] and not h_list[v.code] then
				index = index + 1
				v.sort = index 
				t_list[v.code] = v

				print("wtf 找到地图",gf_get_config_table("mapinfo")[v.map_id].name)

				if v.map_id == target_map_id then
					find_list =  gf_deep_copy(t_list)
					return true
				end
				--寻找这个传送阵到的地图的所有传送阵 
				local tfm = Battle._transport_table_belong[v.map_id]
				--继续寻找
				if not find(tfm) then
					print("wtf 剔除找到地图",gf_get_config_table("mapinfo")[v.map_id].name)
					t_list[v.code] = nil
					index = index - 1
					--没有找到 插入已经寻找队列中 
					h_list[v.code] = v
				else
					return true
				end
				
			end
		end
	end

	find(tf)
	gf_print_table(find_list, "wtf find list1")

	--排序
	local temp = {}
	for i,v in pairs(find_list or {}) do
		table.insert(temp,v)
	end
	gf_print_table(temp, "wtf find list2")

	table.sort(temp,function(a,b)return a.sort<b.sort end)
	
	--去环
	for i,v in ipairs(temp or {}) do
		for ii,vv in ipairs(temp) do
			if vv.code ~= v.code then
				if v.map_id == vv.belong_map and v.belong_map == vv.map_id then
					if not v.end_delete and not v.first_delete then
						v.first_delete = true
						vv.end_delete = true
					end
				end
			end
		end
	end

	local temp_path = {}
	local is_delete = false
	for i,v in ipairs(temp) do
		if v.first_delete then
			is_delete = true
		end
		if not is_delete then
			table.insert(temp_path,v)
		end
		if v.end_delete then
			is_delete = false
		end
	end
	temp = temp_path

	return temp
end

--自动寻路 如果不在改地图上 则直接飞到那个地图
--@map_id
--@pos 寻路位置 
function Battle:auto_move_map(map_id,pos)
	--判断是否在此地图 如果不在 直接传送
	if self.map_id == map_id then
		self.character:set_can_transport(true)
		self.character:move_to(pos, nil, 0.5, true)
		return		
	end
	self.auto_move_pos = pos
	self:transfer_map_c2s(map_id)
end



function Battle:transport_to_map( map_id )
	local t = self:get_transport(map_id)
	print("获取传送阵",t)
	if t then
		self.character:set_can_transport(true)
		self.character:move_to(t.position, nil, 0.5, true)
	else
		local pos = self:get_transport_pos(map_id)
		if not pos then
			-- self:transfer_map_c2s(transport_list[1].belong_map,nil,nil,true,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
			self.move_transport_list = self:get_transform_path(self.map_id,map_id)
			self:move_transport_path()
			return false
		else
			self.character:set_can_transport(true)
			self.character:move_to(pos, nil, 0.5, true)
		end
	end

	return true
end

function Battle:move_transport_path()
	gf_print_table(self.move_transport_list, "wtf move_transport_list:")
	if next(self.move_transport_list or {}) then
		local transport = self.move_transport_list[1]

		table.remove(self.move_transport_list,1)

		local transport_data = self:get_transport(transport.map_id)
		if not transport_data then
			self.move_transport_list = {}
			return false
		end
		local pos = transport_data.position

		self.character:set_can_transport(true)
		self.character:move_to(pos, nil, 0.5, true)
		return true
	end
	self.move_transport_list = {}
	return false
end

-- 显示/隐藏 动态阻挡墙(主要是任务用到)
function Battle:show_obstacle( visible )
	-- local obstacle = LuaHelper.Find("Obstacle")
	-- if obstacle then
	-- 	local obj = LuaHelper.FindChild(obstacle, "obj")
	-- 	if obj then
	-- 		obj:SetActive(visible)
	-- 	end
	-- end
end

-------------------------------------------------------------------------------------------------------------
-- private
-- 转换传送表
local function change_map_info_table()
	Battle._transport_table = {}
	Battle._transport_table_belong = {}
	for k,v in pairs(ConfigMgr:get_config("transport")) do
		if not Battle._transport_table[v.map_id] then
			Battle._transport_table[v.map_id] = {}
		end
		table.insert(Battle._transport_table[v.map_id], v)
		if not Battle._transport_table_belong[v.belong_map] then
			Battle._transport_table_belong[v.belong_map] = {}
		end
		table.insert(Battle._transport_table_belong[v.belong_map], v)
	end
end
change_map_info_table()

