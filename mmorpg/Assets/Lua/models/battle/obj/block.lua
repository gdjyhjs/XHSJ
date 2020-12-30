--[[--
-- 地图上的阻挡
-- @Author:Seven
-- @DateTime:2017-04-20 09:47:06
--]]
local SpriteBase = require("common.spriteBase")
local Effect = require("common.effect")

local Block = class(SpriteBase, function(self, config_data, ...)
    self.config_data = config_data
	SpriteBase._ctor(self, "block_cube.u3d", ...)
end)

function Block:init()
	self.root.tag = "Block"

	self.collider = LuaHelper.GetComponent(self.root, "UnityEngine.BoxCollider")

	self.collider_event = self.root:AddComponent("Seven.ColliderEvent")
	-- self.collider_event.onCollisionEnterFn = handler(self, self.on_collider)

	-- 添加特效
	self:init_effet()

	-- StateManager:register_view(self)
end

function Block:init_effet()
	local cb = function( e )
		e:set_position(self.config_data.position)
		e:set_parent(LuaHelper.Find("Effect").transform)
		e:set_eulerAngles(self.config_data.dir)
		e:show_effect()
	end
	self.effect = Effect(self.config_data.model_id..".u3d", cb)
end

function Block:set_guid( guid )
	self.guid = guid
end

function Block:set_trigger( trigger )
	self.collider.isTrigger = trigger
end

function Block:on_receive( msg, id1, id2, id3 )
	
end

function Block:dispose()
	-- StateManager:remove_register_view(self)
	self.effect:dispose()	
	Block._base.dispose(self)
end

return Block