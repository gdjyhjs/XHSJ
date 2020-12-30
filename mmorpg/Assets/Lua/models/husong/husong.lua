--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-01 17:18:52
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Husong = LuaItemManager:get_item_obejct("husong")
--UI资源
Husong.assets=
{
    View("husongView", Husong) 
}

--点击事件
function Husong:on_click(obj,arg)
	self:call_event("husong_view_on_click",false,obj,arg)
end

--每次显示时候调用
function Husong:on_showed()

end

--初始化函数只会调用一次
function Husong:initialize()
	self:init_info()
	-- self:init_icon()
end

function Husong:init_info()
	self.husong_data = {}
	local data = ConfigMgr:get_config("task")
	for k,v in pairs(data) do
		if v.type ==ServerEnum.TASK_TYPE.ESCORT then
			if #self.husong_data ~=0 then
				local ok = true
				for kk,vv in pairs(self.husong_data) do
					if vv.level == v.level then
						ok = false  --break
					end
				end
				if ok then
					self.husong_data[#self.husong_data+1] = copy(v)
				end
			else
				self.husong_data[#self.husong_data+1] = copy(v)
			end	
		end
	end

	local sortFunc = function(a, b)
       	return a.level < b.level
    end
	table.sort(self.husong_data,sortFunc)
	-- print("护送排序",#self.husong_data)
	-- gf_print_table(self.husong_data,"护送排序")
end



function Husong:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("task")) then
		if id2 == Net:get_id2("task","EscortOpenUIR")  then
			gf_print_table(msg,"护送开启ui")
			gf_print_table(msg,"wtf receive EscortOpenUIR")
			self:escort_openui_s2c(msg)
		elseif id2 == Net:get_id2("task","EscortFreshQualityR")  then
			gf_print_table(msg,"护送刷新品质")
			self:escort_fresh_quality_s2c(msg)
		elseif id2 == Net:get_id2("task","EscortSetOnekeyRemindR")  then
			self:escort_set_onekey_remind_s2c(msg)
		elseif id2 == Net:get_id2("task","EscortTaskInfoR")  then
			gf_print_table(msg,"护送任务信息")
			self:escort_task_info_s2c(msg)
		elseif id2 == Net:get_id2("task","EscortAcceptTaskR")  then
			gf_print_table(msg,"接受护送任务")
			self:escort_accept_task_s2c(msg)
		elseif id2 == Net:get_id2("task","GetTaskR")  then  --取得任务信息
			self:husong_get_task_s2c(msg.list)
		elseif id2 == Net:get_id2("task","EscortFinishR")  then  --完成护送
			gf_print_table(msg,"完成护送任务")
			self:escort_finish_s2c(msg)
		end
	elseif id1==Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			-- self:transfer_map_s2c(msg)
		end
	elseif id1==ClientProto.TransferMapFinish then
		print("护送回调")
		self:transfer_map_s2c(msg)
	elseif(id1==Net:get_id1("base"))then
		if id2 == Net:get_id2("base","OnNewDayR") then
			-- self:escort_openui_c2s()
		end
	end
end

function Husong:get_today_times( )
	return self.todayTimes
end

--初始化品质
function Husong:escort_openui_s2c(msg)
	self.quality = msg.quality
	self.onekeyRemind = msg.onekeyRemind
	self.refreshTimes = msg.refreshTimes
	if msg.todayTimes == nil then 
		self.todayTimes = 3
		return
	end
	self.todayTimes = 3 - msg.todayTimes
	self.quality5Times = msg.quality5Times
end
--初始化请求
function Husong:escort_openui_c2s()
	Net:send({}, "task", "EscortOpenUI")
end
--刷新品质
function Husong:escort_fresh_quality_s2c(msg)
	if msg.err == 0 then
		self.quality = msg.quality
		self.refreshTimes = msg.refreshTimes
		self.assets[1]:choose_img(msg.quality,false)
		self.assets[1]:update_free_remain(msg.refreshTimes)
	end
end
--刷新（#1:一键橙色 0:刷新一次）
function Husong:escort_fresh_quality_c2s(num)
	print("刷新发送",num)
	local msg = {isOnekey = num}
	Net:send(msg, "task", "EscortFreshQuality")
end
--护送任务设置今日一键橙色不再出现确认框
function Husong:escort_set_onekey_remind_s2c(msg)
	print("护送任务设置今日一键橙色不再出现确认框",msg.onekeyRemind)
end
--发送护送任务设置今日一键橙色不再出现确认框
function Husong:escort_set_onekey_remind_c2s(num)
	print("发送不再出现确认框",num)
	local msg = {onekeyRemind = num}
	Net:send(msg, "task", "EscortSetOnekeyRemind")
end

--护送任务信息
function Husong:escort_task_info_c2s()
	Net:send({}, "task", "EscortTaskInfo")
end
function Husong:escort_task_info_s2c(msg)
	self:update_husong_info(msg)
	self:update_main_husong_ui(true)
	self:player_speed_down()
	LuaItemManager:get_item_obejct("battle"):check_npc_follow(self.husong_task)
end

--接受护送任务
function Husong:escort_accept_task_c2s()
 	Net:send({}, "task", "EscortAcceptTask")
end 
function Husong:escort_accept_task_s2c(msg)
 	if msg.err == 0 then
 		self.todayTimes = self.todayTimes-1
 		print("护送顺序11")
		self:update_husong_info(msg.taskInfo)
		self.assets[1]:dispose()
		self:update_main_husong_ui(true)
		if LuaItemManager:get_item_obejct("horse"):is_ride() then
			LuaItemManager:get_item_obejct("horse"):send_to_ride_ex()
		end
		self:player_speed_down()
		local data = LuaItemManager:get_item_obejct("task"):get_task_list()
		for k,v in pairs(data) do
			if v.code == self.task_code then
				LuaItemManager:get_item_obejct("battle"):check_npc_follow(v)
				return
			end
		end
 	end
end 

function Husong:update_husong_info(data)
	self.husong_finish_time = data.endTime
	self.current_beauty = data.quality
	self.beauty_quality = data.quality
	self.isExpired = data.isFail
	self.task_code = data.taskCode
	self.husong_info = data
	-- local tb = ConfigMgr:get_config("task")[self.task_code]
	-- LuaItemManager:get_item_obejct("battle"):check_npc_follow(tb)
end

function Husong:get_husong_info()
	return self.husong_info
end

function Husong:is_husong()
	-- print("护送测试3",self.husong_finish_time ~=nil)
	return self.husong_finish_time ~=nil 
end

function Husong:husong_get_task_s2c(msg)
	if #msg == 0 or not msg then
		return
	end
 	gf_print_table(msg,"是否有护送任务")
	local data = ConfigMgr:get_config("task")
	for k,v in pairs(msg) do
		if data[v.code].type == ServerEnum.TASK_TYPE.ESCORT  then  --护送任务类型
			self.husong_task = copy(data[v.code])
			self.husong_task.status = ServerEnum.TASK_STATUS.PROGRESS
			self:escort_task_info_c2s()
			return
		end
	end
end

function Husong:update_main_husong_ui(tf)
	Net:receive({tf},ClientProto.HusongLeftUI)
end

--完成护送
function Husong:escort_finish_ok_c2s()
	print("完成护送任务1")
	Net:send({}, "task", "EscortFinish")
end
function Husong:escort_finish_fail_c2s()
	print("完成护送任务1")
	Net:send({}, "task", "EscortFinish")
end
function Husong:escort_finish_s2c(msg)
	if msg.err == 0 then
		self.husong_finish_time = nil
		if self.beauty_quality == 5 then
			self.quality5Times = self.quality5Times+1
		end
		self.current_beauty = nil
		self.husong_task_id = msg.code
		self.isDouble = msg.isDouble
		self.isExpired = msg.isExpired
		self:update_main_husong_ui(false)
		require("models.husong.husongClearing")()
		self:player_speed_up()
		if self.todayTimes == 0 then
			LuaItemManager:get_item_obejct("activeDaily"):daily_finish(2,false)
			if self.isDouble == 1 then
				LuaItemManager:get_item_obejct("activeDaily"):husong_daily_hide()
			end
		end
	end
end

function Husong:get_husong_beauty()
	return self.current_beauty
end

-- function Husong:init_icon()
-- 	local hour = os.date("%H",__NOW)
-- 	self.doubleHours = ConfigMgr:get_config("t_misc").escort.double_reward_hour
-- 	self.double_time = self.doubleHours[tonumber(hour)] or 0
-- 	if self.double_time ~= 0 then
-- 		Net:receive({id=ClientEnum.MAIN_UI_BTN.ESCOR,visible = true},ClientProto.ShowOrHideMainuiBtn)
-- 		self:count_open_icon(true)
-- 	else
-- 		Net:receive({id=ClientEnum.MAIN_UI_BTN.ESCOR,visible = false},ClientProto.ShowOrHideMainuiBtn)
-- 		self:count_open_icon(false)
-- 	end
-- end

-- function Husong:count_open_icon(ty)
-- 	self.ch_t = ty
-- 	if not self.countdown then
-- 		self.countdown = Schedule(handler(self,self.count_down),1)
-- 	end
-- end
-- function Husong:count_down()
-- 	local hour = os.date("%H",__NOW)
-- 	self.double_time = self.doubleHours[tonumber(hour)] or 0
-- 	local ty = nil
-- 	if self.double_time ~= 0 then
-- 		ty = true
-- 	else
-- 		ty = false
-- 	end
-- 	if self.ch_t ~= ty then
-- 		self.countdown:stop()
-- 		self.countdown = nil
-- 		-- self:init_icon()
-- 	end
-- end

function Husong:transfer_husong()
	local npc_id,map_id =nil
    local tb = LuaItemManager:get_item_obejct("activeDaily").show_data
    for k,v in pairs(tb) do
        if v.name == "护送美人" then
            npc_id = v.npc_id
            map_id = v.map_id
        end
    end
    if npc_id == nil then
  	    return
    end
    local battle = LuaItemManager:get_item_obejct("battle")
    local data = ConfigMgr:get_config("map.mapMonsters")[map_id][ServerEnum.MAP_OBJECT_TYPE.NPC]
    local pos = 0
    for k,v in pairs(data) do
        if v.code == npc_id then
             pos = v.pos
        end
    end
    local ac_fn = function()
        gf_create_model_view("husong")
    end
    -- battle:move_to( map_id, pos.x, pos.y, ac_fn,1)
    self.is_transfer = true
    local cur_mapid = battle:get_map_id()
    self.husong_map_id = map_id
    self.husong_pos = pos
   	battle:transfer_map_c2s(map_id,pos.x+50,pos.y,true)
end

function Husong:transfer_map_s2c(msg)
	if self.is_transfer then 
		-- if msg.err== 0 then
		-- 	 gf_create_model_view("husong")
		-- else
		-- 	self.is_transfer = false
		-- end
		local data = msg.map_msg
		if self.husong_map_id == data.mapId and self.husong_pos.x+50 == data.posX and self.husong_pos.y == data.posY then
      		self.schedule_show = Schedule(handler(self, function()
				self:add_to_state()
				self.schedule_show:stop()
				self.schedule_show= nil
			end),0.5)
			print("加载完成护送打开界面1")
			self.is_transfer = false
		end
	end
end

function Husong:player_speed_down()
	-- self.player = LuaItemManager:get_item_obejct("battle"):get_character()
	-- if not self.player then return end
	-- self.player_speed = self.player.speed
	-- print("护送速度1",self.player_speed)
	-- self.player:set_speed(self.player_speed*0.8)
	-- print("护送速度2",self.player.speed)
end

function Husong:player_speed_up()
	-- self.player:set_speed(self.player_speed)
end