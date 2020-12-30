--[[--
-- 武将
-- @Author:Seven
-- @DateTime:2017-04-20 11:49:39
--]]

local ModelBase = require("models.battle.obj.modelBase")
local ModelEffect = require("models.battle.obj.modelEffect")

local Hero = class(ModelBase, function( self, config_data, ... )
	self.is_hero = true
	self.is_self_hero = false -- 是否是玩家自己的武将

	ModelBase._ctor(self, config_data, ...)
end)

function Hero:init()
	-- self.atk_range = self.config_data.atk_range
	-- self.atk_range_d = self.atk_range*self.atk_range

	self.follow_distance = ConfigMgr:get_const("hero_follow_d")

	self.follow_move = self.root:AddComponent("Seven.Move.FollowMove")
	self.follow_move:SetFollowDistance(self.follow_distance)
	self.follow_move:SetAtkFollowDistance(ConfigMgr:get_const("hero_atk_follow_d"))
	self.follow_move.starMoveFn = handler(self, self.on_follow_move)
	self.follow_move.atkBackFn = handler(self, self.on_atk_back)
	self.follow_move:SetHero(true)
	
	self.effect_list = {}

	self.battle_item = LuaItemManager:get_item_obejct("battle") -- 战斗数据类
	self.setting_item = LuaItemManager:get_item_obejct("setting")
	self.float_item = LuaItemManager:get_item_obejct("floatTextSys") -- 飘字

	self.is_atk = false

	-- 设置模型点击
	self.touch = self.root:AddComponent("Seven.Touch.Touch3DModel")
	self.touch.onTouchedFn = handler(self, self.on_touch_down)

	self.sound_list = 
	{
		dead = nil,
        -- hit = "behit_common",
	}

	self:set_follow_target(self.follow_target)
end

function Hero:set_is_self( is_self )
	self.is_self_hero = is_self
	if is_self then
		Net:receive({max_hp = self.max_hp,hp = self.hp,}, ClientProto.HeroBlood)
	end
end

-- 拥有者
function Hero:set_ower( ower )
	self.ower = ower
end

function Hero:get_ower()
	return self.ower
end

-- 判断是否有攻击动作
function Hero:is_have_skill_ani( skill_id )
	-- print("判断是否有攻击动作",skill_id,self.cmd_list[skill_id])
	return self.cmd_list[skill_id] ~= nil
end

-- 设置跟随者
function Hero:set_follow_target( target )
	self.follow_target = target
	if not self.is_init or not target then
		return
	end
	self.follow_move:SetTarget(target.root)
end

function Hero:get_follow_target()
	return self.follow_target
end

-- 设置跟随者跟随移动（组队跟随的时候）
function Hero:set_target_follow_move( flag )
	self.follow_move:SetTargetFollowMove(flag)
end

-- 设置移动速度
function Hero:set_speed( speed )
	Hero._base.set_speed(self, speed)
	self.follow_move.speed = speed-1
end

function Hero:hurt( dmg, result )
	self._base.hurt(self,dmg,result)

	--如果是自己的武将
	if self.is_self_hero then
		local max_hp = self:get_max_hp()
		local hp = self:get_hp()
		Net:receive({max_hp = max_hp,hp = hp,}, ClientProto.HeroBlood)
	end
	
end

-- 设置是否跟随
function Hero:set_follow( follow )
	if self.is_follow == follow then
		return
	end

	self.is_follow = follow
	self.follow_move:SetFollow(follow)
end

-- 设置战斗状态
function Hero:set_battle_flag( flag )
	Hero._base.set_battle_flag(self, flag)
	self:set_hp_visible(self.battle_flag)
	if flag then
		self:start_atk()
	else
		self:stop_atk()
	end
end

-- 设置不可移动
function Hero:set_can_not_move( not_move )
	Hero._base.set_can_not_move(self, not_move)
	self:set_follow(not_move)
end

function Hero:faraway()
	Hero._base.faraway(self)
	-- gf_remove_update(self)
	if self.schedule then
		self.schedule:stop()
		self.schedule = nil
	end

	self:stop_atk()
	self:set_follow(false)
	self:set_is_self(false)
end

function Hero:reset()
	Hero._base.reset(self)
	self.is_atk = false
	self.follow_move:SetAtk(false)
end

function Hero:get_code()
	return self.config_data.code
end

function Hero:add_effect( effect, key )
	self.effect_list[key] = effect
end

function Hero:show_effect( key )
	if self.effect_list[key] then
		self.effect_list[key]:show_effect(key)
	end
end

function Hero:show_fly_effect()
	local effect = self.effect_list[self.cur_cmd]
	if effect then
		effect:show_fly_effect(self.cur_cmd)
	end
end

function Hero:init_effect()
	local skill_data = ConfigMgr:get_config("skill")[self.config_data.skill_id]
	self:add_effect(ModelEffect(self.config_data.skill_id, self), "atk")

	self.target_type = skill_data.target_type -- 攻击类型
	self.atk_range = skill_data.cast_distance*0.1
	self.atk_range_d = self.atk_range^2
	self.cmd_list = {}
	for i,v in ipairs(self.config_data.ani_name or {}) do
		self.cmd_list[v[1]] = v[2]
		if not self.effect_list[v[2]] then
			self:add_effect(ModelEffect(v[1],self), v[2])
		end
	end
end

-- 初始化帧事件
function Hero:init_ani_event()

	for i,v in pairs(self.cmd_list) do
		self.event_mgr:AddEvent(v, 0.01, v)
	end

	for k,v in pairs(self.effect_list) do
		if v:is_have_fly() then
			self.event_mgr:AddEvent(k, v:get_atk_percent(), "showFlyAtk") -- 显示飞行道具
			v:set_fly_end_cb(handler(self, self.show_hurt))
		else
			-- 显示伤害数字
			self.event_mgr:AddEvent(k, v:get_atk_percent(), "showHurt")
		end
	end

	self.event_mgr:AddEvent("dead", 0.95, "dead")
end

-- 动画帧事件回调
function Hero:ani_event_callback( arg )
	self._base.ani_event_callback(self, arg)
	
	local show_effect = self:is_mesh_enable()
	if not self.is_self_hero and show_effect then
		show_effect = not self.setting_item:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_EFFECTS)
	end

	if arg == "showHurt" then
	   	if not self.target then
	   		return
	   	end

	    self:show_hurt()
	   	-- print("武将攻击目标",self.target.guid,self.follow_target.guid,self.config_data.skill_id)
		-- self.battle_item:skill_cast_c2s(
		-- 	self.config_data.skill_id, 
		-- 	self.transform.position.x, 
		-- 	self.transform.position.z,
		-- 	self.transform.eulerAngles.y+90,
		-- 	self.target.guid,
		-- 	self.guid
		-- )
	
	elseif arg == "showFlyAtk" then
		if show_effect then
		   	self:show_fly_effect()
	    end

	elseif arg == "dead" then
		self.battle_item.pool:add_hero(self)

	end

	if show_effect then
		self:show_effect(arg)
	end
end

-- 显示伤害数字
function Hero:show_hurt()
	local data = self.battle_item:get_result(self.guid)
	if data and self.target then
		self.float_item:battle_float_text(self.target.transform, data.result, data.damage)
	end
end

-- 检查攻击目标是否在攻击范围内，不在移动到攻击范围
function Hero:check_in_atk_range( target )
	local distance = Seven.PublicFun.GetDistanceSquare(self.transform, target.transform)
	if distance > self.atk_range_d then -- 移动到攻击范围内
		return false
	end

	return true
end

function Hero:is_target_dead()
	if not self.target or self.target.dead or self.target.is_faraway then
		return true
	end
	return false
end

-- 检查目标是否是自己或主人
function Hero:check_target( target )
	if not target then
		return false
	end
	
	if target.guid == self.guid or target.guid == self.follow_target.guid then
		return true
	end
	return false
end

function Hero:get_target()
	if self.target_type == ServerEnum.TARGET_OF_EFFECT.ENEMY then -- 敌人
		if not self.setting_item:is_auto_atk() then
			if not self.follow_target then
				return nil
			end

			if self.follow_target.target and not self.follow_target.target.dead then -- 优先攻击人物攻击单位
				return self.follow_target.target
			end

			if self.follow_target.get_attacker then
				local attacker = self.follow_target:get_attacker() 
				if attacker and not attacker.dead and not self:check_target(attacker) then -- 攻击正在攻击人物的单位
					return attacker
				end
			end
			
			if not self:check_target(self:get_attacker()) then
				return self:get_attacker() -- 攻击正在攻击自己的单位
			end
			return nil
		else
			return self.battle_item:get_target()
		end
	elseif self.target_type == ServerEnum.TARGET_OF_EFFECT.SELF then -- 自己
		return self

	elseif self.target_type == ServerEnum.TARGET_OF_EFFECT.MASTER then -- 主人
		return self.follow_target

	elseif self.target_type == ServerEnum.TARGET_OF_EFFECT.FRIEND then -- 友方
		return self.battle_item:get_friend()
	end
end

function Hero:init_atk()
	-- 真正移动
	if self:is_move() then
		return ClientEnum.MODEL_STATE.MOVING
	end


	-- if self:is_target_dead() then -- 没有攻击目标
		self.target = self:get_target()
		if self:is_target_dead() then
			return ClientEnum.MODEL_STATE.NO_TARGET
		end
	-- end

	if not self:check_in_atk_range(self.target) then
		--移动到攻击目标
		self:move_to2(self.target.transform, handler(self, self.arrive_destination_callback))

		return ClientEnum.MODEL_STATE.MOVE_TO_TARGET
	end

	if self.target then
		self.transform:LookAt(self.target:get_position())
	end

	return ClientEnum.MODEL_STATE.ATK
end

-- 播放攻击动作
function Hero:play_atk(target, skill_id)
	if target and skill_id then
		print("设置武将攻击目标,服务器",target.guid,skill_id,self.config_data.skill_id)
		-- if self.is_self_hero and self.config_data.skill_id == skill_id then -- 自己武将，不处理主动技能
		-- 	return
		-- end
		local cmd = self.cmd_list[skill_id]
		if not cmd then
			return
		end

		self.cur_cmd = cmd
		self.target = target
		print("设置武将攻击目标,服务器",target.guid,skill_id,cmd)

		if target then
			self.transform:LookAt(target:get_position())
		end
		self.attack_mgr:PlayAttack(cmd)

	else
		-- local state = self:init_atk()
		-- if state == ClientEnum.MODEL_STATE.ATK then
		-- 	self.attack_mgr:PlayAttack("atk")

		-- elseif state == ClientEnum.MODEL_STATE.NO_TARGET then
		-- 	print("武将没有攻击目标")
		-- 	self:stop_atk()
		-- end
		self.target = target
	end
end

-- 开始攻击
function Hero:start_atk()
	if self.is_atk then
		return
	end
	print("武将开始攻击")
	self.target = nil
	self.is_atk = true
	self:set_follow(false) -- 开始攻击，交给服务器控制
	-- self.follow_move:SetAtk(true)
end

function Hero:stop_atk()
	if not self.is_atk then
		return
	end
	print("武将结束攻击")
	self.is_atk = false
	self.target = nil
	self:stop_move()
	self:set_follow(true) -- 停止攻击，客户端控制跟随
	-- self.follow_move:SetAtk(false)

	-- 判断武将和人物距离，是否超过最大跟随距离，超过，瞬移会去人物后面
end

function Hero:set_hp( hp, max_hp )
	if self.is_self_hero then
		Net:receive({max_hp = max_hp,hp = hp,}, ClientProto.HeroBlood)
	end
	
	Hero._base.set_hp(self, hp, max_hp)
	if self.dead then
		self:stop_atk()
		self:set_follow(false)
	end
end

function Hero:on_auto_atk_update( dt )
	if self.is_atk and not self.is_dizzy then
		self:play_atk()
	end
end

function Hero:on_update( dt )
	self:on_auto_atk_update()
end

function Hero:set_name(name)
   	self.blood_line:set_name(name)
end

function Hero:on_receive(msg, id1, id2, sid)
	if(id1==Net:get_id1("hero"))then
        if id2 == Net:get_id2("hero", "RenameHeroR") then
        	if self.is_self_hero and self.config_data.code == msg.heroId then
        		local name = gf_getItemObject("hero"):get_name(self.config_data.code) or ""
        		self:set_name(name)
        	end
        end
    end
end

-- 玩家到达目的地回调
function Hero:arrive_destination_callback()
	Hero._base.arrive_destination_callback(self)
end

-- 跟随移动开始，停止攻击
function Hero:on_follow_move()
	self:stop_atk() 
end

function Hero:on_atk_back()
	self:stop_atk() 
end

function Hero:on_touch_down()
	if not self.follow_target.is_self then
		if self.battle_item:is_can_atk_player(self.follow_target) then
			Net:receive({target = self, auto_atk = true}, ClientProto.TouchMonster)
		end
		self.battle_item:show_select(self.guid)
	end
end

function Hero:dispose()
	-- gf_remove_update(self)
	if self.schedule then
		self.schedule:stop()
		self.schedule = nil
	end

	for k,v in pairs(self.effect_list) do
		v:dispose()
	end
	self.effect_list = {}

	Hero._base.dispose(self)
end

return Hero