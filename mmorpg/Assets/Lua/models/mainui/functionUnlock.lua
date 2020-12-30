--[[--
--功能开启
-- @Author:Seven
-- @DateTime:2017-06-05 14:22:09
--]]
local Enum = require("enum.enum")
local FunctionUnlock = class(function (self,ui,item_obj)
	self.ui = ui
	self.item_obj = item_obj
	self:init()
end)
function FunctionUnlock:init()
	self.is_show = true
	self:init_ui()
	self:already_unlock()
end
--初始化ui
function FunctionUnlock:init_ui()
	--功能开启表
	self.function_open_table=copy(ConfigMgr:get_config("function_unlock"))
	self.function_table = {}
	--初始化所有需要开启功能
	local item = self.ui.refer:Get("zhujiemian_ui")
	if #self.function_open_table == 0 then return end 
	for k,v in pairs(self.function_open_table) do
		if v.open_type ~= ServerEnum.FUNC_CONDITION_TYPE.CLICK then
			local index = v.function_id
			self.function_table[index] = item:Get(v.obj_name)
			if self.function_table[index] and v.btn_show == 1 then
				self.function_table[index]:SetActive(false)
			end
			print("功能开启ob",self.function_table[index])
		end
	end
	--功能提示框
	self.function_item = self.ui.refer:Get("rightbottom")
	self.img_function_unlock = self.function_item:Get("img_function_unlock")
	self.txt_open_time =  self.function_item:Get("txt_open_time")
	self.txt_open_function =  self.function_item:Get("txt_open_function")
	self.img_function_icon = self.function_item:Get("img_function_icon")
	self.img_function_unlock:SetActive(false)

	self.level_open_table = {}
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local tb = LuaItemManager:get_item_obejct("functionUnlock"):updata_level_open(lv)

	for k,v in pairs(tb) do
		self.level_open_table[k] = item:Get(v.obj_name)
		if v.open then
			print("开启按钮1",self.level_open_table[k].name)
			-- self.level_open_table[k]:SetActive(true)
			self.ui:showorhide_btn(v.obj_name,true)
		else
			print("开启按钮2",self.level_open_table[k].name)
			if v.btn_show ~= 2 then
				-- self.level_open_table[k]:SetActive(false)
				self.ui:showorhide_btn(v.obj_name,false)
			end
		end
	end
end
--初始化隐藏
function FunctionUnlock:func_unlock_showorhide(show)
	if self.is_show then
		-- self.img_function_unlock:SetActive(show)
	else
		self.img_function_unlock:SetActive(false)
	end
end

function FunctionUnlock:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("base")) then
		if id2 == Net:get_id2("base", "UpdateLvlR") then
        	local tb = LuaItemManager:get_item_obejct("functionUnlock"):updata_level_open(msg.level)
        	for k,v in pairs(tb) do
				if v.open then
					-- self.level_open_table[k]:SetActive(true)
					self.ui:showorhide_btn(v.obj_name,true)
				else
					if v.btn_show ~= 2 then
						-- self.level_open_table[k]:SetActive(false)
						self.ui:showorhide_btn(v.obj_name,false)
					end
				end
			end
			if self.wait_10_open and msg.level>=10 then
				self.img_function_unlock:SetActive(true)
				self.wait_10_open = false
			end
        end
    elseif id1 ==  ClientProto.UpdateFunTips then
    	self:update_fun_txt(msg.fun_data)
    elseif id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetTaskR") then 
			local lv = LuaItemManager:get_item_obejct("game"):getLevel()
			self.cur_fun_tips = LuaItemManager:get_item_obejct("functionUnlock"):init_fun_tips(lv)
			if not self.cur_fun_tips then
				self.img_function_unlock:SetActive(false)
				return
			end
			self:update_fun_txt(self.cur_fun_tips)
			if lv >=10 then
				self.img_function_unlock:SetActive(true)
			else
				self.wait_10_open = true
			end
			self:init_branch_task()
		end
    end
end
--初始化支线
function FunctionUnlock:init_branch_task()
	local tb = LuaItemManager:get_item_obejct("game").role_info.funcIds
	local data = ConfigMgr:get_config("function_tasks")
	for k,v in pairs(tb) do
		if data[v] then
			LuaItemManager:get_item_obejct("task"):init_branch_task(data[v].task_id)
		end
	end
end

--初始化判断已经解锁的功能
function FunctionUnlock:already_unlock()
	local fun_unlock = LuaItemManager:get_item_obejct("functionUnlock")
	StateManager:get_current_state():add_item(fun_unlock)
	local gm = LuaItemManager:get_item_obejct("game")
	local fun_tb=ConfigMgr:get_config("function_unlock")
	gf_print_table(gm.role_info.funcIds,"已经开启过的功能id")
	local g_tb = gm.role_info.funcIds
	LuaItemManager:get_item_obejct("functionUnlock").fun_list = g_tb
	local game_tb ={}
	for k,v in pairs(g_tb) do
		if fun_tb[v].open_type ~= ServerEnum.FUNC_CONDITION_TYPE.CLICK then --筛选弱指引
			local index = #game_tb +1
			game_tb[index] = v
		end
	end
	if #game_tb == 0 then -- 功能id表为空，就从配置表第一个开始
		local fid = fun_tb[1].function_id 
		--准备下一个功能
		self:choose_open_type(fid)
	else
		local tb_num = #game_tb
		print("功能开启长度",#game_tb)
		if tb_num > #fun_tb then
			tb_num = #fun_tb
		end
		for k,v in pairs(game_tb) do
			self.function_table[v]:SetActive(true)
			if fun_tb[v].page then
				fun_unlock:updata_page_tb(fun_tb[v].obj_name,fun_tb[v].page)
			end
		end
		if tb_num == #fun_tb then
			return
		end
		local fid = fun_tb[tb_num].next_function_id
		--开启未开启功能
		-- local player_lv = gm.role_info.level
		-- for i=1,#fun_tb-#game_tb do
		-- 	if player_lv >=fun_tb[fid].open_need_id then
		-- 		fun_unlock:open_fun_c2s(fid)
		-- 		fid = fun_tb[fid].next_function_id
		-- 	end
		-- end
		if fid == 0 then --全部完成
			self.is_show = false
			return
		end
		--准备下一个功能
		self:choose_open_type(fid)
	end
end

function FunctionUnlock:choose_open_type(fid)
	local fun_tb=ConfigMgr:get_config("function_unlock")
	local fun_unlock = LuaItemManager:get_item_obejct("functionUnlock")
	if not fun_tb[fid] then return end
		print("功能开启选择类型",fun_tb[fid].open_type)
	if fun_tb[fid].open_type == Enum.FUNC_CONDITION_TYPE.PLAYER_LEVEL then
		local lv = fun_tb[fid].open_need_id
		fun_unlock:level_up_unlock(fid,lv)
	elseif fun_tb[fid].open_type == Enum.FUNC_CONDITION_TYPE.TASK then
		fun_unlock:task_finish_unlock(fid)
	elseif fun_tb[fid].open_type == Enum.FUNC_CONDITION_TYPE.MAP then
		fun_unlock:join_map_unlock(fid)
	end
end



--功能预告显示
function FunctionUnlock:update_fun_txt(data)
	if not data  then
		self.txt_open_time.text =""
		self.img_function_unlock:SetActive(false)
		print("功能隐藏")
		return
	end
	-- local data = ConfigMgr:get_config("function_unlock")[fun_id]
	local fun_name = data.name
	local lv = data.level
	local img_name = data.icon
	self.txt_open_function.text = fun_name
	if data.open_type then
		self.txt_open_time.text =gf_localize_string(lv .. "级任务开启")
	else
		self.txt_open_time.text =gf_localize_string(lv .. "级开启")
	end
	gf_setImageTexture(self.img_function_icon,img_name)
end

--解锁什么功能
function FunctionUnlock:unlock_what(tb)
	self.function_table[tb.function_id]:SetActive(true)
	self.current_fun_id= tb.function_id
	local fun_btn = self.function_table[tb.function_id]
	print("功能开启function_id",tb.function_id)
	print("功能开启fun_btn",fun_btn)
	local sprite =tb.icon
	local function_name = tb.function_name
	local target_pos = fun_btn.transform.position
	if tb.open_ui_type == 2 then --弹框显示
		LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(true)
		LuaItemManager:get_item_obejct("functionUnlock"):unlock_ccmp(sprite,fun_btn,target_pos,function_name,tb.function_id)
	end
	-- self.function_table[tb.function_id]:SetActive(true)
	if tb.page then
		LuaItemManager:get_item_obejct("functionUnlock"):updata_page_tb(tb.obj_name,tb.page)
	end
	self:next_fun_unlock(tb.next_function_id)
end

--准备下个功能开启
function FunctionUnlock:next_fun_unlock(funid)
	if funid == 0 then
		return
	end
	self:choose_open_type(funid)
end

-- --判断是否是右边按钮和是否是战斗面板
-- function FunctionUnlock:judge_right_btn(tb)
-- 	if tb.function_place == 2 then
-- 		print(LuaItemManager:get_item_obejct("mainui").show_atk_panel,"战斗面板++")
-- 		if LuaItemManager:get_item_obejct("mainui").show_atk_panel then --如果是战斗面板
-- 			return self.switchBtn.transform.position
-- 		end
-- 	end
-- 	return self.function_table[tb.function_id].transform.position
-- end
--判断右边转换按钮是否需要加红点
-- function FunctionUnlock:judge_need_switchBtn(funid)
-- 	for i,v in ipairs(self.function_open_table) do
-- 		if v.function_id == funid  then
-- 			if v.function_place == 2 and LuaItemManager:get_item_obejct("mainui").show_atk_panel then
-- 				return true
-- 			else
-- 				return false
-- 			end
-- 		end
-- 	end
-- 	return false
-- end

--功能展示
function FunctionUnlock:ulock_look_fun()
	local fun_tb = {"equip","bag"}
	print("功能展示+++++",fun_tb[self.current_fun_id])
	self.current_fun = self.ui:add_model(fun_tb[self.current_fun_id])
end

function FunctionUnlock:fun_effect_save(num)
	
end


return FunctionUnlock
