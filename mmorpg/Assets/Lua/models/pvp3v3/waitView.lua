--[[
	等待界面系统主界面
	create at 17.9.19
	by xin
]]

local model_name = "copy"

local res = 
{
	[1] = "mainui_pvp_wait.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("匹配失败"),
	[2] = gf_localize_string("是否继续匹配？"),

}


local waitView = class(UIBase,function(self,msg)
	self.end_time = msg.expireTime --Net:get_server_time_s() + 60--
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function waitView:on_asset_load(key,asset)
    self:init_ui()
end

function waitView:init_ui()

	self:start_scheduler()

end


function waitView:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local start_time = Net:get_server_time_s()
	local update = function()
		local left_time = Net:get_server_time_s() - start_time
		-- left_time = left_time <= 0 and 0 or left_time
		self:update_time(left_time)
		if Net:get_server_time_s() >= self.end_time then
			self:stop_schedule()
			self:dispose()
			gf_message_tips(commom_string[1])
			return
		end
		
	end
	self.schedule_id = Schedule(update, 0.5)
end

function waitView:update_time(left_time)
	self.refer:Get(1).text = gf_convert_time_ms(left_time)
end

function waitView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

--鼠标单击事件
function waitView:on_click( obj, arg)
	local event_name = obj.name
	print("waitView click",event_name)
    if event_name == "lookForPVP" then 
    	local sure_fun = function()
    		-- gf_message_tips("继续匹配")
    		gf_getItemObject("pvp3v3"):send_to_cancel_match()
    	end
    	local cancel_func = function()
    		-- gf_message_tips("取消匹配")
    		
    	end
    	LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(commom_string[2],sure_fun,cancel_func,"退出匹配")

    end
end

function waitView:on_showed()
	StateManager:register_view(self)
end

function waitView:clear()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function waitView:on_hided()
	self:clear()
end
-- 释放资源
function waitView:dispose()
	self:clear()
    self._base.dispose(self)
end

function waitView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 取章节信息
			--如果是竞技场3v3 关闭此界面
			if gf_getItemObject("copy"):is_pvptvt() then
				self:dispose()
			end
		end
	end
	if id1 == Net:get_id1("team") then
		if id2 == Net:get_id2("team", "TeamVsCopyCancelMatchR") then -- 
			if msg.err == 0 then
				self:dispose()
			end
		end
	end
end

return waitView