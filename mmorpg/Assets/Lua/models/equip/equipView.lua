--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-22 11:00:42
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local EquipEnum = require("models.equip.equipEnum")
local PageMgr = require("common.pageMgr")

local EquipView=class(Asset,function(self,item_obj)
    self:set_bg_visible( true )
    Asset._ctor(self, "equip_base.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self.view_list = {}
    print("装备界面")
end)

local MODE_PATH = {
    [EquipEnum.MODE.ENHANCE] = "models.equip.enhance", --强化
    [EquipEnum.MODE.FORMULA] = "models.equip.formula", --打造
    [EquipEnum.MODE.INLAY_GEM] = "models.equip.inlayGem", --镶嵌宝石
    [EquipEnum.MODE.INSCRIPTION] = "models.equip.inscription", --铭刻
}
local on_click_event_name = "equip_view_on_click"

-- 资源加载完成
function EquipView:on_asset_load(key,asset)
    print("装备界面加载完成")
    self.itemCache = {}
   

    self.page_mgr = PageMgr(self.refer:Get("yeqian"))
    -- gf_print_table(self.page_mgr,"装备选择页")
    self.page_mgr.page_list[4].btn.gameObject:SetActive(LuaItemManager:get_item_obejct("game"):getLevel()>=ConfigMgr:get_config("t_misc").polish_equip_need_player_level)

    
    -- self:select_page(self.item_obj.open_page1 or 1)

    self.init = true
    self:show()
end

function EquipView:select_page( page )
    print("装备选择页",page)
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
    self:update_red_point()
end

function EquipView:update_red_point()
    if not self.page_mgr then
        return
    end
    for i,obj in ipairs(self.page_mgr.page_list or {}) do
        local show = (function()
                    for k,v in pairs(self.item_obj.red_pos) do
                        if v and tonumber(string.sub(k,1,1)) == i then
                            return true
                        end
                    end
                end)()
        obj.red_point:SetActive(show or false)
    end
end


--服务器返回
function EquipView:on_receive( msg, id1, id2, sid )
    if id1 == ClientProto.UIRedPoint then -- 红点
        if msg.module == ClientEnum.MODULE_TYPE.EQUIP then
            self:update_red_point()
        end
    end
end

function EquipView:create_sub_view( path, ... )
    print("创建子视窗",path)
    local view = require(path)(self.item_obj, ...)
    self:add_child(view)
    return view
end

function EquipView:on_click(item_obj,obj,arg)
    print("装备系统",obj,arg)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "equip_close" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
        self:dispose()
    elseif string.find(cmd, "equipPage_") then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
        self:select_page(obj.transform:GetSiblingIndex()+1)
    end
end

function EquipView:on_showed()
    if self.init then
        print("看看数据类有没有设置选择页",self.item_obj.open_page1)
        local unlock_list = LuaItemManager:get_item_obejct("functionUnlock"):get_page_tb(ClientEnum.MAIN_UI_BTN.MAKE)  or {}
        local page = self.item_obj.open_page1
        self.item_obj.open_page1 = nil
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
            self:dispose()
            return
        end
        for i,v in ipairs(self.page_mgr.page_list) do
            v.btn.gameObject:SetActive(unlock_list[i]~=0)
        end

        self:select_page(page)
        self.item_obj:register_event(on_click_event_name, handler(self, self.on_click))
    end
end

function EquipView:on_hided()
    self.item_obj:register_event(on_click_event_name, nil)
end

-- 释放资源
function EquipView:dispose()
    print("装备视窗释放  EquipView")
    self:hide()
    self.init = nil
    for i,v in ipairs(self.modeObj or {}) do
        v:dispose()
        self.modeObj[i]=nil
    end
    self._base.dispose(self)
end

function EquipView:get_item(key,obj,root)
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

function EquipView:repay_item(key,item)
    if not self.itemCache[key] then self.itemCache[key] = {} end
    item:SetActive(false)
    item.transform:SetParent(self.root.transform,false)
    self.itemCache[key][#self.itemCache[key]+1] = item
end

return EquipView