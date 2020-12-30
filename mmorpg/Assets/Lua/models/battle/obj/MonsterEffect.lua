--[[--
-- 怪物技能
-- @Author:Seven
-- @DateTime:2017-09-12 22:13:27
--]]

local EffectTransform = LuaHelper.Find("Effect").transform
local Effect = require("common.effect")
local FlyEffect = require("models.battle.obj.flyEffect")

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

local MonsterEffect = class(function( self, skill_id, ower )
	self.ower = ower
	self.skill_id = skill_id

	self:init(skill_id)
end)

function MonsterEffect:init(skill_id)
	self.config_data = ConfigMgr:get_config("skill_res")[skill_id]
	print("怪物特效",self.skill_id,self.config_data)
	if not self.config_data then
		return
	end

	self:init_self_effect()
	self:init_target_effect()
	self:init_fly_effect()
	self:init_hit_effect()
end

-- 初始化在身上的特效
function MonsterEffect:init_self_effect()
	if not self.config_data.self_effect then
		return
	end

	local function cb( effect )
		effect:set_parent(self.ower.transform)
		effect.root.transform.localPosition = Vector3(0,0,0)
		effect:set_eulerAngles(self.ower.transform.eulerAngles)
	end
	self.self_effect = Effect(self.config_data.self_effect..".u3d", cb)
end

-- 初始目标身上特效
function MonsterEffect:init_target_effect()
	if not self.config_data.target_effect then
		return
	end
	local function cb( effect )
		effect:set_parent(EffectTransform)
		effect.root.transform.localPosition = Vector3(0,0,0)
	end
	self.target_effect = Effect(self.config_data.target_effect..".u3d", cb)
end

-- 初始飞行道具
function MonsterEffect:init_fly_effect()
	if not self.config_data.fly_model then
		return
	end
	print("初始飞行道具")
	local cb = function( effect )
		effect:set_parent(EffectTransform)
		effect:set_speed(self.config_data.speed)
	end
	self.fly_effect = FlyEffect(self.config_data.fly_model..".u3d", self.config_data.fly_patern == FLY_PATERN.RADAR, cb)
end

-- 创建受击特效
function MonsterEffect:init_hit_effect()
	if not self.config_data.hit_effect then
		return
	end
	local function cb( effect )
		effect:set_parent(EffectTransform)
		effect.root.transform.localPosition = Vector3(0,0,0)
	end
	self.hit_effect = Effect(self.config_data.hit_effect..".u3d", cb)
end

-- 显示目标身上的特效
function MonsterEffect:show_target_effect(pos)
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

-- 显示特效
function MonsterEffect:show_effect()
	if self.self_effect then
		self.self_effect:show_effect(nil, self.ower.transform.eulerAngles)
	end

	-- 立即播放目标身上播放特效
	if self.target_effect and self.config_data.play_pos == PLAY_POS.TARGET then
		self:show_target_effect()
		if self.hit_effect then -- 显示受击特效
			self.hit_effect:show_effect()
		end
	end
end

function MonsterEffect:show_fly_effect()
	-- 播放飞行特效
	if self.fly_effect then
		local cb = function( effect )
			self:show_target_effect(effect.transform.position)
			if self.hit_effect and self.ower.target then-- 显示受击特效
				local pos = self.ower.target.transform.position
				pos.y = pos.y+self.ower.target.model_height*(self.config_data.hit_height or 0.5)
				self.hit_effect:show_effect(pos)
			end
			if self.fly_end_cb then
				self.fly_end_cb(effect)
			end
		end

		local pos = self.ower.transform.position
		if self.config_data.start_pos then
			pos = self.ower.transform:TransformPoint(Vector3(self.config_data.start_pos[1],self.config_data.start_pos[2],self.config_data.start_pos[3]))
		end

		if self.config_data.atk_pos then
			local height = 3.5
			if self.ower.target then
				height = self.ower.target.model_height
			end

			self.fly_effect:set_atk_pos(Vector3(0,self.config_data.atk_pos*0.01*height,0))
		end

		self.fly_effect:show_effect(pos, self.ower.transform.eulerAngles)
		self.fly_effect:fly(self.ower.target)
		self.fly_effect:set_arrive_cb(cb)
	end
end

-- 飞行道具击中回调
function MonsterEffect:set_fly_end_cb( cb )
	self.fly_end_cb = cb
end

-- 获取动作攻击百分比
function MonsterEffect:get_atk_percent()
	if self.config_data and self.config_data.action_per then
		return self.config_data.action_per*0.01
	end
	return 0.5
end

-- 是否有飞行道具
function MonsterEffect:is_have_fly()
	return self.fly_effect ~= nil
end

function MonsterEffect:hide()
	if self.self_effect then
		self.self_effect:hide()
	end

	if self.target_effect then
		self.target_effect:hide()
	end

	if self.fly_effect then
		self.fly_effect:hide()
	end
end

function MonsterEffect:dispose()
	if self.self_effect then
		self.self_effect:dispose()
	end

	if self.target_effect then
		self.target_effect:dispose()
	end

	if self.fly_effect then
		self.fly_effect:dispose()
	end

	if self.hit_effect then
		self.hit_effect:dispose()
	end
end

return MonsterEffect
