--[[--
--
-- @Author:Seven
-- @DateTime:2017-05-11 17:42:58
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SceneView=class(AssetScene,function(self,item_obj, param)
    AssetScene._ctor(self,param.scene_url..".u3d",param.scene_url,true) --资源名字全部都是小写
    self.item_obj=item_obj
    self.param = param
end)

function SceneView:on_asset_load(key,asset)
	self:init()
end

function SceneView:init()
	Application.targetFrameRate = 30
	if self.param.mapId then
		self.battle_obj = LuaItemManager:get_item_obejct("battle")
		self.battle_obj:set_map_id(self.param.mapId)
		self.battle_obj:init()
	end
	local map_data = ConfigMgr:get_config("mapinfo")[self.param.mapId]
	if not map_data then
		gf_error_tips("找不到地图数据，id =",self.param.mapId)
		return
	end
	if map_data.weather then -- 加载天气
        Loader:get_resource(map_data.weather..".u3d",nil,"UnityEngine.GameObject",function(req)
        	print("加载天气成功")
        	LuaHelper.Instantiate(req.data)
        end,function(s)
        	print("加载天气失败")
        end)
	end
	local ArrowParent = LuaHelper.Find("Arrow")
	if ArrowParent ~= nil then
		local is_show_effect = LuaItemManager:get_item_obejct("mozu"):get_is_show_effect()
		local child_list = LuaHelper.GetAllChild(ArrowParent)
		for i = 1, #child_list do
			child_list[i].gameObject:SetActive(is_show_effect)
		end
	end
end

function SceneView:dispose()
	if self.battle_obj then
		self.battle_obj:clear()
	end
	SceneView._base.dispose(self)
end

return SceneView

