--[[--
-- 特效
-- @Author:Seven
-- @DateTime:2017-04-27 09:50:46
--]]

local SpriteBase = require("common.spriteBase")
local UI = LuaHelper.Find("UI")
local NPC = LuaHelper.Find("NPC")
local HP = LuaHelper.Find("HP")
local Touch = LuaHelper.Find("Touch")

local Effect = class(SpriteBase, function( self, url, ... )
	SpriteBase._ctor(self, url, ...)
	self.url = url
end)

function Effect:init()
	self:hide()

	self.delay_time_list = {} -- 延时列表的初始时间

	local time,_delay = 0
	self.delay_list = self.root:GetComponentsInChildren("Seven.Effect.Delay")
	if self.delay_list then
		for i=1,#self.delay_list do
			local delay = self.delay_list[i]

			if delay.delayTime > 0 then
				delay.gameObject:SetActive(false)
				delay:SetInitPlay(false)
				self.delay_time_list[i] = delay.delayTime
			end
			if delay.hideTime > time then
				time = delay.hideTime
				_delay = delay
			end
		end
	end
	self.time = time -- 隐藏时间

	if _delay then
		_delay.onFinishFn = handler(self, self.on_finish)
	end
end

-- 显示特效
function Effect:show_effect( pos, eulerAngles )
	self:hide()
	if not self.transform then
		return
	end

	if eulerAngles then
		self.transform.eulerAngles = eulerAngles
	end

	if pos then
		self.transform.position = pos
	end
	
	if self.delay_list then
		for i=1,#self.delay_list do
			local delay = self.delay_list[i]
			delay:ShowEffect()
		end
	end
	self:show()
end

function Effect:show_xp(isOnlyXpLayer,isHideCamera)
	-- if not self.xp_camera then
		self.xp_camera = self.root:GetComponentInChildren("UnityEngine.Camera")
	-- end
	isOnlyXpLayer = isOnlyXpLayer==nil and true or isOnlyXpLayer
	if isOnlyXpLayer and self.xp_camera then
		LuaHelper.SetCameraOnlyRenderLayer(self.xp_camera, ClientEnum.Layer.XP)
	end
	self.isHideCamera = isHideCamera==nil and true or isHideCamera
	if self.isHideCamera then
		self:set_camera_visible(false)
	end

	self:hide()
	if self.delay_list then
		for i=1,#self.delay_list do
			local delay = self.delay_list[i]
			delay:ShowEffect()
		end
	end
	self:show()
	self.is_xp = true
end

function Effect:hide_xp()
	self:set_camera_visible(true)
	self:hide()
end

-- 是否播放完成
function Effect:is_finish()
	if self.delay_list then
		for i=1,#self.delay_list do
			local delay = self.delay_list[i]
			if delay.hideTime > 0 then
				return not delay.gameObject.activeSelf
			end
		end
	end
	return true
end

function Effect:set_finish_cb( cb )
	self.finish_cb = cb
end

function Effect:get_hide_time()
	return self.time or 0
end

function Effect:on_finish()
	if self._need_reset_time then
		self._need_reset_time = false
		for k,v in pairs(self.delay_time_list or {}) do
			self.delay_list[k].delayTime = v
		end
	end

	if self.finish_cb then
		self.finish_cb(self)
	end
	if self.is_xp then
		self.is_xp = false
		self:set_camera_visible(true)
	end
end

function Effect:set_camera_visible( visible )
	if not visible then
		self.main_camera = LuaHelper.Find("Main Camera")
		-- self.main_camera = UnityEngine.Camera.main.gameObject
	end
	UI:SetActive(visible)
	NPC:SetActive(visible)
	HP:SetActive(visible)
	Touch:SetActive(visible)
	if self.main_camera then
		self.main_camera:SetActive(visible)
	end
	BeginCamera:SetActive(visible)
	UICamera:SetActive(visible)
	EffectCamera:SetActive(visible)
end

-- 重设初始时间
function Effect:reset_delay_time(dtime)
	dtime = dtime or 0
	if not self.delay_list then
		return
	end

	self._need_reset_time = true
	for k,v in pairs(self.delay_time_list or {}) do
		local t = v-dtime
		if t < 0 then
			t = 0
		end
		self.delay_list[k].delayTime = t
	end
end

function Effect:on_showed()
	local data = ConfigMgr:get_config("key_sound")[self.url]
	if data then
		print("播放特效声音,",self.url,self.root)
		Sound:play_fx(data.name,data.loop==1,data.obj==1 and self.root or nil)
	end
end

return Effect
