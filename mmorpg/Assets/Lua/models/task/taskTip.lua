--[[--
--
-- @Author:Seven
-- @DateTime:2017-12-21 20:03:46
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local TaskTip=class(UIBase,function(self)
	self.item_obj =  LuaItemManager:get_item_obejct("task")
    UIBase._ctor(self, "task_tip.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function TaskTip:on_asset_load(key,asset)
	StateManager:register_view(self)
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	self:init_tb()
end
function TaskTip:init_tb()
	self.level_path_tb =  copy(ConfigMgr:get_config("level_path"))
	if LuaItemManager:get_item_obejct("zorkPractice"):get_practice_time()>0 then
		self.level_path_tb[1].open = true
	end
	if LuaItemManager:get_item_obejct("activeDaily"):get_everday_task_curTimes()<20 then
		self.level_path_tb[2].open = true
	end
	if LuaItemManager:get_item_obejct("husong"):get_today_times()~=0 then
		self.level_path_tb[3].open = true
	end
	if not LuaItemManager:get_item_obejct("activeDaily"):get_daily_over(self.level_path_tb[4].daily_id) then
		self.level_path_tb[4].open = true
	end
	local pvp_time = LuaItemManager:get_item_obejct("pvp"):get_left_challenge_count()
	if	pvp_time>0 then
		self.level_path_tb[5].open = true
	elseif pvp_time == 0 and LuaItemManager:get_item_obejct("pvp"):get_left_buy_count()>0 then 
		self.level_path_tb[5].open = false
	end
	local jq_strenght = LuaItemManager:get_item_obejct("game"):get_strenght()
	if jq_strenght>0 then
		self.level_path_tb[6].open = true
	elseif jq_strenght== 0 and gf_getItemObject("game"):get_strenght_buy_count()>0 then
		self.level_path_tb[6].open = false
	end
	local copy_time =  gf_getItemObject("copy"):get_material_copy_count(ServerEnum.COPY_TYPE.MATERIAL)
	if copy_time>0 then
		self.level_path_tb[7].open = true
	elseif copy_time ==0 and gf_getItemObject("copy"):get_material_copy_buy_count(ServerEnum.COPY_TYPE.MATERIAL) > 0 then
		self.level_path_tb[7].open = false
	end
	local copy_time =  gf_getItemObject("copy"):get_material_copy_count(ServerEnum.COPY_TYPE.MATERIAL2)
	if copy_time>0 then
		self.level_path_tb[8].open = true
	elseif copy_time ==0 and gf_getItemObject("copy"):get_material_copy_buy_count(ServerEnum.COPY_TYPE.MATERIAL2) > 0 then
		self.level_path_tb[8].open = false
	end
	if gf_get_config_const("team_copy_enter_count")>0 then
		self.level_path_tb[9].open = true
	end
	if not self.level_path_tb[1].open then
		self.level_path_tb[10].open = true
	end
	local sortFunc = function(a, b)
       	return a.order <= b.order
    end
 	table.sort(self.level_path_tb,sortFunc)
	local data = {}
	local index = 0
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local d_tb =  ConfigMgr:get_config("daily")
	for k,v in pairs(self.level_path_tb) do
		if v.open ~= nil and index <5 and lv >= d_tb[v.daily_id].level then
			index = index +1
			data[#data+1] = v
		end
	end
	if index <5 then--自适应
		local width = 168.8
		local height = 43*index+18
		self.refer:Get(2).transform.sizeDelta =Vector2(width,height)
	end
	self:refresh(data)
end
function TaskTip:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function TaskTip:update_item(item,index,data)
	item:Get(1).text = data.name
end

function TaskTip:on_click(obj,arg)
	local cmd = obj.name
	if cmd == "item(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:go_up_level(arg.data)
		self:dispose()
	elseif cmd == "btnClose" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

function TaskTip:go_up_level(data)
	local cmd =data.code
	if cmd == 1 then
		gf_create_model_view("zorkPractice")
	elseif cmd == 2 then
		LuaItemManager:get_item_obejct("activeDaily"):open_activeDaily_view(1)
		-- gf_create_model_view("activeDaily")
	elseif cmd == 3 then
		if  LuaItemManager:get_item_obejct("husong"):is_husong() then
			gf_message_tips("正在护送")
			Net:receive({code = self.husong_info.taskCode},ClientProto.HusongNPC)
		else
			if LuaItemManager:get_item_obejct("husong").todayTimes ~=0 then
				LuaItemManager:get_item_obejct("husong"):transfer_husong()
			else
				gf_message_tips("今天护送次数已达到上限")
			end
		end
	elseif cmd == 4 then
		gf_create_model_view("exam")
	elseif cmd == 5 then
		if data.open then
			gf_create_model_view("pvp")
		else

		end
	elseif cmd == 6 then
		if data.open then
			gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.STORY)
		else
			
		end
	elseif cmd == 7 then
		if data.open then
			gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.MATERIAL)
		else
			
		end
	elseif cmd == 8 then
		if data.open then
			gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.MATERIAL)
		else
			
		end	
	elseif cmd == 9 then
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.TEAM)
	elseif cmd == 10 then
		gf_create_model_view("zorkPractice")
	end
end

-- 释放资源
function TaskTip:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return TaskTip

