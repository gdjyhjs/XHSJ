--[[--
-- 在ugui上显示3d模型
-- @Author:Seven
-- @DateTime:2017-05-25 20:20:25
--]]
local Enum = require("enum.enum")
local Weapon = require("models.battle.obj.weapon")
local SpriteBase = require("common.spriteBase")

--callback  模型加载完成回调
local UIModel = class(function( self, root ,pos,withou_move,career,data,callback)
	self.root = root
	self.pos = pos
	self.career = career
	self.data = data
	self.withou_move = withou_move
	self.callback = callback
	self:init()
end)

function UIModel:init()
	self.model_camera = LuaHelper.FindChild(self.root, "camera")
	-- self.model_camera.transform.rotation = Vector3(18,0,0)
	self.model_rotation = LuaHelper.FindChildComponent(self.root, "rawImage", "Seven.ModelRotation")
	--加载人物模型
    self:load_model(self.career)
end

function UIModel:load_model( career )
	self.career = career
	local data = self.data
	if not data then
		self.career = self.career or LuaItemManager:get_item_obejct("game").role_info.career
		data = {}

		local BagUserData = require("models.bag.bagUserData")
		local list = BagUserData:get_role_equip_mode()
		local model_id = list[ServerEnum.EQUIP_TYPE.HELMET]
		local weapon_model = list[ServerEnum.EQUIP_TYPE.WEAPON]
		data.model_name = (model_id or ConfigMgr:get_config("career_default_model")[self.career].model_id)..".u3d"
		data.default_angles = Vector3(0,-173.5,0)
		data.weapon = weapon_model or ConfigMgr:get_config("career_default_weapon")[self.career].model_id
	end

	local on_cmp = function( req )
	print("wtf on cmp")
		local spr = {}
		spr.root = LuaHelper.Instantiate(req.data)
		local model_tf = spr.root.transform
        model_tf.parent = self.root.transform
        model_tf.localPosition = self.pos or Vector3(0,-2,4)				--设置位置
        model_tf.localScale= data.scale_rate or Vector3(1,1,1) 				--设置大小比例
        model_tf.localEulerAngles = data.default_angles or Vector3(0,0,0)	--设置欧拉角
        local animator = LuaHelper.GetComponent(spr.root, "UnityEngine.Animator") -- 动画控制器
        print("UIModel",self.career)
        if self.career then
	    	animator:SetBool("ui_idle", true)
	    else
	        animator:SetBool("idle", true)
	    end

        self.animator = animator
        -- Seven.PublicFun.ChangeShader(spr.root, "Unlit/Texture")

        if not self.withou_move then
        	self.model_rotation.target = model_tf
        end
        LuaHelper.SetLayerToAllChild(model_tf, ClientEnum.Layer.UI)--设置ui层

        -- 加载武器	
        if data.weapon then
        	local cb = function( weapon )
        		LuaHelper.SetLayerToAllChild(weapon.transform, ClientEnum.Layer.UI)--设置ui层
        	end
        	Weapon(spr, data.weapon, cb)
        end

        self.root = spr.root

        if self.callback then
        	self.callback(spr.root)
        end

	end
	Loader:get_resource(data.model_name, on_cmp)
end

function UIModel:on_showed()
	if self.animator then
		if self.career then
	    	self.animator:SetBool("ui_idle", true)
	    else
	        self.animator:SetBool("idle", true)
	    end
	end
end

function UIModel:dispose()
	if self.root then
		LuaHelper.Destroy(self.root)
		self.root = nil
	end
end

return UIModel
