--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 18:14:46
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local Friend=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "friend.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function Friend:on_asset_load(key,asset)
    self:hide_mainui()
    self:init_ui()
    self.init = true
    self:show()
end

function Friend:init_ui()
	self.itemCache = {}
    self.view_list = {}
    self.page_mgr = PageMgr(self.refer:Get("yeqian"))
    self:init_red_point()
end

function Friend:select_page( page )
	print("选择标签",page)
	if not self.page_mgr then
		return
	end

	self.page_mgr:select_page(page)
	if self.page_mgr:get_last_page() and self.view_list[self.page_mgr:get_last_page()] then
		self.view_list[self.page_mgr:get_last_page()]:hide()
	end
	if not self.view_list[page] then
		if page == 1 then -- 我的好友 my_friends
			self.view_list[page] = self:create_sub_view("myFriends",self)
		elseif page == 2 then -- 推荐好友 recommend_friends
			self.view_list[page] = self:create_sub_view("recommendFriends",self)
		elseif page == 3 then -- 获取体力 get_energy
			self.view_list[page] = self:create_sub_view("getEnergy",self)
		elseif page == 4 then -- 最近联系 recent_contact
			self.view_list[page] = self:create_sub_view("recentContact",self)
		elseif page == 5 then -- 好友申请 friends_apply
			self.view_list[page] = self:create_sub_view("friendsApply",self)
		elseif page == 6 then -- 我的仇人 my_enemy
			self.view_list[page] = self:create_sub_view("myEnemy",self)
		elseif page == 7 then -- 黑名单 blacklist
			self.view_list[page] = self:create_sub_view("blacklist",self)
		end
	else
		self.view_list[page]:show()
	end
end

function Friend:create_sub_view( path, ... )
    print("创建子视窗",path)
    local view = require("models.social."..path)(self.item_obj, ...)
    self:add_child(view)
    return view
end

function Friend:on_click(obj,arg)
    print("社交Friend:on_click",obj,arg)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "closeSocialBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
        self:hide()
    elseif string.find(cmd,"friendPage") then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换2级页签音效
        self:select_page(obj.transform:GetSiblingIndex()+1)
    elseif string.find(cmd,"chatBtn_") and arg then --发起私聊
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("chat"):open_private_chat_ui(tonumber(string.split(cmd,"_")[2]))
	elseif string.find(cmd,"friendTips_") then --玩家tips
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_TWO_BTN) -- 切换3级页签音效
		LuaItemManager:get_item_obejct("player"):show_player_tips(tonumber(string.split(cmd,"_")[2]))
    elseif cmd == "to_recommend_friends" then -- 到推荐好友
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:select_page(2)
    end
end

--服务器返回
function Friend:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("friend"))then
        -- gf_print_table(msg,"服务器社交系统返回")
        if(id2== Net:get_id2("friend", "StrengthListR"))then
            -- print("服务器返回：可领体力列表")
            self:show_red_point(3 ,self.item_obj.StrengthList.leftCount>0)
        elseif(id2== Net:get_id2("friend", "BeGiveR"))then
            -- print("服务器返回：可领体力列表")
            self:show_red_point(3 ,self.item_obj.StrengthList.leftCount>0)
        end

	elseif id1 == ClientProto.ShowHotPoint then -- 红点
	 	self:init_red_point()
	end
end

function Friend:register()
    print("注册Friend")
    StateManager:register_view( self )
end

function Friend:cancel_register()
	StateManager:remove_register_view( self )
end

function Friend:on_showed()
	if self.init then
		self:select_page(self.item_obj.open_item or 1)
		self:init_red_point()
        self:register()
	end
end

function Friend:on_hided()
	self:cancel_register()
end

function Friend:get_item(key,obj,root)
    print("获取item",key,obj,root)
    if not self.itemCache[key] then self.itemCache[key] = {} end
    local item = self.itemCache[key][1]
    if item then
        table.remove(self.itemCache[key],1)
    else
        item = LuaHelper.Instantiate(obj)
    end
    item:SetActive(true)
    item.transform:SetParent(root.transform,false)
    return item
end

function Friend:repay_item(key,item)
	print("返还item",key,item)
    item:SetActive(false)
    item.transform:SetParent(self.root.transform,false)
    self.itemCache[key][#self.itemCache[key]+1] = item
end

-- 释放资源
function Friend:dispose()
    self.init = nil
    self:cancel_register()
    self._base.dispose(self)
end

-- 初始化红点
function Friend:init_red_point()
    self:show_red_point(5 ,#self.item_obj.FriendApplyList>0)
    self:show_red_point(3 ,self.item_obj.StrengthList.leftCount>0)
end

--显示按钮红点 show=布尔值 显示或者隐藏，默认显示   mainui_btn_id参考 ClientEnum.MAIN_UI_BTN
function Friend:show_red_point(page_index,show)
    local page = self.page_mgr.page_list[page_index]
    if page then
        if show==nil then show=true end
        local red_point =  LuaHelper.FindChild(page.btn.gameObject,"red_point")
        if red_point then
            red_point:SetActive(show)
        end
    end
end

return Friend

