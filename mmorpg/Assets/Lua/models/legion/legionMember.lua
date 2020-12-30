--[[
	成员管理界面  属性 废弃
	create at 17.10.31
	by xin
]]
local model_name = "legion"

local res = 
{
	[1] = "legion_job_mgr.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local legionMember = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionMember:on_asset_load(key,asset)
    self:init_ui()
end

function legionMember:init_ui()
end

--鼠标单击事件
function legionMember:on_click( obj, arg)
	local event_name = obj.name
	print("legionMember click",event_name)
    if event_name == "q_edit_close_btn" or event_name == "cancleBtn (1)" then 
    	self:dispose()

    elseif event_name == "sureBtn (1)" then
    	gf_getItemObject("legion"):send_to_edit_qq(self.refer:Get(1).text)

    end
end

function legionMember:on_showed()
	StateManager:register_view(self)
end

function legionMember:clear()
	StateManager:remove_register_view(self)
end

function legionMember:on_hided()
	self:clear()
end
-- 释放资源
function legionMember:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionMember:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ModifyInfoR") then
			self:dispose()
		end
	end
end

return legionMember