--[[
	武将系统 仓库
	create at 17.6.6
	by xin
]]
require("models.hero.heroConfig")
require("models.hero.heroPublicFunc")
local LuaHelper = LuaHelper
local dataUse = require("models.hero.dataUse")
local modelName = "hero"

local res = 
{
	[1] = "wujiang_wujiangku.u3d",
}

local commomString = 
{
	[1] = gf_localize_string("待战栏已满"),
	[2] = gf_localize_string("请选择出战的武将"),
	[3] = gf_localize_string("请选择备战的武将"),
	[4] = gf_localize_string("请选择需要炼魂的武将"),
	[5] = gf_localize_string("此武将正在出战中"),
}

--@heroUid  优先选中武将
local heroStoreView=class(UIBase,function(self,heroUid)
	self.heroUid = heroUid
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	
end)

function heroStoreView:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroStoreView:on_asset_load(key,asset)
	StateManager:register_view(self)
    self:init_ui()
end

function heroStoreView:init_ui()
	self:clear()
	self:warListInit()
	self:storeListInit()
end

--出战列表
function heroStoreView:warListInit()
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	local pItem = refer:Get(3)
	local copyItem = refer:Get(4)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

  	local data = gf_getItemObject("hero"):getHeroList()

  	local fightHeroId = gf_getItemObject("hero"):getFightId()

  	for i,v in ipairs(data) do
  		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.gameObject:SetActive(true)
		item.name = "hero_store_war_item"..v.heroUid
  		
  		--等级
  		local levelText = item.transform:FindChild("level").transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
  		levelText.text = v.level
  		--品质
  		SetHeroQualityIcon(item.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image),v.heroId)
  		
  		--头像
  		gf_setImageTexture(item.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image), dataUse.getHeroHeadIcon(v.heroId) or "img_wujiang_head_content_01")

  		if fightHeroId == v.heroUid then
  			-- item.transform:FindChild("Image").gameObject:SetActive(true)
  		end

  	end
end

--仓库
function heroStoreView:storeListInit()
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	local pItem = refer:Get(1)
	local copyItem = refer:Get(2)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

  	local data = gf_getItemObject("hero"):getStoreHeroList()

  	for i,v in ipairs(data) do
  		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.gameObject:SetActive(true)
		item.name = "hero_store_item"..v.heroUid

		local pNode = item.transform:FindChild("front_hole7 (2)")

		--等级
  		local levelText = pNode.transform:FindChild("level").transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
  		levelText.text = v.level
  		--品质
  		SetHeroQualityIcon(pNode.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image),v.heroId)
  	
  		--名字
  		local nameText = item.transform:FindChild("Text (2)"):GetComponent("UnityEngine.UI.Text")
  		nameText.text = v.name ~= "" and v.name or dataUse.getHeroName(v.heroId)
  		--资质
  		local value = 0
  		for i,v in ipairs(v.talent or {}) do
  			value =  value + v
  		end 
  		local talentText = item.transform:FindChild("Text (1)").transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")
  		talentText.text = value

  		--头像
  		gf_setImageTexture(pNode.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image), dataUse.getHeroHeadIcon(v.heroId) or "img_wujiang_head_content_01")

  	end
end

--鼠标单击事件
function heroStoreView:on_click(obj, arg)
	print("heroStoreView click")
    local eventName = obj.name
    if eventName == "hero_store_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()
    elseif string.find(eventName,"hero_store_war_item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if self.lastButton then
			self.lastButton.transform:FindChild("select").gameObject:SetActive(false)
			self.heroUid = nil
			self.pHeroUid = nil
		end
		self.lastButton = arg
		self.lastButton.transform:FindChild("select").gameObject:SetActive(true)
		local heroUid = string.gsub(eventName,"hero_store_war_item","")
		heroUid = tonumber(heroUid)
		self.heroUid = heroUid
    elseif string.find(eventName,"hero_store_item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.lastButton then
			self.lastButton.transform:FindChild("select").gameObject:SetActive(false)
			self.heroUid = nil
			self.pHeroUid = nil
		end
		self.lastButton = arg
		self.lastButton.transform:FindChild("select").gameObject:SetActive(true)
		local heroUid = string.gsub(eventName,"hero_store_item","")
		heroUid = tonumber(heroUid)
		self.pHeroUid = heroUid
    elseif eventName == "hero_store_prepare" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local fightHeroId = gf_getItemObject("hero"):getFightId()
    	if self.heroUid and fightHeroId ~= self.heroUid then
    		print("self.heroUid:",self.heroUid)
	    	gf_getItemObject("hero"):sendToPushHeroToStore(self.heroUid)
	    elseif fightHeroId == self.heroUid then
	    	gf_message_tips(commomString[5])
	    else
	    	gf_message_tips(commomString[3])
    	end
    elseif eventName == "hero_store_goto_attack" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if self.pHeroUid then
    		print("self.pHeroUid:",self.pHeroUid)
    		local data = gf_getItemObject("hero")
    		--判断待战栏已经满
    		local heroList = data:getHeroList()
    		local prepareSize = data:getHeroPrepareSize()
    		
    		if #heroList < prepareSize then
    			gf_getItemObject("hero"):sendToPushHeroToList(self.pHeroUid)
    			return
    		end
	    	gf_message_tips(commomString[1])
	    else
	    	gf_message_tips(commomString[2])
    	end
    elseif eventName == "hero_store_recycle" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local fightHeroId = gf_getItemObject("hero"):getFightId()
    	if not self.pHeroUid and not self.heroUid then
    		gf_message_tips(commomString[4])
    		return
    	end
    	print("ffffff you",self.pHeroUid == fightHeroId or self.heroUid == fightHeroId,self.pHeroUid , self.heroUid, fightHeroId)
    	if self.pHeroUid == fightHeroId or self.heroUid == fightHeroId then
    		gf_message_tips(commomString[5])
    		return
    	end
    	-- self:create_sub_view("models.hero.heroReCycleView",self.pHeroUid or self.heroUid)
    	require("models.hero.heroReCycleView")(self.pHeroUid or self.heroUid)
    	return true
    end
end

function heroStoreView:clear()
	self.heroUid = nil
	self.pHeroUid = nil
	self.lastButton = nil
end
-- 释放资源
function heroStoreView:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroStoreView:on_showed()
end

function heroStoreView:on_hided()
	StateManager:remove_register_view(self)
end



function heroStoreView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "SlotHeroToWareR") then
			if msg.err == 0 then
				print("rec 武将放入仓库")
				self:init_ui()
			end
		elseif id2 == Net:get_id2(modelName,"WareHeroToSlotR") then
			if msg.err == 0 then
				self:init_ui()
			end
		elseif id2 == Net:get_id2(modelName,"RecycleHeroR") then
			if msg.err == 0 then
				self:init_ui()
			end
		end
	end
end

return heroStoreView