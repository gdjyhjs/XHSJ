--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-17 17:58:20
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SkyTaskView=class(Asset,function(self,item_obj)
    self.item_obj=item_obj
    self.game_item = LuaItemManager:get_item_obejct("game")

    Asset._ctor(self, "rotation_task.u3d") -- 资源名字全部是小写
end)

local TaskState = 
{
	Available = 0, -- 可接
	Progress  = 1, -- 已接
	Finish    = 2, -- 完成
	Reward    = 3, -- 已领奖
}

local TaskString = 
{
	[TaskState.Available] = gf_localize_string("领取任务"),
	[TaskState.Progress] = gf_localize_string("已接"),
	[TaskState.Finish] = gf_localize_string("领取奖励"),
	[TaskState.Reward] = gf_localize_string("已领奖"),
}


-- 资源加载完成
function SkyTaskView:on_asset_load(key,asset)
	self:init_ui()

	self:refresh(self.item_obj:get_task_list())
end

function SkyTaskView:init_ui()
	self.scroll_table = self.refer:Get("scroll_table")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	self.count_txt = self.refer:Get("count_txt")
	self.count_txt.text = self.item_obj:get_left_times()
	
	self.refresh_money_txt = self.refer:Get("refresh_money_txt")
	self.refresh_money_txt.text = ConfigMgr:get_config("t_misc").daily_task.refresh_task_cost.num
end

function SkyTaskView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1, -1)
end

function SkyTaskView:update_item( item, index, data )

	local reward_data = ConfigMgr:get_config("daily_task")[data.code]
	if not reward_data then
		print_error("天机任务找不到daily_task表id为",data.code,"的数据")
		return
	end

	-- icon
	gf_setImageTexture(item:Get(1), "rotation_task_icon_"..reward_data.quality)

	-- 名字
	item:Get(2).text = data.name

	local reward = self:init_reward(data.code)

	-- exp
	item:Get(3).text = reward[ServerEnum.BASE_RES.EXP] or 0

	-- 金币
	item:Get(4).text = reward[ServerEnum.BASE_RES.COIN] or 0

	-- 名望
	item:Get(5).text = ""--(reward[ServerEnum.BASE_RES.FAME] or 0).."名望"

	-- 按钮文字
	item:Get(6).text = TaskString[data.state]

	-- 按钮是否可以点击
	item:Get(7).interactable = data.state == TaskState.Available or data.state == TaskState.Finish
	
	-- 可以领取，显示特效
	item:Get(8):SetActive(data.state == TaskState.Finish)
 
    -- lable
	gf_setImageTexture(item:Get(9), "rotation_task_lable_0"..reward_data.quality)
end

--[[
-- 经验 = A + [(level - B ) * C * 任务品级系数
]]
function SkyTaskView:init_reward( task_id )
	local reward_data = ConfigMgr:get_config("t_misc").daily_task.exp_reward_param
	local task_lv = ConfigMgr:get_config("daily_task")[task_id].quality
	local task_q =  ConfigMgr:get_config("t_misc").daily_task.quality_coef[task_lv]

	if not reward_data then
		return {}
	end

	local list = {}

	list[ServerEnum.BASE_RES.EXP] = reward_data["A"]+(self.game_item:getLevel()-reward_data["B"])*reward_data["C"]*task_q
	list[ServerEnum.BASE_RES.COIN] = list[ServerEnum.BASE_RES.EXP]
	-- list[ServerEnum.BASE_RES.FAME] = 100--暂时显示

	return list
end

function SkyTaskView:refresh_item( item )
	item:Get(6).text = TaskString[item.data.state]
end

function SkyTaskView:do_task( state, pos )
	if state == TaskState.Available then
		self.item_obj:daily_task_accept_c2s(pos)
		self.item_obj:dispose()

	elseif state == TaskState.Progress then

	elseif state == TaskState.Finish then
		self.item_obj:daily_task_get_reward_c2s(pos)

	elseif state == TaskState.Reward then
		
	end
end

function SkyTaskView:buy_times()
	LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(
		gf_localize_string("是否要花费10元宝增加5次任务次数？"),
		function()
			self.item_obj:daily_task_buy_valid_times_c2s()
		end,
		function()
			
		end
	)
end

function SkyTaskView:on_click( item_obj, obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self.item_obj:dispose()

	elseif cmd == "refresh_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:daily_task_refresh_c2s()

	elseif cmd == "add_count_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:buy_times()

	elseif cmd == "get_task_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.select_item = arg
		local state = arg.data.state
		self:do_task(state, arg.data.pos)
	end
end

function SkyTaskView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "UpdateDailyTaskInfoR") then
			self:refresh(self.item_obj:get_task_list())

		elseif id2 == Net:get_id2("task", "DailyTaskRefreshR") then
			self:refresh(self.item_obj:get_task_list())
			self.count_txt.text = self.item_obj:get_left_times()

		elseif id2 == Net:get_id2("task", "DailyTaskAcceptR") then
			self:refresh_item(self.select_item)

		elseif id2 == Net:get_id2("task", "DailyTaskGetRewardR") then
			self:refresh_item(self.select_item)

		elseif id2 == Net:get_id2("task", "DailyTaskBuyValidTimesR") then
			self.count_txt.text = self.item_obj:get_left_times()

		end
	end
end

function SkyTaskView:on_showed()
	self.refer:Get("count_txt").text = self.item_obj:get_left_times()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function SkyTaskView:on_hided()
	self.item_obj:register_event("on_click", nil)
end

-- 释放资源
function SkyTaskView:dispose()
	self.item_obj:register_event("on_click", nil)
    self._base.dispose(self)
end

return SkyTaskView

