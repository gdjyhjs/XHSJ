--[[ 废弃
	武将系统主界面
	create at 17.8.1
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local model_name = "pvp"

local res = 
{
	[1] = "hero_common.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}
local tag_texture =   
{  
	[1] = {"wujiang_page_01_select","wujiang_page_01_normal"},
	[2] = {"wujiang_page_02_select","wujiang_page_02_normal"},
	[3] = {"wujiang_page_03_select","wujiang_page_03_normal"}, 
	[4] = {"bag_icon_01_select","bag_icon_01_normal"},
}

local func = 
{
	[1] = "heroProperty",
	[2] = "heroIllustration",
	[3] = "heroFront",
}

local heroCommon = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj

	self.item_obj:register_event("hero_view_on_click", handler(self, self.on_click))

	UIBase._ctor(self, res[1], item_obj,1)
end)



--资源加载完成
function heroCommon:on_asset_load(key,asset)
	
end

function heroCommon:init_ui()
	self:page_click("page1", self.refer:Get(1))
end


function heroCommon:page_click(event_name,button)
	local index = string.gsub(event_name,"page","")
	
	index = tonumber(index)

	if self.last_view then
		self.last_view:hide()
	end
	if self.last_button then 
		print("last button")
		
		self.last_button.interactable = true
		local icon = self.last_button.gameObject.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, tag_texture[self.last_index][2])
	end

	button.interactable = false
	local icon = button.gameObject.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(icon, tag_texture[index][1])

	self.last_button = button
	self.last_index = index

	self:func_call(index)
		
end

function heroCommon:func_call(index)
	print("wtf index:",index)
	local func_name = func[index]
	self.last_view = require("models.hero."..func_name)()
end

--鼠标单击事件
function heroCommon:on_click(obj, arg)
    local event_name = obj.name
    
    if event_name == "hero_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self.last_view:hide()
    	self:hide()

    elseif string.find(event_name,"page") then
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
    	self:page_click(event_name, arg)

    end

end

function heroCommon:clear()
	self.last_view = nil
	self.last_button = nil
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function heroCommon:dispose()
	print("dispose() wtf")
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroCommon:on_showed()
	StateManager:register_view(self)
	self:init_ui()
end

function heroCommon:on_hided()
	StateManager:remove_register_view(self)
end


function heroCommon:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "") then
		end
	end
end

return heroCommon