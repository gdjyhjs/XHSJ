--[[
	武将列表
	create at 17.6.1
	by xin
]]
require("models.hero.heroConfig")
local dataUse = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local modelName = "hero"

local res = 
{
	[1] = "wujiang_mingjianglu.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("道具不足"),
	[2] = gf_localize_string("全部伙伴"),
	[3] = gf_localize_string("<color=ABF2FFFF>变异</color>"),
	[4] = gf_localize_string("<color=ABF2FFFF>普通</color>"),
}

local relive_item_id = 40150201

local heroList=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroList:on_asset_load(key,asset)
	StateManager:register_view(self)
    self:init_ui()
end

function heroList:init_ui()
	self:initList()
	self:init_dropdown()
end
function heroList:dataInit()
	self.heroDataList = {}
end
function heroList:getHeroDataList(type)
	local heroList = type ~= commom_string[2] and dataUse.getHeroByType(type) or dataUse.getAllHero()
	return heroList
end
--初始化列表
function heroList:initList(type)
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	local pItem = refer:Get(2)
	local copyItem = refer:Get(1)
	local heroList = self:getHeroDataList(type)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	for i,v in ipairs(heroList) do
		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.gameObject:SetActive(true)
		item.name = "hero_item_"..v.hero_id

		local bookHeroInfo = gf_getItemObject("hero"):getBookHeroInfo(v.hero_id)
		local heroLevel = bookHeroInfo and bookHeroInfo.level or 0

		if bookHeroInfo then
			--显示icon 品质背景
			-- item.transform:FindChild("head").gameObject:SetActive(true)
		else
			-- item.transform:FindChild("mask").gameObject:SetActive(true)
			-- item.transform:FindChild("lock").gameObject:SetActive(true)
		end

		--品质
		local heroType = dataUse.getHeroQuality(v.hero_id)
		local tagIcon = dataUse.getHeroQualityIcon(heroType)
		local bgImage = item.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(bgImage,tagIcon)
		
		--头像
		print("head:",dataUse.getHeroHeadIcon(v.hero_id))   
  		gf_setImageTexture(item.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image), dataUse.getHeroHeadIcon(v.hero_id) or "img_wujiang_head_content_01")
		
		
		--默认选中第一项
		if i == 1 then
			self:initHeroProperty(v.hero_id,item)
		end
	end

	
end


--初始化属性 
function heroList:initHeroProperty(heroId,heroItem)
	self.heroId = heroId
	self.heroItem = heroItem
		--选中效果
	if heroId and not self.effect_ui then
		--创建特效
		self.effect_ui = LuaHelper.FindChild(self.root,"30000001")
		self.effect_ui.gameObject:SetActive(true)
	end

	if heroId and heroItem then
		self.effect_ui.transform.parent = heroItem.transform
		self.effect_ui.transform.localPosition = Vector3(44.16,-44.16,0) 
	end

	-- local heroPanel = LuaHelper.FindChild(self.root,"hero_panel")
	-- local nameNode = heroPanel.transform:FindChild("hero_name")
	local pPanel = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects"):Get(3)
	-- local reliveNode = heroPanel.transform:FindChild("hero_relive")

	local bookHeroInfo = gf_getItemObject("hero"):getBookHeroInfo(heroId)

	-- local count = 0	--唤魂道具
	-- --获取唤魂道具 
	-- local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.WAKE_HERO)
	-- for i,v in ipairs(items or {}) do
	-- 	count = count + v.item.num
	-- end
	
	--如果没有此武将历史
	if not bookHeroInfo then
		--不能唤魂
		self.refer:Get(7).interactable = false
	else
		self.refer:Get(7).interactable = true
	end

	--名字
	self.refer:Get(4).text = dataUse.getHeroName(heroId)

	-- --品质
	-- local heroType = dataUse.getHeroQuality(heroId)
	-- local tagIcon = dataUse.getHeroTagIcon(heroType)
	-- local bgImage = heroPanel.transform:FindChild("Image (2)"):GetComponent(UnityEngine_UI_Image)
	-- gf_setImageTexture(bgImage,tagIcon)
	
	--资历
	local tPower = dataUse.getHeroTalentPower(heroId)
	local pText = pPanel.transform:FindChild("interval1"):GetComponent("UnityEngine.UI.Text")
	pText.text = string.format("%d-%d",tPower[1],tPower[2])
	
	local tStrenght = dataUse.getHeroTalentStrength(heroId)
	local pText = pPanel.transform:FindChild("interval2"):GetComponent("UnityEngine.UI.Text")
	pText.text = string.format("%d-%d",tStrenght[1],tStrenght[2])
	
	local tSpirit = dataUse.getHeroTalentSpirit(heroId)
	local pText = pPanel.transform:FindChild("interval3"):GetComponent("UnityEngine.UI.Text")
	pText.text = string.format("%d-%d",tSpirit[1],tSpirit[2])
	
	

	local tTalent = dataUse.getHeroTalent(heroId)
	self.refer:Get(11).text = string.format("%d-%d",tTalent[1],tTalent[2])

	local heroLevel = bookHeroInfo and bookHeroInfo.count or 0
	--传承等级 直接继承宠物的属性 每个等级累加
	-- local extendData = dataUse.getHeroExtendData(heroId)
	local eProperty = dataUse.getHeroExtendProperty(heroId)
	local value = dataUse.getHeroExtendData(heroId)
	
	
	self.refer:Get(5).text = string.format("Lv. %d",heroLevel)
	self.refer:Get(6).text = string.format("%s +%d",ConfigMgr:get_config("propertyname")[eProperty].name,heroLevel * value) 

	-- --初始化
	for i=1,8 do
		local skillItem = pPanel.transform:FindChild("hero_skill"..i)
		local image = skillItem.transform:FindChild("Image")
		image.gameObject:SetActive(false)
	end

	--技能
	local skill = dataUse.getHeroSkill(heroId)
	for i,v in ipairs(skill or {}) do
		local skillItem = pPanel.transform:FindChild("hero_skill"..i)
		local image = skillItem.transform:FindChild("Image")
		image.gameObject:SetActive(true)
		--替换icon
		local skill = ConfigMgr:get_config("skill")[v[2]].icon
		gf_setImageTexture(image:GetComponent(UnityEngine_UI_Image), skill)
	end

	--模型
	local model = self.refer:Get(9)
	SetHeroModel(model,heroId,nil,2)
	--[[
	local modelPanel = model.transform:FindChild("camera")
	for i=1,modelPanel.transform.childCount do
  		local go = modelPanel.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

  	local scale = dataUse.getHeroScaleList(heroId)
	local heroModel = dataUse.getHeroModel(heroId) or 420005
	local modelView = require("common.uiModel")(model.gameObject,Vector3(0,-1.2,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,158,0),scale_rate = Vector3(scale,scale,scale)})
	]]	

	

	--des 
	self.refer:Get(8).text = dataUse.getHeroInfoById(heroId).desc

	--道具icon
	local count = 0	--唤魂道具
	--获取唤魂道具 
	local item_id = relive_item_id
	local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.WAKE_HERO,ServerEnum.BAG_TYPE.NORMAL)
	for i,v in ipairs(items or {}) do
		count = count + v.item.num
	end
	local icon = self.refer:Get(10).transform:FindChild("head"):GetComponent(UnityEngine_UI_Image)
	local bg = self.refer:Get(10).transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
	local count_text = self.refer:Get(10).transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
	gf_set_item(item_id,icon,bg)
	local str = "<color=%s>%d</color>"
	local color = count > 0 and gf_get_color(Enum.COLOR.GREEN) or gf_get_color(Enum.COLOR.RED)
	count_text.text = string.format(str,color,count)

	-- --变异
	-- 	if heroInfo.mutate == 1 then
	-- 		self.refer:Get(23).text = commomString[7]
	-- 	else
	-- 		self.refer:Get(23).text = commomString[8]
	-- 	end

end

function heroList:skill_click(event)
	local index = string.gsub(event,"hero_skill","")
	index = tonumber(index)
	local skill = dataUse.getHeroSkill(self.heroId)
	if skill[index] then
		gf_getItemObject('itemSys'):skill_tips(skill[index][2])
	end
	
end

-- 初始化下拉列表
function heroList:init_dropdown()
	local dropdown = self.refer:Get(12)
	dropdown.options:Clear()
 
	local item_list = dataUse.getTypeHero()

	local temp = {}
	local tb = {[1] = {color_name = commom_string[2]}}
	table.insert(temp,tb)
	for i,v in pairs(item_list or {}) do
		table.insert(temp,v)
	end
	item_list = temp

	-- gf_print_table(item_list, "wtf item_list:")

	for i,v in ipairs(item_list) do
		local option = UnityEngine.UI.Dropdown.OptionData()
		option.text = v[1].color_name
		dropdown.options:Add(option)
	end
	dropdown.captionText.text = item_list[1][1].color_name
	dropdown.value = 0
end

function heroList:item_click()
   	gf_getItemObject("itemSys"):common_show_item_info(relive_item_id)
end

function heroList:item_choose(arg)
	local index = arg.captionText.text

	self:initList(index)

end

--鼠标单击事件
function heroList:on_click( obj, arg)
    local eventName = obj.name
    print("heroList click",eventName)
    
    if string.find(eventName,"hero_item_") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local heroId = string.gsub(eventName,"hero_item_","")
   		heroId = tonumber(heroId)
   		self:initHeroProperty(heroId,arg)

   	elseif eventName == "hero_relive" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if not self.heroId then
   			return
   		end
   		local items = gf_getItemObject("bag"):get_item_for_type(Enum.ITEM_TYPE.PROP,Enum.PROP_TYPE.WAKE_HERO,ServerEnum.BAG_TYPE.NORMAL)
   		for i,v in ipairs(items or {}) do
	   		gf_getItemObject("hero"):sendToCreateHero(self.heroId,v.item.guid)
   			return
   		end 
   		gf_message_tips(commom_string[1])
    
    elseif string.find(eventName,"hero_skill") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:skill_click(eventName)

    elseif eventName == "bag_item_item" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click()

    elseif string.find(eventName,"Item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_choose(arg)

    end
end

function heroList:clear()
	self.heroItem = nil
	StateManager:remove_register_view(self)
end

-- 释放资源
function heroList:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroList:on_showed()
end

function heroList:on_hided()
	self:clear()
end


function heroList:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "WakeUpHeroR") then
			if msg.err == 0 then
				self:initHeroProperty(msg.heroId,self.heroItem)
			end
		end
	end
end

return heroList