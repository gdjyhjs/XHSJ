--[[--
-- 军团创建
-- @Author:Seven
-- @DateTime:2017-06-20 09:19:29
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commom_string = 
{
	[1] = gf_localize_string("名字中含有敏感词汇，请重新输入"),
}

local CreateLegionView=class(UIBase,function(self,item_obj)
	self.icon_list_visible = false
	self.icon_index = 1 -- 选中icon
	self.select_lv = 1 -- 选中等级

    UIBase._ctor(self, "create_legion.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function CreateLegionView:on_asset_load(key,asset)
	self:init_ui()
	self:change_level(1)
end

function CreateLegionView:init_ui()

	-- 消耗费用
	self.cost_txt = self.items.create_cost_txt:GetComponent("UnityEngine.UI.Text")
	self.cost_txt.text = ConfigMgr:get_config("t_misc").alliance.buildCost1

	self.refer:Get(7).text = ""

	-- 输入框(宗旨)
	self.inputfield1 = self.refer:Get("InputField1")

	-- 输入框(军团名字)
	self.inputfield2 = self.refer:Get("InputField2")

	self.pre_flag = math.random(1,5)

	gf_setImageTexture(self.refer:Get(6), dataUse.getFlagByColor(self.pre_flag))

	self:init_page_view()
end


function CreateLegionView:init_page_view(index)
	self.scroll_page = self.refer:Get(4)
	self.scroll_page.onItemRender = handler(self, self.on_item_render)
	self.scroll_page.onPageChangedFn = handler(self, self.on_page_change_fn)
	self.scroll_page.OnPageChanged = handler(self, self.on_page_change)

	local teamCopy = ConfigMgr:get_config("alliance_flag")
	self.scroll_page.data = teamCopy
	self.scroll_page:SetPage(#teamCopy)

	self.c_page = 1
	self.max_page = #teamCopy
end

function CreateLegionView:on_item_render( item, cur_index, page, data )
	gf_print_table(data,"wrd data：")
	local icon = item:GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(icon,data.icon)
end
function CreateLegionView:on_page_change(page)
end
function CreateLegionView:on_page_change_fn(page)
	print("on_page_change_fn:",page)
	self.c_page = page + 1
	self.icon_index = ConfigMgr:get_config("alliance_flag")[self.c_page].code
end
function CreateLegionView:page_move(page)
	print("wtf page:",self.c_page,page)
	local c_page = self.c_page
	self.c_page = self.c_page + page
	self.c_page = self.c_page <= 1 and 1 or self.c_page
	self.c_page = self.c_page >= self.max_page and self.max_page or self.c_page
	if c_page == self.c_page then
		return
	end
	print("self.c_page:",self.c_page)
	self.scroll_page:RefreshPage(self.c_page,true)
end
-- 设置加军团图标选中显示
function CreateLegionView:set_icon_list_visible( visible )
	self.icon_list_visible = visible
	self.items.legion_icon_list:SetActive(self.icon_list_visible)
end

function CreateLegionView:change_level( level )
	self.select_lv = level

	self.items.gold_icon:SetActive(level == 2)
	self.items.coin_icon:SetActive(level == 1)
	self.cost_txt.text = ConfigMgr:get_config("t_misc").alliance["buildCost"..level]
end

function CreateLegionView:create_legion()
	local _,_,length = gf_string_to_chars(self.inputfield2.text)
	if length < 4 or length > 10 then
		LuaItemManager:get_item_obejct("cCMP"):add_message(gf_localize_string("名字长度不对，请输入2-5个汉字"))
		return
	elseif checkChar(self.inputfield2.text or "") then
		gf_message_tips(commom_string[1])
		return 

	end

	local game = LuaItemManager:get_item_obejct("game")

	local money = game:get_coin()
	if self.select_lv == 2 then
		money = game:get_gold()
	end

	if money < ConfigMgr:get_config("t_misc").alliance["buildCost"..self.select_lv] then
		LuaItemManager:get_item_obejct("cCMP"):add_message(gf_localize_string("金钱不足"))
		return
	end

	self.item_obj:build_c2s(self.inputfield2.text, self.icon_index, self.select_lv,self.inputfield1.text)
end

function CreateLegionView:on_receive( msg, id1, id2, sid )

end

function CreateLegionView:legion_flag_change()
end

function CreateLegionView:on_click( obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if cmd == "create_legion_btn" then -- 创建军团
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:create_legion()

	elseif cmd == "change_icon_btn" then -- 更换徽章
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:set_icon_list_visible(not self.icon_list_visible)

	elseif cmd == "legion_btn_1" then -- 军团icon
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.icon_index = 1

	elseif cmd == "legion_btn_2" then -- 军团icon
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.icon_index = 2

	elseif cmd == "legion_btn_3" then -- 军团icon
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.icon_index = 3

	elseif cmd == "toggle_1" then -- 等级1
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:change_level(1)

	elseif cmd == "toggle_2" then -- 等级2
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:change_level(2)

	elseif cmd == "change_icon_btn_left" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:page_move(-1)

    elseif cmd == "change_icon_btn_right" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:page_move(1)

    elseif cmd == "legion_flag" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:legion_flag_change()

	end
end

function CreateLegionView:on_input_field_value_end(sender)
	print("on_input_field_value_end",sender.name)
	if sender.name == "legion_flag" then
		
	end
	
end

function CreateLegionView:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function CreateLegionView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return CreateLegionView

