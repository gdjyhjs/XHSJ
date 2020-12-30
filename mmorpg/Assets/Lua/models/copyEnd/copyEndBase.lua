--[[
	结算基础界面
	create at 17.11.20
	by xin
]]

local uiBase = require("common.viewBase")

local copyEndBase = class(uiBase,function(self,res,item_obj)
	self.item_obj = item_obj
	uiBase._ctor(self, res, item_obj)
end)

function copyEndBase:on_showed()
	self.time = Net:get_server_time_s()
	StateManager:register_view(self)
end


function copyEndBase:clear()
	StateManager:remove_register_view(self)
end
function copyEndBase:on_hided()
	self:clear()
end

function copyEndBase:is_can_exit()
	return  Net:get_server_time_s() - self.time >= ConfigMgr:get_config("t_misc").copy.pass_wait_time 
end

-- 释放资源
function copyEndBase:dispose()
	self:clear()
    copyEndBase._base.dispose(self)
end


function copyEndBase:on_receive( msg, id1, id2, sid )
end

return copyEndBase