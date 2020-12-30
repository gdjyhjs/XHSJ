--[[--
-- 军团基础架构界面
-- @Author:Seven
-- @DateTime:2017-06-19 20:44:23
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local LegionBaseView=class(Asset,function(self,item_obj)
    self.item_obj=item_obj
    self.view_list = {}
    self:set_bg_visible(true)
    Asset._ctor(self, "legion_base.u3d") -- 资源名字全部是小写
end)

local TextColor = 
{
	[1] = UnityEngine.Color(136/255, 109/255, 92/255,1), -- 在线
	[2] = UnityEngine.Color(148/255, 148/255, 148/255,1), -- 离线
}

-- 资源加载完成
function LegionBaseView:on_asset_load(key,asset)
	
	self:hide_mainui(true)
	self:hide_mainui()
	self:init_ui()
	gf_set_to_top_layer(self.root)
end

function LegionBaseView:init_ui()

	self.page_mgr = PageMgr(self.refer:Get("yeqian"))

	
	self:select_page(1)
end

function LegionBaseView:select_page( page )
	if not self.page_mgr then
		return
	end
	
	self.page_mgr:select_page(page)
	if self.page_mgr:get_last_page() and self.view_list[self.page_mgr:get_last_page()] then
		self.view_list[self.page_mgr:get_last_page()]:hide()
		self.view_list[self.page_mgr:get_last_page()]:clear_sub_view()
		
	end

	if not self.view_list[page] or not self.view_list[page].root then
		if page == 1 then -- 信息
			self.view_list[page] = self:create_sub_view("legionView")

		elseif page == 2 then -- 管理
			self.view_list[page] = self:create_sub_view("legionApplyView")

		elseif page == 3 then -- 活动
			self.view_list[page] = self:create_sub_view("legionActivityView")

		-- elseif page == 4 then -- 福利
		-- 	self.view_list[page] = self:create_sub_view("legionWarehouseView")

		end
	else
		self.view_list[page]:show()
	end
end

function LegionBaseView:create_sub_view( name, ... )
	local view = require("models.legion."..name)(self.item_obj, ...)
	self:add_child(view)
	return view
end

function LegionBaseView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "QuitR") then
			if msg.err == 0 then
				self.item_obj:remove_from_state()
			end
		elseif id2 == Net:get_id2("alliance", "accept_legion_task_c2s") then
			if msg.err == 0 then
				self.item_obj:remove_from_state()
			end
		elseif id2 == Net:get_id2("alliance", "AllianceAcceptRepeatTaskR") then
			if msg.err == 0 then
				self.item_obj:remove_from_state()
			end
		end
	end
end

function LegionBaseView:on_click( item_obj, obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if string.find(cmd, "page") then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
		self:select_page(arg.transform:GetSiblingIndex()+1)

	elseif cmd == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self.item_obj:remove_from_state()
	end
end

function LegionBaseView:register()
	self.item_obj:register_event("on_clict", handler(self, self.on_click))
end

function LegionBaseView:cancel_register()
	self.item_obj:register_event("on_clict", nil)
end

function LegionBaseView:show()
	LegionBaseView._base.show(self, true)
end

function LegionBaseView:on_showed()
	print("·LegionBaseView on show")
	self:register()
	if self:is_loaded() then
		local page = gf_getItemObject("legion"):get_param() or 1
		print("wtf page:",page)		
		gf_getItemObject("legion"):set_param()
		self:select_page(page or 1)
	end
end

function LegionBaseView:on_hided()
	self:cancel_register()
end

function LegionBaseView:clear()
	self.page_mgr = nil
end

-- 释放资源
function LegionBaseView:dispose()
	self:clear()
	self:cancel_register()
    self._base.dispose(self)
end

return LegionBaseView

