--[[--
-- 对象池
-- @Author:Seven
-- @DateTime:2017-07-25 22:07:15
--]]

local Character = require("models.battle.obj.character")
local Monster = require("models.battle.obj.monster")
local Effect = require("common.effect")
local BloodLineView = require("models.bloodLine.bloodLineView")
local Weapon = require("models.battle.obj.weapon")
local Wing = require("models.battle.obj.wing")
local NPC = require("models.battle.obj.npc")
local Hero = require("models.battle.obj.hero")
local Block = require("models.battle.obj.block")
local SpriteBase = require("common.spriteBase")
local Horse = require("models.battle.obj.horse")
local WeaponParent = LuaHelper.Find("Weapon").transform
local WingParent = LuaHelper.Find("Wing").transform

local CareerConfig = 
{
	[ServerEnum.CAREER.SOLDER] = ConfigMgr:get_config("roleSolder"),
	[ServerEnum.CAREER.MAGIC]  = ConfigMgr:get_config("roleMagic"),
	[ServerEnum.CAREER.BOWMAN] = ConfigMgr:get_config("roleBowman"),
}

local DeleteInterval = 60 -- 清除缓存动画时间间隔

local Pool = class(function ( self, item_obj )
	self.item_obj = item_obj
	self.schedule = Schedule(handler(self, self.on_update), 10)
end)

-- 初始化缓冲池
function Pool:init()
	self.weapon_list = {}
	self.wing_list = {}
	self.hero_list = {}
	self.horse_list = {}
	self.dead_list = {} -- 死亡列表
	self.npc_list = {}
	self.character_list = {}
	self.monster_list = {}
	self.effect_list = {}

	self:check_in_scene()

	self:init_block()
	-- self:init_monster()
	-- self:init_characters()
	-- self:init_npc()
	self:init_effect()
	self:init_map_effect()
end

--[[
获取怪物
monster_id:怪物id
cb        :完成回调
]]
function Pool:get_monster( monster_id, cb )
	local model_id = ConfigMgr:get_config("creature")[monster_id].model_id
	--如果没有重新创建 
	if not self.monster_list[model_id] or #self.monster_list[model_id] == 0 then
		local obj = self:create_monster(monster_id, cb)
		return obj
	end
	--复用
	local obj = self.monster_list[model_id][#self.monster_list[model_id]]
	--重设状态
	obj:reset()
	self.monster_list[model_id][#self.monster_list[model_id]] = nil
	if cb then
		cb(obj)
	end

	return obj
end

function Pool:add_monster( monster )
	monster:faraway()
	local model_id = monster.config_data.model_id
	if not self.monster_list[model_id] then
		self.monster_list[model_id] = {}
	end
	self.monster_list[model_id][#self.monster_list[model_id]+1] = monster

	if DEBUG then
		monster.root.name = model_id.."(hide)"
	end
end

--[[
通过模型id去获取玩家模型
model_id:模型id(不传用默认的)
career  :职业
level   :等级
cb      :加载完成回调
]]
function Pool:get_character( model_id, career, level, cb )
	model_id = model_id or ConfigMgr:get_config("career_default_model")[career].model_id
	if not self.character_list[model_id] or #self.character_list[model_id] == 0 or not self.character_list[model_id][#self.character_list[model_id]] then
		self.character_list[model_id] = {}
		return self:create_character(career,level,cb, model_id)
	end

	local char = self.character_list[model_id][#self.character_list[model_id]]
	char.is_in_pool = nil
	self.character_list[model_id][#self.character_list[model_id]] = nil
	if cb then
		cb(char)
	end
	
	return char
end

function Pool:add_character( character )
	if not character then
		return
	end
	if character.transform then
		character.transform.parent = self.char_parent
	end
	character:faraway()
	character.is_self = false
	character.is_in_pool = true
	if character.transform then
		LuaHelper.SetLayerToAllChild(character.transform, ClientEnum.Layer.CHARACTER)--Character 不碰撞层
	end
	
	local model_id = character.model_id
	
	if not self.character_list[model_id] then
		self.character_list[model_id] = {}
	end
	self.character_list[model_id][#self.character_list[model_id]+1] = character

	if DEBUG then
		character.root.name = model_id.."(hide)"
	end
	print("Pool:add_character_Character:dispose",character.guid)
end

--[[
获取一个武器装备
model_id :模型id
character:所属角色
]]
function Pool:get_weapon( model_id, character, cb )
	if not self.weapon_list[model_id] or #self.weapon_list[model_id] == 0 then
		return self:create_weapon(model_id, character, cb)
	end
	local weapon = self.weapon_list[model_id][#self.weapon_list[model_id]]
	weapon.is_in_pool = nil
	self.weapon_list[model_id][#self.weapon_list[model_id]] = nil
	weapon:set_player(character)
	if cb then
		cb(weapon)
	end
	return weapon
end

function Pool:add_weapon( weapon )
	if not weapon then
		return
	end
	if weapon.transform then
		weapon.transform.parent = WeaponParent
		LuaHelper.SetLayerToAllChild(weapon.transform, ClientEnum.Layer.CHARACTER)--Character 不碰撞层
	end
	weapon:faraway()
	weapon.is_in_pool = true
	local model_id = weapon.model_id
	if not self.weapon_list[model_id] then
		self.weapon_list[model_id] = {}
	end
	self.weapon_list[model_id][#self.weapon_list[model_id]+1] = weapon
end

function Pool:get_wing( model_id, character, cb )
	if not self.wing_list[model_id] or #self.wing_list[model_id] == 0 then
		return self:create_wing(model_id, character, cb)
	end
	local wing = self.wing_list[model_id][#self.wing_list[model_id]]
	wing.is_in_pool = nil
	self.wing_list[model_id][#self.wing_list[model_id]] = nil
	wing:set_player(character)
	if cb then
		cb(wing)
	end
	return wing
end

function Pool:add_wing( wing )
	if not wing then
		return
	end
	if wing.transform then
		wing.transform.parent = WingParent
		LuaHelper.SetLayerToAllChild(wing.transform, ClientEnum.Layer.CHARACTER)--Character 不碰撞层
	end
	wing:faraway()
	wing.is_in_pool = true
	local model_id = wing.model_id
	if not self.wing_list[model_id] then
		self.wing_list[model_id] = {}
	end
	self.wing_list[model_id][#self.wing_list[model_id]+1] = wing
end

--[[
获取一个特效
model_id:模型id
]]
function Pool:get_effect( model_id, cb, ... )
	local url
	if type(model_id) == "string" and string.find(model_id, ".u3d") then
		url = model_id
	else
		url = model_id..".u3d"
	end
	
	if not self.effect_list then
		self.effect_list = {}
	end

	local ef
	if not self.effect_list[url] or not self.effect_list[url][#self.effect_list[url]] then
		ef = self:create_effect(url, cb, ...)
		return ef
	end
	ef = self.effect_list[url][#self.effect_list[url]]
	ef.is_in_pool = nil
	self.effect_list[url][#self.effect_list[url]] = nil

	if cb then
		cb(ef, ...)
	end
	return ef
end

function Pool:add_effect( effect )
	if not effect then 
		return
	end
	if not Seven.PublicFun.IsNull(effect.root) then
		LuaHelper.SetLayerToAllChild(effect.transform, ClientEnum.Layer.DEFAULT)
		effect.transform.parent = self.effect_parent
		effect:hide()
		effect:set_parent(self.effect_parent)
	end
	effect.is_in_pool = true
	if not self.effect_list[effect.url] then
		self.effect_list[effect.url] = {}
	end
	self.effect_list[effect.url][#self.effect_list[effect.url]+1] = effect
end

-- 添加到死亡列表
function Pool:add_dead( model )
	if DEBUG then
		model.root.name = "dead"..model.guid
	end
	-- if not self.dead_list[model.guid] then
	-- 	self.dead_list[model.guid] = {}
	-- end
	-- self.dead_list[model.guid][#self.dead_list[model.guid]+1] = model
	table.insert(self.dead_list, model)
end

function Pool:remove_dead( model )
	-- local guid = 1
	-- if not self.dead_list[guid] then
	-- 	return nil
	-- end

	-- local model = self.dead_list[guid][#self.dead_list[guid]]
	-- self.dead_list[guid][#self.dead_list[guid]] = nil
	-- return model
	local index
	for i,v in ipairs(self.dead_list or {}) do
		if v.guid == model.guid then
			index = i
			break
		end
	end
	if index then
		table.remove(self.dead_list, index)
	end
end

-- 获取一个武将
function Pool:get_hero( hero_id, cb )
	if not self.hero_list[hero_id] or not self.hero_list[hero_id][#self.hero_list[hero_id]] then
		return self:create_hero(hero_id, cb)
	end
	local len = #self.hero_list[hero_id]
	local hero = self.hero_list[hero_id][len]
	hero.is_in_pool = nil
	self.hero_list[hero_id][len] = nil
	cb(hero)
	return hero
end

-- 添加一个武将
function Pool:add_hero( hero )
	if not hero then
		return
	end

	hero:faraway()
	hero.is_in_pool = true
	local model_id = hero.config_data.model_id
	if not self.hero_list[model_id] then
		self.hero_list[model_id] = {}
	end

	self.hero_list[model_id][#self.hero_list[model_id]+1] = hero
	if DEBUG then
		hero.root.name = hero.config_data.model_id.."(hide)"..hero.config_data.code
	end
end

-- 获取一个坐骑
function Pool:get_horse( horse_id, cb )
	if not self.horse_list[horse_id] or not self.horse_list[horse_id][#self.horse_list[horse_id]] then
		return self:create_horse(horse_id, cb)
	end
	local len = #self.horse_list[horse_id]
	local horse = self.horse_list[horse_id][len]
	horse.is_in_pool = nil
	self.horse_list[horse_id][len] = nil
	cb(horse)
	return horse
end

function Pool:add_horse( horse )
	if not horse then
		return
	end

	horse:faraway()
	horse.root.tag = "Untagged"
	horse.is_in_pool = true
	if not self.horse_list[horse.config_data.code] then
		self.horse_list[horse.config_data.code] = {}
	end
	self.horse_list[horse.config_data.code][#self.horse_list[horse.config_data.code]+1] = horse
	if DEBUG then
		horse.name = horse.config_data.model_id.."(hide)"..horse.config_data.code
	end
end

-- 获取一个npc
function Pool:get_npc( npc_id, cb, ... )
	local config_data = ConfigMgr:get_config("npc")[npc_id]
	local model_id = config_data.model
	if not self.npc_list[model_id] or not self.npc_list[model_id][#self.npc_list[model_id]] then
		return self:create_npc(config_data, cb, ...)
	end
	local len = #self.npc_list[model_id]
	local npc = self.npc_list[model_id][len]
	self.npc_list[model_id][len] = nil
	npc.config_data = config_data
	cb(npc, ...)
	return npc
end

-- 添加一个武将
function Pool:add_npc( npc )
	if not npc then
		return
	end

	npc:faraway()
	local model_id = npc.config_data.model
	if not self.npc_list[model_id] then
		self.npc_list[model_id] = {}
	end
	self.npc_list[model_id][#self.npc_list[model_id]+1] = npc
	if DEBUG then
		npc.root.name = npc.config_data.model.."(hide)"..npc.config_data.code
	end
end

-- 检查是否需要删除阻挡
--@end_conditon  结束条件 暂时只有波次id
function Pool:check_block( end_conditon )
	for k,v in pairs(self.block_list) do
		if v.config_data.end_condition == end_conditon then
			v:dispose()
			self.block_list[k] = nil
		end
	end
end

--删除阻挡物 
function Pool:remove_block()
	for k,v in pairs(self.block_list) do
		v:dispose()
	end
	self.block_list = {}
end

-- 缓冲池是否初始化完成
function Pool:is_loaded()
	return 
		   -- self.is_monster_loaded 		and 
		   -- self.is_character_loaded 	and 
		   -- self.is_npc_loaded 			and 
		   self.is_xp_loaded			and
		   self.is_create_role_loaded
end

-- 判断是否可以进入场景
function Pool:check_in_scene()
	if self:is_loaded() and not self.is_in_scene then
		self.is_in_scene = true
		print("向服务器发送进入场景协议")
		-- 向服务器发送进入场景协议
		LuaItemManager:get_item_obejct("login"):on_map_loaded_c2s()
		-- 客户端进入场景通知
		Net:receive(nil, ClientProto.FinishScene)
	end
end

-- 初始化地图上的怪物
function Pool:init_monster()

	self.monster_list = {}
	self.is_monster_loaded = false

	local list = self.load_monster_list
	if gf_table_length(list) == 0 then
		self.is_monster_loaded = true
		self:check_in_scene()
		return
	end

	local config_table = ConfigMgr:get_config("creature")
	local config_data
	local obj

	local total = 0
	local index = 0

	local finish_cb = function(monster)
		Net:receive(nil, ClientProto.PoolFinishLoadedOne)
		self:add_monster(monster)

		index = index+1
		if index == total then
			self.is_monster_loaded = true
			self:check_in_scene()
		end
	end

	for i,v in pairs(list or {}) do
		total = total + 1
		self:create_monster(v.code, finish_cb)
	end
end

function Pool:create_monster( monster_id, cb )
	local config_table = ConfigMgr:get_config("creature")
	local config_data
	local monster

	if not self.monster_parent then
		self.monster_parent = LuaHelper.Find("Monster").transform
	end

	config_data = config_table[monster_id]
	
	if not config_data then
		print_error("找不到怪物 id =", monster_id)
		if cb then
			cb()
		end
		return
	end

	local effect_cb = function( effect, name, monster )
		effect.transform.parent = monster.transform
		effect.root.transform.localPosition = Vector3(0, 0.1, 0)
		effect:show_effect()
		monster:add_effect(effect, name)
	end

	local monster_cb = function(monster)
		if cb then
			cb(monster)
		end
		local blood_cb = function( blood_line, monster_id )
			-- 脚底阴影
			Effect("41000025.u3d", effect_cb, "shadow", monster)
			
			monster:set_parent(self.monster_parent)
			blood_line:show()
			monster:set_blood_line(blood_line)
		end
		BloodLineView("blood_line_monster.u3d", blood_cb, monster_id)
	end

	monster = Monster(config_data, monster_cb)
	return monster
end

--[[
缓存职业，每个职业先缓存
]]
function Pool:init_characters()

	self.is_character_loaded = false

	local list = {
		ServerEnum.CAREER.SOLDER, 
		ServerEnum.CAREER.MAGIC, 
		ServerEnum.CAREER.BOWMAN, 
	}

	local total = #list
	local index = 0

	local finish_cb = function( character )
		self:add_character(character)
		Net:receive(nil, ClientProto.PoolFinishLoadedOne)
		index = index+1
		if index == total then
			self.is_character_loaded = true
			self:check_in_scene()
		end
	end

	for i,v in ipairs(list) do
		-- self:create_character(v, 1, finish_cb)
		self:get_character(nil, v, 1, finish_cb)
	end
end

function Pool:create_character( career, level, cb, model_id )
	print("sdsdfjkslkfdljfsdfkjsdsl")
	if not self.char_parent then
		self.char_parent = LuaHelper.Find("Player").transform
		self.char_parent.eulerAngles = Vector3(0,0,0)
	end

	if not self.effect_parent then
		self.effect_parent = LuaHelper.Find("Effect").transform
	end

	local config_data = CareerConfig[career][level]
	if not config_data then
		print("ERROR:初始化玩家报错！！！配置表找不到相应数据！请检查配置表!")
		return nil
	end
	config_data = copy(config_data)
	config_data.model_id = model_id or ConfigMgr:get_config("career_default_model")[career].model_id
	config_data.career = career

	local character

	-- 特效加载回调
	local effect_cb = function( effect, key, character )
		character:add_effect(effect, key)
		
		effect:set_parent(character.transform)
		effect.root.transform.localPosition = Vector3(0, 0, 0)
		LuaHelper.SetLayerToAllChild(effect.transform, ClientEnum.Layer.CHARACTER)
		if key == "shadow" then
			effect:show_effect()
			effect.root.transform.localPosition = Vector3(0, 0.1, 0)

		end
	end
	

	-- 角色加载完成
	local loaded_cb = function( character, blood_line )
		blood_line:show()
		character:set_parent(self.char_parent)
		character:set_blood_line(blood_line)

		-- 打坐特效
		Effect(ResMgr.SIT[career], effect_cb, "sit", character)
		Effect(ResMgr.PAIR_SIT[career], effect_cb, "pair_sit", character)

		-- 脚底阴影
		Effect("41000025.u3d", effect_cb, "shadow", character)

		-- 加载完成回调
		if cb then
			cb(character)
		end
	end

	-- 血条初始化完成
	local blood_cb = function ( blood_line )
		blood_line:hide()
		character = Character(config_data, loaded_cb, blood_line)
	end
	BloodLineView("blood_line_player.u3d", blood_cb)

	return character
end

--[[
创建一件武器
model_id:模型id
character  :所属角色
]]
function Pool:create_weapon( model_id, character, cb )
	local career = character.config_data.career
	model_id = model_id or ConfigMgr:get_config("career_default_weapon")[career].model_id
	return Weapon(character, model_id, cb)
end	

--[[
创建一个翅膀
model_id:模型id
character  :所属角色
]]
function Pool:create_wing( model_id, character, cb )
	return Wing(character, model_id, cb)
end

function Pool:init_npc()
	self.is_npc_loaded = false
	if not ConfigMgr:get_config("map.mapMonsters")[self.item_obj.map_id] then
		self:check_in_scene()
		return
	end
	
	local npc_list = ConfigMgr:get_config("map.mapMonsters")[self.item_obj.map_id][ServerEnum.MAP_OBJECT_TYPE.NPC]
	if not npc_list or #npc_list == 0 then
		self.is_npc_loaded = true
		self:check_in_scene()
		Net:receive(nil, ClientProto.NPCLoaderFinish)
		return
	end

	local progress = 0
	local total = #npc_list

	local task_data

	local npc_cb = function(npc, data)
		Net:receive(nil, ClientProto.PoolFinishLoadedOne)

		npc:set_position(self.item_obj:covert_s2c_position(data.pos.x, data.pos.y))
		npc:set_task_data(LuaItemManager:get_item_obejct("task"):get_task_data(npc.config_data.code))
		npc:set_eulerAngles(Vector3(0, data.dir or 0, 0))

		self.item_obj:add_model(npc)
		self.item_obj:add_npc(npc)

		progress = progress+1
		if progress == total then -- 地图上所有的npc加载完成
			self.is_npc_loaded = true
			self:check_in_scene()
			Net:receive(nil, ClientProto.NPCLoaderFinish)
		end
	end

	for k,v in pairs(npc_list) do
		self:get_npc(v.code, npc_cb, v)
	end
end

local NPC_UID = ClientEnum.GUID.NPC
function Pool:create_npc( config_data, cb, ... )
	if not self.npc_parent then
		self.npc_parent = LuaHelper.Find("NPC").transform
	end

	local param = {...}

	local effect_cb = function( effect, key, npc )
		effect:set_parent(npc.transform)
		effect.transform.localPosition = Vector3(0,0,0)
		effect:show_effect()
	end

	local npc_cb = function(npc, blood_line)
		npc:show()
		npc:set_blood_line(blood_line)

		NPC_UID = NPC_UID + 1
		npc:set_guid(NPC_UID)

		-- 脚底阴影
		Effect("41000025.u3d", effect_cb, "shadow", npc)

		if DEBUG then
			config_data = npc.config_data
			npc.root.name = config_data.model.."("..config_data.name..")"..config_data.code
		end

		if cb then
			cb(npc, unpack(param))
		end
	end
	
	local blood_cb = function (blood_line)
		blood_line:hide()
		if not config_data then
			gf_error_tips(string.format("找不到npc_id = %d数据，请检查npc表", npc_id))
			return
		end

		if DEBUG then
			blood_line.root.name = "npc"..config_data.name
		end

		local npc = NPC(config_data, task_data, npc_cb, blood_line)
		npc:set_parent(self.npc_parent)

	end

	BloodLineView("blood_line_npc.u3d", blood_cb, data)
end

-- 初始化一些通用特效
function Pool:init_effect()

	local list = 
	{
		gf_get_normal_res(ClientEnum.NORMAL_MODEL.TARGET_SELECT), -- 选中敌人特效
		gf_get_normal_res(ClientEnum.NORMAL_MODEL.FRIEND_SELECT), -- 选中友方特效
	}

	local finish_cb = function( effect )
		effect:set_parent(self.effect_parent)
	end

	for i,v in ipairs(list) do
		if not self.effect_list[v] then
			self.effect_list[v] = {}
		end
		self.effect_list[v][#self.effect_list[v]+1] = self:create_effect(v, cb)
	end
end

function Pool:create_effect( url, ... )
	return Effect(url, ...)
end

function Pool:create_hero( hero_id, cb )
	if not self.hero_parent then
		self.hero_parent = LuaHelper.Find("Hero").transform
	end
	local dataUse = require("models.hero.dataUse")
	local skill_id = dataUse.getHeroSkillId(hero_id)
	local atk_effect = dataUse.getHeroInfoById(hero_id).atk_effect
	local body_effect = dataUse.getHeroInfoById(hero_id).body_effect

	local config_data = 
	{
		code = hero_id,
		model_id = dataUse.getHeroModel(hero_id),
		speed = 0,
		hp = 0,
		max_hp = 0,
		attack_distance = 0,
		name = dataUse.getHeroName(hero_id),
		skill_id = skill_id,
		atk_range = ConfigMgr:get_config("skill")[skill_id].cast_distance*0.1,
		ani_name = ConfigMgr:get_config("hero")[hero_id].ani_name
	}

	local effect_cb = function( effect, hero, key )
		effect:set_parent(hero.transform)
		effect.root.transform.localPosition = Vector3(0, 0, 0)

		hero:add_effect(effect, key)

		if key == "body_effect" or key == "shadow" then
			effect:show_effect()
		else
			effect:hide()
		end
	end

	local effect_cb2 = function( effect, parent )
		if not parent then
			effect:dispose()
			print_error(string.format("找不到怪物身上的节点，特效id =",effect.url))
			return
		end

		effect:set_parent(parent.transform)
		effect.transform.localPosition = Vector3(0,0,0)
		effect:show_effect()
	end

	local hero_cb = function( hero, blood_line )
		blood_line:show()
		hero:set_blood_line(blood_line)
		hero:set_parent(self.hero_parent)

		-- 废弃 放到技能那里了
		-- if atk_effect then
		-- 	self:create_effect(atk_effect..".u3d", effect_cb, hero, "atk_effect")
		-- end

		if body_effect then
			self:create_effect(body_effect..".u3d", effect_cb, hero, "body_effect")
		end

		-- 脚底阴影
		Effect("41000025.u3d", effect_cb, hero, "shadow")

		-- 怪物身上特效
		if config_data.effect then
			Effect(config_data.effect".u3d", effect_cb, "", hero)
		end

		-- 挂在节点上的特效
		if config_data.skeleto_effect then
			for i,v in ipairs(config_data.skeleto_effect) do
				Effect(v[1]..".u3d", effect_cb2, LuaHelper.FindChild(hero.root, v[2]))
			end
		end

		if cb then
			cb(hero)
		end
	end

	local blood_cb = function( blood_line )
		blood_line:hide()
		Hero(config_data, hero_cb, blood_line)
	end
	BloodLineView("blood_line_hero.u3d", blood_cb)
end

-- 初始化阻挡
function Pool:init_block()
	self.block_list = {}

	local map_id = self.item_obj.map_id
	if not ConfigMgr:get_config("map.mapMonsters")[map_id] then
		return
	end

	local list = ConfigMgr:get_config("map.mapMonsters")[map_id][ServerEnum.MAP_OBJECT_TYPE.WALL]
	if not list then
		return
	end

	if not self.block_parent then
		self.block_parent = LuaHelper.Find("Block").transform
	end

	local block_cb = function( block, config_data )
		block:set_parent(self.block_parent)
		block:set_eulerAngles(config_data.dir)
		block:set_scale(Vector3(config_data.width, 10, 1))
		block:set_position(config_data.position)

		self.block_list[config_data.code] = block
	end

	for i,v in ipairs(list) do
		local config_data = ConfigMgr:get_config("map_block")[v.code]
		config_data.position = self.item_obj:covert_s2c_position(v.pos.x, v.pos.y)
		config_data.dir = Vector3(0, v.dir or 0, 0)
		Block(config_data, block_cb, config_data)
	end
end

-- 创建一个坐骑
function Pool:create_horse( horse_id, cb )
	local dataUse = require("models.horse.dataUse")
	local horse_model = dataUse.getHorseModel(horse_id)
	local effect_list = LuaItemManager:get_item_obejct("horse"):get_horse_effect(horse_id)
	gf_print_table(effect_list, "坐骑特效")
	local config_data = 
	{
		code = horse_id,
		model_id = horse_model,
		speed = dataUse.get_horse_speed(horse_id)*0.1,
		atk_range = 0,
	}

	local effect_cb = function( effect, parent, horse, key )
		effect:set_parent(parent.transform)
		effect.transform.localPosition = Vector3(0,0,0)
		effect:set_local_euler_angles(Vector3(0,0,0))

		if horse:is_mesh_enable() then
			print("显示坐骑特效")
			effect:show_effect()
		end
		horse:add_effect(effect, key)
	end

	local finish_cb = function(horse)
		local function delay_()
			-- 挂在节点上的特效
			if effect_list then
				for i,v in ipairs(effect_list) do
					local parent
					if v[2] then
						parent = LuaHelper.FindChild(horse.root, v[2]).transform
					else
						parent = horse.transform
					end
					Effect(v[1]..".u3d", effect_cb, parent, horse, v[1])
				end
			end

			if cb then
				cb(horse)
			end
		end
		-- if DEBUG and OPEN_DELAY_MODEL then
		-- 	delay(delay_,OPEN_DELAY_MODEL_TIME)
		-- else
		-- 	delay_()
		-- end
		delay_()
	end
	return Horse(config_data, finish_cb)
end

-- 初始化场景特效
function Pool:init_map_effect()
	self.map_effect_list = {}

	local map_id = self.item_obj.map_id
	if not ConfigMgr:get_config("map.mapMonsters")[map_id] then
		return
	end

	local list = ConfigMgr:get_config("map.mapMonsters")[map_id][ServerEnum.MAP_OBJECT_TYPE.SCENE_EFFECT]
	if not list then
		return
	end

	if not self.effect_parent then
		self.effect_parent = LuaHelper.Find("Effect").transform
	end

	local effect_cb = function( effect, data )
		effect:set_parent(self.effect_parent)
		effect:set_eulerAngles(Vector3(0, data.dir or 0, 0))
		effect:set_position(self.item_obj:covert_s2c_position(data.pos.x, data.pos.y))

		self.map_effect_list[data.code] = effect
	end

	for i,v in ipairs(list) do
		local config_data = ConfigMgr:get_config("map_effect")[v.code]
		Effect(config_data.model_id..".u3d", effect_cb, v)
	end
end

-- 初始化加载数量
function Pool:init_loading_count()
	

	if StateManager:get_current_state() == StateManager.login or
	   StateManager:get_current_state() == StateManager.create_role then

	   	if StateManager:get_current_state() == StateManager.create_role then
			-- 创建角色xp资源
			local create_role_cb = function(have)
				Net:receive(nil, ClientProto.PoolFinishLoadedOne)
				self.is_create_role_loaded = true
				self:check_in_scene()
			end
			LuaItemManager:get_item_obejct("createRole"):init_xp(create_role_cb)
			StateManager:get_current_state():add_loading_count(1)
	   	end

		return
	else
		self.is_create_role_loaded = true
	end

	local config_table = ConfigMgr:get_config("map.mapMonsters")
	local map_id = self.item_obj.map_id
	
	if not config_table[map_id] then
		return
	end
	
	-- local count = 0

	-- -- 怪物
	-- self.load_monster_list = {}
	-- local list = config_table[map_id][ServerEnum.MAP_OBJECT_TYPE.CREATURE]
	-- for i,v in ipairs(list or {}) do
	-- 	if not self.load_monster_list[v.code] then
	-- 		self.load_monster_list[v.code] = v
	-- 		count = count + 1
	-- 	end
	-- end
	-- StateManager:get_current_state():add_loading_count(count)

	-- 阻挡
	-- list = config_table[map_id][ServerEnum.MAP_OBJECT_TYPE.WALL] or {}
	-- StateManager:get_current_state():add_loading_count(#list)

	-- list = config_table[map_id][ServerEnum.MAP_OBJECT_TYPE.NPC]
	-- if list then
	-- 	StateManager:get_current_state():add_loading_count(#list)
	-- end

	StateManager:get_current_state():add_loading_count(1)
	
	-- 加载首场xp特效

	local first_war = LuaItemManager:get_item_obejct("firstWar")
	if first_war:is_pass() then
		self.is_xp_loaded = true
	else
		local cb = function()
			self.is_xp_loaded = true
			self:check_in_scene()
			Net:receive(nil, ClientProto.PoolFinishLoadedOne)
		end
		first_war:init_xp(cb)
		StateManager:get_current_state():add_loading_count(1)
	end
end

function Pool:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.SceneOnFocus then
		self:init_loading_count()
	end
end

function Pool:on_update(dt)
	for k,v in pairs(self.monster_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.monster_list[k][j] = nil
			end
		end
	end

	for k,v in pairs(self.character_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.character_list[k][j] = nil
			end
		end
	end

	for k,v in pairs(self.horse_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.horse_list[k][j] = nil
			end
		end
	end

	for k,v in pairs(self.weapon_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.weapon_list[k][j] = nil
			end
		end
	end

	for k,v in pairs(self.wing_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.wing_list[k][j] = nil
			end
		end
	end

	for k,v in pairs(self.hero_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.hero_list[k][j] = nil
			end
		end
	end

	for k,v in pairs(self.effect_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.effect_list[k][j] = nil
			end
		end
	end

	for k,v in pairs(self.npc_list or {}) do
		for j,obj in pairs(v) do
			if Net:get_server_time_s() - obj.faraway_time >= DeleteInterval then
				obj:dispose()
				self.npc_list[k][j] = nil
			end
		end
	end
end

function Pool:clear_dead()
	for k,v in pairs(self.dead_list or {}) do
		v:faraway()
	end
end

function Pool:dispose()
	for k,v in pairs(self.monster_list) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.monster_list = {}

	for k,v in pairs(self.character_list) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.character_list = {}

	for k,v in pairs(self.weapon_list) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.weapon_list = {}

	for k,v in pairs(self.wing_list) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.wing_list = {}

	for k,v in pairs(self.effect_list or {}) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.effect_list = {}

	for k,v in pairs(self.dead_list or {}) do
		v:dispose()
	end
	self.dead_list = {}

	for k,v in pairs(self.hero_list) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.hero_list = {}

	for k,v in pairs(self.block_list) do
		v:dispose()
	end
	self.block_list = {}

	for k,v in pairs(self.horse_list or {}) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.horse_list = {}

	for k,v in pairs(self.map_effect_list or {}) do
		v:dispose()
	end
	self.map_effect_list = {}

	for k,v in pairs(self.npc_list or {}) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.npc_list = {}

	self.monster_parent = nil
	self.char_parent = nil
	self.hero_parent = nil
	self.block_parent = nil

	self.is_in_scene = false
	print("Pool:dispose")
end

return Pool
