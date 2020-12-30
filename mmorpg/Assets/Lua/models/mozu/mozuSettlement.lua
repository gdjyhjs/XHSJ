--[[--
-- 任务栏管理ui
-- @Author:xcb
-- @DateTime:2017-06-23 18:23:22
--]]
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MozuSettlement=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mozu")
    UIBase._ctor(self, "arena_end.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function MozuSettlement:on_asset_load(key,asset)
	local jiantou = self.refer:Get(4)
	jiantou.gameObject:SetActive(false)

	jiantou = self.refer:Get(5)
	jiantou.gameObject:SetActive(false)
	local item_obj = LuaItemManager:get_item_obejct("mozu")
	local str = string.format(gf_localize_string("铜钱：<color=#ffc61e>%d</color>"),item_obj.my_rank.coin)

	local score_txt = self.refer:Get(1)
	score_txt.text = str

	str = string.format(gf_localize_string("排名：<color=#ffc61e>%d</color>"),item_obj.my_rank.rank)
	local rank_txt = self.refer:Get(2)
	rank_txt.text = str

	str = string.format(gf_localize_string("伤害：<color=#ffc61e>%d</color>"),item_obj.my_rank.hurt)
	local dmg_txt = self.refer:Get(3)
	dmg_txt.text = str
end

function MozuSettlement:init_ui()
end

function MozuSettlement:on_click( obj, arg )
	if 1 < Net:get_server_time_s() - self.click_time then
	    print("MozuSettlement:on_click")
		gf_auto_atk( false )
		LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
	    self:dispose()
	end
end

function MozuSettlement:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.FinishScene then
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) ~= true then
			self:dispose()
		end
	end
end

function MozuSettlement:register()
	StateManager:register_view( self )
end

function MozuSettlement:cancel_register()
	StateManager:remove_register_view( self )
end

function MozuSettlement:on_showed()
	self:register()
	self.click_time = Net:get_server_time_s()
end

function MozuSettlement:on_hided()
end

-- 释放资源
function MozuSettlement:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return MozuSettlement

