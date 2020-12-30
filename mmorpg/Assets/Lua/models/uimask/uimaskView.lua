--[[--
-- ui 底板
-- @Author:Seven
-- @DateTime:2017-08-09 18:15:09
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local UIMaskView=class(Asset,function(self,item_obj)
	self.retain_count = 0
    self.item_obj=item_obj
    Asset._ctor(self, "mainui_mask.u3d") -- 资源名字全部是小写
    self.level = UIMgr.LEVEL_STATIC
end)

-- 资源加载完成
function UIMaskView:on_asset_load(key,asset)
	self:hide()
end

function UIMaskView:show()
	if self.retain_count == 0 then
		UIMaskView._base.show(self)
	end
	self.retain_count = self.retain_count + 1
	print("show retain_count=",self.retain_count)
end

function UIMaskView:hide()
	self.retain_count = self.retain_count - 1
	if self.retain_count <= 0 then
		self.retain_count = 0
		UIMaskView._base.hide(self)
	end
	print("hide retain_count=",self.retain_count)
end

-- 释放资源
function UIMaskView:dispose()
    self._base.dispose(self)
end

return UIMaskView

