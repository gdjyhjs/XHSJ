--[[--特效红点提醒
--	
-- @Author: xin
-- @DateTime:2017-8-26
--]]
local Vector3 = UnityEngine.Vector3
local effectRedPoint = class(function ( self  )
	self:init()
end)

function effectRedPoint:init()
end

function effectRedPoint:update_all_effect()
	 for k,v in pairs(self.effect_list or {}) do
 		   gf_update_mainui_effect(k) 
	 end
end

function effectRedPoint:register(effect_list)
	   -- self.effect_list = effect_list
end

function effectRedPoint:update_effect_node(msg)
    gf_print_table(msg,"update red point :")
    --圆圈特效红点
    local node = self.effect_list[msg.type]
   	if msg.visible then
      if node.transform:FindChild("effect") then
          return
      end
   		local effect_cb = function( effect )
            effect.root.name = "effect"
            effect:set_parent(node.transform)
            effect.root.transform.localPosition = Vector3(0, 0, 0)
            effect.root.transform.localScale = Vector3(1, 1, 1) 
            -- LuaHelper.SetCameraOnlyRenderLayer(effect.transform:FindChild("UIEffectCamera"):GetComponentInChildren("UnityEngine.Camera"), ClientEnum.Layer.UI)
            effect:show()
        end
        local Effect = require("common.effect")
        Effect("41000047.u3d", effect_cb)
        return
   	end
   	--删除特效
   	if node.transform:FindChild("effect") then
   		 LuaHelper.Destroy(node.transform:FindChild("effect").gameObject)
   	end
end

return effectRedPoint