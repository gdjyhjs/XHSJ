--[[
	module:军团副本小玩法任务面板
	at 2017.11.6
	by xin
]]


local commom_string = 
{
	[1] = gf_localize_string(""),
}


local res = 
{
	[1] = "mainui_copy_casual.u3d", 
}

local py1,py2 = 75.6,80 
local heightOff = 67.4

local legionCopyGameView=class(UIBase,function(self, item_obj)
	UIBase._ctor(self, res[1], item_obj)
end)

function legionCopyGameView:dataInit()
	self:referInit()

end

-- 资源加载完成
function legionCopyGameView:on_asset_load(key,asset)
	StateManager:register_view(self)
	self:set_visible(false)

	self:set_always_receive(true)
	self:dataInit()
	
end

function legionCopyGameView:referInit()
	self.action = self.refer:Get(3)
	self.action.from = self.action.transform.localPosition
	self.action.to = self.action.transform.localPosition + Vector3(-265, 0, 0)

	-- self.action1 = self.refer:Get(7)
	-- self.action1.from = Vector3(0.5, 0.5, 0.5)
	-- self.action1.to = Vector3(1, 1, 1)
end

function legionCopyGameView:init_ui()
	print("wtf init_ui")
	if not LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME) then
		self:set_visible(false)
		return
	end
	self:set_visible(true)


	self.copy_id = gf_getItemObject("copy"):get_copy_id()

	self:init_details()

	self:update_schedule({})
end

function legionCopyGameView:init_details()
	self.refer:Get(2).text = ConfigMgr:get_config("small_game_copy")[self.copy_id].pass_tips
end

--副本进度
function legionCopyGameView:update_schedule(schedule)
	local data = ConfigMgr:get_config("small_game_copy")[self.copy_id]
	local target_str = ""
	
	for i=1,3 do
		local str = data["target_desc"..i]
		if str and str ~= "" then
			local target_count = data.target[i]
			target_str = target_str .. string.format("%s : %d/%d "..(i == #data.condition_type and "" or "\n"),str,schedule[i] or 0,target_count or 0)
		end
	end
	
	print("wtf target:",target_str)
	self.refer:Get(1).text = target_str
end

-- function legionCopyGameView:start_scheduler()
-- 	if self.schedule_id then
-- 		self:stop_schedule()
-- 	end
	
-- 	local update = function()

-- 		if self.pass_time_end then
-- 			if Net:get_server_time_s() - self.pass_time_end >= 0 then
-- 				self:stop_schedule()
-- 				LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
-- 				self.pass_time_end = nil
-- 			end
-- 			return
-- 		end

-- 		local leave_time = Net:get_server_time_s() - self.cur_time
-- 		--更新倒计时
-- 		local time = self.time - leave_time
-- 		--如果leave_time 大于等于3关闭动画
-- 		if leave_time >= 3  then
-- 			if self.refer:Get(5).gameObject.activeSelf then
-- 				self.refer:Get(5).gameObject:SetActive(false)
-- 				--开始挂机 关闭屏蔽点击层
-- 				self:state_change(true)
-- 			end
			
-- 			self:update_time(time)
-- 		end
		
-- 		--时间到了 退出副本
-- 		if time <= 0 and not self.pass_time_end then
-- 			-- self:show_default_view()
-- 			self:stop_schedule()
-- 			LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
-- 		end
-- 		-- if time <= -1 then
-- 		-- 	self.action1:ResetToBeginning()
-- 		-- 	self.refer:Get(6):SetActive(false)

-- 		-- 	self:stop_schedule()
-- 		-- 	LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
-- 		-- end
			
-- 		if self.show_tips_end_time and Net:get_server_time_s() - self.show_tips_end_time >= 0 then
-- 			self.refer:Get(10).text = ""
-- 		end

-- 	end
-- 	update()
-- 	self.schedule_id = Schedule(update, 0.1)
-- end

-- function legionCopyGameView:show_default_view()
-- 	self.refer:Get(6):SetActive(true)
-- 	self.action1:PlayForward()
-- end	

--倒计时
-- function legionCopyGameView:update_time(time)
-- 	self.refer:Get(4).text = gf_convert_time_ms(time)
-- end

-- function legionCopyGameView:stop_schedule()
-- 	if self.schedule_id then
-- 		self.schedule_id:stop()
-- 		self.schedule_id = nil
-- 	end
-- end
-- function legionCopyGameView:state_change(is_begin)
-- 	print("set state :",is_begin)
-- 	self.refer:Get(9):SetActive(not is_begin)
-- 	gf_auto_atk(is_begin)
-- end
--isShow  是否显示出来
function legionCopyGameView:showAction(isShow)
	if not self.action then
		return
	end
	if not isShow then
		self.action:PlayForward()
	else
		self.action:PlayReverse()
	end
end

function legionCopyGameView:setParent(parent)
	parent:add_child(self.root)
end







-- function legionCopyGameView:copy_pass(msg)
-- 	-- self:stop_schedule()
-- 	self.refer:Get(5).gameObject:SetActive(true)
-- 	gf_setImageTexture(self.refer:Get(11), res[3])
-- 	self.pass_time_end = Net:get_server_time_s() + 3
-- end


-- function legionCopyGameView:rec_monster_create(msg)
-- 	gf_print_table(msg, "wtf create monster ")
-- 	local monster_id = msg.monster_id
-- 	--如果是在小游戏副本里
-- 	local data_model = gf_getItemObject("copy")
-- 	if data_model:is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME) then
-- 		local copy_id = data_model:get_copy_id()
-- 		local data = ConfigMgr:get_config("small_game_copy")[copy_id]
-- 		if data and next(data.creature_talk) then
-- 			for i,v in ipairs(data.creature_talk or {}) do
-- 				if v[1] == msg.monster_id then 
-- 					local tips_data = ConfigMgr:get_config("small_game_tips")[v[2]]
-- 					--中间飘字
-- 					if tips_data.type == ServerEnum.SMALL_GAME_COPY_TIPS_TYPE.BELOW then
-- 						self:show_tips(v[2])

-- 					--怪物聊天气泡
-- 					elseif tips_data.type == ServerEnum.SMALL_GAME_COPY_TIPS_TYPE.CREATURE_HEAD then
-- 						local monster_list = gf_getItemObject("battle"):get_enemy_list()
-- 						for i,vv in pairs(monster_list or {}) do
-- 							if vv.guid == msg.guid then
-- 								self:show_pop_tips(vv,v[2])
-- 							end
-- 						end

-- 					end
					
-- 				end
-- 			end
-- 		end

-- 	end

-- end



function legionCopyGameView:on_receive(msg, id1, id2, sid)
	
	if(id1==Net:get_id1("copy"))then

		if id2 == Net:get_id2("copy", "PassCopyR") then -- 通关
			gf_print_table(msg, "wtf PassCopyR:")
			-- self:copy_pass(msg)

		elseif id2 == Net:get_id2("copy","SmallGameInfoR") then
			gf_print_table(msg, "SmallGameInfoR:")
			self:update_schedule(msg.schedule)

		elseif id2 == Net:get_id2("copy","SmallGameTipsR") then
			-- self:show_arg_tips(msg)

		end
	end

	if id1 == ClientProto.AllLoaderFinish then
		self:init_ui()
	end

	

end

function legionCopyGameView:on_showed()
	
end

function legionCopyGameView:on_hided()
	-- StateManager:remove_register_view(self)
	-- self:stop_schedule()
end
-- 释放资源
function legionCopyGameView:dispose()
	-- self:stop_schedule()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return legionCopyGameView

