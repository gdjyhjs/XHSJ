--[[
	军团主界面  属性
	create at 17.10.31
	by xin
]]

local model_name = "alliance"
local res = 
{
	[1] = "legion_base.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}
local tag_texture =   
{  
	[1] = {"army_group_page_01_select","army_group_page_01_normal"},
	[2] = {"army_group_page_04_select","army_group_page_04_normal"},
	[3] = {"army_group_page_03_select","army_group_page_03_normal"},
	[4] = {"army_group_page_02_select","army_group_page_02_normal"},
}

local func = 
{
	[1] = "legionMain",
	[2] = "legionWelfareMain",
	[3] = "legionActivityView",
	[4] = "legionMgrView",
}

local legionCommon = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	self:set_bg_visible(true)
	UIBase._ctor(self, res[1], item_obj)
end)

--资源加载完成
function legionCommon:on_asset_load(key,asset)
	self.item_obj:get_apply_list_c2s()
end


function legionCommon:init_ui()
	local param = gf_getItemObject("legion"):get_param()
	local index = param and param[1] or 1
	self:page_click("page"..index, self.refer:Get(index))
end


function legionCommon:page_click(event_name,button)
	local index = string.gsub(event_name,"page","")
	
	index = tonumber(index)

	if self.last_view then
		self.last_view:dispose()
	end
	if self.last_button then 
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

function legionCommon:func_call(index)
	local func_name = func[index]	
	local param = gf_getItemObject("legion"):get_param() or {}
	local arg1,arg2,arg3 = param[1],param[2],param[3]
	gf_getItemObject("legion"):set_param()
	self.last_view = require("models.legion."..func_name)(arg2,arg3)--self:create_sub_view("models.hero."..func_name)
	self:add_child(self.last_view)
end

--鼠标单击事件
function legionCommon:on_click(obj, arg)
    local event_name = obj.name
    print("legionCommon:",event_name)
    if event_name == "legion_common_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:clear_pre_view()
    	self:dispose()

    elseif string.find(event_name,"page") then
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
    	self:page_click(event_name, arg)

    end

end

function legionCommon:clear_pre_view()
	if self.last_view then
		self.last_view:dispose()
		self.last_view = nil
	end
end

function legionCommon:clear()
	self.last_view = nil
	self.last_button = nil
	StateManager:remove_register_view(self)
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function legionCommon:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionCommon:on_showed()
	print("legionCommon wtf show:ffffff")
	StateManager:register_view(self)
	self:init_ui()
end

function legionCommon:on_hided()
	self:clear()
end

function legionCommon:show_red_point(btn_id,visible)
	if 	btn_id == ClientEnum.MAIN_UI_BTN.FAMILY or btn_id == ClientEnum.MAIN_UI_BTN.SWITCH then
		local can_add = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.ACCEPT_APPLY)
		if can_add then
			self.refer:Get(5):SetActive(visible)
		end
	end
end

function legionCommon:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "DissolveR") or id2 == Net:get_id2(model_name, "QuitR")  then
			self:dispose()
			
		end
	end
	if id1 == ClientProto.LegionViewClose then
		self.last_view:dispose()
		self:dispose()
	end

	if id1 == ClientProto.ShowHotPoint then
		self:show_red_point(msg.btn_id,msg.visible)
	end
end

return legionCommon