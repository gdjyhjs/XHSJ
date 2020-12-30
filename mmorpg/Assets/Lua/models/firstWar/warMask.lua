--[[--
-- 透明遮罩
-- @Author:Seven
-- @DateTime:2017-08-15 21:02:45
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local WarMask=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "war_mask.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function WarMask:on_asset_load(key,asset)

end

-- 释放资源
function WarMask:dispose()
    self._base.dispose(self)
end

return WarMask

