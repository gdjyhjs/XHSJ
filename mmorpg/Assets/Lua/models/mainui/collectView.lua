--[[--
-- 采集进度条（或者传送）
-- @Author:Seven
-- @DateTime:2017-07-25 20:00:13
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local CollectView=class(UIBase,function(self,item_obj, is_transmit)
	self:reset()
    UIBase._ctor(self, "collect.u3d", item_obj) -- 资源名字全部是小写
end)

function CollectView:reset()
	if self.cancel_cb then
		self.cancel_cb()
		self.cancel_cb = nil
	end
	self.is_transmit = is_transmit or false
	self.time = 1
	self.total_time = 1
	self.is_can_cancel = false -- 是否可中断
end

-- 设置完成回调函数
function CollectView:set_finish_cb( cb )
	self.finish_cb = cb
end

-- 设置进度条时间(s)
function CollectView:set_time( time )
	self.time = time
	self.total_time = time
end

-- 设置为传送阵
function CollectView:set_is_transmit(is_transmit)
	self.is_transmit = is_transmit==nil and true or is_transmit
	if self.is_init then
		self.transmit:SetActive(self.is_transmit)
	end
end

-- 设置采集物品图标
function CollectView:set_icon( item_id )
	gf_set_item(item_id, self.icon)
end

function CollectView:set_icon2( name )
	self.tmp_icon_name = name
	if self.is_init then
		gf_setImageTexture(self.icon, name)
	end
end

-- 设置名字
function CollectView:set_name( name )
	self.tmp_name = name
	if self.is_init then
		self.name.text = name
	end

end

-- 设置是否可以中断
function CollectView:set_cancel( cancel )
	self.is_can_cancel = cancel
end

function CollectView:set_cancel_cb( cb )
	self.cancel_cb = cb
end

-- 资源加载完成
function CollectView:on_asset_load(key,asset)
	self.is_init = true
	self:init_ui()
end

function CollectView:init_ui()
	if not self.is_init then
		return
	end
	print("采集进度条（或者传送）ui加载ok")
	self.fill = self.refer:Get("fill")
	self.fill_hl = self.refer:Get("fill_hl")

	self.icon = self.refer:Get("icon")
	self.name = self.refer:Get("name")

	self.transmit = self.refer:Get("transmit")
	self.transmit:SetActive(self.is_transmit)
	self:set_name(self.tmp_name)
	self:set_icon2(self.tmp_icon_name)
end

function CollectView:on_update(dt)
	if not self.is_init then
		return
	end
	if self.time <= 0 or not self.is_init then
		return
	end

	if self.time > 0 then
		self.time = self.time - dt
		if self.time <= 0 then
			self.cancel_cb = nil
			if self.finish_cb then
				self.finish_cb()
				self.cancel_cb = nil
			end
			self:dispose()
			return
		end
	end
	local pro = self.time/self.total_time
	self.fill.fillAmount = 1 - pro

	if self.fill.fillAmount >= 1 then
		self.fill_hl:SetActive(false)
	else
		Seven.PublicFun.SetEulerAngles(self.fill_hl, 0, 0, 360*pro)
	end

end

function CollectView:on_receive( msg, id1, id2, sid )
	if self.is_can_cancel then
		if id1 == ClientProto.JoystickStartMove or 
		   id1 == ClientProto.MouseClick        or
		   id1 == ClientProto.PlayerSelAttack	or
		   id1 == ClientProto.PlayerAutoMove    then -- 被攻击
			if self.cancel_cb then
				self.cancel_cb()
				self.cancel_cb = nil
			end
			self:dispose()
		elseif id1 == ClientProto.ShowMainUIAutoAtk then
			if not msg.visible then
				if self.cancel_cb then
					self.cancel_cb()
					self.cancel_cb = nil
				end
				self:dispose()
			end
		end
	end
end

function CollectView:on_click( obj, arg )
	
end

function CollectView:register()
	if not self.is_register then
		self.is_register = true
		StateManager:register_view(self)
		gf_register_update(self)
	end
end

function CollectView:cancel_register()
	if self.is_register then
		self.is_register = nil
		StateManager:remove_register_view(self)
		gf_remove_update(self)
	end
end

function CollectView:on_showed()
	self:register()
end

function CollectView:on_hided()
	self:cancel_register()
end

-- 释放资源
function CollectView:dispose()
	if self.cancel_cb then
		self.cancel_cb()
		self.cancel_cb = nil
	end
	self.item_obj.collect = nil
	self.is_init = nil
	self:cancel_register()
    self._base.dispose(self)
end

return CollectView