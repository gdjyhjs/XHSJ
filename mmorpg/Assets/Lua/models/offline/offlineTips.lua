--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local left_time = 5
local offline_item_id = math.floor(ConfigMgr:get_config("game_const")["offline_exp_id2"].value)
local OfflineTips=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("offline")
    UIBase._ctor(self, "welfare_offline_tips.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function OfflineTips:on_asset_load(key,asset)
	
end

function OfflineTips:init_ui()
	self.icon = self.refer:Get(1)
	local item_back = self.refer:Get(5)
	gf_set_item( offline_item_id, self.icon , item_back)
	self.tips = self.refer:Get(4)
	self.tips.text = string.format(gf_localize_string("剩余不足%d小时"),left_time)
end

function OfflineTips:on_receive( msg, id1, id2, sid )
	--[[if id1 == ClientProto.CloseOffline then
  		self:dispose()
  	end]]
end

function OfflineTips:on_click( obj, arg )
	local event_name = obj.name
	if event_name == "btnUse" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local list = LuaItemManager:get_item_obejct("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.OFFLINE_EXP_TIME,ServerEnum.BAG_TYPE.NORMAL)
		if #list == 0 then
			local goods = LuaItemManager:get_item_obejct("mall"):get_goods_for_prodId(offline_item_id)
			gf_open_model(ClientEnum.MODULE_TYPE.MALL,2,2,goods.goods_id)
		else
			require("models.offline.offlineBuy")()
		end
		self:dispose()
		Net:receive({}, ClientProto.CloseOffline)
		--self:dispose()
	elseif event_name == "btnClose" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
		Net:receive({}, ClientProto.CloseOffline)
	end
end

function OfflineTips:register()
	StateManager:register_view( self )
end

function OfflineTips:cancel_register()
	StateManager:remove_register_view( self )
end

function OfflineTips:on_showed()
	self:register()
	self:init_ui()
end

function OfflineTips:on_hided()
end

-- 释放资源
function OfflineTips:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return OfflineTips

