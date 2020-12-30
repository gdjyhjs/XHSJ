------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   
--  author pu
------------------------------------------------
ServerEnum = require("enum.enum")
require("core.unity3d")
require("common.bitExtend")
require("common.publicFunc")
require("common.configMgr")
require("common.schedule")
require("common.clientEnum")
require("common.resMgr")
require("common.filterChar")
require("cproto.clientProto")
require("core.structure")
require("const.requires")
require("mgr.uiMgr")
require("registerItemObjects")
require("registerState")
require("registerReceive")
require("uiInput")
require("common.sound")
require("sdk.sdkMgr")

local os=os
local UPDATECOMPONENTS=UPDATECOMPONENTS
local LuaObject=LuaObject
local StateManager=StateManager
local Application= UnityEngine.Application
local RuntimePlatform= UnityEngine.RuntimePlatform
local PlayerPrefs = UnityEngine.PlayerPrefs
local Net=Net
local Msg=Msg
local LuaHelper = LuaHelper
local delay = delay
local pLua = PLua.instance
local CrcCheck = Hugula.Update.CrcCheck
local Common = Hugula.Utils.Common
local UriGroup = Hugula.Loader.UriGroup
local CUtils= Hugula.Utils.CUtils
local PrefabPool = Hugula.Pool.PrefabPool
local BackGroundDownload = Hugula.Update.BackGroundDownload
local UGUIEvent = Hugula.UGUIExtend.UGUIEvent
local ResourcesLoader = Hugula.Loader.ResourcesLoader
local PLua = Hugula.PLua--UI资源
-------------------------------------------------------------------------------

local Proxy=Proxy
local NetMsgHelper = NetMsgHelper
local NetAPIList = NetAPIList
local Screen = UnityEngine.Screen

 Screen.sleepTimeout = -1 -- 设置不锁屏幕

-- 判断是否是iphonex
IS_IPHONEX = false
IPHOENX_TASK_DX = 0 -- 任务栏偏移像素
if Application.platform == RuntimePlatform.IPhonePlayer then
    if Screen.width == 2436 and Screen.height == 1125 then
        IS_IPHONEX = true
        IPHOENX_TASK_DX = 60
    end
end

-- 画布大小
if Screen.width/Screen.height > 1.78 then
    CANVAS_HEIGHT = 720
    CANVAS_WIDTH  = Screen.width/(Screen.height/CANVAS_HEIGHT)
else
    CANVAS_WIDTH = 1280
    CANVAS_HEIGHT = Screen.height/(Screen.width/CANVAS_WIDTH)
end
print("画布大小：",CANVAS_WIDTH,CANVAS_HEIGHT)

UICamera = LuaHelper.Find("UICamera")
BeginCamera = LuaHelper.Find("BeginCamera")
EffectCamera = LuaHelper.Find("EffectCamera")
TOUCH = LuaHelper.Find("Touch")

-- 测试模式显示帧数
if DEBUG or SHOW_PROFILER then
    local begin = LuaHelper.Find("Profiler")
    begin:AddComponent("Hugula.Utils.ProfilerPanel")
end

-- 游戏帧数设为30帧
Application.targetFrameRate = 30

-- 重启游戏
function gf_restart_game()
    LuaHelper.Destroy(LuaHelper.Find("LuaSvrProxy"))
    -- LuaHelper.Destroy(LuaHelper.Find("AssetBundleLoader"))
    -- LuaHelper.Destroy(LuaHelper.Find("BackGroundDownload"))
    LuaHelper.Destroy(PrefabPool.instance)
    UGUIEvent.RemoveAllEvents()
    LuaHelper.Destroy(ResourcesLoader.instance.gameObject)
    BackGroundDownload.Dispose()
    --重启之前清理资源
    PLua.instance:ReStart(0.5)

    gf_clear_texture_cache()
    Seven.STextureManage:getInstance():Clear()

    unload_unused_assets()
    -- StateManager:set_current_state(StateManager.login, true)
end

local function on_state_change(state) --资源回收
	StateManager:auto_dispose_items() --回收标记的item_object
    gf_clear_texture_cache()
    Seven.STextureManage:getInstance():Clear()
	unload_unused_assets()
end

local last_time = -1
local function update()
    -- local ostime=os.clock()
    -- if last_time == -1 then
    --     last_time = ostime
    -- end

    -- local dt = ostime - last_time
    local dt = Time.deltaTime
	local obj
    local len
    len = #g_update_fun_list
    for i=1,len do
        obj=g_update_fun_list[i]
        if obj and obj.on_update then obj:on_update(dt) end
    end

    local cmp
    local len
    len = #gf_components_update_list
    for i=1,len do
        cmp=gf_components_update_list[i]
        if cmp.enable then    cmp:on_update(dt) end
    end
    
    -- last_time = ostime
end

pLua.updateFn=update

require("net.netGame")

-- StateManager:input_disable() --锁定输入
StateManager:set_current_state(StateManager.login)
StateManager:register_state_change(on_state_change,true)

--load config
-- require("common.load_csv")

delay(function( ... )
	-- print(get_value("level_name_001")) --language key
	-- print_table(Model.getUnit(200001)) --read config
	-- Loader:clearSharedAB() 
end,0.5)