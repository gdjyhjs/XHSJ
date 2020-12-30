--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-06-14 13:16:33
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local XpEffect = require("models.battle.obj.xpEffect")

local CreateRole = LuaItemManager:get_item_obejct("createRole")
--UI资源
CreateRole.assets=
{
    -- require("models.createRole.createRoleSceneView")(CreateRole)
    View("createRoleView", CreateRole) ,
}

local model_name = {
	[Enum.CAREER.SOLDER] = "114101@show",
	[Enum.CAREER.MAGIC]  = "111101@show",
	[Enum.CAREER.BOWMAN] = "112101@show"
}

local camera_pos = {
	[Enum.CAREER.MAGIC] = Vector3(-8.62,-3.8,1.6),
    [Enum.CAREER.BOWMAN] = Vector3(-8.1,-3.435,1.18),
    [Enum.CAREER.SOLDER] = Vector3(-9.6,-3.52,1.37),
    [0] = Vector3(-9.6,-3.52,1.37),
}

local camera_dir = {
	[Enum.CAREER.MAGIC] = Vector3(0,69.30591,0),
    [Enum.CAREER.BOWMAN] = Vector3(0,73.28391,0),
    [Enum.CAREER.SOLDER] = Vector3(0,93.75346,0),
    [0] = Vector3(0,93.75346,0),
}


--获取相机角度
function CreateRole:get_camera_dir(career)
	return camera_dir[career] or camera_dir[0]
end

--获取相机位置
function CreateRole:get_camera_pos(career)
	return camera_pos[career] or camera_pos[0]
end

--获取职业模型名称
function CreateRole:get_model_name(career)
	return model_name[career] or "111101@show"
end

--点击事件
function CreateRole:on_click(obj,arg)
	self:call_event("create_role_view_on_click",false,obj,arg)
end

function CreateRole:get_ui(ui)
	if ui then
		self.ui=ui
	end
	return self.ui or self.asset[1]
end

function CreateRole:is_xp_loaded()
	return self._is_xp_loaded or false
end

-- 初始化xp
function CreateRole:init_xp( cb )
	if StateManager:get_current_state() ~= StateManager.create_role then
		cb()
		return
	end

	self.xp_list = {}
	local index = 0

	local finish_cb = function( effect )
		effect:set_not_hide(true)
		local career = tonumber(string.sub(effect.root.url, 3, 3))
		local tf = effect.root.transform
		tf.position = camera_pos[career]
		tf.eulerAngles = camera_dir[career]
		index = index+1
		if index == 3 then
			self._is_xp_loaded = true
			if self.assets[1]:is_loaded() then
				LuaItemManager:get_item_obejct("login"):min_career_c2s()
			end
			cb()
		end
	end
	for i,v in pairs(model_name) do
		self.xp_list[i] = XpEffect({effect = v}, finish_cb)
	end
end

--初始化函数只会调用一次
function CreateRole:initialize()
	print("创号数据初始化完毕")
end

function CreateRole:dispose()
	self._is_xp_loaded = false
	for k,v in pairs(self.xp_list) do
		v:hide()
		v:dispose()
	end
	self.xp_list = {}
	for i,v in ipairs(self.assets) do
		v:dispose()
	end
end

