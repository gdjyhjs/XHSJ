--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-23 20:06:54
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SpeedyPotion=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "speedy_potion.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function SpeedyPotion:on_asset_load(key,asset)
	StateManager:register_view(self)
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	local Mainui = LuaItemManager:get_item_obejct("mainui")
	local data = Mainui:get_cur_blood_tb()
	if data then
		self:refresh(data)
	else
		self:dispose()
	end
end

function SpeedyPotion:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function SpeedyPotion:update_item(item,index,data)
	gf_setImageTexture(item:Get(1),data.icon)
	if data.count > 999 then
		item:Get(2).text = 999
	else
		item:Get(2).text = data.count
	end
	item:Get(3).text =data.name
	item:Get(4).text =data.desc
end
function SpeedyPotion:on_click(obj,arg)
	local cmd =obj.name
	if cmd == "potion_mask" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "potion_item(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("bag"):set_immed_add_hp_item_c2s(arg.data.code)
		self:dispose()
	end 
end
-- 释放资源
function SpeedyPotion:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return SpeedyPotion

