--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-19 18:27:56
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local MarketView=class(Asset,function(self,item_obj,mode)
	 self:set_bg_visible( true )
    Asset._ctor(self, "market.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self.view_list = {}
end)

local MODE_PATH = {
    [1] = "models.market.marketBuy", -- 买
    [2] = "models.market.marketSell", -- 卖
    [3] = "models.market.marketRecord", -- 交易记录
}

-- 资源加载完成
function MarketView:on_asset_load(key,asset)
    gf_set_to_top_layer(self.root)
    self.page_mgr = PageMgr(self.refer:Get("yeqian"))
    self.init = true
    self:show()
end

function MarketView:select_page( page )
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
end

function MarketView:create_sub_view( path, ... )
    print("创建子视窗",path)
    local view = require(path)(self.item_obj, ...)
    self:add_child(view)
    return view
end

function MarketView:on_click(item_obj,obj,arg)
	print("市场系统",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "market_close" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
        self:dispose()
    elseif cmd == "marketPage" then
        Sound:play(ClientEnum.SOUND_KEY.SWITCH_PAGE_ONE_BTN) -- 切换1级页签音效
        self:select_page(obj.transform:GetSiblingIndex()+1)
	end
end


function MarketView:on_showed()
    if self.init then
        local unlock_list = LuaItemManager:get_item_obejct("functionUnlock"):get_page_tb(ClientEnum.MAIN_UI_BTN.MARK) or {}
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
        self.item_obj:register_event("market_view_on_click", handler(self, self.on_click))
    end
end

-- 释放资源
function MarketView:dispose()
    self.item_obj:register_event("market_view_on_click", nil)
    self.item_obj.open_page1 = nil
    self.init = nil
    for i,v in ipairs(self.modeObj or {}) do
        v:dispose()
        self.modeObj[i]=nil
    end
    self._base.dispose(self)
end

return MarketView

