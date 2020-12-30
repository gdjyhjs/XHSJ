--[[--
-- 人物或怪物状态变化更新
-- @Author:Seven
-- @DateTime:2017-04-20 09:44:55
--]]
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Transport = require("models.battle.obj.transport")
local Enum = require("enum.enum")
local TransportConfig = require("config.transport")
local MapMonsters = require("config.map.mapMonsters")
local Buffer = require("models.battle.obj.buffer")
local Wing = require("models.battle.obj.wing")
local BloodLineView = require("models.bloodLine.bloodLineView")
local Effect = require("common.effect")
local XpEffect = require("models.battle.obj.xpEffect")

local Battle = LuaItemManager:get_item_obejct("battle")

local CareerConfig = 
{
	[ServerEnum.CAREER.SOLDER] = ConfigMgr:get_config("roleSolder"),
	[ServerEnum.CAREER.MAGIC] = ConfigMgr:get_config("roleMagic"),
	[ServerEnum.CAREER.BOWMAN] = ConfigMgr:get_config("roleBowman"),
}

local SkillList = 
{
	[ServerEnum.CAREER.SOLDER] = {11401001, 11402001, 11403001, 11404001, 11405001, 11406001},
	[ServerEnum.CAREER.MAGIC] = {11101001, 11102001, 11103001, 11104001, 11105001, 11106001},
	[ServerEnum.CAREER.BOWMAN] = {11201001, 11202001, 11203001, 11204001, 11205001, 11206001},
}

-- 第一场战斗默认用第一套模型
local PlayerModel = 
{
	[ServerEnum.CAREER.SOLDER] = 114101,
   	[ServerEnum.CAREER.MAGIC] = 111101,
    [ServerEnum.CAREER.BOWMAN] = 112101,
}

local WeaponModel = 
{
	[ServerEnum.CAREER.SOLDER] = 124101,
   	[ServerEnum.CAREER.MAGIC] = 121101,
    [ServerEnum.CAREER.BOWMAN] = 122101,
}

-- 获取更新值列表
function Battle:get_update_value( data )
	if not data then
		return {}
	end

	local list = {}
	for k,v in pairs(data.updateMask or {}) do
		list[v] = data.updateValue[k]
	end
	return list
end

-- 创建一个怪物 
-- url:资源
function Battle:create_monster( data )
	local update_value = self:get_update_value(data)

	local hp = update_value[Enum.UNIT_FIELDS.UNIT_HP]
	local max_hp = update_value[Enum.UNIT_FIELDS.UNIT_MAX_HP]
	local speed = update_value[Enum.UNIT_FIELDS.UNIT_SPEED]*0.1
	
	local monster_id = update_value[Enum.OBJ_FIELDS.OBJ_PROTO_ID]

	-- 战场阵营
	local faction = update_value[Enum.UNIT_FIELDS.UNIT_FACTION]

	print("创建怪物 id =",monster_id,data.guid,faction)

	local finish_cb = function( monster )
		print("创建怪物完成",data.guid,self:covert_s2c_position(data.x, data.y))
		local scale = monster.config_data.model_scale or 1

		monster.config_data = copy(ConfigMgr:get_config("creature")[monster_id])
		monster.config_data.level = update_value[Enum.UNIT_FIELDS.UNIT_LEVEL]
		monster:set_position(self:covert_s2c_position(data.x, data.y))
		monster:set_eulerAngles(Vector3(0, self:get_s2c_angle(data.dir) or 0, 0))
		monster:set_speed(speed)
		monster:set_hp(hp, max_hp)
		monster:set_scale(Vector3(scale, scale, scale))
		
		monster:set_faction(faction)
		--如果不幸已经被杀死删除 
		print("wtf monster.dead",monster.dead,monster.is_faraway)
		if monster.dead or monster.is_faraway then
			monster.dead = true
			monster.is_faraway = true
			monster:show_dead()
			return
		end

		monster:reset()

		-- 自动挂机寻怪，找到最近的怪物
		if self:is_auto_atk() and gf_table_length(self.enemy_list) == 1 and self.character then
			self.character:stop_auto_move(false)
			self.character:set_auto_attack(true)
		end

		-- 测试用
		if DEBUG then
			monster.root.name = monster.config_data.model_id.."(active)guid:"..data.guid
		end
		gf_receive_client_prot({monster_id = monster_id,guid = data.guid}, ClientProto.MonsterLoaderFinish)
	end

	local luaObjectMonster = self.pool:get_monster(monster_id, finish_cb)
	luaObjectMonster:set_guid(data.guid)
	self:check_msg(luaObjectMonster)
	self:add_model(luaObjectMonster)
	self:add_enemy(luaObjectMonster)

	return luaObjectMonster
end

function Battle:refresh_monsters_blood_line()
	for k,v in pairs(self.enemy_list) do
		if v.blood_line then
			v.blood_line:refresh_hp()
		end
	end
end

-- 创建一个玩家
-- url:资源
function Battle:create_character( data, is_self, is_mirror )
	local update_value = self:get_update_value(data)

	local career = update_value[Enum.PLAYER_FIELDS.PLAYER_CAREER]
	local pk_mode = update_value[Enum.PLAYER_FIELDS.PLAYER_PK_MODE]
	local recover_hp = update_value[Enum.PLAYER_FIELDS.PLAYER_HP_RECOVER]
	local level = update_value[Enum.UNIT_FIELDS.UNIT_LEVEL]
	local hp = update_value[Enum.UNIT_FIELDS.UNIT_HP]
	local max_hp = update_value[Enum.UNIT_FIELDS.UNIT_MAX_HP]
	local speed = update_value[Enum.UNIT_FIELDS.UNIT_SPEED]*0.1
	local player_info = data.playerInfo
	local title = update_value[Enum.PLAYER_FIELDS.PLAYER_TITLE]
	local helmet_id = update_value[Enum.PLAYER_FIELDS.PLAYER_EQUIP_HELMET]-- 铠甲 
	local weapon_id = update_value[Enum.PLAYER_FIELDS.PLAYER_EQUIP_WEAPON]-- 武器 
	local player_viplevel = update_value[Enum.PLAYER_FIELDS.PLAYER_VIP_LEVEL]
	local model_id -- 模型id
	local weapon_model -- 武器模型
	local wing_model -- 翅膀
	local surround_model -- 气息
	local model_img -- 材质球图片
	local weapon_img
	local wing_img
	local weapon_flow_img
	local weapon_flow_color
	local weapon_flow_speed
	local weapon_effect
	local wing_flow_img
	local wing_flow_color
	local wing_flow_speed
	local wing_effect

	if helmet_id and helmet_id > 0 then
		model_id = ConfigMgr:get_config("item")[helmet_id].effect_ex[1]
	end

	if weapon_id and weapon_id > 0 then
		weapon_model = ConfigMgr:get_config("item")[weapon_id].effect_ex[1]
	end

	-- 外观 （优先显示）
	local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_CLOTHES]
	if surface_id and surface_id > 0 then
		local data = ConfigMgr:get_config("surface")[surface_id]
		model_id = data.model
		model_img = data.model_img
	end

	local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_WEAPON]
	if surface_id and surface_id > 0 then
		local data = ConfigMgr:get_config("surface")[surface_id]
		weapon_model = data.model
		weapon_img = data.model_img
		weapon_flow_img = data.flow_img
		weapon_flow_color = data.flow_color
		weapon_flow_speed = data.flow_speed
		weapon_effect = data.effect
	end

	local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_CARRY_ON_BACK]
	if surface_id and surface_id > 0 then
		local data = ConfigMgr:get_config("surface")[surface_id]
		wing_model = data.model
		wing_img = data.model_img
		wing_flow_img = data.flow_img
		wing_flow_color = data.flow_color
		wing_flow_speed = data.flow_speed
		wing_effect = data.effect
	end

	-- 去掉气息 策划需求
	-- local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_SURROUND]
	-- if surface_id and surface_id > 0 then
	-- 	surround_model = ConfigMgr:get_config("surface")[surface_id].model
	-- end

	-- 能量珠
	local energy_1 = update_value[Enum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD1]
	local energy_2 = update_value[Enum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD2]
	local energy_3 = update_value[Enum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD3]
	-- 掉落归属
	local drop = update_value[Enum.PLAYER_FIELDS.PLAYER_DROP_BELONG]

	-- 战场阵营
	local faction = update_value[Enum.UNIT_FIELDS.UNIT_FACTION]

	print("玩家职业:",career,faction)

	if is_self then
		if self.map_id == 160201 then -- 首场战斗
			model_id = PlayerModel[career]
			weapon_model = WeaponModel[career]
		end
	end

	print("玩家模型id =",model_id)
	print("玩家武器id =",weapon_model)
	print("玩家翅膀id =",wing_model)
	print("玩家气息id =",surround_model)

	local config_data
	local finish_cb = function(character)

		config_data = character.config_data
		config_data.level = level
		config_data.hp = hp
		config_data.max_hp = max_hp
		config_data.speed = speed
		config_data.viplevel = player_viplevel
		config_data.career = career
		config_data.title = title
		config_data.name = data.playerInfo.name

		print("玩家坐标:",data.x,data.y)
		character:change_material_img(model_img)
		character:set_move_forward(false)
		character:set_position(self:covert_s2c_position(data.x, data.y))
		character:set_eulerAngles(Vector3(0, self:get_s2c_angle(data.dir), 0))
		character:set_speed(speed)
		character:set_guid(data.guid)
		character:set_mirror(is_mirror)
		character:set_self(is_self)
		character:set_faction(faction)
		character:set_battle_flag(false, true)
		character:init_hp(hp, max_hp)
		character:set_hp(hp, max_hp )
		character.recover_hp = recover_hp or 0

		local is_follow = LuaItemManager:get_item_obejct("team"):is_follow()
		if is_follow then
			character:set_follow(is_follow)
			character:stop_follow()
		end

		local blood_line = character.blood_line
		blood_line:set_energy_1(energy_1)
		blood_line:set_energy_2(energy_2)
		blood_line:set_energy_3(energy_3)
		blood_line:set_faction(faction)
		blood_line:set_vip(player_viplevel)
		if drop then
			blood_line:show_drop(drop > 0)
		end

		if character.is_in_pool ~= true then
			self:check_msg(character)
			self:add_model(character)
			self:add_character(character)


			-- 检查是否有缓存需要加载
			if self.temp_hero_load_list[data.guid] then
				self:create_hero(self.temp_hero_load_list[data.guid])
			end

			if is_self then
				self.character = character
				character:set_camera()
				character:enable_joystick(true)
				character:set_can_transport(true)
				character:set_auto_attack(self:is_auto_atk())

				local xp_per = ConfigMgr:get_config("mapinfo")[self.map_id].xp_per
				if xp_per and xp_per > 0 then
					character:set_xp_per(xp_per)
					local skill_id = LuaItemManager:get_item_obejct("skill"):get_skill_id(ServerEnum.SKILL_POS.XP)
					local effect = XpEffect(ConfigMgr:get_config("xp_effect")[skill_id],nil,character)
				    effect:set_player()
				    character:add_effect(effect, "xp")

				end

				self:refresh_npc_blood_line()
				self:refresh_monsters_blood_line()
				self:refresh_models_show()
				
			end
			-- 更新一下打坐，坐骑信息
			self:update_player_dynamic_flags(update_value, character)

			character:reset()

			local weapon_cb = function( weapon )
				if is_self then
					Net:receive(character, ClientProto.PlayerLoaderFinish)
				end
				weapon:change_material_img(weapon_img)
				weapon:set_flow_img(weapon_flow_img, weapon_flow_color, weapon_flow_speed)
				weapon:set_effect(weapon_effect)
			end
			
			self.pool:get_weapon(weapon_model, character, weapon_cb)

			local wind_cb = function( wing )
				wing:change_material_img(wing_img)
				wing:set_flow_img(wing_flow_img, wing_flow_color, wing_flow_speed)
				wing:set_effect(wing_effect)
			end
			self:create_wing(wing_model, character, wind_cb)

			self:create_surround(surround_model, character)

			-- 测试用
			if DEBUG then
				character.root.name = config_data.model_id.."(active)guid:"..data.guid
			end
		end
	end
	

	return self.pool:get_character(model_id, career, level, finish_cb)
end

-- 更换玩家模型
function Battle:change_player_model( guid, model_id )
	print("更换玩家模型",guid,model_id)
	local player = self:get_model(guid)
	local config_data = player.config_data
	local is_move = player:is_move()
	local is_self = player.is_self
	if is_self then
		player:enable_joystick(false)
	end

	local finish_cb = function( new_player )
		local player = self:get_model(guid)
		if player == nil then return end
		local model = new_player.config_data.model_id
		new_player.config_data = gf_deep_copy(config_data)
		new_player.config_data.model_id = model

		new_player:set_guid(player.guid)
		new_player:set_self(is_self)
		if player:is_horse() then
			new_player:set_position(player.horse.transform.position)
			new_player:set_eulerAngles(player.horse.transform.eulerAngles)
			new_player:set_scale(Vector3(1,1,1))
		else
			new_player:set_position(player.transform.position)
			new_player:set_eulerAngles(player.transform.eulerAngles)
			new_player:set_scale(Vector3(1,1,1))
		end
		new_player:set_speed(player.speed)
		new_player:set_hp(player.hp, player.max_hp)
		local is_follow = LuaItemManager:get_item_obejct("team"):is_follow()
		if is_follow then
			new_player:set_follow(is_follow)
			new_player:stop_follow()
		end
		
		-- 设置武将
		local hero = player.hero
		if hero then
			hero:set_follow_target(new_player)
			local pos = new_player.transform.position
			pos.z = pos.z - 3
			hero:set_position(pos)
			new_player:set_hero(hero)
		end

		-- 设置武器
		if player.weapon.is_in_pool ~= true then
			player.weapon:set_player(new_player)
		end
		if player.wing and player.wing.is_in_pool ~= true then
			player.wing:set_player(new_player)
		end

		if player.surround then
			player.surround:set_parent(new_player.transform)
		end

		new_player:reset()
		if is_move then
			player:stop_move()
			if is_self then
				new_player:task_move(player:get_estination_pos(), player.auto_move_end_fn, player:get_min_distance())
			else
				new_player:set_move_forward(true)
			end
		end

		if is_self then
			new_player:enable_joystick(true)
			new_player:set_camera()
			self.character = new_player

			local xp_per = ConfigMgr:get_config("mapinfo")[self.map_id].xp_per
			if xp_per and xp_per > 0 then
				new_player:set_xp_per(xp_per)
				XpEffect(new_player)
			end

			if player.is_auto_attack then
				player:set_auto_attack(false)
				new_player:set_auto_attack(true)
			end
		end


		new_player:set_horse(player.horse)
		new_player.is_sit = player.is_sit
		new_player.is_pair_sit = player.is_pair_sit

		if new_player.is_sit == true then
			new_player:sit()
			if new_player.is_pair_sit == true then
				new_player:show_sit_effect(true)
			else
				new_player:show_sit_effect(false)
			end
		end

		player:set_hero(nil)
		player:set_weapon(nil)
		player:set_wing(nil)
		player:set_surround(nil)
		player:set_is_horse(false)
		player.is_self = false

		self:remove_model(guid)
		self:add_model(new_player)
		self:add_character(new_player)

		-- 测试用
		if DEBUG then
			new_player.root.name = new_player.config_data.model_id.."(active)guid:"..new_player.guid
		end
	end
	return self.pool:get_character(model_id, config_data.career, config_data.level, finish_cb)
end

-- 更换武器
function Battle:change_weapon( player, model_id, cb )
	local weapon = player.weapon
	local new_weapon = self.pool:get_weapon(model_id, player, cb)
	self.pool:add_weapon(weapon)
	return new_weapon
end

function Battle:refresh_npc_blood_line()
	for k,v in pairs(self.npc_list) do
		if v.blood_line then
			v.blood_line:refresh_hp()
		end
	end
end

function Battle:create_npc( data, server_npc )
	local npc = self:get_npc(data.npc_id)
	if npc then
		return npc
	end

	local update_value = self:get_update_value(data)
	
	local npc_id
	if server_npc then
		npc_id = update_value[Enum.OBJ_FIELDS.OBJ_PROTO_ID]
	else
		npc_id = data.npc_id
	end
	print("创建npc id =",npc_id,data.guid)

	local crate_data = 
	{
		code = npc_id,
		pos = {x = data.x, y = data.y},
		dir = data.dir or 0,
	}
	local finish_cb = function( npc )
		print("创建npc完成",data.guid,npc.config_data.name)

		npc:set_position(self:covert_s2c_position(crate_data.pos.x, crate_data.pos.y))
		npc:set_task_data(LuaItemManager:get_item_obejct("task"):get_task_data(npc_id))
		npc:set_eulerAngles(Vector3(0, crate_data.dir or 0, 0))
		npc:set_server_npc(server_npc)
		npc:set_guid(data.guid)
		npc:reset(npc.config_data)

		self:add_model(npc)
		self:add_npc(npc)

		-- 测试用
		if DEBUG then
			npc.root.name = npc.config_data.model.."guid:"..data.guid..","..npc.config_data.name..","..npc.config_data.code..","..(data.name or "")
		end
	end
	return self.pool:get_npc(npc_id, finish_cb)
end

-- 刷新npc
function Battle:refresh_npc(task_data)
	local status = task_data.status
	
	if status == ServerEnum.TASK_STATUS.COMPLETE then
		local npc = self:get_npc(task_data.receive_npc)
		if npc then
			npc:set_task_data(nil)
			npc:hide_all_effect()
		end
		local npc = self:get_npc(task_data.finish_npc)
		if npc then
			npc:set_task_data(task_data)
			npc:show_finish_effect()
		end

	elseif status == ServerEnum.TASK_STATUS.AVAILABLE then
		local npc = self:get_npc(task_data.finish_npc)
		if npc then
			npc:set_task_data(nil)
			npc:hide_all_effect()
		end
		
		local npc = self:get_npc(task_data.receive_npc)
		if npc then
			npc:set_task_data(task_data)
			npc:show_receive_effect()
		end

	elseif status == ServerEnum.TASK_STATUS.PROGRESS or 
	       status == ServerEnum.TASK_STATUS.FINISH then
		local npc = self:get_npc(task_data.finish_npc)

		if npc then
			if  status == ServerEnum.TASK_STATUS.PROGRESS then
				npc:set_task_data(task_data)
				npc:show_receive_effect()
			else
				npc:set_task_data(nil)
				npc:hide_all_effect()
			end
		end

		local npc = self:get_npc(task_data.receive_npc)
		if npc then
			npc:set_task_data(nil)
			npc:hide_all_effect()
		end

	end
end

-- 创建传送点
function Battle:create_transport()
	if not MapMonsters[self.map_id] then
		return
	end
	
	local transport_list = MapMonsters[self.map_id][Enum.MAP_OBJECT_TYPE.TRANPORT]
	if not transport_list then
		return
	end

	if not self.transprot_parent then
		self.transprot_parent = LuaHelper.Find("Transport").transform
	end
	
	for k,v in pairs(transport_list) do
		local config_data = copy(TransportConfig[v.code])

		if not config_data then
			gf_error_tips("传送配置表找不到数据："..v.code)
		end
		local t = Transport(config_data)
		t:set_parent(self.transprot_parent)

		local pos = self:covert_s2c_position(v.pos.x, v.pos.y)
		pos.y = pos.y + (config_data.high or 0)
		t:set_position(pos)
		t:set_eulerAngles(Vector3(0, v.dir or 0, 0))
		t:set_guid(ClientEnum.GUID.TRANSPORT+v.uid)

		self:add_transport(t)
		self:add_model(t)
	end
end

-- 创建buffer
function Battle:create_buffer( data )
	local guid = data.buffId..data.ownerId
	if self.buffer_list[guid] then
		return
	end

	local cb = function( buffer )
		buffer:set_guid(guid)
		self.buffer_list[guid] = buffer
	end
	local config = ConfigMgr:get_config("buff")
	local buffer = Buffer(config[data.buffId], data.casterId, data.ownerId, cb)
	return buffer
end

-- 刷新buffer
function Battle:update_buffer( data )
	print("刷新buffer") -- TODO
end

-- 删除buffer
function Battle:remove_buffer( guid )
	local buffer = self.buffer_list[guid]
	
	if not buffer then
		return
	end
	buffer:dispose()
	self.buffer_list[guid] = nil
end

-- 坐骑
function Battle:ride( is_ride, player, horse_id )
	print("上下坐骑",is_ride, player, horse_id)

	local finish_cb = function( effect )
		self:remove_effect(effect)
	end

	local effect_cb = function( effect )
		effect:show_effect(player.transform.position)
		effect:set_finish_cb(finish_cb)
	end

	if is_ride then

		-- 上下马特效
		self:get_effect(41000094, effect_cb)

		-- 同一匹马，不刷新
		if player.horse and player.horse.config_data.code == horse_id then
			return
		end

		if player.is_self then
			horse_id = gf_getItemObject("horse"):get_magic_id()
		end

		if not horse_id or horse_id <= 0 then
			return
		end
		local guid = player.guid
		local finish_cb = function(horse)
			local player = self:get_model(guid)
			if player ~= nil and horse.is_in_pool ~= true then
				player:set_horse(horse)

				if self.character and self.character.is_follow and self.character.follow_target == player then -- 队长上坐骑，设置跟随目标为队长坐骑
					print("队长上坐骑")
					self.character:set_follow_target(horse)
				end
			end
		end

		self.pool:get_horse(horse_id, finish_cb)
		
	else
		if self.character and self.character.is_follow and self.character.follow_target == player.horse then -- 队长上坐骑，设置跟随目标为队长坐骑
			print("队长下坐骑")
			self.character:set_follow_target(player)
		end
		player:set_horse(nil)
		-- 下马特效
		self:get_effect(41000095, effect_cb)
	end
end

-- 武将
function Battle:create_hero(data)
	-- 判断玩家是否创建完成,没加载完成，放进缓存列表
	local player = self:get_model(data.ownerGuid)
	if not player or not player:is_loaded() then
		self.temp_hero_load_list[data.ownerGuid] = data
		return
	end

	gf_print_table(data,"wtf hero data:")

	print("创建武将",player,data.ownerGuid,data.guid)
	if self:get_model(data.guid) then
		return
	end

	local update_value = self:get_update_value(data)
	local hero_id = update_value[Enum.OBJ_FIELDS.OBJ_PROTO_ID]
	local level = update_value[Enum.UNIT_FIELDS.UNIT_LEVEL]

	local finish_cb = function( hero )
		hero.config_data.level = level
		if data.creatureInfo and data.creatureInfo.title then
			hero.config_data.title = data.creatureInfo.title
		end
		if data.creatureInfo and data.creatureInfo.name then
			hero.config_data.name = data.creatureInfo.name ~= "" and data.creatureInfo.name or hero.config_data.name
		end

		hero:set_guid(data.guid)
		local player = self:get_model(data.ownerGuid)
		if player ~= nil and hero.is_in_pool ~= true then
			if player:is_horse() then
				hero:set_follow_target(player.horse)
			else
				hero:set_follow_target(player)
			end
			hero:set_ower(player)
			hero:set_follow(true)
			hero:set_target_follow_move(player:is_follow_move())
			hero:set_speed(player.config_data.speed)
			hero:set_hp(update_value[Enum.UNIT_FIELDS.UNIT_HP], update_value[Enum.UNIT_FIELDS.UNIT_MAX_HP])
			hero:set_name(hero.config_data.name)
			local pos = self:covert_s2c_position(data.x, data.y)
			if not Seven.PublicFun.CheckTwoPosHitWall(player.transform.position, pos) then
				hero:set_position(pos)
			else
				local pos = player.transform.position
				hero:set_position(gf_get_follow_pos(pos))
			end
			hero:reset()
			player:set_hero(hero)

			self:add_model(hero)

			if DEBUG then
				hero.root.name = hero.config_data.model_id.."("..data.guid..")"
			end
			Net:receive({}, ClientProto.HeroLoaderFinish)
		else
		end
	end

	local old_hero = player:get_hero()
	--self.pool:add_hero(old_hero)
	if old_hero ~= nil then
		self:remove_model(old_hero.guid)
	end
	player:set_hero(nil)

	return self.pool:get_hero(hero_id, finish_cb)
end

-- 创建翅膀
function Battle:create_wing(model_id, player, cb)
	if not model_id then
		self.pool:add_wing(player.wing)
		player:set_wing(nil)
		return nil
	end

	local wing = player.wing
	self.pool:add_wing(wing)
	local new_wing = self.pool:get_wing(model_id, player, cb)
	player:set_wing(new_wing)
	if model_id then
		return new_wing
	end
	return nil
end

-- 创建气息
function Battle:create_surround( model_id, player, cb )
	if not model_id then -- 为空是卸下
		self.pool:add_effect(player.surround)
		return
	end

	local surround = player.surround
	local finish_cb = function( surround )
		surround:show()
		local parent = LuaHelper.FindChild(player.root, "Bip001").transform
		surround:set_parent(parent)
		surround.transform.localPosition = Vector3(0,0,0)
		surround:set_local_euler_angles(Vector3(0,0,0))
		if cb then
			cb(surround)
		end
	end
	if model_id then
		local new_surround = self.pool:get_effect(model_id, finish_cb)
		player:set_surround(new_surround)
	end
	self.pool:add_effect(surround)
end


-- 物体属性变化更新
function Battle:update_object( data )
	gf_print_table(data,"Battle:update_object")
	local update_value = self:get_update_value(data)

	-- 获取玩家动态标记(骑乘，打坐，护送等状态的显示)
	local dynamic_flag = update_value[ServerEnum.UNIT_FIELDS.UNIT_DYNAMIC_FLAGS]
	print("1玩家动态标记",dynamic_flag)

	local obj = self:get_model(data.guid)
	if not obj then
		print_error("ERROR:找不到更新的物品 guid =", data.guid)
		return
	end
	--如果没有初始化完 不执行
	if not obj.is_init then
		return
	end
	if update_value[ServerEnum.UNIT_FIELDS.UNIT_HP] then -- 当前生命
		obj:set_hp(update_value[ServerEnum.UNIT_FIELDS.UNIT_HP], obj.max_hp)
	end

	if update_value[ServerEnum.UNIT_FIELDS.UNIT_MAX_HP] then -- 最大生命
		if obj.is_player then
			print("设置玩家最大血量",update_value[ServerEnum.UNIT_FIELDS.UNIT_MAX_HP])
		end
		obj.max_hp = update_value[ServerEnum.UNIT_FIELDS.UNIT_MAX_HP]
	end

	if update_value[ServerEnum.UNIT_FIELDS.UNIT_SPEED] then -- 移动速度
		obj:set_speed(update_value[ServerEnum.UNIT_FIELDS.UNIT_SPEED]*0.1)
	end

	if update_value[ServerEnum.PLAYER_FIELDS.PLAYER_PK_MODE] then -- pk模式
		obj:set_pk_mode(update_value[ServerEnum.PLAYER_FIELDS.PLAYER_PK_MODE])
	end

	if update_value[ServerEnum.PLAYER_FIELDS.PLAYER_TITLE] then -- 称号
		obj.config_data.title = update_value[ServerEnum.PLAYER_FIELDS.PLAYER_TITLE]
		obj.blood_line:set_info(obj.config_data.name or "", obj.config_data.title or "")
	end
	if update_value[ServerEnum.PLAYER_FIELDS.PLAYER_VIP_LEVEL] then -- vip
		obj.config_data.viplevel = update_value[ServerEnum.PLAYER_FIELDS.PLAYER_VIP_LEVEL]
		obj.blood_line:set_vip(obj.config_data.viplevel or 0)
	end 

	print("能量珠1",update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD1])
	if update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD1] then -- 能量珠
		local energy = update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD1]
		obj.blood_line:set_energy_1(energy)
	end
	print("能量珠2",update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD2])
	if update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD2] then -- 能量珠
		local energy = update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD2]
		obj.blood_line:set_energy_2(energy)
	end
	print("能量珠3",update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD3])
	if update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD3] then -- 能量珠
		local energy = update_value[ServerEnum.PLAYER_FIELDS.PLAYER_ENERGY_BEAD3]
		obj.blood_line:set_energy_3(energy)
	end

	-- 掉落归属
	local drop = update_value[Enum.PLAYER_FIELDS.PLAYER_DROP_BELONG]
	if drop then
		obj.blood_line:show_drop(drop>0)
	end

	local hp = update_value[Enum.PLAYER_FIELDS.PLAYER_HP_RECOVER]
	if hp and obj.is_self then
		if obj.recover_hp == nil then
			obj.recover_hp = 0
		end
		local dh = hp - obj.recover_hp
		obj.recover_hp = hp
		if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
			dh = dh*100
		end
		if 0 < dh then
			LuaItemManager:get_item_obejct("floatTextSys"):battle_float_text(obj.transform,"zhiliao",dh)
		end
	end
	local helmet_id = update_value[Enum.PLAYER_FIELDS.PLAYER_EQUIP_HELMET]-- 铠甲
	if helmet_id then
		local model_id
		if helmet_id > 0 then
			model_id = ConfigMgr:get_config("item")[helmet_id].effect_ex[1]
		end
		self:change_player_model(data.guid, model_id)
		LuaItemManager:get_item_obejct("surface"):get_surface_info_c2s()
	end
	
	local weapon_id = update_value[Enum.PLAYER_FIELDS.PLAYER_EQUIP_WEAPON]-- 武器 
	if weapon_id then
		local weapon_model
		if weapon_id > 0 then
			weapon_model = ConfigMgr:get_config("item")[weapon_id].effect_ex[1]
		end
		self:change_weapon(obj, weapon_model)
		LuaItemManager:get_item_obejct("surface"):get_surface_info_c2s()
	end

	-- 外观 （优先显示）
	local new_player
	local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_CLOTHES]
	if surface_id and surface_id > 0 then
		local _d = ConfigMgr:get_config("surface")[surface_id]
		local player = self:change_player_model(data.guid, _d.model)
		player:change_material_img(_d.model_img)
		new_player = player
	end

	local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_WEAPON]
	if surface_id and surface_id > 0 then
		local _d = ConfigMgr:get_config("surface")[surface_id]
		local weapon_cb = function( weapon )
			if _d.model_img then
				weapon:change_material_img(_d.model_img)
			end
			if _d.flow_img then
				weapon:set_flow_img(_d.flow_img, _d.flow_color, _d.flow_speed)
			end
			if _d.effect then
				weapon:set_effect(_d.effect)
			end
			if new_player ~= nil then
				weapon:set_player(new_player)
			end
		end
		self:change_weapon(obj, _d.model, weapon_cb)
	end

	local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_CARRY_ON_BACK]
	if surface_id and surface_id > 0 then
		local _d = ConfigMgr:get_config("surface")[surface_id]
		local wing_cb = function( wing )
			if _d.model_img then
				wing:change_material_img(_d.model_img)
			end
			if _d.flow_img then
				wing:set_flow_img(_d.flow_img, _d.flow_color, _d.flow_speed)
			end
			if _d.effect then
				wing:set_effect(_d.effect)
			end
			if new_player ~= nil then
				wing:set_player(new_player)
			end
		end
		self:create_wing(_d.model, obj, wing_cb)
	elseif surface_id == 0 then
		self:create_wing(nil, obj)
	end

	-- 去掉气息 策划需求
	-- local surface_id = update_value[Enum.PLAYER_FIELDS.PLAYER_SURFACE_SURROUND]
	-- if surface_id then
	-- 	local surround_model
	-- 	if surface_id > 0 then
	-- 		surround_model = ConfigMgr:get_config("surface")[surface_id].model
	-- 	end
	-- 	self:create_surround(surround_model, obj)
	-- end

	if obj.is_player then
		self:update_player_dynamic_flags(update_value, obj)
	end
end

-- 更新玩家打坐、骑乘、护送
function Battle:update_player_dynamic_flags( update_value, obj )
	if update_value[ServerEnum.UNIT_FIELDS.UNIT_DYNAMIC_FLAGS] then -- 动态标记(骑乘，打坐，护送等状态的显示)
		local ty = update_value[ServerEnum.UNIT_FIELDS.UNIT_DYNAMIC_FLAGS]

		print("状态更新",ty)
		print("状态更新 坐骑",bit.band(ty,ServerEnum.UNIT_DYNAMIC_FLAGS.RIDING))
		print("状态更新 打坐",bit.band(ty,ServerEnum.UNIT_DYNAMIC_FLAGS.RESTING))
		print("状态更新 双人打坐",bit.band(ty,ServerEnum.UNIT_DYNAMIC_FLAGS.PAIR_RESTING))
		print("状态更新 护送",bit.band(ty,ServerEnum.UNIT_DYNAMIC_FLAGS.PROTECT_BEAUTY))
		print("状态更新 挂机",bit.band(ty,ServerEnum.UNIT_DYNAMIC_FLAGS.AUTO_COMBAT))


		local map_id = self:get_map_id()

		if bit.band(ty,ServerEnum.UNIT_DYNAMIC_FLAGS.RIDING) > 0 then -- 骑乘状态
			if ConfigMgr:get_config("mapinfo")[map_id].flags <32 then
				self:ride(true, obj, update_value[ServerEnum.PLAYER_FIELDS.PLAYER_HORSE_CODE])
			end
		else
			self:ride(false, obj)
		end

		if bit.band(ty, ServerEnum.UNIT_DYNAMIC_FLAGS.RESTING) > 0 and  ConfigMgr:get_config("mapinfo")[map_id].flags <64 then -- 打坐状态
			print("更新状态 打坐", obj)
			obj:sit()
			obj:show_sit_effect(false)

		elseif bit.band(ty, ServerEnum.UNIT_DYNAMIC_FLAGS.PAIR_RESTING) > 0 and  ConfigMgr:get_config("mapinfo")[map_id].flags <64  then -- 双打坐状态
			print("更新双人打坐")
			obj:sit()
			obj:show_sit_effect(true)

		else
			print("取消双人打坐")
			-- 没有打坐的时候取消
			obj:cancel_sit()
		end

		if bit.band(ty, ServerEnum.UNIT_DYNAMIC_FLAGS.PROTECT_BEAUTY) > 0 then -- 护送美人状态

		else

		end

		-- if bit.band(ty, ServerEnum.UNIT_DYNAMIC_FLAGS.AUTO_COMBAT) == 1 then -- 挂机状态
		-- 	obj:set_auto_attack(true)
		-- else
		-- 	obj:set_auto_attack(false)
		-- end

	end
end
