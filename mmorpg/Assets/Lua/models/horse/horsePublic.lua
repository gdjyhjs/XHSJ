local Enum = require("enum.enum")
local dataUse = require("models.horse.dataUse")
HORSE_TYPE = 
{
	normal 		= 0, 				--普通坐骑 升阶解锁
	ex 			= 1,				--特殊坐骑 道具解锁
	lovers		= 2,				--情侣坐骑
}

RIDE_STATE = 
{
	rest 			= 0 ,			--休息 
	riding 			= 1 ,			--骑乘
}

GROUP_TYPE = 
{
	normal = 1,			--使用一个
	onekey = 2,			--一键
}

HORSE_MAGIC_TYPE = 
{
	normal = 1,
	
}

HORSE_HOLE_LEVEL = 4 			--每个注灵孔位最高等级

HORSE_MEMORY_ITEM_COUNT = 18 		--记忆界面每页item数量


--12345下标对应增加的属性
SLOT_TO_PROPERTY = 
{
	[1] = ServerEnum.COMBAT_ATTR.ATTACK,
	[2] = ServerEnum.COMBAT_ATTR.PHY_DEF,
	[3] = ServerEnum.COMBAT_ATTR.MAGIC_DEF,
	[4] = ServerEnum.COMBAT_ATTR.HP,
	[5] = ServerEnum.COMBAT_ATTR.HIT,
}

HORSE_PROPERTY_NAME = 
{
	[1] = "attack",
	[2] = "physical_defense",
	[3] = "magic_defense",
	[4] = "hp",
	[5] = "dodge", 
}
HORSE_PROPERTY_NAME2 = 
{
	[1] = "attack",
	[2] = "physical_defense",
	[3] = "magic_defense",
	[4] = "hp",
	[5] = "hit", 
}
HORSE_PROPERTY_NAME_CH = 
{
	[1] = "攻击",
	[2] = "物防",
	[3] = "法防",
	[4] = "生命",
	[5] = "闪避", 
}
HORSE_PROPERTY_NAME_CH2 = 
{
	[1] = "攻击",
	[2] = "物防",
	[3] = "法防",
	[4] = "生命",
	[5] = "命中", 
}
function horse_set_item_icon(item,item_id,item_data)
	local item_bg = item:GetComponent(UnityEngine_UI_Image)
	local item_icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
	gf_set_item(item_id,item_icon,item_bg)

	--count
	local count = 0
	for i,v in ipairs(item_data) do
		count = count + v.item.num
	end

	local str = "<color=%s>%d</color>"
	local color = count > 0 and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
	
	local text_node = item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
	text_node.text = string.format(str,color,count)

end


function get_soul_property_add(soul_type,level)
	local temp = 
	{
		attack 				= 0,
		physical_defense 	= 0,
		magic_defense 		= 0,
		hp 					= 0,
		dodge 				= 0,
	}
	for i=1,level do
		local soul_data = dataUse.get_soul_data_by_level(soul_type,i)
		for k,v in pairs(temp) do
			temp[k] = temp[k] + soul_data[k]
		end
	end
	
	return temp
end
function get_soul_property_add2(soul_type,level)
	local temp = 
	{
		attack 				= 0,
		physical_defense 	= 0,
		magic_defense 		= 0,
		hp 					= 0,
		hit 				= 0,
	}
	for i=1,level do
		local soul_data = dataUse.get_soul_data_by_level(soul_type,i)
		for k,v in pairs(temp) do
			temp[k] = temp[k] + soul_data[k]
		end
	end
	
	return temp
end
function set_model_view(id,model,posx,posy,scale)
	-- local modelPanel = model.transform:FindChild("camera")
	-- for i=1,modelPanel.transform.childCount do
 --  		local go = modelPanel.transform:GetChild(i - 1).gameObject
	-- 	LuaHelper.Destroy(go)
 --  	end
 	if model.transform:FindChild("my_model") then
 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
 	end
 	
	local heroModel = dataUse.getHorseModel(id)  
	local scale = scale or dataUse.get_horse_scale(id)

	local callback = function(c_model) 
		if model.transform:FindChild("my_model") then
		 	LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
		 end
		c_model.name = "my_model"
		local effect_cb = function( effect, key )
			print("add effect wtf ")
			effect:set_parent(c_model.transform)
			effect.root.transform.localPosition = Vector3(0, 0, 0)
			effect.root.transform.localScale = Vector3(1, 1, 1)
			effect.root.transform.localRotation = Vector3(0, 0, 0)
			LuaHelper.SetLayerToAllChild(effect.transform, ClientEnum.Layer.UI)
			effect:show()
		end
		local effect_data = gf_getItemObject("horse"):get_horse_effect(id)
		gf_print_table(effect_data, "wtf effect_data:")
		if next(effect_data) then
			local effectId = effect_data[1][1]
			if not effect_data[1][2] then
				print("effectId:",effectId)
				local Effect = require("common.effect")
				Effect(effectId..".u3d", effect_cb)
			end
			
			
		end
		
	end

	local modelView = require("common.uiModel")(model.gameObject,Vector3(posx or 0.3,posy or -1.037,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,-142.3953,0),scale_rate=Vector3(scale,scale,scale)},callback)
	return modelView
end
