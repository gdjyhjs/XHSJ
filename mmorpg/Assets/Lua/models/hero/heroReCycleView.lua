--[[
	武将系统 炼魂
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
	[1] = "wujiang_lianhun.u3d",
}

local commomString = 
{
	[1] = gf_localize_string("再见了朋友"),
	[2] = gf_localize_string("输入错误"),
}


local heroReCycleView=class(UIBase,function(self,heroUid)
	self.heroUid = heroUid
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	
end)

function heroReCycleView:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroReCycleView:on_asset_load(key,asset)
	StateManager:register_view(self)
    self:init_ui()
end

function heroReCycleView:init_ui()
	local heroInfo = gf_getItemObject("hero"):getHeroIdByHeroByUid(self.heroUid)
	local pNode = self.refer:Get(2)
	
	--武将icon
	gf_setImageTexture(pNode.transform:FindChild("hero_item (1)").transform:FindChild("head"):GetComponent(UnityEngine_UI_Image), dataUse.getHeroHeadIcon(heroInfo.heroId) or "img_wujiang_head_content_01")

	--武将名字
	local nameText = pNode.transform:FindChild("Text (2)"):GetComponent("UnityEngine.UI.Text")
	nameText.text = heroInfo.name ~= "" and heroInfo.name dataUse.getHeroName(heroInfo.heroId)

	local levelText = pNode.transform:FindChild("Text (3)"):GetComponent("UnityEngine.UI.Text")
	levelText.text = heroInfo.level

	--品质 
	SetHeroQualityIcon(pNode.transform:FindChild("hero_item (1)").transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image),heroInfo.heroId)

	local power = gf_getItemObject("hero"):get_hero_power(self.heroUid)
	self.refer:Get(4).text = power

	--回收道具
	local itemNode = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects"):Get(3)
	local talent = gf_getItemObject("hero"):getHeroTalentTotal(self.heroUid)
	local items = dataUse.getHeroRecycleItem(heroInfo.level,talent,#heroInfo.skill)
	self.items = items
	gf_print_table(items, "回收items：")
	
	for i=1,4 do
		local item = itemNode.transform:FindChild("item"..i)
		local v = items[i]
		if i > 4 then
			break
		end
		item.gameObject:SetActive(false)
		if v then
			item.gameObject:SetActive(true)
			gf_set_item( v[1], item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image), item.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image))
			local countText = item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
			countText.text = v[2]
		end
		
	end
end

function heroReCycleView:item_click(event_name)
	local index = string.gsub(event_name,"item","")
	index = tonumber(index)
	local data = self.items[index]
	gf_getItemObject("itemSys"):common_show_item_info(data[1])
end

--鼠标单击事件
function heroReCycleView:on_click(obj, arg)
    local eventName = obj.name
    print("heroReCycleView click"..eventName)
    if eventName == "lianhunCloseBtn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()
    elseif eventName == "hero_recycle" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local value = LuaHelper.GetComponent(self.root,"Hugula.ReferGameObjects"):Get(1).text
    	-- gf_getItemObject("hero"):sendToLetItGo(self.heroUid)
    	if value == commomString[1] then
    		gf_getItemObject("hero"):sendToLetItGo(self.heroUid)
   			return
    	end
    	gf_message_tips(commomString[2])

    elseif string.find(eventName,"item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(eventName)
    
    end
end

function heroReCycleView:clear()
end
-- 释放资源
function heroReCycleView:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroReCycleView:on_showed()
end

function heroReCycleView:on_hided()
	StateManager:remove_register_view(self)
end



function heroReCycleView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "RecycleHeroR") then
			self:hide()
		end
	end
end

return heroReCycleView