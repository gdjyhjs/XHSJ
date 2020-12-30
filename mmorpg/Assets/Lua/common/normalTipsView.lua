--[[--
-- 通用提示框
-- @Author:Seven
-- @DateTime:2017-05-15 19:52:47

-- config_data = {"测试","测试2"...}
--]]

local owidth,oheight = 50,30

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local NormalTipsView = class(UIBase,function(self,item_obj, config_data,width)
    self.config_data = config_data or {}
    self.width = width or self:get_str_max_len()
    UIBase._ctor(self, "normal_tips.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function NormalTipsView:on_asset_load(key,asset)
	StateManager:register_view( self )
	self:init_ui()
end

function NormalTipsView:init_ui()
	-- self.scroll_table = LuaHelper.GetComponentInChildren(self.root, "Hugula.UGUIExtend.ScrollRectTable")
	-- self.scroll_table.onItemRender = handler(self, self.update_item)

	-- local item_height = self.scroll_table.tileItem.rectTransform.rect.height

	-- self.scroll_view = LuaHelper.FindChild(self.root, "Scroll View")
	-- self.scroll_view_rt = LuaHelper.GetComponentInChildren(self.scroll_view, "UnityEngine.RectTransform")

	-- local scroll_view_h = #self.config_data*(item_height+5)+item_height
	-- if scroll_view_h > 700 then
	-- 	scroll_view_h = 700
	-- end

	if self.width > 900 then
		self.width = 900
	end

	-- self.scroll_view_rt.sizeDelta = Vector2(scroll_view_w, scroll_view_h)
	-- self.scroll_table.pageSize = #self.config_data
	-- self:refresh(self.config_data)

	local height = 0
	local c_item,p_item,b_item = self.refer:Get(1),self.refer:Get(2),self.refer:Get(3)
	p_item.transform.sizeDelta = Vector2(self.width , 0 )
	for i,v in ipairs(self.config_data or {}) do
		local text_node = LuaHelper.InstantiateLocal(c_item,p_item)
		text_node.transform.sizeDelta = Vector2(self.width , 0 )
		text_node:SetActive(true)
		local text = text_node:GetComponent("UnityEngine.UI.Text")
		text.text = v
		height = height + text.preferredHeight ----
	end
	b_item.transform.sizeDelta = Vector2(self.width + owidth, height + oheight + 5 * #self.config_data)
end

-- 获取最长的字符串长度
function NormalTipsView:get_str_max_len()
	local max_len = 0
	for k,v in pairs(self.config_data) do
		local _, len = gf_string_to_chars(v, 22)
		if len > max_len then
			max_len = len
		end
	end
	return max_len
end

function NormalTipsView:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1) --显示列表
end

function NormalTipsView:update_item(item, index, data)
	item.gameObject:SetActive(true)
	item:Get(1).text = data
end

--鼠标单击事件
function NormalTipsView:on_click(obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "bgBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end

-- 释放资源
function NormalTipsView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return NormalTipsView

