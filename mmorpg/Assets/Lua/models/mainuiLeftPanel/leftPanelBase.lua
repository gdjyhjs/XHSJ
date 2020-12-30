--[[
	主界面左边面板基础界面
	create at 17.12.18
	by xin
]]
-- local move_width = 265
-- local move_time = 0.28

-- local direct = 
-- {
-- 	right = 1,
-- 	left  = 2,
-- }

local leftPanelBase = class(UIBase,function(self,res,item_obj,...)
	self.level = UIMgr.LEVEL_STATIC
	self.item_obj = item_obj
	local callback = ...
	self.callback = callback
	UIBase._ctor(self, res, item_obj)
end)

function leftPanelBase:on_asset_load(key,asset)
	if self.callback then
		self.callback()
	end
	self.is_init = true
end

--@show 即将显示状态
--@state 当前状态
function leftPanelBase:show_view( state,show )
	print("wtf task show view:",state,show,self.tween, self:is_visible(),self.is_init)
	if not self.tween or not self:is_visible() or not self.is_init then
		return 
	end
	local start_pos = self.start_pos or self.tween.from
	local end_pos = self.end_pos or self.tween.to

	self.start_pos = start_pos
	self.end_pos = end_pos

	if state ~= show then
		self:start_scheduler(show,start_pos,end_pos)
	else
		self:set_visible(true)
		if state then
			self.tween.gameObject.transform.localPosition = self.start_pos
		else
			self.tween.gameObject.transform.localPosition = self.end_pos
		end
	end
end

function leftPanelBase:start_scheduler(show,from_ex,to_ex)
	local from = show and to_ex or from_ex
	local to = show and from_ex or to_ex

	if self.p_schedule_id then
		self:p_stop_schedule()
	end
	local total = 0
	
	local start_time = Net:get_server_time_s()
	local update = function(dt)
		print("wtf task show move position:")
		--如果是隐藏状态 直接设置为最后的位置
		if not self:is_visible() then
			print("wtf task show move last")
			self:set_visible(true)
			self.tween.gameObject.transform.localPosition = to
			self:p_stop_schedule()
			self:set_visible(false)
			return
		end
		total = Net:get_server_time_s() - start_time
		if total >= 0.5 then
			self.tween.gameObject.transform.localPosition = to
			self:p_stop_schedule()
			return
		end
		print("wtf move position:",Vector3.Lerp(from,to,total * 2).x)
		self.tween.gameObject.transform.localPosition = Vector3.Lerp(from,to,total * 2)
		
	end

	self.p_schedule_id = Schedule(update, 0.01)
end

function leftPanelBase:p_stop_schedule()
	if self.p_schedule_id then
		self.p_schedule_id:stop()
		self.p_schedule_id = nil
	end
end

function leftPanelBase:dispose()
	self:p_stop_schedule()
	leftPanelBase._base.dispose(self)
end

return leftPanelBase