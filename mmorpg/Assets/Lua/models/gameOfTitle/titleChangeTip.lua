--[[--
--称号改变
-- @Author:Seven
-- @DateTime:2017-06-21 10:18:44
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local TitleChangeTip=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "title_change_tip.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function TitleChangeTip:on_asset_load(key,asset)
	if self.item_obj.title_change_state then
		self.refer:Get("txt_top").text=gf_localize_string("哇，你又变强了，获得新称号！")

	else
		self.refer:Get("txt_top").text=gf_localize_string("坏消息，你被超车了~")
		
	end
	self:register()
	local title1 = ConfigMgr:get_config("title")[self.item_obj.title_upgrade1]
	if title1.category == 1 then --显示文字
		self.refer:Get(1).gameObject:SetActive(true)
		self.refer:Get(1).text =  "<color=".. ConfigMgr:get_config("color")[title1.color_limit].color ..">"..title1.name.."</color>"
	elseif title1.category == 2 then --显示静态图片
		gf_setImageTexture(self.refer:Get(2),title1.icon)
		self.refer:Get(2).gameObject:SetActive(true)
	elseif title1.category == 3 then --显示动态图片
		self.refer:Get(3):SetActive(true)

	end
	local title2 = ConfigMgr:get_config("title")[self.item_obj.title_upgrade2]
	if title2.category == 1 then --显示文字
		self.refer:Get(4).gameObject:SetActive(true)
		self.refer:Get(4).text = "<color=".. ConfigMgr:get_config("color")[title2.color_limit].color ..">"..title2.name.."</color>"
	elseif title2.category == 2 then --显示静态图片
		gf_setImageTexture(self.refer:Get(5),title2.icon)
		self.refer:Get(5).gameObject:SetActive(true)
	elseif title2.category == 3 then --显示动态图片
		self.refer:Get(6):SetActive(true)
	end
end

function TitleChangeTip:register()
	StateManager:register_view( self )
end

function TitleChangeTip:cancel_register()
	StateManager:remove_register_view( self )
end

function TitleChangeTip:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_change_title" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "title_mask" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

-- 释放资源
function TitleChangeTip:dispose()
	self:cancel_register()
    self._base.dispose(self)
 end

return TitleChangeTip

