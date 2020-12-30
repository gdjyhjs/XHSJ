--[[--
--官职
-- @Author:Seven
-- @DateTime:2017-07-17 14:46:52
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local OfficerPosition = LuaItemManager:get_item_obejct("officerPosition")
OfficerPosition.priority = 1
--UI资源
OfficerPosition.assets=
{
    View("officerPositionView", OfficerPosition) 
}

--点击事件
function OfficerPosition:on_click(obj,arg)
	self:call_event("officerPosition_view_on_click",false,obj,arg)
	return true
end

--每次显示时候调用
function OfficerPosition:on_showed( ... )

end

--初始化函数只会调用一次
function OfficerPosition:initialize()
	
end

function OfficerPosition:is_award()
	return (not self.left_award and self.current_left.grade~=0)or( self.current_right.grade ~=0 and not self.right_award ) 
end

-- function OfficerPosition:init()
-- 	self.officer_left_data = {}
-- 	self.officer_right_data = {}
-- 	local data= ConfigMgr:get_config("officerPosition")
-- 	for k,v in pairs(data) do
-- 		if v.type == Enum.POSITION_TYPE.CIVIL then
-- 			self.officer_left_data[#self.officer_left_data+1] = copy(data[k])
-- 		elseif v.type == Enum.POSITION_TYPE.MILITARY then
-- 			self.officer_right_data[#self.officer_right_data+1] = copy(data[k])
-- 		end
-- 	end
-- 	local sortFunc = function(a,b)
-- 		return a.grade > b.grade
--     end
--     table.sort(self.officer_left_data,sortFunc)
-- 	table.sort(self.officer_right_data,sortFunc)
-- end

function OfficerPosition:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("base")) then
		if id2 == Net:get_id2("base","GetOfficeInfoR")  then
			gf_print_table(msg,"wtf receive GetOfficeInfoR")
			gf_print_table(msg,"主动获取官职信息")
			-- self:init()
			self:get_office_info_s2c(msg)
		elseif id2 == Net:get_id2("base","UpdateOfficeInfoR")  then
			gf_print_table(msg,"设置官职主动推送")
			self:update_office_info_s2c(msg)
		elseif id2 == Net:get_id2("base","GetOfficeRewardR")  then
			gf_print_table(msg,"官职获取俸禄")
			self:get_office_reward_s2c(msg)
		end
	end
end

--主动获取官职信息
function OfficerPosition:get_office_info_s2c(msg)
	local data= ConfigMgr:get_config("officerPosition")
	if msg.position[1] == 0 then
		for k,v in pairs(data) do
			if v.type == Enum.POSITION_TYPE.CIVIL and v.grade == 0  then 
				self.current_left =	v 
			end
		end
	else
		self.current_left = data[msg.position[1]]
	end
	if msg.position[2] == 0 then
		for k,v in pairs(data) do
			if v.type == Enum.POSITION_TYPE.MILITARY and v.grade == 0  then 
				self.current_right = v
			end
		end
	else
		self.current_right = data[msg.position[2]]
	end

	-- local left_lock = true
	-- for k,v in pairs(self.officer_left_data) do
	-- 	if left_lock then
	-- 		if msg.position[1] == v.code then
	-- 			v.lock = false
	-- 			self.current_left = v
	-- 			left_lock = false
	-- 		else
	-- 			v.lock = true
	-- 		end
	-- 	else
	-- 		v.lock = false
	-- 	end
	-- end

	-- local right_lock = true
	-- for k,v in pairs(self.officer_right_data) do
	-- 	if right_lock then
	-- 		if msg.position[2] == v.code then
	-- 			v.lock = false
	-- 			self.current_right = v
	-- 			right_lock = false
	-- 		else
	-- 			v.lock = true
	-- 		end
	-- 	else
	-- 		v.lock = false
	-- 	end
	-- end
	
	self.left_award = msg.rewardedToday[1]
	self.right_award = msg.rewardedToday[2]
end
function OfficerPosition:get_office_info_c2s()
	Net:send({},"base","GetOfficeInfo")
end
--设置官职主动推送
function OfficerPosition:update_office_info_s2c(msg)
	if msg.position[1] ~=0 then
		self.current_left = ConfigMgr:get_config("officerPosition")[msg.position[1]]
		-- local left_lock = false
		-- for k,v in pairs(self.officer_left_data) do
		-- 	if v.code == msg.position[1] then
		-- 		left_lock = true
		-- 		v.lock = false
		-- 	end
		-- 	if left_lock then  --后面的都解锁
		-- 		v.lock = false
		-- 	end
		-- end
	end
	if msg.position[2] ~=0 then
		self.current_right = ConfigMgr:get_config("officerPosition")[msg.position[2]]
		-- local right_lock = false
		-- for k,v in pairs(self.officer_right_data) do
		-- 	if v.code == msg.position[2] then
		-- 		right_lock = true
		-- 		v.lock = false
		-- 	end
		-- 	if right_lock then--后面的都解锁
		-- 		v.lock = false
		-- 	end
		-- end
	end
	-- if self.assets[1] then
	-- 	self.assets[1]:update_view()
	-- end
end
--官职获取俸禄
function OfficerPosition:get_office_reward_s2c(msg)
	if msg.err == 0 then
		if self.current_tp  == Enum.POSITION_TYPE.CIVIL then
			self.left_award = true
		elseif self.current_tp  == Enum.POSITION_TYPE.MILITARY then
			self.right_award = true
		end
		Net:receive({show=false,module=ClientEnum.MODULE_TYPE.PLAYER_INFO,a=4}, ClientProto.UIRedPoint)
		self.assets[1]:update_view()
	end
end
function OfficerPosition:get_office_reward_c2s(tp)
	self.current_tp = tp
	Net:send({ positionType = tp},"base","GetOfficeReward")
end

-- --根据id获取左边信息
-- function OfficerPosition:get_left_data(o_id)
-- 	for k,v in pairs(self.officer_left_data) do
-- 		if o_id == v.code then
-- 			return v
-- 		end
-- 	end
-- 	return
-- end
-- --根据id获取右边信息
-- function OfficerPosition:get_right_data(o_id)
-- 	for k,v in pairs(self.officer_right_data) do
-- 		if o_id == v.code then
-- 			return v
-- 		end
-- 	end
-- 	return
-- end