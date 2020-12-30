--[[--
-- 怪物
-- @Author:Seven
-- @DateTime:2017-04-20 11:49:39
--]]

local ModelBase = require("models.battle.obj.modelBase")
local ModelEffect = require("models.battle.obj.modelEffect")
local XPEffect = require("models.battle.obj.xpEffect")

local FadeInTime = 0.3
local FadeOutTime = 2

local Monster = class(ModelBase, function( self, config_data, ... )
	self.is_monster = true
	self.is_boss = config_data.type == ServerEnum.CREATURE_TYPE.BOSS or config_data.type == ServerEnum.CREATURE_TYPE.WORLD_BOSS
	self.is_collider = config_data.type == ServerEnum.CREATURE_TYPE.TOUCH -- 是碰撞触发的
	gf_print_table(config_data,"创建怪物    创建的怪物是否触碰怪"..tostring(self.is_collider))

	self.battle_item = LuaItemManager:get_item_obejct("battle")
	self.float_item = LuaItemManager:get_item_obejct("floatTextSys") -- 飘字
	self.setting_item = LuaItemManager:get_item_obejct("setting")
	
	ModelBase._ctor(self, config_data, ...)
end)

function Monster:init()

	self.is_show_blood = not self.config_data.show_blood and not self.is_boss -- 是否会显示血条名字

	self.is_dead_first = false
	self.fade_time = 0 -- 溶解消失时间
	self.fade_in_time = 0 -- 溶解出现时间

	self.render = self.root:GetComponentInChildren("UnityEngine.Renderer")
	if self.render then
		self.material = self.render.material
	end

	-- 设置模型点击
	self.touch = self.root:AddComponent("Seven.Touch.Touch3DModel")
	self.touch.onTouchedFn = handler(self, self.on_touch_down)

	local touch_area = self.config_data.touch_area
	if self.normal_move and self.normal_move.charCtr and touch_area and touch_area[1] and touch_area[2] then
		self.normal_move:SetCharCtrRadiusAndHeight(touch_area[1], touch_area[2])
	end

	self.effect_list = {}

	-- self:set_speed(self.speed)
	self.is_have_atk_ani = self.event_mgr:GetAniTime("atk") > 0 -- 是否有攻击动作

	local child = self.root.transform:Find("Bip001")
	if child then
		child = child.gameObject
		if self.is_collider then
			local collider = child:AddComponent("UnityEngine.SphereCollider")
			collider.radius = 1
			collider.isTrigger = true
			collider.center = Vector3(0,0,0)
			self.collider_event = child:AddComponent("Seven.ColliderEvent")
			self.collider_event.onCollisionEnterFn = handler(self, self.enter_collider)
			child.layer = 7
		else
			child.layer = 8
		end
	end

	gf_register_update(self)

	self.sound_list = 
	{
		atk = self.is_boss and "boss_atk_1" or nil,
		skill1 = self.is_boss and "boss_atk_2" or nil,
		skill2 = self.is_boss and "boss_skill_1" or nil,
		xp = nil,
		dead = nil,
		hit = nil,
	}
end

function Monster:show_blood( show )
	if self.is_show_blood then
		self:set_hp_visible(show)
		self:set_name_visible(show)
	end
end

function Monster:enter_collider(other)
	print("--触碰到了，判断与玩家或者坐骑产生了碰撞")
	local char = self.battle_item:get_character()
	if char and (other.transform == char.transform or (char.horse and other.transform == char.horse.transform)) then
		print("触碰怪物",self.guid)
		Net:send({guid=self.guid},"scene","Touch")
	end
end

function Monster:is_collect()
	return self.config_data.type == ServerEnum.CREATURE_TYPE.COLLECT
end

function Monster:add_effect( effect, key )
	self.effect_list[key] = effect
end

-- 设置战斗状态
function Monster:set_battle_flag( flag )
	Monster._base.set_battle_flag(self, flag)
	if not flag then
		self:show_blood(false)
	end
	print("怪物进入战斗状态",flag)
end

function Monster:set_blood_line( blood_line )
	Monster._base.set_blood_line(self, blood_line)
	self:set_name_visible(false)
end

function Monster:show_effect( key )
	if not self:is_mesh_enable() then
		return
	end
	
	local effect = self.effect_list[key]
	if effect then
		effect:show_effect()
	end
end

function Monster:show_fly_effect()
	local effect = self.effect_list[self.cur_cmd]
	if effect then
		effect:show_fly_effect()
	end
end

function Monster:play_atk( target, skill_id )
	print("怪物攻击",target,skill_id)
	if not target then
		return
	end
	self.target = target

	if self.config_data.move_type ~= 0 then -- 不移动的怪物不面向攻击目标
		local pos = target:get_position()
		pos.y = self.transform.position.y
		self.transform:LookAt(pos)
	end

	self.cur_cmd = self.cmd_list[skill_id] or "atk"
	if not self:show_xp(skill_id) then
		if self.cur_cmd == "skill1" and self.cmd_list[self.last_skill] == "atk" then
			self.effect_list.atk:hide()
		end
		self.attack_mgr:PlayAttack(self.cur_cmd)
	end

	-- 没有攻击动作的怪物(如箭塔)
	if not self.is_have_atk_ani then
		self:show_fly_effect()
		self:show_effect(self.cur_cmd)
	end
	self.last_skill = skill_id
end

function Monster:reset()
	Monster._base.reset(self)

	self.fade_time = 0
	self.fade_in_time = FadeInTime

	local dissolve_t = 1
	if self.config_data.show_ani and self.config_data.show_ani == 1 then -- 有出厂动画
		if math.random(0,100) <= self.config_data.show_ani_odds then
			self.animator:Play("show", 0)
			dissolve_t = 0.1
		end
	end

	if self.material then
		self.material:SetFloat("_DissolveThreshold", dissolve_t)
	end

	self:set_hp_visible(false)
	self:set_name_visible(false)
	if self.effect_list.shadow then
		self.effect_list.shadow:show_effect()
	end
	-- Seven.PublicFun.ChangeShader(self.root, "Unlit/Texture")

	-- 判断是否需要显示模型
	self:set_mesh_enable(not self.setting_item:get_setting_value(ClientEnum.SETTING.SHIELD_MONSTER))
end

-- 击退
function Monster:atk_back()
	if self.attacker and self.attacker.is_player then
		local data = ConfigMgr:get_config("monster_atk_back")[self.attacker.config_data.career]
		self.attack_mgr.speed = data.speed or 0
		local distance = (data.distance or 0)*0.01
		if distance > 0 then
			self.attack_mgr:AtkMove(Seven.PublicFun.TransformDirection(self.attacker.root, distance))
		end
	end
end

function Monster:set_hp( hp, max_hp )
	if self.dead and hp > 0 then
		if self.animator:GetCurrentAnimatorStateInfo (1):IsName ("EmptyState") == false then
			self.animator:SetTrigger("cancel")
		end
	end

	Monster._base.set_hp(self, hp, max_hp)
end

function Monster:show_dead()
	if not self:have_dead_ani() then -- 没有死亡动作，立即删除
		self.battle_item:remove_model(self.guid)
		return
	end
	-- 隐藏脚底阴影
	if self.effect_list.shadow then
		self.effect_list.shadow:hide()
	end

	if self.dead and not self.is_show_dead then
		if self.blood_line then
			self.blood_line:hide()
		end
		for k,v in pairs(self.effect_list or {}) do
			v:hide()
		end

		self.battle_item:hide_select(self.guid)
		self.run_dead_time = self.dead_time
		
		-- self.battle_item:check_block(self.config_data.code)
	end
	--发死亡客户端协议
	if self.dead and not self.is_dead_first then
		self.is_dead_first = true
		print("monster dead wtf ")
		Net:receive({monster_id = self.config_data.code,guid = self.guid}, ClientProto.MonsterDead)
	end
	
	Monster._base.show_dead(self)
	
end

function Monster:hurt( dmg, result )
	if not self.is_init then
		return
	end
	Monster._base.hurt(self, dmg, result)

	self:check_battle_effect(result)
	self:atk_back()
	--如果是boss 推送血量更新客户端协议 用于boss血量界面更新
	if self.config_data.type == ServerEnum.CREATURE_TYPE.BOSS or self.config_data.type == ServerEnum.CREATURE_TYPE.WORLD_BOSS then
		gf_receive_client_prot({guid = self.guid,hp=dmg}, ClientProto.BossBlood)
	end
end

-- 转镜特效
function Monster:init_xp(skill_id)
	local data = ConfigMgr:get_config("xp_effect")[skill_id]
	if not data then
		return
	end

	local task = LuaItemManager:get_item_obejct("task"):get_main_task() 
	if not task or task.code ~= data.condition then
		return
	end

	self.xp_effect = XPEffect(data)
	self.xp_skill_id = skill_id
end

-- 播放转镜特效
function Monster:show_xp(skill_id)
	if not self.xp_effect or skill_id ~= self.xp_skill_id or self.is_xp_show then
		return false
	end

	local cb = function( effect )
		local data = ConfigMgr:get_config("xp_back")[skill_id]
		local per = data.per
		if not per then
			per = 0.5
			gf_error_tips(string.format("战斗表现表xp_back没有配技能id为:%d的动作播放比例！！！",skill_id))
		end
		self.animator:Play(self.cur_cmd, 1, per) -- 动作开始播放的百分比
	end
	self.is_xp_show = true
	self.xp_effect:show_effect()
	self.xp_effect:set_finish_cb(cb)
	return true
end

-- 添加特效
function Monster:init_effect()
	self.cmd_list = {}
	for i,v in ipairs(self.config_data.skill_list or {}) do
		self:init_xp(v)
		local cmd = self.config_data.skill_action_name_list[i]
		if not cmd then
			cmd = "atk"
			gf_error_tips(string.format("怪物%d,技能%d,没有配上对应的动作，字段skill_action_name_list，请检查怪物表！！！",self.config_data.code, v))
		else
			self.effect_list[cmd] = ModelEffect(v, self)
			self.cmd_list[v] = cmd
		end
	end
end

-- 初始化帧事件
function Monster:init_ani_event()
	for k,v in pairs(self.effect_list) do
		if v:is_have_fly() then
			self.event_mgr:AddEvent(k, v:get_atk_percent(), "showFlyAtk") -- 显示飞行道具
			v:set_fly_end_cb(handler(self, self.show_hurt))
		else
			-- 显示伤害数字
			self.event_mgr:AddEvent(k, v:get_atk_percent(), "showHurt")
		end
	end

	-- 添加事件
	for i,v in ipairs(self.config_data.skill_action_name_list or {}) do
		self.event_mgr:AddEvent(v, 0, v) 
	end
end

-- 动画帧事件回调
function Monster:ani_event_callback( arg )
	self._base.ani_event_callback(self, arg)
	print("Monster:动画帧事件回调:",arg)

	if arg == "showHurt" then
		self:show_hurt()

	elseif arg == "showFlyAtk" then
		self:show_fly_effect()
	end

	self:show_effect(arg)
end

-- 显示伤害数字
function Monster:show_hurt()
	local data = self.battle_item:get_result(self.guid)
	if data then
		self.float_item:battle_float_text(self.target.transform, data.result, data.damage)
	end
end

-- 溶解消失
function Monster:fade_out(dt)
	if not self.dead then
		return
	end

	if self.run_dead_time > 0 then
		self.run_dead_time = self.run_dead_time - dt
		if self.run_dead_time <= 0 then
			self.fade_time = FadeOutTime
		end
	end

	if self.fade_time > 0 then
		self.fade_time = self.fade_time - dt
		if self.material then
			self.material:SetFloat("_DissolveThreshold", 1-(self.fade_time/FadeOutTime))
		end
		
		if self.fade_time <= 0 then
			self.battle_item.pool:remove_dead(self)
			self.battle_item.pool:add_monster(self)
		end
	end
end

-- 溶解出现
function Monster:fade_in(dt)
	if self.fade_in_time > 0 then
		self.fade_in_time = self.fade_in_time - dt
		if self.material then
			self.material:SetFloat("_DissolveThreshold", self.fade_in_time/FadeInTime)
		end
	end
end

function Monster:update_shake(dt)
	if not self.is_shake then
		return
	end

	if self.shake_time > 0 then
		self.shake_time = self.shake_time - dt
		if self.shake_time <= 0 then
			self.is_shake = false
			self.battle_item:shake_screen(self.shake_data.dir[1],self.shake_data.dir[2],self.shake_data.dir[3],self.shake_data.time*0.001)
		end
	end
end

function Monster:check_battle_effect(result)
	
	if self.attacker and self.attacker == self.battle_item.character and result == ServerEnum.SKILL_RESULT.CRIT then --  受到玩家攻击,并且是暴击
		
		-- 检查是否需要震屏
		local data = ConfigMgr:get_config("shake")[result]
		if data then
			local is_have = false
			for i,v in ipairs(data.career_list or {}) do
				if v == self.attacker.config_data.career then
					is_have = true
					break
				end
			end

			if is_have then
				self.shake_data = data
				self.shake_time = (data.late_time or 0)*0.001
				self.is_shake = true
				if self.shake_time == 0 then
					self.battle_item:shake_screen(data.dir[1],data.dir[2],data.dir[3],data.time*0.001)
					self.is_shake = false
				end
			end
		end

		-- 检查是否需要缩放镜头
		data = ConfigMgr:get_config("camera_scale")[result]
		if data then
			local is_have = false
			for i,v in ipairs(data.career_list or {}) do
				if v == self.attacker.config_data.career then
					is_have = true
					break
				end
			end

			if is_have then
				self.attacker.camera_follow:SetCameraScale(
					data.scale_time*0.001,
					data.stop_time*0.001,
					data.resume_time*0.001,
					data.late_time*0.001,
					data.distance
				)
			end
		end
	end

	-- 检查是否需要慢放镜头
	if self.dead then
		local data = ConfigMgr:get_config("time_scale")[self.config_data.code]
		if data then
			self.battle_item:set_time_scale(data.scale*0.1, data.time*0.001)
		end
	end

	-- 检查是否需要播放受伤特效
	local data = ConfigMgr:get_config("monster_hurt_effect")[self.config_data.code]
	if data then
		local cb = function( effect, index )
			local y = self.model_height*data.pos[index]*0.01
			effect:set_parent(self.transform)
			effect.transform.localPosition = Vector3(0, y, 0)
			effect:set_local_euler_angles(Vector3(0,0,0))
			effect:show()

			for i,v in ipairs(data.effect or {}) do -- 隐藏其他特效，一次只显示其中一个
				if i ~= index then
					local e = self.effect_list[v]
					if e then
						e:hide()
					end
				end
			end
		end

		for i,v in ipairs(data.hp_per or {}) do
			local name = data.effect[i]
			if not self.effect_list[name] then
				if self.hp_percent*100 <= v then
					self:add_effect(self.battle_item:get_effect(name..".u3d", cb, i), name)
				end
			end
		end
	end
end

function Monster:on_update( dt )
	self:fade_out(dt)
	self:fade_in(dt)
	self:update_shake(dt)
end

function Monster:on_touch_down()
	print("点击怪物")
	local last_guid = self.battle_item:show_select(self.guid)
	if last_guid == self.guid then
		if self.battle_item:is_can_atk_monster(self) then -- 第二次选中，自动攻击
			Net:receive({target = self, auto_atk = true}, ClientProto.TouchMonster)
		end
	else
		-- 第一次选中，显示名字
		self:set_name_visible(true)
		if self.battle_item:is_can_atk_monster(self) then -- 第二次选中，自动攻击
			Net:receive({target = self, auto_atk = false}, ClientProto.TouchMonster)
		end
	end
end

function Monster:dispose()
	gf_remove_update(self)

	for k,v in pairs(self.effect_list) do
		v:dispose()
	end
	self.effect_list = {}
	self.render = nil
	self.material = nil
	self.touch = nil
	self.collider_event = nil
	
	Monster._base.dispose(self)
end

return Monster
