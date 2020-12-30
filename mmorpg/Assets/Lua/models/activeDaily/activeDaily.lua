--[[--
--日常活跃
-- @Author:Seven
-- @DateTime:2017-07-06 14:23:19
--]]
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PlayerPrefs = UnityEngine.PlayerPrefs
local Enum = require("enum.enum")
local ActiveDaily = LuaItemManager:get_item_obejct("activeDaily")
--UI资源
ActiveDaily.assets=
{
    View("activeDailyView", ActiveDaily) 
}

-- 获取开启的活动按钮
function ActiveDaily:get_open_btn_list()
	return self.open_btn_list
end

--点击事件
function ActiveDaily:on_click(obj,arg)
	self:call_event("activeDaily_view_on_click",false,obj,arg)
	return true
end

function ActiveDaily:open_activeDaily_view(num)
	if num and num <=3 then
		self.open_page = num
	end
	self:add_to_state()
end

-- function ActiveDaily:on_press_down(obj,eventData)
-- 	print("日常按下")
-- 	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
-- 	if cmd == "reward_item(Clone)" then
-- 		local data = obj:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectItem").data
-- 		print("日常物品",data)
-- 		gf_set_press_prop_tips(obj,data)
-- 	end
-- 	-- self:call_event("activeExplain_view_on_press_down",false,obj,click_pos)
-- 	-- return true
-- end
-- function ActiveDaily:on_press_up(obj,click_pos)
-- 	print("日常松手")
-- 	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
-- 	if cmd == "reward_item(Clone)" then
-- 		LuaItemManager:get_item_obejct("itemSys"):hide_item_tips()
-- 	end
-- 	-- self:call_event("activeExplain_view_on_press_up",false,obj,click_pos)
-- 	-- return true
-- end

--每次显示时候调用
function ActiveDaily:on_showed()
	
end

--初始化函数只会调用一次
function ActiveDaily:initialize()

end 
function ActiveDaily:init_info()
	self.current_daily_data = {}
	self.open_btn_list = {}
	self.open_red_list ={}
	self:init_data()
	self.current_day = os.date("%w",__NOW) --当前星期几
	self.all_active_value = 0 --总活跃度
	self:init_award()
	self:init_active_week()
end
--初始化表
function ActiveDaily:init_data()
	self.daily_data = {}
	local data= ConfigMgr:get_config("daily")
	for k,v in pairs(data) do
		-- table.insert(self.daily_data, v)
		self.daily_data[#self.daily_data+1] = copy(data[k])    --不改变原来配置表
		-- self.daily_data[#self.daily_data+1] = v
	end
	self.week_day = tonumber( os.date("%w",__NOW) )--当前星期几
	local week = tonumber(os.date("%W",__NOW) )--当前第几周
	local day = tonumber(os.date("%d",__NOW))
	for k,v in pairs(self.daily_data) do
		v.current_times = 0 --当前次数
		v.active_value = 0 --当前活跃
		v.open_day = false --是否是今天的活动
		if v.date_type == Enum.DAILY_DATE_TYPE.DAILY then  --每天
			v.open_day = true
		elseif v.date_type == Enum.DAILY_DATE_TYPE.WEEKLY then --星期几
			for i=1,#v.date_list do
				if v.date_list[i] == self.week_day then 
					v.open_day = true
					break
				end
			end
		elseif v.date_type == Enum.DAILY_DATE_TYPE.SINGLE_WEEKLY then --单周
			if week%2 ~=0 then
				v.open_day = true
			end
		elseif v.date_type == Enum.DAILY_DATE_TYPE.DOUBLE_WEEKLY then --双周
			if week%2 ==0 then
				v.open_day = true
			end
		elseif v.date_type == Enum.DAILY_DATE_TYPE.MONTHLY then --几号
			for i=1,#v.date_list do
				if day == v.date_list[i] then
					v.open_day = true
					break
				end
			end
		end
		if v.open_day then
			self.current_daily_data[#self.current_daily_data+1] = v
		end
	end
	gf_print_table(self.current_daily_data,"当天日常")
end
--初始化获得
function ActiveDaily:init_award()
	local data = ConfigMgr:get_config("active_reward")
	local sortFunc = function(a, b)
       	return a.active_num < b.active_num
    end
    local st = {}
    for k,v in pairs(data) do 
    	local x = #st+1
    	st[x] = copy(v)
    	st[x].show = false  --显示
    	st[x].get = false   --获得
    end
    table.sort(st,sortFunc)
    self.award_data=st 
    gf_print_table(st,"日常奖励")
end
--判断是否完成
function ActiveDaily:get_daily_over(d_id)
	for k,v in pairs(self.current_daily_data) do
		 if v.code == d_id and v.order == 5 then
		 	return true
		 end
	end
end

--更新表信息
function ActiveDaily:update_daily_data(lv)
	local date = {}
		for k,v in pairs(self.current_daily_data) do
			if  lv >= v.level then --开启等级
				v.open_lv = true
			else
				v.open_lv = false
			end

			local open_min = v.day_time[1]*60+v.day_time[2]
			local close_min = v.day_time[3]*60+v.day_time[4]
			local cur_min = os.date("%H",__NOW) * 60 + os.date("%M",__NOW)
			if #v.day_time>4 and cur_min>close_min then --活动有2个时间段
				open_min =  v.day_time[5]*60+v.day_time[6]
				close_min = v.day_time[7]*60+v.day_time[8]
			end
			if cur_min >= open_min and cur_min <= close_min then --开启时间（nil是未开启,true开启,false过期）
				v.open_time = true
				if v.redpoint ~=false and v.day_time[1]~=0 and v.day_time[3]~=24 and v.open_lv then
					v.redpoint = true  --红点
				end
			elseif cur_min > close_min then
				v.open_time = false
				v.redpoint = false
			else
				v.open_time = nil  --2段时间的关闭接口
				v.redpoint = false
			end
			--特殊次数show_type 
			if v.show_type== 1 then --摇钱次数
				v.show_times = ConfigMgr:get_config("t_misc").money_tree.shake_max_times
				local player_lv = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
				local times = ConfigMgr:get_config("vip")[player_lv].money_tree
				v.show_times = v.show_times + times --总次数
			elseif v.show_type == 2 then
				v.show_times = ConfigMgr:get_config("t_misc").arena.daily_challenge_times
				local player_lv = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
				local times = ConfigMgr:get_config("vip")[player_lv].arena_buy_times
				v.show_times = v.show_times +times
			end
			if v.current_times ~= v.show_times then  --未完成
				v.open_times = true
			else
				if v.finish_type ~= 0 and v.open_times ~=false then
					v.open_times = true
				else
					v.open_times = false
				end
			end
			if v.finish_type == 2 and LuaItemManager:get_item_obejct("husong"):get_today_times() == 0 then--双倍护送的完成
				v.open_times = false
			end
			if v.open_lv and v.open_time and v.open_times then --1先显示开启的,未完成的
				v.order = 1
				date[#date+1] = v 
			end
		end
		for k,v in pairs(self.current_daily_data) do
			if v.open_lv and v.open_time ==nil and v.open_times then --2达到等级但未达到时间，未完成 
				v.order = 2
				date[#date+1] = v 
			end
		end
		for k,v in pairs(self.current_daily_data) do
			if v.open_lv and v.open_time == false and v.open_times then --3达到等级但时间过了，未完成 
				if v.active_type == 2 and v.current_times>0 then
					v.order = 5
				else
					v.order = 3
				end
				date[#date+1] = v 
			end
		end
		for k,v in pairs(self.current_daily_data) do
			if not v.open_lv then --4等级未达到
				v.order = 4
				date[#date+1] = v 
			end
		end
		for k,v in pairs(self.current_daily_data) do
			if not v.open_times then --5已完成完成 
				v.order = 5
				date[#date+1] = v 
			end
		end

	local sortFunc = function(a, b)
		if a.order == b.order then
			return a.code < b.code
		else
       		return a.order <= b.order
       	end
    end
    local st = {}
    for k,v in pairs(date) do 
    	st[#st+1] = v 
    end
    table.sort(st,sortFunc)
    self.show_data = st
	-- gf_print_table(self.show_data,"日常show_data")
end

--显示日常
function ActiveDaily:show_active_type(num)
	self.current_data = {}
	for k,v in pairs(self.show_data) do
		if v.active_type == num then
			self.current_data[#self.current_data+1] = v
		end
	end
	local sortFunc = function(a, b)
		if a.order == b.order then
			return a.order_n < b.order_n
		else
       		return a.order <= b.order
       	end
    end
 	table.sort(self.current_data,sortFunc)
	gf_print_table(self.current_data,"日常cur_data")
end

function ActiveDaily:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("task")) then
		if id2 == Net:get_id2("task","GetDailyListR")  then 
			gf_print_table(msg,"日常1")
			gf_print_table(msg,"wtf receive GetDailyListR")
			self:get_daily_list_s2c(msg)
		elseif id2 == Net:get_id2("task","UpdateDailyInfoR")  then 
			gf_print_table(msg,"日常2")
			self:update_daily_info_s2c(msg)
		elseif id2 == Net:get_id2("task","DailyCheckJoinR")  then 	
			gf_print_table(msg,"日常3")
		elseif id2 == Net:get_id2("task","GetDailyActiveRewardR")  then 
			gf_print_table(msg,"日常4")
			self:get_daily_active_reward_s2c(msg)
		elseif id2 == Net:get_id2("task","DailyActivityStartR")  then --日常活动开启
			print("主界面土包1")
			self:daily_activity_start_s2c(msg)
		elseif id2 == Net:get_id2("task","DailyActivityEndR")  then --日常活动结束
			self:daily_icon_hide(msg.code)
		elseif id2 == Net:get_id2("task","AcceptEveryDayTaskR")  then
			gf_print_table(msg,"接受每日任务")
			self:accept_everyday_task_s2c(msg)
		elseif id2 == Net:get_id2("task","GetEveryDayTaskInfoR")  then	
			gf_print_table(msg,"每日任务")
			gf_print_table(msg,"wtf receive GetEveryDayTaskInfoR")
			self:get_everyday_taskinfo_s2c(msg)
		end
	elseif(id1==Net:get_id1("base"))then
		if id2 == Net:get_id2("base", "UpdateLvlR") then
        	self:update_player_lv(msg.level)
        	print("日常等级",msg.level)
		elseif id2 == Net:get_id2("base","OnNewDayR") then
			-- self:get_daily_list_c2s()
		elseif id2 == Net:get_id2("base","LoginR") then
			if msg.err == 0 then
				-- self:init_info()
				-- self:update_daily_data(msg.role.level)
				-- self.p_lv = msg.role.level
				-- print("日常登录等级",self.p_lv)
			end
		end
	end
end
--获取日常
function ActiveDaily:get_daily_list_s2c(msg)
	self:init_info()
	local level = LuaItemManager:get_item_obejct("game").role_info.level
	print("日常登录等级",level)
	self:update_daily_data(level)
	-- self:init_red_point()  --服务器推了
	self.all_active_value = msg.activeVal
	if #msg.dailyList ~= 0 then --日常次数
		for k,v in pairs(msg.dailyList) do
			for kk,vv in pairs(	self.daily_data) do
				if v.code == vv.code then
					vv.current_times = v.times
					vv.active_value = v.activeVal
				end
			end
		end
	end
	if #msg.activeRewardList ~=0 then --奖励
		for k,v in pairs(msg.activeRewardList) do
			for kk,vv in pairs(self.award_data) do
				if v.activeNum == vv.active_num then
					vv.get = true
				end
			end
		end
	end
	if #msg.nowOpeningList ~=0 then
		for k,v in pairs(msg.nowOpeningList) do
			local tb = {}
			tb.code = v
			local is_show = true
			for kk,vv in pairs(self.daily_data) do
				if vv.code == v and vv.name =="双倍护送" then
					is_show = self:check_husong_times()
				end
			end
			if is_show then
				self:daily_activity_start_s2c(tb)
			end
		end 
	end
	self:update_award_effect()
	self:show_active_redpoint()
	self:check_red_point()
	-- self:check_daily_task()
end
function ActiveDaily:get_daily_list_c2s()
	print("获取日常活动列表")
	Net:send({},"task","GetDailyList")
end
--更新日常
function ActiveDaily:update_daily_info_s2c(msg)
	self.all_active_value = msg.activeVal
	local da =  msg.daily
	for k,v in pairs(self.current_daily_data) do
		if da.code == v.code then
			if v.current_times == 0 then
				self:get_current_active(v)
			end
			v.current_times = da.times
			v.active_value = da.activeVal
		end
	end
	if self.assets[1].view_open then
		self.assets[1]:update_view()
	end
	self:update_award_effect()
end

function ActiveDaily:update_award_effect()
	local index = false
	for k,v in pairs(self.award_data) do
	 	if	self.all_active_value >= v.active_num then
	 		if not v.get then
	 			index = true
	 		end
	 	end
	end
	if index then
		self:show_main_award(true)
	else
		self:show_main_award(false)
	end
end
function ActiveDaily:is_have_award()
	for k,v in pairs(self.award_data) do
	 	if	self.all_active_value >= v.active_num then
	 		if not v.get then
	 			return true
	 		end
	 	end
	end
	return false
end

function ActiveDaily:show_main_award(tf)
	Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY ,visible = tf}, ClientProto.ShowAwardEffect)
end
--参与日常
function ActiveDaily:daily_check_join_s2c(msg)
	
end
function ActiveDaily:daily_check_join_c2s(d_id)
	Net:send({ code = d_id },"task","DailyCheckJoin")
end
--获取日常活跃度奖励
function ActiveDaily:get_daily_active_reward_s2c(msg)
	if msg.err == 0 then
		for k,v in pairs(self.award_data) do
			if v.active_num == msg.activeNum then
				v.get = true
			end
		end
		self.assets[1]:update_view()
		self:update_award_effect()
	end
end

function ActiveDaily:get_daily_active_reward_c2s(num)
	Net:send({ activeNum = num },"task","GetDailyActiveReward")
end

--更新等级
function ActiveDaily:update_player_lv(lv)
	for k,v in pairs(self.show_data) do
		if  lv >= v.level and v.open_lv == false then
			v.open_lv = true
			local open_min = v.day_time[1]*60+v.day_time[2]
			local close_min = v.day_time[3]*60+v.day_time[4]
			local cur_min = os.date("%H",__NOW) * 60 + os.date("%M",__NOW)
			if cur_min >= open_min and cur_min <= close_min and v.day_time[1]~=0 and v.day_time[3]~=24 then --开启时间（nil是未开启,true开启,false过期）
				v.redpoint = true
				self:show_red_point(true)
			end
		end
	end
	local data = ConfigMgr:get_config("daily")
	for k,v in pairs(data) do
		if v.active_type == 2 and v.main_icon and lv >= v.level then
			for kk,vv in pairs(self.open_btn_list) do
				if vv.code == v.code then
					return
				end
			end
			local open_min = v.day_time[1]*60+v.day_time[2]
			local close_min = v.day_time[3]*60+v.day_time[4]
			local cur_min = os.date("%H",__NOW) * 60 + os.date("%M",__NOW)
			if #v.day_time>4 then
				if close_min < cur_min then
					open_min = v.day_time[5]*60+v.day_time[6]
					close_min = v.day_time[7]*60+v.day_time[8]
				end
			end
			if cur_min >= open_min and cur_min <= close_min then --开启时间（nil是未开启,true开启,false过期）
				self.open_btn_list[#self.open_btn_list+1] = v
				Net:receive(v, ClientProto.MainUiShowDaily)
			end
		end
	end
end

--当前选中的活动
function ActiveDaily:get_current_active(data)
	self.cur_choose_data = data
	local redpoint_show = false
	for k,v in pairs(self.show_data) do
		if v.code ==  data.code then
			if v.redpoint then
				v.redpoint = false
				self:save_active_redpoint(data.code)
			end
		end
		if v.redpoint then
			redpoint_show = true
		end
	end
	if redpoint_show then
		self:show_red_point(true)
	else
		self:show_red_point(false)
	end
	if self.assets[1].view_open then
		self.assets[1]:update_view()
	end
end
--初始化周表
function ActiveDaily:init_active_week()
	self.week_data = {}
	local data = ConfigMgr:get_config("weekdaily")
	for i=1,#data do
		for k,v in pairs(data[i].id_list) do
			if v~=0 then
				self.week_data[#self.week_data+1] = self:get_active_info(v)
			else
				self.week_data[#self.week_data+1] = {code = 0}
			end
		end
	end
	print("日常周表",#self.week_data)
end

function ActiveDaily:get_active_info(d_id)
	local data = ConfigMgr:get_config("daily")
	for k,v in pairs(data) do
		if v.code == d_id then
			return v
		end
	end
end
-----------------------------------------------红点----------------------------------------------------------------
--红点协议
function ActiveDaily:show_red_point(tf)
	Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.ACTIVITY ,visible = tf}, ClientProto.ShowHotPoint)
end
--初始化红点
function ActiveDaily:is_have_red_point()
	-- self:update_daily_data()
	for k,v in pairs(self.show_data) do
		if v.redpoint then
			print("日常红点1")
			return true
		end
	end
	return false
end

--初始化红点
function ActiveDaily:init_red_point()
	local player_lv = LuaItemManager:get_item_obejct("game").role_info.level
	for k,v in pairs(self.show_data) do
		local open_min = v.day_time[1]*60+v.day_time[2]
		local close_min = v.day_time[3]*60+v.day_time[4]
		local cur_min = os.date("%H",__NOW) * 60 + os.date("%M",__NOW)
		if v.day_time[1]~=0 and v.day_time[3]~=24 then
			if cur_min >= open_min and cur_min <= close_min  and player_lv >= v.level then --开启时间（nil是未开启,true开启,false过期）
				v.redpoint = true
			end
		end
	end
end

--检查红点
function ActiveDaily:check_red_point()
	for k,v in pairs(self.show_data) do
		if v.redpoint then
			self:show_red_point(true)
			return
		end
	end
	self:show_red_point(false)
end

function ActiveDaily:check_daily_task()
	for k,v in pairs(self.daily_data) do
		if v.name == "天机任务" then
			if v.current_times>0 and v.current_times<10 then
				print("添加任务1111")
				LuaItemManager:get_item_obejct("task"):add_task(copy(ConfigMgr:get_config("task")[300000]))
				return
			end
		end
	end
end

function ActiveDaily:set_red_point(tb)
	local s = serpent.dump(tb)
	local p_id = LuaItemManager:get_item_obejct("game").role_id
	PlayerPrefs.SetString("Daily"..p_id,s)
end
function ActiveDaily:get_red_point()
	local p_id = LuaItemManager:get_item_obejct("game").role_id
	local s = PlayerPrefs.GetString("Daily"..p_id,"")
	print("日常s",s)
	if tb ~= "" then
		local tb = loadstring(s)()
		return tb
	end
end
--保存红点
function ActiveDaily:save_active_redpoint(d_id)
	if self.red_data == nil then self.red_data = {} end
	print("日常self.red_data",self.red_data)
	local tb = self.red_data
	local i = #tb+1
	tb[i]={}
	print("存红点")
	tb[i].code = d_id
	tb[i].year = os.date("%Y",__NOW)
	tb[i].mon = os.date("%m",__NOW)
	tb[i].day = os.date("%d",__NOW)
	self:set_red_point(tb)
end
--恢复红点
function ActiveDaily:show_active_redpoint()
	local p_id = LuaItemManager:get_item_obejct("game").role_id
	print("日常玩家id",p_id)
	if not PlayerPrefs.HasKey("Daily"..p_id) then
		local t = ""
		PlayerPrefs.SetString("Daily"..p_id,t)
	return 
	end
	self.red_data = self:get_red_point()
	local tb = self.red_data
	if tb == nil or #tb == 0 then return end
	local year  = os.date("%Y",__NOW)
	local mon  = os.date("%m",__NOW)
	local day  = os.date("%d",__NOW)
	if tb[1].year ~= year and tb[1].mon ~=mon and tb[1].day ~=day then
		PlayerPrefs.DeleteKey("Daily"..p_id)
		return
	end
	for i=1,#tb do  --恢复红点显示
		for k,v in pairs(self.current_daily_data) do
			if tb[i].code == v.code then
				v.redpoint = false
			end
		end
	end
end
--接取每日任务
function ActiveDaily:accept_everyday_task_s2c(msg)
	if msg.err == 0 then
		self.everday_task_curTimes = msg.curTimes
		LuaItemManager:get_item_obejct("task"):remove_task(1000001)
		local tb = gf_getItemObject("task"):get_task_list()
		for k,v in pairs(tb) do
			if v.type == ServerEnum.TASK_TYPE.EVERY_DAY then
				-- gf_receive_client_prot({code = v.code},ClientProto.HusongNPC)
			end
		end
	end
end
function ActiveDaily:accept_everyday_task_c2s()
	Net:send({},"task","AcceptEveryDayTask")
end
function ActiveDaily:get_everday_task_curTimes()
	return self.everday_task_curTimes
end

--每日任务
function ActiveDaily:get_everyday_taskinfo_s2c(msg)
	self.everday_task_curTimes = msg.curTimes
end
function ActiveDaily:get_everyday_taskinfo_c2s()
	Net:send({},"task","GetEveryDayTaskInfo")
end

-------------------------------------------------------------------------------------------------------------------
--通知完成
function ActiveDaily:daily_finish(d_id,tf)
	print("日常结束")
	for k,v in pairs(self.current_daily_data or {} ) do
		if d_id == v.finish_type then
			v.open_times = tf or true
		end
	end
end
--活动开启
function  ActiveDaily:daily_activity_start_s2c(msg)
	for k,v in pairs(self.show_data) do
		if v.code == msg.code then
			v.redpoint = true
		end
	end
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local data = ConfigMgr:get_config("daily")[msg.code]
	if data.main_icon and lv >= data.level then
		self.open_btn_list[#self.open_btn_list+1] = data
		Net:receive(data, ClientProto.MainUiShowDaily)
	elseif data.red_icon and lv >= data.level then
		self.open_red_list[#self.open_red_list+1] = data
		if not self.countdown then
			-- Net:receive(true, ClientProto.LegionActivityRedPoint)
			print("军团活动开启")
			-- self:daily_red_point()
			--军团红点
			if data.red_icon[1] == ClientEnum.MODULE_TYPE.LEGION and data.red_icon[2] == 1 then
				Net:receive({show=true,module=ClientEnum.MODULE_TYPE.LEGION,a=3,b=1}, ClientProto.UIRedPoint)
			elseif data.red_icon[1] == ClientEnum.MODULE_TYPE.LEGION and data.red_icon[2] == 2 then
				Net:receive({show=true,module=ClientEnum.MODULE_TYPE.LEGION,a=3,b=2}, ClientProto.UIRedPoint)
			end
		end
	end
end

function ActiveDaily:daily_red_point()
	self.countdown = Schedule(handler(self, function()
		for k,v in pairs(self.open_red_list) do
			if v.day_time[3]*60+v.day_time[4] <=  os.date("%H")*60 + os.date("%M") then
				v=nil
			end
		end
		if #self.open_red_list == 0 then
			Net:receive(false, ClientProto.LegionActivityRedPoint)
			self.countdown:stop()
			self.countdown = nil
		end
	end),5)
end

function ActiveDaily:check_husong_times()
	for k,v in pairs(self.daily_data) do
		if v.name == "护送美人" and v.current_times>= 3 then
			return false
		end
	end
	return true
end

function ActiveDaily:is_open_husong()
	local id = ConfigMgr:get_config("t_misc").escort.daily_code
	local d_lv = ConfigMgr:get_config("daily")[id].level
	local c_lv=LuaItemManager:get_item_obejct("game"):getLevel()
	return d_lv <= c_lv
end

--护送任务隐藏
function ActiveDaily:husong_daily_hide()
	local num = nil
	for k,v in pairs(self.open_btn_list) do
		if v.name == "双倍护送" then
			num = k
			self:daily_finish(v.code,false)
			break
		end
	end

	if num then
		Net:receive(self.open_btn_list[num], ClientProto.MainUiHideDaily)
		table.remove(self.open_btn_list,num)
	end
end



--活动隐藏
function ActiveDaily:daily_icon_hide(d_id)
	local num = nil
	if #self.open_btn_list == 0 then
		return
	end
	for k,v in pairs(self.show_data) do
		if v.code == d_id then
			v.redpoint = false
			break
		end
	end
	for k,v in pairs(self.open_btn_list) do
		if v.code == d_id then
			num = k
			break
		end
	end
	if num then
		self:daily_finish(d_id,false)
		Net:receive(self.open_btn_list[num], ClientProto.MainUiHideDaily)
		table.remove(self.open_btn_list,num)
	end
	local data = ConfigMgr:get_config("daily")[d_id]
	if data and data.red_icon then
		if data.red_icon[1] == ClientEnum.MODULE_TYPE.LEGION and data.red_icon[2] == 1 then
			Net:receive({show=false,module=ClientEnum.MODULE_TYPE.LEGION,a=3,b=1}, ClientProto.UIRedPoint)
		elseif data.red_icon[1] == ClientEnum.MODULE_TYPE.LEGION and data.red_icon[2] == 2 then
			Net:receive({show=false,module=ClientEnum.MODULE_TYPE.LEGION,a=3,b=2}, ClientProto.UIRedPoint)
		end
	end
	self:check_red_point()
end



--检查页签有没有红点
function ActiveDaily:page_redpoint()
	self.redpoint_page_tb ={} 
	for k,v in pairs(self.show_data) do
		if v.redpoint then
			self.redpoint_page_tb[v.active_type] = true
		end
	end
end

--获取活动是否存在(num读主界面按钮枚举)
function ActiveDaily:is_have_active(num)
	for k,v in pairs(self.open_btn_list or {}) do
		if v.main_icon and v.main_icon == num then
			return true
		end
	end
	return false
end

function ActiveDaily:get_daily_task_time()
	for k,v in pairs(self.current_daily_data) do
		if v.name == "天机任务" then
			return v.current_times,v.show_times
		end
	end
end
--活动入口
function ActiveDaily:active_enter(data)
	local cmd = data.event
	print("ActiveDailyViewcode",cmd)
	if cmd == 1 then
		gf_create_model_view("skyTask")
	elseif cmd == 2 then
		-- local ac_fn = function()
		-- 	gf_create_model_view("husong")
		-- end
		-- if item.data.find_npc == 1 then
		-- 	self:active_find_npc(item.data.npc_id,item.data.map_id,ac_fn)
		-- end
		if  LuaItemManager:get_item_obejct("husong"):is_husong() then
			gf_message_tips("正在护送")
			local husong_info = LuaItemManager:get_item_obejct("husong"):get_husong_info()
			Net:receive({code = husong_info.taskCode},ClientProto.HusongNPC)
		else
			LuaItemManager:get_item_obejct("husong"):transfer_husong()
		end
	elseif cmd ==  3 then
		gf_create_model_view("moneyTree")
	elseif cmd ==  4 then
		if gf_getItemObject("legion"):is_in() then
			LuaItemManager:get_item_obejct("legion"):accept_legion_task_c2s()
		else
			LuaItemManager:get_item_obejct("legion"):open_view()
		end
	elseif cmd ==  5 then
		gf_create_model_view("pvp")
	elseif cmd ==  6 then
		gf_create_model_view("exam")
	elseif cmd ==  7 then
		-- gf_getItemObject("copy"):create_copy_view(require("enum.enum").COPY_TYPE_VIEW.STORY)
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.STORY)
	elseif cmd ==  8 then
		-- gf_getItemObject("copy"):create_copy_view(require("enum.enum").COPY_TYPE_VIEW.HOLY)
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.HOLY)
	elseif cmd ==  9 then
		-- gf_getItemObject("copy"):create_copy_view(require("enum.enum").COPY_TYPE_VIEW.TOWER)
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.TOWER)
	elseif cmd ==  10 then
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.TEAM)
	elseif cmd ==  11 then
		gf_create_model_view("copy")
	elseif cmd ==  12 then
		gf_create_model_view("zorkPractice")
	elseif cmd ==  13 then	
		LuaItemManager:get_item_obejct("rvr"):add_to_state()
	elseif cmd == 14 then
		gf_create_model_view("pvp3v3")
	elseif cmd == 15 then
		-- local ac_fn = function()
		-- 	gf_create_model_view("husong")
		-- end
		-- if item.data.find_npc == 1 then
		-- 	self:active_find_npc(item.data.npc_id,item.data.map_id,ac_fn)
		-- end
		if  LuaItemManager:get_item_obejct("husong"):is_husong() then
			gf_message_tips("正在护送")
			local husong_info =  LuaItemManager:get_item_obejct("husong"):get_husong_info()
			Net:receive({code = husong_info.taskCode},ClientProto.HusongNPC)
		else
			if LuaItemManager:get_item_obejct("husong").todayTimes ~=0 then
				LuaItemManager:get_item_obejct("husong"):transfer_husong()
			else
				gf_message_tips("今天护送次数已达到上限")
			end
		end
	elseif cmd == 16 then
		local Legion = LuaItemManager:get_item_obejct("legion")
		if not	Legion:is_in() then 
			gf_message_tips("未加入军团")
			return 
		end
		LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(ConfigMgr:get_config("t_misc").alliance.legionMapId,nil,nil,true,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
	elseif cmd == 17 then
		local Legion = LuaItemManager:get_item_obejct("legion")
		if not	Legion:is_in() then 
			gf_message_tips("未加入军团")
			return
		end
		local map_id = ConfigMgr:get_config("t_misc").alliance.legionMapId
		local tb = ConfigMgr:get_config("map.mapMonsters")[map_id][ServerEnum.MAP_OBJECT_TYPE.NPC]
   		local pos = 0
   		local npc_id = data.npc_id
    	for k,v in pairs(tb) do
        	if v.code == npc_id then
            	pos = v.pos
       		end
    	end
		LuaItemManager:get_item_obejct("battle"):move_to(map_id, pos.x, pos.y,nil,1)
	elseif cmd == 18 then
		-- gf_getItemObject("copy"):create_copy_view(require("enum.enum").COPY_TYPE_VIEW.MATERIAL)
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.MATERIAL)
	elseif cmd == 19 then
		gf_create_model_view("boss")
	elseif cmd == 20 then
        print("七煞卡牌")
        gf_create_model_view("card")
    elseif cmd == 21 then
    	gf_create_model_view("mozu")
    elseif cmd == 22 then
    	if self.everday_task_curTimes and self.everday_task_curTimes ==0 then
    		if gf_getItemObject("task"):get_task( data.task_id ) then
    			gf_receive_client_prot({code = data.task_id},ClientProto.HusongNPC)
    		else
    			local tb = gf_get_config_table("task")[data.task_id]
				-- gf_getItemObject("task"):add_task(tb)
				gf_getItemObject("task"):set_task_status(tb.code, ServerEnum.TASK_STATUS.AVAILABLE)
				LuaItemManager:get_item_obejct("battle"):refresh_npc(tb)
				gf_receive_client_prot({}, ClientProto.RefreshTask)
				gf_receive_client_prot({code = data.task_id},ClientProto.HusongNPC)
			end
		else
			local tb = gf_getItemObject("task"):get_task_list()
			for k,v in pairs(tb) do
				if v.type == ServerEnum.TASK_TYPE.EVERY_DAY then
					gf_receive_client_prot({code = v.code},ClientProto.HusongNPC)
				end
			end
		end
	elseif cmd == 23 then
		LuaItemManager:get_item_obejct("equip"):set_open_mode(1)
		LuaItemManager:get_item_obejct("equip"):add_to_state()
	elseif cmd == 24 then
		if  LuaItemManager:get_item_obejct("functionUnlock"):check_ishave_fun(10) then
			LuaItemManager:get_item_obejct("player"):select_player_page(3,3)
			LuaItemManager:get_item_obejct("player"):add_to_state()
		else
			gf_message_tips("完成60级主线任务后开启")
		end
	elseif cmd == 25 then
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.MATERIAL)
	elseif cmd == 26 then
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.MATERIAL2)
	elseif cmd == 27 then
		 LuaItemManager:get_item_obejct("sign"):open_index_view(6)
	end
end

--获取可升级消息
function ActiveDaily:init_level_path()
	self.level_path_tb =  copy(ConfigMgr:get_config("level_path"))
end

function ActiveDaily:get_daily_lv(d_id)
	local data = ConfigMgr:get_config("daily")
	for k,v in pairs(data) do
		if v.code == d_id then
			return v.level
		end
	end
end