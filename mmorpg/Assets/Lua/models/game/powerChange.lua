--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-20 09:19:52
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local current_power = 0 -- 当前战力
local target_power = 0 -- 目标战力
local change_lerf = 0.3 -- 变化插值

local original_change_time = 0.05 -- 最初的战力跳动时间间隔
local change_time = 0.1 -- 战力跳动时间间隔
local time_speed = 0.2 -- 跳动速度(间隔时间，越小越快)

local is_change_end = false

local hide_delay = 1 -- 战力变化结束隐藏延迟
local wait_time = 0 -- 变化或隐藏的等待时间

local arrow_obj = nil

local init = nil -- 是否加载ui完毕
local on_show = nil -- 是否正在显示

local move_speed = 50

local PowerChange=class(UIBase,function(self,item_obj,original,target)

	print("设置战力",original,target)
	current_power = original or 0
	target_power = target or 0

	change_time = original_change_time
	wait_time = change_time

	is_change_end = false

	if current_power<target_power then
		move_speed = math.abs(move_speed)
	else
		move_speed = -math.abs(move_speed)
	end

	
    UIBase._ctor(self, "power_change.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function PowerChange:on_asset_load(key,asset)
	self.atkTxt = self.refer:Get("atkTxt")
	init = true
	self:init_ui()
end

function PowerChange:init_ui()
	print("初始化ui")
	if current_power<target_power then
		self.refer:Get("down"):SetActive(false)
		self.refer:Get("up"):SetActive(true)
		self.refer:Get("up_num").text = target_power - current_power
		arrow_obj = self.refer:Get("up_canvas")
		arrow_obj.transform.localPosition = Vector2(arrow_obj.transform.localPosition.x,1)
	else
		self.refer:Get("up"):SetActive(false)
		self.refer:Get("down"):SetActive(true)
		self.refer:Get("down_num").text = current_power - target_power
		arrow_obj = self.refer:Get("down_canvas")
		arrow_obj.transform.localPosition = Vector2(arrow_obj.transform.localPosition.x,-1)
	end
	arrow_obj.alpha = 1
end

function PowerChange:on_update(dt)
	if init then
		if wait_time <= 0 then
			if math.abs(target_power - current_power) > 0 then
				local change_power = (target_power - current_power)*change_lerf
				if change_power>0 then
					current_power = current_power + math.ceil(change_power)
				else
					current_power = current_power + math.floor(change_power)
				end
				if math.abs(target_power - current_power) < 1 then
					current_power = target_power
					wait_time = hide_delay
					is_change_end = true
				else
					change_time = time_speed/math.abs(change_power)
					wait_time = change_time
				end
			else
				if is_change_end then
					self:dispose()
				else
					current_power = target_power
					wait_time = hide_delay
					is_change_end = true
				end
			end
			self.atkTxt.text = current_power
		else
			wait_time = wait_time - dt
			if is_change_end then
				arrow_obj.alpha = arrow_obj.alpha - dt
				arrow_obj.transform.localPosition = Vector2(arrow_obj.transform.localPosition.x,arrow_obj.transform.localPosition.y+move_speed*dt)
			end
		end
	end
end

function PowerChange:on_showed()
	if not on_show then
		on_show = true
		gf_register_update(self) --注册每帧事件
	end
end

function PowerChange:on_hided()
	if on_show then
		gf_remove_update(self) --注销每帧事件
		on_show = nil
	end
end

-- 释放资源
function PowerChange:dispose()
	init = nil
	self:hide()
    self._base.dispose(self)
 end

return PowerChange

