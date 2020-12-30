--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-31 15:36:37
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local FunctionUnlock = LuaItemManager:get_item_obejct("functionUnlock")
FunctionUnlock.priority = ClientEnum.PRIORITY.GUIDE
--UI资源
FunctionUnlock.assets=
{
    View("functionUnlockView", FunctionUnlock) 
}
FunctionUnlock.priority = ClientEnum.PRIORITY.GUIDE

--解锁弹窗信息
 function FunctionUnlock:unlock_ccmp(icon,obj,target_pos,function_name,function_id)
 	self.fun_type = 1
 	self.function_id=function_id
 	self.function_name=function_name
 	self.icon=icon
 	self.obj = obj
 	self.target_pos=target_pos
 	self.current_fun_item = self:get_fun_tb(self.function_id)
 	Net:receive(nil, ClientProto.HideAllOpenUI)
 	self:add_to_state()
 end
--解锁弹窗信息
 function FunctionUnlock:unlock_skill(icon,obj,target_pos,function_name,skill_id)
 	self.fun_type = 2
 	self.skill_id=skill_id
 	self.function_name=function_name
 	self.icon=icon
 	self.obj = obj
 	self.target_pos=target_pos
 	print("解锁技能")
 	Net:receive(nil, ClientProto.HideAllOpenUI)
 	-- self.current_fun_item = self:get_fun_tb(self.function_id)
 	self:add_to_state()
 end

--解锁显示条件
function FunctionUnlock:unlock_condition()

end

--点击事件
 function FunctionUnlock:on_click(obj,arg)
	self:call_event("function_unlock_view_on_click", false, obj, arg)
end

--初始化函数只会调用一次
function FunctionUnlock:initialize()
	self.fun_type = 0
	self.unlock = LuaItemManager:get_item_obejct("mainui").assets[1].child_ui.functionunlock
	self.fun_list = {}
	print("功能开启111")
end


function FunctionUnlock:updata_level_open(lv)
	if not self.level_open_tb then
		self.level_open_tb = copy(ConfigMgr:get_config("level_open"))
		for k,v in pairs(self.level_open_tb) do
			if v.btn_show == 0 then
				v.open = true
			end
		end
	end
	if not self.page_tb then
		self.page_tb = copy(ConfigMgr:get_config("init_page"))
	end
	for k,v in pairs(self.level_open_tb) do
		if not v.open and v.open_need_id <= lv and v.btn_show == 1 then
			v.open = true
		end
		if v.page and v.open_need_id <= lv then
			self:updata_page_tb(v.obj_name,v.page)
		end
	end
	return self.level_open_tb
end

function FunctionUnlock:updata_page_tb(tp,num)
	for k,v in pairs(self.page_tb or {}) do
	 	if v.btn_id == tp then
	 		v.page_tb[num] = 1
	 	end
	end 
end
--获取页签解锁(tp传按钮枚举)
function FunctionUnlock:get_page_tb(tp)
	for k,v in pairs(self.page_tb or {}) do
	 	if v.btn_id == tp then
	 		return v.page_tb
	 	end
	end 
end

function FunctionUnlock:init_fun_tips(lv)
	-- if not self.fun_tips_tb then
		print("功能预告"..lv)
		self.fun_tips_tb= copy(ConfigMgr:get_config("function_tips"))
		local tb = LuaItemManager:get_item_obejct("task"):get_task_list()
		local task_code = 0
		for k,v in pairs(tb or {} ) do
			if v.type == ServerEnum.TASK_TYPE.MAIN then
				task_code = v.code
			end
		end
		gf_print_table(tb,"功能预告")
		for k,v in pairs(self.fun_tips_tb) do
			if v.level<= lv and not v.open_type then
				v.open = true
			elseif v.level<= lv and v.open_type then
				if v.open_type < task_code or task_code == 0 then
					v.open = true
				end
				if not v.open then
					self.cur_fun_tips = v
					print("功能预告1")
					return self.cur_fun_tips
				end
			else
				self.cur_fun_tips = v
				print("功能预告2")
				return self.cur_fun_tips
			end
		end
	-- end
end

function FunctionUnlock:updata_fun_tips(tp,value)
	if tp == 1 then--等级
		if self.cur_fun_tips and  not self.cur_fun_tips.open_type and self.cur_fun_tips.level<= value then
			if self.cur_fun_tips.code < #self.fun_tips_tb then
				self.cur_fun_tips = self.fun_tips_tb[self.cur_fun_tips.code+1]
				Net:receive({fun_data = self.cur_fun_tips}, ClientProto.UpdateFunTips)
				self:updata_fun_tips(1,LuaItemManager:get_item_obejct("game"):getLevel())
			end
		end
	else
		if  self.cur_fun_tips and self.cur_fun_tips.open_type and self.cur_fun_tips.open_type == value then--and self.cur_fun_tips.level<= value 有可能出现等级问题
			if self.cur_fun_tips.code < #self.fun_tips_tb then
				self.cur_fun_tips = self.fun_tips_tb[self.cur_fun_tips.code+1]
				Net:receive({fun_data = self.cur_fun_tips}, ClientProto.UpdateFunTips)
				self:updata_fun_tips(1,LuaItemManager:get_item_obejct("game"):getLevel())
			end
		end
	end
end

function FunctionUnlock:get_cur_fun_tip()
	return self.cur_fun_tips
end

function FunctionUnlock:check_ishave_fun(f_id)
	for k,v in pairs(self.fun_list) do
		if v == f_id then
			return true
		end
	end
end

function FunctionUnlock:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("base")) then
		if id2 == Net:get_id2("base","OpenFuncR")  then
			gf_print_table(msg,"功能开启id")
			if msg.err == 0 then
				self:open_fun_s2c(msg)
				table.insert(self.fun_list,msg.funcId)
			end
		elseif id2 == Net:get_id2("base", "UpdateLvlR") then
			self:updata_fun_tips(1,msg.level)
        	-- print("功能人物升级了",self.fun_lv)
    --     	if self.fun_lv ~= nil then 
				-- if msg.level>= self.fun_lv then
					-- local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
     --    			if ConfigMgr:get_config("open_fun_scene")[map_id] ~=nil then
     --    				if  self.net_send_only then --限制当前开启功能次数
					-- 		self:open_fun_c2s(self.fun_id)
					-- 		print("功能协议发送成功",self.fun_id)
					-- 		self.net_send_only = false
					-- 	end
     --   				else
     --   					self.map_open_func = self.fun_id
     --   					self.outside = true
     --    			end
       		-- 	end
        	-- end
        	-- self:updata_level_open(msg.level)
        end
	elseif id1 == ClientProto.PlayerLoaderFinish then -- 进入地图
		local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
    	if ConfigMgr:get_config("open_fun_scene")[map_id] and self.outside then
    		self:loader_map_unluck()
    	end
    	print("功能开启进入地图",map_id)
    	if self.join_map_id and self.join_map_id == map_id then
    		self:loader_map_unluck()
    	end
    elseif(id1 == Net:get_id1("task")) then
    	if id2 == Net:get_id2("task", "TaskFinishR") then -- 通知任务结束
    		if self.task_id and self.task_ty == ServerEnum.TASK_STATUS.FINISH then
    			print("功能任务开启",self.task_id)
    			print("功能当前任务",msg.code)
    			if ConfigMgr:get_config("task")[msg.code].type == ServerEnum.TASK_TYPE.MAIN and  self.task_id <= msg.code then
    				self:open_fun_c2s(self.fun_id)
    			end
    		end
    		self:updata_fun_tips(2,msg.code)
    	elseif id2 == Net:get_id2("task", "AcceptTaskR") then -- 接任务
			if self.task_id and self.task_ty == ServerEnum.TASK_STATUS.PROGRESS then
    			print("功能任务开启",self.task_id)
    			print("功能当前任务",msg.code)
    			if  ConfigMgr:get_config("task")[msg.code].type == ServerEnum.TASK_TYPE.MAIN  and self.task_id <= msg.code then
    				self:open_fun_c2s(self.fun_id)
    			end
    		end
    	end
    elseif id1 == ClientProto.GuideFeeble then
    	self:check_feeble_guide(msg.code,msg.pos)
    elseif id1 == ClientProto.GuideFeebleClose then
    	self:feeble_guide_do(msg)
	end
end
--需要进入地图功能开启
function FunctionUnlock:loader_map_unluck()
	if self.map_open_func then
    	if  self.net_send_only then --限制当前开启功能次数
			self:open_fun_c2s(self.map_open_func)
			print("功能协议发送成功",self.map_open_func)
			self.net_send_only = false
			self.map_open_func = nil
		end
    end
end

function FunctionUnlock:open_fun_c2s(funid)
	Net:send({funcId = funid},"base","OpenFunc")
	local data =  ConfigMgr:get_config("function_tasks")[funid] 
	-- if data then
	-- 	LuaItemManager:get_item_obejct("task"):accept_task_c2s(data.task_id)
	-- end
end

function FunctionUnlock:open_fun_s2c(msg) --处理
	local unlock = LuaItemManager:get_item_obejct("mainui").assets[1].child_ui.functionunlock
	local tb =self:get_fun_tb(msg.funcId)
	gf_print_table(tb,"功能开启tb")
	if tb.open_type == ServerEnum.FUNC_CONDITION_TYPE.CLICK then --筛选弱指引
		return
	end
	if tb.open_type == Enum.FUNC_CONDITION_TYPE.PLAYER_LEVEL then
		self.fun_lv = nil
	elseif tb.open_type == Enum.FUNC_CONDITION_TYPE.TASK then
		self.task_id = nil
		self.task_ty = nil
	elseif tb.open_type == Enum.FUNC_CONDITION_TYPE.MAP then
		self.join_map_id = nil
	end
	if tb.next_function_id ~= 0 then
		self.net_send_only = true
	end
	if tb.guide_id ~= 0 and tb.open_ui_type ~= 2 then --指引开启
		self:open_fun_do(false)
	 	LuaItemManager:get_item_obejct("guide"):next(tb.guide_id)
	end
	self.outside = false
	unlock:unlock_what(tb)
end



--功能开启需要做的事情
function FunctionUnlock:open_fun_do(tf)
	Net:receive({is_open=true,fun_hide = tf }, ClientProto.OpenFunction) --功能开启
end
--功能开启结束
function FunctionUnlock:open_fun_over()
	Net:receive({is_open=false}, ClientProto.OpenFunction) -- 功能开启结束
end

--升级判断需要解锁功能
function FunctionUnlock:level_up_unlock(fid,lv)
	self.fun_lv = lv
	self.fun_id = fid
	self.net_send_only = true
end

function FunctionUnlock:task_finish_unlock(fid)
	self.net_send_only = false
	self.fun_id = fid
	self.task_id = self:get_fun_tb(fid).open_need_id
	self.task_ty = self:get_fun_tb(fid).open_task_status
end
function FunctionUnlock:get_fun_id()
	return self.fun_id
end

function FunctionUnlock:join_map_unlock(fid)
	self.net_send_only = true
	self.map_open_func = fid
	self.fun_id = fid
	self.join_map_id = self:get_fun_tb(fid).open_need_id
end
--获取功能tb
function FunctionUnlock:get_fun_tb(funid)
	local fun_tb=ConfigMgr:get_config("function_unlock")[funid]
	if fun_tb then 
		return fun_tb
	end 
end
function FunctionUnlock:open_skill_func()
	self:open_fun_over()
	Net:receive({}, ClientProto.OpenFuncSkill) 
end


function FunctionUnlock:fun_effect_save(f_id)
	local fun_tb = {}
	local role_id = LuaItemManager:get_item_obejct("game").role_id
	if PlayerPrefs.HasKey("fun_unlock"..role_id) then
		fun_tb = self:get_fun_effect()
	else
		fun_tb = {}
	end
	fun_tb[#fun_tb+1] = f_id
	self:set_fun_effect(fun_tb)
end
function FunctionUnlock:fun_effect_dispose(f_id)
	local fun_tb = self:get_fun_effect()
	local num = nil
	for k,v in pairs(fun_tb or {}) do
		if v == f_id then
			num = k
		end
	end
	if num then
	 	table.remove(fun_tb, k)
	end
	self:set_fun_effect(fun_tb)
end
function FunctionUnlock:set_fun_effect(tb)
	local s = serpent.dump(tb)
	local role_id = LuaItemManager:get_item_obejct("game").role_id
	PlayerPrefs.SetString("fun_unlock"..role_id,s)
end
function FunctionUnlock:get_fun_effect()
	local role_id = LuaItemManager:get_item_obejct("game").role_id
	local s = PlayerPrefs.GetString("fun_unlock"..role_id,"")
	if s~= "" then
		local tb = loadstring(s)()
		return tb
	end
end

function FunctionUnlock:check_feeble_guide(g_id,pos)
	if self:check_ishave_fun(g_id) then return end
	local data =  copy(ConfigMgr:get_config("click_fun")[g_id])
	if not self.show_feeble_guide_tb then
		self.show_feeble_guide_tb = {}
	end
	local index = #self.show_feeble_guide_tb+1
	self.show_feeble_guide_tb[index] = data
	self.show_feeble_guide_tb[index].tf_pos = pos
	if not self.guide_feeble_view then
		print("哦哦11")
		self.guide_feeble_view = require("models.guide.guide_text_tip")()
	end
end

function FunctionUnlock:get_feeble_guide()
	return self.show_feeble_guide_tb
end

function FunctionUnlock:feeble_guide_do(msg)
	if self:check_ishave_fun(msg.code) then return end
	if msg.type ~= 0 then
		self:open_fun_c2s(msg.code)
	end
	local index = nil
	for k,v in pairs(self.show_feeble_guide_tb or {}) do
		if v.code == msg.code then
			 index = k
			 break
		end
	end
	if index then
		table.remove(self.show_feeble_guide_tb,index)
	end
end