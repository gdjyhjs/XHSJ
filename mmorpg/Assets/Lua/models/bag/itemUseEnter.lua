--道具使用跳转 会返回是否关闭背包
--@item protoId 物品原形id
local Enum = require("enum.enum")

local function enter(protoId,guid)
	print("guid:",guid)
	local bt,st = gf_getItemObject("bag"):get_type_for_protoId(protoId)

	--宝石
	if bt == Enum.ITEM_TYPE.GEM then
		local equip = LuaItemManager:get_item_obejct("equip")
		equip:set_open_mode(3)
		equip:add_to_state()
		return true

	-- --强化石
	-- elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.ENHANCE_MATERIAL then
	-- 	local equip = LuaItemManager:get_item_obejct("equip")
	-- 	equip:set_open_mode(1,1)
	-- 	equip:add_to_state()
	-- 	return true

	--洗练石
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.POLISTH_MATERIAL then
		local equip = LuaItemManager:get_item_obejct("equip")
		equip:set_open_mode(4)
		equip:add_to_state()
		return true

	--陨铁（打造用材料）
	elseif bt == Enum.ITEM_TYPE.PROP and (st == Enum.PROP_TYPE.EQUIP_MATERIAL
		or st == Enum.PROP_TYPE.FORMULA_EQUIP_BASE_COLOR
		or st == Enum.PROP_TYPE.EQUIP_STAR_STONE) then
		local equip = LuaItemManager:get_item_obejct("equip")
		equip:set_open_mode(2)
		equip:add_to_state()
		return true

	--天命突破石
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.BREAK_THROUGH then
		local player = LuaItemManager:get_item_obejct("player")
		player:select_player_page(3)
		player:add_to_state()
		return true

	--喇叭
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.SPEAKER then
		require("models.chat.trumpet")(LuaItemManager:get_item_obejct("chat"))
		return false

	--洗炼书
	elseif bt == Enum.ITEM_TYPE.PROP and (st == Enum.PROP_TYPE.POLISH_HERO or st == Enum.PROP_TYPE.POLISH_HERO_LOCK_SKILL ) then

		gf_create_model_view("hero",ClientEnum.HERO_VIEW.BATTLE,ClientEnum.HERO_SUB_VIEW.HEROWASH)
		return true
	
	--给武将加经验的书
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HERO_EXP_BOOK then
		
		gf_create_model_view("hero")
		return true
	
	--技能书
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HERO_SKILL_BOOK then
		
		gf_create_model_view("hero")
		return true
	
	--给武将增加槽的道具
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.UNLOCK_HERO_SLOT then
		
		gf_create_model_view("hero")
		return true

	--给武将阵位开槽的道具
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.UNLOCK_HERO_SQUARE then
		gf_create_model_view("hero",ClientEnum.HERO_VIEW.FRONT)
		return true
 
	--给武将唤魂的道具
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.WAKE_HERO then
		gf_create_model_view("hero",ClientEnum.HERO_VIEW.LIST)
		return true

	--召唤武将的道具
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.RAND_GIFT_HERO then
		
		require("models.hero.heroCallupView")()
		return true

	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HORSE_FROM_ITEM  then
		print("wtf =====")
		local item_data = gf_getItemObject("itemSys"):get_item_for_id(protoId)	--根据原型id获取宝石物品数据
		local horse_id = item_data.effect[1]
		local items = item_data.effect_ex
		local item_str = ""
		-- for i,v in ipairs(items or {}) do
		local item_name =  gf_getItemObject("itemSys"):get_item_for_id(items[1]).name
		item_str = item_str .. string.format("<color=#B01FE5>%s</color>*",item_name) .. items[2]
		-- end
		local horse_name = require("models.horse.dataUse").getHorseName(horse_id)
		local str = string.format(gf_localize_string("<color=#B01FE5>%s</color>已被激活，是否将此道具兑换成"),horse_name)..item_str
		--判断是否已经有这个坐骑了 有则提示兑换
		if gf_getItemObject("horse"):get_is_unlock(horse_id) then
			local function sure_func()
				gf_getItemObject("bag"):use_item_c2s(guid,1,protoId)
			end
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(str,sure_func,nil,"兑换")
			return
		end  
		-- gf_getItemObject("horse"):set_arg("horse_commont_magic","tag2",horse_id)
		gf_create_model_view("horse",ClientEnum.HORSE_VIEW.MAGIC,ClientEnum.HORSE_SUB_VIEW.SPECIAL,horse_id)
		return true

	--天赋石头 

	elseif 	(bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.ADD_HERO_TALENT_FORCE) then
		-- gf_getItemObject("hero"):set_arg("talentGroup",Enum.HERO_TALENT_TYPE.FORCE)
		-- gf_getItemObject("hero"):set_view_param(1)
		-- gf_create_model_view("hero") 
		gf_create_model_view("hero",ClientEnum.HERO_VIEW.BATTLE,ClientEnum.HERO_SUB_VIEW.TALENTGROUP,Enum.HERO_TALENT_TYPE.FORCE)

		return true
	elseif 	(bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.ADD_HERO_TALENT_PHYSIQUE) then
		-- gf_getItemObject("hero"):set_arg("talentGroup",Enum.HERO_TALENT_TYPE.PHYSIQUE)
		-- gf_getItemObject("hero"):set_view_param(1)
		-- gf_create_model_view("hero") 

		gf_create_model_view("hero",ClientEnum.HERO_VIEW.BATTLE,ClientEnum.HERO_SUB_VIEW.TALENTGROUP,Enum.HERO_TALENT_TYPE.PHYSIQUE)


		return true
	elseif 	(bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.ADD_HERO_TALENT_FLEXABLE) then
		-- gf_getItemObject("hero"):set_arg("talentGroup",Enum.HERO_TALENT_TYPE.FLEXABLE)
		-- gf_getItemObject("hero"):set_view_param(1)
		-- gf_create_model_view("hero") 

		gf_create_model_view("hero",ClientEnum.HERO_VIEW.BATTLE,ClientEnum.HERO_SUB_VIEW.TALENTGROUP,Enum.HERO_TALENT_TYPE.FLEXABLE)


		return true
	elseif 	(bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.ADD_HERO_TALENT_MULTIPLE) then
		-- gf_getItemObject("hero"):set_arg("talentGroup",Enum.HERO_TALENT_TYPE.MULTIPLE)
		-- gf_getItemObject("hero"):set_view_param(1)
		-- gf_create_model_view("hero") 
		gf_create_model_view("hero",ClientEnum.HERO_VIEW.BATTLE,ClientEnum.HERO_SUB_VIEW.TALENTGROUP,Enum.HERO_TALENT_TYPE.MULTIPLE)

		return true
			
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HORSE_STAGE_UP  then
		gf_create_model_view("horse")
		return true
		
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HORSE_FOOD  then
		gf_create_model_view("horse",ClientEnum.HORSE_VIEW.FEED,ClientEnum.HORSE_SUB_VIEW.ITEM_FEED)
		return true

	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HORSE_SOUL_ITEM  then
		gf_create_model_view("horse",ClientEnum.HORSE_VIEW.MAGIC,ClientEnum.HORSE_SUB_VIEW.SOUL)
		return true

	-- 提升修炼的道具
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.ALLIANCE_TRAIN_ITEM  then
		gf_getItemObject("legion"):create_view(ClientEnum.LEGION_VIEW.GIFT)

	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.ALLIANCE_BOSS_FOOD  then
		gf_getItemObject("legion"):create_view(ClientEnum.LEGION_VIEW.ACTIVEITY,ClientEnum.LEGION_SUB_VIEW.BOSS)

	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.FLOWER  then
		-- 鲜花
		gf_getItemObject("gift"):show_view(nil,protoId)
		
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.TREASURE_KEY  then
		-- 寻宝钥匙
		LuaItemManager:get_item_obejct("luckyDraw"):open()
		return true
		
	-- 外观
	elseif bt == Enum.ITEM_TYPE.PROP and 
		(st == Enum.PROP_TYPE.SURFACE_CLOTHES
		or st == Enum.PROP_TYPE.SURFACE_WEAPON 
		or st == Enum.PROP_TYPE.SURFACE_CARRY_ON_BACK 
		or st == Enum.PROP_TYPE.SURFACE_SURROUND 
		or st == Enum.PROP_TYPE.SURFACE_TALK_BG 
		or st == Enum.PROP_TYPE.SURFACE_TRACE 
		or st == Enum.PROP_TYPE.SURFACE_GRADE_UP_ITEM)
		then
		local Surface = LuaItemManager:get_item_obejct("surface")
		local surface_id = ConfigMgr:get_config("item")[protoId].effect[1]
		if Surface:is_unlock( surface_id ) then
			local itemSys = LuaItemManager:get_item_obejct("itemSys")
			local data1 = ConfigMgr:get_config("item")[protoId]
			local name1 = data1.name
			local color1 = itemSys:get_item_color(data1.color)
			local data2 = ConfigMgr:get_config("item")[data1.effect_ex[1]]
			local name2 = data2.name
			local color2 = itemSys:get_item_color(data2.color)
			local count = data1.effect_ex[2]
			local str = string.format(gf_localize_string(
				"<color=%s>[%s]</color>已解锁，确定要将其分解成<color=%s>%d个[%s]</color>吗？"),
			color1,name1,color2,count,name2)
			local function sure_func()
				gf_getItemObject("bag"):use_item_c2s(guid,1,protoId)
			end
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(str,sure_func,nil,"分解")
			return false
		else
			Surface:open_view(surface_id)
			return true
		end
	elseif bt == ServerEnum.ITEM_TYPE.PROP and st == ServerEnum.PROP_TYPE.NAME_CHANGE_CARD then
		local color = LuaItemManager:get_item_obejct("itemSys"):get_item_for_id(protoId).color
		if color == 3 then
			local Player = LuaItemManager:get_item_obejct("player")
			Player:change_name_tip()
		elseif color == 4 then
			local Legion = LuaItemManager:get_item_obejct("legion")
			Legion:change_name_tip()
		end
	end

			return true
end

return enter