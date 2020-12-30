--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local kouliang_shop_id = 20010001
local OfflineBuy=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("offline")
    UIBase._ctor(self, "item_sys_cpm.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function OfflineBuy:on_asset_load(key,asset)
	
end

function OfflineBuy:init_ui()	
	self.title_text = self.refer:Get(1)
	self.num = self.refer:Get(4)
	self.num_text = self.refer:Get(7)
	self.name = self.refer:Get(5)
	self.select_count = 1

	local list = LuaItemManager:get_item_obejct("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.OFFLINE_EXP_TIME,ServerEnum.BAG_TYPE.NORMAL)
	local config = ConfigMgr:get_config("item")
	local function sort(a,b)
		local value_a = config[a.item.protoId].effect[1]
		local value_b = config[b.item.protoId].effect[1]
		return value_b < value_a
	end
	table.sort(list,sort)
	local item_id = list[1].item.protoId
	self.guid = list[1].item.guid
	self.item_id = item_id
	self.count = list[1].item.num
	self.num.text = tostring(self.count)
	if ConfigMgr:get_config("item")[item_id] ~= nil then
		self.name.text = ConfigMgr:get_config("item")[item_id].name
	end
	self.icon = self.refer:Get(3)
	local item_back = self.refer:Get(2)
	gf_set_item( list[1].item.protoId, self.icon , item_back)
	self.num_text.text = "1"

	self.title_text.text = gf_localize_string("使 用")

	self.function_name = self.refer:Get(6)
	self.function_name.text = gf_localize_string("使用数量:")
end

function OfflineBuy:refresh()
	self.num_text.text = tostring(self.select_count)
end
function OfflineBuy:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("base") then
        if id2 == Net:get_id2("base", "UpdateResR") then
        	self:init_ui()
        end
    end
end

function OfflineBuy:on_click( obj, arg )
	local event_name = obj.name
	if event_name == "cmpAddBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		if self.select_count < self.count then
			self.select_count = self.select_count + 1
			self:refresh()
		else
			self.select_count = 1
			self:refresh()
		end
	elseif event_name == "cmpReduceBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		if 1 < self.select_count then
			self.select_count = self.select_count - 1
			self:refresh()
		else
			self.select_count = self.count
			self:refresh()
		end
	elseif event_name == "cmpSureBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local goods = LuaItemManager:get_item_obejct("mall"):get_goods_for_prodId(self.item_id)
		print("hahahahahdkdkdkdd",self.guid,self.select_count,self.item_id)
		LuaItemManager:get_item_obejct("bag"):use_item_c2s(self.guid,self.select_count,self.item_id)
		self:dispose()
	elseif event_name == "cmpCancleBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
	end
end

function OfflineBuy:register()
	StateManager:register_view( self )
end

function OfflineBuy:cancel_register()
	StateManager:remove_register_view( self )
end

function OfflineBuy:on_showed()
	self:register()
	self:init_ui()
end

function OfflineBuy:on_hided()
end

-- 释放资源
function OfflineBuy:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return OfflineBuy

