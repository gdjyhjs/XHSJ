--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-20 09:25:33
--]]
print("市场工具初始化")
local MarketTools = {}

local BagUserData = require("models.bag.bagUserData")

local classification = {} -- 储存所遇分类[大类][小类] = 
local goods_item = {}
local market_type_data = ConfigMgr:get_config("market_type")
for k,v in pairs(market_type_data) do
	if not classification[v.type] then
		classification[v.type] = {name = v.type_name}
	end
	if not classification[v.type][v.sub_type] then
		classification[v.type][v.sub_type] = {name = v.sub_type_name,
											unit_type = v.unit_type,
											icon = v.icon,
											color = v.color,
											data = v,
											keys = {},} -- keys 是搜索关键词
	end
end
-- 给数组添加关键词
local item_data = ConfigMgr:get_config("item")
local prefix_data = ConfigMgr:get_config("equip_prefix")
local add_key = function(list,code)
	local data = item_data[code]
	goods_item[code] = data

	-- 如果是装备 包含所有前缀+装备名
	if data.type == ServerEnum.ITEM_TYPE.EQUIP then
		for i,v in ipairs(prefix_data) do
			if not list.prefix then
				list.prefix = {}
			end
			if not list.prefix[v.prefix_id] then
				list.prefix[v.prefix_id] = true
				list[#list+1] = {prefix = v.prefix_id,key = prefix_data[v.prefix_id].prefix_name.."·"}
				-- gf_print_table(list[#list],"添加前缀 "..prefix_data[v.prefix_id].prefix_name)
			end
			list[#list+1] = {prefix = v.prefix_id,protoId = code,key = string.format("%s·%s",prefix_data[v.prefix_id].prefix_name,data.name)}
			-- gf_print_table(list[#list],"一对")
		end
	end

	-- 如果是装备 不包含所有前缀+装备名
	-- if data.type == ServerEnum.ITEM_TYPE.EQUIP and not list.prefix then
	-- 	list.prefix = {}
	-- 	for i,v in ipairs(prefix_data) do
	-- 		list[#list+1] = {prefix = v.prefix_id,key = prefix_data[v.prefix_id].prefix_name}
	-- 	end
	-- end


	list[#list+1] = {protoId = code,key = data.name}
	-- gf_print_table(list[#list],"一对")
end	

local market_unit_type_data = ConfigMgr:get_config("market_unit_type")
for i,v in ipairs(market_unit_type_data) do -- 分类加入所包含的物品名 作为搜索关键词
	if v.item_code~=0 then
		add_key(classification[market_type_data[v.unit_type].type][market_type_data[v.unit_type].sub_type].keys,v.item_code)
	else
		local list = BagUserData:get_item_for_type(v.item_type,v.item_sub_type)
		for i,item in ipairs(list) do
			if item.bind==0 and (v.item_career == 0 or v.item_career == item.career) then
				if market_type_data[v.unit_type] then
					add_key(classification[market_type_data[v.unit_type].type][market_type_data[v.unit_type].sub_type].keys,item.code)
				else
					gf_error_tips("缺少市场类别"..v.unit_type)
				end				
			end
		end
	end
end

-- 获取可上架所有物品
function MarketTools:get_goods_item(code)
	print("是否可以上架",code, goods_item[code] and  goods_item[code].name or nil,(code and goods_item[code] or goods_item) and true or false)
	return code and goods_item[code]
end

 -- 获取大小类
function MarketTools:get_classification()
	return classification
end

-- 获取关键词
function MarketTools:get_keys(str,big_type,sub_type)
	local list = {}
	local keys = {}
	if sub_type and sub_type~=0 then
		for i,v in ipairs(classification[big_type][sub_type].keys) do
			if not keys[v.key] and string.find(v.key,str) then
				list[#list+1] = v
				keys[v.key] = v
			end
		end
	else
		for i,l in ipairs(classification[big_type]) do
			for i,v in ipairs(l.keys) do
				if not keys[v.key] and string.find(v.key,str) then
					list[#list+1] = v
					keys[v.key] = v
				end
			end
		end
	end
	return list,keys
end

-- 获取关键词库
function MarketTools:get_search(big_type,sub_type)
	print("获取关键词库",big_type,sub_type)
	local list = {}
	if sub_type and sub_type~=0 then
		for i,v in ipairs(classification[big_type][sub_type].keys) do
			list[v.key] = v
		end
	else
		for i,l in ipairs(classification[big_type]) do
			for i,v in ipairs(l.keys) do
				list[v.key] = v
			end
		end
	end
	return list
end

return MarketTools