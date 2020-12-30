

--[[
	职位名称 设置界面 
	create at 17.11.2
	by xin
]]
local model_name = "alliance"

local res = 
{
	[1] = "legion_custom_position.u3d",
}

local dataUse = require("models.legion.dataUse")

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local legionPositionMgr = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionPositionMgr:on_asset_load(key,asset)
    self:init_ui()
end

function legionPositionMgr:init_ui()
	local data_object = gf_getItemObject("legion")

	local title_num = data_object:get_title_num()
	local legion_data = data_object:get_info()

	gf_print_table(title_num, "wtf title_num:")

	gf_print_table(dataUse.getAllianceData(legion_data.level).position_max, "dataUse.getAllianceData(legion_data.level).position_max:")



	for i,v in ipairs(ClientEnum.LEGION_TITLE_NAME) do
		print("wtf dddd",data_object:get_title_name(i))
		local max_num = gf_getItemObject("name") 
		local name_text = self.refer:Get(1).transform:FindChild("Image"..i).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		name_text.text = string.format("%s(%d/%d)",data_object:get_title_name(i),#(title_num[i] or {}) ,dataUse.getAllianceData(legion_data.level).position_max[i])

	end

end

function legionPositionMgr:sure_click()
	local temp = {}
	for i,v in ipairs(ClientEnum.LEGION_TITLE_NAME) do
		local value = self.refer:Get(2).transform:FindChild("InputField"..i).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		-- local name_text = self.refer:Get(1).transform:FindChild("Image"..i).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		-- local real = value.text ~= "" and value.text or name_text.text

		if value.text ~= "" then
			local entry = {}
			entry.titleCode = i
			entry.titleName = value.text
			if value.text ~= "" and checkChar(value.text) then
				gf_message_tips(gf_localize_string("输入中包含违规内容，请重新输入!"))
				return
			end
			table.insert(temp,entry )
		end

		
	end

	gf_getItemObject("legion"):modify_info_c2s(nil,nil,temp)
end

--鼠标单击事件
function legionPositionMgr:on_click( obj, arg)
	local event_name = obj.name
	print("legionPositionMgr click",event_name)
    if event_name == "position_close_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "sure_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:sure_click()

    end
end

function legionPositionMgr:on_showed()
	StateManager:register_view(self)
end

function legionPositionMgr:clear()
	StateManager:remove_register_view(self)
end

function legionPositionMgr:on_hided()
	self:clear()
end
-- 释放资源
function legionPositionMgr:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionPositionMgr:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ModifyInfoR") then
			if msg.err == 0 then
				gf_message_tips("设置成功")
				self:dispose()
			end

		end
	end
end

return legionPositionMgr