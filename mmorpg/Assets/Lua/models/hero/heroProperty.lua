--[[
	武将主界面  属性
	create at 17.6.1
	by xin
]]
require("models.hero.heroConfig")
require("models.hero.heroPublicFunc")
local dataUse = require("models.hero.dataUse")
local dataUse1 = require("models.horse.dataUse")
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local modelName = "hero"

local res = 
{
	[1] = "hero_battle.u3d",
}

local sub_view = 
{
	"talentGroup",
	"heroWash",
	"heroAwaken",
	"heroEquip",
	"heroReborn",
	"expAdd",
}

local commomString = 
{
	[1] = gf_localize_string("休息"),
	[2] = gf_localize_string("出战"),
	[3] = gf_localize_string("无"),
	[4] = gf_localize_string("%d级"),
	[5] = gf_localize_string("请选择武将"),
	[6] = gf_localize_string("可使用武将技能书学习技能"),
	[7] = gf_localize_string("<color=ABF2FFFF>变异</color>"),
	[8] = gf_localize_string("<color=ABF2FFFF>普通</color>"),
	[9] = gf_localize_string("名字中含有敏感词汇，请重新输入"),
	
	[13] = gf_localize_string("确定花费<color=#B01FE5>%d</color>元宝，开启一个新的栏位？(优先使用绑定元宝)"),
	[14] = gf_localize_string("专属技能不能替换"),
	
	[16] = gf_localize_string("出战功能冷却中"),
	
}
local color = 
{
	[1] = Color(113/255, 92/255, 72/255, 1),
	[2] = Color(132/255, 56/255, 19/255, 1),
}

local heroProperty = class(UIBase,function(self,view_param1,view_param2,view_param3)
	self.view_param1 = view_param1
	self.view_param2 = view_param2
	self.view_param3 = view_param3
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)

--资源加载完成
function heroProperty:on_asset_load(key,asset)
	print("on_asset_load wtf ffffff:",self.view_param1,self.view_param2)
	StateManager:register_view(self)
	self:init_ui()
end

function heroProperty:init_ui()
	self:setHeroList()

	self:start_scheduler()

	if self.view_param1 then
		local view_name = sub_view[self.view_param1]
		local type = self.view_param2
		if self.view_param3 or self.heroId and self.heroId > 0 then
			require("models.hero."..view_name)(self.view_param3 or self.heroId,type)
		end
		
		self.view_param1 = nil
		self.view_param2 = nil
		self.view_param3 = nil
	end
end

function heroProperty:setHeroList()
	
	local itemList = self:setHeroListEx()
	self.itemList = itemList 

	local function get_index(heroId)
		for i,v in ipairs(self.itemList or {}) do
			if v.heroId == heroId then
				return i
			end
		end
		return 1
	end

	local index = 1
	if self.heroId then
		index = get_index(self.heroId)
	end

	--如果没有出战武将 默认选中第一个
	if next(itemList or {}) then
		self:heroChoose(itemList[index].heroId,itemList[index].item)
	else
		self:heroChoose(nil)
	end
	
end

function heroProperty:setHeroListEx()

	self.select_tag = nil

	local pItem = self.refer:Get(4)
	local copyItem = self.refer:Get(1)

	local heroList = gf_getItemObject("hero"):getFightIdList()

	--将首战放前面
	local temp = {}
	local fightId = gf_getItemObject("hero"):getFightId()
	if fightId > 0 then
		table.insert(temp,fightId)
	end

	for i,v in ipairs(heroList or {}) do
		if v ~= fightId then
			table.insert(temp,v)
		end
	end
	heroList = temp
	local itemList = SetHeroList(pItem,copyItem,heroList)
	return itemList
end

--设置武将装备
function heroProperty:setHeroEquipView()
	print("setHeroEquipView")
	local pNode = self.refer:Get(11)

	local heroEquipInfo = gf_getItemObject("hero"):getHeroEquip(self.heroId)
	SetHeroEquipView(pNode, heroEquipInfo, "militayr_equip")

end


function heroProperty:heroChoose(heroId,heroItem)
	self.heroId = heroId

	if self.select_tag then
		self.select_tag.gameObject:SetActive(false)
	end

	if heroId then
		heroItem.transform:FindChild("select").gameObject:SetActive(true)
		self.select_tag = heroItem.transform:FindChild("select")
	end

	--出战休息按钮
	local fightId = gf_getItemObject("hero"):getFightId()
	local text = self.refer:Get(6)

	--如果在cd中
	self.refer:Get(26).gameObject:SetActive(false)
	if gf_getItemObject("hero"):get_fight_cd_time() - Net:get_server_time_s() > 0 and fightId ~= heroId then
		self:start_button_cd_scheduler()
	end

	if fightId == heroId then
		text.text = commomString[1]
	else
		text.text = commomString[2]
	end
	--设置装备
	self:setHeroEquipView()

	--武将详情
	local heroInfo = heroId and gf_getItemObject("hero"):getHeroInfo(heroId) or {}
	local name = self.refer:Get(21)
	local pNode = self.refer:Get(11)
	
	--战力
	self:set_hero_power()

  	--exp
  	self:update_exp_view(heroId)

  	local model = pNode.transform:FindChild("model")

  	local modelPanel = model.transform:FindChild("camera")
	if model.transform:FindChild("my_model") then
 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
 	end

	if next(heroInfo or {}) then
		
		SetHeroModel(model,heroInfo.heroId,nil,1)

		--品质
		local heroType = dataUse.getHeroQuality(heroInfo.heroId)
		local iconName = dataUse.getHeroIcon(heroType)
		gf_setImageTexture(self.refer:Get(2),iconName )
		--名字 
		name.text = heroInfo.name ~= "" and heroInfo.name or dataUse.getHeroName(heroInfo.heroId)  

	else
		name.text = "" 
		
	end

	self:showPanel("property")
	self:showPanel("skill")

end

function heroProperty:start_button_cd_scheduler()
	if self.cd_schedule_id then
		self:stop_schedule_cd()
	end
	local end_time = gf_getItemObject("hero"):get_fight_cd_time()

	local function set(cd)
		self.refer:Get(26).fillAmount = cd / 10
		self.refer:Get(27).text = string.format("%ds",math.floor(cd))
	end
	self.refer:Get(26).gameObject:SetActive(true)
	local update = function()
		local left_time = end_time - Net:get_server_time_s()
		set(left_time)
		if left_time <= 0 then
			self.refer:Get(26).gameObject:SetActive(false)
			self:stop_schedule_cd()
			return
		end
	end
	update()
	self.cd_schedule_id = Schedule(update, 0.1)
end

function heroProperty:stop_schedule_cd()
	if self.cd_schedule_id then
		self.cd_schedule_id:stop()
		self.cd_schedule_id = nil
	end
end
function heroProperty:update_item_level()
	for i,v in ipairs(self.itemList or {}) do
		local index = string.gsub(v.item.name,"hero_item_fight","")
		index = tonumber(index)
		if index == self.heroId then
			local level = gf_getItemObject("hero"):getHeroInfo(self.heroId).level
			local refer = v.item:GetComponent("Hugula.ReferGameObjects")
			refer:Get(3).text = "Lv. "..level
		end
	end
end

function heroProperty:update_exp_view(heroId)
	if not heroId then
		self.refer:Get(19).text = 0
		self.refer:Get(20).fillAmount = 1
		self.refer:Get(25).text = ""
		return
	end
	local heroInfo = gf_getItemObject("hero"):getHeroInfo(heroId) 
	self.refer:Get(19).text = string.format(commomString[4],heroInfo.level )
	print("heroInfo.exp / dataUse.getHeroLevelExp(heroInfo.level):",heroInfo.exp , dataUse.getHeroLevelExp(heroInfo.level))
	self.refer:Get(20).fillAmount = heroInfo.exp / dataUse.getHeroLevelExp(heroInfo.level)

	self.refer:Get(25).text = string.format("%d/%d",heroInfo.exp , dataUse.getHeroLevelExp(heroInfo.level))
	
end

function heroProperty:set_hero_power()
	local power = 0
	if self.heroId then
		power = gf_getItemObject("hero"):get_hero_power(self.heroId)
	end
	self.refer:Get(24).text = power

end

function heroProperty:showPanel(name)

	if name == "property" then
		self:showHeroProperty()

	elseif name == "talent" then
		self:showHeroTalent()

	elseif name == "skill" then
		self:showHeroSkill()

	end 
end

function heroProperty:reset_button_view()
	self.refer:Get(15):SetActive(false)
	self.refer:Get(14):SetActive(false)
	self.refer:Get(12).transform:FindChild("Image").gameObject:SetActive(false)
	self.refer:Get(13).transform:FindChild("Image").gameObject:SetActive(false)
	self.refer:Get(17).color = color[1]
	self.refer:Get(18).color = color[1]
	
end


function heroProperty:showHeroProperty(name)
	print("showHeroProperty:",name)
	self:reset_button_view()
	self.refer:Get(14):SetActive(true)
	self.refer:Get(17).color = color[2]
	self.refer:Get(12).transform:FindChild("Image").gameObject:SetActive(true)

	local pNode = self.refer:Get(7)
	
	local p_refer = pNode:GetComponent("Hugula.ReferGameObjects")

	if not self.heroId then
		for i=1,12 do
			p_refer:Get(12+i).text = 0
		end
		return
	end

	local heroInfo = gf_getItemObject("hero"):getHeroInfo(self.heroId)
	local propertyData = gf_getItemObject("hero"):getHeroProperty(self.heroId)
	SetHeroProperty(self.heroId,pNode,propertyData)

end
function heroProperty:showHeroTalent()
	self:reset_button_view()
	self.refer:Get(15):SetActive(true)
	self.refer:Get(18).color = color[2]
	self.refer:Get(13).transform:FindChild("Image").gameObject:SetActive(true)

	local hero_data = gf_getItemObject("hero"):getHeroInfo(self.heroId)

    local data1,data2 = {},{}
    if self.heroId then
    	data1,data2 = dataUse.getHeroTalentIncludeAwake(self.heroId,hero_data.talent,hero_data.awakenLevel)
    end
   
    SetHeroTalent(self.refer:Get(15),data1,data2,self.heroId)

end

function heroProperty:showHeroSkill()
	if not self.heroId then
		return
	end

	local skill_data = gf_getItemObject("hero"):get_hero_skill_slot(self.heroId)

	local pItem = self.refer:Get(10)
	local copyItem = self.refer:Get(9)

	gf_set_skill_panel(self.heroId,skill_data,pItem,copyItem)
	
	
end


--开始倒计时
function heroProperty:start_scheduler()
	if not gf_getItemObject("hero"):get_is_have_hero_dead()then
		return
	end
	if self.schedule_id then
		self:stop_schedule()
	end

	local temp = {}
	for i,v in ipairs(self.itemList or {}) do
		local index = string.gsub(v.item.name,"hero_item_fight","")
		index = tonumber(index)
		temp[index] = v
	end
	local update = function()
		--如果没有倒计时 停止定时器
		print("update wtf")
		if not gf_getItemObject("hero"):get_is_have_hero_dead()then
			self:stop_schedule()
		end
		local fight_list = gf_getItemObject("hero"):getFightIdList()
		for i,v in ipairs(fight_list or {}) do
			local hero_info = gf_getItemObject("hero"):getHeroInfo(v)
			local item = temp[v].item
			local refer = item:GetComponent("Hugula.ReferGameObjects")
			--复活时间
			local left_time = hero_info.deadTime +  ConfigMgr:get_config("t_misc").hero.relive_time - Net:get_server_time_s()
			left_time = left_time <=0 and 0 or left_time
			left_time = math.floor(left_time)
			local fill = item.transform:FindChild("filled")
			if left_time > 0 then
				refer:Get("filled"):SetActive(true)
				refer:Get("Text").text = left_time
			else
				refer:Get("filled"):SetActive(false)
			end
		end
	end
	update()
	self.schedule_id = Schedule(update, 0.1)
end

function heroProperty:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end



function heroProperty:equipClick(index,eButton)
	if not self.heroId then
		return
	end
 	require("models.hero.heroEquip")(self.heroId)

end
     
function heroProperty:userItem(itemId,count,itemGuid)
	if not self.heroId then
		gf_message_tips(commomString[5])
		return
	end
	local itemData = itemId and gf_getItemObject("bag"):get_item_for_protoId(itemId) or gf_getItemObject("bag"):get_item_for_guid(itemGuid) 
	if not itemData then
		return
	end
	gf_print_table(itemData, "itemData：")

	local bt,st = gf_getItemObject("bag"):get_type_for_protoId(itemData.protoId)

	--洗炼书
	if bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.POLISH_HERO then
		
		gf_getItemObject("hero"):sendToPolishHero(self.heroId,itemData.guid)
	
	--给武将加经验的书
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HERO_EXP_BOOK then
	
		gf_getItemObject("hero"):sendToUseHeroExBook(itemData.guid,self.heroId,count or 1)

	--技能书
	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.HERO_SKILL_BOOK then
		gf_getItemObject("hero"):sendToUseSkillBook(self.heroId,itemData.guid)

	elseif bt == Enum.ITEM_TYPE.PROP and st == Enum.PROP_TYPE.UNLOCK_HERO_SLOT then
		
		require("models.hero.heroOpen")()

	end
	


	--装备
	if bt == Enum.ITEM_TYPE.EQUIP and st == Enum.HERO_EQUIP_TYPE.WEAPON  then

		gf_getItemObject("hero"):sendToEquip(self.heroId,itemData.guid)

	elseif bt == Enum.ITEM_TYPE.EQUIP and st == Enum.HERO_EQUIP_TYPE.ARMOR then

		gf_getItemObject("hero"):sendToEquip(self.heroId,itemData.guid)

	elseif bt == Enum.ITEM_TYPE.EQUIP and st == Enum.HERO_EQUIP_TYPE.DECORATION then

		gf_getItemObject("hero"):sendToEquip(self.heroId,itemData.guid)

	end

end

function heroProperty:change_name_click(arg)
	if not self.heroId then
		gf_message_tips(commomString[5])
		return
	end
	local name = arg.textComponent.text

	if checkChar(name) then
		gf_message_tips(commomString[9])
		return

	end
	gf_getItemObject("hero"):sendToNameHero(self.heroId, name)
end

function heroProperty:item_lock_click()
	
	local sure_fun = function()
		gf_getItemObject("hero"):sendToUnLockHeroSlot()
		-- gf_getItemObject("hero"):test_add_to_unlock()
	end
	local size = gf_getItemObject("hero"):getHeroPrepareSize()
	local count = dataUse.getOpenPrice(size + 1)
	local content = string.format(commomString[13],count)
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)
end

--鼠标单击事件
function heroProperty:on_click(obj, arg)
    local eventName = obj.name
    print("heroProperty click ",eventName)
    
    if string.find(eventName,"hero_check_") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	
    	local name = string.gsub(eventName,"hero_check_","")
    	self:showPanel(name)

    elseif string.find(eventName,"militayr_equip") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local index = string.gsub(eventName,"militayr_equip","")
   		index = tonumber(index)
    	self:equipClick(index,arg)
    elseif string.find(eventName,"hero_item_fight") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local heroId = string.gsub(eventName,"hero_item_fight","")
    	heroId = tonumber(heroId)

    	if heroId == self.heroId then
    		require("models.hero.heroBattle")()
    		return
    	end

		self:heroChoose(heroId,arg)  

	elseif eventName == "goto_attack" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if not self.heroId then
			gf_message_tips(gf_localize_string("请选择武将"))
			return
		end
		local fightId = gf_getItemObject("hero"):getFightId()
		if fightId == self.heroId then
			gf_getItemObject("hero"):send_to_rest()
			return
		end

		if not gf_getItemObject("hero"):get_hero_is_dead(self.heroId)  then
			if  gf_getItemObject("hero"):get_fight_cd_time() - Net:get_server_time_s() <= 0 then
				gf_getItemObject("hero"):sendToHeroGotoAttack(self.heroId)
			else
				gf_message_tips(commomString[16])
			end
			
		else
			gf_message_tips(gf_localize_string("武将已经死亡"))
		end
		
	
		
    elseif string.find(eventName,"hero_bag_item_") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local itemId = string.gsub(eventName,"hero_bag_item_","")
    	itemId = tonumber(itemId)
   		local item = gf_getItemObject("bag"):get_item_for_guid(itemId)

   		local function callback(count)
   			self:userItem(nil,count,itemId)
   		end

   		gf_getItemObject("itemSys"):prop_use_tips(item.protoId,callback)

    elseif eventName == "hero_store" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	-- self:create_sub_view("models.hero.heroStoreView")
    	require("models.hero.heroStoreView")()

    -- elseif string.find(eventName,"hero_item_lock") then
    -- 	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    -- 	require("models.hero.heroOpen")()

    elseif eventName == "InputField" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:change_name_click(arg)

    elseif eventName == "goto_decomposition" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if self.heroId and self.heroId > 0 then
    		require("models.hero.heroTrainNew")(self.heroId)
    		return
    	end
    	gf_message_tips(gf_localize_string("请选择武将"))
    
   	elseif eventName == "hero_train" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if self.heroId then
   			require("models.hero.expAdd")(self.heroId)
   			return
   		end
   		gf_message_tips(commomString[5])
	
   	elseif string.find(eventName,"talent_group") then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if self.heroId then
   			local type = string.gsub(eventName,"talent_group","")
	    	type = tonumber(type)
	   		require("models.hero.talentGroup")(self.heroId,type)
   		end

   	elseif eventName == "hero_details" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if self.heroId then
   			require("models.hero.heroDetails")(self.heroId)
   			return
   		end
   		gf_message_tips(gf_localize_string("请选择武将"))
   		

   	elseif eventName == "hero_rename" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		if self.heroId then
   			require("models.hero.heroRename")(self.heroId)
   			return
   		end
   		gf_message_tips(gf_localize_string("请选择武将"))

   	elseif eventName == "hero_item_empty" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		require("models.hero.heroBattle")()


   	elseif eventName == "hero_item_lock" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		self:item_lock_click()

   	elseif eventName == "talent" or eventName == "power" or eventName == "strenght" or eventName == "spirite" then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		gf_show_doubt(1084)

    end

end

function heroProperty:clear()
	print("heroPropertyclear")
	self.lPanel = nil
	self.lEquipButton = nil
	self.heroId = nil
	self.panelTag = nil
	self.lSkill = nil
	self.select_tag = nil
	self:stop_schedule()
	self:stop_schedule_cd()
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function heroProperty:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroProperty:on_showed()
end

function heroProperty:on_hided()
	print("on hide wtf")
	self:clear()
	StateManager:remove_register_view(self)
end


function heroProperty:rec_rename(msg)
	if msg.err == 0 and self.heroId then
		if msg.heroId == self.heroId then
			self.refer:Get(21).text = msg.name
		end
	end
end

function heroProperty:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "SetHeroFightR") then
			if msg.err == 0 then
				self:init_ui()
			end

		elseif id2 == Net:get_id2(modelName, "SlotHeroToWareR") then
			--武将放入仓库	
			self:init_ui()

		elseif id2 == Net:get_id2(modelName,"WareHeroToSlotR") then
			self:init_ui()

		elseif id2 == Net:get_id2(modelName,"UnlockHeroSlotR") then
			self:init_ui()

		elseif id2 == Net:get_id2(modelName,"PolishHeroR") then
			-- self:showHeroTalent()

		elseif id2 == Net:get_id2(modelName,"RecycleHeroR") then
			self:init_ui()

		elseif id2 == Net:get_id2(modelName,"GainSkillByBookR") then
			self:showHeroSkill()
			self:set_hero_power()

		elseif id2 == Net:get_id2(modelName,"AddHeroExpByBookR") then
			if msg.err ~= 0 then
				return
			end
			if msg.heroId ~= self.heroId then
				return
			end
			self:update_exp_view(self.heroId)
			self:showHeroProperty()
			self:set_hero_power()
			self:update_item_level()
			self:showHeroSkill()
			
		elseif id2 == Net:get_id2(modelName,"SetHeroEquipR") or id2 == Net:get_id2(modelName,"UnloadHeroEquipR") then
			self:setHeroEquipView()
			self:showHeroProperty()
			self:set_hero_power()

		elseif id2 == Net:get_id2(modelName,"RenameHeroR") then
			self:rec_rename(msg)

		elseif id2 == Net:get_id2(modelName,"AddTalentByItemR") then
			self:showHeroTalent()
			self:set_hero_power()

		elseif id2 == Net:get_id2(modelName,"SetHeroToFightListR") then
			self:init_ui()

		elseif id2 == Net:get_id2(modelName,"AwakenHeroR") then
			self:showHeroSkill()
			self:showHeroTalent()
			self:set_hero_power()

		elseif id2 == Net:get_id2(modelName,"RecycleHeroR") then
			self:init_ui()

		elseif id2 == Net:get_id2(modelName,"SavePolishHeroR") then
			self:init_ui()


		elseif id2 == Net:get_id2(modelName,"RestR") then
			self:init_ui()
			
		elseif id2 == Net:get_id2(modelName,"GainHeroR") then
			self:init_ui()
		
		elseif id2 == Net:get_id2(modelName,"HeroDieR") then
			self:start_scheduler()

		end
	end
end

return heroProperty

--[[
function heroProperty:setSkillView()
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	local pNode = refer:Get(3)
	local panel = pNode.transform:FindChild("skill")
	local rich_text_panel = panel.transform:FindChild("Panel")
	local rich_text = rich_text_panel.transform:FindChild("liaotianText"):GetComponent("UnityEngine.UI.Text")

	local function cb( arg )
		gf_getItemObject("itemSys"):common_show_item_info(hero_item_skill_book_id)
	end
	rich_text.OnHrefClickFn=cb
	
end

--设置道具
function heroProperty:showItemView()
	-- self:reset_button_view_bottom()
	self.refer:Get(18).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").color = color[2]
	-- self.refer:Get(18).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Outline").enabled = true
	self.refer:Get(18).transform:FindChild("Image").gameObject:SetActive(true)
	self.refer:Get(16).enabled = true
	print("setItemView:",type)
	local list = gf_getItemObject("hero"):getHeroTypeBagItem(ServerEnum.BAG_TYPE.NORMAL)
	
	-- gf_print_table(list, "武将道具装备:")

	local pItem = self.refer:Get(10)
	pItem.gameObject:SetActive(true)
	local copyItem = self.refer:Get(8)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end
  	--1到4显示四个格子 5~8显示8个格子 以此类推
  	local item_count = 8
	local count = math.ceil(#list / item_count) * item_count
	count = count > 0 and count or item_count
	for i=1,count do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)
		cItem.transform:FindChild("icon").gameObject:SetActive(false)
		v = list[i]
		if v then
			cItem.transform:FindChild("icon").gameObject:SetActive(true)
			cItem.name = "hero_bag_item_"..v.item.guid
			--替换icon
			local itemData = v.data
			gf_set_item(v.item.protoId, cItem.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image), cItem:GetComponent(UnityEngine_UI_Image))
			--数量
			local count_text = cItem.transform:FindChild("count")	
			count_text.gameObject:SetActive(true)
			count_text:GetComponent("UnityEngine.UI.Text").text = v.item.num
		end
	end
end
]]