--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-22 15:23:20
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MessagePush=class(UIBase,function(self,item_obj)
	self.item_obj = LuaItemManager:get_item_obejct("setting")
    UIBase._ctor(self, "message_push.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function MessagePush:on_asset_load(key,asset)
	StateManager:register_view(self)
	self.btnHpFullSel = self.refer:Get("btnHpFullSel")--体力回满
	self.btnRvrSel = self.refer:Get("btnRvrSel")--逐鹿战场
	self.btnBonfireSel = self.refer:Get("btnBonfireSel")--军团篝火
	self.btnDoubleSel = self.refer:Get("btnDoubleSel")--双倍护送
	self.btninPrivateChatSel = self.refer:Get("btninPrivateChatSel")--好友私聊
	self.btnGetVPSel = self.refer:Get("btnGetVPSel")--体力领取
	self.btn3v3Sel = self.refer:Get("btn3v3Sel")--烽火3v3
	self.btnBanquetSel = self.refer:Get("btnBanquetSel")--军团宴会
	self.btnSiegeSel = self.refer:Get("btnSiegeSel")--怪物攻城

	self.btnHpFullNor = self.refer:Get("btnHpFullNor")--体力回满
	self.btnRvrNor = self.refer:Get("btnRvrNor")--逐鹿战场
	self.btnBonfireNor = self.refer:Get("btnBonfireNor")--军团篝火
	self.btnDoubleNor = self.refer:Get("btnDoubleNor")--双倍护送
	self.btninPrivateChatNor = self.refer:Get("btninPrivateChatNor")--好友私聊
	self.btnGetVPNor = self.refer:Get("btnGetVPNor")--体力领取
	self.btn3v3Nor = self.refer:Get("btn3v3Nor")--烽火3v3
	self.btnBanquetNor = self.refer:Get("btnBanquetNor")--军团宴会
	self.btnSiegeNor = self.refer:Get("btnSiegeNor")--怪物攻城

	self:update_ui()
end

function MessagePush:update_ui()
	self.btnHpFullSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.HPFULL))
	self.btnRvrSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.RVR))
	self.btnBonfireSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.BONFIRE))
	self.btnDoubleSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.DOUBLEHUSONG))
	self.btninPrivateChatSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.INPRIVATECHAT))
	self.btnGetVPSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.GETVP))
	self.btn3v3Sel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.FIRE3V3))
	self.btnBanquetSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.BANQUET))
	self.btnSiegeSel:SetActive(self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.SIEGE))

	self.btnHpFullNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.HPFULL))
	self.btnRvrNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.RVR))
	self.btnBonfireNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.BONFIRE))
	self.btnDoubleNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.DOUBLEHUSONG))
	self.btninPrivateChatNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.INPRIVATECHAT))
	self.btnGetVPNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.GETVP))
	self.btn3v3Nor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.FIRE3V3))
	self.btnBanquetNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.BANQUET))
	self.btnSiegeNor:SetActive(not self.item_obj:get_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,ClientEnum.MESSAGEPUSH.SIEGE))
end


function MessagePush:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btnHpFull" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.HPFULL)
		self:update_ui()
	elseif cmd == "btnRVR" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.RVR)
		self:update_ui()
	elseif cmd == "btnBonfire" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.BONFIRE)
		self:update_ui()
	elseif cmd == "btnDouble" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.DOUBLEHUSONG)
		self:update_ui()
	elseif cmd == "btninPrivateChat" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.INPRIVATECHAT)
		self:update_ui()
	elseif cmd == "btnGetVP" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.GETVP)
		self:update_ui()
	elseif cmd == "btn3v3" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.FIRE3V3)
		self:update_ui()
	elseif cmd == "btnBanquet" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.BANQUET)
		self:update_ui()
	elseif cmd == "btnSiege" then
	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效	
		self.item_obj:set_setting_value(ClientEnum.SETTING.MESSAGE_PUSH,nil,ClientEnum.MESSAGEPUSH.SIEGE)
		self:update_ui()
	elseif cmd == "btnMessagePushClose" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end


-- 释放资源
function MessagePush:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return MessagePush

