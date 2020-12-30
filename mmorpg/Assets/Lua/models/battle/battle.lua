--[[--
--
-- @Author:Seven
-- @DateTime:2017-04-20 09:44:55
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Effect = require("common.effect")

local MapHeight = require("config.mapHeight")
local Pool = require("models.battle.pool")
require("models.battle.publicFun")

local Battle = LuaItemManager:get_item_obejct("battle")
Battle.priority = ClientEnum.PRIORITY.MAIN_UI
Battle.forced_click = true

-- 进入场景后调用的初始化
function Battle:init()
	self:init_pool()
	self:create_transport()
	self:init_shake()
end

function Battle:init_pool()
	self.pool:init()
end

function Battle:init_shake()
	self.shake = LuaHelper.GetComponent(LuaHelper.Find("Main Camera"), "Seven.CameraShake")
	self.deemo = LuaHelper.GetComponent(LuaHelper.Find("Main Camera"), "Seven.DeemoRadialBlur")
end

--[[
震动屏幕
x,y,z:震动的幅度
time :震动时间
]]
function Battle:shake_screen( x, y, z, time )
	self.shake:SetShakeDir(x, y, z)
	self.shake.shakeTime = time or 0.5
	self.shake:Shake()
end

-- 设置自动攻击模式
function Battle:set_auto_atk( auto_atk )
	self._is_auto_atk = auto_atk
end

function Battle:is_auto_atk()
	return self._is_auto_atk
end

-- 设置是否模糊场景（快捷切换地图用到）
function Battle:set_deemo_visible( visible )
	-- if not self._is_deemo_effect_finish then
	-- 	return
	-- end
	-- self._is_deemo = visible
	if not self.deemo then
		return
	end

	self.deemo.enabled = visible
	if visible then
		self._deemo_frame_index = 1
		self._deemo_cur_frame = 1
		self._deemo_end_frame = 1
		self._is_deemo_effect_finish = false
	else
		self._is_deemo_effect_finish = true
	end
end

-- 检查是否需要隐藏地图阻挡
--@end_conditon  结束条件 暂时只有波次id
function Battle:check_block( end_conditon )
	self.pool:check_block(end_conditon)
end

--[[
设置慢放或者快放
scale:时间缩放
time :持续时间
]]
function Battle:set_time_scale( scale, time )
	Time.timeScale = scale or 1
	self.scale_time = time or 0
end

-- 设置是否可以传送
function Battle:set_is_transport( transport )
	self.is_transport = transport
end

-- 设置当前地图id
function Battle:set_map_id( id )
	self.map_id = id
	LuaItemManager:get_item_obejct("game"):set_map_id(id)
	self:init_npc_pos()
end

function Battle:get_map_id()
	return self.map_id
end

-- 把服务器坐标转为客户端坐标
function Battle:covert_s2c_position( x, y )
	local pos = self:get_map_pos(x*0.1, y*0.1)
	if pos.x == -1 and pos.y == -1 and pos.z == -1 then
		return Vector3(x*0.1, 0, y*0.1)
	end
	return pos
end

-- 获取地图坐标点
function Battle:get_map_pos( x, y )
	local map_height = 0
	if MapHeight[self.map_id] then
		map_height = MapHeight[self.map_id].height
	end
	return Seven.PublicFun.GetNavMeshPos(x, y, map_height)
end

-- 获取玩家自己
function Battle:get_character()
	return self.character
end

-- 添加一个模型
function Battle:add_model( model )
	if self:get_model(model.guid) then
		self:remove_model(model.guid)
	end
	self.model_list[model.guid] = model
end

function Battle:get_model( guid )
	return self.model_list[guid]
end

-- 删除一个模型
function Battle:remove_model( guid )
	if not guid then
		return
	end
	local model = self.model_list[guid]
	self.model_list[guid] = nil
	self.enemy_list[guid] = nil
	self.npc_list[guid] = nil
	self.transport_list[guid] = nil
	self.character_list[guid] = nil
	if model then

		-- 重新把对象返回缓存迟
		if model.is_player then
			self.pool:add_character(model)
			self:refresh_players_num()

		elseif model.is_monster then
			print("删除怪物",model.guid,model.dead)
			--如果这个怪物还没有被创建出来 设置为死亡状态
			if not model.is_init then
				model.is_faraway = true
			elseif model.dead then
				if model:have_dead_ani() then
					self.pool:add_dead(model)
					model:show_dead()
				else
					self.pool:add_monster(model)
				end
			else
				self.pool:add_monster(model)
				model:faraway()
			end

		elseif model.is_hero then
			print("删除武将")
			if model:get_ower() then
				model:get_ower():set_hero(nil)
			end
			if model.dead then
				self.pool:add_dead(model)
				model:show_dead()
			else
				self.pool:add_hero(model)
			end

		elseif model.is_npc then
			self.pool:add_npc(model)

		else
			model:dispose()
		end

	end
end

-- 添加玩家
function Battle:add_character( char )
	self.character_list[char.guid] = char
end

-- 获取玩家
function Battle:get_character_list()
	return self.character_list
end

--获取敌人
function Battle:get_enemy_list()
	return self.enemy_list
end
-- 添加一个敌人
function Battle:add_enemy( enemy )
	self.enemy_list[enemy.guid] = enemy
end

-- 添加战斗结果
function Battle:add_result( data )
	self.result_list[data.caster] = data
end

function Battle:get_result( guid )
	local data = self.result_list[guid]
	self.result_list[guid] = nil
	return data
end

function Battle:add_npc( npc )
	self.npc_list[npc.guid] = npc
end

-- 通过npc id 获取npc
function Battle:get_npc( npc_id )
	for k,v in pairs(self.npc_list) do
		if v.config_data.code == npc_id then
			return v
		end
	end
	return nil
end

-- 通过阵营获取一个npc
function Battle:get_npc_by_faction( faction )
	for k,v in pairs(self.npc_list) do
		if v.config_data.faction == faction then
			return v
		end
	end
	return nil
end

function Battle:init_npc_pos()
	for i,v in ipairs(ConfigMgr:get_config("map.mapMonsters")[self.map_id][ServerEnum.MAP_OBJECT_TYPE.NPC] or {}) do
		self.npc_pos_list[v.code] = v
	end
end

-- 获取npc位置
function Battle:get_npc_pos( npc_id )
	local data = self.npc_pos_list[npc_id]
	if data then
		return self:covert_s2c_position(data.pos.x, data.pos.y)
	end
	return nil
end

function Battle:remove_npc_pos( npc_id )
	self.npc_pos_list[npc_id] = nil
end

function Battle:add_npc_pos( data )
	print("添加npc pos：",data.npc_id)
	self.npc_pos_list[data.npc_id] = data
end

-- 获取一个传送阵
function Battle:get_transport( map_id )
	local t
	for k,v in pairs(self.transport_list) do
		if v.config_data.map_id == map_id then
			t = v
			break
		end
	end
	return t
end
--清除block
function Battle:remove_block()
	self.pool:remove_block()
end
-- npc看向玩家,玩家看向npc
function Battle:npc_lookat_character( npc_id )
	local npc = self:get_npc(npc_id)
	if not npc then
		return
	end

	npc:look_at(self.character.transform.position)
	self.character:look_at(npc.transform.position)
end

function Battle:add_transport( transport )
	self.transport_list[transport.guid] = transport
end

--[[
添加一个特效到模型身上
guid:模型唯一id
effect_model:特效模型id
ty:特效下标（对应ClientEnum.EffectIndex)
]]
function Battle:add_model_effect( guid, effect_model, ty ,cb)
	if self.effect_list[guid] and self.effect_list[guid][ty] then
		self.effect_list[guid][ty]:show_effect()
		if cb then
			cb(self.effect_list[guid][ty])
		end
		return
	end

	local model = self:get_model(guid)
	if not model then
		return
	end
	local finish_cb = function( effect )
		if effect.is_in_pool ~= true then
			local parent
			if model.is_player and model.horse then
				parent = model.horse.transform
			else
				parent = model.transform
			end
			effect:set_parent(parent)
			effect.transform.localPosition = Vector3(0, 0, 0)
			if ty == ClientEnum.NORMAL_MODEL.TARGET_SELECT or ty == ClientEnum.NORMAL_MODEL.FRIEND_SELECT then
				local scale = model.config_data.select_scale or 1
				effect:set_scale(Vector3(scale,scale,scale))
			end
			effect:show_effect()

			if not self.effect_list[guid] then
				self.effect_list[guid] = {}
			end

			self.effect_list[guid][ty] = effect
			if cb then
				cb(self.effect_list[guid][ty])
			end
		else
		end
	end
	self:get_effect(effect_model, finish_cb)
end

-- 移除人物身上的特效
function Battle:remove_model_effect( guid, ty )
	if not self.effect_list[guid] then
		return
	end
	self:remove_effect(self.effect_list[guid][ty])
	self.effect_list[guid][ty] = nil
end

-- 添加一个特效
function Battle:get_effect( model_id, cb, ... )
	return self.pool:get_effect(model_id, cb, ...)
end

-- 删除一个特效
function Battle:remove_effect( effect )
	self.pool:add_effect(effect)
end

-- 显示选中特效
function Battle:show_select( guid )
	local last_guid = self._last_select_guid or 0
	if self._last_select_guid then
		self:hide_select(self._last_select_guid)
	end

	if self:is_friend(guid) or self:is_collect_monster(guid) then
		self:add_model_effect(
			guid,
			gf_get_normal_res(ClientEnum.NORMAL_MODEL.FRIEND_SELECT),
			ClientEnum.EFFECT_INDEX.SELECT
		)
	else
		self:add_model_effect(
			guid,
			gf_get_normal_res(ClientEnum.NORMAL_MODEL.TARGET_SELECT),
			ClientEnum.EFFECT_INDEX.SELECT
		)
	end
	self._last_select_guid = guid

	return last_guid
end

-- 隐藏选中特效
function Battle:hide_select(guid)
	local model = self:get_model(guid)
	if model and model.is_monster and not model:get_battle_flag() then -- 隐藏名字
		model:set_name_visible(false)
	end
	self:remove_model_effect(guid, ClientEnum.EFFECT_INDEX.SELECT)
	self._last_select_guid = nil
end

--[[
切换场景
map_id:切换的地图id
copy_id:副本才有
]]
function Battle:change_scene( map_id, copy_id)
	print("切换地图 map_id =",map_id,self.map_id, copy_id)
	local last_map_id = self.map_id
	local copy_data 

	if copy_id and copy_id > 0 then
		copy_data = ConfigMgr:get_config("copy")[copy_id]
		if copy_data.maps[1] == map_id then
			self.show_leave_btn = copy_data.show_leave == 1
		else
			self.show_leave_btn = false
		end
	elseif map_id == 150102 then
		self.show_leave_btn = true
	else
		self.show_leave_btn = false
	end

	self:set_map_id(map_id)
	self:set_is_transport(true)
	
	if last_map_id > 0 and ConfigMgr:get_config("mapinfo")[last_map_id].scene_url == ConfigMgr:get_config("mapinfo")[map_id].scene_url then
		self:clear()
		Net:receive(nil, ClientProto.HideAllOpenUI)
		self:set_deemo_visible(true)
		self:set_map_id(map_id)
		Net:receive(self, ClientProto.SceneOnFocus)
		self:init()

		local map_data = ConfigMgr:get_config("mapinfo")[map_id]
		if not map_data then
			gf_error_tips("找不到地图数据，id =",map_id)
		else
			if map_data.weather then -- 加载天气
		        Loader:get_resource(map_data.weather..".u3d",nil,"UnityEngine.GameObject",function(req)
		        	print("加载天气成功")
		        	LuaHelper.Instantiate(req.data)
		        end,function(s)
		        	print("加载天气失败")
		        end)
			end
			local ArrowParent = LuaHelper.Find("Arrow")
			if ArrowParent ~= nil then
				local is_show_effect = LuaItemManager:get_item_obejct("mozu"):get_is_show_effect()
				local child_list = LuaHelper.GetAllChild(ArrowParent)
				for i = 1, #child_list do
					child_list[i].gameObject:SetActive(is_show_effect)
				end
			end
		end
	else
		StateManager:change_scene(map_id)
	end

	self.pk_mode = LuaItemManager:get_item_obejct("game"):get_pk_mode()

	-- 设置地图默认pk模式
	local map_data = ConfigMgr:get_config("mapinfo")[map_id]
	if map_data and map_data.force_pk_mode then
		self.pk_mode = map_data.force_pk_mode
		self:set_pk_mode_c2c(self.pk_mode, true)
		print("地图强制pk模式",self.pk_mode)
	end
	print("地图pk模式",self.pk_mode)

	if copy_data then
		-- 判断是否需要自动挂机
		print("副本是否自动挂机",copy_data.auto_atk)
		if copy_data.auto_atk and copy_data.auto_atk == 1 then
			gf_auto_atk(true)
		end
	end
end

-- 获取是否显示主界面离开按钮
function Battle:is_show_leave_btn()
	return self.show_leave_btn
end

-- 获取战斗模式
function Battle:get_pk_mode()
	return self.pk_mode
end

-- 获取当前地图可以设置的pk模式权限
function Battle:get_map_permissions( permissions )
	local config_data = ConfigMgr:get_config("mapinfo")[self.map_id]
	if not config_data then
		return false
	end
	
	return bit.band(config_data.flags, permissions) > 0
end

-- 获取杀死玩家的攻击者名字和等级
function Battle:get_attacker_name_and_level()
	local attacker = self.character:get_attacker()
	if attacker then
		return attacker:get_name(), attacker:get_level()
	end
	return "", ""
end

-- 客户端角度转服务器角度
function Battle:covert_c2s_angle( dir )
	dir = 450 - dir -- 服务器逆时针是正角度（客户端顺时针是正角度）
	if dir > 360 then
		dir = dir - 360
	end
	return dir
end

-- 获取服务器转客户端角度
function Battle:get_s2c_angle( dir )
	if not dir then
		return 0
	end

	dir = 450 - dir
	if dir > 360 then
		dir = dir - 360
	end
	return dir
end

function Battle:add_msg( guid, data, fn )
	if not self.temp_msg_list[guid] then
		self.temp_msg_list[guid] = {}
	end
	self.temp_msg_list[guid][#self.temp_msg_list+1] = {data = data, fn = fn}
end

function Battle:check_msg( model )
	local list = self.temp_msg_list[model.guid]
	self.temp_msg_list[model.guid] = nil
	if list then
		for i,v in ipairs(list) do
			local fn = model[v.fn]
			fn(model,v.data)
		end
	end
end

-- 屏蔽/显示 其他玩家
function Battle:set_other_players_visible( visible )
	local num = LuaItemManager:get_item_obejct("setting"):get_setting_value(ClientEnum.SETTING.DISPLAY_NUMBER)
	local index = 0
	for k,v in pairs(self.character_list) do
		if not v.is_self then
			local show = visible
			if visible then
				index = index + 1
				if index > num then -- 超过最大同屏数量隐藏
					show = false
				end

				if v.hero then
					v.hero:set_mesh_enable(show)
				end
			end
			v:set_mesh_enable(show)
			if v.horse then
				v.horse:set_mesh_enable(show)
			end
			if v.weapon then
				v.weapon:set_mesh_enable(show)
			end
			if v.wing then
				v.wing:set_mesh_enable(show)
			end
		end
	end
end

-- 刷新玩家显示数量（设置界面）
function Battle:refresh_players_num()
	local setting = LuaItemManager:get_item_obejct("setting")
	if setting:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_PLAYER) then
		return
	end

	local num = setting:get_setting_value(ClientEnum.SETTING.DISPLAY_NUMBER)
	local show_hero = not setting:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_HERO) -- 是否显示武将
	local index = 0
	for k,v in pairs(self.character_list) do
		if not v.is_self then
			index = index + 1
			local visible = true
			if index > num then
				visible = false
			end

			v:set_mesh_enable(visible)
			if v.horse then
				v.horse:set_mesh_enable(visible)
			end
			if v.weapon then
				v.weapon:set_mesh_enable(visible)
			end
			if v.wing then
				v.wing:set_mesh_enable(visible)
			end
			if v.hero then
				if visible and show_hero then
					v.hero:set_mesh_enable(true)
				else
					v.hero:set_mesh_enable(false)
				end
			end
		end
	end
end

-- 屏蔽/显示 怪物
function Battle:set_monsters_visible( visible )
	for k,v in pairs(self.enemy_list) do
		v:set_mesh_enable(visible)
	end
end

-- 屏蔽/显示 他人武将
function Battle:set_other_heros_visible( visible )
	for k,v in pairs(self.character_list) do
		if not v.is_self and v.hero then
			v.hero:set_mesh_enable(visible)
		end
	end
end

-- 屏蔽/显示 称号
function Battle:set_titles_visible( visible )
	for k,v in pairs(self.character_list) do
		local blood_line = v.blood_line
		if blood_line then
			if blood_line.title ~= 0 and blood_line.title ~=nil and blood_line.title ~="" and visible then
				v.blood_line:set_title_visible(visible)
			else
				v.blood_line:set_title_visible(false)
			end
		end
	end
end

--初始化函数只会调用一次
function Battle:initialize()
	self.enemy_list = {} -- 怪物列表
	self.character_list = {} -- 玩家列表(包括自己)
	self.model_list = {} -- 模型列表，包括玩家和怪物,npc
	self.npc_list = {}
	self.transport_list = {}
	self.buffer_list = {} -- buffer列表
	self.effect_list = {} -- 特效列表
	self.follow_npc_list = {} -- 跟随npc
	self.result_list = {} -- 伤害结果列表
	self.npc_pos_list = {}

	self.task_info = {} -- 当前的任务信息

	self.is_transport = false -- 是否是传送过去的
	self.pk_mode = ServerEnum.PK_MODE.PEACE

	self.show_leave_btn = false

	self.move_list = {} --移动列表	
	self.move_flag_list = {} -- 移动标志列表

	self.obj_list = {} -- 服务器下推的物体创建删除列表
	self.temp_hero_load_list = {} -- 等待武将加载列表

	self.temp_msg_list = {} -- 消息缓存列表，用来缓存物体还没创建完成接收到的消息

	self.map_id = 0
	self.pool = Pool(self) -- 对象缓冲池

	self.scale_time = 0

	self.last_stop_transfer_time = 0

	self.float_item = LuaItemManager:get_item_obejct("floatTextSys") -- 飘字

	self._is_auto_atk = false

	require("models.battle.extra.receive")
	require("models.battle.extra.objectUpdate")
	require("models.battle.extra.find")
	require("models.battle.extra.target")
	require("models.battle.extra.move")

	gf_register_update(self)
end

-- 清除数据
function Battle:clear()
	print("切换场景清除战斗数据")
	if self.character then
		self.character:set_camera_target(nil)
		self.character = nil
	end
	self.transprot_parent = nil

	if self._last_select_guid ~= nil then
		self:hide_select(self._last_select_guid)
		self._last_select_guid = nil
	end

	for k,v in pairs(self.model_list) do
		v:dispose()
	end
	
	self.model_list = {}
	self.enemy_list = {}
	self.character_list = {} -- 玩家列表(包括自己)
	self.npc_list = {}
	self.transport_list = {}
	self.result_list = {}
	self.npc_pos_list = {}

	for k,v in pairs(self.effect_list) do
		for j,obj in pairs(v) do
			obj:dispose()
		end
	end
	self.effect_list = {}

	for k,v in pairs(self.follow_npc_list) do
		v:dispose()
	end
	self.follow_npc_list = {}

	for k,v in pairs(self.buffer_list) do
		v:dispose()
	end
	self.buffer_list = {} -- buffer列表

	self.move_list = {} --移动列表	
	self.move_flag_list = {} -- 移动标志列表
	self.obj_list = {}
	self.temp_hero_load_list = {}
	self.temp_msg_list = {}
	self.map_id = 0
	self.player_grid = nil

	self.scale_time = 0

	-- 取消自动挂机
	gf_auto_atk(false)

	self.pool:dispose()
end

-- 快速清除（用于同一个场景资源）
function Battle:fast_clear()
	self.character:set_camera_target(nil)

	if self._last_select_guid ~= nil then
		self:hide_select(self._last_select_guid)
		self._last_select_guid = nil
	end
	for k,v in pairs(self.enemy_list) do
		self:remove_model(v.guid)
	end
	self.enemy_list = {}
	self.pool:clear_dead()
	self.pool:remove_block()

	for k,v in pairs(self.npc_list) do
		self:remove_model(v.guid)
	end

	for k,v in pairs(self.character_list) do
		self:remove_model(v.guid)
	end

	for k,v in pairs(self.transport_list or {}) do
		self:remove_model(v.guid)
	end
	self.transport_list = {}
	self.npc_pos_list = {}

	self.pool.is_in_scene = false

	self.map_id = 0
	-- 取消自动挂机
	gf_auto_atk(false)
end

function Battle:dispose()
	
end

