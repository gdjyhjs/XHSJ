--[[--
-- 角色特效
-- @Author:Seven
-- @DateTime:2017-04-27 09:50:46
--]]

local EffectTransform = LuaHelper.Find("Effect").transform
local Effect = require("common.effect")
local FlyEffect = require("models.battle.obj.flyEffect")

local CMD = {"skill1","skill2","skill3","skill4","skill5","atk1","atk2","atk3"}
local FLY_CMD = {"ONE", "TWO", "THREE", "FOUR", "XP", "NORMAL_1", "NORMAL_2", "NORMAL_3"}

local PLAY_POS = 
{
	SELF   	= 1, -- 以自己为中心
	TARGET 	= 2, -- 以目标为中心
	TARGET2 = 3, -- 以目标为中心,飞行道具到达后才播放目标身上特效
}

local FLY_PATERN = 
{
	LINE  = 1, -- 直线
	RADAR = 2, -- 抛物线
}

local CharacterEffect = class(function( self, config_data, ower )
	self.config_data = config_data
	self.ower = ower

	self:init()
end)

function CharacterEffect:init()
	local res_id = math.floor(self.config_data.code*0.001)
	local parent
	if self.config_data.pos_type == ServerEnum.SKILL_POS.NORMAL_1 or 
	   self.config_data.pos_type == ServerEnum.SKILL_POS.NORMAL_2 or
	   self.config_data.pos_type == ServerEnum.SKILL_POS.NORMAL_3 then -- 普通攻击
	    parent = self.ower.transform
	   	res_id = self.config_data.code
	end

	local res_data = ConfigMgr:get_config("skill_res")[res_id]
	if not res_data then
		print_error("ERROR:找不到技能资源数据，skill_id=",self.config_data.code)
		return
	end

	local key = CMD[self.config_data.pos_type]

	if res_data.follow and res_data.follow == 1 then
		parent = self.ower.transform
		self.ower.normal_move:AddSkill(key)
	end

	if res_data.self_effect then
		self.ower:add_effect(self, key)
		self[key] = self:create_effect(res_data.self_effect..".u3d", nil, nil, parent)
	end

	if (res_data.play_pos == PLAY_POS.TARGET or res_data.play_pos == PLAY_POS.TARGET2) and res_data.target_effect then
		self.target_effect = self:create_effect(res_data.target_effect..".u3d")
	end


	-- 挂在骨骼上面的特效
	if res_data.skeleton_effect_list and res_data.skeleton_name_list then
		self.skeleton_list = {}

		local cb = function ( effect, index )
			local node = LuaHelper.FindChild(self.ower.root, res_data.skeleton_name_list[index])
			if node then
				effect:set_parent(node.transform)
			end
			effect.root.transform.localScale = Vector3(1,1,1)
			effect.root.transform.localPosition = Vector3(0,0,0)
			effect:set_eulerAngles(self.ower.root.transform.eulerAngles)

		end
		for k,v in pairs(res_data.skeleton_effect_list) do
			self.skeleton_list[k] = self:create_effect(v..".u3d", cb, k)
		end

	end

	-- 受击特效
	if res_data.hit_effect then
		self.hit_effect = self:create_effect(res_data.hit_effect..".u3d")
	end

	-- 是否有飞行道具
	if res_data.is_have_fly == 1 then
		self.fly_list = {}

		local cb = function( effect )
			effect:set_parent(EffectTransform)
			effect:set_speed(res_data.speed)
		end
		local effect = FlyEffect(res_data.fly_model..".u3d", res_data.fly_patern == FLY_PATERN.RADAR, cb)
		self.fly_list[FLY_CMD[self.config_data.pos_type]] = effect

		-- self.speed = res_data.speed
		-- self.atk_pos = res_data.atk_pos*0.01
		self.is_have_fly = true
		gf_print_table(self.fly_list, "飞行道具")
	end

	if res_data.is_move_to_target and res_data.is_move_to_target == 1 then -- 是否需要移动到攻击目标再播放技能（冲锋技能）
		self._is_move_to_target = true
		self._move_speed = res_data.move_speed
		self._star_forward_dis = self.config_data.cast_distance*0.1 -- 开始冲锋距离
		self._star_forward_dis = self._star_forward_dis*self._star_forward_dis
	end

	if res_data.forward_effect then -- 冲锋特效
		local cb = function( effect )
			effect:set_parent(self.ower.transform)
			effect.root.transform.localPosition = Vector3(0,0,0)
			effect:set_eulerAngles(self.ower.transform.eulerAngles)
		end
		self.forward_effect =  Effect(res_data.forward_effect..".u3d", cb)

		self.ower:add_effect(self, "forward")
	end

	self.res_data = res_data
end

function CharacterEffect:create_effect( url, cb, key, parent )
	local effect = Effect(url, cb, key)
	effect:set_parent(parent or EffectTransform)
	return effect
end

function CharacterEffect:show_target_effect(pos)
	if not self.target_effect then
		return
	end

	if not pos then
		if self.ower.target and self.ower.target.transform then
			pos = self.ower.target.transform.position
		else
			pos = self.ower.transform.position
		end
	end
	pos.y = pos.y + 0.5
	
	self.target_effect:show_effect(pos)
end

function CharacterEffect:show_effect(cmd)
	
	if self[cmd] then
		local pos = self.ower.transform.position
		pos.y = pos.y + 0.5
		self[cmd]:show_effect(pos, self.ower.transform.eulerAngles)
	end

	if self.skeleton_list then
		for k,v in pairs(self.skeleton_list) do
			v:show_effect()
		end
	end

	-- 是否在目标身上播放特效
	if self.target_effect and self.res_data.play_pos == PLAY_POS.TARGET then
		self:show_target_effect()
	end

	print("播放特效",cmd,self.forward_effect)
	if cmd == "forward" and self.forward_effect then
		self.forward_effect:show_effect()
	else
		if self.forward_effect then
			self.forward_effect:hide()
		end
	end

end

function CharacterEffect:show_fly_effect( cmd )
	
	-- 是否有飞行道具
	if self.is_have_fly then
		if self.ower.is_faraway then
			return
		end
		
		local effect = self.fly_list[cmd]
		if not effect then
			return
		end
		local pos = self.ower.transform.position
		if self.res_data.start_pos then
			pos = self.ower.transform:TransformPoint(Vector3(self.res_data.start_pos[1],self.res_data.start_pos[2],self.res_data.start_pos[3]))
		end

		if self.res_data.atk_pos then
			local height = 3.5
			if self.ower.target then
				height = self.ower.target.model_height
			end

			effect:set_atk_pos(Vector3(0,self.res_data.atk_pos*0.01*height,0))
		end
		effect:show_effect(pos, self.ower.transform.eulerAngles)

		if self.ower.target and not self.ower.target.dead then
			effect:fly(self.ower.target)
		else
			local tpos = Seven.PublicFun.TransformDirection(self.ower.transform, Vector3(0,0,15))
			tpos.y = pos.y+1
			effect:move_to(tpos)
		end

		if self.res_data.play_pos == PLAY_POS.TARGET2 or self.hit_effect then
			local cb = function(effect)
				
				self:show_target_effect(effect.transform.position)
				if self.hit_effect and self.ower.target then
					local pos = self.ower.target.transform.position
					pos.y = pos.y+self.ower.target.model_height*(self.res_data.hit_height or 0.5)
					self.hit_effect:show_effect(pos)
				end
			end
			effect:set_arrive_cb(cb)
		end
	end

	if not self.is_have_fly and self.hit_effect and self.ower.target and not Seven.PublicFun.IsNull(self.ower.target.transform) then

		local pos = self.ower.target.transform.position
		pos.y = pos.y + self.ower.target.model_height*(self.res_data.hit_height or 0.5)

		self.hit_effect:show_effect(pos)
	end
end

-- 获取动作攻击百分比
function CharacterEffect:get_atk_percent(index)
	if self.res_data.action_per then
		return self.res_data.action_per*0.01
	end
	return 0.5
end

-- 显示受击特效，服务器下发伤害的时候
function CharacterEffect:show_hit_effect_s2c( target_list )
	if not target_list or not self.res_data.hit_effect then
		return
	end

	local battle = LuaItemManager:get_item_obejct("battle")

	local finish_cb = function( effect, pos )
		effect:show_effect(pos)
	end

	local end_cb = function(effect)
		effect:dispose()
	end

	for k,v in pairs(target_list) do
		local target = battle:get_model(v.guid)
		if target then
			local pos = target:get_position()
			local e = self:create_effect(self.res_data.hit_effect..".u3d", finish_cb, pos)
			e:set_finish_cb(end_cb)
		end
	end
end

-- 重设技能延时时间
function CharacterEffect:reset_delay_time( cmd, dtime )
	if self[cmd] then
		self[cmd]:reset_delay_time(dtime)
	end
end

-- 是否是冲锋技能
function CharacterEffect:is_move_to_target()
	return self._is_move_to_target
end

-- 获取移动速度
function CharacterEffect:get_speed()
	return self._move_speed
end

function CharacterEffect:get_forward_dis()
	return self._star_forward_dis
end

function CharacterEffect:hide()
	if self[CMD[self.config_data.pos_type]] then
		self[CMD[self.config_data.pos_type]]:hide()
	end

	for k,v in pairs(self.fly_list or {}) do
		v:hide()
	end

	for k,v in pairs(self.skeleton_list or {}) do
		v:hide()
	end

	if self.hit_effect then
		self.hit_effect:hide()
	end

	if self.target_effect then
		self.target_effect:hide()
	end

	if self.forward_effect then
		self.forward_effect:hide()
	end
end

function CharacterEffect:dispose()
	if self[CMD[self.config_data.pos_type]] then
		self[CMD[self.config_data.pos_type]]:dispose()
		self[CMD[self.config_data.pos_type]] = nil
	end

	for k,v in pairs(self.fly_list or {}) do
		v:dispose()
	end
	self.fly_list = nil

	for k,v in pairs(self.skeleton_list or {}) do
		v:dispose()
	end
	self.skeleton_list = nil

	if self.hit_effect then
		self.hit_effect:dispose()
		self.hit_effect = nil
	end

	if self.target_effect then
		self.target_effect:dispose()
		self.target_effect = nil
	end

	if self.forward_effect then
		self.forward_effect:dispose()
	end
end

return CharacterEffect
