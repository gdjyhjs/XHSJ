--[[--
--
-- @Author:Seven
-- @DateTime:2017-11-23 10:47:49
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SettingPassword=class(UIBase,function(self,ty)
	self.ty = ty
	self.item_obj = LuaItemManager:get_item_obejct("setting") 
    UIBase._ctor(self, "system_setting_password_input.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function SettingPassword:on_asset_load(key,asset)
	gf_mask_show(false)
	StateManager:register_view(self)
	local state = self.item_obj:get_setting_state()
	if state == ServerEnum.ROLE_SAFTY_STATE.NONE then
		self.refer:Get("input3_obj"):SetActive(false)
		self.refer:Get("tips"):SetActive(false)
		self.refer:Get("txtInput1").text = gf_localize_string("设置密码")
		self.refer:Get("txtInput2").text = gf_localize_string("确认密码")
		self.refer:Get("uiTitleTxt").text = gf_localize_string("设置密码")

	elseif self.ty then
		self.refer:Get("tips"):SetActive(false)
		self.refer:Get("uiTitleTxt").text = gf_localize_string("重设密码")

	elseif state == ServerEnum.ROLE_SAFTY_STATE.LOCK then
		self.refer:Get("input2_obj"):SetActive(false)
		self.refer:Get("input3_obj"):SetActive(false)
		self.refer:Get("txtInput1").text = gf_localize_string("输入密码")
		self.refer:Get("uiTitleTxt").text = gf_localize_string("解除锁定")
		
	end
end

function SettingPassword:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btnposswordClose" or cmd == "cancle_btn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "sure_btn"  then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		local state = self.item_obj:get_setting_state()
		if state == ServerEnum.ROLE_SAFTY_STATE.NONE then
			if  string.len(self.refer:Get(1).text)>=6 and self.refer:Get(1).text == self.refer:Get(2).text then
				self.item_obj:set_safty_code_c2s(self.refer:Get(1).text)
				return
			end
			if self.refer:Get(1).text ~= self.refer:Get(2).text and (self.refer:Get(1).text ~= "" or self.refer:Get(2).text ~= "")  then
				gf_mask_show(false)
				gf_message_tips("输入2次密码不一致")
				return
			end
		elseif self.ty then
			if  string.len(self.refer:Get(1).text)>=6 then
				if  string.len(self.refer:Get(2).text)>=6 and self.refer:Get(3).text == self.refer:Get(2).text then
					self.item_obj:reset_safty_code_c2s(self.refer:Get(1).text,self.refer:Get(2).text)
					return
				elseif  self.refer:Get(2).text == "" and self.refer:Get(3).text == "" then
					self.item_obj:reset_safty_code_c2s(self.refer:Get(1).text,self.refer:Get(2).text)
					return
				end
				if (self.refer:Get(3).text ~= "" or self.refer:Get(2).text ~= "") and self.refer:Get(3).text ~= self.refer:Get(2).text then
					gf_mask_show(false)
					gf_message_tips("输入2次密码不一致")
					return
				end
			end
		elseif state == ServerEnum.ROLE_SAFTY_STATE.LOCK then
			if  string.len(self.refer:Get(1).text)>=6 then
				self.item_obj:unlock_safty_code_c2s(self.refer:Get(1).text)
				return
			end
		end
		gf_mask_show(false)
		gf_message_tips("请输入6-8位数字密码")
	end
end
function SettingPassword:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "UnlockSaftyCodeR")
			or id2 == Net:get_id2("base", "SetSaftyCodeR")
			or id2 == Net:get_id2("base", "ResetSaftyCodeR")
			or id2 == Net:get_id2("base", "LockSaftyCodeR") then
			if msg.err == 0 then
				if self then
					self:dispose()
				end
			end
			gf_mask_show(false) 
		end
	end
end
-- 释放资源
function SettingPassword:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return SettingPassword

