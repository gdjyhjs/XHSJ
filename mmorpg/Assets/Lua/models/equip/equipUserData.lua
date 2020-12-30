--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-29 16:24:45
--]]

local EquipUserData = {}
local Enum = require("enum.enum")
local BagUserData = require("models.bag.bagUserData")

--宝石类型下拉框值
local gem_type_dropdown_value = {
	[0]=Enum.GEM_TYPE.ATTACK,
	[1]=Enum.GEM_TYPE.HP,
	[2]=Enum.GEM_TYPE.PHY_DEF,
	[3]=Enum.GEM_TYPE.MAGIC_DEF,
	[4]=Enum.GEM_TYPE.CRIT,
	[5]=Enum.GEM_TYPE.HIT,
	[6]=Enum.GEM_TYPE.DODGE,
	[7]=Enum.GEM_TYPE.THROUGH,
	[8]=Enum.GEM_TYPE.CRIT_DEF,
}
--宝石等级下拉框值
local gem_level_dropdown_value = {
	[0]=2,
	[1]=3,
	[2]=4,
	[3]=5,
	[4]=6,
	[5]=7,
	[6]=8,
	[7]=9,
	[8]=10,
}

--装备类型名称
local equip_type_name = {
	[Enum.EQUIP_TYPE.WEAPON] = gf_localize_string("武器"),
	[Enum.EQUIP_TYPE.CAP] = gf_localize_string("头盔"),
	[Enum.EQUIP_TYPE.HELMET] = gf_localize_string("铠甲"),
	[Enum.EQUIP_TYPE.BELT] = gf_localize_string("腰带"),
	[Enum.EQUIP_TYPE.BOOTS] = gf_localize_string("鞋靴"),
	[Enum.EQUIP_TYPE.SHOULDER_HELMET] = gf_localize_string("肩甲"),
	[Enum.EQUIP_TYPE.BRACERS] = gf_localize_string("护腕"),
	[Enum.EQUIP_TYPE.NECKLACE] = gf_localize_string("项链"),
	[Enum.EQUIP_TYPE.RING] = gf_localize_string("戒指"),
	[Enum.EQUIP_TYPE.WEDDING_RING] = gf_localize_string("婚戒"),
}

--打造装备等级下拉框的值对应的装备等级、
local formula_equip_dropdown_value = {}

local formula_equip_list = {}

local game = LuaItemManager:get_item_obejct("game")
local career = game:getRoleInfo().career
local item_data = ConfigMgr:get_config("item")
for k,v in pairs(ConfigMgr:get_config( "equip_formula" )) do
	if v.is_play_formula==1 and item_data[v.code].career == career then
		if not formula_equip_list[v.level] then
			formula_equip_list[v.level] = {}
			formula_equip_dropdown_value[#formula_equip_dropdown_value+1] = v.level
		end
		-- print("打造表",v.level,item_data[v.code].sub_type)
		formula_equip_list[v.level][ConfigMgr:get_config("item")[v.code].sub_type] = v
	end
	if DEBUG then
		local data = item_data[v.code]
		print("打造id",v.formulaId,"名称",data.name,"是否由玩家打造", v.is_play_formula==1,"职业是否相符",data.career==career)
	end
end
-- print("排列")
for k,v in pairs(formula_equip_list) do
	table.sort(v,function(a,b) return a.formulaId<b.formulaId end)
end
table.sort(formula_equip_dropdown_value,function(a,b)return a<b end)

-- 初始化读取配置文件 获取装备属性取值空间
local polish_attr_interval = {}

for i,v in ipairs(ConfigMgr:get_config("equip_polish")) do
	if v.career == career then
		if not polish_attr_interval[v.level] then
			polish_attr_interval[v.level] = {}
		end
		if not polish_attr_interval[v.level][v.equip_type] then
			polish_attr_interval[v.level][v.equip_type] = {}
		end
		for i,attrs in ipairs(v.attr) do
			polish_attr_interval[v.level][v.equip_type][attrs[2]] = {attrs[3],attrs[4]}
		end
	end
end

--获取宝石类型下拉框的值
function EquipUserData:get_gem_type_dropdown_value(value)
	return gem_type_dropdown_value[value]
end

--获取宝石等级下拉框的值
function EquipUserData:gem_level_dropdown_value(value)
	return gem_level_dropdown_value[value]
end

--获取装备穿戴部位的部位名称
function EquipUserData:get_equip_type_name(value)
	return equip_type_name[value] or ""
end

--获取装备打造列表
function EquipUserData:get_formula_equip_list(lv)
	return lv and formula_equip_list[lv] or formula_equip_list
end

--获取打造装备等级下拉框的值对应的装备等级
function EquipUserData:get_formula_equip_dropdown_value(value)
	return value and (formula_equip_dropdown_value[value+1] or -1) or formula_equip_dropdown_value
end

--获取与自身等级最匹配的下拉索引
function EquipUserData:get_def_value()
	local result = -1
	for i,v in ipairs(formula_equip_dropdown_value) do
		if v<=game:getRoleInfo().level then
			result = i-1
		end
	end
	return result
end

local auxiliary_material_list = nil
--获取对应等级的保底材料
function EquipUserData:get_auxiliary_material(lv)
	if not auxiliary_material_list then
		local itemSys = LuaItemManager:get_item_obejct("itemSys")
		local list = BagUserData:get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.FORMULA_EQUIP_BASE_COLOR)
		auxiliary_material_list = {}
		for i,v in ipairs(list) do
			if not auxiliary_material_list[v.item_level] then
				auxiliary_material_list[v.item_level] = {}
			end
			if not itemSys:calculate_item_is_bind(v.code) then
				auxiliary_material_list[v.item_level][#auxiliary_material_list[v.item_level]+1] = v.code
			end
		end
	end
	return auxiliary_material_list[lv] or {}
end

-- 获取洗炼属性区间
function EquipUserData:get_polish_attr_interval(level,equip_type,attr_type)
	return polish_attr_interval[level] and polish_attr_interval[level][equip_type] and polish_attr_interval[level][equip_type][attr_type] or {1,1}
end

return EquipUserData
