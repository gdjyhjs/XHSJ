--[[--
-- 背包主界面
-- @Author:HuangJunShan
-- @DateTime:2017-03-24 14:43:25
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local BagEnum = require("models.bag.bagEnum")
local PageMgr = require("common.pageMgr")

local BagView=class(Asset,function(self,item_obj,mode)
    self:set_bg_visible(true)
    Asset._ctor(self, "bag.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self.view_list = {}
    print("create bag view1")
    
    
end)

local MODE_PATH = {
    [BagEnum.MODE.KNAPSACK] = "models.bag.knapsack",
    [BagEnum.MODE.DEPOT] = "models.bag.depot",
    [BagEnum.MODE.FUSION] = "models.bag.fusion",
    [BagEnum.MODE.SET] = "models.bag.set",
}

-- 资源加载完成
function BagView:on_asset_load(key,asset)
    gf_set_to_top_layer(self.root)
    print("create bag view2")
    self:hide_mainui()
    self:init_ui()
    self.init = true

    self:show()
end

function BagView:init_ui()
    self.page_mgr = PageMgr(self.refer:Get("yeqian"))
end

function BagView:select_page( page )
    if self.item_obj.OneKeyUseObj then -- 如果打开一键使用则关闭
        self.item_obj.OneKeyUseObj:hide()
        self.item_obj.OneKeyUseObj = nil
    end
    if not self.page_mgr then
        return
    end
    
    self.page_mgr:select_page(page)
    if self.page_mgr:get_last_page() and self.view_list[self.page_mgr:get_last_page()] then
        self.view_list[self.page_mgr:get_last_page()]:hide()
    end

    if not self.view_list[page] or not self.view_list[page].root then
        self.view_list[page] = self:create_sub_view(MODE_PATH[page],self)
    else
        self.view_list[page]:show()
    end
end

function BagView:create_sub_view( path, ... )
    print("创建子视窗",path)
    local view = require(path)(self.item_obj, ...)
    self:add_child(view)
    return view
end

function BagView:on_click(item_obj,obj,arg)
    print("背包系统",obj,arg)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "bag_close" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 音效
        self:hide()
    elseif string.find(cmd, "page") then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 音效
        self:select_page(obj.transform:GetSiblingIndex()+1)
    end
end

function BagView:register()
    self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
end

function BagView:cancel_register()
    self.item_obj:register_event(self.item_obj.event_name, nil)
end

function BagView:on_showed()
    if self.init then
        local unlock_list = LuaItemManager:get_item_obejct("functionUnlock"):get_page_tb(ClientEnum.MAIN_UI_BTN.BAG) or {}
        local page = self.item_obj.open_mode
        self.item_obj.open_mode = nil
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
        if self.init then
            self:select_page(page)
        end
        self:register()
    end
end

function BagView:on_hided()
    if self.item_obj.OneKeyUseObj then -- 如果打开一键使用则关闭
        self.item_obj.OneKeyUseObj:hide()
        self.item_obj.OneKeyUseObj = nil
    end
    self.item_obj.open_mode = nil
    self:cancel_register()
end

-- 释放资源
function BagView:dispose()
    self.init = nil
    self.page_mgr = nil
    self:cancel_register()
    self._base.dispose(self)
end

function BagView:get_item(key,obj,root)
    -- print("获取item",key,obj,root)
    if not self.itemCache then self.itemCache = {} end
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

function BagView:repay_item(key,item)
    item:SetActive(false)
    item.transform:SetParent(self.root.transform,false)
    self.itemCache[key][#self.itemCache[key]+1] = item
end

return BagView


