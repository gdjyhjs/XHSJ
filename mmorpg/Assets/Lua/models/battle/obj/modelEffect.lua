--[[--
-- 技能特效
-- @Author:Seven
-- @DateTime:2017-10-10 09:37:37
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

local ModelEffect = class(function( self, skill_id, ower )
	self.ower = ower
	self.skill_id = skill_id

	self:init()
end)

function ModelEffect:init()
	self.config_data = ConfigMgr:get_config("skill_res")[self.skill_id]
	self.is_player_normal = (self.ower.config_data.career ~= nil and self.config_data ~= nil) -- 是角色普攻技能

	if not self.config_data then
		-- 角色技能去掉后面3位
		self.config_data = ConfigMgr:get_config("skill_res")[math.floor(self.skill_id*0.001)]
		if not self.config_data then
			return
		end
	end

	self:init_self_effect()
	self:init_target_effect()
	self:init_fly_effect()
	self:init_hit_effect()
	self:init_skeleton_effect()
	self:init_forward_effect()
	self:init_warning_effect()
end

-- 初始化在身上的特效
function ModelEffect:init_self_effect()
	if not self.config_data.self_effect then
		return
	end

	local function cb( effect )
		local parent
		if self.is_player_normal or self:is_follow() then
			parent = self.ower.transform
		else
			parent = EffectTransform
		end
		effect:set_parent(parent)
		effect.transform.localPosition = Vector3(0,0,0)
		effect.transform.localRotation = Vector3(0,0,0)
		effect.transform.localScale = Vector3(1,1,1)
		effect:set_eulerAngles(self.ower.transform.eulerAngles)
	end
	self.self_effect = Effect(self.config_data.self_effect..".u3d", cb)
	print("init_self_effect",self.config_data.self_effect)
end

-- 初始目标身上特效
function ModelEffect:init_target_effect()
	if not self.config_data.target_effect then
		return
	end
	local function cb( effect )
		effect:set_parent(EffectTransform)
		effect.transform.localPosition = Vector3(0,0,0)
		effect.transform.localRotation = Vector3(0,0,0)
		effect.transform.localScale = Vector3(1,1,1)
	end
	self.target_effect = Effect(self.config_data.target_effect..".u3d", cb)
end

-- 初始飞行道具
function ModelEffect:init_fly_effect()
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
function ModelEffect:init_hit_effect()
	if not self.config_data.hit_effect then
		return
	end
	local function cb( effect )
		effect:set_parent(EffectTransform)
		effect.transform.localPosition = Vector3(0,0,0)
		effect.transform.localRotation = Vector3(0,0,0)
		effect.transform.localScale = Vector3(1,1,1)
	end
	self.hit_effect = Effect(self.config_data.hit_effect..".u3d", cb)
end

-- 初始骨骼特效
__gf_model_effect_l = {}
function ModelEffect:init_skeleton_effect()
	self.skeleton_list = {}

	local function cb( effect, parent )
		effect:set_parent(parent)
		effect.transform.localScale = Vector3(1,1,1)
		effect.transform.localPosition = Vector3(0,0,0)
		effect:set_eulerAngles(self.ower.transform.eulerAngles)
	end

	for i,v in ipairs(self.config_data.skeleton_effect_list or {}) do
		local parent = LuaHelper.FindChild(self.ower.root, self.config_data.skeleton_name_list[i])
		if not parent then
			gf_error_tips(string.format("找不到骨骼:%s,%s",self.config_data.skeleton_name_list[i],self.ower.url))
		else
			local url = v..".u3d"
			if __gf_model_effect_l[self.ower] and __gf_model_effect_l[self.ower][url] then
				self.skeleton_list[i] = __gf_model_effect_l[self.ower][url]
			else
				local effect = Effect(url, cb, parent.transform)
				self.skeleton_list[i] = effect
				if not __gf_model_effect_l[self.ower] then
					__gf_model_effect_l[self.ower] = {}
				end
				__gf_model_effect_l[self.ower][url] = effect
			end
		end
	end
end

-- 初始化冲锋特效
function ModelEffect:init_forward_effect()
	if self.config_data.forward_effect then -- 冲锋特效
		local skill_data = ConfigMgr:get_config("skill")[self.skill_id]
		self.forward_speed = self.config_data.move_speed
		self.forward_dis = skill_data.cast_distance*0.1 -- 开始冲锋距离

		local cb = function( effect )
			effect:set_parent(self.ower.transform)
			effect.transform.localPosition = Vector3(0,0,0)
			effect.transform.localScale = Vector3(1,1,1)
			effect:set_eulerAngles(self.ower.transform.eulerAngles)
		end
		self.forward_effect =  Effect(self.config_data.forward_effect..".u3d", cb)
	end
end

-- 初始化预警特效
function ModelEffect:init_warning_effect()
	if not self.config_data.warning_effect then
		return
	end
	local skill_data = ConfigMgr:get_config("skill")[self.skill_id]
	local scale = skill_data.range*0.1*self.config_data.warning_unit_per+1 -- 加多1米，避免玩家走出这个范围还会受到伤害
	local cb = function( effect )
		effect:set_parent(self.ower.transform)
		effect.transform.localPosition = Vector3(0,0,0)
		effect.transform.localScale = Vector3(1,1,1)
		effect:set_eulerAngles(self.ower.transform.eulerAngles)

		effect.transform.localScale = Vector3(scale, scale, scale)
	end
	self.warning_effect =  Effect(self.config_data.warning_effect..".u3d", cb)
end

-- 显示目标身上的特效
function ModelEffect:show_target_effect(pos)
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
function ModelEffect:show_effect(cmd)
	if self.self_effect then
		local pos = self.ower.transform.position
		self.self_effect:show_effect(pos, self.ower.transform.eulerAngles)
	end

	-- 立即播放目标身上播放特效
	if not self.fly_effect then
		self:show_target_effect()
		self:show_hit_effect()
	end

	-- 显示骨骼特效
	for i,v in ipairs(self.skeleton_list or {}) do
		v:show_effect()
	end

	-- 预警特效
	if self.warning_effect then
		self.warning_effect:show_effect()
	end

	if cmd ~= "forward" then
		self:stop_forward()
	end
end

function ModelEffect:show_fly_effect()
	-- 播放飞行特效
	if not self.fly_effect then
		return
	end

	local cb = function( effect )
		self:show_target_effect(effect.transform.position)
		self:show_hit_effect()
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

	if self.ower.target and not self.ower.target.dead then
		self.fly_effect:fly(self.ower.target)
		self.fly_effect:set_arrive_cb(cb)
	else
		-- 没有目标，向前飞行技能攻击距离

		if not self.fly_dis then
			self.fly_dis = ConfigMgr:get_config("skill")[self.skill_id].cast_distance*0.1
		end
		local tpos = Seven.PublicFun.TransformDirection(self.ower.transform, Vector3(0,0,self.fly_dis))
		tpos.y = pos.y+1
		self.fly_effect:move_to(tpos)
	end
end

function ModelEffect:show_hit_effect()
	if self.hit_effect and self.ower.target and not Seven.PublicFun.IsNull(self.ower.target.transform) then -- 显示受击特效
		local pos = self.ower.target.transform.position
		pos.y = pos.y+self.ower.target.model_height*(self.config_data.hit_height or 0.5)
		self.hit_effect:show_effect(pos)
	end
end

-- 显示受击特效，服务器下发伤害的时候
function ModelEffect:show_hit_effect_s2c( target_list )
	if not target_list or not self.config_data.hit_effect then
		return
	end

	local battle = LuaItemManager:get_item_obejct("battle")

	local finish_cb = function( effect, pos )
		effect:show_effect(pos)
	end

	local end_cb = function(effect)
		battle.pool:add_effect(effect)
	end

	for k,v in pairs(target_list) do
		local target = battle:get_model(v.guid)
		if target then
			local pos = target:get_position()
			pos.y = pos.y + target.model_height*(self.config_data.hit_height or 0.5)
			local e = battle.pool:get_effect(self.config_data.hit_effect..".u3d", finish_cb, pos)
			e:set_finish_cb(end_cb)
		end
	end
end

-- 飞行道具击中回调
function ModelEffect:set_fly_end_cb( cb )
	self.fly_end_cb = cb
end

-- 获取动作攻击百分比
function ModelEffect:get_atk_percent()
	if self.config_data and self.config_data.action_per then
		return self.config_data.action_per*0.01
	end
	return 0.5
end

-- 是否有飞行道具
function ModelEffect:is_have_fly()
	return self.fly_effect ~= nil
end

-- 重设技能延时时间
function ModelEffect:reset_delay_time( dtime )
	if self.self_effect then
		self.self_effect:reset_delay_time(dtime)
	end
end

-- 是否可以跟随移动
function ModelEffect:is_follow()
	if self.config_data.follow and self.config_data.follow == 1 then
		return true
	end
	return false
end

-- 是否有冲锋技能
function ModelEffect:is_forward()
	return self.forward_effect ~= nil and not self.ower:check_in_atk_range(self.ower.target, 9)
end

-- 显示冲锋特效
function ModelEffect:show_forward()
	if not self.ower:check_in_atk_range(self.ower.target, self.forward_dis^2) then -- 没在冲锋距离，先移动到冲锋距离
		self.ower.is_move_to_target = self.ower:move_to2(self.ower.target.transform,handler(self, self.show_forward_effect),self.forward_dis)
	else
		self:show_forward_effect()
	end
end

function ModelEffect:show_forward_effect()
	self.ower.normal_move.speed = self.forward_speed
	local dis = (self.ower.target.config_data.vluame_r or 0)*0.1+3
	self.ower.is_move_to_target = self.ower:move_to2(self.ower.target.transform, handler(self, self.forward_arrive_cb), dis, "forward")
	self.forward_effect:show_effect()

	local dis = Vector3.Distance(self.ower.transform.position, self.ower.target.transform.position)
	delay(handler(self, self.forward_arrive_cb), dis/self.forward_speed)
end

function ModelEffect:forward_arrive_cb()
	print("冲锋特效完成")
	self.forward_effect:hide()
	self.ower.normal_move.speed = self.ower.speed
	self.ower:arrive_destination_callback()
	if self.ower.animator:GetCurrentAnimatorStateInfo (1):IsName ("forward") then
		self.ower.animator:Play("skill1", 1)
	end
end

function ModelEffect:stop_forward()
	if not self.forward_effect then
		return
	end
	self.ower.is_move_to_target = false
	self.ower.normal_move.speed = self.ower.speed
	self.forward_effect:hide()
end

function ModelEffect:hide()
	if self.self_effect then
		self.self_effect:hide()
	end

	if self.target_effect then
		self.target_effect:hide()
	end

	if self.fly_effect then
		self.fly_effect:hide()
	end

	if self.forward_effect then
		self.forward_effect:hide()
	end

	for i,v in ipairs(self.skeleton_list or {}) do
		v:hide()
	end
end

function ModelEffect:dispose()
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
	__gf_model_effect_l[self.ower] = {}
end

return ModelEffect
