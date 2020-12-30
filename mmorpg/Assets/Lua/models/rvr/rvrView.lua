--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 09:57:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local RvrView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "rvr.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function RvrView:on_asset_load(key,asset)
	self:init_ui()
end

function RvrView:init_ui()
	
end

function RvrView:on_click( item_obj, obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "integral_shop_btn" then -- 兑换商店
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_open_model(ClientEnum.MODULE_TYPE.MALL,nil,nil,gf_get_config_const("shop_honor_type"))
		self.item_obj:on_blur()
		
	elseif cmd == "battle_record_btn" then -- 战场记录
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		View("rvrStatisticsView", item_obj)

	elseif cmd == "enter_battle_btn" then -- 进入战场
		Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN) -- 进入副本/挑战按钮点击音效
		LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(self.item_obj:get_id())

	elseif cmd == "close_btn" then -- 关闭
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self.item_obj:on_blur()

	elseif cmd == "help_btn" then -- 帮助
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1061)
	end
end

function RvrView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function RvrView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function RvrView:on_showed()
	self:register()
end

function RvrView:on_hided( )
	self:cancel_register()
end

-- 释放资源
function RvrView:dispose()
	
	self:cancel_register()
    self._base.dispose(self)
end

return RvrView

