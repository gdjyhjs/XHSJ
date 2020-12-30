--[[--
--日常活跃
-- @Author:Seven
-- @DateTime:2017-07-06 14:23:26
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local ActiveExplain = require("models.activeDaily.activeExplain")
local ActiveWeek = require("models.activeDaily.activeWeek")
local DailyEnum = require("models.activeDaily.dailyEnum")
local ActiveDailyView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
    Asset._ctor(self, "daily.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    
end)

-- 资源加载完成
function ActiveDailyView:on_asset_load(key,asset)
	self:hide_mainui()
end

function ActiveDailyView:init_info()
	self.view_open = true
	self:init_ui()
	self:register()
	local level = LuaItemManager:get_item_obejct("game").role_info.level
	self.item_obj:update_daily_data(level)
	local init_show = true 
	for k,v in pairs(self.item_obj.show_data) do
		if v.redpoint then
			self.item_obj:show_active_type(v.active_type)
			self.current_tab = v.active_type
			init_show = false
			break
		end
	end
	if init_show or LuaItemManager:get_item_obejct("guide"):get_step() ~=0 or self.item_obj.open_page then
		if self.item_obj.open_page then
			self.item_obj:show_active_type(self.item_obj.open_page)
			self.current_tab = self.item_obj.open_page
			self.item_obj.open_page= nil
		else
			self.item_obj:show_active_type(DailyEnum.ACTIVE_TYPE.DAILY)
			self.current_tab = DailyEnum.ACTIVE_TYPE.DAILY
		end
	end
	if self.current_tab ~=DailyEnum.ACTIVE_TYPE.DAILY then --设置页签
		self.refer:Get("tog_1"):SetActive(false)
		self.refer:Get("tog_".. self.current_tab):SetActive(true)
	end
	local data = {}
	for k,v in pairs(ConfigMgr:get_config("active_reward")) do
		 data[#data+1] = copy(v)
	end
	local sortFunc = function(a, b)
       	return a.active_num < b.active_num
    end
  	table.sort(data,sortFunc)
	for k,v in pairs(data) do
		self.refer:Get("txt_award"..k).text = v.active_num
	end
	self.max_active_num = data[#data].active_num
	self:refresh(self.item_obj.current_data)
	self:update_view()
end
function ActiveDailyView:init_ui()
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	for k,v in pairs(self.item_obj.award_data) do
		local obj = self.refer:Get("award"..k).gameObject
		if not v.show then
			gf_set_click_prop_tips(obj,v.reward)
		end
	end
end

function ActiveDailyView:register()
	self.item_obj:register_event("activeDaily_view_on_click",handler(self,self.on_click))
end

function ActiveDailyView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "daily_close" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		if self.activeexplain~=nil then
			self.activeexplain:dispose()
		end
		-- local x = ConfigMgr:get_config("daily")
		-- gf_print_table(x,"日常结束")
		self:hide()
	elseif string.find(cmd , "itemSysPropClick_" ) then
		if self.activeexplain~=nil then
			self.activeexplain:dispose()
		end
	elseif cmd == "title_item(Clone)" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_active(arg)
        
	elseif cmd == "active_join" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:join_active(arg)
	elseif cmd == "award1" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:get_award(1,obj)
	elseif cmd == "award2" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:get_award(2,obj)
	elseif cmd == "award3" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:get_award(3,obj)
	elseif cmd == "award4" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:get_award(4,obj)
	elseif cmd == "award5" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:get_award(5,obj)
	elseif cmd == "btn_week" then

        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.activeexplain~=nil then
			self.activeexplain:hide()
		end
		ActiveWeek(self.item_obj)
	elseif cmd == "daily_mask" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.activeexplain~=nil then
			self.activeexplain:hide()
		end
	elseif cmd == "daily" then --日常
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_tab(DailyEnum.ACTIVE_TYPE.DAILY)
	elseif cmd == "active" then --活动
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_tab(DailyEnum.ACTIVE_TYPE.ACTIVE)
	elseif cmd == "duplicate" then --副本
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_tab(DailyEnum.ACTIVE_TYPE.DUPLICATE)
	elseif cmd == "welfare" then --福利
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_tab(DailyEnum.ACTIVE_TYPE.WELFARE)
	end
end
--选中的
function ActiveDailyView:select_active(item,sf)
	if self.current_select_acitve then
		local img = self.current_select_acitve:Get("title_item")
		gf_setImageTexture(img,"scroll_table_cell_bg_02_normal")
	end
	gf_setImageTexture(item:Get("title_item"),"scroll_table_cell_bg_02_select")
	self.current_select_acitve = item
	self.item_obj:get_current_active(item.data)
	self.activeexplain = ActiveExplain(self.item_obj)
end

-- local ActiveDailyEnum = {
-- 	[1]=1001,	--天机任务
-- 	[2]=1002,	--护送美人
-- 	[3]=1003,	--摇钱树
-- 	[4]=1004,	--军团任务
-- 	[5]=1005,	--风云竞技
-- 	[6]=2001,	--金榜题名
-- 	[7]=3001,	--剧情副本
-- 	[8]=3002,	--过关斩将
-- 	[9]=3003,	--爬塔副本
-- 	[10]=3004,	--组队副本
-- 	[11]=3005,	--连环战船
-- 	[12]=1006,	--魔域修炼
-- 	[13]=2003,  --战场测试
-- 	[14]=2006, 	--3v3
-- 	[15]=2002,  --护送
-- 	[16]=2004,  --军团篝火
-- 	[17]=2005,  --军团宴会
-- 	[18]=3007,  --材料副本
-- 	[19]=1007,	--魔狱领主
-- 	[20]=2008,	--卡牌
-- 	[21]=2007,	--魔族围城
-- }

function ActiveDailyView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("task")) then
		if id2 == Net:get_id2("task","AcceptEveryDayTaskR")  then
			if msg.err == 0 then
				self:dispose()
			end
		end
	end
end
--参加
function ActiveDailyView:join_active(item,sf)
	if self.activeexplain~=nil then
		self.activeexplain:dispose()
	end
	self.item_obj:get_current_active(item.data)
	self.item_obj:active_enter(item.data)
	self:hide()
end

--请求获取奖励
function ActiveDailyView:get_award(num,obj)
	local data = self.item_obj.award_data[num]
	print("日常领取奖励",data.show)
	if data.show then
		print("日常领取",data.active_num)
		self.item_obj:get_daily_active_reward_c2s(data.active_num)
	else
		gf_set_click_prop_tips(obj,data.reward)
	end
end
--选择页签
function ActiveDailyView:select_tab(num)
	print("日常啊",self.current_tab)
	self.refer:Get("tog_".. self.current_tab):SetActive(false)
	self.refer:Get("tog_".. num):SetActive(true)
	self.current_tab = num
	print("日常啊",self.current_tab)
	self.item_obj:show_active_type(num)
	if self.current_select_acitve then
		local img = self.current_select_acitve:Get("title_item")
		gf_setImageTexture(img,"scroll_table_cell_bg_02_normal")
	end
	self:refresh(self.item_obj.current_data)
	if self.activeexplain ~=nil then
	 	self.activeexplain:hide()
	end
end

function ActiveDailyView:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1 ) --显示列表
end

function ActiveDailyView:update_item(item,index,data)
	item:Get("daily_name").text = data.name
	if data.show_times == 0 then
		item:Get("txt_show_times"):SetActive(false)
		item:Get("daily_times").text =""
	elseif data.show_times ~=999 then
		item:Get("txt_show_times"):SetActive(true)
		item:Get("daily_times").text = data.current_times .."/"..data.show_times
	else
		item:Get("txt_show_times"):SetActive(true)
		item:Get("daily_times").text =gf_localize_string("无限")
	end
	if data.max_active_times * data.per_active_val == 0 then
		item:Get("txt_show_daily"):SetActive(false)
		item:Get("active_value").text = ""
	else
		item:Get("txt_show_daily"):SetActive(true)
		item:Get("active_value").text = data.active_value.."/"..data.max_active_times * data.per_active_val
	end
	if data.show_time == 0 then
		item:Get("time").gameObject:SetActive(false)
	elseif	data.day_time[1] == 0 and data.day_time[3] == 24 then
		item:Get("time").text =gf_localize_string("全天")
		item:Get("time").gameObject:SetActive(true)
	else
		item:Get("time").gameObject:SetActive(true)
		if #data.day_time>4 then
			if os.date("%H",__NOW) * 60 + os.date("%M",__NOW) > data.day_time[3]*60+data.day_time[4]  then
				item:Get("time").text =string.format('%02d:%02d',data.day_time[5],data.day_time[6]).."-"..string.format('%02d:%02d',data.day_time[7],data.day_time[8])
			else
				item:Get("time").text =string.format('%02d:%02d',data.day_time[1],data.day_time[2]).."-"..string.format('%02d:%02d',data.day_time[3],data.day_time[4])
			end
		else
			item:Get("time").text =string.format('%02d:%02d',data.day_time[1],data.day_time[2]).."-"..string.format('%02d:%02d',data.day_time[3],data.day_time[4])
		end
	end
	if data.order == 1 then
		item:Get("active_join"):SetActive(true)
		item:Get("btn_join_txt").text = gf_localize_string("参加")
		if data.event == 24 and not LuaItemManager:get_item_obejct("functionUnlock"):check_ishave_fun(10) then --猎取天命特殊处理
			item:Get("btn_join_txt").text = gf_localize_string("可开启")
		end
		item:Get("open_condition").gameObject:SetActive(false)
		item:Get("overdue"):SetActive(false)
		item:Get("finish"):SetActive(false)
	elseif data.order == 2 then
		if #data.day_time>4 then
			if os.date("%H") * 60 + os.date("%M") > data.day_time[3]*60+data.day_time[4]  then
				item:Get("open_condition").text =string.format('%02d:%02d',data.day_time[5],data.day_time[6])..gf_localize_string("开启")
			else
				item:Get("open_condition").text = string.format('%02d:%02d',data.day_time[1],data.day_time[2])..gf_localize_string("开启")		
			end
		else
			item:Get("open_condition").text = string.format('%02d:%02d',data.day_time[1],data.day_time[2])..gf_localize_string("开启")
		end
		item:Get("open_condition").gameObject:SetActive(true)
		item:Get("active_join"):SetActive(false)
		item:Get("overdue"):SetActive(false)
		item:Get("finish"):SetActive(false)
	elseif data.order == 3 then	
		item:Get("overdue"):SetActive(true)
		item:Get("open_condition").gameObject:SetActive(false)
		item:Get("active_join"):SetActive(false)
		item:Get("finish"):SetActive(false)
	elseif data.order == 4 then
		item:Get("open_condition").text =gf_localize_string(data.level.."级开启")
		item:Get("open_condition").gameObject:SetActive(true)
		item:Get("active_join"):SetActive(false)
		item:Get("overdue"):SetActive(false)
		item:Get("finish"):SetActive(false)
	elseif data.order == 5 then
		item:Get("finish"):SetActive(true)
		item:Get("active_join"):SetActive(false)
		item:Get("open_condition").gameObject:SetActive(false)
		item:Get("overdue"):SetActive(false)
	end
	if data.redpoint then
		item:Get("red_point"):SetActive(true)
	else 
		item:Get("red_point"):SetActive(false)
	end
	 gf_setImageTexture(item:Get("icon"),data.icon)
end
--更新ui
function ActiveDailyView:update_view()
	self:check_page_redpront()
	self.refer:Get("all_active_value").text=self.item_obj.all_active_value
	local width  = self.item_obj.all_active_value /self.max_active_num * 636
	local height = 12
	self.refer:Get("all_value_condition").transform.sizeDelta =Vector2(width ,height)
	local award_effect = false --主界面奖励特效
	for k,v in pairs(self.item_obj.award_data) do
	 	if	self.item_obj.all_active_value >= v.active_num then
	 		if v.get then
	 			gf_setImageTexture(self.refer:Get("award"..k),v.icon)
	 			self.refer:Get("tx_award"..k):SetActive(false)
	 		else
	 			self.refer:Get("tx_award"..k):SetActive(true)
	 			award_effect = true
	 		end
	 		 self.refer:Get("award"..k).gameObject.name = "award"..k
	 		 v.show = true
	 	end
	end
	if not award_effect then
		self.item_obj:show_main_award(false)
	end
	self:refresh(self.item_obj.current_data)
end

function ActiveDailyView:active_find_npc(npc_id,map_id,ac_fn)
	local battle = LuaItemManager:get_item_obejct("battle")
	-- battle:find_task_target({sub_type = ServerEnum.TASK_SUB_TYPE.ESCORT}, npc_id, map_id, ac_fn)
	local data = ConfigMgr:get_config("map.mapMonsters")[map_id][ServerEnum.MAP_OBJECT_TYPE.NPC]
	local pos = 0
	for k,v in pairs(data) do
		if v.code == npc_id then
			pos = v.pos
		end
	end
	battle:move_to( map_id, pos.x, pos.y, ac_fn,1)
end

function ActiveDailyView:check_page_redpront()
	self.item_obj:page_redpoint()
	local tb = self.item_obj.redpoint_page_tb
	for i=1,3 do
		if tb[i] then
			self.refer:Get("red_point_"..i):SetActive(true)
		else
			self.refer:Get("red_point_"..i):SetActive(false)
		end
	end
end

function ActiveDailyView:on_hided()
	self.item_obj:register_event("activeDaily_view_on_click",nil)
	if self.refer ~=nil then
		self.refer:Get("tog_".. self.current_tab):SetActive(false)
		self.refer:Get("tog_1"):SetActive(true)
	end
	self.view_open = nil
	if self.activeexplain~=nil then
		self.activeexplain:dispose()
	end
end

function ActiveDailyView:on_showed()
	self:init_info()
end

-- 释放资源
function ActiveDailyView:dispose()
	self.item_obj:register_event("activeDaily_view_on_click",nil)
	self.view_open = nil
    self._base.dispose(self)
 end

return ActiveDailyView

