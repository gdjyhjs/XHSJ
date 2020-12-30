--[[--
-- 武器类
-- @Author:Seven
-- @DateTime:2017-07-27 18:17:15
--]]
local WeaponParent = LuaHelper.Find("Weapon").transform
local SpriteBase = require("common.spriteBase")
local Weapon = class(SpriteBase, function ( self, player, model_id, ... )
	self.player = player
	self.model_id = model_id
	
	SpriteBase._ctor(self, model_id..".u3d", ...)
end)

function Weapon:init()
	LuaHelper.SetLayerToAllChild(self.transform, ClientEnum.Layer.CHARACTER)-- 不碰撞层
	Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）
	LuaHelper.RemoveComponent(self.root, "UnityEngine.AI.NavMeshAgent")
	LuaHelper.RemoveComponent(self.root, "UnityEngine.CharacterController")
	LuaHelper.RemoveComponent(self.root, "UnityEngine.Animator")
	
	self.mesh_enable = true
	self.mesh = LuaHelper.GetComponent(self.root, "UnityEngine.MeshRenderer")
	self:change_material_img(self.material_img)

	if self.is_in_pool ~= true then
		self:init_weapon()
	else
		self.transform.parent = WeaponParent
		self:faraway()
	end
end

function Weapon:init_weapon()
	if self.player ~= nil then
		if self.player.root ~= nil then
			local parent = LuaHelper.FindChild(self.player.root, "Bip001 Prop1").transform
			self:set_parent(parent)
			self.transform.localPosition = Vector3(0,0,0)
			self.transform.localRotation = Vector3(0,0,0)
			self.transform.localScale = Vector3(1,1,1)
			if self.player.set_weapon then
				self.player:set_weapon(self)
			end
		end
	end
end

function Weapon:set_player( player )
	self.player = player
	if self.transform ~= nil and self.is_in_pool ~= true then
		self:init_weapon()
	end
end

function Weapon:set_mesh_enable( enabled )
	self.mesh_enable = enabled
	if self.mesh then
		self.mesh.enabled = enabled
	end
	if self.effect then
		if enabled then
			self.effect:show_effect()
		else
			self.effect:hide()
		end
	end
end

-- 更换材质球贴图
function Weapon:change_material_img( img_name )
	if not img_name then
		return
	end
	self.material_img = img_name

	if not self:is_loaded() then
		return
	end

	if not self.flow_img then
		-- 更换shader
		Seven.PublicFun.ChangeShader(self.root, "Unlit/Texture")
		Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）
	end

	if not self.material then
		local render = LuaHelper.GetComponentInChildren(self.root, "UnityEngine.Renderer")
		self.material = render.material
	end
	gf_change_material_img(self.material, img_name)
end

-- 设置流光贴图
function Weapon:set_flow_img( img, color, speed )
	print("设置流光贴图",img, color, speed)
	color = color and gf_get_color2("#"..color)
	self.flow_img = img
	self.flow_color = color
	self.flow_speed = speed

	if not img then
		Seven.PublicFun.ChangeShader(self.root, "Unlit/Texture")
		Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）
		return
	end

	-- 更换shader
	Seven.PublicFun.ChangeShader(self.root, "Seven/Flow")
	Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）

	if not self.material then
		local render = LuaHelper.GetComponentInChildren(self.root, "UnityEngine.Renderer")
		self.material = render.material
	end

	gf_change_material_img(self.material, img, "_AfterTex")
	self.material:SetColor("_AfterColor", color)
	self.material:SetFloat("_FlowSpeed", speed)
end

-- 武器特效
function Weapon:set_effect( effect_list, layer )
	layer = layer or ClientEnum.Layer.CHARACTER
	for i,v in ipairs(self.effect_list or {}) do
		LuaItemManager:get_item_obejct("battle"):remove_effect(v)
	end
	self.effect_list = {}
	if not effect_list then
		return
	end

	local finish_cb = function( effect, parent, scale )
		if self.mesh_enable then
			effect:show_effect()
		end
		effect.transform.parent = parent
		effect.transform.localPosition = Vector3(0,0,0)
		effect.transform.localRotation = Vector3(0,0,0)
		effect.transform.localScale = Vector3(scale,scale,scale)
		if layer then
			LuaHelper.SetLayerToAllChild(effect.transform, layer)
		end
		self.effect_list[#self.effect_list+1]=effect
	end
	
	for i,v in ipairs(effect_list or {}) do
		local parent = self.transform
		if v[1] ~= "" then
			parent = LuaHelper.FindChild(self.root, v[1])
		end
		if not parent then
			parent = self.transform
		end
		local scale = v[3] or 1
		LuaItemManager:get_item_obejct("battle"):get_effect(v[2]..".u3d", finish_cb, parent, scale)
	end
end

function Weapon:faraway()
	Weapon._base.faraway(self)
	for i,v in ipairs(self.effect_list or {}) do
		LuaItemManager:get_item_obejct("battle"):remove_effect(v)
	end
	self.effect_list = {}
end

function Weapon:dispose()
	print("Weapon:dispose",self.model_id)
	Weapon._base.dispose(self)
end

return Weapon

