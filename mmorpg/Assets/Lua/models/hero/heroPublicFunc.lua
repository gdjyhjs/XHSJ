local Enum = require("enum.enum")
local dataUse = require("models.hero.dataUse")
local dataUse1 = require("models.horse.dataUse")
require("models.hero.heroConfig")
function SetHeroQualityIcon(image,heroId)
	local dataUse = require("models.hero.dataUse")
	local heroType = dataUse.getHeroQuality(heroId)
	local tagIcon = dataUse.getHeroQualityIcon(heroType)
	gf_setImageTexture(image,tagIcon)
end

--设置武将装备
--@pNode  装备节点的父节点
--@heroEquipInfo    {{[装备类型(97,98,99)] = 装备},}
--@child_name       装备节点的名字
function SetHeroEquipView(pNode,heroEquipInfo,child_name)
	local index = 1            
	for i=Enum.HERO_EQUIP_TYPE.BEGIN,Enum.HERO_EQUIP_TYPE.END - 1,1 do
		local item = pNode.transform:FindChild(child_name..index)
		if heroEquipInfo[i] then
			item.transform:FindChild("icon").gameObject:SetActive(true)
			item.transform:FindChild("filled").gameObject:SetActive(false)
			item.transform:FindChild("bg").gameObject:SetActive(false)
			gf_set_item(heroEquipInfo[i].protoId, item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image), item:GetComponent(UnityEngine_UI_Image))
		else
			gf_setImageTexture(item:GetComponent(UnityEngine_UI_Image), "item_color_0")
			item.transform:FindChild("filled").gameObject:SetActive(true)
			item.transform:FindChild("icon").gameObject:SetActive(false)
			item.transform:FindChild("bg").gameObject:SetActive(true)
		end
		index = index + 1
	end
	
end

--设置属性
function SetHeroProperty(heroId,pnode,property)
	local propertyInfo = dataUse.getHeroProperty(heroId)
	local p_refer = pnode:GetComponent("Hugula.ReferGameObjects")
	for i,v in ipairs(propertyInfo) do
		p_refer:Get(i).text = ConfigMgr:get_config("propertyname")[v[1]].name
		p_refer:Get(12+i).text = math.floor(property[v[1]])
	end
end


function SetHeroList(pItem,copyItem,data,name,empty_name,lock_name)
	local itemList = {}
	local heroList =  data and data or gf_getItemObject("hero"):getFightIdList()
	local total_unlock_count = gf_getItemObject("hero"):getHeroPrepareSize()
	local hero_attack_count = dataUse.getHeroAttackCount()
	local effectFrontId = gf_getItemObject("hero"):getEffectiveId()
	local fightId = gf_getItemObject("hero"):getFightId()
	
	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	for i,value in ipairs(heroList or {}) do

		local v = gf_getItemObject("hero"):getHeroInfo(value)

		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)
		cItem.name = (name or "hero_item_fight")..v.heroId

		cItem.transform:FindChild("bg").gameObject:SetActive(true)
		--头像
		cItem.transform:FindChild("head").gameObject:SetActive(true)	
		gf_setImageTexture(cItem.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image), dataUse.getHeroHeadIcon(v.heroId) or "img_wujiang_head_content_01")
		
		--名字
		if cItem.transform:FindChild("txtName") then
			cItem.transform:FindChild("txtName"):GetComponent("UnityEngine.UI.Text").text = dataUse.getHeroName(v.heroId)
		end

		--等级
		cItem.transform:FindChild("level").gameObject:SetActive(true)
		cItem.transform:FindChild("level").transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = string.format("Lv. %d",v.level)

		local heroType = dataUse.getHeroQuality(v.heroId)
		--类型
		-- local tag = dataUse.getHeroIcon(heroType)
		-- local tag_node = cItem.transform:FindChild("hero_grade_high")
		-- tag_node.gameObject:SetActive(true)
		-- local tag_icon = tag_node:GetComponent(UnityEngine_UI_Image)
		-- gf_setImageTexture(tag_icon, tag)

		--品质框
		local qualityIcon = dataUse.getHeroQualityIcon(heroType)
		local bgImage = cItem.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(bgImage,qualityIcon)

		--如果在生效阵法中 可以优化数据数据结构
		-- local heroHoleInfo = gf_getItemObject("hero"):getHeroHoleData(v.heroId)

		-- if effectFrontId > 0 and heroHoleInfo then
		-- 	local bgImage = cItem.transform:FindChild("Image (1)")
		-- 	bgImage.gameObject:SetActive(true)
		-- 	local nameText = bgImage.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
		-- 	nameText.text = dataUse.getHoleDataByIndex(effectFrontId,heroHoleInfo.posId,heroHoleInfo.level).name
		-- end

		--如果是出战武将 设置为选中
		if fightId == v.heroId then
			cItem.transform:FindChild("Image").gameObject:SetActive(true)	
		else
			cItem.transform:FindChild("Image").gameObject:SetActive(false)		
		end

		--如果有锁 隐藏
		if cItem.transform:FindChild("lock") then
			cItem.transform:FindChild("lock").gameObject:SetActive(false)
		end

		local temp = {}
		temp.heroId = v.heroId 
		temp.item = cItem
		itemList[i] = temp
	end

	--未出战武将 
	for i=1,total_unlock_count - #heroList do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.name = empty_name or "hero_item_empty"
		cItem.transform:FindChild("level").gameObject:SetActive(false)
		cItem.gameObject:SetActive(true)
		if cItem.transform:FindChild("mask") then
			cItem.transform:FindChild("mask").gameObject:SetActive(true)
		end
		--名字
		if cItem.transform:FindChild("txtName") then
			cItem.transform:FindChild("txtName"):GetComponent("UnityEngine.UI.Text").text = ""
		end
	end
	--未解锁栏位
	for i=1,hero_attack_count - total_unlock_count do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.transform:FindChild("level").gameObject:SetActive(false)
		cItem.name = lock_name or "hero_item_lock"
		cItem.gameObject:SetActive(true)
		cItem.transform:FindChild("lock").gameObject:SetActive(true)
		--名字
		if cItem.transform:FindChild("txtName") then
			cItem.transform:FindChild("txtName"):GetComponent("UnityEngine.UI.Text").text = ""
		end
	end


	return itemList
end

--@data1 当前天赋
--@data2 当前天赋上限
function SetHeroTalent(pNode,data1,data2,hero_id)
	local width,height = 168.32,10
	local heroInfo = gf_getItemObject("hero"):getHeroInfo(hero_id)
	
	local powerPanel = pNode.transform:FindChild("power")
	local strenghtPanel = pNode.transform:FindChild("strenght")
	local spiritePanel = pNode.transform:FindChild("spirite")
	local talentPanel = pNode.transform:FindChild("talent")

	local image1 = powerPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text1 = powerPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	local image2 = strenghtPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text2 = strenghtPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	local image3 = spiritePanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text3 = spiritePanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")
	
	--天资
	local image4 = talentPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text4 = talentPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	if not hero_id then
		image1.fillAmount = 1
		text1.text = string.format("%d/%d",0,0)
		image2.fillAmount = 1
		text2.text = string.format("%d/%d",0,0)
		image3.fillAmount = 1
		text3.text = string.format("%d/%d",0,0)
		image4.fillAmount = 1
		text4.text = string.format("%d/%d",0,0)
		return
	end

	local rate = 1

	--武力
	local power = data2[ServerEnum.HERO_TALENT_TYPE.FORCE]
	local maxValue = power[2] - power[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.FORCE] - power[1]
	print("minValue maxValue:",minValue,maxValue)
	image1.fillAmount = minValue / (maxValue * rate)
	text1.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.FORCE],power[2] * rate)

	--体魄
	local power = data2[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]
	local maxValue = power[2] - power[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE] - power[1]
	image2.fillAmount = minValue / (maxValue * rate)
	text2.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE],power[2] * rate)

	--灵力
	local power = data2[ServerEnum.HERO_TALENT_TYPE.FLEXABLE]
	local maxValue = power[2] - power[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.FLEXABLE] - power[1]
	image3.fillAmount = minValue / (maxValue * rate)
	text3.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.FLEXABLE],power[2] * rate)

	--天赋 
	local power = data2[ServerEnum.HERO_TALENT_TYPE.MULTIPLE]
	local maxValue = power[2] - power[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.MULTIPLE] - power[1]
	image4.fillAmount = minValue / (maxValue * rate)
	text4.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.MULTIPLE],power[2] * rate)
end

function SetSkillIcon(skill_id,icon,bg)
	local dataUse1 = require("models.horse.dataUse")
	local icon_res = dataUse1.get_skill_icon(skill_id)
	gf_setImageTexture(icon, icon_res)

	local color = dataUse1.get_skill_color(skill_id)
	gf_set_quality_bg(bg,color)
end

function gf_set_skill_panel(heroId,skill_data,pItem,copyItem)
	

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

  	local commomString = 
	{
		[10] = gf_localize_string("100级开启"),
		[11] = gf_localize_string("觉醒1级开启"),
		[12] = gf_localize_string("觉醒2级开启"),
		
	}

  	-- gf_print_table(skill_data, "wtf skill_data :")
  	for i,v in ipairs(skill_data or {}) do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)
		cItem.name = "hero_skill_"..i.."_"..heroId
		cItem.transform:FindChild("Image").gameObject:SetActive(false)
		if v.type == 0 then
			if dataUse.getOwnSkill(heroId) == v.skill then
				cItem.transform:FindChild("Image").gameObject:SetActive(true)
			end
			--替换技能icon
			cItem.transform:FindChild("icon").gameObject:SetActive(true)
			gf_set_hero_skill(v.skill,cItem)

		elseif v.type == -1 then
			cItem.transform:FindChild("add").gameObject:SetActive(true)
		elseif v.type == 1 then
			cItem.transform:FindChild("Text").gameObject:SetActive(true)
			cItem.transform:FindChild("mask").gameObject:SetActive(true)
			cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = commomString[10]
		elseif v.type == 2 then
			cItem.transform:FindChild("Text").gameObject:SetActive(true)
			cItem.transform:FindChild("mask").gameObject:SetActive(true)
			cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = commomString[11]
		elseif v.type == 3 then
			cItem.transform:FindChild("Text").gameObject:SetActive(true)
			cItem.transform:FindChild("mask").gameObject:SetActive(true)
			cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = commomString[12]
		end
	end
end

function gf_set_hero_skill(skill,item)
	local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
	local icon_res = dataUse1.get_skill_icon(skill)
	gf_setImageTexture(icon, icon_res)

	--品质
	local color = gf_get_config_table("skill")[skill].color
	local bg = item:GetComponent(UnityEngine_UI_Image)
	gf_setImageTexture(bg,"item_color_"..color)
end

--根据 战力高→品质高→等级高→觉醒高 排序
function HeroSort(hero_id_list)
	local function sort_(ai, bi)
		local r 	

		local a = type(ai) == "number" and ai or ai.heroId
		local b = type(bi) == "number" and bi or bi.heroId

		local a_info = gf_getItemObject("hero"):getHeroInfo(a)
		local b_info = gf_getItemObject("hero"):getHeroInfo(b)

		--战力
		local pa = gf_getItemObject("hero"):get_hero_power(a)
		local pb = gf_getItemObject("hero"):get_hero_power(b)
		--品质
		local ca = dataUse.getHeroQuality(a)
		local cb = dataUse.getHeroQuality(b)
		--等级
		local la = a_info.level
		local lb = b_info.level
		--觉醒等级
		local aa = a_info.awakenLevel
		local ab = b_info.awakenLevel

		--战力
		if  pa ~= pb then
			return pa > pb
		end
		--品质
	    if ca ~= cb then
	      	return ca > cb
	    end
    	if la ~= lb then
	      	return la > lb
      	end
		return aa > ab
		
	end   

	table.sort(hero_id_list,sort_)

	return hero_id_list
end

--shwo type 
function SetHeroModel(model,heroId,posy,type)
	local modelPanel = model.transform:FindChild("camera")
	if model.transform:FindChild("my_model") then
 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
 	end
		
	local callback = function(c_model)
		if model.transform:FindChild("my_model") then
	 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
	 	end
		c_model.name = "my_model"
	end

  	local scale = type == 1 and dataUse.getHeroScaleProperty(heroId) or type == 2 and dataUse.getHeroScaleList(heroId) or type == 4 and dataUse.getHeroScaleGet(heroId) or dataUse.getHeroScaleShow(heroId)
	local heroModel = dataUse.getHeroModel(heroId) or 420005
	local angle = dataUse.getHeroAngle(heroId)
	print("wtf angle is ",angle)
	local modelView = require("common.uiModel")(model.gameObject,Vector3(0,posy or -1.2,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,angle or 158,0),scale_rate = Vector3(scale,scale,scale)},callback)
end


