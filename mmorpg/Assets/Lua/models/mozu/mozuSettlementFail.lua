--[[--
-- 任务栏管理ui
-- @Author:xcb
-- @DateTime:2017-06-23 18:23:22
--]]
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MozuSettlementFail=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mozu")
    UIBase._ctor(self, "challenge_default.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function MozuSettlementFail:on_asset_load(key,asset)
end

function MozuSettlementFail:init_ui()
end

function MozuSettlementFail:on_click( obj, arg )
	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if cmd == "btn_RecoverPiont3" then
		--Net:send({}, "copy", "ExitCopy")
		print("MozuSettlementFail:on_click")
		gf_auto_atk( false )
		LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
		self:dispose()
	end
end

function MozuSettlementFail:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.FinishScene then
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) ~= true then
			self:dispose()
		end
	end
end

function MozuSettlementFail:register()
	StateManager:register_view( self )
end

function MozuSettlementFail:cancel_register()
	StateManager:remove_register_view( self )
end

function MozuSettlementFail:on_showed()
	self:register()
	self.click_time = Net:get_server_time_s()
end

function MozuSettlementFail:on_hided()
end

-- 释放资源
function MozuSettlementFail:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return MozuSettlementFail

