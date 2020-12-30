--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-24 10:19:46
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local DoubleHitTime = 4 -- 连击时间
local Mainui_combo=class(UIBase,function(self,item_obj)
	self.atk_count = 1 -- 连击数量
	self.atk_time  = 0 -- 连击时间
    UIBase._ctor(self, "mainui_combo.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function Mainui_combo:on_asset_load(key,asset)
	self:hide()
	self.cd_hide = false
	self:set_always_receive(true)
	self.tween = self.refer:Get("tween") 
	self.combo_text = self.refer:Get("Text")
	self.hide_img1 =  self.refer:Get(2)
	self.hide_img2 =  self.refer:Get(3)
	self.hide_img3 =  self.refer:Get(4)
	self.cur_a = 1
end

function Mainui_combo:show_combo()
	-- self.tween:Play()
	self.tween.enabled = true
	self.cd_hide = false
	if not self.countdown then
		self.countdown = Schedule(handler(self, function()
					self.tween.enabled =false
					self.tween.transform.localScale = Vector3(1,1,1)
					self.cd_hide = true
					self.countdown:stop()
					self.countdown = nil
					end), 0.15)
	end
end

function Mainui_combo:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.ComboText then
		-- self:combo_next_text()
	elseif id1 == ClientProto.PlayNormalAtk then -- 普通攻击
		print("连击啊")
		-- self:combo_next_text()
	end
end

function Mainui_combo:combo_next_text()
	local now_time = Net:get_server_time_s()
	-- print("连击",self.atk_time)
	self.atk_count = self.atk_count + 1
	if (self.atk_time-now_time) <= 0 then
		self.atk_count = 1
	else
		self.cur_a = 1
		self:hide_combo()
		self:show()
		if self.atk_count>999 then
			self.atk_count = 999
		end
		self.combo_text.text = self.atk_count
		self:show_combo()
	end

	self.atk_time = now_time + DoubleHitTime
	-- print("连击",self.atk_count,self.atk_time)
end

function Mainui_combo:update_combo( dt )
	local now_time = Net:get_server_time_s()
	if  self.atk_time>0 and (self.atk_time-now_time) <= 1 then
		self:hide_combo(dt)
	end
	if  self.atk_time>0 and (self.atk_time-now_time) <= 0 then
		if self.cd_hide and self.cur_a<=0 then 
			self:hide()
			self.cd_hide = false
		end
	end
end

function Mainui_combo:hide_combo(dt)
	if not self.cur_a then return end 
	if dt then
		self.cur_a = self.cur_a - dt
	end
	self.hide_img1.color = UnityEngine.Color(1,1,1,self.cur_a)
	self.hide_img2.color = UnityEngine.Color(1,1,1,self.cur_a)
	self.hide_img3.color = UnityEngine.Color(1,1,1,self.cur_a)
end


function Mainui_combo:on_showed()
	if	self.ud_combo == nil then
		self.ud_combo = Schedule(handler(self,self.update_combo),0.05)
	end
end
function Mainui_combo:on_hided()
	if	self.ud_combo then
		self.ud_combo:stop()
		self.ud_combo=nil
	end
end
-- 释放资源
function Mainui_combo:dispose()
	if	self.ud_combo then
		self.ud_combo:stop()
		self.ud_combo=nil
	end
    self._base.dispose(self)
 end

return Mainui_combo

