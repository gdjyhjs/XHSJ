--[[--
-- 传送点
-- @Author:Seven
-- @DateTime:2017-04-20 09:47:06
--]]

local SpriteBase = require("common.spriteBase")
local Transport = class(SpriteBase, function( self, config_data, ...)

    self.config_data = config_data
    self.map_id = config_data.map_id

	SpriteBase._ctor(self, self.config_data.model_id..".u3d", ...)
end)

function Transport:init()
	LuaHelper.SetLayerToAllChild(self.root.transform, ClientEnum.Layer.DEFAULT)

	local collider = self.root:AddComponent("UnityEngine.SphereCollider")
	collider.radius = 1
	collider.isTrigger = true

	self.collider_event = self.root:AddComponent("Seven.ColliderEvent")
	self.collider_event.onCollisionEnterFn = handler(self, self.on_transport)
	self.collider_event.onCollisionExitFn = handler(self, self.on_exit)

end

function Transport:set_guid( guid )
	self.guid = guid
end

function Transport:on_transport(collision)
	
	local item_obj = LuaItemManager:get_item_obejct("battle")
	print("传送阵",collision.tag,item_obj:get_character().can_transport)
	if collision.tag == "Player" and item_obj:get_character().can_transport  then
		print(">>>进入传送点", self.config_data.code,self.config_data.map_id)
		item_obj:transfer_map_c2s(
			self.map_id,
			self.config_data.pos[1],
			self.config_data.pos[2],
			nil,
			ServerEnum.TRANSFER_MAP_TYPE.TRANSPORT_POINT
		)
	end
end

function Transport:on_exit()
	LuaItemManager:get_item_obejct("battle"):get_character():set_can_transport(true)
end

function Transport:dispose()
	StateManager:remove_register_view( self )
	Transport._base.dispose(self)
end

return Transport