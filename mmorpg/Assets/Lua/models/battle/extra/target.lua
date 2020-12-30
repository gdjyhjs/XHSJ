--[[--
-- 获取战斗目标
-- @Author:Seven
-- @DateTime:2017-04-20 09:44:55
--]]

local LimitLevel = ConfigMgr:get_config("t_misc").pk_mode_open_level

local GuideLevel = ConfigMgr:get_config("t_misc").guide_protect_level

local Battle = LuaItemManager:get_item_obejct("battle")

-- 获取攻击目标, 如果monster_id不为空，那寻找最近的monster_id怪物
-- function Battle:get_target2(monster_id, all)
-- 	local target

-- 	if ConfigMgr:get_config("mapinfo")[self.map_id].is_atk_player == 1 then -- 优先攻击玩家
-- 		target = self:get_can_atk_player(true)

-- 		if target then
-- 			return target
-- 		end
-- 	end


-- 	local max_range_list = {} -- 最大视野内的怪物列表
-- 	local min_range_list = {} -- 最小范围内的怪物列表
-- 	local out_range_list = {} -- 视野外的怪物列表
-- 	local max_up_half_range_list = {} -- 最大视野上半区列表
-- 	local max_down_half_range_list = {} -- 最大视野下半区列表

-- 	local enemy_list
-- 	if monster_id then
-- 		enemy_list = {}
-- 		for k,v in pairs(self.enemy_list) do
-- 			if v.config_data.code == monster_id then
-- 				enemy_list[#enemy_list+1] = v
-- 			end
-- 		end
-- 	else
-- 		enemy_list = self.enemy_list
-- 	end

-- 	local max_search_range = self.character.max_search_range^2
-- 	local min_search_range = self.character.min_search_range^2

-- 	for k,v in pairs(enemy_list or {}) do
-- 		if not v.dead and (all or not v:is_collect()) and self:is_can_atk_monster(v) then

-- 			local pos = self.character.transform:InverseTransformPoint(v.transform.position) -- 把怪物坐标转成玩家坐标系
-- 			local distance = pos.x^2 + pos.y^2 + pos.z^2
			
-- 			if distance <= max_search_range then
-- 				if pos.z >= 0 then -- 上半区
-- 					max_up_half_range_list[#max_up_half_range_list + 1] = {target = v, distance = distance, vector = pos}
-- 				else -- 下半区
-- 					max_down_half_range_list[#max_down_half_range_list + 1] = {target = v, distance = distance}
-- 				end

-- 				if distance <= min_search_range then -- 最小范围内的怪
-- 					min_range_list[#min_range_list + 1] = {target = v, distance = distance}
-- 				else
-- 					max_range_list[#max_range_list + 1] = {target = v, distance = distance}
-- 				end
-- 			else
-- 				out_range_list[#out_range_list + 1] = {target = v, distance = distance}
-- 			end
-- 		end
-- 	end

	
-- 	if #max_up_half_range_list > 0 then -- 最大范围上半区有怪物
-- 		-- print(">>>上半区有怪物")
-- 		target = self:judge_angle(max_up_half_range_list)
-- 		-- print(">>>判断攻击目标是否落在玩家的前方30的视觉扇形区域内 target =",target)

-- 		if not target then -- 获取小圆攻击目标
-- 			target = self:get_range_target(min_range_list)
-- 			-- print(">>>获取小圆攻击目标:target =",target)
-- 		end
		
-- 		if not target then -- 获取上半区的最近攻击目标
-- 			target = self:get_range_target(max_up_half_range_list)
-- 			-- print(">>>获取上半区的最近攻击目标:target =",target)
-- 		end

-- 	else
-- 		-- print("下半区有怪")
-- 		target = self:get_range_target(min_range_list) -- 获取小圆攻击目标
-- 		-- print(">>>获取小圆攻击目标:target =",target)

-- 		if not target then -- 获取下半区的最近攻击目标
-- 			target = self:get_range_target(max_down_half_range_list)
-- 			-- print(">>>获取下半区的最近攻击目标:target =",target)
-- 		end

-- 		if not target then -- 获取视野范围外的最近攻击目标
-- 			if self:is_auto_atk() then
-- 				target = self:get_range_target(out_range_list)
-- 				-- print(">>>获取视野范围外的最近攻击目标:target =",target)
-- 			end
-- 		end
-- 	end

-- 	return target
-- end

function Battle:get_target( monster_id, all, is_auto_atk, find_r )
	if not self.character then
		return nil
	end
	
	if not self.find_range then
		self.find_range = ConfigMgr:get_const("find_target_r_"..self.character.config_data.career)^2 -- 自动攻击搜索范围
	end
	find_r = find_r or self.find_range

	if self:is_auto_atk() then
		find_r = 10000
	end

	local target
	
	local attacker = self.character:get_attacker()
	if attacker and attacker.is_player and self:is_can_atk_player(attacker) then
		target = attacker
	end


	if ConfigMgr:get_config("mapinfo")[self.map_id].is_atk_player == 1 then -- 优先攻击玩家
		target = self:get_can_atk_player(true, find_r)

		if target then
			return target
		end
	end

	local enemy_list
	if monster_id then
		enemy_list = {}
		for k,v in pairs(self.enemy_list) do
			if v.config_data.code == monster_id then
				enemy_list[#enemy_list+1] = v
			end
		end
	else
		enemy_list = self.enemy_list
	end

	local max_distance = 10000000
	for k,v in pairs(enemy_list or {}) do
		if not v.dead and (all or not v:is_collect()) and self:is_can_atk_monster(v) then
			local distance = Seven.PublicFun.GetDistanceSquare(self.character.transform, v.transform)
			if distance ~= -1 and distance < max_distance then
				max_distance = distance
				if max_distance <= find_r or is_auto_atk then
					target = v
				end
			end
		end
	end

	return target
end

-- 通过怪物类型寻找最近的
function Battle:get_target_by_type( ty )
	local enemy_list = self.enemy_list
	local target = nil

	local max_distance = 10000000
	for k,v in pairs(enemy_list or {}) do
		if not v.dead and ty == v.config_data.type then
			local distance = Seven.PublicFun.GetDistanceSquare(self.character.transform, v.transform)
			if distance < max_distance then
				max_distance = distance
				target = v
			end
		end
	end

	return target
end

-- 获取地图配置表上面某个类型怪的最近位置
function Battle:get_target_pos_on_map( ty )
	local map_data = ConfigMgr:get_config("map.mapMonsters")[self.map_id]
	if not map_data then
		return nil
	end

	local max_distance = 10000000
	local char_pos = self.character.transform.position
	local pos = nil
	for i,v in ipairs(map_data[ServerEnum.MAP_OBJECT_TYPE.CREATURE] or {}) do
		local d = ConfigMgr:get_config("creature")[v.code]
		if d.type == ty then
			local dx = char_pos.x - v.pos.x*0.1
			local dz = char_pos.z - v.pos.z*0.1
			local distance = dx^2 + dz^2
			if distance < max_distance then
				pos = v.pos
			end
		end
	end
	if pos then
		pos = self:covert_s2c_position(pos.x, pos.y)
	end
	return pos
end

-- 获取友方
function Battle:get_friend()
	local distance = 100000000
	local target = nil
	for k,v in pairs(self.character_list or {}) do
		if self:is_friend(v.guid) then -- 30级以前，不能功能攻击
		   	local dpos = self.character:get_position() - v:get_position()
		   	local d = dpos.y^2 + dpos.y^2 + dpos.y^2
		   	if d < distance then
		   		target = v
		   	end

		end
	end

	return target
end

-- 判断攻击目标是否落在玩家的前方30的视觉扇形区域内
function Battle:judge_angle( list )
	local angle = 90 -- 视野角度
	local half_angle = angle/2

	local target
	local distance = 10000
	for k,v in pairs(list) do
        local temVec = v.vector.normalized
        local agl = Vector2.Angle(Vector2(0,1), Vector2(temVec.x, temVec.z)) --计算两个向量间的夹角
        if agl <= half_angle and distance > v.distance then -- 落在视野范围内
        	target = v.target
        	distance = v.distance
        end
	end

	return target
end

-- 获取圆内的最近攻击目标
function Battle:get_range_target( list )
	if #list == 0 then
		return nil
	end

	local sortfn = function( a, b )
		return a.distance > b.distance
	end

	table.sort( list, sortfn )

	return list[1].target
end

-- 获取可以攻击的玩家作为攻击目标
function Battle:get_can_atk_player(force, find_r)
	if not self.find_range then
		self.find_range = ConfigMgr:get_const("find_target_r_"..self.character.config_data.career)^2 -- 自动攻击搜索范围
	end
	find_r = find_r or self.find_range

	if LuaItemManager:get_item_obejct("rvr"):is_rvr() or gf_getItemObject("copy"):is_pvptvt() then -- 如果在战场中，选中不是自己阵营的玩家
		local distance = 100000000
		local target = nil
		for k,v in pairs(self.character_list or {}) do
			if not v.is_self                                   and 
			   v:get_faction() ~= self.character:get_faction() then

			   	local dpos = self.character:get_position() - v:get_position()
			   	local d = dpos.y^2 + dpos.y^2 + dpos.y^2
			   	if d < distance then
			   		distance = d
			   		if distance <= find_r then
				   		target = v
				   	end
			   	end

			end
		end
		
		return target
	end

	if self.pk_mode == ServerEnum.PK_MODE.PEACE then -- 和平模式不可攻击玩家
		return nil
	end

	if self.pk_mode == ServerEnum.PK_MODE.ALLIANCE then -- 可以攻击自己军团和队伍以外的非和平模式玩家（没有军团的则是队伍以外）
		local distance = 100000000
		local target = nil
		for k,v in pairs(self.character_list or {}) do
			if not v.is_self                               and 
			   v:get_pk_mode() ~= ServerEnum.PK_MODE.PEACE and
			   not self:is_in_legion(v:get_guid())         and 
			   not self:is_in_team(v:get_guid())           and 
			   (v.config_data.level > LimitLevel or force) then -- 30级以前，不能功能攻击

			   	local dpos = self.character:get_position() - v:get_position()
			   	local d = dpos.y^2 + dpos.y^2 + dpos.y^2
			   	if d < distance then
			   		distance = d
			   		if distance <= find_r then
				   		target = v
				   	end
			   	end

			end
		end

		return target
	end

	if self.pk_mode == ServerEnum.PK_MODE.SERVER then -- 攻击其他服务器（跨服）
		return nil
	end

	if self.pk_mode == ServerEnum.PK_MODE.WORLD then -- 可以攻击自己军团和队伍以外的所有玩家
		local distance = 100000000
		local target = nil
		for k,v in pairs(self.character_list or {}) do
			if not v.is_self                               and 
			   -- not self:is_in_legion(v:get_guid())         and 
			   -- not self:is_in_team(v:get_guid())           then
			   (v.config_data.level > LimitLevel or force) then

			   	local dpos = self.character:get_position() - v:get_position()
			   	local d = dpos.y^2 + dpos.y^2 + dpos.y^2
			   	if d < distance then
			   		distance = d
			   		if distance <= find_r then
				   		target = v
				   	end
			   	end

			end
		end

		return target
	end

	return nil
end

-- 判断一个玩家是否在自己的军团
function Battle:is_in_legion( guid )
	local legion = LuaItemManager:get_item_obejct("legion")

	local member_list = legion:get_member_list() or {}
	for k,v in pairs(member_list) do
		if guid == v.roleId then
			return true
		end
	end

	return false
end

-- 判断一个玩家是否在队伍里
function Battle:is_in_team( guid )
	local team = LuaItemManager:get_item_obejct("team")
	if not team:getTeamData() then
		return false
	end

	local team_list = team:getTeamData().members or {}

	for k,v in pairs(team_list) do
		if guid == v.roleId then
			return true
		end
	end

	return false
end

-- 是否在同一阵营
function Battle:is_in_faction( guid )
	local model = self:get_model(guid)
	if not model then
		return false
	end
	
	if self.character:get_faction() == nil or model:get_faction() == nil then
		return false
	end

	if self.character:get_faction() <= 0 or model:get_faction() <= 0 then
		return false
	end

	return self.character:get_faction() == model:get_faction()
end

-- 判断是否是友方
function Battle:is_friend( guid )
	local model = self:get_model(guid)
	if model and model.is_monster then
		return not self:is_can_atk_monster(model)
	end
	return self:is_in_legion(guid) or self:is_in_team(guid) or self:is_in_faction(guid)
end

--判断是否是采集怪
function Battle:is_collect_monster(guid)
	local model = self:get_model(guid)
	if model and model.is_monster then
		local tp = model.config_data.type
		if tp == ServerEnum.CREATURE_TYPE.COLLECT then
			return true
		end
	end
	return false
end

-- 判断当前玩家是否可以攻击
function Battle:is_can_atk_player( player )

	if not player then
		return false
	end
	
	if self:is_in_faction(player.guid) then
		return false
	end

	if not self:is_in_team(player.guid) and not self:is_in_legion(player.guid) then
		if self.pk_mode == ServerEnum.PK_MODE.ALLIANCE then
			return true
		end
	end

	if self.pk_mode == ServerEnum.PK_MODE.WORLD   or 
	   self.pk_mode == ServerEnum.PK_MODE.FACTION then
		if player.config_data.level > GuideLevel then
			return true
		else
			gf_error_tips("玩家正在新手保护期间，不能攻击")
		end
	end

	if player:get_battle_flag() and self.character:get_attacker() == player then -- 出于和平模式，被人打，对方 战斗状态为true 时候可以攻击
		return true
	end

	return false
end

-- 判断自己是否可以攻击其他玩家
function Battle:is_can_atk_other_player()
	return self.character.config_data.level > LimitLevel
end

-- 判断怪物是否可以攻击
function Battle:is_can_atk_monster( monster )
	if not monster then
		return false
	end

	if self:is_in_faction(monster.guid) then
		return false
	end

	return true
end