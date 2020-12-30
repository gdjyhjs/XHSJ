--[[--
--礼物回赠
-- @Author:Seven
-- @DateTime:2017-07-20 09:29:27
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local GiftReturn=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "gift_return_tip.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function GiftReturn:on_asset_load(key,asset)
	self.refer:Get("txt_player_name").text =self.item_obj.send_flower_data.name
	self.refer:Get("txt_explain").text =self.item_obj.return_txt
	StateManager:register_view(self)
end

function GiftReturn:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_close_return" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "btn_gift_return" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self.item_obj:show_view(self.item_obj.send_flower_data)
		self:dispose()
	end
end
-- 释放资源
function GiftReturn:dispose()
	self.item_obj:delay_show_effect()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return GiftReturn

