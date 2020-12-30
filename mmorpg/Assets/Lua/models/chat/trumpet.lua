--[[--
-- 喇叭
-- @Author:Seven
-- @DateTime:2017-09-19 11:54:28
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local init = false -- 是否加载ui完毕
local on_show = false -- 是否正在显示

local max_text_count = 60

local Trumpet=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "trumpet.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function Trumpet:on_asset_load(key,asset)
	self.message_input_field = self.refer:Get("input_text")
	self:set_horn_count()
	init = true
end

function Trumpet:on_click(obj,arg)
	print("喇叭点击",obj,arg)
 	local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if cmd == "close_trumpet" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "send_hron" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if LuaItemManager:get_item_obejct("bag"):get_item_count(ConfigMgr:get_config("t_misc").special_item_code.speaker_code,ServerEnum.BAG_TYPE.NORMAL)<1 then
			gf_message_tips("喇叭数量不足")
		elseif self.message_input_field.text == nil or self.message_input_field.text == "" then
			gf_message_tips("发送消息不能为空")
		else
			self.item_obj:send_message_c2s(self.message_input_field.text,ServerEnum.CHAT_CHANNEL.SPEAKER)
			self:dispose()
		end
	elseif cmd == "emoji_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:open_emoji_ui(self.message_input_field,ServerEnum.CHAT_CHANNEL.SPEAKER)
	elseif cmd == "addCount" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_create_quick_buy_by_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.SPEAKER,1)
	elseif cmd == "input_text" then
		local inputField = self.message_input_field
		while(gf_get_string_length(inputField.text)>max_text_count)do
			inputField.text = string.sub(inputField.text,1,-2)
		end
		self.refer:Get("text_count").text = max_text_count - gf_get_string_length(inputField.text)
	end
end

function Trumpet:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("bag") then
		if id2 == Net:get_id2("bag", "UpdateItemR") then
			self:set_horn_count()
		end
    elseif id1==ClientProto.VoiceMessageR then
      	gf_print_table(msg,"语音消息转文字结果")
      	self.message_input_field.text = self.message_input_field.text .. msg.text
    end
end

--设置拥有喇叭数量
function Trumpet:set_horn_count()
	self.refer:Get("horn_count").text = LuaItemManager:get_item_obejct("bag"):get_item_count(ConfigMgr:get_config("t_misc").special_item_code.speaker_code,ServerEnum.BAG_TYPE.NORMAL)
end

function Trumpet:on_showed()
	if not on_show then
		on_show = true
		StateManager:register_view( self )
	end
end

function Trumpet:on_hided()
	on_show = nil
	StateManager:remove_register_view( self )
end

-- 释放资源
function Trumpet:dispose()
	self:hide()
	init = nil
    self._base.dispose(self)
 end

function Trumpet:on_press_down(obj,eventData)
    print("准备发喇叭界面按下",obj,eventData)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "record_btn" then
        LuaItemManager:get_item_obejct("chat"):start_recording(ServerEnum.CHAT_CHANNEL.END,eventData.position)
    end
    return true
end

function Trumpet:on_drag(obj,position)
    print("准备发喇叭界面按住",obj,position)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "record_btn" then
        LuaItemManager:get_item_obejct("chat"):on_recording(ServerEnum.CHAT_CHANNEL.END,position)
    end
    return true
end

function Trumpet:on_press_up(obj,eventData)
    print("准备发喇叭界面弹起",obj,eventData)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "record_btn" then
        LuaItemManager:get_item_obejct("chat"):stop_recording(ServerEnum.CHAT_CHANNEL.END,eventData.position)
    end
    return true
end

return Trumpet

