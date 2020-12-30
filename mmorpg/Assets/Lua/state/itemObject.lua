------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   
--  author pu
------------------------------------------------
LuaItemManager={}
local LuaObject =LuaObject
local LuaItemManager = LuaItemManager
LuaItemManager.ItemObject=class(LuaObject,function(self,name) --implement luaobject
    LuaObject._ctor(self, name)

    self.asset_loader = self:add_component("assetLoader") -- 添加一个资源加载器的组件
    self.priority = 0
    self.log_enable = true -- 是否启用日志记录用于返回

    self.forced_click = false -- 强制接受点击事件
end)

local StateManager = StateManager
local ItemObject = LuaItemManager.ItemObject
LuaItemManager.items = {}

--[[
*获取已经注册的ItemObject并调用initialize()方法
*objectName:注册的名字
]]
function LuaItemManager:get_item_obejct(objectName)
    local obj=self.items[objectName]
    if obj == nil then
         print(objectName .. " is not registered ")
        return nil
    end
   
    if obj._require == nil then 
      obj._require = true 
      require(obj._lua_path) 
      if obj.initialize ~= nil then obj:initialize() end
      StateManager:add_registerItem(obj)
    end
    return  obj
end

--小心调用这个只用于subview关联
function LuaItemManager:get_item_clone_obejct(objectName)
    local obj=self.items[objectName]
    if obj == nil then
         print(objectName .. " is not registered ")
        return nil
    end
   
    require(obj._lua_path) 
    if obj.initialize ~= nil then obj:initialize() end
    return  obj
end

--[[
*注册object
*objectName:lua文件名字
*luaPaht:lua文件所在路径
*instance_now:是否实例化 bool
*auto_mark_dispose:是否标记为自动释放
]]
function LuaItemManager:register_item_object(objectName, instance_now, auto_mark_dispose)

    assert(self.items[objectName] == nil)
    local new_class   = ItemObject(objectName)
    new_class._key  = objectName
    new_class._lua_path = "models."..objectName.."."..objectName
    new_class._auto_mark_dispose = auto_mark_dispose
    self.items[objectName] = new_class

    if not auto_mark_dispose then -- 加入常驻列表
        StateManager:add_permanent_item(new_class)
    end

    if instance_now then 
        new_class._require = true  
        require(new_class._lua_path) 
        if new_class.initialize ~= nil then new_class:initialize() end
        StateManager:add_registerItem(new_class)
    end

    return new_class
end

-- 显示ItemObject
function ItemObject:show( ... )
    local assets = self.assets -- 需要显示的资源列表
    if assets ~= nil then
        for k,v in ipairs(assets) do  
            v:show()   
        end 
    end
end

-- 显示完成
function ItemObject:on_showed( ... )

end

-- 隐藏ItemObject
function ItemObject:hide( ... )
  local assets = self.assets
  if assets then
   
    for k,v in ipairs(assets) do  v:hide()  end

  end
end

--设置界面参数
function ItemObject:set_view_param(...)
    self.view_param = {...}
end

function ItemObject:get_view_param()
    return self.view_param
end

-- 是否真正显示
function ItemObject:is_visible()
    local assets = self.assets
    if assets then
        for k,v in ipairs(assets) do 
            if v.is_visible and v:is_visible() then
                return true
            end
        end
    end
    return false
end

-- 删除ItemObject
function ItemObject:dispose( ... )
    if self.sub_view_list then
        for k,v in pairs(self.sub_view_list) do
            v:dispose()
        end
        self.sub_view_list = nil
    end

    local assets = self.assets
    if self.on_dispose then self:on_dispose() end
    if assets then
        for k,v in ipairs(assets) do  v:dispose()   end
    end
    self.is_call_assets_loaded = nil
    self.is_disposed = true --标记销毁
end

--检测资源是否加载完成
function ItemObject:check_assets_loaded() 
    local assets = self.assets
    if assets and #assets >= 1 then
        for k,v in ipairs(assets) do
            if v and not v:is_preload() and v:is_loaded() == false then--如果为空没有加载完成
                return false 
            end 
        end
        if  self.is_call_assets_loaded ~= true then --如果还没有加载过
            return false 
        end
    end
    return true --加载完成
end

-- 聚焦 就是显示ItemObject,聚焦完成后会调用自己和注册的on_showed方法
function ItemObject:on_focus(...)
    self.is_on_blur = false
    self.is_disposed = false
    -- 判断是否是正在加载
    if self.is_loading then return end

    -- 是否加载完成
    if self:check_assets_loaded() then 
        self:show()  
        self:send_message("on_showed")
        self:call_event("on_showed")
    else
        for i,v in ipairs(self.assets) do
            if v._clear then
                v:_clear()
            end
        end
        self.asset_loader:load(self.assets)
    end
end

-- function ItemObject:on_back() --返回时候自己实现调用

-- end

-- 标记为自动释放,这个会在StateManager:auto_dispose_items()中管理
function ItemObject:mark_dispose_flag(flag) -- dispose when  StateManager:auto_dispose_items() called
    self._auto_mark_dispose = flag
end

-- 开始隐藏
function ItemObject:on_hide()
  
end

function ItemObject:auto_mark_dispose()
    if self._auto_mark_dispose then 
        StateManager:mark_dispose_flag(self,self._auto_mark_dispose) --标记销毁
    end
end

function ItemObject:on_blur( state )
    if self:check_assets_loaded() then
        self:send_message("on_hide",state) --开始隐藏
        self:auto_mark_dispose()
    end
    self.is_on_blur = true --处于失去焦点状态
    self:hide()
end

--注册 属性改变事件
--[[
*注册属性改变事件
*func:属性改变后的回调方法，就是调用raise_property_changed或set_property会调用此方法
*view:被注册的视图
]]
function ItemObject:register_property_changed(func,view)
    if self.property_changed == nil then self.property_changed = {} end
    self.property_changed[func] = view
end

--mvvm property change 当属性改变的时候需要调用
--[[
*通知注册view属性变更
*property_name:变更的属性名字
]]
function ItemObject:raise_property_changed(property_name)
    if self.property_changed ~= nil then
        local changed_tb = self.property_changed
        for k,v in pairs(changed_tb) do
            k(v,self, property_name)
        end
    end
end

--[[
*设置属性
*propertyName:属性名字，就是设置self.propertyName = value
*value:设置属性的值
]]
function ItemObject:set_property(propertyName,value) --设置属性
    if  self[propertyName] == value or not propertyName then return false end
    self[propertyName] = value
    self:raise_property_changed(propertyName)
    return true
end

-- 添加 调用这个方法去显示属于ItemObjec的view，即是self.assets的所有视图
function ItemObject:add_to_state(state)
    local flag = true
    local current_state = StateManager:get_current_state()
    if state == nil or state == current_state then
        if current_state:add_item(self) then flag = false end -- 此itemObj已经存在

        if self.on_focusing then self:on_focusing(current_state) end
        self:on_focus(current_state)
        if self.on_focused then self:on_focused(current_state) end
        if self.log_enable then StateManager:record_state() end
    else
        state:add_item(self)
    end

    return flag
end

function ItemObject:remove_from_current()
    self:remove_from_state(StateManager._current_game_state)
end

function ItemObject:remove_from_state(state)
    local current_state = StateManager:get_current_state()

    if state == nil or state == current_state then 

        local removed = current_state:remove_item(self)
        if not removed and self._current_state then removed = self._current_state:remove_item(self) end
        
        if removed then --如果从当前状态移除成功        
            if self.on_bluring then self:on_bluring(new_state) end
            self:on_blur(current_state) 
            if self.on_blured then self:on_blured(new_state) end
            if self.log_enable then StateManager:record_state() end
        end
    else
        state:remove_item(self)
        if self._current_state then self._current_state:remove_item(self) end
    end
    self._current_state = nil
end

-- 删除视图
function ItemObject:remove_view()
    local assets = self.assets
    if assets then
        for k,v in ipairs(assets) do  v:dispose()  end
    end
    self:hide()
end

function ItemObject:add_sub_view( view )
    if not self.sub_view_list then
        self.sub_view_list = {}
    end
    self.sub_view_list[view] = view
    
end

function ItemObject:remove_sub_view( view )
    if not self.sub_view_list then
        return
    end
    
    self.sub_view_list[view] = nil
end

function ItemObject:__tostring()
    return string.format("ItemObject(%s) ", self._key)
end
