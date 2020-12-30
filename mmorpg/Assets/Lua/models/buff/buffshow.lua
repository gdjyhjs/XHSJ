--[[--
--
-- @Author:Seven
-- @DateTime:2017-12-07 15:14:54
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Buffshow=class(UIBase,function(self)
	self.item_obj = LuaItemManager:get_item_obejct("buff")
    UIBase._ctor(self, "buff_state.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Buffshow:on_asset_load(key,asset)
	self.buff_time =0
	self.buff_cur_time = 0
	self.buff_bg = self.refer:Get("buff_bg")
	self.buff_state = self.refer:Get("buff_state")
	local tb = ConfigMgr:get_config("buff_show")[self.item_obj.buff_show_data.show_type]
	self:update_buff(tb.icon,self.item_obj.buff_show_data.cur_duration+Net:get_server_time_s()*10,self.item_obj.buff_show_data.duration/1000)
	self.t = Schedule(handler(self,self.countdown),0.05)
end

function Buffshow:update_buff(name,cur_time,time)
	print("buff1112啊A"..time)
	self.buff_time = tonumber(time)*10
	self.buff_cur_time = tonumber(cur_time)
	gf_setImageTexture(self.buff_state,name)
	local nowtime =  Net:get_server_time_s()*10--*1000
	local s = self.buff_cur_time-nowtime
	local x = s/self.buff_time
	print("buff1112啊1T"..s)
	print("buff1112啊2T"..self.buff_cur_time)
	print("buff1112啊3T"..nowtime )
	if self.buff_state then
		self.buff_state.fillAmount = x
	end
	gf_setImageTexture(self.buff_bg,name.."_bg")
end

function Buffshow:countdown()
	local nowtime =  Net:get_server_time_s()*10--*1000
	local s = self.buff_cur_time-nowtime
	if s<0 then
		self:dispose()
		return
	end
	local x = s/self.buff_time
	self.buff_state.fillAmount = x
end

-- 释放资源
function Buffshow:dispose()
	if self.t then
		self.t:stop()
		self.t = nil
	end
	self.item_obj.buff_show = nil
    self._base.dispose(self)
 end

return Buffshow

