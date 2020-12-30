--[[--
--称号过期
-- @Author:Seven
-- @DateTime:2017-06-21 10:02:19
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local TitleExpiredTip=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "title_expired_tip.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function TitleExpiredTip:on_asset_load(key,asset)
	local title = ConfigMgr:get_config("title")[self.item_obj.overdue_title]
	if title.category == 1 then --显示文字
		self.refer:Get(1).gameObject:SetActive(true)
		self.refer:Get(1).text = "<color=".. ConfigMgr:get_config("color")[title.color_limit].color ..">"..title.name.."</color>"
	elseif title.category == 2 then --显示静态图片
		gf_setImageTexture(self.refer:Get(2),title.icon)
		self.refer:Get(2).gameObject:SetActive(true)
	elseif title.category == 3 then --显示动态图片
		self.refer:Get(3):SetActive(true)
	end
	self:register()
end

function TitleExpiredTip:register()
	StateManager:register_view( self )
end

function TitleExpiredTip:cancel_register()
	StateManager:remove_register_view( self )
end

function TitleExpiredTip:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_title_expired" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "title_mask" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

-- 释放资源
function TitleExpiredTip:dispose()
	self:cancel_register()
    self._base.dispose(self)
 end

return TitleExpiredTip

