--  Copyright © 2013-2014   Hugula: Arpg game Engine
--   NGUIEvent
--  author pu
------------------------------------------------
local UGUIEvent=UGUIEvent --.instance
local Plua = PLua.instance
local StateManager = StateManager
--local InputEvent = {}
local function on_press(sender,arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_press",sender,arg)
	end
end

local function on_press_down( sender, arg )
	if StateManager:get_input_enable() then
		StateManager:on_event("on_press_down",sender,arg)
	end
end

local function on_press_up( sender, arg )
	if StateManager:get_input_enable() then
		StateManager:on_event("on_press_up",sender,arg)
	end
end

local function on_click(sender,arg)
	if StateManager:get_input_enable() then
		local delay_frame = function()
			StateManager:on_event("on_click",sender,arg)
		end
		delay(delay_frame, 0.034) -- 延迟一帧去处理点击事件
	end
end

local function on_drag(sender,arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_drag",sender,arg)
	end
end

local function on_drop(sender,arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_drop",sender,arg)
	end
end

local function on_customer(sender,arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_customer",sender,arg)
	end
end

local function on_select(sender,arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_select",sender,arg)
	end
end

local function on_cancel(sender,arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_cancel",sender,arg)
	end
end

local function on_input_field_value_changed(sender,arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_input_field_value_changed",sender,arg)
	end
end

local function on_input_field_value_end(sender, arg)
	if StateManager:get_input_enable() then
		StateManager:on_event("on_input_field_value_end",sender,arg)
	end
end

local function on_app_pause(sender,arg)
	if StateManager._current_game_state then
		StateManager:on_event("on_app_pause",sender,arg)
	end
end

local function on_app_focus(sender,arg)
	if StateManager._current_game_state then
		StateManager:on_event("on_app_focus",sender,arg)
	end
end

UGUIEvent.onSelectFn=on_select
UGUIEvent.onCancelFn=on_cancel
UGUIEvent.onCustomerFn=on_customer
UGUIEvent.onPressFn=on_press
UGUIEvent.onClickFn=on_click
UGUIEvent.onDragFn=on_drag
UGUIEvent.onDropFn=on_drop
UGUIEvent.onPointerDownFn = on_press_down
UGUIEvent.onPointerUpFn = on_press_up
UGUIEvent.onInputFieldValueChanged = on_input_field_value_changed
UGUIEvent.onInputFieldValueEnd = on_input_field_value_end

Plua.onAppFocusFn = on_app_focus
Plua.onAppPauseFn = on_app_pause --游戏暂停