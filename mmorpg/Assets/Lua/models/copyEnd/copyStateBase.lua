--[[
	结算基础界面
	create at 17.11.20
	by xin
]]


local copyStateBase = class(UIBase,function(self,res,item_obj)
	self.item_obj = item_obj
	UIBase._ctor(self, res, item_obj)
	print("wtf res:",res)
	self.show_effect = true
end)

 
 
function copyStateBase:is_can_exit()
	return  Net:get_server_time_s() - self.pass_copy_time >= ConfigMgr:get_config("t_misc").copy.pass_wait_time 
end
 
-- 资源加载完成
function copyStateBase:on_asset_load(key,asset)
end
function copyStateBase:on_showed()
	StateManager:register_view(self)
	self.pass_copy_time = Net:get_server_time_s() 
	self:start_scheduler()
	print("self.show_effect:",self.show_effect)
	if self.show_effect then
		-- gf_receive_client_prot({visible = true}, ClientProto.CopyExitButtonEffect)
	end
	
end


function copyStateBase:clear()
	StateManager:remove_register_view(self)
	copyStateBase:stop_schedule()
end
function copyStateBase:on_hided()
	self:clear()
end
-- 释放资源
function copyStateBase:dispose()
	self:clear()
    copyStateBase._base.dispose(self)
end

function copyStateBase:start_scheduler()
	if copyStateBase.schedule_id then
		copyStateBase:stop_schedule()
	end
	local update = function()
		if self.pass_copy_time + ConfigMgr:get_config("t_misc").copy.auto_exit_time  <= Net:get_server_time_s() then
			print("copyStateBase update")
			copyStateBase:stop_schedule()
			-- gf_receive_client_prot({visible = false}, ClientProto.CopyExitButtonEffect)
			LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
			
		end
	end
	copyStateBase.schedule_id = Schedule(update, 0.1)

end

function copyStateBase:start_tick()
end

function copyStateBase:stop_schedule()
	print("copyStateBase stop schedule")
	if copyStateBase.schedule_id then
		copyStateBase.schedule_id:stop()
		copyStateBase.schedule_id = nil
	end
end

function copyStateBase:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy","PassCopyR") then
		end
	end
	
end

return copyStateBase