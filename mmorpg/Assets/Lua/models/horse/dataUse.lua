local horse_data = ConfigMgr:get_config("horse")
local level_data = ConfigMgr:get_config("horse_level")
local soul_data = ConfigMgr:get_config("horse_soul_level")
local feed_data = ConfigMgr:get_config("horse_feed_level")
local skill_data = ConfigMgr:get_config("skill")
local mail_data = ConfigMgr:get_config("goods")

local dataUse = 
{
	get_horse_by_type 					= nil,				--根据类型获取坐骑
	get_horse_next_and_front 			= nil,				--获取坐骑上一个和下一个坐骑
	get_horse_soul_type 				= nil,				--根据类型获取坐骑
	getHorseName  						= nil,				--获取坐骑名字
	getHorseModel 						= nil,				--获取坐骑模型
	get_horse_speed 					= nil,				--获取坐骑速度
	get_horse_type  					= nil,				--获取坐骑类型
	get_horse_star_by_level 			= nil,				--根据等级获取坐骑星阶
	get_transform_exp	 				= nil,				--转换总经验
	get_horse_level_info 				= nil,				--获取坐骑解锁的那个等级数据
	get_max_level 						= nil,				--获取坐骑最大等级
	get_total_property_info_bylevel 	= nil,				--获取累加属性加成	
	get_exp_by_level 					= nil,				--获取坐骑该等级升级所需的经验值
	get_top_unlock_horse 				= nil,				--根据等级获取最高解锁的坐骑形象 
	get_horse_item_id 		 			= nil,				--获取可以开出次坐骑的道具
	get_soul_data_by_level				= nil,				--根据等级获取封灵数据
	get_soul_max_level 					= nil,				--获取封灵最高等级
	get_feed_exp 						= nil,				--获取喂养经验
	get_feed_max_level 					= nil,				--获取喂养最高等级
	get_feed_skill 						= nil,				--获取此等级拥有的技能
	get_skill_icon 						= nil,				--获取技能icon
	get_skill_color 					= nil,				--获取技能color 	
	get_skill_name 						= nil,				--获取技能name
	get_level_unlock_skill 				= nil,				--获取每个等级解锁的技能
	get_level_and_left_exp 				= nil,				--获取等级和剩余经验
	get_total_exp						= nil,				--获取总经验值
	get_group_item 						= nil,				--获取升阶需要的道具
	get_goods_by_item_id 				= nil,				--根据itemid获取货物id 
	get_horse_effect 					= nil,				--根据id获取坐骑的特效
	get_horse_scale 					= nil,				--根据id获取坐骑的模型缩放比
	get_horse_level_string 				= nil,				--获取坐骑中文等级显示
}



dataUse.get_horse_level_string = function(level)
	local star_count,stage_level = dataUse.get_horse_star_by_level(level)
	return string.format(gf_localize_string("%d阶%d星"),stage_level,star_count)
end

dataUse.get_skill_data= function(id)
	local data = skill_data[id]
	if data then
		return data
	end
	print("error 没有技能数据 id :",id)
end
dataUse.get_horse_data= function(id)
	local data = horse_data[id]
	if data then
		return data
	end
	print("error 没有坐骑数据 id :",id)
end
dataUse.get_feed_data= function(level)
	local data = feed_data[level]
	if data then
		return data
	end
	print("error 没有喂养数据 level:",level)
end

dataUse.get_feed_total_property_add = function(level)

	local property = 
	{
		attack					=		0,
		physical_defense		=		0,
		magic_defense			=		0,
		hp						=		0,
		dodge					=		0,
	}
	for i=1,level do
		local data = dataUse.get_feed_data(i)
		for k,v in pairs(property) do
			property[k] = property[k] + data[k]
		end
	end

	gf_print_table(property, "wtf property:")

	return property
end



dataUse.get_level_data= function(level)
	local data = level_data[level]
	if data then
		return data
	end
	print("error 没有坐骑此等级数据 level :",level)
end

dataUse.getHorseName = function(id)
	return dataUse.get_horse_data(id).name
end
dataUse.get_group_item = function(level)
	return dataUse.get_level_data(level).need_item
end

dataUse.get_horse_soul_type = function(id)
	return dataUse.get_horse_data(id).soul_type
end

dataUse.get_horse_item_id = function(id)
	return dataUse.get_horse_data(id).item_id
end

dataUse.get_horse_speed = function(id)
	return dataUse.get_horse_data(id).speed
end
dataUse.get_horse_scale = function(id)
	return dataUse.get_horse_data(id).model_scale
end

dataUse.get_horse_type = function(id)
	return dataUse.get_horse_data(id).type
end
dataUse.getHorseModel = function(id)
	return dataUse.get_horse_data(id).model_id or "440006"
end
dataUse.get_horse_by_type = function(type)
	return dataUse.type_horse[type]
end

dataUse.get_horse_effect = function(id)
	local horse_info = dataUse.get_horse_data(id)
	if horse_info then
		--todo
	end 
	return {{"22310004a", ""}}
end

dataUse.get_max_level = function()
	return level_data[#level_data].level
end
dataUse.get_total_exp = function(level)
	local exp = 0
	for i=1,level do
		exp = exp + level_data[i].exp
	end
	return exp
end


dataUse.get_horse_level_info = function(id)
	local data = dataUse.level_horse
	for k,v in ipairs(data or {}) do
		if v.horse_id == id then
			return v
		end
	end
end
dataUse.get_total_property_info_bylevel = function(level)
	local property = 
	{
		attack				= 0 ,
		physical_defense	= 0 ,
		magic_defense		= 0 ,
		hp					= 0 ,
		dodge				= 0 ,
	}
	for i=1,level do
		local data = dataUse.get_level_data(i)
		for k,v in pairs(property) do
			property[k] = v + data[k]
		end
	end
	return property
end

dataUse.get_horse_star_by_level= function(level)
	local data = dataUse.get_level_data(level)
	return data.start_level,data.stage_level
end
dataUse.get_transform_exp= function(exp)
	for i,v in ipairs(level_data or {}) do
		if v.exp <= exp then
			exp = exp - v.exp
		else
			return v.level,exp,v.exp
		end	
	end
end
dataUse.get_horse_next_and_front = function(type,id)
	local data = dataUse.type_horse[type]
	for i,v in ipairs(data) do
		if id == v.horse_id then
			return {data[i-1],data[i+1]}
		end
	end
	return {}
end

dataUse.get_exp_by_level = function(level)
	local data = dataUse.get_level_data(level)
	return data.exp
end

dataUse.get_top_unlock_horse = function(level)
	local temp 
	for i,v in ipairs(dataUse.level_horse or {}) do
		if v.level > level then
			return temp
		end
		temp = v 
	end
	return temp
end

dataUse.get_soul_data_by_level = function(soul_type,level)
	assert(dataUse.reg_sour_data[soul_type][level],"没有此等级封灵数据 soul_type level:"..soul_type.." "..level)
	return dataUse.reg_sour_data[soul_type][level]
end
dataUse.get_soul_max_level = function(soul_type)
	assert(dataUse.reg_sour_data[soul_type],"没有此等级封灵数据 soul_type level:"..soul_type)
	local soul_data = dataUse.reg_sour_data[soul_type]
	return soul_data[#soul_data].level
end


dataUse.get_feed_exp = function(level)
	return dataUse.get_feed_data(level).exp
end

dataUse.get_feed_max_level = function()
	local max_level = 0
	for i,v in ipairs(feed_data or {}) do
		if v.level > max_level then
			max_level = v.level
		end
	end
	return max_level
end

dataUse.get_feed_skill = function(level)
	return dataUse.get_feed_data(level).skill
end
dataUse.get_skill_icon = function(id)
	local skill_data = dataUse.get_skill_data(id)
	return skill_data.icon
end
dataUse.get_skill_color = function(id)
	local skill_data = dataUse.get_skill_data(id)
	return skill_data.color
end
dataUse.get_skill_name = function(id)
	local skill_data = dataUse.get_skill_data(id)
	return skill_data.name
end
dataUse.get_level_and_left_exp = function(exp,c_level)
	c_level = c_level or 0
	local level = c_level 
	
	for i=c_level,dataUse.get_feed_max_level() do
		if exp >= feed_data[i].exp then
			level = level + 1
			exp = exp - feed_data[i].exp
		else
			return level,exp,feed_data[i].exp
		end
	end
	return level,exp
end


dataUse.get_level_unlock_skill = function()
	if dataUse.skill_level then
		return dataUse.skill_level
	end
	local skill_level = {}

	local function isNew(skills,skill_id)
		for i,v in ipairs(skills or {}) do
			if string.sub(v.skill,1,string.len(v.skill) - 3) == string.sub(skill_id,1,string.len(skill_id) - 3) then
				return false
			end
		end
		return true
	end

	for i=0,dataUse.get_feed_max_level() do
		local level_data  = dataUse.get_feed_skill(i)
		for ii,vv in ipairs(level_data or {}) do
			if isNew(skill_level,vv) then
				local temp = {}
				temp.level = i
				temp.skill = vv
				table.insert(skill_level,temp)
			end
		end
	end
	dataUse.skill_level = skill_level
	return dataUse.skill_level
end

dataUse.get_goods_by_item_id = function(item_id)
	local goods = dataUse.mail_item2goods[item_id]
	if next(goods or {}) then
		return goods
	end
	print("商城并没有卖次道具:",item_id)
end

dataUse.get_goods_by_items_id_ex = function(item_ids)
	local temp = {}
	table.sort(item_ids,function(a,b)return a > b end)
	for i,v in ipairs(item_ids) do
		local goods = dataUse.mail_item2goods[v]
		for ii,vv in ipairs(goods or {}) do
			table.insert(temp,vv)
		end
	end
	
	if next(temp or {}) then
		return temp
	end
	print("商城并没有卖次道具:",temp)
end

dataUse.get_goods_by_items_id = function(item_ids)
	local temp = {}
	table.sort(item_ids,function(a,b)return a.code > b.code end)
	for i,v in ipairs(item_ids) do
		local goods = dataUse.mail_item2goods[v.code]
		for ii,vv in ipairs(goods or {}) do
			table.insert(temp,vv)
		end
	end
	
	if next(temp or {}) then
		return temp
	end
	print("商城并没有卖次道具:",temp)
end


--转表
ex_table = function()
	if dataUse.type_horse then
		return
	end
	print("wtf 开始转表=============================================")
	
	--坐骑类型
	local type_horse = {}
	for k,v in pairs(horse_data) do
		if not type_horse[v.type] then
			type_horse[v.type] = {}
		end
		table.insert(type_horse[v.type],v)
	end

	for k,v in pairs(type_horse or {}) do
		table.sort(v,function(a,b)return a.horse_id < b.horse_id end)
	end
	
	--等级对应解锁坐骑
	local level_horse = {}
	for i,v in ipairs(level_data or {}) do
		if v.horse_id > 0 then
			-- level_horse[v.level] = v
			table.insert(level_horse,v)
		end
	end

	--注灵数据
	local reg_soul_data = {}
	for i,v in pairs(soul_data or {}) do
		if not reg_soul_data[v.soul_type] then
			reg_soul_data[v.soul_type] = {}
		end
		reg_soul_data[v.soul_type][v.level] = v
	end

	--商品表转表 
	local mail_item2goods = {}
	for i,v in pairs(mail_data or {}) do
		if not mail_item2goods[v.item_code] then
			mail_item2goods[v.item_code] = {}
		end
		--只添加 元宝类型商品 有需求再拓展 or v.base_res_type == ServerEnum.BASE_RES.BIND_GOLD
		if v.base_res_type == ServerEnum.BASE_RES.GOLD  then
			table.insert(mail_item2goods[v.item_code],v)
		end
		
	end
	dataUse.mail_item2goods = mail_item2goods

	-- local item_type2item_data = {}
	-- for k,v in pairs(item_data or {}) do
	-- 	if not item_type2item_data[v.type * 100000 + v.sub_type] then
	-- 		item_type2item_data[v.type * 100000 + v.sub_type] = {}
	-- 	end
	-- 	table.insert(item_type2item_data[v.type * 100000 + v.sub_type],v)
	-- end
	-- dataUse.item_type2item_data = item_type2item_data
	-- --记忆道具筛选
	-- local item_id_select 	= {}
	-- local item_type_select 	= {}
	-- for i,v in ipairs(table_name) do
	-- 	if v.code and v.code > 0 then
	-- 		table.insert(item_id_select,v)
	-- 	else
	-- 		table.insert(item_type_select,v)
	-- 	end
	-- end

	-- dataUse.item_id_select   	= item_id_select 
	-- dataUse.item_type_select 	= item_type_select
	dataUse.reg_sour_data   	= reg_soul_data 
	dataUse.level_horse 		= level_horse
	dataUse.type_horse 			= type_horse

end 
ex_table()

return dataUse