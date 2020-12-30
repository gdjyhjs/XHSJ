--[[--
-- 协议接收、处理
-- @Author:Seven
-- @DateTime:2017-04-20 09:44:55
--]]
local Effect = require("common.effect")

local Battle = LuaItemManager:get_item_obejct("battle")

-- 请求移动
function Battle:player_move_c2s( x, y, dir, is_move )
	local msg = {
		srcX = x*10,
		srcY = y*10,
		dir = self:covert_c2s_angle(dir),
		mode = is_move,
	}
	gf_print_table(msg, "player_move_c2s:")
	Net:send(msg, "scene", "PlayerMove")
end

-- 对象移动广播
function Battle:object_move_s2c( msg )
	-- gf_print_table(msg,"object_move_s2c:")
	for i,data in ipairs(msg.objList or {}) do
		-- if not self.move_list[data.guid] then
		-- 	self.move_list[data.guid] = {}
		-- 	self.move_flag_list[data.guid] = true
		-- end
		-- table.insert(self.move_list[data.guid], data)
		self:update_move(data, self:get_model(data.guid))
	end
end

--创建,更新,移除通用协议
function Battle:update_object_s2c( msg )
	-- gf_print_table(msg, "update_object_s2c:")

	self.is_update_obj = false
	for i,v in ipairs(msg.objList or {}) do
		table.insert(self.obj_list, v)
		-- self:create_or_del_model(v)
	end
	self.is_update_obj = true
end

-- 请求释放技能
function Battle:skill_cast_c2s( code, x, y, dir, target, caster )

	local msg = {
		code = code,
		posX = x*10,
		posY = y*10,
		dir = self:covert_c2s_angle(dir),
		target = target,
		caster = caster,
	}
	gf_print_table(msg, "播放技能:")
	Net:send(msg, "scene", "SkillCast")
end

-- 技能返回 #失败只返回给释放者，成功则广播
function Battle:skill_cast_s2c( msg )
	-- gf_print_table(msg, "Battle:skill_cast_s2c:")
	-- print(Net:error_code(msg.err))

	if msg.err ~= 0 then
		return
	end

	local attacker = self.model_list[msg.caster]
	local target = self.model_list[msg.target]
	
	if not attacker then
		-- print_error("ERROR:服务器下发的攻击目标或攻击者有问题!")
		return
	end

	if Seven.PublicFun.IsNull(attacker.root) then
		return
	end

	local function play_atk()
		if not attacker:is_visible() then
			return
		end

		if attacker.is_monster then -- 怪物
			if target and target.is_self then -- 攻击自己的显示血条
				attacker:show_blood(true)
			end
			attacker:play_atk(target, msg.skillId)

		elseif attacker.is_hero then -- 武将
			attacker:play_atk(target, msg.skillId)

		else -- 玩家
			if not attacker.is_self then
				attacker:play_atk_other(target, LuaItemManager:get_item_obejct("skill"):get_cmd(msg.skillId))
				-- if target.is_player then -- 玩家，设置攻击目标，以便反击
				-- 	target:set_target(attacker)
				-- end

				self.character:is_leader_atk(attacker)
			else
			
			end
		end
	end

	if not attacker.is_self then -- TODO先不设位置(考虑到性能问题)
		if attacker.is_monster then
			local pos = self:covert_s2c_position(msg.posX, msg.posY)
			local function finish_cb()
				attacker:set_speed(attacker.normal_speed)
				Seven.PublicFun.SetPosition(attacker.transform, pos)
				play_atk()
			end
			attacker:stop_move()
			attacker:set_speed(attacker.normal_speed*ConfigMgr:get_const("monster_speed_scale"))
			attacker:move_to2(pos,finish_cb,0.3)
		else
			Seven.PublicFun.SetPosition(attacker.transform, self:covert_s2c_position(msg.posX, msg.posY))
			play_atk()
		end
	else
		LuaItemManager:get_item_obejct("skill"):add_play_skill(msg.skillId)
	end
end

-- 返回技能处理结果（广播)
function Battle:skill_cast_result_s2c( msg )
	gf_print_table(msg, "Battle:skill_cast_result_s2c:")
	local attacker = self:get_model(msg.caster)
	local cmd, skill_index = LuaItemManager:get_item_obejct("skill"):get_cmd(msg.skillId)
	if attacker and attacker.is_player and attacker:get_effect_list() then
		local effect = attacker:get_effect_list()[cmd]
		if effect then
			effect:show_hit_effect_s2c(msg.target)
		end
	end

	for k,v in pairs(msg.target or {}) do
		local obj = self.model_list[v.guid]
		if obj then
			obj:set_attacker(attacker)
			obj:hurt(v.damage, v.result)

			local show_hurt = obj.is_self or obj.is_self_hero -- 显示玩家自己的伤血
			if attacker then
				local is_player_atk = self.character.guid == attacker.guid
				if is_player_atk and skill_index >= ServerEnum.SKILL_POS.NORMAL_1 then -- 普通攻击造成的伤害
					Net:receive(nil, ClientProto.PlayNormalAtk)
				elseif is_player_atk and skill_index <ServerEnum.SKILL_POS.NORMAL_1 then
					Net:receive(nil, ClientProto.PlayNormalAtk)
				end

				show_hurt = show_hurt or is_player_atk -- 玩家自己造成的伤血
				show_hurt = show_hurt or (self.character.hero and self.character.hero.guid == attacker.guid) -- 玩家武将造成的伤血
			end

			if obj.is_player and obj.is_self and v.damage > 0 then
				v.result = 7 -- 玩家受伤,用不同颜色字体显示
			end

			if show_hurt then
				if not LuaItemManager:get_item_obejct("firstWar"):is_pass() and (obj.is_monster or obj.is_self) then -- 首场战斗战斗伤害数值加大
					v.damage = v.damage*math.random(101,109)
				end
				if attacker and (attacker.is_monster or attacker.is_hero) then
					if attacker.is_hero and not attacker:is_have_skill_ani(msg.skillId) then
						self.float_item:battle_float_text(obj.transform, v.result, v.damage)
					else
						if msg.leadIndex == 1 then
							-- 1断伤害 怪物/武将伤害延迟显示
							local data = {caster = msg.caster, target = v.guid, result = v.result, damage = v.damage}
							self:add_result(data)
						else
							self.float_item:battle_float_text(obj.transform, v.result, v.damage)
						end
					end
				else
					self.float_item:battle_float_text(obj.transform, v.result, v.damage)
				end
			end
		
		end
	end

end

-- buffer更新
function Battle:update_buffer_s2c( msg )
	-- gf_print_table(msg, "buffer更新:")

	local buff = msg.buff
	if not buff then
		return
	end

	if buff.updateType == ServerEnum.BUFF_UPDATE_TYPE.CREATE then -- 创建
		self:create_buffer(buff)

	elseif buff.updateType == ServerEnum.BUFF_UPDATE_TYPE.UPDATE then -- 更新
		self:update_buffer(buff)

	elseif buff.updateType == ServerEnum.BUFF_UPDATE_TYPE.REMOVE then -- 移除
		self:remove_buffer(buff.buffId..buff.ownerId)

	end
end

-- 人物跨格子
function Battle:cross_cell_c2s()
	local msg = {
		posX = self.character.transform.position.x*10,
		posY = self.character.transform.position.z*10,
	}
	-- gf_print_table(msg, "跨越格子，通知服务器:")
	Net:send(msg, "scene", "CrossCell")
end

-- 复活
function Battle:respawn_c2s( ty )
	gf_mask_show(true)
	local msg = {type = ty}
	gf_print_table(msg, "发送玩家复活协议:")
	Net:send(msg, "scene", "Respawn")
end

function Battle:respawn_s2c( msg )
	if self.is_self then
		gf_print_table(msg, "复活返回")
	end
	gf_mask_show(false)
	local obj = self.model_list[msg.guid]
	if obj then
		obj:revive(msg.hp)
		local ps = LuaItemManager:get_item_obejct("battle"):covert_s2c_position(msg.posX,msg.posY)
		obj:set_position(ps)
	end
end

local change_scene_cool_time = 0
-- 切换地图
function Battle:transfer_map_c2s(dst_map_id, x, y, is_read_line, transport_ty)
	-- print("切换地图",self.map_id,"到",dst_map_id)
	-- if self.on_transport then
	-- 	if self.last_stop_transfer_time + change_scene_cool_time < Net:get_server_time_s() then
	-- 		self.last_stop_transfer_time = Net:get_server_time_s()
	-- 		self:remove_model_effect(self.character.guid, ClientEnum.EFFECT_INDEX.TRANSPORT)
	-- 		self.on_transport = nil
	-- 	else
	-- 		gf_message_tips("正在传送")
	-- 		return
	-- 	end
	-- end
	Net:receive(false, ClientProto.StarOrEndSit) -- 取消打坐

	local map_data = ConfigMgr:get_config("mapinfo")[dst_map_id]
	x = x or map_data.delivery_posx
	y = y or map_data.delivery_posy
-- print("切换地图",self.map_id,"到",dst_map_id,x,y)
	transport_ty = transport_ty or ServerEnum.TRANSFER_MAP_TYPE.TRANSPORT_POINT

	local cancle_fn = function()
		if self.on_transport then
			self.last_stop_transfer_time = Net:get_server_time_s()
			self:remove_model_effect(self.character.guid, ClientEnum.EFFECT_INDEX.TRANSPORT)
			-- print("移除传送特效")
			self.on_transport = nil
		end
	end
	-- --判断是否正在寻路										--放到读条里面判断
	-- if self:get_character():is_move() then
	-- 	self:get_character():stop_move()
	-- 	LuaItemManager:get_item_obejct("map"):auto_move_end()
	-- end
	self:get_character():stop_follow()

	local to_change = function()
		cancle_fn()
		self.transfer_map_msg = {mapId = dst_map_id,posX=x,posY=y}

		if dst_map_id == self.map_id then -- 原地图传送，直接改变角色坐标
			if LuaItemManager:get_item_obejct("husong"):is_husong() then 
				gf_message_tips("正在护送中无法传送")
				return 
			end
			self.character:set_position(self:covert_s2c_position(x,y))
			self.character:reset_camera()
			if self.transfer_map_msg then
				Net:receive({map_msg = self.transfer_map_msg,map_type = 1},ClientProto.TransferMapFinish)
				self.transfer_map_msg = nil
			end

		else -- 其他情况，普通的切换场景
			dst_map_id = dst_map_id or self.last_map_id
			local msg = {
				srcMap = self.map_id,
				dstMap = dst_map_id,
				dstX = x,
				dstY = y,
				type = transport_ty,
			}
			gf_print_table(msg, "发送切换地图协议:"..dst_map_id.." x="..x.." y="..y)
			Net:send(msg, "scene", "TransferMap")
			self.dst_map_id = dst_map_id
			self.last_map_id = self.map_id
		end
	end


	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local need_lv = ConfigMgr:get_config("mapinfo")[dst_map_id].minlevel
	--判断等级是否足够传到
	if lv < need_lv then
		gf_message_tips(string.format(gf_localize_string("进入该地图需要%d等级"),need_lv))
		return
	end

	if is_read_line then --判断是否需要读条
		if dst_map_id == self.map_id and Vector2.Distance(self.character.transform.position,self:covert_s2c_position(x,y))<50 then
			-- print("距离短，寻路")
			local arrive_cb = function()
				-- print("寻路完成","距离")
				self.transfer_map_msg = {mapId = dst_map_id,posX=x,posY=y}
				Net:receive({map_msg = self.transfer_map_msg,map_type = 1},ClientProto.TransferMapFinish)
				self.transfer_map_msg = nil
			end
			self.character:move_to(self:covert_s2c_position(x,y), arrive_cb, 2, true)
		else
			-- print("距离长，传送")
			if self.last_stop_transfer_time + change_scene_cool_time > Net:get_server_time_s() then
				gf_message_tips("传送冷却中")
			else
				--判断该地图是否能传送
				if bit._and(ConfigMgr:get_config("mapinfo")[self.map_id].flags,16)~=16 then
					gf_message_tips(gf_localize_string("该地图无法传送"))
					return
				end


				local view = LuaItemManager:get_item_obejct("mainui"):collect_view() --切图读条
				if view then
					view:set_is_transmit()
					view:set_time(2.5) --设置传送读条时间
					view:set_name(gf_localize_string("传送中"))
					view:set_cancel(true)
					view:set_finish_cb(to_change)
					view:set_cancel_cb(cancle_fn)
					self.on_transport = dst_map_id
					
					-- print("读条传送")
					self:add_model_effect(self.character.guid, "41000017.u3d", ClientEnum.EFFECT_INDEX.TRANSPORT)
					-- print("添加传送特效")
				end
			end
		end
	else
		print("直接传送")
		to_change()
	end
end

-- 切换地图成功
function Battle:transfer_map_s2c( msg )
	gf_print_table(msg,"切换地图协议返回"..msg.dstMap.." x="..msg.dstX.." y="..msg.dstY)
	if msg.err == 0 then
		if self.map_id == msg.dstMap then -- 在同一张地图不切换(一般情况是副本用到)
			self.pool:clear_dead()

			if self.character then
				local pos = self:covert_s2c_position(msg.dstX, msg.dstY)
				self.character:set_position(pos)
				if self.character.hero then
					self.character.hero:set_position(gf_get_follow_pos(pos))
				end

				self.character:reset_camera()
				self.character:reset()
			end

			if self.transfer_map_msg then
				Net:receive({map_msg = self.transfer_map_msg,map_type = 2},ClientProto.TransferMapFinish)
				self.transfer_map_msg = nil
			end
		else
			self:change_scene(msg.dstMap, msg.dstCopyCode)

		end
	end
end

-- 自动挂机
function Battle:auto_combat_next_pos_c2s()
	print("自动挂机")
	Net:send({}, "scene", "AutoCombatNextPos")
end

function Battle:auto_combat_next_pos_s2c( msg )
	print("请求自动关机位置",self.character.transform.position)
	gf_print_table(msg, "自动挂机返回：")
	local function cb()
		self.character:set_auto_attack(self:is_auto_atk())
	end

	if msg.posX and msg.posY then
		self.character:move_to(self:covert_s2c_position(msg.posX, msg.posY), cb, nil, true)
	else
		self.character:set_auto_attack(self:is_auto_atk())
	end
end

-- 请求设置pk模式
function Battle:set_pk_mode_c2c( mode, force )
	if self.set_pk_mode_time and not force then
		if Net:get_server_time_s() - self.set_pk_mode_time <= 10 then
			gf_message_tips(gf_localize_string("10秒内不可重复切换"))
			return
		end
	end

	self.set_pk_mode_time = Net:get_server_time_s()
	print("设置pk模式",mode)
	Net:send({mode = mode}, "scene", "SetPkMode")
end

-- 会主动推送
function Battle:set_pk_mode_s2c( msg )
	gf_print_table(msg, "pk模式返回")
	if msg.err ~= 0 then
		return
	end
	self.pk_mode = msg.mode
end

--此协议广播给周围玩家和自己
function Battle:combat_status_change_s2c( msg )
	gf_print_table(msg, "战斗状态改变:")
	local obj = self:get_model(msg.guid)
	if obj then
		obj:set_battle_flag(msg.isInCombat)
	else
		self:add_msg(msg.guid, msg.isInCombat, "set_battle_flag")
	end
end

--播放转镜协议
function Battle:stop_ai_updata_c2s(time)
	print("播放转镜协议",time)
	Net:send({interval = time}, "scene", "StopAiUpdate")
end

-- 取消转镜协议
function Battle:continue_ai_update()
	Net:send({}, "scene", "ContinueAiUpdate")
end

function Battle:relocate_player_pos_s2c( msg )
	gf_print_table(msg, "重置玩家到指定位置：")
	local pos = self:covert_s2c_position(msg.posX, msg.posY)
	self.character:set_position(pos)
	self.character:reset_camera()
end

--服务器返回
function Battle:on_receive( msg, id1, id2, sid )

	if self.character then
		self.character:on_receive(msg, id1, id2, sid)
	end

	if self.pool then
		self.pool:on_receive(msg, id1, id2, sid)
	end

	if id1==Net:get_id1("scene") then

		if id2 == Net:get_id2("scene", "UpdateObjectR") then -- 创建,更新,移除通用协议
			self:update_object_s2c(msg)

		elseif id2== Net:get_id2("scene", "ObjectMoveR")then -- 对象移动广播
			self:object_move_s2c(msg)

		elseif id2== Net:get_id2("scene", "SkillCastR") then -- 失败只返回给释放者，成功则广播
			self:skill_cast_s2c(msg)

		elseif id2== Net:get_id2("scene", "SkillCastResultR") then -- 返回技能处理结果（广播）
			self:skill_cast_result_s2c(msg)

		elseif id2== Net:get_id2("scene", "RespawnR") then --
			self:respawn_s2c(msg)

		elseif id2 == Net:get_id2("scene", "BuffUpdateR") then -- buffer更新
			self:update_buffer_s2c(msg)

		elseif id2 == Net:get_id2("scene", "AutoCombatNextPosR") then -- 客户端请求行走的下一个目标点
			self:auto_combat_next_pos_s2c(msg)

		elseif id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			self:transfer_map_s2c(msg)

		elseif id2 == Net:get_id2("scene", "SetPkModeR") then -- 战斗模式
			self:set_pk_mode_s2c(msg)

		elseif id2 == Net:get_id2("scene", "CombatStatusChangeR") then -- 战斗状态
			self:combat_status_change_s2c(msg)

		elseif id2== Net:get_id2("scene", "SceneSpecialEffectsR") then -- 播放特效
			gf_play_effect(msg.code,LuaItemManager:get_item_obejct("battle"):covert_s2c_position(msg.posX,msg.posY))

		elseif id2== Net:get_id2("scene", "RelocatePlayerPosR") then -- 重置玩家到指定位置
			self:relocate_player_pos_s2c(msg)
		end

	elseif id1 == ClientProto.ShowMainUIAutoAtk then -- 挂机
		if not self.character then
			return
		end

		local auto_atk = self:is_auto_atk()
		if auto_atk then
			self:auto_combat_next_pos_c2s()
		else
			self.character:set_auto_attack(auto_atk)
		end


	elseif id1 == ClientProto.PlayerLoaderFinish then
		Net:receive(false, ClientProto.StarOrEndSit) -- 取消打坐
		self:set_deemo_visible(false)
		self:is_change_scene_finish()

	elseif id1 == ClientProto.JoystickStartMove then
		self.task_info.is_task = false

	elseif id1 == ClientProto.AllLoaderFinish then--所有加载完成
		self:check_npc_follow_in_scene()
		if self.transfer_map_msg then
			Net:receive({map_msg = self.transfer_map_msg,map_type = 2},ClientProto.TransferMapFinish)
			self.transfer_map_msg = nil
		end
	end
end

--点击事件
function Battle:on_click(obj,arg)
	if self.character then
		self.character:on_click(obj, arg)
	end
end

