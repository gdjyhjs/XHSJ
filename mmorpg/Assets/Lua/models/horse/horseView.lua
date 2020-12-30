--[[
	坐骑common界面  属性
	create at 17.6.19
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local model_name = "horse"

local res = 
{
	[1] = "horse_common.u3d",
}

local commom_string = 
{
}

local color_text = 
{
	group = {[1] = gf_localize_string("<color=#A01010FF>进阶</color>"),[2] = gf_localize_string("<color=#4E3922FF>进阶</color>"),},
	magic = {[1] = gf_localize_string("<color=#A01010FF>幻化</color>"),[2] = gf_localize_string("<color=#4E3922FF>幻化</color>"),},
	feed  = {[1] = gf_localize_string("<color=#A01010FF>喂养</color>"),[2] = gf_localize_string("<color=#4E3922FF>喂养</color>"),},
	equip = {[1] = gf_localize_string("<color=#A01010FF>装备</color>"),[2] = gf_localize_string("<color=#4E3922FF>装备</color>"),},
}

local tag_texture =  
{  
	["group"] = {"horse_page_01_select","horse_page_01_normal"},
	["magic"] = {"horse_page_02_select","horse_page_02_normal"},
	["feed"]  = {"horse_page_03_select","horse_page_03_normal"},
	["equip"] = {"horse_page_04_select","horse_page_04_normal"},
}

local button_tag = 
{
	["horse_commont_group"] = 1,
	["horse_commont_feed"] = 2,
	["horse_commont_magic"] = 3,
}
local button_tag_str = 
{
	"horse_commont_group","horse_commont_feed","horse_commont_magic",
}
local horseView=class(Asset,function(self,item_obj) 
	self.item_obj=item_obj
	self:set_bg_visible(true)
  	Asset._ctor(self, res[1]) -- 资源名字全部是小写
end)


--资源加载完成
function horseView:on_asset_load(key,asset)
	print("horseView on load")
	self:hide_mainui(true)
	gf_set_to_top_layer(self.root)
	self:set_always_receive(true)
	self.item_obj:register_event("horse_view_on_click", handler(self, self.on_click))
end

function horseView:init_ui()
	local page_index = unpack(gf_getItemObject("horse"):get_param()) or 1
	self:pageClick(button_tag_str[page_index] or "horse_commont_group",self.refer:Get(page_index))
end


function horseView:pageClick(event_name,button)
	local event_name = string.gsub(event_name,"horse_commont_","")
	
	self:remove_children()

	if self.last_button then 
		print("is last")
		-- self.last_button.transform:FindChild("normalText"):GetComponent("UnityEngine.UI.Text").text = color_text[self.last_name][2]
		self.last_button.interactable = true
		local icon = self.last_button.gameObject.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon, tag_texture[self.last_name][2])
	end

	button.interactable = false
	-- button.transform:FindChild("normalText"):GetComponent("UnityEngine.UI.Text").text = color_text[event_name][1]
	local icon = button.gameObject.transform:FindChild("normalIcon"):GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(icon, tag_texture[event_name][1])

	self.last_button = button
	self.last_name = event_name

	if event_name == "equip" then
		return
	end

	local arg1,arg2,arg3 = unpack(gf_getItemObject("horse"):get_param())

	self.last_view = require("models.horse."..event_name)(arg2,arg3)

	self:add_child(self.last_view)

	gf_getItemObject("horse"):set_param()
	
end

--鼠标单击事件
function horseView:on_click(item_obj, obj, arg)
    local eventName = obj.name
    print("horseView click ",eventName)

    if eventName == "horse_commont_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

    elseif string.find(eventName,"horse_commont") then
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
    	self:pageClick(eventName,arg)	

    end
end

function horseView:clear()
	self.last_button = nil
	self.last_view = nil
	self.last_name = nil
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function horseView:dispose()
	self:clear()
    self._base.dispose(self)
end

function horseView:on_showed()
	if self.pre_show then
		self.pre_show = false
		return
	end
	self:init_ui()
end

function horseView:on_hided()
end


function horseView:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.HorseGoToGroup then
		self:pageClick("horse_commont_group",self.refer:Get(1))
	end
	if(id1 == Net:get_id1(model_name))then
        if id2 == Net:get_id2(model_name,"HorseR") then
        	--如果是显示状态
        	self.is_horse_show = true
        	self:set_always_receive(true)
        	self:set_visible(false)
        	-- self.last_view:set_visible(false)

        	--设置不被自动回收
        	self.level = UIMgr.LEVEL_STATIC
        end
    end
    if id1 == ClientProto.HorseShowState then
    	if not self.is_horse_show then
    		return
    	end
    	self:set_always_receive(false)
    	self.pre_show = true
        self:set_visible(true)
        self.is_horse_show = false
    	--设置可以被自动回收
    	self.level = UIMgr.LEVEL_0
    end

end

return horseView