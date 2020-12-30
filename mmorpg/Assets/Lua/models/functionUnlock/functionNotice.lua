--[[--
--
-- @Author:Seven
-- @DateTime:2017-12-19 16:14:58
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FunctionNotice=class(UIBase,function(self)
	self.item_obj = LuaItemManager:get_item_obejct("functionUnlock")
    UIBase._ctor(self, "function_notice.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function FunctionNotice:on_asset_load(key,asset)
	StateManager:register_view(self)
	local data = self.item_obj:get_cur_fun_tip()
	gf_setImageTexture(self.refer:Get(1),data.icon)
	self.refer:Get(2).text = gf_localize_string(data.name)
	self.refer:Get(3).text = gf_localize_string(data.content)
	local lv = data.level-LuaItemManager:get_item_obejct("game"):getLevel()
	if lv<0 then
		lv = 0
	end
	local txt = ""
	if data.open_type then
		txt = "完成"..data.level.."级主线任务开启"
	else
		txt = "等级达到"..data.level.."级开启(还差"..lv.."级)"
	end
	self.refer:Get(4).text = gf_localize_string(txt)
end


function FunctionNotice:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "bg" or "closebagBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	end
end
-- 释放资源
function FunctionNotice:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return FunctionNotice

