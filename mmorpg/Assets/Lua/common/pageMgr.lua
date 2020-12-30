--[[--
-- 也签管理
-- @Author:Seven
-- @DateTime:2017-06-05 18:05:08
--]]

local PageMgr = class(function( self, root )
	self.root = root
	self.select_color = Color(160/255, 16/255, 16/255, 1)
	self.normal_color = Color(78/255, 57/255, 34/255, 1)
	self.last_page = nil

	self:init_page()
end)

-- 设置选中字体颜色
function PageMgr:set_select_color( color )
	self.select_color = color
end

-- 普通字体颜色
function PageMgr:set_normal_color( color )
	self.normal_color = color
end

-- 获取当前也签
function PageMgr:get_cur_page()
	return self.current_page
end

-- 获取上一个也签
function PageMgr:get_last_page()
	return self.last_page
end

-- 选择页面
function PageMgr:select_page( index )

	if self.current_page then
		self:highlight_page_btn(self.page_list[self.current_page], false)
	end
	self:highlight_page_btn(self.page_list[index], true)
	
	self.last_page = self.current_page
	self.current_page = index
end

--------------------------------private-------------------------
-- 初始化页签
function PageMgr:init_page()
	-- 初始化标签按钮

	self.page_list = {}
	local foreach = function ( index, child )
		self.page_list[index+1] = {
			btn = LuaHelper.GetComponent(child, "UnityEngine.UI.Button"),
			txt = LuaHelper.GetComponentInChildren(child, "UnityEngine.UI.Text"),
			normal_img = LuaHelper.FindChild(child, "normalIcon"),
			hl_img = LuaHelper.FindChild(child, "hlIcon"),
			red_point = LuaHelper.FindChild(child, "red_point"),
		}
	end
	LuaHelper.ForeachChild(self.root, foreach)
	
	self.current_page = nil
end

function PageMgr:highlight_page_btn( data, hl )
	if not data then
		return
	end

	-- if hl then
	-- 	data.txt.color = self.select_color
	-- else
	-- 	data.txt.color = self.normal_color
	-- end

	data.btn.interactable = not hl
	if data.page then
		data.page:SetActive(hl)
	end

	if data.normal_img then
		data.normal_img:SetActive(not hl)
	end

	if data.hl_img then
		data.hl_img:SetActive(hl)
	end

	-- data.txt.text = "<color=#"..color..">"..data.txt.text.."</color>\n"

end

return PageMgr
