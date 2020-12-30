--[[--
-- 移动管理
-- @Author:Seven
-- @DateTime:2017-04-20 09:44:55
--]]

local Battle = LuaItemManager:get_item_obejct("battle")
local CREATE_CLIENT_NPC = 100000 -- 客户端创建npc

function Battle:on_update( dt )
	self:notice_move()
	self:check_temp_npc_list()
	self:update_obj()
	self:upadate_scale_time(dt)
end

-- 物体更新
local update_count = 1 -- 一帧刷新数量
function Battle:update_obj()
	if not self.is_update_obj then
		return
	end

	for i=1,update_count do
		local data = self.obj_list[1]
		if not data then
			break
		end
		table.remove(self.obj_list, 1)
		self:create_or_del_model(data)
	end
end

function Battle:create_or_del_model( data )
	if data.updateType == ServerEnum.OBJECT_UPDATE_TYPE.VALUES then -- 属性变化
		self:update_object(data)

	elseif data.updateType == ServerEnum.OBJECT_UPDATE_TYPE.CREATE_OBJECT then -- 创建对象
		if data.objType == ServerEnum.OBJ_TYPE.CREATURE then -- 怪物
			self:create_monster(data)

		elseif data.objType == ServerEnum.OBJ_TYPE.PLAYER then -- 玩家
			self:create_character(data)

		elseif data.objType == ServerEnum.OBJ_TYPE.HERO then -- 武将
			self:create_hero(data)

		elseif  data.objType == ServerEnum.OBJ_TYPE.PLAYER_CLONE then -- 竞技场镜像
			self:create_character(data,false,true)

		elseif data.objType == ServerEnum.OBJ_TYPE.NPC then -- 创建服务器控制的npc
			self:create_npc(data, true)
		end

	elseif data.updateType == ServerEnum.OBJECT_UPDATE_TYPE.CREATE_YOURSELF then -- 创建自己
		self:create_character(data, true)

	elseif data.updateType == ServerEnum.OBJECT_UPDATE_TYPE.OUT_OF_RANGE_OBJECTS then -- 移除
		self:remove_model(data.guid)
		Net:receive({}, ClientProto.RemoveMapModel)

	elseif data.updateType == CREATE_CLIENT_NPC then --客户端创建npc
		self:create_npc(data, false)
	end
end

-- 修正移动
function Battle:fix_move( obj, dx, dy, cb )
	obj:set_move_forward(false)
	obj:stop_auto_move()
	local dp = self:covert_s2c_position(dx, dy)
	obj:move_to2(dp, cb, 0.3)
end

function Battle:update_move( data, obj )
	if not obj or obj.is_self or obj.dead or obj.is_faraway or not obj.is_init then
		return
	end
	if data.mode ~= nil and data.mode == false then
		print("停止移动")
		-- 停止移动
		local cb = function()
			obj:set_local_euler_angles(Vector3(0, self:get_s2c_angle(data.dir), 0))
			obj:set_position(self:covert_s2c_position(data.srcX, data.srcY))
		end
		self:fix_move(obj, data.srcX, data.srcY, cb)
	else
		if data.dstX and data.dstY then -- 移动到目标点
			obj:move_to(self:covert_s2c_position(data.dstX, data.dstY), cb, 0.3, true)

		else

			local cb = function()
				obj:set_position(self:covert_s2c_position(data.srcX, data.srcY))
				obj:set_local_euler_angles(Vector3(0, self:get_s2c_angle(data.dir), 0))
				obj:set_move_forward(true)
			end
			self:fix_move(obj, data.srcX, data.srcY, cb)
		end
	end
end


Battle.player_grid = nil -- 玩家格子坐标
Battle.is_start_move = false -- 玩家是否开始移动
Battle.send_time = 0 -- 上一次发送时间
Battle.move_msg_info = {} -- 记录玩家移动信息
Battle.last_dir = 0 -- 玩家上一次的方向

-- 玩家跨格子通知服务器
function Battle:notice_move()

	if not self.character or not self.character.is_init then -- 只有玩家自己移动才需要发送消息
		return
	end

	local player = self.character
	if self.character:is_horse() then
		player = self.character.horse
	end

	if player:is_move() then
		self:player_move(player)
	
	elseif self.character:is_team_move_notice() then
		-- 跟随队长
		if self.character.follow_target then
			if not self.character.follow_target.is_faraway then
				self:player_move(player)
			else -- 请求队长位置
				self.character.follow_target = nil
				LuaItemManager:get_item_obejct("team"):leader_position_req_c2s()
			end
		end
	else
		self:player_stop_move(player)
	end

end

function Battle:player_stop_move( player )
	if self.is_start_move then
		self.is_start_move = false
		self:player_move_c2s(
			player.transform.position.x, 
			player.transform.position.z, 
			player.transform.localEulerAngles.y,
			false
		)
	end
end

function Battle:player_move( player )
	local pos = player.transform.position
	if not self.is_start_move then -- 开始移动，获取一下当前格子
		self.player_grid = gf_convert_world_2_grid(pos.x, pos.z)
	end

	local grid = gf_convert_world_2_grid(pos.x, pos.z)
	if self.player_grid.x ~= grid.x or self.player_grid.y ~= grid.y then -- 通知服务器跨越格子
		self.player_grid = grid
		-- self:cross_cell_c2s()
		self:refresh_models_show()
	end

	-- 通知服务器方向改变
	local dir = player.transform.localEulerAngles.y
	
	if math.abs(dir - self.last_dir) >= 1 or not self.is_start_move then
		if not self.is_start_move then
			self.send_time = os.clock() - 1 -- 第一次及时发送
			self.is_start_move = true
		end
		self.last_dir = dir
		self.move_msg_info.dir = dir
		self.move_msg_info.x = player.transform.position.x
		self.move_msg_info.y = player.transform.position.z
		self.move_msg_info.need_send = true
	end

	if self.is_start_move then -- 每隔0.2秒向服务器发送一次方向改变，如果有
		if os.clock() > self.send_time then
			self.send_time = os.clock() + 0.15
			if self.move_msg_info.need_send then
				self.move_msg_info.need_send = false
				self:player_move_c2s(
					self.move_msg_info.x,
					self.move_msg_info.y,
					self.move_msg_info.dir,
					true
				)
			end
		end
	end
end

-- 判断npc、怪物、玩家 是否落在9宫格内，是显示，不是，隐藏
function Battle:judge_model_in_9_grid(x, y)

	if not self.player_grid and self.character and self.character.transform then
		local p = self.character.transform.position
		self.player_grid = gf_convert_world_2_grid(p.x, p.z)
	end

	if not self.player_grid then
		return false
	end
	
	local minx = self.player_grid.x - 1
	local maxx = self.player_grid.x + 1
	local miny = self.player_grid.y - 1
	local maxy = self.player_grid.y + 1

	local grid = gf_convert_world_2_grid(x, y)
	if grid.x >= minx and grid.x <= maxx and grid.y >= miny and grid.y <= maxy then
		return true
	end
	return false
end

-- 刷新模型显示
local NPC_GUID_START = ClientEnum.GUID.NPC
Battle.temp_add_npc_list = {}
function Battle:refresh_models_show()
	for i,v in pairs(self.npc_pos_list or {}) do
		local npc = self:get_model(NPC_GUID_START+i)
		if self:judge_model_in_9_grid(v.pos.x*0.1, v.pos.y*0.1) then -- 创建npc
			if not npc then
				local data = {npc_id = v.code, x = v.pos.x, y = v.pos.y, dir = v.dir, guid = NPC_GUID_START+i, updateType = CREATE_CLIENT_NPC, name = v.name}
				if self.is_update_obj then
					table.insert(self.obj_list, data)
				else
					table.insert(self.temp_add_npc_list, data)
				end
			end
		else
			if npc then
				if npc.config_data.move ~= 1 then
					self:remove_model(npc.guid)
				end
			end
		end
	end

	-- for k,v in pairs(self.npc_list or {}) do
	-- 	if not v:is_server_npc() then -- 服务器控制的npc留给服务器删除
	-- 		local pos = v.transform.position
	-- 		if not self:judge_model_in_9_grid(pos.x, pos.y) then
	-- 			self:remove_model(v.guid)
	-- 		end
	-- 	end
	-- end
end

function Battle:check_temp_npc_list()
	if self.is_update_obj then
		for i,v in ipairs(self.temp_add_npc_list or {}) do
			table.insert(self.obj_list, v)
		end
		self.temp_add_npc_list = {}
	end
end

function Battle:upadate_scale_time( dt )
	if self.scale_time > 0 then
		self.scale_time = self.scale_time - dt
		if self.scale_time <= 0 then
			self:set_time_scale(1, 0)
		end
	end
end
