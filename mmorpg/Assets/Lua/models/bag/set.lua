--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-26 17:04:48
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Set=class(UIBase,function(self,item_obj,ui)
    UIBase._ctor(self, "bag_set.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    self.ui = ui
end)

-- 资源加载完成
function Set:on_asset_load(key,asset)

end

-- 释放资源
function Set:dispose()
    self._base.dispose(self)
 end

return Set

