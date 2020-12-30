--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveExExchange=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("activeEx")
    UIBase._ctor(self, "service_open_activity_collect.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ActiveExExchange:on_asset_load(key,asset)
end

function ActiveExExchange:init_ui()
	self.data_list = {}
	self.activity_id = LuaItemManager:get_item_obejct("activeEx").activity_id
	local config = LuaItemManager:get_item_obejct("activeEx"):get_config(self.activity_id)
	local item_config = ConfigMgr:get_config("item")
	local function update(item,index,data)
		local award_item = item:Get(2)
		local add1 = award_item:Get(10)
		local add2 = award_item:Get(8)
		local add3 = award_item:Get(9)
		local condition = config[data.rewardId].condition
		if #condition < 4 then
			add3:SetActive(false)
		else
			add3:SetActive(true)
		end
		if #condition < 3 then
			add2:SetActive(false)
		else
			add2:SetActive(true)
		end
		if #condition < 2 then
			add1:SetActive(false)
		else
			add1:SetActive(true)
		end
		for i = 1,4 do
			local item = award_item:Get(i)
			if condition[i] ~= nil then
				item.gameObject:SetActive(true)
				local item_back = item:Get(1)
				local item_icon_img = item:Get(2)
				local count = item:Get(3)
				gf_set_item( condition[i][1], item_icon_img, item_back)
				local schedule = 0
				for ii,vv in ipairs(data.schedule) do
					if condition[i][1] == vv.code then
						schedule = vv.count
						break
					end
				end
				count.text = string.format("%d/%d",schedule,condition[i][2])
				item.gameObject.name = "item" .. condition[i][1]
				local lock = item:Get(4)
				if item_config[condition[i][1]].bind == 1 then
					lock:SetActive(true)
				else
					lock:SetActive(false)
				end
			else
				item.gameObject:SetActive(false)
			end
		end
		local item5 = award_item:Get(5)
		local reward = config[data.rewardId].reward
		if reward[1] ~= nil then
			item5.gameObject:SetActive(true)
			local item_back = item5:Get(1)
			local item_icon_img = item5:Get(2)
			local count = item5:Get(3)
			gf_set_item( reward[1][1], item_icon_img, item_back)
			count.text = tostring(reward[1][2])

			item5.gameObject.name = "item" .. reward[1][1]
			local lock = item5:Get(4)
			if item_config[reward[1][1]].bind == 1 then
				lock:SetActive(true)
			else
				lock:SetActive(false)
			end
		else
			item5.gameObject:SetActive(false)
		end

		local server_times = config[data.rewardId].server_times
		local remain = item:Get(7)
		if server_times == 0 then
			remain.gameObject:SetActive(false)
		else
			remain.gameObject:SetActive(true)
			remain.text = string.format(gf_localize_string("全服剩余:%d份"),data.serverLeft)
		end

		local player_times = config[data.rewardId].player_times
		local day_times = config[data.rewardId].day_times
		local receive = item:Get(6)
		--[[if player_times == 0 then
			receive.gameObject:SetActive(false)
		else
			receive.gameObject:SetActive(true)
			receive.text = string.format(gf_localize_string("个人可领取:%d/%d份"),player_times - data.times,player_times)
		end

		local day_times = config[data.rewardId].day_times
		if day_times == 0 then
			receive.gameObject:SetActive(false)
		else
			receive.gameObject:SetActive(true)
			receive.text = string.format(gf_localize_string("今日可领取:%d/%d份"),day_times - data.times,day_times)
		end]]
		if player_times == 0 and day_times == 0 then
			receive.gameObject:SetActive(false)
		else
			receive.gameObject:SetActive(true)
			if 0 < player_times then
				receive.text = string.format(gf_localize_string("个人可领取:%d/%d份"),player_times - data.times,player_times)
			else
				receive.text = string.format(gf_localize_string("今日可领取:%d/%d份"),day_times - data.timesToday,day_times)
			end
		end
		local get_over = item:Get(1)
		local get_award = item:Get(3)
		local get_text = item:Get(4)
		local unclick = item:Get(5)
		if ( 0 < server_times and data.serverLeft <= 0 ) or (0 < player_times and player_times - data.times <= 0 ) or ( 0 < day_times and day_times - data.timesToday <= 0 ) then
			get_award.interactable = false
			get_over:SetActive(true)
			unclick.text = gf_localize_string("领取")
		else
			if LuaItemManager:get_item_obejct("activeEx"):is_finished(data.schedule,self.activity_id,data.rewardId) == true then
				get_text.text = gf_localize_string("领取")
				get_over:SetActive(false)
				get_award.interactable = true
			else
				get_award.interactable = false
				get_over:SetActive(true)
				unclick.text = gf_localize_string("领取")
			end
		end

		get_award.name = string.format("exchange_reward%d",data.rewardId) 
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
	--Net:send({activityId = self.activity_id},"task","GetRewardGroup")
	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,serverLeft = 20,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,serverLeft = 20,timesToday = 0},
									{rewardId =  4,schedule = {{code = 40121501,count = 0},},times = 0,serverLeft = 20,timesToday = 0},
									{rewardId =  5,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,timesToday = 0},
									{rewardId =  6,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,timesToday = 0},
						}
					}]]
	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 10,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 10,serverLeft = 10,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,serverLeft = 15,timesToday = 5},
									{rewardId =  4,schedule = {{code = 40121501,count = 0},},times = 0,serverLeft = 0,timesToday = 20},
									{rewardId =  5,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,timesToday = 5},
									{rewardId =  6,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 1,timesToday = 0},
						}
					}]]

	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 10,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 10,serverLeft = 0,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,serverLeft = 0,timesToday = 5},
									{rewardId =  4,schedule = {{code = 40121501,count = 0},},times = 10,serverLeft = 0,timesToday = 0},
									{rewardId =  5,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 5,timesToday = 5},
									{rewardId =  6,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 1,timesToday = 100},
						}
					}]]
	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,serverLeft = 0,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,serverLeft = 0,timesToday = 0},
									{rewardId =  4,schedule = {{code = 40121501,count = 0},},times = 0,serverLeft = 0,timesToday = 0},
									{rewardId =  5,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,timesToday = 0},
									{rewardId =  6,schedule = {{code = 40121501,count = 0},{code = 40121501,count = 0},},times = 0,timesToday = 0},
						}
					}]]

	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,serverLeft = 20,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,serverLeft = 20,timesToday = 0},
									{rewardId =  4,schedule = {{code = 40121501,count = 1},},times = 0,serverLeft = 20,timesToday = 0},
									{rewardId =  5,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 0},
									{rewardId =  6,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 0},
						}
					}]]
	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 10,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 10,serverLeft = 10,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,serverLeft = 15,timesToday = 5},
									{rewardId =  4,schedule = {{code = 40121501,count = 1},},times = 20,serverLeft = 0,timesToday = 0},
									{rewardId =  5,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 5},
									{rewardId =  6,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 1,timesToday = 0},
						}
					}]]

	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 10,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 10,serverLeft = 0,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,serverLeft = 0,timesToday = 5},
									{rewardId =  4,schedule = {{code = 40121501,count = 1},},times = 10,serverLeft = 0,timesToday = 0},
									{rewardId =  5,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 5},
									{rewardId =  6,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 1,timesToday = 0},
						}
					}]]
	--[[local test_data = {err = 0,
						activityId = 30001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 0},
									{rewardId =  2,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,serverLeft = 0,timesToday = 0},
									{rewardId =  3,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,serverLeft = 0,timesToday = 0},
									{rewardId =  4,schedule = {{code = 40121501,count = 1},},times = 0,serverLeft = 0,timesToday = 0},
									{rewardId =  5,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 0},
									{rewardId =  6,schedule = {{code = 40121501,count = 1},{code = 40121501,count = 1},},times = 0,timesToday = 0},
						}
					}
	
	gf_send_and_receive(test_data, "task", "GetRewardGroupR")

	self.activity_type = ConfigMgr:get_config("activity_server_start")[self.activity_id].activity_type]]
	Net:send({activityId = self.activity_id},"task","GetRewardGroup")
end

function ActiveExExchange:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetRewardGroupR") then
			if self.activity_id == msg.activityId then
				self.data_list = LuaItemManager:get_item_obejct("activeEx"):get_data(self.activity_id)
				self.right_scroll.data = self.data_list
				self.right_scroll:Refresh(0,#self.data_list - 1)
			end
		elseif id2 == Net:get_id2("task","GetNormalRewardR") then
			--local activity_type = ConfigMgr:get_config("activity_server_start")[msg.activity_id].activity_type
			if self.activity_id == msg.activityId and msg.err == 0 then
				--[[for i,v in ipairs(self.data_list) do
					if v.rewardId == msg.rewardId then
						self.right_scroll:Refresh(i - 1,i - 1)
						break
					end
				end]]
				self.right_scroll:Refresh(0,#self.data_list - 1)
			end
		end
	end
end

function ActiveExExchange:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if string.find(cmd,"exchange_reward") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(cmd,"exchange_reward","")
		index = tonumber(index)
		Net:send({rewardId = index,activityId = self.activity_id},"task","GetNormalReward")
	elseif string.find(cmd,"item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(cmd,"item","")
		index = tonumber(index)
		gf_getItemObject("itemSys"):common_show_item_info(index)
	end
end

function ActiveExExchange:register()
	StateManager:register_view( self )
end

function ActiveExExchange:cancel_register()
	StateManager:remove_register_view( self )
end

function ActiveExExchange:on_showed()
	self:register()
	self:init_ui()
end

function ActiveExExchange:on_hided()
end

-- 释放资源
function ActiveExExchange:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return ActiveExExchange

