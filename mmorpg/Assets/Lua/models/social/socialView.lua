--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 17:59:56
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local SocialView=class(Asset,function(self,item_obj)
	self:set_bg_visible( true )
    Asset._ctor(self, "social.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function SocialView:on_asset_load(key,asset)
    self:hide_mainui()
    self.page_mgr = PageMgr(self.refer:Get("yeqian"))
    self.view_list = {}

    self.init = true
    self:show()
    gf_set_to_top_layer(self.root)
end

function SocialView:init_ui()
    local unlock_list = LuaItemManager:get_item_obejct("functionUnlock"):get_page_tb(ClientEnum.MAIN_UI_BTN.MAIL) or {}
    local page = self.item_obj.open_page 
    	or (self.item_obj:is_have_red_point() and unlock_list[1]~=0 and 1) -- 好友有红点吗？并且已经且所好友
    	or (LuaItemManager:get_item_obejct("email"):is_have_red_point() and unlock_list[2]~=0 and 2) -- 邮件有红点吗？并且已经解锁邮件
    self.item_obj.open_page = nil
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
    end
    if unlock_list[page] == 0 then
        gf_message_tips("功能未开启")
        self:hide()
        return
    end
    for i,v in ipairs(self.page_mgr.page_list) do
        v.btn.gameObject:SetActive(unlock_list[i]~=0)
    end

	self:init_red_point()
	self:select_page(page)
	self.item_obj.open_page = nil
	self:register()
end

function SocialView:select_page( page )
	print("选择页签",page, self.last_page)
	if not self.page_mgr then
		return
	end

	self.page_mgr:select_page(page)
	if self.last_page and self.view_list[self.last_page] then
		self.view_list[self.last_page]:hide()
	end
	self.last_page = page
	if not self.view_list[page] then
		if page == 1 then -- 好友 
			self.view_list[page] = View("friend", self.item_obj)
    		self:add_child(self.view_list[page])
		elseif page == 2 then -- 邮件
			local item = LuaItemManager:get_item_obejct("email")
			item:add_to_state()
			self.view_list[page] = item
			self:add_child(item.assets[1])
		elseif page == 3 then --结婚
			local item = LuaItemManager:get_item_obejct("marriage")
			item:add_to_state()
			self.view_list[page] = item
			self:add_child(item.assets[1])
		elseif page == 4 then --结义
			local item = LuaItemManager:get_item_obejct("swornBrothers")
			item:add_to_state()
			self.view_list[page] = item
			self:add_child(item.assets[1])
		end
	else
		self.view_list[page]:show()
	end
end

function SocialView:on_click(item_obj,obj,arg)
    print("点击SocialView:on_click",obj,arg)

    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "closeSocialBtn" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
        self:hide()
    elseif cmd == "page" then
    	Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
        self:select_page(obj.transform:GetSiblingIndex()+1)
    end
end

--服务器返回
function SocialView:on_receive( msg, id1, id2, sid )
	 if id1 == ClientProto.ShowHotPoint then -- 红点
		self:show_red_point(2,LuaItemManager:get_item_obejct("email"):is_have_red_point())
		self:show_red_point(1 ,self.item_obj:is_have_red_point())
	end
end

function SocialView:register()
	print("注册SocialView")
    self.item_obj:register_event("social_on_click", handler(self, self.on_click))
end

function SocialView:cancel_register()
	self.item_obj:register_event("social_on_click", nil)
end

function SocialView:on_showed()
	if self.init then
		self:init_ui()
	end
end

function SocialView:on_hided()
	self:dispose()
end

-- 释放资源
function SocialView:dispose()
	self:cancel_register()
    self.init = nil
    self.itemCache = nil
    self._base.dispose(self)
end


-- 初始化红点
function SocialView:init_red_point()
    self:show_red_point(2 ,LuaItemManager:get_item_obejct("email"):is_have_red_point())
    self:show_red_point(1 ,self.item_obj:is_have_red_point())
end

--显示按钮红点 show=布尔值 显示或者隐藏，默认显示   mainui_btn_id参考 ClientEnum.MAIN_UI_BTN
function SocialView:show_red_point(page_index,show)
    local page = self.page_mgr.page_list[page_index]
    if page then
        if show==nil then show=true end
        local red_point =  LuaHelper.FindChild(page.btn.gameObject,"red_point")
        if red_point then
            red_point:SetActive(show)
        end
    end
end

return SocialView