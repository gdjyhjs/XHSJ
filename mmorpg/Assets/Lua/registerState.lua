------------------------------------------------
--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   
--  author pu
------------------------------------------------
local StateManager = StateManager
local LuaItemManager = LuaItemManager
local StateBase = StateBase
StateManager:set_state_transform(LuaItemManager:get_item_obejct("transform"))

StateManager.welcome = StateBase({"welcome"},nil, nil, "test")
-- StateManager.tetris=StateBase({"tetris"})
--可以多加载UIStateBase({"mainScene", "mainui","dsadsa","asfdsaf"})

StateManager.create_role = StateBase({"createRole","scene160102"})
StateManager.login = StateBase({"login"})

-- StateManager.test = StateBase({"horse"},nil, nil, "test")