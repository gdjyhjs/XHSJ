--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-16 10:09:12
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FingerGuide=class(UIBase,function(self,item_obj)
	StateManager:input_disable()
    UIBase._ctor(self, "first_war_guide.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function FingerGuide:on_asset_load(key,asset)

end

-- 释放资源
function FingerGuide:dispose()
	StateManager:input_enable()
    self._base.dispose(self)
end

return FingerGuide

