--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-21 15:35:11
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local DestinyView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "destiny_base.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)
local MODE_PATH = {
    [1] = "models.destiny.inlay", --镶嵌
    [2] = "models.destiny.resolve", --分解
    [3] = "models.destiny.hunt", --猎取
}
-- 资源加载完成
function DestinyView:on_asset_load(key,asset)
    print("天命加载完毕")
    self.view_list = {}
    self.page_mgr = PageMgr(self.refer:Get("titleRoot"))

    self.init =true
    self:show()
end

function DestinyView:select_page( page )
    print("天命选择页",page)
    if not self.page_mgr then
        return
    end

    self.page_mgr:select_page(page)
    if self.page_mgr:get_last_page() and self.view_list[self.page_mgr:get_last_page()] then
        self.view_list[self.page_mgr:get_last_page()]:hide()
    end

    if self.view_list[page] then
        self.view_list[page]:show()
    else
        self.view_list[page] = self:create_sub_view(MODE_PATH[page],self)
    end
end

function DestinyView:create_sub_view( path, ... )
    print("创建天命子视窗",path)
    local view = require(path)(self.item_obj, ...)
    self:add_child(view)
    return view
end

function DestinyView:on_click(item_obj,obj,arg)
    print("天命系统",obj,arg)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "destinyType" then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
        self:select_page(obj.transform:GetSiblingIndex()+1)
    elseif cmd == "destinyType_1" then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
        self:select_page(1)
    end
end

function DestinyView:on_showed()
    print("显示天命")
    if self.init then
        self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
        local player = LuaItemManager:get_item_obejct("player")
        self:select_page(player.page2 or 1)
        player.page2 = nil
    end
    
end

function DestinyView:on_hided()
    print("隐藏天命")
    self.item_obj:register_event(self.item_obj.event_name, nil)
end

-- 释放资源
function DestinyView:dispose()
    -- print("天命 -- 释放DestinyView")
    self:hide()
    for k,v in pairs(self.view_list or {}) do
        v:dispose()
    end
    self.view_list = nil
    self.init = nil
    self._base.dispose(self)
end

return DestinyView

