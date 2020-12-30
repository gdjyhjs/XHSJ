--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-09 19:50:01
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local TaskShowEnum = require("models.task.taskShowEnum")

local TaskTitleString = TaskShowEnum.TaskTitleString

local SubTypeString = TaskShowEnum.SubTypeString

-- 任务字体颜色
local TaskColor = 
{
	[ServerEnum.TASK_TYPE.MAIN] 			= UnityEngine.Color(1,0.706,0.177,1) , -- 橙黄色
	[ServerEnum.TASK_TYPE.BRANCH] 			= UnityEngine.Color(0.177,0.675,1,1) , -- 蓝色
	[ServerEnum.TASK_TYPE.DAILY] 			= UnityEngine.Color(65/255,254/255,1,1) , -- 绿色
	[ServerEnum.TASK_TYPE.ALLIANCE_DAILY] 	= UnityEngine.Color(65/255,254/255,1,1) , -- 绿色
	[ServerEnum.TASK_TYPE.ESCORT] 			= UnityEngine.Color(65/255,254/255,1,1) , -- 绿色
	[ServerEnum.TASK_TYPE.ALLIANCE_REPEAT] 	= UnityEngine.Color(65/255,254/255,1,1) , -- 绿色
	[ServerEnum.TASK_TYPE.FACTION] 			= UnityEngine.Color(65/255,254/255,1,1) , -- 绿色
	[ServerEnum.TASK_TYPE.ALLIANCE_PARTY]	= UnityEngine.Color(65/255,254/255,1,1) , -- 绿色
	[ServerEnum.TASK_TYPE.ALLIANCE_GUILD]	= UnityEngine.Color(65/255,254/255,1,1) , -- 绿色
	[ServerEnum.TASK_TYPE.EVERY_DAY] 		= UnityEngine.Color(0.177,0.675,1,1) , -- 蓝色
	[ServerEnum.TASK_TYPE.EVERY_DAY_GUILD] 	= UnityEngine.Color(0.177,0.675,1,1) , -- 蓝色
}

local TaskView=class(UIBase,function(self, item_obj)

	self.task_item = LuaItemManager:get_item_obejct("task")
	self.battle_item = LuaItemManager:get_item_obejct("battle")
	self.rvr_item = LuaItemManager:get_item_obejct("rvr")
	self.chat_view = require("models.task.chatView")(item_obj)

	self.task_list = {} -- 当前任务列表

    UIBase._ctor(self, "mainui_task.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function TaskView:on_asset_load(key,asset)
	self:set_always_receive(true)
	self.newcomerlevel=ConfigMgr:get_config("t_misc").guide_protect_level --新手等级限制

	self:init_ui()
	self:register()

	-- 请求任务列表
	self.task_item:get_task_c2s()
end

function TaskView:register()
	StateManager:register_view( self )
end

function TaskView:cancel_register()
	StateManager:remove_register_view( self )
end

function TaskView:init_ui()
	self.scroll_table = self.refer:Get("loop_scroll")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	self.tween = self.refer:Get("tween")
	self.is_init = true
	self:init_tween()
end

function TaskView:init_tween()
	local dx = IPHOENX_TASK_DX
	local half_w = CANVAS_WIDTH/2
	local y = self.tween.gameObject.transform.localPosition.y
	self.tween.from = Vector3(-half_w+dx, y, 0)
	self.tween.to = Vector3(-half_w-265+dx, y, 0)
	self.refer:Get("task_rt").anchoredPosition = Vector2(dx, self.refer:Get("task_rt").anchoredPosition.y)
end

function TaskView:refresh( data )
	if #data == 0 then 
		self.scroll_table:ClearCells()
		self.scroll_table.gameObject:SetActive(false)
	return 
	else
		self.scroll_table.gameObject:SetActive(true)
	end  --data为空的时候要调出不然会出现个空的
	self.task_list = data
	self.scroll_table.totalCount = #data
	self.scroll_table:RefillCells(0)
end

function TaskView:update_item( item, index )
	item:Get(3):SetActive(false)
	local data = self.task_list[index]
	if not data then
		item.gameObject:SetActive(false)
		return
	elseif data.branch_task_num then
		item.data = data
		item:Get(1).color = TaskColor[ServerEnum.TASK_TYPE.BRANCH]
		item:Get(1).text =  gf_localize_string("[支]可接取支线任务")
		item:Get(2).text = 	gf_localize_string(data.branch_task_num.."个未接取任务")
		item:SetHeight(60)
		return
	else
		item.gameObject:SetActive(true)
	end
	item.data = data
	print("任务信息啊",data.name)
	self:set_title(item:Get(1), data)-- 任务标题
	local content = ""
	if	data.status == ServerEnum.TASK_STATUS.NONE then
		content =  gf_localize_string("<color=#ef3131>"..data.level.."级可接取</color>")
	else
		content = self:get_content(data)
	end
	item:Get(2).text = content -- 内容

	-- 自动适配大小
	local len = #string.split(content, "\n")
	if len > 1 then
		item:SetHeight(60+(len-1)*25)
	else
		item:SetHeight(60)
	end
	local lv = LuaItemManager:get_item_obejct("game").role_info.level
	if index == self.index and data.status == ServerEnum.TASK_STATUS.COMPLETE then
		if data.type ==ServerEnum.TASK_TYPE.MAIN or
			data.type ==ServerEnum.TASK_TYPE.EVERY_DAY or
			data.type ==ServerEnum.TASK_TYPE.ALLIANCE_REPEAT or
			data.type == ServerEnum.TASK_TYPE.ALLIANCE_PARTY or
			data.type ==ServerEnum.TASK_TYPE.ALLIANCE_DAILY or
			data.type ==ServerEnum.TASK_TYPE.ALLIANCE_GUILD then
			item:Get(3):SetActive(true)
		end
	end
	if index == self.index and data.type == ServerEnum.TASK_TYPE.MAIN and self.newcomerlevel>lv then
		if data.status ~= ServerEnum.TASK_STATUS.NONE then
			item:Get(3):SetActive(true)
		end
	end
end


-- 获取标题
function TaskView:set_title( title, task_data )
	local finish_str = "" --是否完成
	--如果是军团任务 添加进度
	if task_data.type == ServerEnum.TASK_TYPE.ALLIANCE_REPEAT  then
		local task_count = gf_getItemObject("legion"):get_repeate_task_time() 
		
		finish_str = finish_str .. string.format("(%d/%d)",task_count,ConfigMgr:get_config("t_misc").alliance.repeatTaskTimesMax)
	end
	if task_data.type == ServerEnum.TASK_TYPE.EVERY_DAY  then
		local task_count = gf_getItemObject("activeDaily"):get_everday_task_curTimes() 
		
		finish_str = finish_str .. string.format("(%d/%d)",task_count,ConfigMgr:get_config("t_misc").task_every_day.default_valid_times)
	end
	if task_data.status == ServerEnum.TASK_STATUS.COMPLETE then -- and (task_data.type ~= ServerEnum.TASK_TYPE.ALLIANCE_REPEAT and task_data.type ~= ServerEnum.TASK_TYPE.ALLIANCE_GUILD )
		finish_str = finish_str .. "<color=#67f858>"..gf_localize_string("(完成)").."</color>"
	end
	title.text = TaskTitleString[task_data.type]..task_data.name..finish_str
	title.color = TaskColor[task_data.type]
end



-- 获取内容文字
function TaskView:get_content( task_data )
	local s_tb =ConfigMgr:get_config("task_show_content")[task_data.code] 
	if s_tb and task_data.status == s_tb.status then
		return s_tb.content
	end
	local name = ""
	local cur_num = 0
	local max_num = 0
	local sub_type = task_data.sub_type
	local status = task_data.status
	if task_data.code == 300000 then
		local num1,num2 = LuaItemManager:get_item_obejct("activeDaily"):get_daily_task_time()
		return "今天还可以做"..num1.."/"..num2
	end
	local target_list = self.task_item:get_target_list(task_data)
	-- local data = ConfigMgr:get_config("task_copy")[target_list[1]]
	-- if data and data.des and data.des ~= "" then -- 如果有配显示字段，显示配表的
	-- 	return data.des
	-- end
	if task_data.handup_type == ServerEnum.TASK_HANDUP_TYPE.FINISH_CLICK_TASK then
		sub_type = ConfigMgr:get_config("task")[task_data.code].sub_type
	end

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

	elseif sub_type == ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP or
	  sub_type == ServerEnum.TASK_SUB_TYPE.ESCORT then
		gf_print_table(target_list, "wtf target_list:")
		for i,v in ipairs(target_list) do
			local config_data = ConfigMgr:get_config("npc")[v]
			if not config_data then
				print_error("Error:找不到任务npc：",v)
				break
			end
			name = name..config_data.name..(i>1 and "," or "")
		end
		print("wtf name:",name)
		
	elseif sub_type == ServerEnum.TASK_SUB_TYPE.DESTINATION then
		name = ConfigMgr:get_config("mapinfo")[task_data.map_id].name
		local data = ConfigMgr:get_config("task_destination")[task_data.condition[1]]
		if data then
			cur_num = data.pos[1]*0.1
			max_num = data.pos[2]*0.1
		end

	elseif sub_type == ServerEnum.TASK_SUB_TYPE.CHALLENGECOPY then
		-- name = task_data.name
		name = ConfigMgr:get_config("copy")[task_data.condition[1]].name
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

			local cur_num_2 = task_data.schedule and task_data.schedule[2] or 0
			local max_num_2 = task_data.target[2] or 0

			local cur_num_3 = task_data.schedule and task_data.schedule[3] or 0
			local max_num_3 = task_data.target[3] or 0

		return string.format(SubTypeString[sub_type],cur_num,max_num,cur_num_2,max_num_2,cur_num_3,max_num_3)

	elseif sub_type ==  ServerEnum.TASK_SUB_TYPE.TOWER_COPY_FLOOR then
		max_num =  task_data.target[1]
		return string.format(SubTypeString[sub_type],max_num)
	end
	if status == ServerEnum.TASK_STATUS.COMPLETE then
		gf_print_table(task_data,"任务啊")
		if task_data.handup_type == ServerEnum.TASK_HANDUP_TYPE.FIND_NPC then
		 	return string.format(gf_localize_string("找<color=#67f858>%s</color>完成任务"),name)
		end
	end

	return string.format(SubTypeString[sub_type], name, cur_num, max_num)
end

function TaskView:show_view( show )
	if not self.tween or not self:is_visible() then
		return
	end

	if show then
		self.tween:PlayReverse()
	else
		self.tween:PlayForward()
	end
end

function TaskView:do_task( task_data )
	if not task_data then
		print_error("Error:任务数据为空")
		-- self:arrive_destination_callback()
		return
	elseif task_data.branch_task_num then
		self.task_item:receive_branch_task()  --接取当前所有支线
		return
	end
	if task_data.status == ServerEnum.TASK_STATUS.NONE then -- 任务不可做
		return
	end
	self.battle_item:refresh_npc(task_data)  --给npc上任务数据
	gf_print_table(task_data, "task_data:")
	--如果是军团任务 直接打开界面
	if task_data.sub_type == ServerEnum.TASK_SUB_TYPE.ALLIANCE_DAILY then
		self.task_data = task_data
		require("models.legion.collectionView")()
		return
	elseif task_data.type == ServerEnum.TASK_TYPE.ESCORT  then
		print("护送啊")
		self.battle_item:check_npc_follow(task_data)
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.ENHANCE_EQUIP then-- 强化装备
		gf_create_model_view("equip")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.FORMULA_EQUIP then-- 打造装备
		LuaItemManager:get_item_obejct("equip"):set_open_mode(2)
		gf_create_model_view("equip")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.POLISH_EQUIP then-- 洗练装备
		gf_getItemObject("equip"):set_open_mode(1,4)
		gf_create_model_view("equip")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.INLAY_GEM then-- 镶嵌宝石
		gf_getItemObject("equip"):set_open_mode(3)
		gf_create_model_view("equip")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.STAGE_UP_HORSE then-- 坐骑进阶
		gf_create_model_view("horse")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.POLISH_HERO then-- 武将洗练
  		gf_create_model_view("hero",ClientEnum.HERO_VIEW.BATTLE,ClientEnum.HERO_SUB_VIEW.HEROWASH)
  		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.UPGRADE_SOUL_HOURSE then-- 坐骑封灵
		-- gf_getItemObject("horse"):set_arg("horse_commont_magic","tag3")
		-- gf_create_model_view("horse") 

		gf_create_model_view("horse",ClientEnum.HORSE_VIEW.MAGIC,ClientEnum.HORSE_SUB_VIEW.SOUL)
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.SKILL_LEVEL_UP then-- 升级技能
		LuaItemManager:get_item_obejct("player"):select_player_page(2)
		gf_create_model_view("player")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.FACTION_HAND_UP then -- 提交采集珠给军需官
		self:do_rvr_task_collect(task_data)
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.FACTION_KILL then -- 击败3人or助攻5人or死亡3次
		self:do_rvr_task_kill(task_data)
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.	ALLIANCE_JOIN     then   -- 加入军团
		LuaItemManager:get_item_obejct("legion"):open_view()
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.SHAKE_MONEY_TREE  then    -- 摇摇钱树
		gf_create_model_view("moneyTree")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.HERO_LEVEL_UP      then-- 武将升级
		gf_create_model_view("hero")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.DEATHTRAP_EXP      then   -- 魔狱10倍经验击杀
		gf_create_model_view("zorkPractice")
		return
	elseif task_data.sub_type == ServerEnum.TASK_SUB_TYPE.TOWER_COPY_FLOOR      then   -- 爬塔	
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.TOWER)
	end

	self.task_data = task_data
	local status = task_data.status
	local target_list, map_id = self.task_item:get_target_list(task_data)
	self.target_id = target_list[1]

	if not self.target_id then
		self:arrive_destination_callback()
		return
	end

	local status = task_data.status

	if status == ServerEnum.TASK_STATUS.PROGRESS then -- 进行中
		-- local event_list = task_data.event

		-- for i,event in ipairs(event_list or {}) do

		-- 	if event == ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP then -- 如果是找npc
		-- 		self.task_item:cossip_with_npc(self.target_id)
		-- 		return
				
		-- 	end

		-- end

		if  self:check_show_copy_ui(task_data)  then
			return
		end
	end

	gf_print_table(target_list, "任务目标列表：")
	print("任务目标列表：",task_data.code)
	-- 通知显示自动寻路ui特效
	Net:receive({visible = true}, ClientProto.ShowMainUIAutoPath)

	local find = self.battle_item:find_task_target(
		task_data, 
		self.target_id, 
		map_id, 
		handler(self, self.arrive_destination_callback),
		task_data.target[1]
	)

end

-- 到达目标点
function TaskView:arrive_destination_callback(err)
	-- 通知隐藏自动寻路ui特效
	Net:receive({visible = false}, ClientProto.ShowMainUIAutoPath)

	-- 有错
	if err then
		return
	end

	if not self.target_id or not self.task_data then
		return
	end
	local status = self.task_data.status
	if self.task_data.type == ServerEnum.TASK_TYPE.ESCORT and status == ServerEnum.TASK_STATUS.PROGRESS then  --护送到达
		-- return
		-- 玩家和npc对望
		self.chat_view:set_chat(self.task_data)
		-- self.battle_item:npc_lookat_character(self.target_id)
	end

	if self.target_id ~= self.last_target_id then
		self.task_item:set_skip_story(false)
	end



	if status == ServerEnum.TASK_STATUS.AVAILABLE or status == ServerEnum.TASK_STATUS.COMPLETE or  status == ServerEnum.TASK_STATUS.NONE  then -- 找npc对话
			self.chat_view:set_chat(self.task_data)
			-- 玩家和npc对望
		-- end
			self.battle_item:npc_lookat_character(self.target_id)

	elseif status == ServerEnum.TASK_STATUS.PROGRESS then -- 进行中
		local event_list = self.task_data.event
		print("npc大对法",self.target_id)

		for i,event in ipairs(event_list or {}) do

			if self.task_data.original_sub_type == ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP or 
				self.task_data.original_sub_type == ServerEnum.TASK_SUB_TYPE.ESCORT	then
				print("npc大对法1",self.target_id)
				self.task_item:cossip_with_npc(self.target_id)

			end

		end
	end

	self.last_target_id = self.target_id
	self:check_show_chapter(self.task_data)
end

-- 功能开启
function TaskView:open_function(msg)
	if msg.is_open == true then -- 功能开启
		if not self.task_click then
        	self.task_click = Schedule(handler(self, function()
        			self.task_click:stop()
        			self.task_click = nil
			end), 1)--尝试限制点击频率
        else
        	self.task_click:reset_time( 1 )
        end
        local player = self.battle_item:get_character()
		if self.chat_view:is_visible() or (player and player:is_move())then
			self.chat_view:hide()
			-- 停止自动寻路
			if player then
				player:stop_auto_move()
			end
			Net:receive({visible = false}, ClientProto.ShowMainUIAutoPath)
			self.temp_task_data = self.task_data
		end

		if msg.fun_hide then
			Net:receive(nil, ClientProto.HideAllOpenUI)
		end

	else -- 功能开启结束
		-- 恢复任务

		if self.temp_task_data then
			if self.temp_task_data.status == ServerEnum.TASK_STATUS.NONE then
				local data = self.task_item:get_type_task(ServerEnum.TASK_TYPE.EVERY_DAY_GUILD)
				if not data then
					data =  self.task_item:get_type_task(ServerEnum.TASK_TYPE.EVERY_DAY)
				end 
				self.temp_task_data = data
			end
			if self.temp_task_data then--防止没有每日指导任务
				self:do_task(self.temp_task_data)
				self.temp_task_data = nil
			end
		end
	end
end

-- 检查是否要显示章节ui
function TaskView:check_show_chapter( task_data )
	local data = ConfigMgr:get_config("task_section")[task_data.code]
	if not data then
		return
	end
	
	if task_data.status ~= data.status then
		return
	end
	View("chapterView", self.item_obj, nil, data, task_data)
	self.chat_view:hide()
end

-- 检查是否需要打副本ui
function TaskView:check_show_copy_ui( task_data )
	print("打开副本ui",self.target_id)
	gf_print_table(task_data,"打开副本ui")
	if task_data.sub_type == ServerEnum.TASK_SUB_TYPE.CHALLENGECOPY then
		local data = ConfigMgr:get_config("task_copy")[self.target_id]
		if gf_getItemObject("copy"):is_copy() then
			Net:receive(true,ClientProto.AutoAtk)
			return true
		end
		-- if LuaItemManager:get_item_obejct("functionUnlock").fun_type ~=0 then
		-- 	return true
		-- end
		if data then
			if data.ty == 1 then --打开副本ui
				gf_create_model_view("copy")
				return true
				
			elseif data.ty == 3 then -- 新手进入副本ui
				View("copyEnter", self.item_obj, nil, data)
				return true
			end
		end
		if not data  then -- 打开副本ui
			local tb = ConfigMgr:get_config("copy")[self.target_id]
			if not tb then
				gf_create_model_view("copy")
			else
				if tb.type == ServerEnum.COPY_TYPE.STORY then 
					gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.STORY)
				elseif tb.type == ServerEnum.COPY_TYPE.MATERIAL then
					gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.MATERIAL)
				elseif tb.type == ServerEnum.COPY_TYPE.MATERIAL2 then
					gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.MATERIAL2)
				elseif tb.type == ServerEnum.COPY_TYPE.TEAM then
					gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.TEAM)
				elseif tb.type == ServerEnum.COPY_TYPE.HOLY then
					gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.HOLY)
				elseif tb.type == ServerEnum.COPY_TYPE.TOWER then
					gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.TOWER)
				end
			end
			return true
		end
	end

	return false
end

-- 战场采集任务处理
function TaskView:do_rvr_task_collect(task_data)
	local character = self.battle_item:get_character()
	if character:is_have_energy() then -- 有能量珠，去提交
		local npc = self.battle_item:get_npc_by_faction(character:get_faction())
		local cb = function()
			self.chat_view:set_chat(npc.config_data, true)
			self.chat_view:refresh(npc:get_event())
		end
		if npc then
			character:move_to(npc.transform.position, cb, 3, true)
		end
	else -- 没有去寻找最近的采集怪
		local target = self.battle_item:get_target_by_type(ServerEnum.CREATURE_TYPE.COLLECT)
		if target then
			self.battle_item:collect(target, 1)
		else
			-- 在视野范围内找不到采集怪，先移动到采集怪附近
			local pos = self.battle_item:get_target_pos_on_map(ServerEnum.CREATURE_TYPE.COLLECT)
			local cb = function()
				self.battle_item:collect(self.battle_item:get_target_by_type(ServerEnum.CREATURE_TYPE.COLLECT), 1)
			end
			if pos then
				character:move_to(pos, cb, 5, true)
			end
		end
	end
end

-- 战场击杀任务处理
function TaskView:do_rvr_task_kill(task_data)
	self.battle_item:get_character():move_to(Vector3(62, 8.96, 137), nil, 3)
end

function TaskView:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if cmd == "taskItem" then -- 做任务
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        if not self.task_click then
        	self.task_click = Schedule(handler(self, function()
        			self.task_click:stop()
        			self.task_click = nil
			end), 1)--尝试限制点击频率
        else
        	return
        end
		local task_data = arg.data
		local status = task_data.status
		if status == ServerEnum.TASK_STATUS.COMPLETE then
			if task_data.handup_type == ServerEnum.TASK_HANDUP_TYPE.FINISH_CLICK_TASK then -- 达成条件 点击任务栏中的任务
				self.task_item:task_hand_up_c2s(task_data.code)
				return
			end
		end
		if status == ServerEnum.TASK_STATUS.NONE then
			-- gf_message_tips("任务"..task_data.level.."级可接取")
			require("models.task.taskTip")()
		else
			self:do_task(arg.data)
		end
	end
end
	
function TaskView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetTaskR") then -- 取任务信息,应该只需要登录的时候取一次
			self:refresh(self:task_list_sort())

		elseif id2 == Net:get_id2("task", "AcceptTaskR") then -- 接任务
			print("wtf AcceptTaskR")
			self.is_accept = true
			self:refresh(self:task_list_sort())

			-- 接完任务，去到目标点
            local data = self.task_item:get_task(msg.code)
            if data and data.type == ServerEnum.TASK_TYPE.BRANCH and data.pre_task == 0 then
            	return
            end
            local bonfire = LuaItemManager:get_item_obejct("bonfire")
        	if bonfire:is_diliver(msg.code) and bonfire.diliverTimes==0 then--军团宴会
          		print("task服务器推来了任务 停止寻路做任务")
          		-- Net:receive({is_open=true,fun_hide=true},ClientProto.OpenFunction) -- 不自动寻路做任务
          		return
        	end
        	if self:check_fun_task(msg.code) then --功能开启的支线任务
        		return
        	end
			self:do_task(self.task_item:get_task(msg.code))
		elseif id2 == Net:get_id2("task", "ScheduleUpdateR") then -- 通知任务进展
			self:refresh(self:task_list_sort())

		elseif id2 == Net:get_id2("task", "TaskCompleteR") then -- 通知任务完成
			print("wtf TaskCompleteR")
			print("护送w",msg.code)
			self:refresh(self:task_list_sort())
			-- if self.task_item:get_task(msg.code).sub_type ~= ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP then
			if 	self.task_item:get_task(msg.code) and self.task_item:get_task(msg.code).type == ServerEnum.TASK_TYPE.ESCORT then  --护送结算
				print("护送成功结算")
				self.battle_item:check_npc_follow(self.task_item:get_task(msg.code))
			else
				self:do_task(self.task_item:get_task(msg.code))
			end
			-- end
			-- 任务完成，停止攻击
			if self.task_data and self.task_data.sub_type == ServerEnum.TASK_SUB_TYPE.KILL_CREATURE then
				gf_auto_atk(false)
			end

		elseif id2 == Net:get_id2("task", "TaskFinishR") then -- 通知任务结束
			gf_print_table(msg, "TaskFinishR wtf :")
			local task_data = ConfigMgr:get_config("task")[msg.code]
			if task_data.sub_type == ServerEnum.TASK_SUB_TYPE.KILL_CREATURE then
				gf_auto_atk(false)
			end

			--如果是军团任务 获取下一个任务 而且次数不是10 而且是最后一条任务
			if task_data.type == ServerEnum.TASK_TYPE.ALLIANCE_REPEAT then
				if self:is_last_task(msg.code) and gf_getItemObject("legion"):get_repeate_task_time() < ConfigMgr:get_config("t_misc").alliance.repeatTaskTimesMax then
					
				elseif self:is_last_task(msg.code) and gf_getItemObject("legion"):get_repeate_task_time() == ConfigMgr:get_config("t_misc").alliance.repeatTaskTimesMax then
					gf_print_table(self:task_list_sort(),"wtf list")
					self:refresh(self:task_list_sort())
					
				else
					gf_getItemObject("task"):accept_task_c2s(task_data.next_task)
				end
				return
			end
			if task_data.type == ServerEnum.TASK_TYPE.EVERY_DAY then
				if self:is_last_everyday_task(msg.code) and gf_getItemObject("activeDaily"):get_everday_task_curTimes() < ConfigMgr:get_config("t_misc").task_every_day.default_valid_times then
					
				elseif self:is_last_everyday_task(msg.code) and gf_getItemObject("activeDaily"):get_everday_task_curTimes() == ConfigMgr:get_config("t_misc").task_every_day.default_valid_times then
					gf_print_table(self:task_list_sort(),"wtf list")
					self:refresh(self:task_list_sort())
					
				else
					gf_getItemObject("task"):accept_task_c2s(task_data.next_task)
					print("接取下个任务")
				end
				return
			end
			self:refresh(self:task_list_sort())
			if 	task_data.type == ServerEnum.TASK_TYPE.ESCORT then  --护送结算
				self.battle_item:check_npc_follow(task_data)
			else

				self:do_task(self.task_item:get_task(task_data.next_task))
			end
			self.task_item:show_story(msg.code)
		elseif id2 == Net:get_id2("task", "TaskGiveUpR") then -- 通知任务移除
			self:refresh(self:task_list_sort())
		end
	end

	if id1 == ClientProto.OnTouchNpcTask then -- 点击npc，有任务
		self:do_task(msg.task_data)
	elseif id1 == ClientProto.OnTouchNpcNoTask then -- 点击npc，无任务
		if self.battle_item:get_character():get_faction() ~= msg.data.faction then -- 不在同一阵营，不打开对话界面
			return
		end

		self.chat_view:set_chat(msg.data, true)
		self.chat_view:refresh(msg.event)

		self.battle_item:get_character():stop_auto_move()

	elseif id1 == ClientProto.OpenFunction then -- 功能开启
		print("功能开启界面停止",msg.is_open)
		self:open_function(msg)

	elseif id1 == ClientProto.CloseTaskChapterUI then -- 关闭章节ui，让任务继续
		-- self.chat_view:set_chat(self.task_data)
		LuaItemManager:get_item_obejct("functionUnlock"):open_fun_over()
	elseif id1 == ClientProto.HusongNPC then
		self:do_task(self.task_item:get_task(msg.code))

	elseif id1 == ClientProto.RefreshTask then
		self:refresh(self:task_list_sort())

	elseif(id1==Net:get_id1("base"))then
		if id2 == Net:get_id2("base", "UpdateLvlR") then
        	self:update_task_status(msg.level)
        end

    elseif id1 == ClientProto.DoTask then
    	self:do_task(self.task_item:get_task(msg.code))
    	
	end
end
--更新任务状态（不可以接取变接取）
function TaskView:update_task_status(lv)
	local data= self:task_list_sort()
	if #data == 0 then return end
	for k,v in pairs(data) do
		if v.status == ServerEnum.TASK_STATUS.NONE and lv>=v.level then
		 	self.task_item:set_task_status(v.code,ServerEnum.TASK_STATUS.AVAILABLE)
		end
	end
	self:refresh(self:task_list_sort())
end

function TaskView:check_fun_task(t_id)
	local data =  ConfigMgr:get_config("function_tasks")
	for k,v in pairs(data) do
		if v.task_id == t_id then
			return true
		end
	end
	return false
end

function TaskView:is_last_task(task_id)
	local task_alliance = ConfigMgr:get_config("task_alliance")
	for k,v in pairs(task_alliance or {}) do
		if v.final_code == task_id then
			return true
		end
	end
	return false
end

function TaskView:is_last_everyday_task(task_id)
	local task_every_day = ConfigMgr:get_config("task_every_day")
	for k,v in pairs(task_every_day or {}) do
		if v.final_code == task_id then
			return true
		end
	end
	return false
end


function TaskView:task_list_sort()
	local data =  copy(self.task_item:get_task_list())
	local tb = {}
	local index = 0
	for k,v in pairs(data or {}) do
		if v.type == ServerEnum.TASK_TYPE.MAIN then
			index = #tb + 1
			tb[index] = copy(v)
		end
	end
	for k,v in pairs(data or {}) do
		if v.type == ServerEnum.TASK_TYPE.EVERY_DAY or v.type == ServerEnum.TASK_TYPE.EVERY_DAY_GUILD  then
			index = #tb + 1
			tb[index] = copy(v)
		end
	end
	for k,v in pairs(data or {}) do
		if 	v.type == ServerEnum.TASK_TYPE.ALLIANCE_REPEAT or
			v.type == ServerEnum.TASK_TYPE.ALLIANCE_PARTY or
			v.type == ServerEnum.TASK_TYPE.ALLIANCE_DAILY or
			v.type == ServerEnum.TASK_TYPE.ALLIANCE_GUILD then
			index = #tb + 1
			tb[index] = copy(v)
		end
	end
	local sortFunc = function(a, b)--进行一次完成的排序
		if a.status == ServerEnum.TASK_STATUS.COMPLETE or b.status == ServerEnum.TASK_STATUS.COMPLETE then
			if a.status == b.status then
				return a.type < b.type 
			end
			return a.status>b.status
		end
    end
 	table.sort(tb,sortFunc)
 	local receive_data = self.task_item:get_recently_task()
 	if receive_data then
 		local num = 0
		for k,v in pairs(tb) do
			if v.code == receive_data.code then
				num = k
				receive_data = copy(v)
				break
			end
		end
		if num ~= 0 then
			table.remove(tb,num)
			table.insert(tb,1,receive_data)
		end
 	end

 	local branch_data = {}
	for k,v in pairs(data or {}) do
		if v.type == ServerEnum.TASK_TYPE.BRANCH then
			index = #branch_data + 1
			branch_data[index] = copy(v)
		end
	end
	local sortFunc1 = function(a, b)--进行一次支线的排序
		if a.status == b.status then
			return a.code > b.code 
		end
		return a.status>b.status
    end
 	table.sort(branch_data,sortFunc1)
 	for k,v in pairs(branch_data) do
 		table.insert(tb,v)
 	end
 	
	for k,v in pairs(data or {}) do
		if 	v.type ~= ServerEnum.TASK_TYPE.MAIN and
			v.type ~= ServerEnum.TASK_TYPE.BRANCH and
			v.type ~= ServerEnum.TASK_TYPE.EVERY_DAY_GUILD and
 			v.type ~= ServerEnum.TASK_TYPE.EVERY_DAY and 
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_REPEAT and
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_PARTY and
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_DAILY and
			v.type ~= ServerEnum.TASK_TYPE.ALLIANCE_GUILD then
			index = #tb + 1
			tb[index] = copy(v)
		end
	end
	local b_tb = copy(self.task_item:get_branch_list())
	self.index = 1
	if #b_tb >0 and not LuaItemManager:get_item_obejct("rvr"):is_rvr() then
		local cur_tb = {}
		cur_tb[1]={branch_task_num =  #b_tb}
		for k,v in pairs(tb) do
			table.insert(cur_tb,v)
		end
		self.index = 2
		return cur_tb
	end
	return tb
end



function TaskView:on_showed()
	local is_rvr = self.rvr_item:is_rvr()
	if self.is_init then
		self:refresh(self:task_list_sort())
	end

end

function TaskView:on_hided()
	
end

-- 释放资源
function TaskView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return TaskView

