--[[
	基础界面基类
	create at 17.11.22
	by xin
]]


local viewBase = class(UIBase,function(self,res,item_obj)
	self.item_obj = item_obj
	UIBase._ctor(self, res, item_obj)
	self.remove_dispacher_on_hide = true
end)

function viewBase:on_showed()
	print("wtf register_view")
	StateManager:register_view(self)
end

function viewBase:clear()
	print("wtf remove_register_view")
end

function viewBase:on_hided()
	self:clear()
	if self.remove_dispacher_on_hide then
		StateManager:remove_register_view(self)
	end
	
end

-- 释放资源
function viewBase:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    viewBase._base.dispose(self)
    
end


return viewBase