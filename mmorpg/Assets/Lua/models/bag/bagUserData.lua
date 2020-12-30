--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-10 17:46:24
--]]

local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local BagUserData = {}
local Bag = LuaItemManager:get_item_obejct("bag")

BagUserData.bagTidyTime = 10
BagUserData.fillRefreshTime = 0.1


local bagUnlock = ConfigMgr:get_config("bagUnlock")
local bagMaxItem = 0
local depotMaxItem = 0
for k,v in pairs(bagUnlock) do
	if v.type == Enum.BAG_TYPE.NORMAL then
		bagMaxItem = bagMaxItem + 1
	elseif v.type == Enum.BAG_TYPE.DEPOT then
		depotMaxItem = depotMaxItem + 1
	end
end

local type_item_list = nil -- 物品分类 类型为键获取物品列表
local precious_item = nil -- 贵重物品 使用时需要判断解锁的物品id ｛id=id｝
local use_guide_item = nil -- 获得时需要引导使用的物品 ｛id=id｝

--获取背包最大页数
function BagUserData:get_knapsack_max_page(bagType)
	if bagType == Enum.BAG_TYPE.NORMAL then
		return bagMaxItem/self:get_knapsack_page_item_count(bagType)
	elseif bagType == Enum.BAG_TYPE.DEPOT then
		print("最大格子数",depotMaxItem)
		print("每页几格",self:get_knapsack_page_item_count(bagType))
		print("最大页数",depotMaxItem/self:get_knapsack_page_item_count(bagType))
		return depotMaxItem/self:get_knapsack_page_item_count(bagType)
	elseif bagType == Enum.BAG_TYPE.EQUIP then
		return 1
	end
end

--获取背包每页格子数
function BagUserData:get_knapsack_page_item_count(bagType)
	if bagType == Enum.BAG_TYPE.NORMAL then
		return 16
	elseif bagType == Enum.BAG_TYPE.DEPOT then
		return 20
	elseif bagType == Enum.BAG_TYPE.EQUIP then
		return 10
	end
end

--获取最大格子数
function BagUserData:get_max_item_count(bagType)
	if bagType == Enum.BAG_TYPE.NORMAL then
		return bagMaxItem
	elseif bagType == Enum.BAG_TYPE.DEPOT then
		return depotMaxItem
	elseif bagType == Enum.BAG_TYPE.EQUIP then
		return 10
	end
end

--获取背包，页，格的物品
function BagUserData:get_item(bagType,page,index)
	print("获取物品",bagType,page,index)
	return Bag:get_bag_item()
	[bagType*10000+(page-1)*BagUserData:get_knapsack_page_item_count(bagType)+index]
end

--获取身上装备的模型
function BagUserData:get_role_equip_mode()
	local t = {}
	for i=1,10 do
		local item = Bag:get_bag_item()[Enum.BAG_TYPE.EQUIP*10000+i]
		if item then
			t[i] = ConfigMgr:get_config("item")[item.protoId].effect_ex[1]
		end
	end
	return t
end

--根据大小类获取道具原型id
function BagUserData:get_item_for_type(type,sub_type)
	if not type_item_list then
		type_item_list = {}
		for k,v in pairs(ConfigMgr:get_config("item")) do
			if not type_item_list[v.type] then type_item_list[v.type] = {} end
			if not type_item_list[v.type][v.sub_type] then type_item_list[v.type][v.sub_type] = {} end
			type_item_list[v.type][v.sub_type][#type_item_list[v.type][v.sub_type]+1] = v
		end
	end
	if not type_item_list[type] then
		gf_error_tips("不存在物品大类"..type)
	elseif not type_item_list[type][sub_type] then
		gf_error_tips("不存在物品大类"..type.."小类"..sub_type)
	end
	return type_item_list[type][sub_type] or {}
end

function BagUserData:get_item_lock(code)
	print("判断物品是否需要验证解锁",code)
	if not precious_item then
		precious_item = {}
		for i,v in ipairs(ConfigMgr:get_config("safty_lock_item")) do
			if v.code~=0 then
				precious_item[v.code] = v.code
			else
				local list = self:get_item_for_type(v.type,v.sub_type)
				for i,v in ipairs(list) do
					precious_item[v.code] = v.code
				end
			end
		end
	end
	return precious_item[code]
end

function BagUserData:get_item_use_guide(code)
	print("判断物品是否要引导使用",code)
	if not use_guide_item then
		use_guide_item = {}
		for i,v in ipairs(ConfigMgr:get_config("use_guide")) do
			if v.code~=0 then
				use_guide_item[v.code] = v.code
			elseif v.type~=0 and v.sub_type~=0 then
				local list = self:get_item_for_type(v.type,v.sub_type)
				for i,item in ipairs(list or {}) do
					use_guide_item[item.code] = {v.min_lv,v.max_lv}
				end
			end
		end
	end
	local level_limit = use_guide_item[code]
	if not level_limit then
		return
	end
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	return lv>=level_limit[1] and lv <= level_limit[2]
end

return BagUserData