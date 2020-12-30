--[[--
-- 任务收集界面
-- @Author:Seven
-- @DateTime:2017-06-19 21:07:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")

local collectionView = class(UIBase,function(self)
	local item_obj = gf_getItemObject("legion")
    UIBase._ctor(self, "legion_materials_handed.u3d", item_obj) -- 资源名字全部是小写
end)

local commom_string = 
{
	[1] = gf_localize_string("贡献 +%d"),
	[2] = gf_localize_string("经验 +%d"),
}


-- 资源加载完成
function collectionView:on_asset_load(key,asset)
	self:init_ui()
end

function collectionView:init_ui()
	-- self:set_bg_visible(true)
	self:hide_mainui()
	local task_data = gf_getItemObject("legion"):get_task()

	gf_print_table(task_data, "task_data:wtf")

	if next(task_data or {}) and task_data.isDone == 0 then

		local rewards_exp,rewards_coin,rewards_donate = 0,0,0
		--需要的道具
		for i,v in ipairs(task_data.taskCodeList) do
			local task_item_info = ConfigMgr:get_config("alliance_daily_task")[v]
			-- gf_print_table(task_item_info, "task_item_info:")
			local item_node = self.refer:Get(1).transform:FindChild("item"..i)
			local item_id = task_item_info.item_code
			
			local item_data = gf_getItemObject("bag"):get_item_for_protoId_type(item_id,ServerEnum.BAG_TYPE.NORMAL)
			gf_print_table(item_data, "item_data wtf:")
			local count = 0
			for i,v in ipairs(item_data or {}) do
				count = count + v.item.num
			end
			-- local count = item_data and item_data.num or 0

			local item_icon = item_node.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
			local item_bg 	= item_node:GetComponent(UnityEngine_UI_Image)

			gf_set_item(item_id, item_icon, item_bg)

			local count_node = item_node.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
			count_node.text = string.format("%d/%d",count,task_item_info.item_count)

			rewards_exp 	= rewards_exp 	+ task_item_info.reward_exp
			rewards_coin 	= rewards_coin 	+ task_item_info.reward_coin
			rewards_donate 	= rewards_donate + task_item_info.reward_donate

		end


		self.refer:Get(2).text = string.format(commom_string[1],rewards_donate)
		self.refer:Get(3).text = string.format(commom_string[2],rewards_exp)

	end
end

function collectionView:item_click(event_name)
	local index = string.gsub(event_name,"item","")
	index = tonumber(index)
	local task_data = gf_getItemObject("legion"):get_task()
	local v = task_data.taskCodeList[index]

	local task_item_info = ConfigMgr:get_config("alliance_daily_task")[v]
	local item_id = task_item_info.item_code

	gf_getItemObject("itemSys"):common_show_item_info(item_id)
end


function collectionView:on_click( obj, arg )
	local event_name = obj.name
	print("event_name:",event_name)
	if event_name == "legion_task_close_Btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif event_name == "commit_task" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_getItemObject("legion"):commit_task_c2s()

	elseif string.find(event_name,"item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:item_click(event_name)

	end
end
function collectionView:clear_sub_view()
end

function collectionView:on_showed()
	StateManager:register_view( self )
end

function collectionView:on_hided()
	StateManager:remove_register_view( self )
end

function collectionView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetMyInfoR") then
			self:init_ui()

		elseif id2 == Net:get_id2("alliance", "HandInDailyTaskR") then
			if msg.err == 0 then
				self:dispose()
			end

		end
	end
end

-- 释放资源
function collectionView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return collectionView

