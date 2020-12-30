--[[--
--飘字系统
-- @Author:HuangJunShan
-- @DateTime:2017-04-12 16:00:24
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FloatTextSys = LuaItemManager:get_item_obejct("floatTextSys")
--UI资源
FloatTextSys.assets=
{
    View("floatTextSysView", FloatTextSys) 
}

--初始化函数只会调用一次
function FloatTextSys:initialize()
	print("飘字系统函数初始化完毕")
end

function FloatTextSys:battle_float_text(target_tf, btf_type, number)
	self.assets[1]:battle_float_text(target_tf, btf_type, number)
end

--[[
普通中间飘字
content:内容
]]
function FloatTextSys:tishi(content)
	self.assets[1]:add_leftbottom_broadcast(content, 0)
	--self.assets[1]:sys_tishi(content,UnityEngine.Vector2(640,50))
end

-- 进入战斗状态飘字
function FloatTextSys:in_battle_flag()
	self.assets[1]:add_leftbottom_broadcast(gf_localize_string("进入战斗状态"), 100)
end

-- 脱离战斗状态飘字
function FloatTextSys:out_battle_flag()
	self.assets[1]:add_leftbottom_broadcast(gf_localize_string("脱离战斗状态"), 101)
end

-- 屏幕中间广播(content内容string,interval间隔number,count次数integer,delay延遲，秒數,time(如果没有count，有time，会自动计算count))
function FloatTextSys:marquee(content,count,interval,delay,time)
	self.assets[1]:set_epinasty_broadcast(content,count,interval,delay,time)
end

-- 屏幕底部广播



-- 物品飘飞
function FloatTextSys:add_get_item(cprotoId,Vector3_pos,color)
	self.assets[1]:add_get_item(cprotoId,Vector3_pos,color)
end