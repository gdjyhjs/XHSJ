--[[--
-- 坐骑类
-- @Author:Seven
-- @DateTime:2017-04-20 09:47:06
--]]
local SpriteBase = require("common.spriteBase")

local Horse = class(SpriteBase, function(self, config_data, finish_cb)
	self.config_data = config_data
	self.is_horse = true
	
	SpriteBase._ctor(self, self.config_data.model_id..".u3d", finish_cb)
end)

function Horse:pre_init()
	self.speed = self.config_data.speed
	self.atk_range = self.config_data.atk_range
	self.mesh_enable = true
end

function Horse:init()
	LuaHelper.SetLayerToAllChild(self.transform, ClientEnum.Layer.CHARACTER)-- 不碰撞层
	Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）
	
	self.mesh = LuaHelper.GetComponentInChildren(self.root, "UnityEngine.SkinnedMeshRenderer")
	self.normal_move = self.root:AddComponent("Seven.Move.NormalMove")
	self.auto_move = self.root:AddComponent("Seven.Move.AutoMove")
	self.animator = LuaHelper.GetComponent(self.root, "UnityEngine.Animator") -- 动画控制器
	self.animator:SetBool("idle", true)

	self.attack_mgr = self.root:AddComponent("Seven.Attack.PlayerAttack")
	
	local player = LuaHelper.FindChild(self.root, "player")
	if not player then
		gf_message_tips(string.format("坐骑%d的动作文件没有加player节点！请去找动作！",self.config_data.model_id))
		print_error(string.format("坐骑%d的动作文件没有加player节点！请去找动作！",self.config_data.model_id))
		return
	end

	self.ride_transform = LuaHelper.FindChild(self.root, "player").transform -- 玩家坐上坐骑的节点
	
	self.head_node = LuaHelper.FindChild(self.root, "HP")
	
	self.auto_move.minDistance = self.atk_range
	self:set_speed(self.speed)
	-- self:enable_joystick(self.is_joystick)

	-- 鼠标点击特效
	self.mouse_effect = LuaItemManager:get_item_obejct("battle").pool:get_effect("41000003.u3d")
end

-- 设置移动速度
function Horse:set_speed( speed )
	if not self.is_init then
		return
	end
	self.normal_move.speed = speed
	self.auto_move.speed = speed
end

function Horse:set_atk_range( range )
	self.atk_range = range
	self.auto_move.minDistance = self.atk_range
end

function Horse:set_mesh_enable( enabled )
	self.mesh_enable = enabled
	if self.mesh then
		self.mesh.enabled = enabled
	end
	self:set_all_effect_visible(enabled)
end

function Horse:is_mesh_enable()
	return self.mesh_enable
end

-- 是否允许摇杆操作角色
function Horse:enable_joystick( enable )
	self.is_joystick = enable or false

	if self.is_init then
		self.normal_move:EnableJoysick(enable)
	end
end

-- 鼠标点击移动
function Horse:enable_touch_move( enable )
	if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
		return
	end
	if enable then
		self.auto_move.touchMoveFn = handler(self, self.on_touch_move)
		-- 延迟1秒设置
		local delay_fn = function()
			self.auto_move:EnableTouchMove(true)
		end
		delay(delay_fn, 1)
	else
		self.auto_move:EnableTouchMove(false)
	end
end

-- 是否真正移动
function Horse:is_move()
	if not self.is_init then
		return false
	end

	return self.normal_move:IsMove() or self.auto_move:IsAutoMove() or self.attack_mgr:IsMove()
end

function Horse:stop_move()
	self.auto_move:StopMove(true)
	self.normal_move:StopMove()
	self.normal_move:SetMoveForward(false)
end

function Horse:add_effect( effect, key )
	if not self.effect_list then
		self.effect_list = {}
	end
	self.effect_list[key] = effect
	if effect.transform then
		LuaHelper.SetLayerToAllChild(effect.transform, ClientEnum.Layer.CHARACTER)-- 不碰撞层
	end
end

function Horse:show_effect( key )
	if self.effect_list[key] then
		self.effect_list[key]:show_effect()
	end
end

function Horse:set_all_effect_visible( visible )
	for k,v in pairs(self.effect_list or {}) do
		if visible then
			v:show_effect()
		else
			v:hide()
		end
	end
end

-- 鼠标点击移动
function Horse:on_touch_move( point )
	print("鼠标点击",point)
	Net:receive(nil, ClientProto.MouseClick)
	if self.mouse_effect then
		self.mouse_effect:set_position(point)
		self.mouse_effect:show_effect()
	end
end

function Horse:faraway()
	Horse._base.faraway(self)
	self:stop_move()
end

function Horse:dispose()
	for k,v in pairs(self.effect_list or {}) do
		v:dispose()
	end
	self.effect_list = {}
	
	Horse._base.dispose(self)
end

function Horse:get_battle_flag()
	return self.battle_flag
end
return Horse