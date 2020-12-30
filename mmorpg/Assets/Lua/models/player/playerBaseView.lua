--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-05 19:40:43
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")
local Player = LuaItemManager:get_item_obejct("player")

local PlayerBaseView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
    Asset._ctor(self, "player_base_ui.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self.init = false
    self.view_list = {}
end)

-- 资源加载完成
function PlayerBaseView:on_asset_load(key,asset)
	-- self:hide_mainui()
	self:init_ui()
	self.init = true
	self:show()
end

function PlayerBaseView:init_ui()
	-- 标题
	self.title = LuaHelper.FindChildComponent(self.root, "viewTitle", "UnityEngine.UI.Text")
	self.view_list = {}
	self.page_mgr = PageMgr(LuaHelper.FindChild(self.root, "page"))
	self.page = self.refer:Get("page")
	local data =  LuaItemManager:get_item_obejct("functionUnlock"):get_page_tb(ClientEnum.MAIN_UI_BTN.HEAD)
	for k,v in pairs(data or {}) do
		if v==1 then
			self.page:Get(k):SetActive(true)
		else
			self.page:Get(k):SetActive(false)
		end
	end
end

function PlayerBaseView:register()
    self.item_obj:register_event("on_clict", handler(self, self.on_click))
end

function PlayerBaseView:select_page( page )
	if not self.page_mgr then
		return
	end
	self.page_mgr:select_page(page)
	if self.page_mgr:get_last_page() and self.view_list[self.page_mgr:get_last_page()] then
		self.view_list[self.page_mgr:get_last_page()]:hide()
	end
	if not self.view_list[page] then
		if page == 1 then -- 玩家信息
			self.view_list[page] = View("playerView", self.item_obj)
			self:add_child(self.view_list[page])
		elseif page == 2 then -- 技能
			local item = LuaItemManager:get_item_obejct("skill")
			item:add_to_state()
			self.view_list[page] = item
			self:add_child(item.assets[1])
		elseif page == 3 then --天命
			local item = LuaItemManager:get_item_obejct("destiny")
			item:add_to_state()
			self.view_list[page] = item
			self:add_child(item.assets[1])
		elseif page == 4 then --官职
			local item = LuaItemManager:get_item_obejct("officerPosition")
			item:add_to_state()
			self.view_list[page] = item
			self:add_child(item.assets[1])
		elseif page == 5 then --称号
			local item = LuaItemManager:get_item_obejct("gameOfTitle")
			item:add_to_state()
			self.view_list[page] = item
			self:add_child(item.assets[1])
		end
	else
		self.view_list[page]:show()
	end
end
--更新红点
function PlayerBaseView:updata_page_redpoint()

	-- 根据变强通知设置红点start
    if self.page_mgr then
	    for i,obj in ipairs(self.page_mgr.page_list or {}) do
	        local show = (function()
	                    for k,v in pairs(self.item_obj.red_pos) do
	                        if v and tonumber(string.sub(k,1,1)) == i then
	                            return true
	                        end
	                    end
	                end)()
			if obj.red_point then
	        	obj.red_point:SetActive(show or false)
	        end
	    end
    end
	-- 根据变强通知设置红点end

	print("官职红点")
	if	LuaItemManager:get_item_obejct("officerPosition"):is_award() then
		self.refer:Get(1):SetActive(true)
	else
		self.refer:Get(1):SetActive(false)
	end
	if  LuaItemManager:get_item_obejct("gameOfTitle"):is_redpoint() then
		self.refer:Get(2):SetActive(true)
	else
		self.refer:Get(2):SetActive(false)
	end
end

function PlayerBaseView:on_receive(msg,id1,id2,sid)
	if id1 ==  ClientProto.UIRedPoint then
		if msg.module == ClientEnum.MODULE_TYPE.PLAYER_INFO then
			self:updata_page_redpoint()
		end
	end
end
function PlayerBaseView:show()
	PlayerBaseView._base.show(self, true)
end

function PlayerBaseView:on_showed()
	if self.init then
		self:updata_page_redpoint()

		
        local unlock_list = LuaItemManager:get_item_obejct("functionUnlock"):get_page_tb(ClientEnum.MAIN_UI_BTN.HEAD) or {}
        local page = self.item_obj.base_page
		self.item_obj.base_page = nil
        if not page then
            for i,v in ipairs(unlock_list) do
                if v~=0 then
                    page = i
                    break
                end
            end
        end
        if not page then
            page = 1
        elseif page == 2 then
        	LuaItemManager:get_item_obejct("skill"):open_skill(self.item_obj.page2,self.item_obj.page3)
        end
        if unlock_list[page] == 0 then
            gf_message_tips("功能未开启")
            self:hide()
            return
        end
        for i,v in ipairs(self.page_mgr.page_list) do
            v.btn.gameObject:SetActive(unlock_list[i]~=0)
        end
		
		self:select_page(page)
		self:register()
	end
end

function PlayerBaseView:on_hided()
	self.item_obj:register_event("on_clict", nil)
end

function PlayerBaseView:on_click( item_obj, obj, arg )
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""

	if string.find(cmd, "page") then
		Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
		self:select_page(arg.transform:GetSiblingIndex()+1)

	elseif cmd == "playerCloseBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "chengHaoinput" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("gameOfTitle"):add_to_state()
	end
end

-- 释放资源
function PlayerBaseView:dispose()
	-- self:hide()
	for k,v in pairs(self.view_list) do
		v:dispose()
	end
	self.view_list = {}
	self.init = false
	self.item_obj:register_event("on_clict", nil)
    self._base.dispose(self)
end

return PlayerBaseView

