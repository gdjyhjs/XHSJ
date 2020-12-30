--[[--
-- 任务栏管理ui
-- @Author:xcb
-- @DateTime:2017-06-23 18:23:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveExWheel=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("activeEx")
    UIBase._ctor(self, "service_open_activity_dial.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ActiveExWheel:on_asset_load(key,asset)
end

function ActiveExWheel:init_info()
	self.rotation_total_time = 3
	self.rotation_pass_time = 0
	self.reward_list = {}
	self.leftReward = {}
	for i = 1,8 do
		table.insert(self.reward_list,self.refer:Get(6 + i - 1))
	end
	local info = {}
	self.pointer_rotation = self.refer:Get(1)
	self.deaw = self.refer:Get(3)
	self.pause = self.refer:Get(4)
	self.btn_click = self.refer:Get(14) 
	self.txt_time = self.refer:Get(5)
	self.gray = self.refer:Get(15).material
	self.next_rewarded_time = 0
	self.cur_index = 0
	self.activity_id = LuaItemManager:get_item_obejct("activeEx").activity_id
	self.activity_wheel_level = {}
	local config = LuaItemManager:get_item_obejct("activeEx"):get_config(self.activity_id)
	local id_list = {}
	for i,v in ipairs(config) do
		if v.activity_id == self.activity_id then
			table.insert(id_list,i)
		end
	end
	gf_print_table(id_list,"skdjfkdsdffsl")
	for i,v in ipairs(self.reward_list) do
		local index = id_list[i]
		local level = config[index].pool_id
		local reward_list = ConfigMgr:get_config("activity_wheel_level")[level].reward_arr
		if info[level] == nil then
			info[level] = {}
		end
		local temp = {}
		temp.index = i
		temp.reward_id = reward_list[#info[level] + 1]
		temp.rewarded = 1
		if temp.reward_id ~= nil then
			table.insert(info[level],temp)
		end
	end
	self.data_list = {}
	for k,v in pairs(info) do
		for kk,vv in ipairs(v) do
			table.insert(self.data_list,vv)
		end
	end
	local function sort(a,b)
		return a.index < b.index
	end
	table.sort(self.data_list,sort)
	self.btn_click.interactable = false
	self.pause:SetActive(false)
	self.deaw:SetActive(true)

	--[[local test_data = {
		err = 0,
		activityId = 50001,
		leftReward = {3},
		remainTime = Net:get_server_time_s(),
	}
	gf_send_and_receive(test_data, "task", "GetWheelActivityR")]]
	Net:send({activityId = self.activity_id},"task","GetWheelActivity")
end

function ActiveExWheel:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetWheelActivityR") then
			for i,v in ipairs(msg.leftReward or {}) do
				for ii,vv in ipairs(self.data_list) do
					if vv.reward_id == v then
						vv.rewarded = 0
						break
					end
				end
			end
			gf_print_table(msg.leftReward,"GetWheelActivityR")
			self.leftReward = gf_deep_copy(msg.leftReward)
			self.next_rewarded_time = Net:get_server_time_s() + msg.remainTime
			self:init_ui()
		elseif id2 == Net:get_id2("task", "TurnWheelR") then
			if msg.err == 0 then
				for i,v in ipairs(self.leftReward) do
					if v == msg.reward then
						table.remove(self.leftReward,i)
						break
					end
				end
				print("self.leftReward",i)
				gf_print_table(self.leftReward,"TurnWheelR")
				local turn_count = 0
				for i,v in ipairs(self.data_list) do
					if v.rewarded == 1 then
						turn_count = turn_count + 1
					end
				end
				if 0 < turn_count and turn_count < #self.data_list then
					local data = LuaItemManager:get_item_obejct("activeEx"):get_wheel_table(self.activity_id)--ConfigMgr:get_config("activity_wheel")
					local cold_time = 0
					if 0 < turn_count and turn_count < #data then
						cold_time = data[turn_count + 1].condition
					end
					self.next_rewarded_time = Net:get_server_time_s() + cold_time
					self:start_scheduler2()
				end
			end
		end
	elseif id1==Net:get_id1("base") then
		if id2 == Net:get_id2("base", "OnNewDayR") then
			self.rotation_total_time = 3
			self.rotation_pass_time = 0
			self.leftReward = {}
			self.pointer_rotation:ResetToBeginning()
			self:stop_schedule1()
		    self:stop_schedule2()
			Net:send({activityId = self.activity_id},"task","GetWheelActivity")
		end
	end
end

function ActiveExWheel:on_click( obj, arg )
	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if cmd == "btnClick" then
	--	print("ActiveExWheel:start_scheduler2")
		--gf_send_and_receive({err = 0,activityId = 50001,reward = {code = 3,count = 0}}, "task", "TurnWheelR")
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		--Net:send({activityId = self.activity_id},"task","TurnWheel")
		local reward = self.leftReward[1]
		if reward == nil then return end
		for i,v in ipairs(self.data_list) do
			if v.reward_id == reward then
				v.rewarded = 1
				--self.cur_index = i
				self:play_action(i)
				self.btn_click.interactable = false
				break
			end
		end
		print("TurnWheel",self.activity_id)
	elseif string.find(cmd,"item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(cmd,"item","")
		index = tonumber(index)
		gf_getItemObject("itemSys"):common_show_item_info(index)
	end
end

function ActiveExWheel:play_action(index)
	self.pointer_rotation:ResetToBeginning()
	local cur_rotation = -self:get_angle(self.cur_index)
	local angle = self:get_angle(index)
	--360 + cur_rotation + Angle表示从当前角度旋转到下一个位置最少需要旋转多少度,再加上360*4表示继续转4圈
	local total_rotation = -(360 * 5+ cur_rotation + angle)
	vector1 = Vector3(0,0,cur_rotation)
	vector2 = Vector3(0,0,cur_rotation + total_rotation)
	self.pointer_rotation.from = vector1
	self.pointer_rotation.to = vector2
	self.pointer_rotation:Play(true)
	self.rotation_pass_time = 0
	self.cur_index = index
	self:start_scheduler1()
end
function ActiveExWheel:get_angle(index)
	if index == 0 then
		return 0
	else
		local vector1 = Vector3(0,1,0)
		local dest = self.reward_list[index].transform.position
		local src = self.pointer_rotation.transform.position
		local vector2 = Vector3(dest.x - src.x,dest.y - src.y,0)
		local angle = Vector3.Angle (vector1, vector2); 	--求出两向量之间的夹角  
		local normal = Vector3.Cross (vector1,vector2);		--叉乘求出法线向量
		if 0 < normal.z then
			angle = 360-angle
		end
		return angle
	end
end

function ActiveExWheel:start_scheduler1()
	if self.schedule_id1 then
		self:stop_schedule1()
	end
	local update = function(dt)
		if self.rotation_pass_time < self.rotation_total_time then
			self.rotation_pass_time = self.rotation_pass_time + dt
		else
			self:stop_schedule1()
			local gameObject = self.reward_list[self.cur_index].gameObject
			local button = gameObject:GetComponent("UnityEngine.UI.Button")
			button.interactable = false
			local item_back = self.reward_list[self.cur_index]:Get(1)
			local item_icon_img = self.reward_list[self.cur_index]:Get(2)
			item_back.gameObject:GetComponent(UnityEngine_UI_Image).material = self.gray
			item_icon_img.gameObject:GetComponent(UnityEngine_UI_Image).material = self.gray
			local turn_count = 0
			for i,v in ipairs(self.data_list) do
				if v.rewarded == 1 then
					turn_count = turn_count + 1
				end
			end
			if 0 < turn_count and turn_count < #self.data_list then
				--self:start_scheduler2()
				self.pause:SetActive(true)
				self.deaw:SetActive(false)
			else
				self.pause:SetActive(false)
				self.deaw:SetActive(true)
				self.deaw.gameObject:GetComponent(UnityEngine_UI_Image).material = self.gray
				self.btn_click.interactable = false
			end
			Net:send({activityId = self.activity_id},"task","TurnWheel")
		end
	end
	self.schedule_id1 = Schedule(update, 0.05)
end

function ActiveExWheel:start_scheduler2()
	if self.schedule_id2 then
		self:stop_schedule2()
	end
	local update = function(dt)
		if self.next_rewarded_time < Net:get_server_time_s() then
			self:stop_schedule2()
			self.pause:SetActive(false)
			self.deaw:SetActive(true)
			self.btn_click.interactable = true
		else
			local left_time = self.next_rewarded_time - Net:get_server_time_s()
			self.txt_time.text = gf_convert_timeEx(math.floor(left_time))
		end
	end
	self.schedule_id2 = Schedule(update, 0.05)
end

function ActiveExWheel:stop_schedule1()
	if self.schedule_id1 then
		self.schedule_id1:stop()
		self.schedule_id1 = nil
	end
end

function ActiveExWheel:stop_schedule2()
	if self.schedule_id2 then
		self.schedule_id2:stop()
		self.schedule_id2 = nil
	end
end

function ActiveExWheel:register()
	StateManager:register_view( self )
end

function ActiveExWheel:cancel_register()
	StateManager:remove_register_view( self )
end

function ActiveExWheel:on_showed()
	self:register()
	self:init_info()
end

function ActiveExWheel:init_ui()
	local turn_count = 0
	local item_config = ConfigMgr:get_config("item")
	for i,v in ipairs(self.reward_list) do
		if self.data_list[i].index == i then	--不等于的话说明策划奖励表少配了一个奖励
			local item_back = v:Get(1)
			local item_icon_img = v:Get(2)
			local count = v:Get(3)
			local reward = ConfigMgr:get_config("activity_wheel_reward")[self.data_list[i].reward_id]
			gf_set_item( reward.item_id, item_icon_img, item_back)
			count.text = tostring(reward.count)
			if self.data_list[i].rewarded == 1 then
				local button = v.gameObject:GetComponent("UnityEngine.UI.Button")
				button.interactable = false
				item_back.gameObject:GetComponent(UnityEngine_UI_Image).material = self.gray
				item_icon_img.gameObject:GetComponent(UnityEngine_UI_Image).material = self.gray
				turn_count = turn_count + 1
			else
				local button = v.gameObject:GetComponent("UnityEngine.UI.Button")
				button.interactable = true
				item_back.gameObject:GetComponent(UnityEngine_UI_Image).material = nil
				item_icon_img.gameObject:GetComponent(UnityEngine_UI_Image).material = nil
			end
			local lock = v:Get(4)
			if item_config[reward.item_id].bind == 1 then
				lock:SetActive(true)
			else
				lock:SetActive(false)
			end
			v.gameObject.name = "item" .. reward.item_id
		end
	end
	--[[local data = ConfigMgr:get_config("activity_wheel")
	local cold_time = 0
	if 0 < turn_count and turn_count < #self.data_list then
		cold_time = data[turn_count].condition
	end]]
	if self.next_rewarded_time <= Net:get_server_time_s() and turn_count < #self.data_list then
		self.pause:SetActive(false)
		self.deaw:SetActive(true)
		self.btn_click.interactable = true
	elseif #self.data_list <= turn_count then
		self.pause:SetActive(false)
		self.deaw:SetActive(true)
		self.deaw.gameObject:GetComponent(UnityEngine_UI_Image).material = self.gray
		self.btn_click.interactable = false
	else
		self.pause:SetActive(true)
		self.deaw:SetActive(false)
		self.btn_click.interactable = false
		self:start_scheduler2()
	end
end
function ActiveExWheel:on_hided()
end

-- 释放资源
function ActiveExWheel:dispose()
	self:cancel_register()
    self._base.dispose(self)
    if self.schedule_id1 then
    	Net:send({activityId = self.activity_id},"task","TurnWheel")
    end
    self:stop_schedule1()
    self:stop_schedule2()
end

return ActiveExWheel

