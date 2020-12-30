--[[--
-- 成就
-- @Author:xcb
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper

local Offline = LuaItemManager:get_item_obejct("offline")
Offline.priority = -1
--UI资源
Offline.assets=
{
    View("offlineView", Offline) 
}

function Offline:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("base") then
        if id2 == Net:get_id2("base", "GetOfflineExpInfoR") then
        	gf_print_table(msg,"wtf receive GetOfflineExpInfoR")
        	print("GetOfflineExpInfoR",msg.maxOfflineMin,msg.totalOfflineMin)
		   	self.can_use_offline_times = msg.maxOfflineMin
			self.cur_use_offline_times = msg.totalOfflineMin
		elseif id2 == Net:get_id2("base", "GetOfflineExpRewardR") then
			print("GetOfflineExpRewardR")
			if msg.err == 0 then
				local exp_per_min = 0
				local play_lv = LuaItemManager:get_item_obejct("game"):getLevel()
				if ConfigMgr:get_config("offline_exp")[play_lv] ~= nil then
					exp_per_min = ConfigMgr:get_config("offline_exp")[play_lv].exp_per_min
				end
				local exp = self.cur_use_offline_times * ( exp_per_min + math.floor(LuaItemManager:get_item_obejct("game"):getPower()/ConfigMgr:get_config("t_misc").offline.power_to_exp_coef))
				local str
				if 10000 < exp then
					str = string.format("%.2f万",exp / 10000)
				else
					str = tostring(exp)
				end
				str = string.format(gf_localize_string("获得%s经验"),str)
				gf_message_tips(str)
				self.can_use_offline_times = self.can_use_offline_times - self.cur_use_offline_times
				self.cur_use_offline_times = 0
			end
		elseif id2 == Net:get_id2("base","UpdateOfflineExpMaxTimeR") then
			self.can_use_offline_times = msg.maxOfflineMin
        end
    end
end

function Offline:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end
--初始化函数只会调用一次
function Offline:initialize()
	self.can_use_offline_times = 0
	self.cur_use_offline_times = 0
	self.cur_ui = nil
	self.ui_queue = {}
	self.ui_priority = {
	announcement = 1,
	offline = 999,
}
end

function Offline:get_time_str(times)
	if 60 < times then
		if times%60 == 0 then
			return string.format(gf_localize_string("%d小时"),math.floor(times/60))
		else 
			return string.format(gf_localize_string("%d小时%d分"),math.floor(times/60),times%60)
		end
	else
		return string.format(gf_localize_string("%d分"),times)
	end
end

function Offline:have_offline_exp()
	local play_lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local exp = LuaItemManager:get_item_obejct("game"):get_exp()
	local data = ConfigMgr:get_config("player")
	if 0 < self.cur_use_offline_times and ( data[play_lv + 1] ~= nil or exp < data[play_lv].exp) then
		return true
	end
	return false
end

function Offline:get_offline_times()
	print("Offline:get_offline_times")
	Net:send({},"base","GetOfflineExpInfo")
end

function Offline:push_ui(id,cb)
	if self.cur_ui == nil then
		cb()
		self.cur_ui = id
	elseif self.cur_ui ~= id then
		local is_in_here = false
		for i,v in ipairs(self.ui_queue) do
			if v.id == id then
				is_in_here = true
				break
			end
		end
		if is_in_here == false then
			table.insert(self.ui_queue,{id = id,cb = cb})
		end
	end
end

function Offline:pop_ui(id)
	if self.cur_ui == id then
		if #self.ui_queue ~= 0 then
			self.cur_ui = self.ui_queue[1].id
			self.ui_queue[1].cb()
			table.remove(self.ui_queue,1)
		else
			self.cur_ui = nil
		end
	else		--被隐藏的情况下也要调用，强制从堆栈弹出
		for i,v in ipairs(self.ui_queue) do
			if v.id == id then
				table.remove(self.ui_queue,i)
				break
			end
		end
	end
end




