--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-06 12:33:10
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local copyStateBase = require("common.viewBase")

local CopyView=class(copyStateBase,function(self,item_obj)
    copyStateBase._ctor(self, "mainui_tower.u3d", item_obj) -- 资源名字全部是小写

    self.copy_item = LuaItemManager:get_item_obejct("copy")
    self.time = 0
end)

-- 资源加载完成
function CopyView:on_asset_load(key,asset)
	self.is_init = true
	self:set_always_receive(true)
	self:init_ui()
	self:set_visible(self.copy_item:is_show_task())
	self:update_view()
end

function CopyView:register()
	self.schedule = Schedule(handler(self, self.on_update), 1.0)
end

function CopyView:cancel_register()
	if self.schedule then
		self.schedule:stop()
		self.schedule = nil
	end
end

function CopyView:update_view()
	if not self.is_init then
		return
	end

	self:init_view()

	if self.view then
		self.view:update_view()
	end
end

function CopyView:init_ui()

	-- self.tips_img = LuaHelper.FindChild(self.root, "tipsImg")
	-- self.tips_txt = self.tips_img:GetComponentInChildren("UnityEngine.UI.Text")

	self.tween = self.refer:Get("copy")
	self.tween.from = self.tween.transform.localPosition
	self.tween.to = self.tween.transform.localPosition + Vector3(-265, 0, 0)

	-- self.story_view = require("models.mainui.storyView")(self.root, self.refer:Get(3))
	self.tower_view = require("models.mainui.towerView")(self.root, self.refer:Get(4))

	self:init_view()
end

function CopyView:init_view()
	local is_story = self.copy_item:is_story()
	local is_tower = self.copy_item:is_tower()

	if is_tower then
		self.view = self.tower_view
	else
		self.view = nil
	end

	self.refer:Get("tower"):SetActive(is_tower)
end

function CopyView:show_view( show )
	if not self.tween then
		return
	end

	if show then
		self.tween:PlayReverse()
	else
		self.tween:PlayForward()
	end
end

function CopyView:on_update( dt )
	if not self.is_init then
		return
	end
	
	if self.view then
		self.view:update_time(dt)
	end
end

function CopyView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "leaveBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		
	end
end

function CopyView:on_receive(msg, id1, id2, sid)
	print("CopyView on_receive:")
	if self.view then
		self.view:on_receive(msg, id1, id2, sid)
	end
end

function CopyView:on_showed()
	CopyView._base.on_showed(self)
	self:register()
end

function CopyView:on_hided()
	self:cancel_register()
	CopyView._base.on_hided(self)
end

-- 释放资源
function CopyView:dispose()
	CopyView._base.dispose(self)
	self.view = nil
	self.tower_view = nil
	self.story_view = nil
	self:cancel_register()
   
end

return CopyView

