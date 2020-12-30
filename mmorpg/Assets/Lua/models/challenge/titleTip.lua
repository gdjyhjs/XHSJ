--[[
	称号界面
	create at 17.7.18
	by xin
]]
local LuaHelper = LuaHelper
local Enum = require("enum.enum")

local res = 
{
	[1] = "fuben_title_tip1.u3d",
	[2] = "fuben_title_tip2.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local titleTip = class(UIBase,function(self,title_id)
	self.title_id = title_id
	self.title_info = ConfigMgr:get_config("title")[self.title_id]
	local item_obj = LuaItemManager:get_item_obejct("challenge")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[self.title_info.category], item_obj)
end)


--资源加载完成
function titleTip:on_asset_load(key,asset)
    self:init_ui()
end

function titleTip:init_ui()
	local title_info = self.title_info
	
	--名字 (称号大类(1-文字,2-静态图片,3-动态图片))
	local str = "<color=%s>%s</color>"

	if title_info.category == 1 then
		local color = gf_get_color(title_info.color_limit)
		self.refer:Get(4).text = string.format(str,color,title_info.name) 
			

	elseif title_info.category == 2 then
		gf_setImageTexture(self.refer:Get(3), title_info.icon)
		

	elseif title_info.category == 3 then


	end

	--属性
	local attribute = title_info.attribute
	local pnode = self.refer:Get(5)
	for i=1,4 do
		local pt = pnode.transform:FindChild("p"..i)
		pt.gameObject:SetActive(false)
	end
	for i,v in ipairs(attribute or {}) do
		local pt = pnode.transform:FindChild("p"..i)
		pt.gameObject:SetActive(true)
		local ptext = pt:GetComponent("UnityEngine.UI.Text")
		ptext.text = string.format("%s +%d",ConfigMgr:get_config("propertyname")[v[1]].name,v[2])
	end

	--来源
	self.refer:Get(6).text = title_info.condition
end


--鼠标单击事件
function titleTip:on_click( obj, arg)
	print("titleTip click")
    local event_name = obj.name
    if event_name == "ui_mask" then 
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()

    end
end

-- 释放资源
function titleTip:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function titleTip:on_receive( msg, id1, id2, sid )
end

return titleTip