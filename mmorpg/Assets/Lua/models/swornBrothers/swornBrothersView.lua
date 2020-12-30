--[[--
--
-- @Author:huangjunshan
-- @DateTime:2017-08-17 20:43:17
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SwornBrothersView=class(Asset,function(self,item_obj)
	self:set_bg_visible( true )
    Asset._ctor(self, "sworn_brothers.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function SwornBrothersView:on_asset_load(key,asset)
	

end

function SwornBrothersView:on_showed()
end

-- 释放资源
function SwornBrothersView:dispose()
    self._base.dispose(self)
 end

return SwornBrothersView

