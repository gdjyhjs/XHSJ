------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   
--  author pu
------------------------------------------------

local UnityEngine = UnityEngine
----------------------global-------------------------
GameObject=UnityEngine.GameObject
local Resources = UnityEngine.Resources

------------------------------static 变量---------------------------
LeanTween=LeanTween
LeanTweenType=LeanTweenType
Random = UnityEngine.Random
CUtils=CUtils --luanet.import_type("CUtils") -- --LCUtils --
LuaHelper=LuaHelper --LLuaHelper --luanet.import_type("LuaHelper")

Request=LRequest --luanet.import_type("LRequest")

-- 注册更新方法
function gf_register_update( obj )
	table.insert(g_update_fun_list, obj)
end

-- 移除更新方法
function gf_remove_update( obj )
	local len=#g_update_fun_list
    local delIdx
    for i=1,len do
        if g_update_fun_list[i] == obj then
            delIdx =i
            break
        end
    end

    if delIdx~=nil then table.remove(g_update_fun_list,delIdx) end
end

-----------------------global-----------------------------
gf_game_object_atlas={} --resource cach table
gf_components_update_list={} --all update fun components
g_update_fun_list = {}

----------------------require-----------------------------
require("core.luaObject")
require("core.asset")
require("core.assetScene")
require("core.view")

require("state.stateManager")
require("state.itemObject")
require("state.stateBase")
require("common.uiBase")

