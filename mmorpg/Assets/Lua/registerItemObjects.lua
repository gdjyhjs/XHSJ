------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   
--  author pu
------------------------------------------------
local LuaItemManager = LuaItemManager
local StateManager = StateManager

--global
LuaItemManager:register_item_object("transform",true)
LuaItemManager:register_item_object("game",true)
LuaItemManager:register_item_object("guide",false)
LuaItemManager:register_item_object("uimask",true)
LuaItemManager:register_item_object("cCMP",true)
LuaItemManager:register_item_object("npc",true)
LuaItemManager:register_item_object("buff",true)
LuaItemManager:register_item_object("floatTextSys",true)
LuaItemManager:register_item_object("mask",true)
LuaItemManager:register_item_object("keyboard",true)

if DEBUG then
	LuaItemManager:register_item_object("test",true)
end

--itemobject
LuaItemManager:register_item_object("login",false,true)
LuaItemManager:register_item_object("announcement",false,true)
LuaItemManager:register_item_object("createRole",false,true)
LuaItemManager:register_item_object("skill",false,true)
LuaItemManager:register_item_object("player", false, true)
LuaItemManager:register_item_object("copy",false,true)
LuaItemManager:register_item_object("battle",false,true)
LuaItemManager:register_item_object("bag",false,true)
LuaItemManager:register_item_object("map",false,true)
LuaItemManager:register_item_object("chat",false,true)
LuaItemManager:register_item_object("itemSys",false,true)
LuaItemManager:register_item_object("equip",false,true)
LuaItemManager:register_item_object("welcome",false,true)
LuaItemManager:register_item_object("mainui",false, true)
LuaItemManager:register_item_object("fuhuo",false,true)
LuaItemManager:register_item_object("combat",false,true)
LuaItemManager:register_item_object("shop",false,true)
LuaItemManager:register_item_object("system",false,true)
LuaItemManager:register_item_object("head",false,true)
LuaItemManager:register_item_object("social",false,true)
LuaItemManager:register_item_object("email",false,true)
LuaItemManager:register_item_object("marriage",false,true)
LuaItemManager:register_item_object("swornBrothers",false,true)
LuaItemManager:register_item_object("mall",false,true)
LuaItemManager:register_item_object("vipPrivileged",false,true)
LuaItemManager:register_item_object("market",false,true)
LuaItemManager:register_item_object("destiny",false,true)
LuaItemManager:register_item_object("zorkPractice",false,true)
LuaItemManager:register_item_object("luckyDraw",false,true)
LuaItemManager:register_item_object("bonfire",false,true)
LuaItemManager:register_item_object("card",false,true)
LuaItemManager:register_item_object("empty",false,true)

LuaItemManager:register_item_object("husong",false,true)
LuaItemManager:register_item_object("functionUnlock",false,true)
LuaItemManager:register_item_object("gameOfTitle",false,true)
LuaItemManager:register_item_object("moneyTree",false,true)
LuaItemManager:register_item_object("activeDaily",false,true)
LuaItemManager:register_item_object("officerPosition",false,true)
LuaItemManager:register_item_object("gift",false,true)
LuaItemManager:register_item_object("exam",false,true)
LuaItemManager:register_item_object("sign",false,true)

LuaItemManager:register_item_object("task",false,true)
LuaItemManager:register_item_object("legion",false,true)
LuaItemManager:register_item_object("sit",false,true)
LuaItemManager:register_item_object("setting",false,true)

LuaItemManager:register_item_object("team",false,true)
LuaItemManager:register_item_object("hero",false,true)
LuaItemManager:register_item_object("horse",false,true)
LuaItemManager:register_item_object("rank",false,true)
LuaItemManager:register_item_object("train",false,true)
LuaItemManager:register_item_object("challenge",false,true)
LuaItemManager:register_item_object("boss",false,true)
LuaItemManager:register_item_object("pvp",false,true)
LuaItemManager:register_item_object("pvp3v3",false,true)

LuaItemManager:register_item_object("skyTask",false,true)
LuaItemManager:register_item_object("firstWar",false,true)
LuaItemManager:register_item_object("story",false,true)
LuaItemManager:register_item_object("rvr",false,true)
LuaItemManager:register_item_object("surface",false,true)

LuaItemManager:register_item_object("strengthen",false,true)

-- 场景
LuaItemManager:register_item_object("scene160102",false,true)

LuaItemManager:register_item_object("mozu",false,true)
LuaItemManager:register_item_object("achievement",false,true)
LuaItemManager:register_item_object("achievementTips",false,true)
LuaItemManager:register_item_object("warehouse",false,true)
LuaItemManager:register_item_object("astrolabe",false,true)
LuaItemManager:register_item_object("activeEx",false,true)
LuaItemManager:register_item_object("offline",false,true)


