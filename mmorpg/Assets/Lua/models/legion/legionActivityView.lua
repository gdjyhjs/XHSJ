--[[--
-- 军团活动界面
-- @Author:Seven
-- @DateTime:2017-06-19 21:07:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")

local LegionActivityView=class(UIBase,function(self,tag)
	self.tag = tag
	local item_obj = gf_getItemObject("legion")
    UIBase._ctor(self, "legion_activity_welfare.u3d", item_obj) -- 资源名字全部是小写
end)

local type2type =
{
	[ClientEnum.LEGION_SUB_VIEW.BOSS] 		= ServerEnum.ALLIANCE_ACTIVITY.ANCIENT_BOSS,
	[ClientEnum.LEGION_SUB_VIEW.PART] 		= ServerEnum.ALLIANCE_ACTIVITY.LEGION_PARTY,
	[ClientEnum.LEGION_SUB_VIEW.NEEDFIRE] 	= ServerEnum.ALLIANCE_ACTIVITY.LEGION_NEEDFIRE,
}

local view_path = 
{
	[1] = "",
	[2] = "",
	[3] = "legionBoss",
}

-- 资源加载完成
function LegionActivityView:on_asset_load(key,asset)
	self.init = true
	self:init_ui()
end

function LegionActivityView:init_ui()
	local activity_list_info = ConfigMgr:get_config("legion_activity")
	self.scroll_table = self.refer:Get(1)
	self.scroll_table.onItemRender = handler(self,self.update_item)
	self.scroll_top_table = self.refer:Get(3)
	self.scroll_top_table.onItemRender = handler(self,self.update_top_item)
	self:refresh_top(activity_list_info)
	self.txtTime1 =self.refer:Get(2):Get(1)
	self.txtTime2 =self.refer:Get(2):Get(2)
	self.txtLevel =self.refer:Get(2):Get(3)
	self.txtContent =self.refer:Get(2):Get(4)
	self.bg_image =self.refer:Get(4)
	self.btn_join = self.refer:Get(5)
end

function LegionActivityView:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1 ) --显示列表
end

function LegionActivityView:update_item(item,index,data)
	gf_set_item(data,item:Get(2),item:Get(1))
	gf_set_click_prop_tips(item.gameObject,data)
	item:Get(3).text = ""
end

function LegionActivityView:refresh_top(data)
	self.scroll_top_table.data = data
	self.scroll_top_table:Refresh(0 ,-1 ) --显示列表
end

function LegionActivityView:update_top_item(item,index,data)
	item:Get(2).text = data.name
	item:Get(3).text = data.name
	local tb = LuaItemManager:get_item_obejct("activeDaily").open_red_list or {}
	if #tb ~= 0 then
		for k,v in pairs(tb) do
			if v.code == data.code then
				item:Get(4):SetActive(true)
			end
		end
	else
		item:Get(4):SetActive(false)
	end

	if not self.select_item then
		if self.tag and type2type[self.tag] then
			if data.type == type2type[self.tag] then
				self:select_cur_item(item)
				self.tag = nil
			end
		else
			self:select_cur_item(item)
		end
	end
end

-- function LegionActivityView:get_button_state(activity_type)
-- 	if activity_type == Enum.ALLIANCE_ACTIVITY.DAILY_TASK then
-- 		--判断今日任务是否已经领取 或者已经完成
-- 		local task_data = gf_getItemObject("legion"):get_task()
-- 		if next(task_data or {}) and task_data.isDone == 1 then
-- 			gf_print_table(task_data, "task_data:")
-- 			return true
-- 		end

-- 	end
-- 	return false
-- end

function LegionActivityView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetMyInfoR") then
			gf_print_table(msg, "GetMyInfoR:")
			if msg.dailyTask.isDone then
				require("models.legion.collectionView")()	
				return
			end
		elseif id2 == Net:get_id2("alliance","HandInDailyTaskR") then
			if msg.err == 0 then
				self:init_ui()
			end
		end
	end
end


function LegionActivityView:on_click( obj, arg )
	local event_name = obj.name
	print("event_name:",event_name)
	if event_name == "btnJoinActivity" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:enjoy_click(self.select_item)
	elseif event_name=="tag_item(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN)
		self:select_cur_item(arg)
	end
end
local weekday = {
	[1] ="一",
	[2] ="二",
	[3] ="三",
	[4] ="四",
	[5] ="五",
	[6] ="六",
	[7] ="日",
}

function LegionActivityView:pre_view_clear()
	if self.pre_view then
		print("pre view dispose")
		self.pre_view:dispose()
		self.pre_view = nil
	end
end

function LegionActivityView:select_cur_item(item)
	gf_print_table(item.data,"wtf select_cur_item")
	if self.select_item then
		self.select_item:Get(1):SetActive(false)
	end
	self.select_item = item
	item:Get(1):SetActive(true)

	self.refer:Get(2).gameObject:SetActive(view_path[item.data.id] == "")

	self:pre_view_clear()

	if view_path[item.data.id] ~= "" then
		self.pre_view = require("models.legion."..view_path[item.data.id])()
		return
	end

	local data = ConfigMgr:get_config("daily")[item.data.code]
	self:refresh(data.reward)
	local txt_time  = "周"
	for k,v in pairs(data.date_list) do
		if k>1 then
			txt_time = txt_time.."、".. weekday[v]
		else
			txt_time = txt_time..weekday[v]
		end
	end
	self.txtTime1.text =txt_time
	self.txtTime2.text =string.format('%02d:%02d-%02d:%02d',data.day_time[1],data.day_time[2],data.day_time[3],data.day_time[4])
	self.txtLevel.text =data.level.."级以上"
	self.txtContent.text =data.desc
	gf_setImageTexture(self.bg_image,item.data.icon)
	local is_set = false
	for k,v in pairs(data.date_list) do
		if v == tonumber(os.date("%w")) then
			local t = os.date("%H")*60 + os.date("%M")
			if data.day_time[1]*60+data.day_time[2]<= t and t <=  data.day_time[3]*60 +data.day_time[4] then
				is_set = true
			end
		end
	end	
	self.btn_join:SetActive(is_set)
end

--点击处理--
--物资收集
function LegionActivityView:collection()
	print("点击收集")
	--如果任务还未完成
	local task_data = gf_getItemObject("legion"):get_task()
	if next(task_data or {}) and task_data.isDone == 0 then
		require("models.legion.collectionView")()
		return
	end
	gf_getItemObject("task"):accept_task_c2s( ConfigMgr:get_config("t_misc").legion_task )
end

function LegionActivityView:boss()
	gf_getItemObject("legion"):enter_copy()
end

function LegionActivityView:copy()
	gf_getItemObject("legion"):enter_copy()
end
function LegionActivityView:task()
	gf_getItemObject("legion"):accept_legion_task_c2s()
	gf_receive_client_prot(msg,ClientProto.LegionViewClose)
end

function LegionActivityView:train()
	-- gf_create_model_view("train")
end

function LegionActivityView:war()
end

function LegionActivityView:party()
	-- LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(,nil,nil,true,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
	local map_id = ConfigMgr:get_config("t_misc").alliance.legionMapId
	local data = ConfigMgr:get_config("map.mapMonsters")[map_id][ServerEnum.MAP_OBJECT_TYPE.NPC]
   	local pos = 0
   	local npc_id = ConfigMgr:get_config("daily")[self.select_item.data.code].npc_id
    for k,v in pairs(data) do
        if v.code == npc_id then
           pos = v.pos
       	end
    end
    LuaItemManager:get_item_obejct("battle"):move_to(map_id, pos.x, pos.y,nil,1)
	Net:receive({},ClientProto.LegionViewClose)
end

function LegionActivityView:needfire()
	LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(ConfigMgr:get_config("t_misc").alliance.legionMapId,nil,nil,true,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
	Net:receive({},ClientProto.LegionViewClose)
end

function LegionActivityView:enjoy_click(arg)
	local activity_list = 
	{    
		[Enum.ALLIANCE_ACTIVITY.DAILY_TASK] 	= handler(self, self.collection)	,
		[Enum.ALLIANCE_ACTIVITY.ANCIENT_BOSS] 	= handler(self, self.boss)			,
		[Enum.ALLIANCE_ACTIVITY.LEGION_COPY] 	= handler(self, self.copy)			,
		[Enum.ALLIANCE_ACTIVITY.LEGION_WAR] 	= handler(self, self.war)			,
		[Enum.ALLIANCE_ACTIVITY.LEGION_PARTY] 	= handler(self, self.party)			,
		[Enum.ALLIANCE_ACTIVITY.LEGION_TRAIN] 	= handler(self, self.train)			,
		[Enum.ALLIANCE_ACTIVITY.LEGION_TASK] 	= handler(self, self.task)			,
		[Enum.ALLIANCE_ACTIVITY.LEGION_NEEDFIRE] 	= handler(self, self.needfire)			,
	}
	local data = arg.data
	-- local index = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem").index + 1
	activity_list[data.type]()
end



function LegionActivityView:on_showed()
	StateManager:register_view( self )
	if self.init then
		local activity_list_info = ConfigMgr:get_config("legion_activity")
		self:refresh_top(activity_list_info)
	end
end

function LegionActivityView:on_hided()
	self:clear()
	
end

function LegionActivityView:clear()
	self:pre_view_clear()
	if self.select_item then
		self.select_item:Get(1):SetActive(false)
	end
	StateManager:remove_register_view( self )
end

-- 释放资源
function LegionActivityView:dispose()
	self:clear()
    self._base.dispose(self)
 end

return LegionActivityView

