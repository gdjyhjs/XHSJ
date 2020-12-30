--[[--
--
-- @Author:Seven
-- @DateTime:2017-08-17 14:10:34
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local CopyEnter=class(UIBase,function(self,item_obj,data)
	self.data = data
    UIBase._ctor(self, "mainui_copy_enter.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function CopyEnter:on_asset_load(key,asset)
	StateManager:register_view( self )
	self:init_ui()
end

function CopyEnter:init_ui()
	self.refer:Get("name").text = ConfigMgr:get_config("copy")[self.data.code].name
	self.refer:Get("content").text = self.data.des or ""
end

function CopyEnter:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "enter_btn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        local tb =  ConfigMgr:get_config("story_copy")[self.data.code]
        if tb and LuaItemManager:get_item_obejct("game"):get_strenght() < tb.strength then
			gf_getItemObject("copy"):power_add()
			gf_message_tips(gf_localize_string("体力不足"))
		else
			-- if LuaItemManager:get_item_obejct("game"):get_strenght_buy_count then
			LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(self.data.code)
		end
		self:dispose()
	elseif cmd == "copy_enter_colse_btn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end
function CopyEnter:on_receive( msg, id1, id2, sid )
	if id1 ==  ClientProto.AutoDotask then 
		if not msg then
			LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(self.data.code)
			Net:receive(true, ClientProto.AutoDotask)
			self:dispose()
		end
	end
end

-- 释放资源
function CopyEnter:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
end

return CopyEnter

