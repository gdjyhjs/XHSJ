--[[--
-- 等待遮挡界面
-- @Author:Seven
-- @DateTime:2017-06-22 20:34:09
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MaskView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "loading_mask.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function MaskView:on_asset_load(key,asset)
	self:hide()
end

function MaskView:on_showed()
	local delay_fn = function()
		self:hide()
		self.item_obj:time_out()
	end
	self.delay = PLua.Delay(delay_fn, 10)
end

function MaskView:on_hided()
	if self.delay then
		PLua.StopDelay(self.dlay)
		self.delay = nil
	end
end

-- 释放资源
function MaskView:dispose()
    self._base.dispose(self)
 end

return MaskView

