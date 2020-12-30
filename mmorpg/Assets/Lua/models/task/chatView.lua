--[[--
-- 任务对话
-- @Author:Seven
-- @DateTime:2017-06-10 10:08:46
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local UIModel = require("common.uiModel")
local Game = LuaItemManager:get_item_obejct("game")
-- local auto_time = 5 -- 自动做任务
local ChatView=class(UIBase,function(self,item_obj)

	self.task_item = LuaItemManager:get_item_obejct("task")
	self.last_model_name = nil -- 上一次显示的模型

	self.is_init = false
	
    UIBase._ctor(self, "npcchat.u3d", item_obj) -- 资源名字全部是小写

    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function ChatView:on_asset_load(key,asset)
	self.is_init = true
	self:register()

	self:hide()
	self:init_ui()
end

function ChatView:init_ui()
	self.name_txt = LuaHelper.FindChildComponent(self.root,"txt_npc_name","UnityEngine.UI.Text")
	self.dialogue_txt = LuaHelper.FindChildComponent(self.root,"txt_ch_dialogue","UnityEngine.UI.Text")

	self.model = LuaHelper.FindChild(self.root, "model")
	self.model_camera = LuaHelper.FindChild(self.model, "camera")

	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	self.itemScrollVContent = self.refer:Get("itemScrollVContent")
	self.itemScrollVContent.onItemRender = handler(self, self.update_items)
	-- self:auto_do_task()
end

function ChatView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1)
end

function ChatView:update_item( item, index, data )
	item:Get(1).text = data.name
end

function ChatView:refresh_item(data)
	self.itemScrollVContent.data = data
	self.itemScrollVContent:Refresh(-1,-1)
end

function ChatView:update_items( item, index, data )
	if data.num then
		item:Get(3).text = gf_format_count(data.num)
	else
		item:Get(3).text = ""
	end
	-- if data.formuleId then
	-- 	local tb = ConfigMgr:get_config("equip_formula")[data.formuleId]
	-- 	if ConfigMgr:get_config("t_misc").guide_protect_level <= Game:getLevel() then
	-- 		print("对话的",data.formuleId,tb.color_prob[#tb.color_prob][2])
	-- 		gf_set_click_prop_tips(item:Get(1).gameObject,data.formuleId)--tonumber(tb.color_prob[#tb.color_prob][2]
	-- 	end
	-- 	gf_set_item(tb.code,item:Get(2),item:Get(1),tb.color_prob[#tb.color_prob][2])
	-- else
	if ConfigMgr:get_config("t_misc").guide_protect_level <= Game:getLevel() then
		gf_set_click_prop_tips(item.gameObject,data.code)
	end
	gf_set_item(data.code,item:Get(2),item:Get(1),data.color,data.star_count)
	-- end
	local tb = ConfigMgr:get_config("item")
	if tb[data.code].bind == 1 then
		item:Get("binding"):SetActive(true)
	else
		item:Get("binding"):SetActive(false)
	end
end

-- 设置对话
function ChatView:set_chat( data, no_task )
	if not data then
		print_error("任务数为空")
		print("任务数为空")
		return
	end


	self.index = 1
	self.no_task = no_task
	self:refresh_item()
	if not no_task then
		self.task_data = data
		self.talk_data = self:get_talk_list(self.task_data)
		self.name_txt.text, self.npc_id = self:get_name(self.task_data)
		self:show_chat()
		-- self:refresh(gf_get_npc_event(self.npc_id))
		self:refresh() --清空之前不是任务对话的事件
	else
		local tb = ConfigMgr:get_config("npc")[data.code]
		self.name_txt.text = tb.name
		if tb.talk_num and tb.task_num ~=1 then
			local npc_day_talk = LuaItemManager:get_item_obejct("npc").npc_day_talk
			for k,v in pairs(npc_day_talk or {}) do
				if v.code == data.code then
					local tb1 = {}
					if v.cur_talk_num then
						tb1 = gf_getNRandom(1,tb.talk_num,1,{v.cur_talk_num})
					else
						tb1 =gf_getNRandom(1,tb.talk_num,1,{})
					end
					v.cur_talk_num = tb1[1]
					self.dialogue_txt.text = tb["content"..v.cur_talk_num]
				end
			end
		else
			self.dialogue_txt.text = tb.content1
		end
		local scale = (data.scale or 100)*0.01
		local pos
		if data.height then
			pos = Vector3(0,-3+data.height*0.01,4)
		end
		self:refresh_model(data.model..".u3d", Vector3(scale,scale,scale), pos)
	end
	self.refer:Get(3):SetActive(false)
	--完成按钮
	if data then
		if data.type == ServerEnum.TASK_TYPE.ESCORT and data.status ~= ServerEnum.TASK_STATUS.FINISH then --护送任务按钮
			if LuaItemManager:get_item_obejct("husong").isExpired == 1 then
				self.dialogue_txt.text = gf_localize_string("护送失败")
			end
			self.refer:Get(3):SetActive(true)
			self.refer:Get(5).text = gf_localize_string("领取奖励")
			self.refer:Get(7):SetActive(true)
		--如果是军团任务 显示为接取
		elseif data.status == ServerEnum.TASK_STATUS.COMPLETE and data.finish_npc == self.npc_id and data.type == ServerEnum.TASK_TYPE.ALLIANCE_REPEAT then
			self.refer:Get(3):SetActive(true)
			self.refer:Get(5).text = gf_localize_string("接取任务")
			self.refer:Get(7):SetActive(false)
		elseif data.status == ServerEnum.TASK_STATUS.AVAILABLE and data.receive_npc == self.npc_id then
			self.refer:Get(3):SetActive(true)
			self.refer:Get(5).text = gf_localize_string("接取任务")
			self.refer:Get(7):SetActive(false)
		elseif data.status == ServerEnum.TASK_STATUS.COMPLETE and data.finish_npc == self.npc_id then
			self.refer:Get(3):SetActive(true)
			self.refer:Get(5).text = gf_localize_string("提交任务")
			self.refer:Get(7):SetActive(true)
			self:set_award(data)
		end
	end

	-- 是否是跳过剧情
	if self.task_item:is_skip_story() then
		self:notice_finish_talk()
		return
	end
	self:show()
	if data then
		self:check_need_guide(data.code,data.status)
	end
	self.is_hide_mainui = true
end

function ChatView:set_award(data)
	-- local task_tb = ConfigMgr:get_config("task_show_award")[data.code]
	-- if task_tb.status
	-- if task_tb then
	-- 	if not task_tb.status or task_tb.status == data.status then

	-- 		self:refresh_item(tb)
	-- 	else
	-- 		self:refresh()
	-- 	end
	-- elseif data.status == ServerEnum.TASK_STATUS.COMPLETE then
	local tb = {}
	local base_data = ConfigMgr:get_config("base_res")
	if data.exp_reward and data.exp_reward[1]~= 0 then
		local x_id = base_data[ServerEnum.BASE_RES.EXP].item_code
		tb[#tb+1] = {code = x_id,num = data.exp_reward[1]}
	end
	if data.money_reward and #data.money_reward ~= 0 then
		for k,v in pairs(data.money_reward) do
			tb[#tb+1] = {code =base_data[v[1]].item_code,num = v[2][1]}
		end
	end
	if data.item_reward and #data.item_reward~= 0 then
		for k,v in pairs(data.item_reward or {}) do
			if v and #v~=0 then
				tb[#tb+1] = {code = v[1],num = v[2],color=v[4],star_count = v[5]}
			end
		end
	end
	local career = Game:get_career()
	if data["career_"..career] and #data["career_"..career] ~= 0 then
		for k,v in pairs(data["career_"..career]) do
			tb[#tb+1] = {code =v[1],num = v[2]}
		end
	end
	self.cur_item_tb = tb
	LuaItemManager:get_item_obejct("task"):preread_task_reward(data.code)
	-- end
end

function ChatView:show_chat()
	if self.schedule_hide then
		self.schedule_hide:stop()
		self.schedule_hide = nil
	end
	if not self.talk_data or self.index > #self.talk_data then

		-- local delay_fn = function()
		self:latency_hiding()
		-- end
		-- self.dlay = PLua.Delay(delay_fn, 0.1)

		self:notice_finish_talk()
		self.talk_data = nil
		return
	end
	
	local talk_id = self.talk_data[self.index]
	
	local config_data = ConfigMgr:get_config("task_talk")[talk_id]
	if config_data then
		self.dialogue_txt.text = config_data.content
	else
		print("Error:找不到对话表数据，id = ",talk_id)
	end
	self.index = self.index + 1

	if config_data.head > 0 then -- 显示对话头像
		local scale
		if config_data.scale or config_data.scale > 0 then
			scale = (config_data.scale or 100)*0.01
			scale = Vector3(scale, scale, scale)
		end

		self:refresh_model(config_data.head..".u3d", scale)
	else -- 对话头像为0,显示npc头像
		local npc_data = ConfigMgr:get_config("npc")[self.npc_id]
		local scale = (npc_data.scale or 100)*0.01
		local pos
		if npc_data.height then
			pos = Vector3(0,-3+npc_data.height*0.01,4)
		end
		self:refresh_model(npc_data.model..".u3d", Vector3(scale,scale,scale), pos)
	end
	-- self:auto_do_task()
end

-- 获取名字
function ChatView:get_name( task_data )
	local target_list = self.task_item:get_target_list(task_data)
	local sub_type = task_data.sub_type

	if #target_list > 0 then
		local name = ""
		if sub_type == ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP then
			for i,v in ipairs(target_list) do
				name = name..ConfigMgr:get_config("npc")[v].name..(i>1 and "," or "")
			end
			
		end

		return name, target_list[1]
	end
	return ""
end

-- 获取对话内容
function ChatView:get_talk_list(task_data)
	local status = task_data.status

	if status == ServerEnum.TASK_STATUS.AVAILABLE then
		return task_data.receive_text

	elseif status == ServerEnum.TASK_STATUS.COMPLETE or task_data.type == ServerEnum.TASK_TYPE.ESCORT then
		return task_data.finish_text
		
	end

	return {}
end

function ChatView:refresh_model( model_name, scale, pos )
	if self.last_model_name ~= model_name then
		self.last_model_name = model_name

		-- 清除camera下面的所有模型
		-- local eachFn =function(i,obj)
		-- 	LuaHelper.Destroy(obj)
		-- end
		-- LuaHelper.ForeachChild(self.model_camera,eachFn)
		if self.model.transform:FindChild("my_model") then
 			LuaHelper.Destroy(self.model.transform:FindChild("my_model").gameObject)
 		end
		local callback = function(c_model)
			c_model.name = "my_model"
		end

		pos = pos or Vector3(0,-3,4)
		self.ui_model = UIModel(self.model, pos, nil, nil, {model_name = model_name, default_angles = Vector3(0,180,0), scale_rate = scale},callback)
	end
end

-- 通知服务器完成npc对话
function ChatView:notice_finish_talk()
	if not self.task_data then return end
	self:check_story(self.task_data)

	-- 完成和npc对话
	self.task_item:cossip_with_npc(self.npc_id)

	local status = self.task_data.status

	if status == ServerEnum.TASK_STATUS.AVAILABLE or status == ServerEnum.TASK_STATUS.NONE then -- 接任务
		--对完话接取军团重复任务
		if self.task_data.type == ServerEnum.TASK_TYPE.ALLIANCE_GUILD then
			--删除引导任务
			gf_getItemObject("task"):remove_task(self.task_data.code)
			gf_getItemObject("legion"):accept_legion_task_c2s()
			return
		end
		if self.task_data.type == ServerEnum.TASK_TYPE.EVERY_DAY_GUILD then
			gf_getItemObject("task"):remove_task(self.task_data.code)
			gf_getItemObject("activeDaily"):accept_everyday_task_c2s()
			return
		end
		self.task_item:accept_task_c2s(self.task_data.code)

	elseif status == ServerEnum.TASK_STATUS.COMPLETE and self.task_data.type ~= ServerEnum.TASK_TYPE.ESCORT then -- 提交任务(不包括护送失败)
		if self.task_data.handup_type == ServerEnum.TASK_HANDUP_TYPE.FIND_NPC then

			self.task_item:task_hand_up_c2s(self.task_data.code)
		end
	
	end
end

-- 跳过剧情
function ChatView:skip_story()
	if self.no_task then
		self:latency_hiding()
		return
	end
	self.task_item:set_skip_story(true)
	self:notice_finish_talk()
	self:latency_hiding()
end

-- 对应npc事件触发的东西
function ChatView:on_npc_event( data )
	if data.content_ty == ClientEnum.NPC_CONTENT_TY.COPY then -- 进入副本
		LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(data.content)

	elseif data.content_ty == ClientEnum.NPC_CONTENT_TY.TASK then -- 任务

	elseif data.content_ty == ClientEnum.NPC_CONTENT_TY.MAP  then -- 传送到某张地图
		LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(data.content)

	elseif data.content_ty == ClientEnum.NPC_CONTENT_TY.HUSONG  then --打开某个界面
		-- gf_create_model_view("husong")
		LuaItemManager:get_item_obejct("husong"):escort_finish_ok_c2s()
	elseif data.content_ty == ClientEnum.NPC_CONTENT_TY.FACTION  then -- 提交采集珠给军需官
		LuaItemManager:get_item_obejct("rvr"):faction_hand_up_c2s()
	end
end

-- 检查是否有剧情
function ChatView:check_story( task_data )
	if task_data == nil then return end
	local data = ConfigMgr:get_config("task_story")[task_data.code]
	if not data or data.status ~= task_data.status then
		return
	end
	local story_data = ConfigMgr:get_config("story")[data.story_id]
	if not story_data then
		print_error("找不到剧情数据 id =",data.story_id)
		return
	end
	LuaItemManager:get_item_obejct("story"):set_data(story_data)
end

function ChatView:register()
	StateManager:register_view( self )
end

function ChatView:cancel_register()
	StateManager:remove_register_view( self )
end

function ChatView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "panel_btn_next" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.no_task then
			self:latency_hiding()
		else
			self:show_chat()
		end
	elseif cmd == "btn_chat1" or cmd == "btn_chat2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.no_task then
			self:latency_hiding()
		else
			self:show_chat()
		end
	elseif cmd == "btn_skip" then -- 跳过剧情，跳过当前npc所有剧情
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:skip_story()

	elseif cmd == "preItem(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:latency_hiding()
		self:on_npc_event(arg.data)
	elseif	cmd== "btnGet" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.task_data.type == ServerEnum.TASK_TYPE.ESCORT then 
			local data = {}
			data.content_ty = ClientEnum.NPC_CONTENT_TY.HUSONG
			self:on_npc_event(data)
		else
			self:show_chat()
		end
		self:latency_hiding()
	end
end

function ChatView:on_receive( msg, id1, id2, sid )
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
				for kk,vv in pairs(self.cur_item_tb or {} ) do
					if v.code == vv.code then
						vv.num = v.num
					end 
				end
			end
			self:refresh_item(self.cur_item_tb)
		end
	elseif id1 ==  ClientProto.AutoDotask then 
        if not msg then
            self:auto_do_task()
        end
	end
end

function ChatView:latency_hiding()  --延迟0.1s隐藏防止点击地板移动（暂时）
	-- if not self.schedule_hide then
	-- 	self.schedule_hide = Schedule(handler(self, function()
					self:hide()
		-- 			self.schedule_hide:stop()
		-- 			self.schedule_hide = nil
		-- end), 0.1)
end

function ChatView:auto_do_task()
	-- local newcomerlevel=ConfigMgr:get_config("t_misc").guide_protect_level --新手等级限制

	-- if not self.schedule_hide and gf_getItemObject("game"):getLevel()<= newcomerlevel then
	-- 	self.schedule_hide = Schedule(handler(self, function()
		self:show_chat()
		Net:receive(true, ClientProto.AutoDotask)
	-- 	end), auto_time )
	-- end
end
--开头任务指引
function ChatView:check_need_guide(code,status)
	self.index_guide = nil
	if code == 100001 and status == ServerEnum.TASK_STATUS.COMPLETE then
		Net:receive({code = ClientEnum.GUIDE_FEEBLE.TASK_100001_3 ,pos = self.refer:Get(5).gameObject.transform.position }, ClientProto.GuideFeeble)
		self.index_guide = ClientEnum.GUIDE_FEEBLE.TASK_100001_3
	elseif code == 100002 and status == ServerEnum.TASK_STATUS.AVAILABLE then
		Net:receive({code = ClientEnum.GUIDE_FEEBLE.TASK_100002_1 ,pos = self.refer:Get(5).gameObject.transform.position }, ClientProto.GuideFeeble)
		self.index_guide = ClientEnum.GUIDE_FEEBLE.TASK_100002_1
	elseif	code == 100002 and status == ServerEnum.TASK_STATUS.COMPLETE then
		Net:receive({code = ClientEnum.GUIDE_FEEBLE.TASK_100002_3 ,pos = self.refer:Get(5).gameObject.transform.position }, ClientProto.GuideFeeble)
		self.index_guide = ClientEnum.GUIDE_FEEBLE.TASK_100002_3
	end
end
function ChatView:clear_guide()
	if self.index_guide then
		Net:receive({code = self.index_guide,type = 0 },ClientProto.GuideFeebleClose)
	end
end

function ChatView:on_showed()
	if self.dlay then
		PLua.StopDelay(self.dlay)
	end

	if self.is_init then
		-- self:auto_do_task()
		if self.ui_model then
			self.ui_model:on_showed()
		end
		-- 隐藏主ui
		Net:receive({visible = false}, ClientProto.HidOrShowMainUI)
		Net:receive(nil, ClientProto.HideAllOpenUI)
	end
end

function ChatView:on_hided()
	if self.schedule_hide then
		self.schedule_hide:stop()
		self.schedule_hide = nil
	end
	self:clear_guide()
	if self.is_hide_mainui then
		-- 显示主ui
		Net:receive({visible = true}, ClientProto.HidOrShowMainUI)
	end
end

-- 释放资源
function ChatView:dispose()
	if self.schedule_hide then
		self.schedule_hide:stop()
		self.schedule_hide = nil
	end
	self:cancel_register()
    self._base.dispose(self)
end

return ChatView

