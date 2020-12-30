--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local ActiveExTask=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("activeEx")
    UIBase._ctor(self, "service_open_activity_task.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function ActiveExTask:on_asset_load(key,asset)
end

function ActiveExTask:init_ui()
	self.data_list = {}
	self.activity_id = LuaItemManager:get_item_obejct("activeEx").activity_id
	local config = LuaItemManager:get_item_obejct("activeEx"):get_config(self.activity_id)
	local item_config = ConfigMgr:get_config("item")
	local function update(item,index,data)
		local award_item = item:Get(2)
		local reward = config[data.rewardId].reward
		for i = 1,2 do
			local item = award_item:Get(i)
			if reward[i] ~= nil then
				item.gameObject:SetActive(true)
				local item_back = item:Get(1)
				local item_icon_img = item:Get(2)
				local count = item:Get(3)
				gf_set_item( reward[i][1], item_icon_img, item_back)
				count.text = tostring(reward[i][2])
				item.gameObject.name = "item" .. reward[i][1]
				local lock = item:Get(4)
				if item_config[reward[i][1]].bind == 1 then
					lock:SetActive(true)
				else
					lock:SetActive(false)
				end
			else
				item.gameObject:SetActive(false)
			end
		end

		local server_times = config[data.rewardId].server_times
		local remain = item:Get(6)
		if server_times == 0 then
			remain.gameObject:SetActive(false)
		else
			remain.gameObject:SetActive(true)
			remain.text = string.format(gf_localize_string("全服剩余:%d份"),data.serverLeft)
		end

		local day_times = config[data.rewardId].day_times
		local player_times = config[data.rewardId].player_times
		local receive = item:Get(8)
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
		local event = config[data.rewardId].event
		if ( 0 < server_times and data.serverLeft <= 0 ) or (0 < player_times and player_times - data.times <= 0 ) or ( 0 < day_times and day_times - data.timesToday <= 0 ) then
			get_award.interactable = false
			get_over:SetActive(true)
			unclick.text = gf_localize_string("领取")
		elseif (event == require("enum.enum_ser").EVENT.POWER_UPDATE 
				or event == require("enum.enum_ser").EVENT.COMBAT_ATTR_UP 
				or event == 0)
				and LuaItemManager:get_item_obejct("activeEx"):is_finished(data.schedule,self.activity_id,data.rewardId) == false then
			get_award.interactable = false
			get_over:SetActive(true)
			unclick.text = gf_localize_string("点击前往")
		else
			get_over:SetActive(false)
			get_award.interactable = true
			if LuaItemManager:get_item_obejct("activeEx"):is_finished(data.schedule,self.activity_id,data.rewardId) == true then
				get_text.text = gf_localize_string("领取")
			else
				get_text.text = gf_localize_string("点击前往")
			end
		end
		local condition = item:Get(7)
		local schedule = data.schedule[1] or {}
		schedule = schedule.count or 0
		local des = config[data.rewardId].description
		local target = config[data.rewardId].condition[2] or 0
		des = string.format("%s(%d/%d)",des,schedule,target)
		condition.text = des

		get_award.name = string.format("task_reward%d",index)
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
						activityId = 40001,
						schedule = {
									{rewardId =  1,schedule = {{code = 40121501,count = 0}},times = 0,serverLeft = 20},
									{rewardId =  2,schedule = {{code = 40121501,count = 0}},times = 0,serverLeft = 20},
									{rewardId =  3,schedule = {{code = 40121501,count = 0}},times = 0,serverLeft = 20},
									{rewardId =  4,schedule = {{code = 40121501,count = 0}},times = 0,serverLeft = 20},
									{rewardId =  5,schedule = {{code = 40121501,count = 0}},times = 0,serverLeft = 20},
									{rewardId =  6,schedule = {{code = 40121501,count = 0}},times = 0,serverLeft = 20},
						}
					}
	self.activity_type = ConfigMgr:get_config("activity_server_start")[self.activity_id].activity_type
	gf_send_and_receive(test_data, "task", "GetRewardGroupR")]]
	Net:send({activityId = self.activity_id},"task","GetRewardGroup")
end

function ActiveExTask:on_receive( msg, id1, id2, sid )
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

function ActiveExTask:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if string.find(cmd,"task_reward") then
		local index = string.gsub(cmd,"task_reward","")
		index = tonumber(index)
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local data = self.data_list[index]
		if LuaItemManager:get_item_obejct("activeEx"):is_finished(data.schedule,self.activity_id,data.rewardId) == true then
			Net:send({rewardId = data.rewardId,activityId = self.activity_id},"task","GetNormalReward")
		else
			local config = LuaItemManager:get_item_obejct("activeEx"):get_config(self.activity_id)
			local level = config[index].level
			local player_lv = LuaItemManager:get_item_obejct("game"):getLevel()
			if player_lv < level then
				local str = string.format(gf_localize_string("需要%d级开放"),level)
				gf_message_tips(str)
				return
			end
			local event = config[index].event
			if event == require("enum.enum_ser").EVENT.POWER_UPDATE then
			elseif event == require("enum.enum_ser").EVENT.DAILY_ANSWER_ONCE then
				local data = ConfigMgr:get_config("daily")[2001]
				if player_lv < data.level then
					local str = string.format(gf_localize_string("需要%d级开放"),data.level)
					gf_message_tips(str)
				else
					gf_create_model_view("exam")
				end
			elseif event == require("enum.enum_ser").EVENT.DAILY_ACTIVE_ADD then
				gf_create_model_view("activeDaily")
			elseif event == require("enum.enum_ser").EVENT.CHALLENGECOPY_TYPE then
				-- gf_getItemObject("copy"):create_copy_view(require("enum.enum").COPY_TYPE_VIEW.STORY)
				gf_create_model_view("copy")
			elseif event == require("enum.enum_ser").EVENT.CHALLENGECOPY then
				if config[index].condition[1] == require("enum.enum").COPY_TYPE.PROTECT_CITY then
					--[[if gf_getItemObject("activeDaily"):is_have_active(ClientEnum.MAIN_UI_BTN.DEFENSE) == true then
						gf_create_model_view("mozu")
					else
						gf_message_tips(gf_localize_string("该活动已经结束"))
						return
					end]]
					gf_create_model_view("mozu")
				else 
					gf_create_model_view("copy")
				end
			elseif event == require("enum.enum_ser").EVENT.ALLIANCE_JOIN then
				gf_getItemObject("legion"):open_view()
			elseif event == require("enum.enum_ser").EVENT.EVERY_DAY_TASK_DONE then
				--gf_create_model_view("activeDaily")
				local data = ConfigMgr:get_config("daily")[1008]
				LuaItemManager:get_item_obejct("activeDaily"):active_enter(data)
			elseif event == require("enum.enum_ser").EVENT.COMBAT_ATTR_UP then
			end
			Net:receive({}, ClientProto.closeActiveEx)
		end
	elseif string.find(cmd,"item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(cmd,"item","")
		index = tonumber(index)
		gf_getItemObject("itemSys"):common_show_item_info(index)
	end
end

function ActiveExTask:register()
	StateManager:register_view( self )
end

function ActiveExTask:cancel_register()
	StateManager:remove_register_view( self )
end

function ActiveExTask:on_showed()
	self:register()
	self:init_ui()
end

function ActiveExTask:on_hided()
end

-- 释放资源
function ActiveExTask:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return ActiveExTask

