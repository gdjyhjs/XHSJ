--[[--
-- 成就
-- @Author:xcb
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper

local Warehouse = LuaItemManager:get_item_obejct("warehouse")
--UI资源
Warehouse.assets=
{
    View("warehouseView", Warehouse) 
}

function Warehouse:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "GetStoreItemListR") then
			self.item_list = {}
			for i,v in ipairs(msg.items) do
				self.item_list[v.guid] = gf_deep_copy(v)
			end
			self.have_requested = true
		elseif id2 == Net:get_id2("alliance", "GetStoreRecordR") then
			print("GetStoreRecordR")
			for i,v in ipairs(msg.record) do
				local str = self:getRecord(v)
				table.insert(self.record_list,str)
			end
			self.have_requested = true
		elseif id2 == Net:get_id2("alliance", "StoreRecordUpdateR") then
			for i,v in ipairs(msg.record) do
				local str = self:getRecord(v)
				table.insert(self.record_list,1,str)
			end
			for i,v in ipairs(msg.items or {}) do
				if self.item_list[v.guid] == nil then
					local temp = gf_deep_copy(v)
					self.item_list[v.guid] = temp
				end
			end

			for i,v in ipairs(msg.guidList or {}) do
				self.item_list[v] = nil
			end
		elseif id2 == Net:get_id2("alliance", "QuitR") then
			self.record_list = {}
			self.item_list = {}
			self.have_requested = false
		end
	end
end

function Warehouse:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end

function Warehouse:getRecord(info)
	local str = ""
	local time = os.date("%m-%d %H:%M",info.time)
	local data = ConfigMgr:get_config("item")
	local name = data[info.protoId].name
	local color = LuaItemManager:get_item_obejct("itemSys"):get_item_color(info.color)
	--1捐献 2兑换 3销毁
	if info.type == 1 then
		str = string.format(gf_localize_string("[%s]%s捐献了<color=%s>%s</color>"),time,info.roleName,color,name)
	elseif info.type == 2 then
		str = string.format(gf_localize_string("[%s]%s兑换了<color=%s>%s</color>"),time,info.roleName,color,name)
	elseif info.type == 3 then
		str = string.format(gf_localize_string("[%s]%s销毁了<color=%s>%s</color>"),time,info.roleName,color,name)
	end
	return str
end

function Warehouse:get_score(role_equip)
	local t_misc = ConfigMgr:get_config("t_misc")
	local data = ConfigMgr:get_config("item")[role_equip.protoId]
	local score = data.level * t_misc.alliance.equipLevel2StorePoint -- 等级*10
	if role_equip.prefix and role_equip.prefix>0 then -- 前缀 等级*10+2500
		score = score + data.level * t_misc.alliance.equipPrefix2StorePoint[1] + t_misc.alliance.equipPrefix2StorePoint[2]
	end
	if role_equip.exAttr and #role_equip.exAttr>0 and #role_equip.exAttr<=#t_misc.alliance.equipStar2StorePoint then -- 星 等级*5+500
		score = score + data.level * t_misc.alliance.equipStar2StorePoint[#role_equip.exAttr][1] + t_misc.alliance.equipStar2StorePoint[#role_equip.exAttr][2]
	end
	if role_equip.color then -- 品质系数
		score = score * t_misc.alliance.equipColor2StorePoint[role_equip.color] or 1
	end
	return score
end

function Warehouse:get_equips_list()
	local equips_list = {}
	local list = LuaItemManager:get_item_obejct("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.EQUIP,nil,ServerEnum.BAG_TYPE.NORMAL)
	for k,v in pairs(list) do
		equips_list[v.item.guid] = gf_deep_copy(v.item)
	end
	return equips_list
end
--初始化函数只会调用一次
function Warehouse:initialize()
	self.record_list = {}
	self.item_list = {}
	self.have_requested = false
	--[[
	self.test_data = {}
			]]
end

function Warehouse:get_record_list()
	return self.record_list
end

function Warehouse:get_item_list()
	return self.item_list
end

function Warehouse:request_item_list()
	Net:send({},"alliance","GetStoreItemList")
	Net:send({},"alliance","GetStoreRecord")
end

function Warehouse:is_had_requested()
	return self.have_requested
end


