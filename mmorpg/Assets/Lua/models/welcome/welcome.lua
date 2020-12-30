---------------------------------------------------------------------------------------------------
--===============================================================================================--
--filename: welcome.lua
--data:2015.4.17
--author:pu
--desc:
--===============================================================================================--
---------------------------------------------------------------------------------------------------

local welcome = LuaItemManager:get_item_obejct("welcome")
local StateManager = StateManager
local delay = delay
local LuaHelper=LuaHelper
local CUtils = CUtils
local get_value = get_value --多国语言

--UI资源
welcome.assets=
{
     View("welcomeView",welcome)
}

------------------private-----------------
local eg_data = {
	-- {title="俄罗斯方块",name="tetris"},
	{title= "战斗场景",name="enemy_scene"},
	{title="主场景",name="main_scene"},
	{title=gf_localize_string("登录"),name="login"},
	-- {title="物品系统",name="item_sys"},
	-- {title="背包",name="bag"},
	-- {title="扩展包资源加载",name="load_extends"}

}

------------------public------------------
function welcome:get_eg_data()
	return self.eg_data
end

function welcome:set_eg_data(val)
	self:set_property("eg_data",val) --设置属性触发属性改变事件
	print(self.eg_data)
end

--资源加载完成后显示的时候调用
function welcome:on_showed()
	self:set_eg_data(eg_data)
end

--列表点击事件 Button绑定CEventReceive.OnCustomerEvent
function welcome:on_customer(obj,arg)
	local cmd =obj.name
    print("welcome  click "..cmd, arg)
    Loader:set_active_variants({"hd"})
    StateManager:set_current_state(StateManager[cmd], true) --切换到对应状态

    
end

function welcome:on_click( sender, arg )
	self.assets[1].content_rect_table:ScrollTo(20)
end

--初始化函数只会调用一次
function welcome:initialize()
	
end