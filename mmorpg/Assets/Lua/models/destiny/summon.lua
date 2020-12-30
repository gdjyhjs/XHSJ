--[[--
-- 召唤高级天命 元宝抽取 --self.item_obj:draw_destiny_c2s()
-- @Author:Seven
-- @DateTime:2017-11-24 11:30:58
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local once_money = 10
local ten_money = 90
local money_type = ServerEnum.BASE_RES.GOLD

local Summon=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "destiny_advanced_draw.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    once_money = self.item_obj:get_need_money(2,1).need_money or once_money
	ten_money = self.item_obj:get_need_money(2,2).need_money or ten_money 
end)

-- 资源加载完成
function Summon:on_asset_load(key,asset)
	-- 初始化设置召唤消耗
	self.refer:Get("txtOnceMoney").text = once_money
	self.refer:Get("txtTenMoney").text = ten_money
end

function Summon:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeSummon" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN)
		self:dispose()
	elseif cmd=="btnOnceDraw" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        if LuaItemManager:get_item_obejct("game"):get_money(money_type) >= once_money then
        	self.item_obj:draw_destiny_c2s(1)
			self:dispose()
        else
        	gf_message_tips("元宝不足")
        end
	elseif cmd=="btnTenEvenDraw" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
        if LuaItemManager:get_item_obejct("game"):get_money(money_type) >= ten_money then
        	self.item_obj:draw_destiny_c2s(2)
			self:dispose()
        else
        	gf_message_tips("元宝不足")
        end
	end
end

function Summon:on_showed()
    StateManager:register_view( self )
end

function Summon:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function Summon:dispose()
	self:hide()
    self._base.dispose(self)
 end

return Summon

