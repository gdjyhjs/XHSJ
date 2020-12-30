--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-04 09:57:45
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Collect=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "collect.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function Collect:on_asset_load(key,asset)
	self.collect_role = self.refer:Get("collect_role")
	self.img_collect = self.refer:Get("img_collect")
	self.refer:Get("txt_collect").text = "采集" .. ""
	self.role360 = 0
	self.run = true
	gf_register_update(self) --注册每帧事件
end

function Collect:on_update(dt)
	if self.run then
		self.collect_role.fillAmount = self.collect_role.fillAmount + dt*0.5
		self.role360 = self.role360 - dt*180
		self.img_collect.localRotation=Quaternion.Euler(0,0,self.role360)
		if self.role360  <= -360 then
			self.run = false
			self:finish_role()
		end
	end
end
--完成
function Collect:finish_role()
	print("采集完成")
	self:dispose()
end

-- 释放资源
function Collect:dispose()
	gf_remove_update(self)
    self._base.dispose(self)
 end

return Collect

