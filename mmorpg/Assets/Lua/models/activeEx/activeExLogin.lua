--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveExLogin=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("activeEx")
    UIBase._ctor(self, "service_open_activity_login.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ActiveExLogin:on_asset_load(key,asset)
end

function ActiveExLogin:init_ui()
	self.data_list = {}
	self.activity_id = LuaItemManager:get_item_obejct("activeEx").activity_id
	local config = LuaItemManager:get_item_obejct("activeEx"):get_config(self.activity_id)
	local item_config = ConfigMgr:get_config("item")
	local function update(item,index,data)
		local award_item = item:Get(3)
		local reward_list = config[data.rewardId].reward
		for i = 1,5 do
			local item = award_item:Get(i)
			if reward_list[i] ~= nil then
				item.gameObject:SetActive(true)
				local item_back = item:Get(1)
				local item_icon_img = item:Get(2)
				local count = item:Get(3)
				gf_set_item( reward_list[i][1], item_icon_img, item_back)
				count.text = tostring(reward_list[i][2])
				item.gameObject.name = "item" .. reward_list[i][1]

				local lock = item:Get(4)
				if item_config[reward_list[i][1]].bind == 1 then
					lock:SetActive(true)
				else
					lock:SetActive(false)
				end
			else
				item.gameObject:SetActive(false)
			end
		end

		local get_award_btn = item:Get(4)
		local get_over = item:Get(2)

		local unclickable = item:Get(6)
		if data.times == 0 then
			if LuaItemManager:get_item_obejct("activeEx"):is_finished(data.schedule,self.activity_id,data.rewardId) == true then
				--get_award_btn.gameObject:SetActive(true)
				get_award_btn.interactable = true
				get_over:SetActive(false)
			else
				--get_award_btn.gameObject:SetActive(false)
				get_award_btn.interactable = false
				get_over:SetActive(true)
				unclickable.text = gf_localize_string("领取")
			end
		else
			--get_award_btn.gameObject:SetActive(false)
			get_award_btn.interactable = false
			get_over:SetActive(true)
			unclickable.text = gf_localize_string("已领取")
		end
		get_award_btn.name = string.format("login_reward%d",data.rewardId)
		local condition = item:Get(1)
		condition.text = config[data.rewardId].login_times
	end
	self.right_scroll = self.refer:Get(1)
	self.right_scroll.data = self.data_list
	self.right_scroll.onItemRender = update

	local start_time = self.refer:Get(2)
	start_time.text = os.date("%Y-%m-%d %H:%M:%S",LuaItemManager:get_item_obejct("activeEx"):get_time_info(self.activity_id).begin_time)

	local end_time = self.refer:Get(3)
	end_time.text = os.date("%Y-%m-%d %H:%M:%S",LuaItemManager:get_item_obejct("activeEx"):get_time_info(self.activity_id).end_time)

	local des = self.refer:Get(4)
	des.text = string.format(gf_localize_string("活动介绍:%s"),ConfigMgr:get_config("activity_server_start")[self.activity_id].description)

	--[[local test_data = {err = 0,
						activityId = 10001,
						schedule = {
									{rewardId =  10001001,schedule = {{code = 5},},times = 0,},
									{rewardId =  10001002,schedule = {{code = 5},},times = 0,},
									{rewardId =  10001003,schedule = {{code = 5},},times = 0,},
									{rewardId =  10001004,schedule = {{code = 5},},times = 0,},
									{rewardId =  10001005,schedule = {{code = 5},},times = 0,},
									{rewardId =  10001006,schedule = {{code = 5},},times = 0,},
									{rewardId =  10001007,schedule = {{code = 5},},times = 0,},
						}
					}
	gf_send_and_receive(test_data, "task", "GetRewardGroupR")]]

	--self.activity_type = ConfigMgr:get_config("activity_server_start")[self.activity_id].activity_type
	Net:send({activityId = self.activity_id},"task","GetRewardGroup")
	print("GetRewardGroups",self.activity_id)
end

function ActiveExLogin:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetRewardGroupR") then
			if self.activity_id == msg.activityId then
				self.data_list = LuaItemManager:get_item_obejct("activeEx"):get_data(self.activity_id) or {}
				self.right_scroll.data = self.data_list
				self.right_scroll:Refresh(0,#self.data_list - 1)
			end
		elseif id2 == Net:get_id2("task","GetNormalRewardR") then
			--local activity_type = ConfigMgr:get_config("activity_server_start")[msg.activity_id].activity_type
			if self.activity_id == msg.activityId and msg.err == 0 then
				for i,v in ipairs(self.data_list) do
					if v.rewardId == msg.rewardId then
						self.right_scroll:Refresh(i - 1,i - 1)
						break
					end
				end
			end
		end
	end
end

function ActiveExLogin:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if string.find(cmd,"login_reward") then
		local index = string.gsub(cmd,"login_reward","")
		index = tonumber(index)
		print("ActiveExLogin:on_click",index)
		Net:send({rewardId = index,activityId = self.activity_id},"task","GetNormalReward")
	elseif string.find(cmd,"item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(cmd,"item","")
		index = tonumber(index)
		gf_getItemObject("itemSys"):common_show_item_info(index)
	end
end

function ActiveExLogin:register()
	StateManager:register_view( self )
end

function ActiveExLogin:cancel_register()
	StateManager:remove_register_view( self )
end

function ActiveExLogin:on_showed()
	self:register()
	self:init_ui()
end

function ActiveExLogin:on_hided()
end

-- 释放资源
function ActiveExLogin:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return ActiveExLogin

