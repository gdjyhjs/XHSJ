--[[--
-- 获取体力
-- @Author:HuangJunShan
-- @DateTime:2017-08-16 21:02:06
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local GetEnergy=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "get_energy.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function GetEnergy:on_asset_load(key,asset)
	self.item_obj:strength_list_c2s()
	self.init = true
end

function GetEnergy:set_content()
	local list = self.item_obj.StrengthList
	self.refer:Get("max_get_strength_text").text = (list.todayGet or 0).."/25"
	self.refer:Get("can_get_strength_text").text = list.leftCount or 0
end

function GetEnergy:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="getStrengthBtn" then --领取体力
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:get_strength_c2s()
	end
end

function GetEnergy:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		-- gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "StrengthListR"))then
			-- print("服务器返回：可领体力列表")
			self:set_content()
		elseif(id2== Net:get_id2("friend", "BeGiveR"))then
			-- print("服务器返回：可领体力列表")
			self.item_obj:strength_list_c2s() --获取体力
		end
	end
end

function GetEnergy:register()
    StateManager:register_view( self )
end

function GetEnergy:cancel_register()
	StateManager:remove_register_view( self )
end

function GetEnergy:on_showed()
	self:register()
    if self.init then
		self.item_obj:strength_list_c2s() --获取体力
	end
end

function GetEnergy:on_hided()
	self:cancel_register()
end
-- 释放资源
function GetEnergy:dispose()
    self._base.dispose(self)
 end

return GetEnergy

