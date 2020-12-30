------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--  luaObject base of object
--  author pu
------------------------------------------------
local components = {}
local gf_components_update_list = gf_components_update_list

local function load_component(name)
    if components[name] == nil then
        components[name] = require("components/"..name)
    end
    return components[name]
end

local function get_component_name(path)
   local _,b,name= string.find(path,"[%.,%/]*(%a+_*%a+)$")
   return name
end

local function add_global_update_comp(fn)
    table.insert(gf_components_update_list,fn)
end

local function remove_global_update_comp(fn)
    local len=#gf_components_update_list
    local delIdx
    for i=1,len do
        if gf_components_update_list[i]==fn then
            delIdx =i
            break
        end
    end

    if delIdx~=nil then table.remove(gf_components_update_list,delIdx) end
end

-------------------------------------------------------------------------------
-------------------------LuaObject---------------------------------------------
-------------------------------------------------------------------------------

LuaObject=class(function(self,name) 
    self.name = name or "luaObject"
	self.components = {}
	self.updatecomponents = {}
    self.active = true
    self.parent = nil
    self.is_disposed = false
end)

--[[
*添加一个组件,即是添加components/arg
*arg:组件名字
]]
function LuaObject:add_component(arg)
    local name = get_component_name(arg)
    local cmp = nil 
    if self.components[name] then
        -- print("component "..name.." already exists!")
        return self.components[name]
    end
    cmp = load_component(arg)
    assert(cmp, "component ".. name .. " does not exist!")

    local loadedcmp = cmp(self)
    self.components[name] = loadedcmp
    loadedcmp.name = name
    if loadedcmp.start then loadedcmp:start() end

    if loadedcmp.on_update then
        if not self.updatecomponents then self.updatecomponents={} end
        self.updatecomponents[name]=loadedcmp
        add_global_update_comp(loadedcmp)
    end

    return loadedcmp
 end

 function LuaObject:remove_component(name)
    local cmp=self.components[name]
    if cmp then remove_global_update_comp(cmd)
        if cmp.remove then cmp:remove() end
    end 
    self.components[name] = nil
    self.updatecomponents[name] = nil
 end

 -- function LuaObject:set_active(bl)
 --    self.active = bl
 -- end

function LuaObject:dispose()
    table.clear(self.components)
    table.clear(self.updatecomponents)
    self.active=false
    self.is_disposed = true
end

--event eg:on_showed
--method_args {{method = "",args = ...},}
--[[
*event:事件名称
*method:事件的回调方法
]]
function LuaObject:register_event(event, method) --在某个事件后调用自己的某个方法
    if self.event_fun == nil then self.event_fun = {} end
    local event_call = self.event_fun[event]
    if event_call == nil then self.event_fun[event] = method end
end

--[[
*触发注册的事件方法
*event:事件名字
*remove:是否要移除(不用的时候要去移除)
]]
function LuaObject:call_event(event, remove, ...) 
    remove = remove == nil and true or remove
    if self.event_fun == nil then return end
    local event_call = self.event_fun[event]
    if event_call and not self.is_disposed then
        local t = type(event_call) 
        if t == "string" then
            fn = self[event_call]
            if fn then fn(self, ...) end
        elseif t == "function" then
            event_call(self, ...)
        end
    end
    if remove == true then
        self.event_fun[event] = nil
    end
end

-- 调用LuaObjiect和它所有组件名字为method的方法
--[[
*method:执行的方法
*...:传给执行方法的参数
]]
function LuaObject:send_message(method,...)
    local cmps=self.components
    local fn
    fn = self[method]
    if type(fn) == "function" then fn(self,...) end --fn(self,{...})

    if cmps then
        --遍历components表中的内容
        for k,v in pairs(cmps) do
            fn = v[method]
           if type(fn) == "function" then fn(v,...) end --fn(v,unpack({...}))
        end
    end

end

--修改表的输出行为
function LuaObject:__tostring()
    --string.format 用于把字符串格式化输出
    return string.format("luaObject.name = %s ", self.name)
end