--[[
	封灵展示属性加成界面
	create at 17.6.22
	by xin
]]
local LuaHelper = LuaHelper
local dataUse = require("models.horse.dataUse")
local res = 
{
	[1] = "horse_property_show.u3d",
}

local commom_string =
{
	[1] = gf_localize_string("封灵等级%d级"),
}

local showProperty = class(UIBase,function(self,horse_id)
	self.horse_id = horse_id
	local item_obj = LuaItemManager:get_item_obejct("horse")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function showProperty:on_asset_load(key,asset)
    self:init_ui()
end



--获取每个孔位属性加成
--封灵等级。每个孔位等级


--鼠标单击事件
function showProperty:on_click( obj, arg)
	print("showProperty click")
    local event_name = obj.name
    if event_name == "show_close" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()
    end
end

-- 释放资源
function showProperty:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function showProperty:on_receive( msg, id1, id2, sid )
	-- if id1 == Net:get_id1(modelName) then
	-- 	if id2 == Net:get_id2(modelName, "WakeUpHeroR") then
	-- 	end
	-- end
end

return showProperty