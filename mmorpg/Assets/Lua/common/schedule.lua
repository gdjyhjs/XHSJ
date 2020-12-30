--[[--
-- 定时器
-- @Author:Seven
-- @DateTime:2017-04-22 10:04:45
--]]

-- fn：回调函数，time：定时时间
Schedule = class(function ( self, fn, time )
	-- self.parent = LuaHelper.Find("Schedule")
	-- self.timer = self.parent:AddComponent("Seven.Schedule")
	-- self.timer:StartUpdate(fn, time)
	self.fn = fn
	self.o_time = time
	self.time = time
	self._pause = false
	gf_register_update(self)
end)

-- 停止定时器（注：定时器销毁要调用这个函数）
function Schedule:stop()
	-- if not Seven.PublicFun.IsNull(self.timer) then
	-- 	self.timer:StopUpdate()
	-- end
	gf_remove_update(self)
end

-- 恢复定时器
function Schedule:resume()
	-- self.timer:ResumeUpdate()
	self._pause = false
end

-- 暂停定时器
function Schedule:pause()
	-- self.timer:PauseUpdate()
	self._pause = true
end

-- 重设刷新时间
function Schedule:reset_time( time )
	-- self.timer:ResetUpdateTime(time)
	self.time = time
	self.o_time = time
end

function Schedule:on_update( dt )
	if self._pause then
		return
	end

	self.time = self.time - dt
	if self.time <= 0 then
		self.time = self.o_time
		self.fn(self.o_time)
	end
end

return Schedule
