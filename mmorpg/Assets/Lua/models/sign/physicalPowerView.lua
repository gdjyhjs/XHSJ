--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-26 14:31:35
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local PhysicalPowerView=class(UIBase,function(self,item_obj)
	self.item_obj = item_obj
    UIBase._ctor(self, "welfare_weary_value.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function PhysicalPowerView:on_asset_load(key,asset)
	StateManager:register_view(self)
	self.lunch_rf = self.refer:Get(3)
	self.dinner_rf = self.refer:Get(4)
	self:update_view()
	local data = self.item_obj.free_strenght_tb
	self.refer:Get("txtTips").text = gf_localize_string("每天"..data[1].time[1]..":00-"..data[1].time[2]..":00 "..data[2].time[1]..":00-"..data[2].time[2]..":00可以吃大餐回复大量体力，错过也可以补领哦")
end

function PhysicalPowerView:update_view()
	local time = tonumber(os.date("%H",Net:get_server_time_s()))
	local data = self.item_obj.free_strenght_tb
	print("体力信息time",data[1].time[1],time)
	if	data[1].time[1]> time then
		self:prepare_power(self.lunch_rf)
		self:prepare_power(self.dinner_rf)
		self.refer:Get(1).gameObject:SetActive(true)
		self:updata_time(data)
		self.t = Schedule(handler(self, function()
			self:updata_time(data)
			if ts == 0 then
				self.refer:Get(1).gameObject:SetActive(false)
				self:updata_open_item(self.lunch_rf,data[1],1,false)
				self.item_obj:check_stength_award()		
				self.t:stop()
				self.t=nil
			end
		end), 1)
	elseif	data[1].time[1]<=time and data[1].time[2]>time then--午餐
		self:prepare_power(self.dinner_rf)
		self:updata_open_item(self.lunch_rf,data[1],1,false)
		if data[1].open then
			self:lunch_over(data)
		end
	elseif data[1].time[2]<=time and data[2].time[1]>time then
		self:updata_open_item(self.lunch_rf,data[1],1,true)
		self:prepare_power(self.dinner_rf)
		self.refer:Get(1).gameObject:SetActive(true)
		self.t = Schedule(handler(self, function()
			local ts = data[2].time[1]*3600-os.date("%H")*3600-os.date("%M")*60-os.date("%S")
			if not self.refer then 
				return 
			end 
			self.refer:Get(1).text = gf_localize_string("距离下一次大餐 ".. gf_convert_time(ts))
			if ts == 0 then
				self.refer:Get(1).gameObject:SetActive(false)
				self:updata_open_item(self.dinner_rf,data[2],2,false)
				self.item_obj:check_stength_award()
				self.t:stop()
				self.t=nil
			end
		end), 1)
		self:not_gold(1)
	elseif (data[2].time[1]<=time and data[2].time[2]>time) then--晚餐	
		self:updata_open_item(self.lunch_rf,data[1],1,true)
		self:updata_open_item(self.dinner_rf,data[2],2,false)
		self:not_gold(2)
	else
		self.refer:Get(1).gameObject:SetActive(false)
		self:updata_open_item(self.lunch_rf,data[1],1,true)
		self:updata_open_item(self.dinner_rf,data[2],2,true)
		self:not_gold(3)
	end
end

function PhysicalPowerView:updata_time(data)
	local ts = data[1].time[1]*3600-os.date("%H")*3600-os.date("%M")*60-os.date("%S")
	self.refer:Get(1).text = gf_localize_string("距离下一次大餐 ".. gf_convert_time(ts))
end

function PhysicalPowerView:updata_open_item(item,data,index,is_finish)
	if data.open ==1 then
		item:Get(2):SetActive(true)
		item:Get(3).gameObject:SetActive(true)
		item:Get(3).text = gf_localize_string("吃饱啦")
		item:Get(4).gameObject:SetActive(false)
	else
		item:Get(2):SetActive(false)
		item:Get(3).gameObject:SetActive(false)
		if is_finish then
			if index == 1 then
				item:Get(1).text = gf_localize_string("午餐补领")
			else
				item:Get(1).text = gf_localize_string("晚餐补领")
			end
			item:Get(4).text = data.needgold
			item:Get(4).gameObject:SetActive(true)
		else
			if index == 1 then
				item:Get(1).text = gf_localize_string("午餐领取")
			else
				item:Get(1).text = gf_localize_string("晚餐领取")
			end
			item:Get(1).gameObject:SetActive(true)
		end
	end
end

function PhysicalPowerView:prepare_power(item)
	item:Get(1).gameObject:SetActive(false)
	item:Get(3).gameObject:SetActive(true)
	item:Get(3).text =gf_localize_string("准备中")
end

function PhysicalPowerView:on_click(obj,arg)
	local  cmd = obj.name
	if cmd =="btnLunch" then
		self.select_item = arg
		self:down_get_award(1)
	elseif cmd =="btnDinner" then
		self.select_item = arg
		self:down_get_award(2)
	end
end
function PhysicalPowerView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("shop")) then
		if id2 == Net:get_id2("shop","GainFreeStrengthR") then --领取午餐晚餐
			if msg.err == 0 then
				self:update_view()
			end
		end
	end
end

function PhysicalPowerView:not_gold(tp)
	local data = self.item_obj.free_strenght_tb
	if tp == 1 and LuaItemManager:get_item_obejct("game"):get_gold() < data[1].needgold then --晚餐前
		if data[1].open == 0 then
			self.item_obj:player_no_gold()
		end
	elseif tp == 2 then --晚餐
		if data[2].open == 0 then
			return
		end
		if LuaItemManager:get_item_obejct("game"):get_gold() < data[1].needgold then 
			self.item_obj:player_no_gold()
		end
	else --晚餐后
		if LuaItemManager:get_item_obejct("game"):get_gold() < data[1].needgold then 
			self.item_obj:player_no_gold()
		end
	end
end

function PhysicalPowerView:down_get_award(num)
	local time = tonumber(os.date("%H",Net:get_server_time_s()))
	local data = self.item_obj.free_strenght_tb
	if	data[1].time[1]>time then
		gf_message_tips("准备中")
	elseif	data[1].time[1]<=time and data[1].time[2]>time then --午餐
		if num == 1 then
			if data[1].open == 0 then
				self.item_obj:gain_free_strength_c2s(0,num)
			else
				gf_message_tips("已领取")
			end
		else
			gf_message_tips("准备中")
		end
	elseif data[1].time[2]<=time and data[2].time[1]>time then --晚餐前
		if num == 1 then
			if data[1].open == 0 then
				self.item_obj:gain_free_strength_c2s(1,num)
			else
				gf_message_tips("已领取")
			end
		else
			gf_message_tips("准备中")
		end
	elseif (data[2].time[1]<=time and data[2].time[2]>time) then--晚餐
		if num == 1 then
			if data[1].open == 0 then
				self.item_obj:gain_free_strength_c2s(1,num)
			else
				gf_message_tips("已领取")
			end
		else
			if data[2].open == 0 then
				self.item_obj:gain_free_strength_c2s(0,num)
			else
				gf_message_tips("已领取")
			end
		end
	else
		if num == 1 then
			if data[1].open == 0 then
				self.item_obj:gain_free_strength_c2s(1,num)
			else
				gf_message_tips("已领取")
			end
		else
			if data[2].open == 0 then
				self.item_obj:gain_free_strength_c2s(1,num)
			else
				gf_message_tips("已领取")
			end
		end
	end	
end

function PhysicalPowerView:lunch_over(data)
	self.refer:Get(1).gameObject:SetActive(true)
		if self.t then return end
		self:update_lunch_time(data)
		self.t = Schedule(handler(self, function()
			self:update_lunch_time(data)
			if ts == 0 then
				self.refer:Get(1).gameObject:SetActive(false)
				self:updata_open_item(self.dinner_rf,data[2],2,false)
				self.item_obj:check_stength_award()
				self.t:stop()
				self.t=nil
			end
		end), 1)
end

function PhysicalPowerView:update_lunch_time(data)
	local ts = data[2].time[1]*3600-os.date("%H")*3600-os.date("%M")*60-os.date("%S")
	self.refer:Get(1).text = gf_localize_string("距离下一次大餐 ".. gf_convert_time(ts))
end

function PhysicalPowerView:on_hided()
	-- if self.t then
	-- 	self.t:stop()
	-- 	self.t = nil
	-- end
end


-- 释放资源
function PhysicalPowerView:dispose()
	if self.t then
		self.t:stop()
		self.t = nil
	end
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return PhysicalPowerView

