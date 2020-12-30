--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-01 17:14:03
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Sign = LuaItemManager:get_item_obejct("sign")
--UI资源
Sign.assets=
{
    View("signView", Sign)
}

--点击事件
function Sign:on_click(obj,arg)
	self:call_event("sign_view_on_click",false,obj,arg)
	return true
end

--每次显示时候调用
function Sign:on_showed()

end

--初始化函数只会调用一次
function Sign:initialize()
	self.keep_sign_day = 0
	self.redprint_tb = {}
	self.over_tb = {}
end

function Sign:open_index_view(index)
	self.goto_index = index
	self:add_to_state()
end

function Sign:is_have_red_point()
	print("sign奖励1",self.red_point)
 	return self.red_point or false
end 
--初始化福利奖励
function Sign:is_have_award()
	if not self.award_effect then return false end
	for k,v in pairs(self.award_effect) do
		if v then
			print("sign奖励2",v)
			return v
		end
	end	
	return false
end
--初始化15天奖励
function Sign:is_have_15award()
	return self.login_15award
end

function Sign:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("bag")) then
		if id2 == Net:get_id2("bag","GetSigninInfoR")then  -- 获取签到信息
			gf_print_table(msg,"wtf receive GetSigninInfoR")
			gf_print_table(msg,"获取签到信息")
			self:get_signin_info_s2c(msg)
		elseif id2 == Net:get_id2("bag","DragTodayGiftR")then  --今天签到
			self:drag_today_gift_s2c(msg)
		elseif id2 == Net:get_id2("bag","DragAccmulateGiftR")then--累计签到
			self:drag_accmulate_gift_s2c(msg)
		elseif id2 == Net:get_id2("bag","OnlineGiftInfoR")then  --获取在线时长的礼包
			gf_print_table(msg,"wtf receive OnlineGiftInfoR")
			self:online_gift_info_s2c(msg)
		elseif id2 == Net:get_id2("bag","DrawOnlineGiftR")then   --领取今天的时间礼包
			-- gf_print_table(msg,"领取今天的时间礼包")
			print("领取今天的时间礼包",msg.second)
			self:draw_online_gift_s2c(msg)
		elseif id2 == Net:get_id2("bag","DrawLastWeekOnlineGiftR")then   --领取今天的时间礼包
			self:draw_last_week_online_gift_s2c(msg)
		end
	elseif(id1 == Net:get_id1("base")) then
		if id2 == Net:get_id2("base","GetLevelGiftListR")then --获取等级礼包信息列表
			gf_print_table(msg,"wtf receive GetLevelGiftListR")
			self:get_level_gift_list_s2c(msg.levelGiftInfo)
		elseif id2 == Net:get_id2("base","GetLevelGiftR")then --获取等级礼包奖励
			self:get_level_gift_s2c(msg)
		elseif id2 == Net:get_id2("base","GetLoginGiftListR")then --15天登录奖励信息列表
			gf_print_table(msg,"15天")
			gf_print_table(msg,"wtf receive GetLoginGiftListR")
			self:get_login_gift_list_s2c(msg.loginGiftInfo)
		elseif id2 == Net:get_id2("base","GetLoginGiftR")then --获取15天登录奖励
			self:get_login_gift_s2c(msg)
		elseif id2 == Net:get_id2("base", "UpdateLvlR") then
			self:check_award_level(msg.level)
		elseif id2 == Net:get_id2("base","OnNewDayR") then 
			-- self:get_signin_info_c2s() --签到信息									--"bag","GetSigninInfo"
			-- self:online_gift_info_c2s() --签到信息									--"bag","OnlineGiftInfo"
			-- self:get_level_gift_list_c2s() --等级礼包信息							--"base","GetLevelGiftList"
			-- self:get_login_gift_list_c2s()--15天登录信息							--"base","GetLoginGiftList"
			-- self:invest_info_c2s()--投资信息										--"shop","InvestInfo"
			-- self:week_month_card_info_c2s()--月卡信息								--"shop","WeekMonthCardInfo"
			-- self:free_strenght_info_c2s()--体力午餐晚餐信息							--"shop","FreeStrenghtInfo"
			self:next_day_invest() --投资信息
		end
	elseif(id1 == Net:get_id1("shop")) then
		if id2 == Net:get_id2("shop","InvestInfoR")then --投资信息
			gf_print_table(msg,"wtf receive InvestInfoR")
			self:invest_info_s2c(msg)
		elseif id2 == Net:get_id2("shop","DoInvestR")then --投资
			self:do_invest_s2c(msg)
		elseif id2 == Net:get_id2("shop","DrawInvestGiftR")then --领投资的礼包
			self:draw_invest_gift_s2c(msg)
		elseif id2 == Net:get_id2("shop","WeekMonthCardInfoR") then --周卡月卡信息
			gf_print_table(msg,"wtf receive WeekMonthCardInfoR")
			self:week_month_card_info_s2c(msg)
		elseif id2 == Net:get_id2("shop","DrawWeekCardGiftR") then --周卡奖励
			self:draw_week_card_gift_s2c(msg)
		elseif id2 == Net:get_id2("shop","DrawMonthCardGiftR") then --月卡奖励
			self:draw_month_card_gift_s2c(msg)
		elseif id2 == Net:get_id2("shop","RechargeR") then --购买卡
			self:recharge_s2c(msg)
		elseif id2 == Net:get_id2("shop","FreeStrenghtInfoR") then --午餐晚餐信息
			gf_print_table(msg,"wtf receive FreeStrenghtInfoR")
			self:free_strenght_info_s2c(msg)
		elseif id2 == Net:get_id2("shop","GainFreeStrengthR") then --领取午餐晚餐
			self:gain_free_strength_s2c(msg)
		end
	end
end

------------------------------------------------------------签到-------------------------------------------------------
--获取签到信息
function Sign:get_signin_info_c2s()
	print("签到协议发送")
	Net:send({},"bag","GetSigninInfo")
	self.redprint_tb = {}
end
function Sign:get_signin_info_s2c(msg)
	self.keep_sign_day = msg.daysTotal
	self.todat_is_sign = msg.bIntTodayDraw
	self.cur_sign_group = msg.giftGroupId
	self.get_award_tb = msg.accmulateGiftIdArr
	--30天的奖励
	self.sign_data = {}
	local data = ConfigMgr:get_config("signin")
	if self.cur_sign_group == 0 then  --没有生效组的情况
		self.cur_sign_group = 1
	end
	if self.todat_is_sign == 0 then --今天没有签到
		self.today_sign = self.keep_sign_day+1
		self:show_red_point(true)
		self.red_point = true
		self.redprint_tb[1] = true
	end
	for k,v in pairs(data) do
		if v.group_id == self.cur_sign_group then
			local num = #self.sign_data+1
			self.sign_data[num] = copy(data[k])
			local tb = self.sign_data[num]
			if tb.days <= self.keep_sign_day then
				tb.open = true
			else
				tb.open = false
				if self.today_sign and tb.days == self.today_sign then
					tb.today = true
					self.cur_sign_id = tb.idx
				end
			end
		end
	end
	local sortFunc = function(a, b)
       	return a.days < b.days
    end
	table.sort(self.sign_data,sortFunc)
	--累计登录
	self.keep_sign_data = {}
	local dt = ConfigMgr:get_config("signin_accmulate")
	for k,v in pairs(dt) do
		if v.group_id == self.cur_sign_group then
			local num = #self.keep_sign_data + 1
			self.keep_sign_data[num] = copy(dt[k])
			if #self.get_award_tb ~= 0 then
				for kk,vv in pairs(self.get_award_tb) do
					if vv == v.days then
						self.keep_sign_data[num].open = true
					end
				end
			end
		end
	end
	table.sort(self.keep_sign_data,sortFunc)
	self:check_award_day(self.keep_sign_day)
end
--今天签到
function Sign:drag_today_gift_c2s()
	Net:send({},"bag","DragTodayGift")
end
function Sign:drag_today_gift_s2c(msg)
	print("今天签到cwm",msg.err)
	if msg.err == 0 then
		self.red_point = false
		self:show_red_point(false)
		self.sign_data[self.cur_sign_id].open = true
		self.sign_data[self.cur_sign_id].today = false
		self.keep_sign_day = self.keep_sign_day +1
		self.todat_is_sign = 1
		self:check_award_day(self.keep_sign_day)
		-- if self.assets[1].sign_child_view[1] then
		-- 	self.assets[1].sign_child_view[1]:update_info()
		-- end
	end
end
--领取累计签到
function Sign:drag_accmulate_gift_c2s(day)
	Net:send({days=day},"bag","DragAccmulateGift")
end
function Sign:drag_accmulate_gift_s2c(msg)
	if msg.err == 0 then
		for k,v in pairs(self.keep_sign_data) do
			if v.days == msg.days then
				v.open = true
			end
		end
		-- if self.assets[1].sign_child_view[1] then
		-- 	self.assets[1].sign_child_view[1]:update_info()
		-- end
		self:check_award_day(self.keep_sign_day)
	end
end

function Sign:find_cur_award(data)
	if #data == 0 then
		return
	end
	for k,v in pairs(data) do
		if not v.open then
			return k
		end
	end
	return #data
end
--检查是否有没领取的累计奖励
function Sign:check_award_day(day)
	local is_award = false
	for k,v in pairs(self.keep_sign_data) do
	 	if v.days <= day then
			if not v.open then
				v.open = false
				is_award = true
			end
		end
	end 
	if is_award then
		-- self:show_main_award(true)
		self:check_award(1,true)
		self.redprint_tb[1] = true
	else
		if self.todat_is_sign ~= 0 then
			self.redprint_tb[1] = false
			self:check_award(1,false)
			if self.assets[1].is_init then
				if self.assets[1].select_left_item then
					self.assets[1].select_left_item:Get(3):SetActive(false)
				end
			end
		end
	end
end

--红点协议
function Sign:show_red_point(tf)
	Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.SIGN ,visible = tf}, ClientProto.ShowHotPoint)
end
function Sign:show_main_award(tf)
	Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.SIGN ,visible = tf}, ClientProto.ShowAwardEffect)
end
--统一检查有没有奖励
function Sign:check_award(num,tf)
	if not self.award_effect then
		self.award_effect = {}
		self.show_award = false
	end
	self.award_effect[num] = tf
	local is_award = false
	for k,v in pairs(self.award_effect) do
		if v then
			is_award = true
			break
		end
	end
	if is_award then
		if not self.show_award then
			self:show_main_award(true)
			self.show_award = true
		end
	else
		if self.show_award then
			self:show_main_award(false)
			self.show_award = false
		end
	end
end

---------------------------------------------------------在线奖励---------------------------------------------------------

function Sign:init_online_data()
	local data = ConfigMgr:get_config("online_day")
	self.online_data = {}
	for k,v in pairs(data) do
		self.online_data[#self.online_data+1] =copy(v)
	end
	local sortFunc = function(a, b)
       	return a.time_seconds < b.time_seconds
    end
    table.sort(self.online_data,sortFunc)
end

--获取在线时长的礼包
function Sign:online_gift_info_c2s()
	Net:send({},"bag","OnlineGiftInfo")
end
function Sign:online_gift_info_s2c(msg)
	self:init_online_data()
	gf_print_table(msg,"获取在线时长的礼包")
	local now_time = Net:get_server_time_s()
	print("获取在线时长的礼包T",now_time)
	self.cur_online = now_time - msg.todayOnlineTm   --上线时间戳
	self.cur_week_online = now_time - msg.thisWeekOnlineTm
	for k,v in pairs(self.online_data) do
		if v.time_seconds <= msg.todayOnlineTm then
			v.open = true
			for kk,vv in pairs(msg.secondArr or {}) do
				if vv == v.time_seconds then
					 v.open = false
					 v.show = true
					 v.get_id = msg.protoIdArr[kk]
					for kkk,vvv in pairs(v.rand_table) do
						if vvv[2] == v.get_id then
							v.get_count = vvv[3]
						end
					end
				end
			end
		end
	end
	self.last_week_online = msg.lastWeekOnlineTm
	-- if self.last_week_online ~=0 then
	-- 	local level = LuaItemManager:get_item_obejct("game"):getLevel()
	-- 	local data =  ConfigMgr:get_config("online_week")[level]
	-- 	self.last_week_gold = math.floor(self.last_week_online/600)*data.bind_gold
	-- 	if self.last_week_gold  == 0 then
	-- 		self.last_week_online = 0
	-- 	elseif self.last_week_gold  > data.limit then
	-- 		 self.last_week_gold = data.limit
	-- 	end
	-- end
	self:chack_award_online()
	self:next_online_time()
end

--领取今天的时间礼包
function Sign:draw_online_gift_c2s(sc)
	Net:send({second=sc},"bag","DrawOnlineGift")
end
function Sign:draw_online_gift_s2c(msg)
	if msg.err == 0 then
		for k,v in pairs(self.online_data) do
			if v.time_seconds == msg.second then
				v.open = false
				v.get_id = msg.protoId
				for kk,vv in pairs(v.rand_table) do
					if vv[2] == v.get_id then
						v.get_count = vv[3]
					end
				end
			end
		end
		self:chack_award_online()
		self:next_online_time()
	end
	gf_mask_show(false)
end

--领取上周的时间礼包
function Sign:draw_last_week_online_gift_c2s()
	Net:send({},"bag","DrawLastWeekOnlineGift")
end

function Sign:draw_last_week_online_gift_s2c(msg)
	if msg.err == 0 then
		self.last_week_online = 0
		self:chack_award_online()
	end
	gf_mask_show(false)
end

function Sign:chack_award_online()
	local is_award = false
	for k,v in pairs(self.online_data) do
		if v.open then
			is_award = true
		end
	end
	if self.last_week_online ~=0 then
		is_award = true
	end
	if is_award then
		-- self:show_main_award(true)
		self:check_award(2,true)
		self.redprint_tb[2] = true
	else
		self.redprint_tb[2] =false
		if self.assets[1].is_init then
			if self.assets[1].select_left_item then
				self.assets[1].select_left_item:Get(3):SetActive(false)
			end
		end
		-- self:show_main_award(false)
		self:check_award(2,false)
	end
end

function Sign:count_award_online(t)
	self.ch_t = t
	if not self.countdown then
		self.countdown = Schedule(handler(self,self.count_down),5)
	end
end
function Sign:count_down()
	local now_time = Net:get_server_time_s()
	if now_time >= self.ch_t then
		self.online_cur_data.open = true
		self:chack_award_online()
		self.countdown:stop()
		self.countdown = nil
	end
end
function Sign:next_online_time()
	for k,v in pairs(self.online_data) do
		if v.open == nil and k ~= #self.online_data then
			local now_time = Net:get_server_time_s()
			local time = v.time_seconds+self.cur_online
			self.online_cur_data = v
			self:count_award_online(time)
			break
		end
	end
end

------------------------------等级礼包----------------------------------------
--获取等级礼包信息列表
function Sign:get_level_gift_list_c2s()
	Net:send({},"base","GetLevelGiftList")
end
function Sign:get_level_gift_list_s2c(msg)
	gf_print_table(msg,"等级礼包")
	local data = ConfigMgr:get_config("level_award")
	local lv =LuaItemManager:get_item_obejct("game"):getLevel()
	self.level_award_data ={}
	for k,v in pairs(data) do
		local x = #self.level_award_data+1
		self.level_award_data[x] = copy(v)
		if lv>= v.level then
			self.level_award_data[x].open = true
		end
	end
	local sortFunc = function(a, b)
       	return a.level < b.level
    end
	table.sort(self.level_award_data,sortFunc)
	for k,v in pairs(msg or {}) do
		for kk,vv in pairs(self.level_award_data) do
			if vv.level == v.level  then
				if v.isRewarded == 1 then
					vv.open = false
				end
				vv.count = v.restCount
			end
		end
	end
	self:check_award_level(lv)
end

--获取等级礼包奖励
function Sign:get_level_gift_c2s(lv)
	Net:send({level = lv},"base","GetLevelGift")
end
function Sign:get_level_gift_s2c(msg)
	if msg.err == 0 then
		local is_award = false
		for k,v in pairs(self.level_award_data) do
			if v.level == msg.level then
				v.open = false
				-- if self.assets[1].sign_child_view[3]  then
				-- 	self.assets[1].sign_child_view[3]:update_view()
				-- end
			end
			if v.open then
				is_award = true
			end
		end
		if self.assets[1].is_init and not is_award then
			self.assets[1].select_left_item:Get(3):SetActive(false)
		end
		self:check_award_level(LuaItemManager:get_item_obejct("game"):getLevel())
	end
end
function Sign:check_award_level(lv)
	local is_award = false
	for k,v in pairs(self.level_award_data or {}) do
		if v.open then
			is_award = true
			if v.count and v.count==0 then
				is_award = false
			end
			if is_award then
				break
			end
		end
		if lv>= v.level and v.open == nil and (v.count and v.count>0 )then
			v.open = true
			is_award = true
			break
		end
	end
	if is_award then
		self.redprint_tb[3] = true
		-- self:show_main_award(true)
		self:check_award(3,true)
	else
		self.redprint_tb[3] = false
		-- self:show_main_award(false)
		self:check_award(3,false)
		if self.assets[1].is_init then
			if self.assets[1].select_left_item then
				self.assets[1].select_left_item:Get(3):SetActive(false)
			end
		end
	end
end
--------------------------------15天登录奖励-------------------------------------------
--15天登录奖励信息列表
function Sign:get_login_gift_list_c2s()
	Net:send({},"base","GetLoginGiftList")
end
function Sign:get_login_gift_list_s2c(msg)
	local data = ConfigMgr:get_config("login_15")
	self.login_15 = {}
	for k,v in pairs(data) do
		self.login_15[#self.login_15+1] =copy(v)
	end
	for k,v in pairs(msg or {}) do
		for kk,vv in pairs(self.login_15) do
			if vv.day == v.day then
				if  v.state == 0 then
					vv.open = true
				else
					vv.open = false
				end
			end
		end
	end
	local sortFunc = function(a, b)
       	return a.day < b.day
    end
    table.sort(self.login_15,sortFunc)
	self.login_today = #msg or 0
	print("15天",self.login_today)
	self:check_award_login()
end	
--获取15天登录奖励
function Sign:get_login_gift_c2s(num)
	Net:send({day = num},"base","GetLoginGift")
end
function Sign:get_login_gift_s2c(msg)
	if msg.err == 0 then
		print("15天礼包",msg.day)
		for k,v in pairs(self.login_15) do
			if v.day == msg.day then
				v.open = false
				Net:receive(nil, ClientProto.Login15Day)
				self:check_award_login()
				return
			end
		end
	end
end	

function Sign:check_award_login()
	local is_award = false
	for k,v in pairs(self.login_15 or {}) do
		if v.open then
			is_award = true
		end
	end
	if is_award then
		self.login_15award = true
		self:login_redprint(true)
	else
		self.login_15award = false
		self:login_redprint(false)
		if self.login_today == 15 then
			self.login_15_over = true
			Net:receive({ id = ClientEnum.MAIN_UI_BTN.LOGIN ,visible = false}, ClientProto.ShowOrHideMainuiBtn)
		end
	end
end

function Sign:login_15_isover()
	return self.login_15_over
end

function Sign:login_redprint(tf)
	Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.LOGIN ,visible = tf}, ClientProto.ShowAwardEffect)
end
----------------------------------------------------投资基金--------------------------------------------------------
--投资信息
function Sign:invest_info_c2s()
	Net:send({},"shop","InvestInfo")
end
function Sign:invest_info_s2c(msg)
	gf_print_table(msg,"投资啊")
	print("投资",msg.status)
	print("投资",#msg.days)
	print("投资",msg.investStartTimestamp)
	self.invest_data = copy(ConfigMgr:get_config("investment"))
	self.invest_status = msg.status
	if self.invest_status ~= 0 then
		self.invest_day =  gf_time_diff(Net:get_server_time_s(),msg.investStartTimestamp).day
		self.invest_day = self.invest_day+1
		if self.invest_day>#self.invest_data then
			self.invest_day = #self.invest_data
		end
		print("投资",self.invest_day)
		for i=1,self.invest_day do
			self.invest_data[i].open = true
		end
		for k,v in pairs(msg.days) do
			self.invest_data[v].open = false
		end
		self:check_invest_award()
	else
		self:check_award(5,true)
		self.redprint_tb[5] = true
	end
	self:sort_invest_award()
	-- self:check_invest_over()
end

function Sign:next_day_invest()
	if self.invest_status ~= 0 then
		if self.invest_day~=#self.invest_data then
			self.invest_day = self.invest_day+1
		else
			return
		end
		self.invest_data[self.invest_day].open = true
		self:check_invest_award()
	end
end

--投资
function Sign:do_invest_c2s()
	Net:send({},"shop","DoInvest")
end
function Sign:do_invest_s2c(msg)
	if msg.err == 0 then
		self.invest_status = 1
		self.invest_data[1].open = true
		-- if self.assets[1].sign_child_view[5]  then
		-- 	self.assets[1].sign_child_view[5]:update_view()
		-- end
		self:check_invest_award()
	end
	gf_mask_show(false)
end
--领投资的礼包
function Sign:draw_invest_gift_c2s(gift_day)
	Net:send({day = gift_day},"shop","DrawInvestGift")
end
function Sign:draw_invest_gift_s2c(msg)
	gf_print_table(msg,"投资")
	if msg.err == 0 then
		if msg.day then
			for k,v in pairs(self.invest_data) do
				if v.day == msg.day then
					v.open = false
					break
				end
			end
			-- self:sort_invest_award()
			-- if self.assets[1].sign_child_view[5]  then
			-- 	self.assets[1].sign_child_view[5]:update_view()
			-- end
		end
		self:check_invest_award()
		-- self:check_invest_over()
	end
	gf_mask_show(false)
end

function Sign:check_invest_award()
	local is_award = false
	for k,v in pairs(self.invest_data) do
		if v.open then
			is_award = true
			break
		end
	end
	if is_award then
		self:check_award(5,true)
		self.redprint_tb[5] = true
		if self.assets[1].is_init then
			if self.assets[1].select_left_item then
				self.assets[1].select_left_item:Get(3):SetActive(true)
			end
		end
	else
		self:check_award(5,false)
		self.redprint_tb[5] = false
		if self.assets[1].is_init then
			if self.assets[1].select_left_item then
				self.assets[1].select_left_item:Get(3):SetActive(false)
			end
		end
	end
end
function Sign:sort_invest_award()
	local tb1 = {}
	local tb2 = {}
	for k,v in pairs(self.invest_data) do
		if v.open or v.open == nil  then
			tb1[#tb1+1] = v
		else
			tb2[#tb2+1] = v
		end
	end
	local sortFunc = function(a, b)
       	return a.day < b.day
    end
    table.sort(tb1,sortFunc)
    table.sort(tb2,sortFunc)
    for k,v in pairs(tb2) do
    	tb1[#tb1+1] = v
    end
    self.invest_data  = tb1
end

function Sign:check_invest_over()
	local is_over = true
	for k,v in pairs(self.invest_data) do
		if v.open == false then
			is_over = false
		end
	end
	if is_over then
		self.over_tb[5] = true
	else
		self.over_tb[5] = false
	end
end


----------------------------------------------月卡-------------------------------------------------
--周卡月卡信息
function Sign:week_month_card_info_c2s()
	Net:send({},"shop","WeekMonthCardInfo")
end
function Sign:week_month_card_info_s2c(msg)
	gf_print_table(msg,"周卡月卡信息")
	self.week_data = {}
	self.month_data = {}
	local data = ConfigMgr:get_config("week_month_card")
	for k,v in pairs(data) do
		if v.type == ServerEnum.RECHARGE_TYPE.WEEK_CARD then
			self.week_data[#self.week_data+1] = copy(v)
		elseif v.type == ServerEnum.RECHARGE_TYPE.MONTH_CARD then
			self.month_data[#self.month_data+1] = copy(v)
		end
	end
	local sortFunc = function(a, b)
       	return a.level < b.level
    end
	table.sort(self.week_data,sortFunc)
	table.sort(self.month_data,sortFunc)
	self.timestamp_week =  msg.timestamp[1]
	self.timestamp_month =  msg.timestamp[2]
	if msg.timestamp[1] ~= 0 then
		self.drawGiftTimestamp_week = os.date("%Y%m%d",msg.drawGiftTimestamp[1])
		print("周卡月卡信息1",self.drawGiftTimestamp_week)
	end
	if msg.timestamp[2] ~= 0 then
		self.drawGiftTimestamp_month = os.date("%Y%m%d",msg.drawGiftTimestamp[2])
		print("周卡月卡信息2",self.drawGiftTimestamp_month)
	end
	if self.timestamp_week == 0 and self.timestamp_month == 0 then
		self:check_award(4,true)
		self.redprint_tb[4] = true
	elseif gf_time_diff(os.date("%Y%m%d",Net:get_server_time_s(),self.timestamp_week)).day>7 or gf_time_diff(os.date("%Y%m%d",Net:get_server_time_s(),self.timestamp_month)).day>30  then
		self:check_award(4,true)
		self.redprint_tb[4] = true
	else
		self:week_month_card_award()
	end
end
function Sign:is_week_card()
	if self.timestamp_week == 0  then return false end
	return gf_time_diff(os.date("%Y%m%d",Net:get_server_time_s(),self.timestamp_week)).day<7
end
function Sign:is_month_card()
	if  self.timestamp_month == 0 then return false end
	return gf_time_diff(os.date("%Y%m%d",Net:get_server_time_s(),self.timestamp_month)).day<30 
end
--领取周卡奖励
function Sign:draw_week_card_gift_c2s()
	Net:send({},"shop","DrawWeekCardGift")
end
function Sign:draw_week_card_gift_s2c(msg)
	print("卡卡lq1",msg.err)
	if msg.err == 0 then
		self.drawGiftTimestamp_week = os.date("%Y%m%d",Net:get_server_time_s())
		-- if self.assets[1].sign_child_view[4] then
		-- 	self.assets[1].sign_child_view[4]:update_view()
		-- end
		self:week_month_card_award()
	end
end
--领取月卡奖励
function Sign:draw_month_card_gift_c2s()
	Net:send({},"shop","DrawMonthCardGift")
end
function Sign:draw_month_card_gift_s2c(msg)
	print("卡卡lq2",msg.err)
	if msg.err == 0 then
		self.drawGiftTimestamp_month = os.date("%Y%m%d",Net:get_server_time_s())
		-- if self.assets[1].sign_child_view[4]  then
		-- 	self.assets[1].sign_child_view[4]:update_view()
		-- end
		self:week_month_card_award()
	end
end
--购买周卡月卡
function Sign:recharge_c2s(c_id)
	local id = nil
	for k,v in pairs(ConfigMgr:get_config("recharge")) do
		if v.type == c_id then
			id = v.charge_id
		end
	end
	if id then
		Net:send({chargeId = id},"shop","Recharge")
	end
end
function Sign:recharge_s2c(msg)
	if msg.err == 0 then
		local c_id = ConfigMgr:get_config("recharge")[msg.chargeId].type
		if  c_id == ServerEnum.RECHARGE_TYPE.WEEK_CARD then
			self.timestamp_week = Net:get_server_time_s()
			self.drawGiftTimestamp_week = "0"
		elseif c_id == ServerEnum.RECHARGE_TYPE.MONTH_CARD then
			self.timestamp_month = Net:get_server_time_s()
			self.drawGiftTimestamp_month = "0"
		end
		-- if self.assets[1].sign_child_view[4]  then
		-- 	self.assets[1].sign_child_view[4]:update_view()
		-- end
		self:week_month_card_award()
	end
end


--检测月卡周卡奖励奖励
function Sign:week_month_card_award()
	local is_award = nil
	if self.timestamp_week ~=0 and gf_time_diff(Net:get_server_time_s(),self.timestamp_week).day<=7 then
		if os.date("%Y%m%d",Net:get_server_time_s()) ~= self.drawGiftTimestamp_week then
			is_award = true
		end
	end
	if self.timestamp_month ~=0 and gf_time_diff(Net:get_server_time_s(),self.timestamp_month).day<=30 then
		if os.date("%Y%m%d",Net:get_server_time_s()) ~= self.drawGiftTimestamp_month then
			is_award = true
		end
	end
	if is_award then
		-- self:show_main_award(true)
		self:check_award(4,true)
		self.redprint_tb[4] = true
		if self.assets[1].select_left_item then
			self.assets[1].select_left_item:Get(3):SetActive(true)
		end
	else
		self:check_award(4,false)
		self.redprint_tb[4] = false
		if self.assets[1].is_init then
			if self.assets[1].select_left_item then
				self.assets[1].select_left_item:Get(3):SetActive(false)
			end
		end
	end
end

-----------------------------------------晚餐-----------------------------------------------------
--午餐晚餐信息
function Sign:free_strenght_info_c2s()
	Net:send({},"shop","FreeStrenghtInfo")
end
function Sign:free_strenght_info_s2c(msg)
	gf_print_table(msg,"体力信息1")
	local data = ConfigMgr:get_config("t_misc").free_strenght
	self.free_strenght_tb = {}
	for i=1,2 do
		self.free_strenght_tb[i] = {time = data.time_region_hour[i],strength = data.strength[i],needgold = data.needgold[i],open = msg.freeStrength[i]}
	end
	self:check_stength_award()
end
--领取体力
function Sign:gain_free_strength_c2s(ty,f_ty)
	gf_mask_show(true)
	Net:send({type = ty,freeType = f_ty},"shop","GainFreeStrength")
end
function Sign:gain_free_strength_s2c(msg)
	gf_print_table(msg,"体力信息2")
	if msg.err == 0 then
		self.free_strenght_tb[msg.freeType].open = 1
		-- gf_message_tips("获得体力"..self.free_strenght_tb[msg.freeType].strength)
		self:check_stength_award()
	end
	gf_mask_show(false)
end

function Sign:check_stength_award()
	local is_award = false
	local time = tonumber(os.date("%H",Net:get_server_time_s()))
	for k,v in pairs(self.free_strenght_tb) do
		if v.open == 0 then
			if time >= v.time[1] then
				is_award = true
			end
		end
	end
	if is_award then
		self:check_award(6,true)
		self.redprint_tb[6] = true
		if self.assets[1].is_init then
			if self.assets[1].select_left_item then
				self.assets[1].select_left_item:Get(3):SetActive(true)
			end
		end
	else
		self:check_award(6,false)
		self.redprint_tb[6] = false
		if self.assets[1].is_init then
			if self.assets[1].select_left_item then
				self.assets[1].select_left_item:Get(3):SetActive(false)
			end
		end
	end
end
function Sign:player_no_gold()
	self:check_award(6,false)
	self.redprint_tb[6] = false
	if self.assets[1].is_init then
		if self.assets[1].select_left_item then
			self.assets[1].select_left_item:Get(3):SetActive(false)
		end
	end
end