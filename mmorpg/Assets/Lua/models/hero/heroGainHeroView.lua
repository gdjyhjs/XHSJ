--[[
	武将系统 获取武将弹框   废弃
	create at 17.6.6
	by xin
]]
require("models.hero.heroConfig")
local LuaHelper = LuaHelper
local dataUse = require("models.hero.dataUse")
local modelName = "hero"
local Enum = require("enum.enum")
local res = 
{
	[1] = "wujiang_get_tip.u3d",
}

local commomString = 
{
	[1] = gf_localize_string("传承  等级%d"),
}

--@isMain  是否跳转到主ui
local heroGainHeroView=class(UIBase,function(self,heroInfo,isMain)
	gf_print_table(heroInfo, "heroInfo:")
	self.heroInfo = heroInfo
	self.isMain = isMain
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	
end)

function heroGainHeroView:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroGainHeroView:on_asset_load(key,asset)
	StateManager:register_view(self)
    self:init_ui()
end

function heroGainHeroView:init_ui()
	self:clear()
	self:heroInfoInit()
end

function heroGainHeroView:heroInfoInit()
	local refer = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects")
	local heroName = dataUse.getHeroName(self.heroInfo.heroId)
	--天资
	local width = 145.1

	--武力
	local power = dataUse.getHeroTalentPower(self.heroInfo.heroId)
	local maxValue = power[2] - power[1]
	local minValue = self.heroInfo.talent[Enum.HERO_TALENT_TYPE.FORCE] - power[1]
	local power_image = refer:Get(1).transform:FindChild("power1")
	local text1 = refer:Get(1).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	power_image.sizeDelta = Vector2(width * minValue / maxValue,8)
	text1.text = self.heroInfo.talent[Enum.HERO_TALENT_TYPE.FORCE]--string.format("%d/%d",self.heroInfo.talent[Enum.HERO_TALENT_TYPE.FORCE],power[2])

	--体魄
	local power = dataUse.getHeroTalentStrength(self.heroInfo.heroId)
	local maxValue = power[2] - power[1]
	local minValue = self.heroInfo.talent[Enum.HERO_TALENT_TYPE.PHYSIQUE] - power[1]
	local image2 = refer:Get(2).transform:FindChild("spirite1")
	local text2 = refer:Get(2).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	image2.sizeDelta = Vector2(width * minValue / maxValue,8)
	text2.text = self.heroInfo.talent[Enum.HERO_TALENT_TYPE.PHYSIQUE]--string.format("%d/%d",self.heroInfo.talent[Enum.HERO_TALENT_TYPE.PHYSIQUE],power[2])

	--灵力
	local power = dataUse.getHeroTalentSpirit(self.heroInfo.heroId)
	local maxValue = power[2] - power[1]
	local minValue = self.heroInfo.talent[Enum.HERO_TALENT_TYPE.FLEXABLE] - power[1]
	local image3 = refer:Get(3).transform:FindChild("strenght1")
	local text3 = refer:Get(3).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
	image3.sizeDelta = Vector2(width * minValue / maxValue,8)
	text3.text = self.heroInfo.talent[Enum.HERO_TALENT_TYPE.FLEXABLE] --string.format("%d/%d",self.heroInfo.talent[Enum.HERO_TALENT_TYPE.FLEXABLE],power[2])

	--继承
	local extand = refer:Get(6)
	local eProperty = dataUse.getHeroExtendProperty(self.heroInfo.heroId)
	local value = dataUse.getHeroExtendData(self.heroInfo.heroId)
	local bookHeroInfo = gf_getItemObject("hero"):getBookHeroInfo(self.heroInfo.heroId)
	gf_print_table(bookHeroInfo, "bookHeroInfo:")
	local heroLevel = bookHeroInfo and bookHeroInfo.count or 0
	
	local pText = extand.transform:FindChild("Text (12)"):GetComponent("UnityEngine.UI.Text")
	pText.text = string.format(commomString[1],heroLevel)

	local pText = extand.transform:FindChild("Text (11)"):GetComponent("UnityEngine.UI.Text")
	pText.text = string.format("%s+%d",ConfigMgr:get_config("propertyname")[eProperty].name,heroLevel * value )

	--技能
	local skill_panel = refer:Get(4)

	for i=1,8 do
		local item = skill_panel.transform:FindChild("skill"..i)
		item.transform:FindChild("Image").gameObject:SetActive(false)
	end

	
	for i,v in ipairs(self.heroInfo.skill or {}) do
		local item = skill_panel.transform:FindChild("skill"..i)
		item.transform:FindChild("Image").gameObject:SetActive(true)
	end

	--名字 品级
	local name_panel = refer:Get(5)
	local nameText = name_panel.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text")
	nameText.text = heroName

	--品质
	local bgImage = name_panel.transform:FindChild("GameObject").transform:FindChild("Image (3)"):GetComponent(UnityEngine_UI_Image)
	local heroType = dataUse.getHeroQuality(self.heroInfo.heroId)
	local iconName = dataUse.getHeroIcon(heroType)
	gf_setImageTexture(bgImage,iconName )

	--模型
	local model = LuaHelper.FindChild(self.root,"right").transform:FindChild("model")
	local modelPanel = model.transform:FindChild("camera")
	for i=1,modelPanel.transform.childCount do
  		local go = modelPanel.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end
  	
  	local scale = dataUse.getHeroScaleGet(self.heroInfo.heroId)
	local heroModel = dataUse.getHeroModel(self.heroInfo.heroId) or 420005
	local modelView = require("common.uiModel")(model.gameObject,Vector3(0,-2,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,158,0),scale_rate=Vector3(scale,scale,scale)})

end

--鼠标单击事件
function heroGainHeroView:on_click(obj, arg)
	print("heroGainHeroView click")
    local eventName = obj.name
    if eventName == "hero_mask" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:hide()
    elseif eventName == "hero_train" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:hide()
   		--跳转界面
   		if self.isMain then
   			-- self:create_sub_view("models.hero.heroEntry",heroType.property,self.heroInfo.heroUid)
   			require("models.hero.heroEntry")(heroType.property,self.heroInfo.heroUid)
   		else
   			-- self:create_sub_view("models.hero.heroStoreView",self.heroInfo.heroUid)
   			-- require("models.hero.heroStoreView")(self.heroInfo.heroUid)
   		end
   		gf_receive_client_prot(msg,ClientProto.RecGotoHeroView)
    elseif eventName == "hero_recall" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:hide()
    end
end

function heroGainHeroView:clear()
end
-- 释放资源
function heroGainHeroView:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroGainHeroView:on_showed()
end

function heroGainHeroView:on_hided()
	StateManager:remove_register_view(self)
end



function heroGainHeroView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "SlotHeroToWareR") then
		end
	end
end

return heroGainHeroView