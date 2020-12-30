--[[--
-- UI基类
-- 注：继承这个类去做UI要自己手动去调用dispose()去销毁
-- @Author:Seven
-- @DateTime:2017-03-17 18:10:58
--]]

local AssetLoader = require("components.assetLoader")
UIBase = class(Asset,function(self, url, item_obj)
    Asset._ctor(self, url)

    self.item_obj = item_obj
    -- self.asset_loader = AssetLoader(item_obj) -- 添加一个资源加载器的组件
    self.item_obj:add_sub_view(self)

    if not item_obj._auto_mark_dispose then -- 常驻ui
		self:set_level(UIMgr.LEVEL_STATIC)
	end

    self.item_obj.asset_loader:load({self})
end)

-- 资源加载完成 UI的初始化放在这里
function UIBase:on_asset_load(key,asset)
    if self.callback then
        print("run self.callback")
        self.callback()
    end
end

function UIBase:set_load_callback(callback)
    self.callback = callback
end

function UIBase:dispose()
    self.item_obj:remove_sub_view(self)
    UIBase._base.dispose(self)
end

return UIBase
