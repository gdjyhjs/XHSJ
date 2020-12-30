--[[
	材料副本界面  属性 废弃
	create at 17.9.5
	by xin
]]
local dataUse = require("models.copy.dataUse")
local model_name = "copy"

local res = 
{
	[1] = "copy_materials.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("需要等级："),
	[2] = gf_localize_string("今日次数："),
	[3] = gf_localize_string("%d级开启"),
	[4] = gf_localize_string("进入副本"),
	[5] = gf_localize_string("将消耗%d%s重置1次副本次数，是否确定"),
	[6] = gf_localize_string("进入副本"),
	[7] = gf_localize_string("重置"),
}
local limit_color = 
{
	[1] = "<color=#FF5F4E>%d</color>",			--红
	[2] = "<color=#00A92F>%d</color>", 			--绿
}

local materialCopy = class(UIBase,function(self,item_obj)
	self.item_obj = item_obj
	
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function materialCopy:on_asset_load(key,asset)
	-- LuaItemManager:get_item_obejct("copy"):get_material_copy_data_c2s()
end

function materialCopy:init_ui()
	local server_data = gf_getItemObject("copy"):get_material_copy_data()
	local dataex = dataUse.getTypeMaterialCopy()
	local scroll_view = self.refer:Get(1)
	self.scroll_table = scroll_view
	local my_level = gf_getItemObject("game"):getLevel()	
	

	scroll_view.onItemRender = function(scroll_rect_item,index,data_item)
		local data = self:find_copy(data_item)
		local refer = scroll_rect_item
		local copy_data = ConfigMgr:get_config("copy")[data.copy_code]

		local server_copy_data = server_data[data.copy_code]

		gf_print_table(server_copy_data, "wtf server_copy_data:")

		--如果进入次数不足
		local button = refer:Get(10):GetComponent("UnityEngine.UI.Button")
		button.interactable = true
		if server_copy_data.finishTimes >= ConfigMgr:get_config("t_misc").copy.materialCopyCount then
			button.interactable = false
		end

		--背景
		gf_setImageTexture(refer:Get(1), copy_data.bg_code)
		--name
		refer:Get(2).text = copy_data.name
		--需要等级
		local button_text = refer:Get(10).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		button_text.text = commom_string[4]

		local limit_level = copy_data.min_level

		refer:Get(3).text = string.format(limit_color[2],limit_level)
		if limit_level > my_level then
			refer:Get(3).text = string.format(limit_color[1],limit_level)
			button_text.text = string.format(commom_string[3],limit_level)
		end
		
		--材料
		for i=1,3 do
			local item = refer:Get(3 + i)
			item:SetActive(false)
			if data.material[i] then
				item:SetActive(true)
				local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
				local bg   = item:GetComponent(UnityEngine_UI_Image)
				gf_set_item(data.material[i][1], icon, bg)
				local count_text = item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
				count_text.text = data.material[i][2]
			end
		end

		--进入次数
		refer:Get(7).text = commom_string[2] .. string.format(limit_color[2],1)
		local enter_button_text = refer:Get(10).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		enter_button_text.text = commom_string[6]
		if server_copy_data.validTimes <= 0 then
			refer:Get(7).text = commom_string[2]..string.format(limit_color[1],0)
			enter_button_text.text = commom_string[7]
		end

	end
	
	scroll_view.data = dataex
	scroll_view:Refresh(-1,-1)

end

function materialCopy:find_copy(data)
	local my_level = gf_getItemObject("game"):getLevel()	
	for i,v in ipairs(data or {}) do
		if v.level_grade[1] <= my_level and v.level_grade[1] >= my_level then
			return v
		end
	end
	return data[1]
end

function materialCopy:item_click(arg,event_name)
	local index = string.gsub(event_name,"material_reward","")
	index = tonumber(index)

	local bindex = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem").index + 1 		 --索引从零开始

	local data = dataUse.getTypeMaterialCopy()
	local rdata = self:find_copy(data[bindex])
	local item = rdata.material[index]
	if item then
		gf_getItemObject("itemSys"):common_show_item_info(item[1])
	end
end

function materialCopy:enter_click(arg)
	local bindex = arg.index + 1 
	local server_data = gf_getItemObject("copy"):get_material_copy_data()
	local data = dataUse.getTypeMaterialCopy()[bindex][1]
	local server_copy_data = server_data[data.copy_code]

	--如果免费次数不足
	if server_copy_data.validTimes <= 0 and server_copy_data.finishTimes <= (ConfigMgr:get_config("t_misc").copy.materialCopyCount - 1) then

		local sure_fun = function()
			gf_getItemObject("copy"):material_copy_buy_count_c2s(data.copy_code)
		end
		local cost_data = ConfigMgr:get_config("t_misc").copy.materialCopyBuyCost[server_copy_data.finishTimes]
		local cost = cost_data[2]
		local res_name = gf_get_money_name(cost_data[1])
		local content = string.format(commom_string[5],cost,res_name)
		gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun)

		return
	end
	Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN)
	gf_getItemObject("copy"):enter_copy_c2s(data.copy_code)
end
--鼠标单击事件
function materialCopy:on_click( obj, arg)
	local event_name = obj.name
	print("materialCopy click",event_name)
    if string.find(event_name,"material_reward") then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(arg,event_name)

    elseif string.find(event_name,"enter_btn") then
    	-- Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:enter_click(arg,event_name)

    end
end

function materialCopy:on_showed()
	StateManager:register_view(self)
end

function materialCopy:clear()
	StateManager:remove_register_view(self)
end

function materialCopy:on_hided()
	self:clear()
end
-- 释放资源
function materialCopy:dispose()
	self:clear()
    self._base.dispose(self)
end

function materialCopy:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "BuyMaterialTimesR") then
			--刷新状态
			self.scroll_table:Refresh(self.scroll_table.currFirstIndex,-1)
		elseif id2 == Net:get_id2(model_name, "GetMaterialCopyInfoR") then 
			self:init_ui()
		end
	end
end

return materialCopy