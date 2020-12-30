-- 飞行特效
-- @Author:Seven
-- @DateTime:2017-04-27 09:50:46
--]]

local Effect = require("common.effect")

local FlyEffect = class(Effect, function ( self, url, is_radar, ... )
	self.is_radar = is_radar

	Effect._ctor(self, url, ...)
end)

function FlyEffect:init()
	FlyEffect._base.init(self)
	self.finish = true
	
	-- 抛物线
	if self.is_radar then
		self.radar = self.root:AddComponent("Seven.Shell.Radar")
	else
		self.radar = self.root:AddComponent("Seven.Shell.Line")
	end

	self.radar.OnArriveFn = handler(self, self.on_arrive)
end

function FlyEffect:set_speed( speed )
	self.speed = speed
	self.radar.speed = self.speed
end

-- 设置击中目标哪个位置
function FlyEffect:set_atk_pos( pos )
	if self.radar then
		self.radar.offset = pos
	end
end

function FlyEffect:fly( target )
	if not target or target.dead or not self.radar then
		self:hide()
		return
	end
	self.finish = false
	self.radar.target = target.root
	self.radar:Play()
end

function FlyEffect:move_to( pos )
	self.finish = false
	self.radar:MoveTo(pos)
end

function FlyEffect:set_arrive_cb( cb )
	self.arrive_cb = cb
end

function FlyEffect:on_arrive()
	self.finish = true
	if self.arrive_cb then
		self.arrive_cb(self)
	end
end

function FlyEffect:is_finish()
	return self.finish
end

return FlyEffect
