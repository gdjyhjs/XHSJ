--[[--
--获取称号
-- @Author:Seven
-- @DateTime:2017-06-21 09:48:32
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local GetTitle=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "get_title.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function GetTitle:on_asset_load(key,asset)
	self.title_amount = 0
	self:init_title_id()
	self:init_ui()
	self:register()
end

function GetTitle:init_ui()
	local title = ConfigMgr:get_config("title")[self.current_title]
	print("称号获得",self.current_title)
	if title.category == 1 then --显示文字
		self.refer:Get(1).gameObject:SetActive(true)
		self.refer:Get(1).text =  "<color=".. ConfigMgr:get_config("color")[title.color_limit].color ..">"..title.name.."</color>"
	elseif title.category == 2 then --显示静态图片
		gf_setImageTexture(self.refer:Get(2),title.icon)
		self.refer:Get(2).gameObject:SetActive(true)
	elseif title.category == 3 then --显示动态图片
		self.refer:Get(3):SetActive(true)
	end
end

function GetTitle:init_title_id()
	local tb = self.item_obj.get_titles_list
	if #tb == 0 or self.title_amount == #tb then
		self:dispose()
	end
	self.title_amount=self.title_amount+1
	self.current_title = tb[self.title_amount]
end

function GetTitle:register()
	StateManager:register_view( self )
end

function GetTitle:cancel_register()
	StateManager:remove_register_view( self )
end

function GetTitle:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "bgBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:init_title_id()
	elseif cmd == "useBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:take_on_title_c2s(self.current_title) --装备称号
		self.item_obj.show_get_title=false
		self:init_title_id()
	elseif cmd == "title_close_Btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

-- 释放资源
function GetTitle:dispose()
	self:cancel_register()
    self._base.dispose(self)
 end

return GetTitle

