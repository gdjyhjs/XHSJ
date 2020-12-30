--[[--
-- 成就
-- @Author:xcb
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper

local Astrolabe = LuaItemManager:get_item_obejct("astrolabe")
--UI资源
Astrolabe.assets=
{
    View("astrolabeView", Astrolabe) 
}

function Astrolabe:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "AstrolabeRedPointR") then
			print("AstrolabeRedPointR")
			self.system_red = {}
			for i,v in ipairs(msg.list) do
				self.system_red[v] = true
			end
			local red_point = self:has_red()
			Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ASTROLABE, visible=red_point}, ClientProto.ShowHotPoint)
			Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ASTROLABE ,visible = red_point}, ClientProto.ShowAwardEffect)
		elseif id2 == Net:get_id2("task", "GetAstrolabeScheduleR") then
			if msg.list[1] ~= nil then
				local system = ConfigMgr:get_config("astrolabe")[msg.list[1].code].system
				self.task_list[system] = {}
				self.task_list[system].list = gf_deep_copy(msg.list)
				self.task_list[system].is_get_reward = msg.systemRewarded
			end
		elseif id2 == Net:get_id2("task", "GetAstrolabeRewardR") then
			if msg.err == 0 then
				local code = unpack(Net:get_sid_param(sid))
				local system = ConfigMgr:get_config("astrolabe")[code].system
				if self.task_list[system] ~= nil then
					for i,v in ipairs(self.task_list[system].list or {}) do
						if code == v.code then
							v.rewarded = true
							break
						end
					end
					local has_red = false
					local target = 0
					local count = 0
					if self.task_list[system].list ~= nil then
						target = #self.task_list[system].list
					end
					for i,v in ipairs(self.task_list[system].list or {}) do
						local target = ConfigMgr:get_config("astrolabe")[v.code].target
						if v.rewarded == false and target <= v.schedule then
							has_red = true
						end
						if target <= v.schedule then
							count = count + 1
						end
					end
					if self.task_list[system].is_get_reward == false and target <= count then
						has_red = true
					end
					self.system_red[system] = has_red
					local red_point = self:has_red()
					Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ASTROLABE, visible=red_point}, ClientProto.ShowHotPoint)
					Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ASTROLABE ,visible = red_point}, ClientProto.ShowAwardEffect)
				end
			end
		elseif id2 == Net:get_id2("task", "GetAstrolabeSkillR") then
			if msg.err == 0 then
				local system = unpack(Net:get_sid_param(sid))
				print("GetAstrolabeSkillRxxxxxxx",system)
				if self.task_list[system] ~= nil then
					self.task_list[system].is_get_reward = true
					local has_red = false
					for i,v in ipairs(self.task_list[system].list or {}) do
						local target = ConfigMgr:get_config("astrolabe")[v.code].target
						if v.rewarded == false and target <= v.schedule then
							has_red = true
							break
						end
					end
					self.system_red[system] = has_red
					local red_point = self:has_red()
					Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.ASTROLABE, visible=red_point}, ClientProto.ShowHotPoint)
					Net:receive({btn_id = ClientEnum.MAIN_UI_BTN.ASTROLABE ,visible = red_point}, ClientProto.ShowAwardEffect)
				end
			end
		end
	end
end

function Astrolabe:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
	return true
end
--初始化函数只会调用一次
function Astrolabe:initialize()
	self.system_red = {}
	self.task_list = {}
end

function Astrolabe:has_red()
	for i,v in pairs(self.system_red) do
		if v == true then
			return true
		end
	end
	return false
end

function Astrolabe:get_red(system)
	return self.system_red[system]
end

function Astrolabe:get_red_system()
	local system = 9999
	for i,v in pairs(self.system_red or {}) do
		if v == true and i < system then
			system = i
		end
	end
	if system == 9999 then
		system = 1
	end
	return system
end


