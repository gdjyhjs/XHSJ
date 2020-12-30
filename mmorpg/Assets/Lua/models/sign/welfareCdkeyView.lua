--[[--
--
-- @Author:Seven
-- @DateTime:2018-01-18 11:27:26
--]]

local res_err = {
	[0] = "兑换码错误",
	[200] = "兑换成功",
	[404] = "请求方式不对",
	[400] = "兑换失败",
	[403] = "此礼包每个角色只能兑换一次",
	[202] = "兑换码为空",
	[203] = "角色id为空",
	[405] = "兑换码错误，请重新输入",
	[406] = "你已兑换过",
}

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local WelfareCdkeyVie=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "welfare_cdkey.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
    self.item_obj=item_obj
end)

-- 资源加载完成
function WelfareCdkeyVie:on_asset_load(key,asset)

end

function WelfareCdkeyVie:on_click(obj,arg)
	print("点击",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name
	if cmd == "btnGetCdKey" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:get_welfare_cdkey()
	elseif cmd == "btnHelp" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1141)
	end
end

function WelfareCdkeyVie:get_welfare_cdkey()
	gf_mask_show(true)
	local url = "http://192.168.0.127:81/index.php/index/card/index"
	local code = self.refer:Get("check_input").text
	local roleid = LuaItemManager:get_item_obejct("game"):getId()
	local curl = string.format("%s?code=%s&roleId=%s",url,code,roleid)
	local on_req_comp = function(req)
		print(req.data)
		gf_mask_show(false)
		local err = json:decode(req.data).code
		gf_message_tips(res_err[err] or res_err[0])
	end
	local on_err = function()
		gf_mask_show(false)
		gf_message_tips(res_err[0])
	end
	print(curl)
	Loader:get_http_data(curl,nil,String,on_req_comp,on_err)
end

function WelfareCdkeyVie:on_showed()
	if not self.is_register then
		self.is_register = 1
	StateManager:register_view(self)
	end
end

function WelfareCdkeyVie:on_hided()
	if self.is_register then
		self.is_register = nil
	StateManager:remove_register_view( self )
	end
end

-- 释放资源
function WelfareCdkeyVie:dispose()
	self:hide()
    self._base.dispose(self)
 end

return WelfareCdkeyVie

