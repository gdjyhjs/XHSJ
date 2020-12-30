--[[
	销毁军团确认界面  属性
	create at 17.11.2
	by xin
]]
local model_name = "alliance"

local res = 
{
	[1] = "legion_dissolution.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("再见了我的团"),
}


local legionConfirmDispose = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionConfirmDispose:on_asset_load(key,asset)
    self:init_ui()
end

function legionConfirmDispose:init_ui()
end

--鼠标单击事件
function legionConfirmDispose:on_click( obj, arg)
	local event_name = obj.name
	print("legionConfirmDispose click",event_name)
    if event_name == "comfirm_cancleBtn (1)" or event_name == "comfirm_close_btn" then 
    	self:dispose()

    elseif event_name == "comfirm_sureBtn (1)" then
    	print("self.refer:Get(1).text == commom_string[1]:",self.refer:Get(1).text == commom_string[1],self.refer:Get(1).text , commom_string[1])
    	if self.refer:Get(1).text == commom_string[1] then
    		self:dispose()
    		gf_getItemObject("legion"):send_to_dissolve()
    	end

    end
end

function legionConfirmDispose:on_showed()
	StateManager:register_view(self)
end

function legionConfirmDispose:clear()
	StateManager:remove_register_view(self)
end

function legionConfirmDispose:on_hided()
	self:clear()
end
-- 释放资源
function legionConfirmDispose:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionConfirmDispose:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ModifyInfoR") then
			self:dispose()
		end
	end
end

return legionConfirmDispose