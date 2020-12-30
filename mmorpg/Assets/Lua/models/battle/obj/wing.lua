--[[--
--  翅膀
-- @Author:Seven
-- @DateTime:2017-07-14 11:28:01
--]]
local WingParent = LuaHelper.Find("Wing").transform
local SpriteBase = require("common.spriteBase")
local Wing = class(SpriteBase, function ( self, player, model_id, ... )
	self.player = player
	self.model_id = model_id
	self.battle_item = LuaItemManager:get_item_obejct("battle")
	SpriteBase._ctor(self, self.model_id..".u3d", ...)
end)

function Wing:init()
	LuaHelper.SetLayerToAllChild(self.transform, ClientEnum.Layer.CHARACTER)-- 不碰撞层
	Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）
	self:change_material_img(self.material_img)

	LuaHelper.RemoveComponent(self.root, "UnityEngine.AI.NavMeshAgent")
	LuaHelper.RemoveComponent(self.root, "UnityEngine.CharacterController")

	self.mesh = LuaHelper.GetComponentInChildren(self.root, "UnityEngine.SkinnedMeshRenderer")
	self.animator = LuaHelper.GetComponent(self.root, "UnityEngine.Animator") -- 动画控制器
	if self.animator then
		self.animator:SetBool("idle", true)
	end
	if self.is_in_pool ~= true then
		if self.player then
			if self.player.root ~= nil then
				local node = LuaHelper.FindChild(self.player.root, "wing")
				self:set_parent(node.transform)
				self.transform.localPosition = Vector3(0,0,0)
				self.transform.localRotation = Vector3(0,0,0)
				self.transform.localScale = Vector3(1,1,1)

				self.mesh_enable = true
			end
		
			self.player:set_wing(self)
		end
	else
		self.transform.parent = WeaponParent
		self:faraway()
	end
end

function Wing:set_player( player )
	self.player = player
	if self.transform ~= nil and self.is_in_pool ~= true then
		self:init()
	end
end

function Wing:set_mesh_enable( enabled )
	self.mesh_enable = enabled
	if self.mesh then
		self.mesh.enabled = enabled
	end
end

function Wing:on_ani_change(is_move)
	if not self.animator then
		return
	end
	self.animator:SetBool("move", is_move or false)
end

-- 更换材质球贴图
function Wing:change_material_img( img_name )
	print("wing设置材质球贴图",img_name)
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
function Wing:set_flow_img( img, color, speed )
	print("设置翅膀流光贴图",img, color, speed)
	color = color and gf_get_color2("#"..color)
	self.flow_img = img
	self.flow_color = color
	self.flow_speed = speed

	if not self.root then
		return
	end

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

-- 特效
function Wing:set_effect( effect_list, layer )
	layer = layer or ClientEnum.Layer.CHARACTER
	-- print("设置翅膀特效",effect_list)
	for i,v in ipairs(self.effect_list or {}) do
		LuaItemManager:get_item_obejct("battle"):remove_effect(v)
	end
	self.effect_list = {}
	if not effect_list then
		return
	end

	local finish_cb = function( effect, parent, scale )
		-- print("翅膀骨骼特效",self.mesh_enable)
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
			local obj = LuaHelper.FindChild(self.root, v[1])
			-- print("翅膀骨骼特效",obj)
			if obj then
				parent = obj.transform
			end
		end
		if not parent then
			parent = self.transform
		end
		local scale = 1
		if v[3] then
			scale = tonumber(v[3])
		end
		LuaItemManager:get_item_obejct("battle"):get_effect(v[2]..".u3d", finish_cb, parent, scale)
	end
end

function Wing:faraway()
	Wing._base.faraway(self)
	for i,v in ipairs(self.effect_list or {}) do
		LuaItemManager:get_item_obejct("battle"):remove_effect(v)
	end
	self.effect_list = {}
end

function Wing:dispose()
	print("Wing:dispose",self.model_id)
	Wing._base.dispose(self)
end

return Wing
