--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-18 23:00:01
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local BossTipsView=class(UIBase,function(self,item_obj,boss_id)
	self.boss_id = boss_id
    UIBase._ctor(self, "zork_quick entry.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function BossTipsView:on_asset_load(key,asset)
	self:init_ui()
end

function BossTipsView:init_ui()
	local data = ConfigMgr:get_config("creature")[self.boss_id]
	if not data then
		gf_error_tips(string.format("找不到boss = %d的数据，请检查配置表!!!",self.boss_id))
		return
	end

	self.refer:Get("name").text = data.name.." Lv."..data.level
	gf_setImageTexture(self.refer:Get("icon"),data.icon_id or "")

	self:start_scheduler()
end

function BossTipsView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "btn_close" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()

	elseif cmd == "atk_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:find_boss(self.boss_id)
		self:dispose()

	end
end

function BossTipsView:start_scheduler()
	self.start_tick = Net:get_server_time_s() + 60
	if self.schedule_id then
		self:stop_scheduler()
	end
	local update = function()
		print("wtf update BossTipsView")
		if self.start_tick < Net:get_server_time_s() then
			self:dispose()
		end
	end
	self.schedule_id = Schedule(update, 1)
end
function BossTipsView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function BossTipsView:on_receive( msg, id1, id2, sid )
end

function BossTipsView:register()
	StateManager:register_view( self )
end

function BossTipsView:cancel_register()
	self:stop_schedule()
	StateManager:remove_register_view( self )
end

function BossTipsView:on_showed()
	self:register()

end

function BossTipsView:on_hided()
	self:cancel_register()
end

-- 释放资源
function BossTipsView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return BossTipsView

