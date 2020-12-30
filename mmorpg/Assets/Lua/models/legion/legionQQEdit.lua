--[[
	qq群编辑界面  属性
	create at 17.10.31
	by xin
]]
local model_name = "alliance"

local res = 
{
	[1] = "legion_change_group_num.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("请输入数字"),
}


local legionQQEdit = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionQQEdit:on_asset_load(key,asset)
    self:init_ui()
end

function legionQQEdit:init_ui()
end

--鼠标单击事件
function legionQQEdit:on_click( obj, arg)
	local event_name = obj.name
	print("legionQQEdit click",event_name)
    if event_name == "q_edit_close_btn" or event_name == "cancleBtn (1)" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "sureBtn (1)" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local value = tonumber(self.refer:Get(1).text) or 0
    	if value > 0 then
    		gf_getItemObject("legion"):send_to_edit_qq(self.refer:Get(1).text)
    		return
    	end
    	gf_message_tips(commom_string[1])

    end
end

function legionQQEdit:on_showed()
	StateManager:register_view(self)
end

function legionQQEdit:clear()
	StateManager:remove_register_view(self)
end

function legionQQEdit:on_hided()
	self:clear()
end
-- 释放资源
function legionQQEdit:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionQQEdit:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ModifyInfoR") then
			self:dispose()
		end
	end
end

return legionQQEdit