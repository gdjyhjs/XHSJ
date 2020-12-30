--[[--
-- XP特效
-- @Author:Seven
-- @DateTime:2017-09-06 14:20:04
--]]

local Effect = require("common.effect")

local EffectParent = LuaHelper.Find("Effect").transform
local UI = LuaHelper.Find("UI")
local NPC = LuaHelper.Find("NPC")
local HP = LuaHelper.Find("HP")
local Touch = LuaHelper.Find("Touch")

local XpEffect = class(function( self, data, cb, ower )
	self.data = data -- xp_effect表数据
	self.xp_res_d = ConfigMgr:get_config("xp_res")[data.effect]
	self.cb = cb
	self.root = ower

	self.is_xp = true

	self:init()
end)

function XpEffect:init()
	if not self.root then
		self:init_root()
	else
		self:init_effect()
	end
end

function XpEffect:init_root()
	local effect_cb = function( root )
		root:set_parent(EffectParent)
		self.root = root
		
		self:init_effect()
	end
	if self.data.effect then
		Effect(self.data.effect..".u3d", effect_cb) -- 加载动作
	else
		gf_error_tips("找不到xp特效"..self.data.code)
	end
end

-- 加载动作特效
function XpEffect:init_effect()
	self.is_player = self.root.is_player

	self.effect_list = {}

	local list = self.xp_res_d.effect_list or {}
	local count = #self.xp_res_d.effect_list
	if count == 0 then
		if self.cb then
			self.cb(self)
		end
	end

	local index = 0
	local effect_cb = function( effect, parent )
		effect:set_parent(parent.transform)
		effect.root.transform.localScale = Vector3(1,1,1)
		effect.root.transform.localPosition = Vector3(0,0,0)
		effect.root.transform.localRotation = Vector3(0,0,0)

		if not self.xp_camera then
			self.xp_camera = effect.root:GetComponentInChildren("UnityEngine.Camera")
		end

		index = index+1
		if index == count then
			if not self.is_player then
				LuaHelper.SetLayerToAllChild(self.root.transform, ClientEnum.Layer.XP)
			end
			if self.cb then
				self.cb(self)
			end
		end
	end

	for i,v in ipairs(self.xp_res_d.effect_list or {}) do
		local parent = LuaHelper.FindChild(self.root.root, v[2])
		if v[2] == "" then
			parent = self.root.root
		end
		self.effect_list[i] = Effect(v[1]..".u3d", effect_cb, parent)
	end
end

function XpEffect:set_parent( parent )
	self.root:set_parent(parent)
end

function XpEffect:set_local_position( pos )
	self.root.transform.localPosition = pos
end

--[[
is_all:是否设置XP相机看所有层（默认只看xplayer）
hide_main_camera:是否需要隐藏主相机(默认隐藏)
]]
function XpEffect:show_effect(is_all, hide_main_camera)
	if not hide_main_camera then
		self:set_camera_visible(false)
	end

	if not is_all then
		LuaHelper.SetCameraOnlyRenderLayer(self.xp_camera, ClientEnum.Layer.XP)
	end

	if self.is_player then
		LuaHelper.SetLayerToAllChild(self.root.transform, ClientEnum.Layer.XP)
		-- if string.find(self.root.sprite_name, "112") then --隐藏弓箭手武器
		-- 	self.root.weapon:hide()
		-- end
	end

	self._is_visible = true
	if not self.is_player then
		if self.root.show_effect then
			self.root:show_effect()
		end
	end

	for i,v in ipairs(self.effect_list) do
		v:show_effect()
	end
	delay(handler(self, self.on_finish), self.xp_res_d.time)
end

function XpEffect:set_finish_cb( cb )
	self.finish_cb = cb
end

-- 设置特效播放完成后不隐藏
function XpEffect:set_not_hide( hide )
	self.is_not_hide = hide
end

-- 设置是玩家
function XpEffect:set_player()
	self.is_player = true
end

function XpEffect:set_camera_visible( visible )
	if not self.main_camera or not visible then
		self.main_camera = LuaHelper.Find("Main Camera")
		if not self.main_camera then
			self.main_camera = BeginCamera
		end
	end

	UI:SetActive(visible)
	NPC:SetActive(visible)
	HP:SetActive(visible)
	Touch:SetActive(visible)
	BeginCamera:SetActive(visible)
	UICamera:SetActive(visible)
	EffectCamera:SetActive(visible)

	self.main_camera:SetActive(visible)
end

function XpEffect:get_hide_time()
	return self.xp_res_d.time
end

function XpEffect:on_finish( effect )
	if not self._is_visible or self.is_not_hide then
		return
	end
	
	self._is_visible = false
	if self.is_player then
		LuaHelper.SetLayerToAllChild(self.root.transform, ClientEnum.Layer.CHARACTER)
		-- if string.find(self.root.sprite_name, "112") then --隐藏弓箭手武器
		-- 	self.root.weapon:show()
		-- end
	end

	for i,v in ipairs(self.effect_list) do
		v:hide()
	end

	self:hide()

	if self.finish_cb then
		self.finish_cb(self)
	end
end

function XpEffect:hide()
	self:set_camera_visible(true)
	if not self.is_player then
		self.root:hide()
	else
		-- self.root.animator:Play("EmptyState", 1)
	end
end

function XpEffect:dispose()
	for i,v in ipairs(self.effect_list) do
		v:dispose()
	end
	self.effect_list = {}
	if not self.is_player then
		self.root:dispose()
	end
	self.root = nil
	print("xp特效dispose ",self.data.effect)
end

return XpEffect
