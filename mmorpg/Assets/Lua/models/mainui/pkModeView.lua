--[[--
--  设置战斗模式ui
-- @Author:Seven
-- @DateTime:2017-07-08 14:08:30
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local PkModeView=class(UIBase,function(self,item_obj)
	Net:receive(false, ClientProto.HideOrShowTaskPanel)

    UIBase._ctor(self, "main_battle_state.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function PkModeView:on_asset_load(key,asset)
	self.battle_item = LuaItemManager:get_item_obejct("battle")

	self:init_ui()

	StateManager:register_view(self)
end

function PkModeView:init_ui()
	local is_can_atk = self.battle_item:is_can_atk_other_player()
	self.refer:Get("legion_btn"):SetActive(is_can_atk)
	self.refer:Get("all_btn"):SetActive(is_can_atk)
end

function PkModeView:on_click( sender, arg )
	local cmd = sender.name

	if cmd == "peace_btn" then -- 和平
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.battle_item:get_character():get_battle_flag() then
			gf_message_tips(gf_localize_string("战斗状态下不能切换"))
			return
		end

		if self.battle_item:get_map_permissions(ServerEnum.MAP_FLAG.PK_PEACE) then
			self.battle_item:set_pk_mode_c2c(ServerEnum.PK_MODE.PEACE)
		else
			gf_message_tips(gf_localize_string("当前地图不能设置此模式"))
		end

	elseif cmd == "legion_btn" then -- 军团
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.battle_item:get_map_permissions(ServerEnum.MAP_FLAG.PK_ALLIANCE) then
			self.battle_item:set_pk_mode_c2c(ServerEnum.PK_MODE.ALLIANCE)
		else
			gf_message_tips(gf_localize_string("当前地图不能设置此模式"))
		end

	elseif cmd == "server_btn" then -- 本服
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.battle_item:get_map_permissions(ServerEnum.MAP_FLAG.PK_SERVER) then
			self.battle_item:set_pk_mode_c2c(ServerEnum.PK_MODE.SERVER)
		else
			gf_message_tips(gf_localize_string("当前地图不能设置此模式"))
		end

	elseif cmd == "all_btn" then -- 全服
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.battle_item:get_map_permissions(ServerEnum.MAP_FLAG.PK_WORLD) then
			self.battle_item:set_pk_mode_c2c(ServerEnum.PK_MODE.WORLD)
		else
			gf_message_tips(gf_localize_string("当前地图不能设置此模式"))
		end
	end

	self:dispose()
end

function PkModeView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "StartRestR") then -- 开始打坐
			if msg.err == 0 then
				self:dispose()
			end
		end
	end
end

-- 释放资源
function PkModeView:dispose()
	Net:receive(true, ClientProto.HideOrShowTaskPanel)
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

return PkModeView

