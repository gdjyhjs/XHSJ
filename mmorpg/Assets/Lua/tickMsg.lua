--[[
	定时器发送协议
	create at 18.1.2
	by xin
]]
local tick = 
{
	[1] = gf_get_server_zero_time() + 0 * 60 * 60 + 0*60 + 0, 			--零点0时0分0秒 刷新的时间戳
}

local get_msg = 
{	
	--对应tick 把方法传进来即可
	[1] = 
	{
		gf_getItemObject("copy").get_material_copy_data_c2s,
	}
}

local tickMsg = class(function(self)
	self:init()
end)

function tickMsg:init()
	--启动定时器 每2秒检测一次
	self.is_send = {}

	for i,v in ipairs(tick or {}) do
		self.is_send[i] = false
	end

	self:start_scheduler()
end

function tickMsg:start_scheduler()
	if self.schedule_id then
		self:stop_scheduler()
	end
	local update = function()
		local time = math.floor(Net:get_server_time_s())
		for i,v in ipairs(tick or {}) do
			--允许十秒延迟
			local delay = time - v
			if delay >=0 and delay <= 10 and not self.is_send[i] then
				for ii,vv in ipairs(get_msg[i]) do
					if vv then
						vv()
					end
				end
				self.is_send[i] = true
			end 
			--大于30s 重置标记
			if delay > 30 and self.is_send[i] then
				self.is_send[i] = false
			end
		end

	end
	self.schedule_id = Schedule(update, 2)
end

function tickMsg:stop_scheduler()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

return tickMsg