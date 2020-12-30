--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local AchievementTipsView=class(UIBase,function(self,id)
	local item_obj = LuaItemManager:get_item_obejct("achievementTips")
	self.item_obj = item_obj
    UIBase._ctor(self, "mainui_get_achievement.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function AchievementTipsView:on_asset_load(key,asset)
	local item_obj = LuaItemManager:get_item_obejct("achievementTips")
	self.id = item_obj.achievement_id
	local data = ConfigMgr:get_config("achieve")
	local name = data[self.id].name or ""
	local text = self.refer:Get(1)
	text.text = name

	local callBack = function()
		self:dispose()
	end
	delay(callBack,3)
end

function AchievementTipsView:on_click( obj, arg )
    local cmd= obj.name
	if cmd == "bg" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		 if LuaItemManager:get_item_obejct("guide"):is_guide() then return end
		if LuaItemManager:get_item_obejct("battle"):get_character().dead ~= true then
			local item_obj = LuaItemManager:get_item_obejct("achievement")
			item_obj.id = self.id
			gf_create_model_view("achievement")
		end
	end
end

function AchievementTipsView:on_receive( msg, id1, id2, sid )
end

function AchievementTipsView:register()
	--self.item_obj:register_event("on_click", handler(self, self.on_click))
	StateManager:register_view(self)
end

function AchievementTipsView:cancel_register()
	--self.item_obj:register_event("on_click", nil)
	StateManager:remove_register_view(self)
end

function AchievementTipsView:on_showed()
	self:register()
end

function AchievementTipsView:on_hided()
end

-- 释放资源
function AchievementTipsView:dispose()
	self:cancel_register()
    self._base.dispose(self)
    local item_obj = LuaItemManager:get_item_obejct("achievementTips")
	item_obj.achievement_id = nil
end

return AchievementTipsView

