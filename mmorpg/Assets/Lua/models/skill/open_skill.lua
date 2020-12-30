--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-17 09:42:54
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Open_skill=class(UIBase,function(self,item_obj,num,atkplane)
    UIBase._ctor(self, "guide_skill.u3d",item_obj) -- 资源名字全部是小写
    self.num = num
    self.atkplane = atkplane
end)

-- 资源加载完成
function Open_skill:on_asset_load(key,asset)
	LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(true)
	StateManager:register_view( self )
	self.refer:Get(self.num):SetActive(true)
	self.countdown =Schedule(handler(self, function()
		self.atkplane.open_skill_unlock = nil
		LuaItemManager:get_item_obejct("functionUnlock"):open_fun_over()
		self:dispose()
		self.countdown:stop()
	end), 5)
	 -- 技能、武将伙伴库、背包仓库等解锁时播放的音效
	Sound:play(ClientEnum.SOUND_KEY.UNLOCK)
end

function Open_skill:on_click(obj, arg)
	if obj.name == "gd_background" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.atkplane.open_skill_unlock = nil
		if self.atkplane.close_effect_id ~=5 then
			self.atkplane.filled_list[self.atkplane.close_effect_id].effect3:SetActive(false)
		end
		LuaItemManager:get_item_obejct("functionUnlock"):open_fun_over()
		self:dispose()
	end
end

-- 释放资源
function Open_skill:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return Open_skill

