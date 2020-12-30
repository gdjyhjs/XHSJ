--[[--
--
-- @Author:Huangjunshan
-- @DateTime:2017-06-14 12:22:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Scene = LuaItemManager:get_item_obejct("scene160102")
--UI资源
Scene.assets=
{
    require("models.sceneView.sceneView")(Scene, {scene_url = "login"}) 
}

--点击事件
function Scene:on_click(obj,arg)
	
end

--每次显示时候调用
function Scene:on_showed( ... )

end

--初始化函数只会调用一次
function Scene:initialize()
	
end