--主界面特效层

local res = 
{
	[1] = "mainui_effect.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local mainuiEffect = class(UIBase,function(self,main_ui)
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj

	self.main_ui = main_ui

	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function mainuiEffect:on_asset_load(key,asset)
    self:init_ui()
end

function mainuiEffect:init_ui()
end

--离开副本特效
function mainuiEffect:show_leave_effect(isshow)
	print("wtf show effect :",isshow)
	self.refer:Get(1):SetActive(isshow)
	if isshow then 
		local ps = self.main_ui.refer:Get(2):Get("leaveBtn").transform.position
		local opos = self.refer:Get(1).transform.position
		self.refer:Get(1).transform.position = Vector3(opos.x,ps.y,opos.z)
		local ps1 = self.refer:Get(1).transform.position
	end
end

function mainuiEffect:show_main_text_effect(text)
	if not text or text == "" then
		self.refer:Get(2).gameObject:SetActive(false)
		return
	end
	self.refer:Get(2).gameObject:SetActive(true)
	self.refer:Get(2).text = text
end

function mainuiEffect:on_showed()
	StateManager:register_view(self)
end

function mainuiEffect:clear()
	StateManager:remove_register_view(self)
end

function mainuiEffect:on_hided()
	self:clear()
end
-- 释放资源
function mainuiEffect:dispose()
	self:clear()
    self._base.dispose(self)
end

function mainuiEffect:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.CopyExitButtonEffect then
		self:show_leave_effect(msg.visible)

	elseif id1 == ClientProto.MainUiTextEffect then
		self:show_main_text_effect(msg.text)

	end
end

return mainuiEffect