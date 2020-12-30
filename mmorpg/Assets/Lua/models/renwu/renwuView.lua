--[[--
--
-- @Author:Seven
-- @DateTime:2017-05-12 10:48:42
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local RenwuView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "renwu.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function RenwuView:on_asset_load(key,asset)
	print(2)
end

-- 释放资源
function RenwuView:dispose()
    self._base.dispose(self)
 end

return RenwuView

