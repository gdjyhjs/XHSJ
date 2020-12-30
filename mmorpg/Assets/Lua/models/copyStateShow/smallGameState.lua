--[[--
-- 小游戏状态栏
-- @Author:xin
-- @DateTime:2017-12-29 
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commom_string =
{
	[1] = gf_localize_string("第%d波怪物来袭"),
	[2] = gf_localize_string("%s后降为%d星"),
	[3] = gf_localize_string("%s后通关失败"),
}

local res = 
{
	[1] = "copy_count_down_enter", 
	[2] = "copy_count_down_leave", 
	[3] = "copy_count_down_num_01", 
	[4] = "copy_count_down_num_02", 
	[5] = "copy_count_down_num_03", 
}
local copyStateBase = require("common.viewBase")

local smallGameState=class(copyStateBase,function(self)
	gf_create_model_view("empty")
	local item_obj = LuaItemManager:get_item_obejct("empty")
	self.item_obj = item_obj
	copyStateBase._ctor(self, "mainui_copy_casual_state.u3d", item_obj)
end)


-- 资源加载完成
function smallGameState:on_asset_load(key,asset)
	self:init_ui()
end

function smallGameState:init_ui()
	self.copy_id = gf_getItemObject("copy"):get_copy_id()
	self.time_txt = self.refer:Get(2)
	self:state_change(false)
	self.time = ConfigMgr:get_config("small_game_copy")[self.copy_id].limit_time + 3
	self.cur_time = Net:get_server_time_s()

	--开启动画
	self.refer:Get(4).gameObject:SetActive(true)
	self:set_anim(false)

	self:start_scheduler_tick()

	self.refer:Get(1):SetActive(false)
end

function smallGameState:rec_monster_event(msg,param_name)
	
	local monster_id = msg.monster_id
	--如果是在小游戏副本里
	local data_model = gf_getItemObject("copy")
	if data_model:is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME) then
		local copy_id = data_model:get_copy_id()
		local data = ConfigMgr:get_config("small_game_copy")[copy_id]
		if data and next(data[param_name]	) then
			for i,v in ipairs(data[param_name]	 or {}) do
				if v[1] == msg.monster_id then 
					local tips_data = ConfigMgr:get_config("small_game_tips")[v[2]]
					--中间飘字
					if tips_data.type == ServerEnum.SMALL_GAME_COPY_TIPS_TYPE.BELOW then
						self:show_tips(v[2])

					--怪物聊天气泡
					elseif tips_data.type == ServerEnum.SMALL_GAME_COPY_TIPS_TYPE.CREATURE_HEAD then
						local monster_list = gf_getItemObject("battle"):get_enemy_list()
						for i,vv in pairs(monster_list or {}) do
							if vv.guid == msg.guid then
								self:show_pop_tips(vv,v[2])
							end
						end

					end
					
				end
			end
		end

	end
end

--飘字
function smallGameState:show_tips(tipCode,arg)
	local desc = ConfigMgr:get_config("small_game_tips")[tipCode].desc
	if arg then
		desc = string.format(desc,unpack(arg))
	end
	self.refer:Get(3).text = desc
	self.show_tips_end_time = Net:get_server_time_s() + 4
end

--怪物气泡
function smallGameState:show_pop_tips(monster,tipCode,arg)
	local desc = ConfigMgr:get_config("small_game_tips")[tipCode].desc
	if arg then
		desc = string.format(desc,unpack(arg))
	end
	monster.blood_line:set_monster_talk_text(desc)
end

--带参数飘字	
function smallGameState:show_arg_tips(msg)
	--如果是怪物的
	if msg.guid then
		local monster_list = gf_getItemObject("battle"):get_enemy_list()
		for i,vv in pairs(monster_list or {}) do
			if vv.guid == msg.guid then
				self:show_pop_tips(vv,msg.tipCode,msg.args)
			end
		end
		return
	end
	self:show_tips(msg.tipCode,msg.args)
end


--倒计时
function smallGameState:update_time(time)
	self.refer:Get(2).text = gf_convert_time_ms(time)
end

function smallGameState:update_view( dt )
		if self.pass_time_end then
			if Net:get_server_time_s() - self.pass_time_end >= 0 then
				self:stop_schedule()
				LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
				self.pass_time_end = nil
				return
			end
			self:show_anim(3 - self.pass_time_end + Net:get_server_time_s())
			return
		end

		local leave_time = Net:get_server_time_s() - self.cur_time
		--更新倒计时
		local time = self.time - leave_time

		if leave_time <= 3 then 
			self:show_anim(leave_time)
			return
		end

		--如果leave_time 大于等于3关闭动画
		if leave_time >= 3  then
			if self.refer:Get(7).gameObject.activeSelf then
				self.refer:Get(1):SetActive(true)
				self.refer:Get(7).gameObject:SetActive(false)
				self.refer:Get(4).gameObject:SetActive(false)
				--开始挂机 关闭屏蔽点击层
				self:state_change(true)
			end
			self:update_time(time)
		end
		
		--时间到了 退出副本
		if time <= 0 and not self.pass_time_end then
			self:stop_schedule()
			LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
		end
			
		if self.show_tips_end_time and Net:get_server_time_s() - self.show_tips_end_time >= 0 then
			self.refer:Get(3).text = ""
		end
end

function smallGameState:set_anim(is_leave)
	self.refer:Get(8):SetActive(is_leave)
	self.refer:Get(6):SetActive(not is_leave)
end

function smallGameState:show_anim(time)
	time = math.ceil(time)
	time = time > 0 and time or 1
	print("wtf show anim time:",time)
	gf_setImageTexture(self.refer:Get(5),res[6 - time])
end

function smallGameState:state_change(is_begin)
	print("set state :",is_begin)
	self.refer:Get(7):SetActive(not is_begin)
	gf_auto_atk(is_begin)
end

function smallGameState:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function smallGameState:start_scheduler_tick()
	if self.schedule_id_tick then
		self:stop_schedule()
	end
	local update = function()
		self:update_view()
	end
	self.schedule_id_tick = Schedule(update, 0.1)
end

function smallGameState:stop_schedule()
	if self.schedule_id_tick then
		self.schedule_id_tick:stop()
		self.schedule_id_tick = nil
	end
end


function smallGameState:on_hided()
	self:stop_schedule()
	smallGameState._base.on_hided(self)

end

function smallGameState:dispose()
	self:stop_schedule()
	smallGameState._base.dispose(self)
end

function smallGameState:on_receive(msg, id1, id2, sid)
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "PassCopyR") then
			self.pass_time_end = Net:get_server_time_s() + 3
			self:set_anim(true)
			self.refer:Get(4).gameObject:SetActive(true)
			gf_receive_client_prot({visible = true}, ClientProto.CopyExitButtonEffect)

		elseif id2 == Net:get_id2("copy","SmallGameTipsR") then
			self:show_arg_tips(msg)

		end
	end
	if id1 == ClientProto.FinishScene then
		if gf_getItemObject("copy"):is_story() then
		else
			self:dispose()
		end
	end
	if id1 == ClientProto.MonsterLoaderFinish then
		self:rec_monster_event(msg,"creature_talk")

	end

	if id1 == ClientProto.MonsterDead then
		self:rec_monster_event(msg,"creature_death_tips")

	end
end

return smallGameState

