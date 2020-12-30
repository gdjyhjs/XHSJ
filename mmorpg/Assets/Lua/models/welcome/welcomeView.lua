---------------------------------------------------------------------------------------------------
--===============================================================================================--
--filename: welcome_view.lua
--data:2016..
--author:pu
--desc:view 
--===============================================================================================--
-------------------------------------------------------------------------------------------------

local LuaHelper=LuaHelper

local view=class(Asset,function(self,item_obj)
    Asset._ctor(self, "welcome.u3d")
    self.item_obj=item_obj
end)

function view:on_asset_load(key,asset)
	-- 删除热更界面
	local fristView = LuaHelper.Find("regeng")
	if fristView then LuaHelper.Destroy(fristView) end
	
    self.item_obj:register_property_changed(self.databind,self)
    
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects") 
	self.content_rect_table = refer:Get(1)

	self.content_rect_table.onItemRender=function(scroll_rect_item,index,dataItem)
		scroll_rect_item.gameObject:SetActive(true)
		scroll_rect_item:Get(1).text = dataItem.title --title
		scroll_rect_item:Get(2).name = dataItem.name --button
		scroll_rect_item.name = dataItem.name
	end
	
	local obj = self.item_obj.assets[1].items.Text
	print(LuaHelper.GetComponent(obj,"UnityEngine.UI.Text").text)
	LuaHelper.GetComponent(obj,"UnityEngine.UI.Text").text = "Seven Text"
	print(refer:Get(2).text)
	local Vector3=UnityEngine.Vector3

	-- local camera = LuaHelper.GetComponent(LuaHelper.Find("Camera"),"UnityEngine.Camera")
	-- print("------camera =",camera:WorldToScreenPoint(Vector3(100, 0, 1)))
	-- self.camera = LuaHelper.Find("BeginCamera")

	-- self.battle_obj = LuaItemManager:get_item_obejct("battle")
	
	-- self:add_character("114101.u3d")

end

function view:add_character(name)
	-- 创建玩家
	local char = self.battle_obj:create_character(name)
	char:set_camera(self.camera)
	char:set_position(Vector3(50,10,150))
	char:set_scale(Vector3(10,10,10))
	char:enable_joystick(true)
	return char
end

--资源加载完成后显示的时候调用
function view:show_eg_list(data)
	self.content_rect_table.data = data
	self.content_rect_table:Refresh(-1,-1) --显示列表

end

function view:dispose()
    self.item_obj:register_property_changed(self.databind,nil)
    self._base.dispose(self)
 end

function view:databind(item_obj,property_name)
    if property_name == "eg_data" then
        self:show_eg_list(item_obj:get_eg_data())
    end
end

return view