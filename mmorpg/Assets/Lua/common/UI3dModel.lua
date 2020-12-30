--[[--
-- 在ugui上显示3d模型
-- @Author:Seven
-- @DateTime:2017-05-25 20:20:25
--]]
local Enum = require("enum.enum")
local Weapon = require("models.battle.obj.weapon")
local Wing = require("models.battle.obj.wing")
local SpriteBase = require("common.spriteBase")

--callback  模型加载完成回调
local UIModel = class(function( self, ui_model)
	self.ui_model = ui_model
	self.touch_rotation = true

	self.battle_item = LuaItemManager:get_item_obejct("battle")
	self.surface_item = LuaItemManager:get_item_obejct("surface")

	self:init()
end)

function UIModel:init()
	self.is_be_dispose = false
	self.model_camera = LuaHelper.FindChild(self.ui_model, "camera")
	self.model_rotation = LuaHelper.FindChildComponent(self.ui_model, "rawImage", "Seven.ModelRotation")
end

-- 设置职业
function UIModel:set_career( career )
	self.career = career or LuaItemManager:get_item_obejct("game").role_info.career
end

-- 设置模型id
function UIModel:set_model( model_id )
	if model_id and self.model_id == model_id then
		return
	end

	self.is_load = false
	self.model_id = model_id
	if not model_id then
		if not self.career then
			self:set_career()
		end

		local BagUserData = require("models.bag.bagUserData")
		local list = BagUserData:get_role_equip_mode()
		local model_img
		self.model_id, model_img = self.surface_item:get_wear_surface_model(ServerEnum.SURFACE_TYPE.CLOTHES)
		if model_img then
			self:set_material_img(model_img)
		end
		if not self.model_id then
			self.model_id = list[ServerEnum.EQUIP_TYPE.HELMET] or ConfigMgr:get_config("career_default_model")[self.career].model_id
		end
		print("UI模型id =",self.model_id,model_img)
	end
end

-- 设置武器
function UIModel:set_weapon( weapon_id )
	if self.weapon_id and weapon_id and self.weapon_id == weapon_id then -- 同一个武器模型，不重新加载
		return
	end

	if weapon_id then
		self.weapon_id = weapon_id
	else
		if not self.career then
			self:set_career()
		end

		local BagUserData = require("models.bag.bagUserData")
		local list = BagUserData:get_role_equip_mode()
		local weapon_img,weapon_flow_img,weapon_flow_color,weapon_flow_speed,weapon_effect
		self.weapon_id,weapon_img,weapon_flow_img,weapon_flow_color,weapon_flow_speed,weapon_effect = self.surface_item:get_wear_surface_model(ServerEnum.SURFACE_TYPE.WEAPON)
		if weapon_img then
			self:set_weapon_img(weapon_img)
		end
		if weapon_flow_img then
			self:set_weapon_flow_img(weapon_flow_img,weapon_flow_color,weapon_flow_speed)
		end
		if weapon_effect then
			self:set_weapon_effect(weapon_effect)
		end

		if not self.weapon_id then
			self.weapon_id = list[ServerEnum.EQUIP_TYPE.WEAPON] or ConfigMgr:get_config("career_default_weapon")[self.career].model_id
		end
	end

	if self.is_load then
		self:load_weapon()
	end
end

-- 设置翅膀
function UIModel:set_wing( wing_id )
	if self.wing_id and wing_id and self.wing_id == wing_id then -- 同一个，不重新加载
		return
	end

	if wing_id then
		self.wing_id = wing_id
	else
		if not self.career then
			self:set_career()
		end
		local wing_img,flow_img,flow_color,flow_speed,effect
		self.wing_id,wing_img,flow_img,flow_color,flow_speed,effect = self.surface_item:get_wear_surface_model(ServerEnum.SURFACE_TYPE.CARRY_ON_BACK)
		if wing_img then
			self:set_wing_img(wing_img)
		end
		if flow_img then
			self:set_wing_flow_img(flow_img,flow_color,flow_speed)
		end
		if effect then
			self:set_wing_effect(effect)
		end
	end
	
	if self.is_load then
		self:load_wing()
	end
end

-- 设置气息
function UIModel:set_surround( surround_id )

	if self.surround_id and surround_id and self.surround_id == surround_id then -- 同一个，不重新加载
		return
	end

	if surround_id then
		self.surround_id = surround_id
	else
		self.surround_id = self.surface_item:get_wear_surface_model(ServerEnum.SURFACE_TYPE.SURROUND)
	end
		
	if self.is_load then
		self:load_surround()
	end
end

-- 更换材质球图片
function UIModel:set_material_img( img )
	self.material_img = img
	if self.is_load then
		self.obj:change_material_img(img)
	else
		self.material_img_change = true
	end
end

function UIModel:set_weapon_img( img )
	self.weapon_img = img
	if self.is_load then
		self:load_weapon_img()
	else
		self.weapon_img_change = true
	end
end

-- 设置武器流光贴图
function UIModel:set_weapon_flow_img( img, color, speed )
	self.weapon_flow_img = img
	self.weapon_flow_color = color
	self.weapon_flow_speed = speed
	if self.is_load then
		self:load_weapon_flow_img()
	end
end

-- 武器特效
function UIModel:set_weapon_effect( effect )
	self.weapon_effect = effect
	if self.is_load then
		self:load_weapon_effect()
	end
end

function UIModel:set_wing_img( img )
	self.wing_img = img
	if self.is_load then
		self:load_wing_img()
	else
		self.wing_img_change = true
	end
end

-- 设置武器流光贴图
function UIModel:set_wing_flow_img( img, color, speed )
	self.wing_flow_img = img
	self.wing_flow_color = color
	self.wing_flow_speed = speed
	if self.is_load then
		self:load_wing_flow_img()
	end
end

-- 武器特效
function UIModel:set_wing_effect( effect )
	self.wing_effect = effect
	if self.is_load then
		self:load_wing_effect()
	end
end

-- 设置模型角度
function UIModel:set_angle( angle )
	self.angle = angle or Vector3(0,-173.5,0)
end

-- 设置本地位置
function UIModel:set_local_position( pos )
	self.local_pos = pos or Vector3(0,-2,4)
end

-- 缩放
function UIModel:set_scale( scale )
	self.scale = scale or Vector3(1,1,1)
end

-- 设置拖动旋转
function UIModel:set_touch_rotation( flag )
	self.touch_rotation = flag
end

-- 设置为玩家
function UIModel:set_player( is_player )
	self.is_player = is_player
end

-- 设置为怪物
function UIModel:set_monster( is_monster )
	self.is_monster = is_monster
end

-- 获取角色
function UIModel:get_char()
	return self.obj
end

-- 设置模型加载完成回调
function UIModel:set_finish_cb( cb )
	self.finish_cb = cb
end

-- 加载模型
function UIModel:load_model()
	if self.obj and self.obj.config_data.model_id == self.model_id then -- 同一个模型，不重新加载
		if self.finish_cb then
	    	self.finish_cb(self.obj)
	    end
		self:load_material_img()
		self:load_weapon()
		self:load_wing()
		return
	end

	if self.is_player then
		print("UIModelload_model:on_cmp")
		self.battle_item.pool:get_character(self.model_id, self.career, 1, handler(self, self.on_cmp))
	end
end

function UIModel:load_clothes()
	if self.obj and self.obj.config_data.model_id == self.model_id then -- 同一个模型，不重新加载
		if self.finish_cb then
	    	self.finish_cb(self.obj)
	    end
		return
	end
	if self.is_player then
		print("UIModelload_model:load_clothes")
		self.battle_item.pool:get_character(self.model_id, self.career, 1, handler(self, self.on_cmp))
	end
end

function UIModel:load_weapon()
	if not self.obj then
		return
	end
	
	if self.obj.weapon and self.obj.weapon.model_id == self.weapon_id then -- 同一把武器
		self:load_weapon_flow_img()
		self:load_weapon_img()
		self:load_weapon_effect()
		return
	end

	-- 加载武器	
    if self.weapon_id then
    	local cb = function( weapon )
    		LuaHelper.SetLayerToAllChild(weapon.transform, ClientEnum.Layer.UI)--设置ui层
    		self:load_weapon_flow_img()
    		self:load_weapon_img()
			self:load_weapon_effect()
    	end
    	self.battle_item:change_weapon(self.obj, self.weapon_id, cb)
    end
end

function UIModel:load_wing()
	if not self.obj then
		return
	end

	if self.obj.wing and self.obj.wing.model_id == self.wing_id then -- 同一把武器
		self:load_wing_flow_img()
		self:load_wing_img()
		self:load_wing_effect()
		return
	end

	if self.wing_id then
		local cb = function( wing )
    		LuaHelper.SetLayerToAllChild(wing.transform, ClientEnum.Layer.UI)--设置ui层
    		self:load_wing_flow_img()
			self:load_wing_img()
			self:load_wing_effect()
    	end
		self.battle_item:create_wing(self.wing_id, self.obj, cb)
	else
		self.battle_item:create_wing(nil, self.obj)
	end
end

function UIModel:load_surround()
	if self.surround_id then
		local cb = function( surround )
    		LuaHelper.SetLayerToAllChild(surround.transform, ClientEnum.Layer.UI)--设置ui层
    	end
		self.battle_item:create_surround(self.surround_id, self.obj, cb)
	end
end

function UIModel:load_material_img()
	if self.material_img and self.material_img_change then
		self.material_img_change = false
		self.obj:change_material_img(self.material_img)
	end
end

function UIModel:load_weapon_img()
	if self.weapon_img and self.obj.weapon and self.obj.weapon.model_id == self.weapon_id then
		self.obj.weapon:change_material_img(self.weapon_img)
		self.weapon_img = nil
	end
end

function UIModel:load_wing_img()
	if self.wing_img then
		self.obj.wing:change_material_img(self.wing_img)
		self.wing_img = nil
	end
end

function UIModel:load_weapon_flow_img()
	if self.obj.weapon and self.obj.weapon.model_id == self.weapon_id then
		self.obj.weapon:set_flow_img(self.weapon_flow_img, self.weapon_flow_color, self.weapon_flow_speed)
		self.weapon_flow_img = nil
	end
end

function UIModel:load_weapon_effect()
	if self.obj.weapon and self.obj.weapon.model_id == self.weapon_id then
		self.obj.weapon:set_effect(self.weapon_effect, ClientEnum.Layer.UI)
		self.weapon_effect = nil
	end
end

function UIModel:load_wing_flow_img()
	if self.obj.wing and self.obj.wing.model_id == self.wing_id then
		self.obj.wing:set_flow_img(self.wing_flow_img, self.wing_flow_color, self.wing_flow_speed)
		self.wing_flow_img = nil
	end
end

function UIModel:load_wing_effect()
	if self.obj.wing and self.obj.wing.model_id == self.wing_id then
		self.obj.wing:set_effect(self.wing_effect, ClientEnum.Layer.UI)
		self.wing_effect = nil
	end
end

function UIModel:on_cmp( obj )
	print("UIModelxxxxxxxx:on_cmp")
	self:clear_model()
	self.obj = obj
	if self.is_be_dispose ~= true then
		local model_tf = obj.transform
	    model_tf.parent = self.ui_model.transform
	    model_tf.localPosition = self.local_pos or Vector3(0,-2,4)		--设置位置
	    model_tf.localScale= self.scale or Vector3(1,1,1) 				--设置大小比例
	    model_tf.localEulerAngles = self.angle or Vector3(0,-173.5,0)	--设置欧拉角
	    
	    if self.is_player then
		    obj.animator:SetBool("idle", false)
	    	obj.animator:SetBool("ui_idle", true)
	    else
	        obj.animator:SetBool("idle", true)
	    end

	    if self.touch_rotation then
	    	self.model_rotation.target = model_tf
	    end
	    LuaHelper.SetLayerToAllChild(model_tf, ClientEnum.Layer.UI)--设置ui层
	  	self.obj:set_blood_line_visble(false)
	    self:load_material_img()
		self:load_weapon()        
		self:load_wing()
		self:load_surround()

	    self.is_load = true

	    if self.finish_cb then
	    	self.finish_cb(self.obj)
	    end
	else	--如果被dipsose掉了，就再clear一次
		self:clear_model()
	end
end

function UIModel:clear_model()
	print("UIModelclear_model1111:on_cmp")
	self.is_load = false
	if not self.obj then
		return
	end
	print("UIModelclear_model22222:on_cmp")
	-- self.obj.root.layer = ClientEnum.Layer.CHARACTER -- Character 不碰撞层
	LuaHelper.SetLayerToAllChild(self.obj.transform, ClientEnum.Layer.CHARACTER)--Character 不碰撞层
	if self.is_player then
		self.battle_item.pool:add_character(self.obj)
		self.battle_item.pool:add_weapon(self.obj.weapon)
		self.obj:set_weapon(nil)
		self.battle_item.pool:add_wing(self.obj.wing)
		self.obj:set_wing(nil)
		self.battle_item.pool:add_effect(self.obj.surround)
		self.obj:set_surround(nil)
	end
	self.obj = nil

end

function UIModel:on_showed()
	if self.obj and self.obj.animator then
		if self.is_player then
	    	self.obj.animator:SetBool("ui_idle", true)
	    else
	        self.obj.animator:SetBool("idle", true)
	    end
	end
end

function UIModel:dispose()
	self:clear_model()
	self.model_id = nil
	self.wing_id = nil
	self.weapon_id = nil
	self.surround_id = nil
	self.is_be_dispose = true
end

return UIModel
