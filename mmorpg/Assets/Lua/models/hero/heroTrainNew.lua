--[[
	武将培养界面  属性
	create at 17.10.16
	by xin
]]
local dataUse = require("models.hero.dataUse")
local dataUse1 = require("models.horse.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_train.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("%d级"),
	[2] = gf_localize_string("100级开启"),
	[3] = gf_localize_string("觉醒1级开启"),
	[4] = gf_localize_string("觉醒2级开启"),
}
local color = 
{
	[1] = Color(113/255, 92/255, 72/255, 1),
	[2] = Color(132/255, 56/255, 19/255, 1),
}

local heroTrainNew = class(UIBase,function(self,hero_id)
	self.hero_id = hero_id
	self.heroInfo = gf_getItemObject("hero"):getHeroInfo(hero_id) 
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroTrainNew:on_asset_load(key,asset)
    self:init_ui()
end

function heroTrainNew:init_ui()
	self:setHeroEquipView()

	self:set_hero_view()

	--战力
	self:set_hero_power()

  	--exp
  	self:update_exp_view(self.hero_id)

  	self:showPanel("talent")

  	self:showHeroSkill()

  	self:update_awaken_button()
end

function heroTrainNew:update_awaken_button()
	local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	local chip = gf_getItemObject("hero"):getHeroLeftChip(self.hero_id)
	local max_data = dataUse.get_awake_max_data(self.hero_id)
	--如果还没觉醒满
	if max_data.awaken_level > hero_data.awakenLevel then
		local awake_info = dataUse.getHeroAwakeData(self.hero_id,hero_data.awakenLevel +1)
		self.refer:Get(18):SetActive(chip >= awake_info.chip_count)
	else
		self.refer:Get(18):SetActive(false)
	end

	--是否开发洗练
	local level = gf_getItemObject("game"):getLevel()
	self.refer:Get(19).interactable = gf_get_config_const("hero_wash_open_level") <= level  
end

function heroTrainNew:showHeroSkill()
	local skill_data = gf_getItemObject("hero"):get_hero_skill_slot(self.hero_id)
	local pItem = self.refer:Get(11)
	local copyItem = self.refer:Get(12)
	gf_set_skill_panel(self.hero_id,skill_data,pItem,copyItem)
	
	-- 
	-- 

	-- for i=1,pItem.transform.childCount do
 --  		local go = pItem.transform:GetChild(i - 1).gameObject
	-- 	LuaHelper.Destroy(go)
 --  	end
 --  	gf_print_table(skill_data, "wtf skill_data :")
 --  	for i,v in ipairs(skill_data or {}) do
	-- 	local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
	-- 	cItem.gameObject:SetActive(true)
	-- 	cItem.name = "hero_skill"..i
	-- 	cItem.transform:FindChild("Image").gameObject:SetActive(false)
	-- 	if v.type == 0 then
	-- 		if dataUse.getOwnSkill(self.hero_id) == v.skill then
	-- 			cItem.transform:FindChild("Image").gameObject:SetActive(true)
	-- 		end
	-- 		--替换技能icon
	-- 		cItem.transform:FindChild("icon").gameObject:SetActive(true)
	-- 		local icon = cItem.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
	-- 		local icon_res = dataUse1.get_skill_icon(v.skill)
	-- 		gf_setImageTexture(icon, icon_res)
	-- 	elseif v.type == -1 then
	-- 		cItem.transform:FindChild("add").gameObject:SetActive(true)
	-- 	elseif v.type == 1 then
	-- 		cItem.transform:FindChild("Text").gameObject:SetActive(true)
	-- 		cItem.transform:FindChild("mask").gameObject:SetActive(true)
	-- 		cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = commom_string[2]
	-- 	elseif v.type == 2 then
	-- 		cItem.transform:FindChild("Text").gameObject:SetActive(true)
	-- 		cItem.transform:FindChild("mask").gameObject:SetActive(true)
	-- 		cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = commom_string[3]
	-- 	elseif v.type == 3 then
	-- 		cItem.transform:FindChild("Text").gameObject:SetActive(true)
	-- 		cItem.transform:FindChild("mask").gameObject:SetActive(true)
	-- 		cItem.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = commom_string[4]
	-- 	end
	-- end
	
end

function heroTrainNew:showPanel(name)

	if name == "property" then
		self:showHeroProperty()

	elseif name == "talent" then
		self:showHeroTalent()

	end 
end


function heroTrainNew:showHeroProperty(name)
	print("showHeroProperty:",name)
	self:reset_button_view()
	self.refer:Get(6):SetActive(true)
	self.refer:Get(20).color = color[2]
	self.refer:Get(21):SetActive(true)

	local p_refer = self.refer:Get(10):GetComponent("Hugula.ReferGameObjects")
	if not self.hero_id then
		for i=1,12 do
			p_refer:Get(12+i).text = 0
		end
		return
	end

	local heroInfo = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	local propertyData = gf_getItemObject("hero"):getHeroProperty(self.hero_id)
	local propertyInfo = dataUse.getHeroProperty(heroInfo.heroId)
	for i,v in ipairs(propertyInfo) do
		p_refer:Get(i).text = ConfigMgr:get_config("propertyname")[v[1]].name
		p_refer:Get(12+i).text = math.floor(propertyData[v[1]])
	end

end


function heroTrainNew:showHeroTalent()
	self:reset_button_view()
	self.refer:Get(7):SetActive(true)
	self.refer:Get(22).color = color[2]
	self.refer:Get(23):SetActive(true)


	local width,height = 142.32,10
	local pNode = self.refer:Get(7)
	local heroInfo = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	
    local data1,data2 = dataUse.getHeroTalentIncludeAwake(self.hero_id,heroInfo.talent,heroInfo.awakenLevel)

    SetHeroTalent(pNode,data1,data2,self.hero_id)

	-- local powerPanel = pNode.transform:FindChild("power")
	-- local strenghtPanel = pNode.transform:FindChild("strenght")
	-- local spiritePanel = pNode.transform:FindChild("spirite")
	-- local talentPanel = pNode.transform:FindChild("talent")

	-- local image1 = powerPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	-- local text1 = powerPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	-- local image2 = strenghtPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	-- local text2 = strenghtPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	-- local image3 = spiritePanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	-- local text3 = spiritePanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")
	
	-- --天资 
	-- local image4 = talentPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	-- local text4 = talentPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	-- if not self.hero_id then
	-- 	image1.fillAmount = 1
	-- 	text1.text = string.format("%d/%d",0,0)
	-- 	image2.fillAmount = 1
	-- 	text2.text = string.format("%d/%d",0,0)
	-- 	image3.fillAmount = 1
	-- 	text3.text = string.format("%d/%d",0,0)
	-- 	image4.fillAmount = 1
	-- 	text4.text = string.format("%d/%d",0,0)
	-- 	return
	-- end

	-- local rate = 1

	-- --武力
	-- local power = dataUse.getHeroTalentPower(heroInfo.heroId)
	-- local maxValue = power[2] - power[1]
	-- local minValue = heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.FORCE] - power[1]
	-- print("minValue maxValue wtf ",minValue,maxValue)
	-- image1.fillAmount = minValue / (maxValue * rate)
	-- text1.text = string.format("%d/%d",heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.FORCE],power[2] * rate)

	-- --体魄
	-- local power = dataUse.getHeroTalentStrength(heroInfo.heroId)
	-- local maxValue = power[2] - power[1]
	-- local minValue = heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE] - power[1]
	-- image2.fillAmount = minValue / (maxValue * rate)
	-- text2.text = string.format("%d/%d",heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE],power[2] * rate)

	-- --灵力
	-- local power = dataUse.getHeroTalentSpirit(heroInfo.heroId)
	-- local maxValue = power[2] - power[1]
	-- local minValue = heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.FLEXABLE] - power[1]
	-- image3.fillAmount = minValue / (maxValue * rate)
	-- text3.text = string.format("%d/%d",heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.FLEXABLE],power[2] * rate)
	-- --设置道具
	-- -- self:setItemView("talent")

	-- --天赋 
	-- local talent = dataUse.getHeroTalent(heroInfo.heroId)
	-- local maxValue = talent[2] - talent[1]
	-- local minValue = heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.MULTIPLE] - talent[1]
	-- image4.fillAmount = minValue / (maxValue * rate)
	-- text4.text = string.format("%d/%d",heroInfo.talent[ServerEnum.HERO_TALENT_TYPE.MULTIPLE],talent[2] * rate)

end

function heroTrainNew:reset_button_view()
	self.refer:Get(6):SetActive(false)
	self.refer:Get(7):SetActive(false)
	self.refer:Get(21):SetActive(false)
	self.refer:Get(23):SetActive(false)
	self.refer:Get(20).color = color[1]
	self.refer:Get(22).color = color[1]
end

function heroTrainNew:set_hero_view()
	local heroInfo = self.heroInfo
	local model = self.refer:Get(3)
	SetHeroModel(model,heroInfo.heroId,nil,1)
	--品质
	local heroType = dataUse.getHeroQuality(heroInfo.heroId)
	local iconName = dataUse.getHeroIcon(heroType)
	gf_setImageTexture(self.refer:Get(5),iconName )
	--名字 
	self.refer:Get(15).text = heroInfo.name ~= "" and heroInfo.name or dataUse.getHeroName(heroInfo.heroId)  
end

function heroTrainNew:update_exp_view()
	local heroInfo = self.heroInfo
	self.refer:Get(13).text = string.format(commom_string[1],heroInfo.level )
	print("heroInfo.exp / dataUse.getHeroLevelExp(heroInfo.level):",heroInfo.exp , dataUse.getHeroLevelExp(heroInfo.level))
	self.refer:Get(14).fillAmount = heroInfo.exp / dataUse.getHeroLevelExp(heroInfo.level)
	self.refer:Get(17).text = string.format("%d/%d",heroInfo.exp , dataUse.getHeroLevelExp(heroInfo.level))
end
function heroTrainNew:set_hero_power()
	local power = 0
	if self.hero_id then
		power = gf_getItemObject("hero"):get_hero_power(self.hero_id)
	end
	self.refer:Get(2).text = power

end
--设置武将装备
function heroTrainNew:setHeroEquipView()
	print("setHeroEquipView")
	local pNode = self.refer:Get(1)
	local heroEquipInfo = gf_getItemObject("hero"):getHeroEquip(self.hero_id)
	SetHeroEquipView(pNode, heroEquipInfo, "militayr_train_equip")

end

function heroTrainNew:rec_rename(msg)
	if msg.err == 0 and self.hero_id then
		if msg.heroId == self.hero_id then
			self.refer:Get(15).text = msg.name
		end
	end
end

--鼠标单击事件
function heroTrainNew:on_click( obj, arg)
	local event_name = obj.name
	print("heroTrainNew click",event_name)
    if event_name == "btn_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif string.find(event_name,"hero_check_") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local name = string.gsub(event_name,"hero_check_","")
    	self:showPanel(name)

    elseif event_name == "btnReset" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.hero.heroWash")(self.hero_id)

    elseif event_name == "train_btnAwaken" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local view = require("models.hero.heroAwaken")(self.hero_id)
    	local callback = function()
    		self:dispose()
    	end
    	view:set_load_callback(callback)
   	elseif event_name == "btnRebron" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.hero.heroReborn")(self.hero_id)

    elseif event_name == "btnEquip" or string.find(event_name,"militayr_train_equip") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local view = require("models.hero.heroEquip")(self.hero_id)
    	local callback = function()
    		self:dispose()
    	end
    	view:set_load_callback(callback)
    elseif event_name == "hero_rename" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if self.hero_id then
   			require("models.hero.heroRename")(self.hero_id)
   			return
   		end

   	elseif event_name == "train_hero_details" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		require("models.hero.heroDetails")(self.hero_id)
   		
   	elseif string.find(event_name,"talent_train_group") then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if self.hero_id then
   			local type = string.gsub(event_name,"talent_train_group","")
	    	type = tonumber(type)
	    	print("type :",type)
	   		require("models.hero.talentGroup")(self.hero_id,type)
   		end

   	elseif event_name == "hero_view_train" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if self.hero_id then
   			require("models.hero.expAdd")(self.hero_id)
   		end

   	end
end

function heroTrainNew:on_showed()
	StateManager:register_view(self)
end

function heroTrainNew:clear()
	StateManager:remove_register_view(self)
end

function heroTrainNew:on_hided()
	self:clear()
end
-- 释放资源
function heroTrainNew:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroTrainNew:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "RecycleHeroR") then
			self:init_ui()
		elseif id2 == Net:get_id2(model_name,"RenameHeroR") then
			self:rec_rename(msg)
		elseif id2 == Net:get_id2(model_name,"GainSkillByBookR") then
			self:showHeroSkill()
		elseif id2 == Net:get_id2(model_name,"SavePolishHeroR") then
			self:init_ui()

		elseif id2 == Net:get_id2(model_name,"AddHeroExpByBookR") then
			self:init_ui()

		elseif id2 == Net:get_id2(model_name,"AwakenHeroR") then
			self:update_awaken_button()
		
		elseif id2 == Net:get_id2(model_name,"AddTalentByItemR") then
			self:showPanel("talent")
			
		end

	end
end

return heroTrainNew