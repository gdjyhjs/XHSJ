--[[--
-- buffer
-- @Author:Seven
-- @DateTime:2017-06-12 20:17:56
--]]

local SpriteBase = require("common.spriteBase")

local Buffer = class(SpriteBase, function( self, config_data, caster_id, owner_id, cb  )

	self.config_data = config_data -- buffer配置表数据
	self.caster_id = caster_id -- 释放者guid
	self.owner_id = owner_id -- 承受着guid
	self.cb = cb

	self.battle_item = LuaItemManager:get_item_obejct("battle")

	local obj = self.battle_item:get_model(self.owner_id)
	local show_buffer = false -- 是否需要显示特效
	if obj then
		show_buffer = obj:is_mesh_enable()
	end
	
	if show_buffer and self.config_data.model and self.config_data.model > 0 then
		SpriteBase._ctor(self, self.config_data.model..".u3d")
	else
		self:init()
	end

end)

function Buffer:get_guid()
	return self.guid
end

function Buffer:set_guid( guid )
	self.guid = guid
end

function Buffer:init()
	self:analyzing_buffer(self.config_data.state_effect[1])
	if self.cb then
		self.cb(self)
	end
end

-- 解析buffer
function Buffer:analyzing_buffer( data )
	local buffer_effect_type = data[1]
	
	local target = self.battle_item:get_model(self.owner_id)
	local status = data[2]
	local y = 0
	if target then
		y = target.model_height*(self.config_data.effect_pos or 100)*0.01
	end
	local pos = Vector3(0,y,0)
	print("buff 攻击目标",target, self.owner_id, self.config_data.model,status)
	if buffer_effect_type == ServerEnum.BUFF_EFFECT_TYPE.DOT_DAMAGE then -- 持续伤害

	elseif buffer_effect_type == ServerEnum.BUFF_EFFECT_TYPE.ADD_STATE then -- 附加状态（如冰冻，沉默，定身）

		if not target then
			return
		end
		
		if self:bit_combat_state(status, ServerEnum.COMBAT_STATE.SILENCE) then -- 沉默(可以使用普通攻击)
			if self.battle_item:get_character():get_guid() == self.owner_id then
				LuaItemManager:get_item_obejct("skill"):set_can_use(false) -- 设置不可以使用技能
			end
			-- pos = target.head_node.transform.localPosition
			print("buff 沉默")
		end

		if self:bit_combat_state(status, ServerEnum.COMBAT_STATE.IMMOBILIZE) then -- 定身(可以使用普通攻击)
			if self.battle_item:get_character():get_guid() == self.owner_id then
				LuaItemManager:get_item_obejct("skill"):set_can_use(false) -- 设置不可以使用技能
			end
			target:set_can_not_move(true)
			print("buff 定身")
		end

		if self:bit_combat_state(status, ServerEnum.COMBAT_STATE.DIZZY) then -- 眩晕(冰冻)不可以进行任何战斗操作
			if self.battle_item:get_character():get_guid() == self.owner_id then
				LuaItemManager:get_item_obejct("skill"):set_can_use(false) -- 设置不可以使用技能
			end
			target:set_can_not_move(true)
			target:set_dizzy(true)
			-- pos = target.head_node.transform.localPosition
			print("buff 眩晕")
		end

	end
	
	if target and self.root then
		target:set_buffer(self)
		self:set_parent(target.transform)
		self.transform.localPosition = pos
	end

	self.status = status
end

function Buffer:bit_combat_state( value, ty )
	return bit.band(value, ty) > 0
end

function Buffer:clear(force)
	if self.status then
		if self:bit_combat_state(self.status, ServerEnum.COMBAT_STATE.SILENCE) or
		   self:bit_combat_state(self.status, ServerEnum.COMBAT_STATE.IMMOBILIZE) or
		   self:bit_combat_state(self.status, ServerEnum.COMBAT_STATE.DIZZY) then
		   local char = self.battle_item:get_character()
		   if char or force then
				if (char ~= nil and char:get_guid() == self.owner_id) or force then
					LuaItemManager:get_item_obejct("skill"):set_can_use(true) -- 设置可以使用技能
				end
			end
		end
	end

	local target = self.battle_item:get_model(self.owner_id)
	if target then
		target:set_can_not_move(false)
		target:set_dizzy(false)
	end
end

function Buffer:dispose()
	self:clear(true)
	Buffer._base.dispose(self)
end

return Buffer
