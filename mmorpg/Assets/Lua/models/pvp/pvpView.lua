--[[
	pvp系统主界面
	create at 17.8.1
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local model_name = "pvp"

local res = 
{
	[1] = "pvp_common.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}
local tag_texture =   
{  
	[1] = {"arena_page_01_select","arena_page_01_normal"},
	[2] = {"arena_page_02_select","arena_page_02_normal"},
	[3] = {"arena_page_03_select","arena_page_03_normal"},
}

local func = 
{
	[1] = "challenge",
	[2] = "challenge",
	[3] = "rankList",
}

local pvpView=class(Asset,function(self,item_obj)
	self.item_obj=item_obj
	self:set_bg_visible(true)
  	Asset._ctor(self, res[1]) -- 资源名字全部是小写
end)


--资源加载完成
function pvpView:on_asset_load(key,asset)
	
	self.item_obj:register_event("pvp_view_on_click", handler(self, self.on_click))
     gf_set_to_top_layer(self.root)
end

function pvpView:init_ui()
	self:page_click("pvp_page1", self.refer:Get(1))
end


function pvpView:page_click(event_name,button)
	local index = string.gsub(event_name,"pvp_page","")
	
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

function pvpView:func_call(index)
	print("wtf index:",index)
	local func_name = func[index]
	
	self.last_view = require("models.pvp."..func_name)(index)

	self:add_child(self.last_view) 
	-- self.last_view = self:create_sub_view("models.pvp."..func_name)

end

--鼠标单击事件
function pvpView:on_click(item_obj, obj, arg)
    local event_name = obj.name
    
    if event_name == "closeArenaBtn" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self.last_view:hide()
    	self:hide()

    elseif string.find(event_name,"pvp_page") then
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
    	self:page_click(event_name, arg)

    end

end

function pvpView:clear()
	self.last_view = nil
	self.last_button = nil
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function pvpView:dispose()
	self:clear()
    self._base.dispose(self)
end

function pvpView:on_showed()
	self:init_ui()
end


function pvpView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "") then
		end
	end
end

return pvpView