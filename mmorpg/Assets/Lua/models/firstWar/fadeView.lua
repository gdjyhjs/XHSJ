--[[--
-- 渐变
-- @Author:Seven
-- @DateTime:2017-08-16 22:09:26
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FadeView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "fade_view.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

--[[
fade_in_time:淡入时间
fade_out_time：淡出时间
stop_time：停留时间
]]
function FadeView:set_time( fade_in_time, fade_out_time, stop_time )
	self.fade_in_time = fade_in_time
	self.fade_out_time = fade_out_time
	self.stop_time = stop_time
	
	self.speed_in = 1/fade_in_time
	self.speed_out = 1/fade_out_time
	if self.fade_in_time == 0 then
		self.color.a = 1
	else
		self.color.a = 0
	end
	self.image.color = self.color
	self:show()
end

-- 资源加载完成
function FadeView:on_asset_load(key,asset)
	self:hide()
	self.image = self.refer:Get(1)
	self.color = self.image.color
	self.fade_in_time = 0
	self.fade_out_time = 0
	self.stop_time = 0

	gf_register_update(self)
end

function FadeView:on_update( dt )
	if self.fade_in_time > 0 then
		self.fade_in_time = self.fade_in_time - dt
		self.color.a = self.color.a + self.speed_in*dt
		self.image.color = self.color
	elseif self.stop_time > 0 then
		self.stop_time = self.stop_time - dt

	elseif self.fade_out_time > 0 then
		self.fade_out_time = self.fade_out_time - dt
		self.color.a = self.color.a - self.speed_out*dt
		self.image.color = self.color

		if self.fade_out_time <= 0 then
			self:hide()
		end
	else
		if self:is_visible() then
			self:hide()
		end
	end
end

-- 释放资源
function FadeView:dispose()
	gf_remove_update(self)
    self._base.dispose(self)
end

return FadeView