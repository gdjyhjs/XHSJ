--[[--
--任务界面
-- @Author:Seven
-- @DateTime:2017-05-12 11:16:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local TaskShowEnum = require("models.task.taskShowEnum")
local TaskView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
    Asset._ctor(self, "taskinterface.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self.select_item = nil
end)

-- 资源加载完成
function TaskView:on_asset_load(key,asset)
	self:hide_mainui()
	--初始化
	print("初始化进入任务界面")
	self:init_ui()
	self:register()
	local data = self:check_task(self.item_obj:get_task_list(),0)
	self:refresh_left(data)
	if data and #data == 0 and self.current_task_type then 
		self:current_task_empty(true)
	else
		self:current_task_empty(false)
	end
end
--任务排序
function TaskView:check_task(data,num)
	local tb = {}
	local index = 0
	local is_have_main = true
	for k,v in pairs(data or {}) do
		if v.type == ServerEnum.TASK_TYPE.MAIN then
			index = #tb + 1
			if is_have_main then
				tb[index] = copy(v)
				tb[index].show = 1
				index = index + 1
				is_have_main = false
			end
			if v.type == num then
				tb[index] = copy(v)
				tb[index].show = 2
			end
		end
	end
	local is_have_branch = true
	for k,v in pairs(data or {}) do
		if v.type == ServerEnum.TASK_TYPE.BRANCH then
			index = #tb + 1
			if is_have_branch then
				tb[index] = copy(v)
				tb[index].show = 1
				index = index + 1
				is_have_branch = false
			end
			if v.type == num then
				tb[index] = copy(v)
				tb[index].show = 2
			end
		end
	end
	local is_have_daily = true
	for k,v in pairs(data or {}) do
		if v.type == ServerEnum.TASK_TYPE.EVERY_DAY or v.type == ServerEnum.TASK_TYPE.EVERY_DAY_GUILD  then
			index = #tb + 1
			if is_have_daily then
				tb[index] = copy(v)
				tb[index].show = 1
				index = index + 1
				is_have_daily = false
			end
			if v.type == num then
				tb[index] = copy(v)
				tb[index].show = 2
			end
		end
	end
	local is_have_alliance = true
	for k,v in pairs(data or {}) do
		if 	v.type == ServerEnum.TASK_TYPE.ALLIANCE_REPEAT or
			v.type == ServerEnum.TASK_TYPE.ALLIANCE_PARTY or
			v.type == ServerEnum.TASK_TYPE.ALLIANCE_DAILY or
			v.type == ServerEnum.TASK_TYPE.ALLIANCE_GUILD then
			index = #tb + 1
			if is_have_alliance then
				tb[index] = copy(v)
				tb[index].show = 1
				index = index + 1
				is_have_alliance = false
			end
			if v.type == num then
				tb[index] = copy(v)
				tb[index].show = 2
			end
		end
	end
	local is_have_other = true
	for k,v in pairs(data or {}) do
		if 	v.type ~= ServerEnum.TASK_TYPE.MAIN and
			v.type ~= ServerEnum.TASK_TYPE.BRANCH and
 			v.type ~= ServerEnum.TASK_TYPE.EVERY_DAY and 
 			v.type ~= ServerEnum.TASK_TYPE.EVERY_DAY_GUILD and
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_REPEAT and
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_PARTY and
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_DAILY and
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_GUILD then
			index = #tb + 1
			if is_have_other then
				tb[index] = copy(v)
				tb[index].show = 1
				index = index + 1
				is_have_other = false
			end
			if v.type == num then
				tb[index] = copy(v)
				tb[index].show = 2
			end
		end
	end
	return tb
end

function  TaskView:init_ui()
	self.scroll_left_table =  self.refer:Get("Content1")
	self.scroll_left_table.onItemRender = handler(self,self.update_left_item)

	self.scroll_right_table =  self.refer:Get("Content2")
	self.scroll_right_table.onItemRender = handler(self,self.update_right_item)
	--当前任务信息
	self.current_task_type = self.refer:Get("txt_task_type")
	self.current_task_description = self.refer:Get("txt_task_description")
	-- self.award1 = self.refer:Get("award1")--经验奖励
	-- self.award2 = self.refer:Get("award2")--铜钱奖励
	self.current_task_target = self.refer:Get("txt_task_target")
end

function TaskView:refresh_left(data)
	self.scroll_left_table.data = data
	self.scroll_left_table:Refresh(0,- 1 ) --显示列表
end

function TaskView:refresh_right(data)
		print("任务奖励刷新")
	self.scroll_right_table.data = data
	self.scroll_right_table:Refresh(0,- 1 ) --显示列表
end

function TaskView:update_left_item(item,index,data)
	-- --选中任务
	if not self.select_big_code then
		self:select_big_task(item)
	else
		-- item:Get(2):SetActive(false)
	end
	item:Get(4).text = self:get_task_type(data.type)
	if data.type ==ServerEnum.TASK_TYPE.DAILY or
		data.type ==ServerEnum.TASK_TYPE.ESCORT or
		data.type ==ServerEnum.TASK_TYPE.ALLIANCE_REPEAT or
		data.type ==ServerEnum.TASK_TYPE.ALLIANCE_PARTY or
		data.type ==ServerEnum.TASK_TYPE.ALLIANCE_GUILD or
		data.type ==ServerEnum.TASK_TYPE.EVERY_DAY or
		data.type ==ServerEnum.TASK_TYPE.EVERY_DAY_GUILD then
		local lv = LuaItemManager:get_item_obejct("game"):getLevel()
		item:Get(7).text = "[lv."..lv.."]"..data.name.."\n"..self:get_task_state(data.status)
	else
		item:Get(7).text = "[lv."..data.show_level.."]"..data.name.."\n"..self:get_task_state(data.status)
	end
	if data.show == 1 then
		item:Get(1):SetActive(true)
		item:Get(2):SetActive(false)
		if self.select_big_code == data.code and  not self.cur_select_big then
			item:Get(3):SetActive(true)
			item:Get(5).localRotation=Quaternion.Euler(0,0,0)
		elseif self.cur_select_big and self.select_big_code == data.code  then 
			item:Get(3):SetActive(true)
			item:Get(5).localRotation=Quaternion.Euler(0,0,90)
		else
			item:Get(3):SetActive(false)
			item:Get(5).localRotation=Quaternion.Euler(0,0,90)
		end
	elseif data.show == 2 then
		item:Get(1):SetActive(false)
		item:Get(2):SetActive(true)
		if data.select then
			self:select_task(item)
			item:Get(6):SetActive(true)
		else
			item:Get(6):SetActive(false)
		end
	end
end

function TaskView:get_task_state(num)
	if num == ServerEnum.TASK_STATUS.NONE then
		return gf_localize_string("<color=#ef3131>任务不可接</color>")
	elseif num == ServerEnum.TASK_STATUS.AVAILABLE then
		return gf_localize_string("<color=#18a700>任务可领取</color>")
	elseif num == ServerEnum.TASK_STATUS.PROGRESS then
		return	gf_localize_string("<color=#18a700>任务进行中</color>")
	elseif num == ServerEnum.TASK_STATUS.COMPLETE then
		return	gf_localize_string("<color=#18a700>任务已完成</color>")
	end
end

function TaskView:update_right_item(item,index,data)
	if data.num then
		item:Get(2).text = gf_format_count(data.num)
	else
		item:Get(2).text = ""
	end
	if data.formuleId then
		local tb = ConfigMgr:get_config("equip_formula")[data.formuleId]
		gf_set_click_prop_tips(item.gameObject,data.formuleId)--,tb.color_prob[#tb.color_prob][2]
		gf_set_item(tb.code,item:Get(1),item:Get(3),tb.color_prob[#tb.color_prob][2])
	else
		gf_set_click_prop_tips(item.gameObject,data.code)
		gf_set_item(data.code,item:Get(1),item:Get(3),data.color,data.star_count)
	end
	local tb = ConfigMgr:get_config("item")
	if tb.code and tb[tb.code].bind == 1 then
		item:Get("binding"):SetActive(true)
	else
		item:Get("binding"):SetActive(false)
	end
end

--选中任务
function TaskView:select_task(item,tf)
	if self.select_item == item and not tf then 
		return
	end
	if self.select_item then
		self.select_item:Get(6):SetActive(false)
	end
	item:Get(6):SetActive(true)
	self.select_item = item
	print("任务选中",self.select_item.data.name)
	self:refresh_right()
	self:update_right(item.data)
	if  self.select_item.data.status == ServerEnum.TASK_STATUS.PROGRESS 
		or self.select_item.data.status == ServerEnum.TASK_STATUS.COMPLETE then
		print("任务选中fa",self.select_item.data.name)
		self.item_obj:preread_task_reward(self.select_item.data.code)
	end
end

function TaskView:select_big_task(item)
	if self.select_big_code == item.data.code and not self.cur_select_big then 
		local data = self:check_task(self.item_obj:get_task_list(),0)
		self:refresh_left(data)
		-- self.select_big_item:Get(5).localRotation=Quaternion.Euler(0,0,90)
		self.cur_select_big = true
		return
	else
		local data = self:check_task(self.item_obj:get_task_list(),item.data.type)
		for k,v in pairs(data) do
			if v.code == item.data.code and v.show == 2 then
				v.select = true
			end
		end
		self:refresh_left(data)
		self.cur_select_big = false
	end
	-- if self.select_big_item then
	-- 	self.select_big_item:Get(3):SetActive(false)
	-- 	self.select_big_item:Get(5).localRotation=Quaternion.Euler(0,0,90)
	-- end

	self.select_big_code = item.data.code
end

--任务类型
function TaskView:get_task_type(num)
	local tb = TaskShowEnum.TaskTitle
	if  num ~= ServerEnum.TASK_TYPE.MAIN and
		num ~= ServerEnum.TASK_TYPE.BRANCH and
 		num ~= ServerEnum.TASK_TYPE.EVERY_DAY and
 		num ~= ServerEnum.TASK_TYPE.EVERY_DAY_GUILD and 
		num ~= ServerEnum.TASK_TYPE.ALLIANCE_REPEAT and
		num ~= ServerEnum.TASK_TYPE.ALLIANCE_PARTY and
		num ~= ServerEnum.TASK_TYPE.ALLIANCE_DAILY and
		num ~= ServerEnum.TASK_TYPE.ALLIANCE_GUILD then
		return gf_localize_string("其他任务")
	end
	return tb[num]
end	
--更新右边信息
function TaskView:update_right(t_data)
	local data = copy(t_data)
	self.current_task_type.text= self:get_task_type(data.type)
	self.current_task_description.text= data.disc
	self.current_task_target.text= self:get_task_target(data)
	if data.type == ServerEnum.TASK_TYPE.EVERY_DAY or data.type == ServerEnum.TASK_TYPE.ALLIANCE_REPEAT then
		if data.next_task~=0 then
			print("啊啊啊",data.next_task)
			local tb = ConfigMgr:get_config("task")
			local index = data.next_task
			for i=1,10 do
				if tb[index].next_task == 0 then
					break
				else
					index = tb[index].next_task
				end
			end
			data = tb[index]
		end
	end
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local career = LuaItemManager:get_item_obejct("game").role_info.career
		self.scroll_right_table.gameObject:SetActive(true)
		self.data_right = {}
		local base_data = ConfigMgr:get_config("base_res")
		if data.exp_reward and data.exp_reward[1]~= 0 then
			local x_id = base_data[ServerEnum.BASE_RES.EXP].item_code
			self.data_right[#self.data_right+1] = {code = x_id,num = data.exp_reward[1]+(lv-data.exp_reward[2])*data.exp_reward[3]}--
		end
		if data.money_reward and #data.money_reward ~= 0 then
			for k,v in pairs(data.money_reward) do
				self.data_right[#self.data_right+1] = {code =base_data[v[1]].item_code,num = v[2][1]+(lv-v[2][2])*v[2][3]}--
			end
		end
		if data.item_reward then
			for k,v in pairs(data.item_reward) do
				local i = #self.data_right+1
				self.data_right[i] = {code = v[1],num = v[2],color=v[4],star_count = v[5]}
			end
		end
		if data["career_"..career] then
			for k,v in pairs(data["career_"..career]) do
				local i = #self.data_right+1
				self.data_right[i] = {code = v[1]}
			end
		end
	-- if data.status then
	-- 	if  data.status ~= ServerEnum.TASK_STATUS.PROGRESS 
	-- 		and data.status ~= ServerEnum.TASK_STATUS.COMPLETE then
	-- 		self:refresh_right(self.data_right)
	-- 	end
	-- else
		self:refresh_right(self.data_right)
	-- end
end
-- --物品奖励判断
-- function TaskView:judge_award_type(item_id)
-- 	local item_type = ConfigMgr:get_config("item")[item_id].type
-- 	if item_type =  ServerEnum.ITEM_TYPE.
-- end



local SubTypeString = TaskShowEnum.SubTypeStringView


--任务目标
function TaskView:get_task_target(task_data)
	local s_tb =ConfigMgr:get_config("task_show_content")[task_data.code] 
	if s_tb and task_data.status == s_tb.status then
		return s_tb.content
	end
	local name = ""
	local map_id = 0
	local cur_num = 0
	local max_num = 0
	local sub_type = task_data.sub_type
	local status = task_data.status
	self.task_item = LuaItemManager:get_item_obejct("task")
	local target_list,map_id= self.task_item:get_target_list(task_data)

	if sub_type == ServerEnum.TASK_SUB_TYPE.KILL_CREATURE or 
	   sub_type == ServerEnum.TASK_SUB_TYPE.COLLECT then
		for i,v in ipairs(target_list) do
			local config_data = ConfigMgr:get_config("creature")[v]
			if config_data then
				name = name..config_data.name..(i>1 and "," or "")
			else
				print_error("Error:找不到怪物数据:id =",v)
			end
		end
		-- gf_print_table(task_data.schedule, "进度")
		cur_num = task_data.schedule and task_data.schedule[1] or 0
		max_num = task_data.target[1]
		local txt = ConfigMgr:get_config("mapinfo")[map_id].name
		return string.format(SubTypeString[task_data.sub_type],txt ,name, cur_num, max_num)	
	elseif sub_type == ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP then
		for i,v in ipairs(target_list) do
			local config_data = ConfigMgr:get_config("npc")[v]
			if not config_data then
				print_error("Error:找不到任务npc：",v)
				break 
			end
			name = name..config_data.name..(i>1 and "," or "")
		end
		local txt = ConfigMgr:get_config("mapinfo")[map_id].name
		return string.format(SubTypeString[task_data.sub_type],txt,name)
	elseif sub_type == ServerEnum.TASK_SUB_TYPE.DESTINATION then
		name = ConfigMgr:get_config("mapinfo")[task_data.map_id].name
		local data = ConfigMgr:get_config("task_destination")[task_data.condition[1]]
		if data then
			cur_num = data.pos[1]*0.1
			max_num = data.pos[2]*0.1
		end
	elseif sub_type == ServerEnum.TASK_SUB_TYPE.CHALLENGECOPY then
		name = task_data.name
		return string.format(SubTypeString[task_data.sub_type],name)
	elseif sub_type == ServerEnum.TASK_SUB_TYPE.ENHANCE_EQUIP 		or
		   sub_type == ServerEnum.TASK_SUB_TYPE.FORMULA_EQUIP 		or
		   sub_type == ServerEnum.TASK_SUB_TYPE.POLISH_EQUIP 		or
		   sub_type == ServerEnum.TASK_SUB_TYPE.INLAY_GEM 			or
		   sub_type == ServerEnum.TASK_SUB_TYPE.STAGE_UP_HORSE 		or
		   sub_type == ServerEnum.TASK_SUB_TYPE.POLISH_HERO 		or
		   sub_type == ServerEnum.TASK_SUB_TYPE.UPGRADE_SOUL_HOURSE or
		   sub_type == ServerEnum.TASK_SUB_TYPE.SKILL_LEVEL_UP 		or 
		   sub_type == ServerEnum.TASK_SUB_TYPE.FACTION_HAND_UP		or
		   sub_type == ServerEnum.TASK_SUB_TYPE.FACTION_KILL     	or
		   sub_type == ServerEnum.TASK_SUB_TYPE.SHAKE_MONEY_TREE	or
		   sub_type == ServerEnum.TASK_SUB_TYPE.HERO_LEVEL_UP		or
		   sub_type == ServerEnum.TASK_SUB_TYPE.DEATHTRAP_EXP		then
			cur_num = task_data.schedule and task_data.schedule[1] or 0
			max_num =  task_data.target[1]
		return string.format(SubTypeString[task_data.sub_type],cur_num,max_num)
	elseif sub_type ==  ServerEnum.TASK_SUB_TYPE.TOWER_COPY_FLOOR then
		max_num =  task_data.target[1]
		return string.format(SubTypeString[sub_type],max_num)
	end
	
	if status == ServerEnum.TASK_STATUS.COMPLETE then
		return string.format(gf_localize_string("找%s完成任务"),name)
	end

	return string.format(SubTypeString[task_data.sub_type], name, cur_num, max_num)
end

--注册事件
function TaskView:register()
    self.item_obj:register_event("task_view_on_click", handler(self, self.on_click))
end

function  TaskView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击了-----",cmd)
	if cmd == "btnFirstLevel" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_big_task(arg)
		-- self:select_task(arg)
	elseif cmd == "btnSecondLevel" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_task(arg)
	elseif cmd == "btn_cancle" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "btnGo" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		Net:receive({task_data = self.select_item.data},ClientProto.OnTouchNpcTask)
		self:dispose()
	end
end

--当前任务信息清空
function TaskView:current_task_empty(ty)
	--配置信息
	 -- self.current_task_type.text= ""
	 -- self.current_task_description.text= ""
	 -- self.current_task_target.text=""
	self:refresh_right()
	self.refer:Get("txtNull"):SetActive(ty)
 	self.refer:Get("null"):SetActive(ty)
 	self.refer:Get("Panel_center"):SetActive(not ty)
	 -- self.award1.text= ""
end
function TaskView:on_showed()
	-- if  self.task_list and #self.task_list == 0 and self.current_task_type then 
	-- 	self:current_task_empty()
	-- end
	-- if self.scroll_left_table then
	-- 	self:refresh_left(self.task_list)
	-- 	self:register()
	-- end
end

function TaskView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "PrereadTaskRewardR") then
			gf_print_table(msg,"任务刷新")
			local data = msg.reward
			if not data or #data == 0 then return end
			for k,v in pairs(data) do
				local tb = ConfigMgr:get_config("base_res")[v.code]
				if tb then
					v.code = tb.item_code
				end
				for kk,vv in pairs(self.data_right or {}) do
					if vv.code == v.code then
						vv.num = v.num
					end
				end
			end
			self:refresh_right(self.data_right)
		end
	end
end

function TaskView:on_hided()
	self:dispose()
end

-- 释放资源
function TaskView:dispose()
	self.select_big_code = nil
	self.select_item = nil
	self.item_obj:register_event("task_view_on_click", nil)
    self._base.dispose(self)
 end

return TaskView

