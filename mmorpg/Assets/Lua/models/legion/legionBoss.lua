--[[
	军团boss 兽神。界面
	create at 17.11.23
	by xin
]]

local uiBase = require("common.viewBase")

local commom_string = 
{
	[1] = gf_localize_string("挑战进行中%s"),
	[2] = gf_localize_string("开启挑战"),
	[3] = gf_localize_string("前往挑战"),
	[4] = gf_localize_string("消耗:%d"),
	[5] = gf_localize_string("是否花费%d口粮开启活动，活动失败后返还开启所花费的口粮。"),
	[6] = gf_localize_string("口粮不足"),
}

local dataUse = require("models.legion.dataUse")

local legionBoss = class(uiBase,function(self)
	local item_obj = gf_getItemObject("copy")
	uiBase._ctor(self, "legion_god_animal.u3d", item_obj)
end)

function legionBoss:on_showed()
	legionBoss._base.on_showed(self)
	gf_getItemObject("legion"):get_member_list_c2s()
end

function legionBoss:init_ui()
	self:start_scheduler()
	local legion_info = gf_getItemObject("legion"):get_legion_base_info()
	local data = ConfigMgr:get_config("legion_boss")[1]
	--模型
	gf_set_model(ConfigMgr:get_config("creature")[data.proto_id].model_id,self.refer:Get(1),data.model_scale)
	
	self:init_open_state_view()

	--口粮icon
	gf_set_item(data.food_code, self.refer:Get(10), self.refer:Get(9))
	--数量
	self.refer:Get(11).text = gf_getItemObject("bag"):get_count_in_bag(data.food_code)
	--挑战次数
	self.refer:Get(5).text = string.format("%d/%d",legion_info.legionBossTimes,data.week_count)
	--开启一次需要口粮
	self.refer:Get(12).text = string.format(commom_string[4], data.need_food)
	--总口粮
	self.refer:Get(6).text = string.format("%d/%d",legion_info.foodCount,data.need_food)
	--消耗的icon
	local icon =  ConfigMgr:get_config("item")[data.food_code].icon
	gf_setImageTexture(self.refer:Get(19),icon)

	self:init_button_state()

	self:init_boss_reward()

	
end 

function legionBoss:init_boss_reward()
	local level = gf_getItemObject("legion"):get_average_level()
	local career = gf_getItemObject("game"):get_career()
	local reward = dataUse.getLegionBossBoxReward(level,career)

	local food_item_id = ConfigMgr:get_const( "legion_donation_id" )

	local scroll_view = self.refer:Get(18)
	
	gf_print_table(reward,"wtf reward:")

	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		gf_set_click_prop_tips(scroll_rect_item.gameObject,data_item[1],data_item[3],data_item[4])
		if data_item[1] == ServerEnum.BASE_RES.ALLIANCE_DONATE then
			gf_set_click_prop_tips(scroll_rect_item.gameObject,food_item_id)
			gf_set_item(food_item_id, scroll_rect_item:Get(1), scroll_rect_item:Get(3))
			return
		end
		gf_set_equip_icon(data_item[2], scroll_rect_item:Get(1), scroll_rect_item:Get(3),data_item[3],data_item[4])
	end
	
	scroll_view.data = reward
	scroll_view:Refresh(-1,-1)

end

function legionBoss:init_button_state()
	local can_open = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.OPEN_ACTIVITY)
	local is_open = gf_getItemObject("legion"):get_legion_boss()

	self.refer:Get(17):SetActive(is_open or can_open)
	
	self.refer:Get(16).text = commom_string[3]

	if not is_open and can_open then
		self.refer:Get(16).text = commom_string[2]
	end
end

function legionBoss:update_time_left()
	local legion_info = gf_getItemObject("legion"):get_legion_base_info()
	local data = ConfigMgr:get_config("legion_boss")[1]
	local valid_time = data.valid_time 
	--已经进行时间
	local leave_time = legion_info.legionBossLeaveTime
	local left = leave_time - Net:get_server_time_s()
	left = math.ceil(left)
	left = left <= 0 and 0 or left
	self.refer:Get(13).text = string.format(commom_string[1],gf_convert_time(left))

	print("wtf left:",left)
	return left <= 0
end

function legionBoss:start_scheduler()
	--开启状态
	local is_open = gf_getItemObject("legion"):get_legion_boss()
	if not is_open then
		return
	end
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		if self:update_time_left() then
			self:stop_schedule()
			self:init_ui()
		end
	end
	update()
	self.schedule_id = Schedule(update, 0.5)
end

function legionBoss:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end

end
--开启状态
function legionBoss:init_open_state_view()
	local legion_info = gf_getItemObject("legion"):get_legion_base_info()
	local data = ConfigMgr:get_config("legion_boss")[1]
		
	local is_open = gf_getItemObject("legion"):get_legion_boss()

	self.refer:Get(8):SetActive(not is_open)
	self.refer:Get(7):SetActive(is_open)

	--时间
	local valid_time = data.valid_time 
	if not is_open then
		self.refer:Get(3).text = string.format("%s-%s",gf_convert_time_hm(valid_time[1][1] * 60 * 60 + 60 * valid_time[1][2]),gf_convert_time_hm(valid_time[2][1] * 60 * 60 + 60 * valid_time[2][2]))
		return
	end

	self:update_time_left()

	--血量	
	self.refer:Get(14).text = string.format("%s/%s",legion_info.legionBossCurHP,legion_info.legionBossMaxHP)
	self.refer:Get(15).fillAmount = legion_info.legionBossCurHP / legion_info.legionBossMaxHP

end

function legionBoss:clear()
	print("clear wtf")
	self:stop_schedule()
end
function legionBoss:on_hided()
	legionBoss._base.on_hided(self)
end

-- 释放资源
function legionBoss:dispose()
	legionBoss._base.dispose(self)
end


function legionBoss:hand_food_click()
	local data = ConfigMgr:get_config("legion_boss")[1]
	local count = gf_getItemObject("bag"):get_count_in_bag(data.food_code)
	if count <= 0 then
		gf_message_tips(commom_string[6])
		return
	end
	gf_getItemObject("legion"):hand_boss_food_c2s()
end

function legionBoss:join_click()
	local is_open = gf_getItemObject("legion"):get_legion_boss()
	local data = ConfigMgr:get_config("legion_boss")[1]

	--开启状态
	if is_open then
		local data = ConfigMgr:get_config("legion_boss")[1]
		gf_getItemObject("legion"):enter_scene(data.npc_id)
		gf_receive_client_prot({}, ClientProto.LegionViewClose)

	else
		local function sure_func()
			gf_getItemObject("legion"):star_legion_boss_c2s()	
		end
		local str = string.format(commom_string[5],data.need_food)
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(str,sure_func)

	end
end

function legionBoss:on_click(arg)
	local event_name = arg.name
	print("legionBoss event_name ",event_name)
	if event_name == "btnTrunIn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:hand_food_click()

	elseif event_name == "btnJoin" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:join_click()

	end
	
end

function legionBoss:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "HandInLegionBossFoodR") then
			self:init_ui()

		elseif id2 == Net:get_id2("alliance","StartLegionBossR") then
			gf_print_table(msg, "StartLegionBossR:")
			self:init_ui()
			self:start_scheduler()

		elseif id2 == Net:get_id2("alliance","UpdateLegionBossFoodR") then
			gf_print_table(msg, "UpdateLegionBossFoodR:")
			self:init_ui()
		elseif id2 == Net:get_id2("alliance", "GetMemberListR") then
			self:init_ui()
		
	
	
		end
	end
end

return legionBoss