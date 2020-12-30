--[[--
--世界地图
-- @Author:HuangJunShan
-- @DateTime:2017-08-05 19:38:42
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local WorldMap=class(UIBase,function(self,item_obj,ui)
	self:set_bg_visible( true )
    UIBase._ctor(self, "world_map.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    self.ui = ui
end)

-- 资源加载完成
function WorldMap:on_asset_load(key,asset)
	print("注册世界地图")
	StateManager:register_view( self )
end

function WorldMap:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击了世界地图",obj)
	if cmd == "cancleBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:hide()
	elseif cmd == "toSceneBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:hide()
		-- View("bigMap",self.item_obj)
		require("models.map.bigMap")(self.item_obj)
	elseif cmd == "infoZorkPractice" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("zorkPractice"):info_zork_scene()
		self:hide()
	elseif string.find(cmd,"changeScene_") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:hide()
		local mapId = tonumber(string.split(cmd,"_")[2])
		local mapinfo = ConfigMgr:get_config( "mapinfo" )[mapId]
		LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(mapId,mapinfo.delivery_posx,mapinfo.delivery_posy,true,ServerEnum.TRANSFER_MAP_TYPE.WORLD_MAP)
	end
end

function WorldMap:on_showed()
end

function WorldMap:on_hided()
	self:dispose()
end

-- 释放资源
function WorldMap:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return WorldMap

