--[[--
--
-- @Author:huangjunshan-
-- @DateTime:2017-08-17 20:37:07
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MarriageView=class(Asset,function(self,item_obj)
	self:set_bg_visible( true )
    Asset._ctor(self, "marriage.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function MarriageView:on_asset_load(key,asset)
	

end

function MarriageView:on_showed()
end

-- 释放资源
function MarriageView:dispose()
    self._base.dispose(self)
 end

return MarriageView

