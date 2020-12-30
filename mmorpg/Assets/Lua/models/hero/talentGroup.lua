--[[
	天赋升级界面  属性
	create at 17.10.12
	by xin
]]
local dataUse = require("models.hero.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_upgrade_talent.u3d",
	[2] = "scroll_table_cell_bg_02_normal",
	[3] = "scroll_table_cell_bg_02_select",
	
}

local commom_string = 
{
	[1] = gf_localize_string("战力：%d"),
	[2] = gf_localize_string("觉醒：%d"),
	[3] = gf_localize_string("%d级"),
	[4] = gf_localize_string("没有道具"),
	[5] = gf_localize_string("%s已经突破天际"),
}

--资质道具
local item_list = 
{
	[ServerEnum.HERO_TALENT_TYPE.FORCE]			=40300301,
	[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]		=40310301,
	[ServerEnum.HERO_TALENT_TYPE.FLEXABLE]		=40320301,
	[ServerEnum.HERO_TALENT_TYPE.MULTIPLE]		=40440301,
}

local to_type = 
{
	power_up 		= ServerEnum.HERO_TALENT_TYPE.FORCE		,
	strenght_up 	= ServerEnum.HERO_TALENT_TYPE.PHYSIQUE	,
	spirite_up 		= ServerEnum.HERO_TALENT_TYPE.FLEXABLE	,
	talent_up  		= ServerEnum.HERO_TALENT_TYPE.MULTIPLE	,
}

local talentGroup = class(UIBase,function(self,hero_id,type)
	self.type = type
	self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function talentGroup:on_asset_load(key,asset)
    self:init_ui()
end

function talentGroup:init_ui()
	--武将信息--
	local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	--头像
	local head = self.refer:Get(2)
	local head_bg = self.refer:Get(1)
	gf_setImageTexture(head, dataUse.getHeroHeadIcon(self.hero_id))
	gf_setImageTexture(head_bg, dataUse.getHeroQualityIcon(dataUse.getHeroQuality(self.hero_id)))
	--名字
	self.refer:Get(4).text = dataUse.getHeroName(self.hero_id)
	--战力
	self.refer:Get(5).text = string.format(commom_string[1],gf_getItemObject("hero"):get_hero_power(self.hero_id))
	--等级
	self.refer:Get(6).text = string.format(commom_string[3],hero_data.level)
	--觉醒等级
	self.refer:Get(7).text = string.format(commom_string[2],hero_data.awakenLevel)

	self:item_update()

	--天资--
	local width,height = 202.32,10
	local pNode = self.refer:Get(15)
	local heroInfo = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	
	local powerPanel = pNode.transform:FindChild("power_up")
	local strenghtPanel = pNode.transform:FindChild("strenght_up")
	local spiritePanel = pNode.transform:FindChild("spirite_up")
	local talentPanel = pNode.transform:FindChild("talent_up")

	if not self.item_image_list  then
		self.item_image_list = 
		{
			[ServerEnum.HERO_TALENT_TYPE.FORCE]			=powerPanel:GetComponent(UnityEngine_UI_Image),
			[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]		=strenghtPanel:GetComponent(UnityEngine_UI_Image),
			[ServerEnum.HERO_TALENT_TYPE.FLEXABLE]		=spiritePanel:GetComponent(UnityEngine_UI_Image),
			[ServerEnum.HERO_TALENT_TYPE.MULTIPLE]		=talentPanel:GetComponent(UnityEngine_UI_Image),
		}
	end

	self:item_click(self.item_image_list[self.type])

	local image1 = powerPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text1 = powerPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	local image2 = strenghtPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text2 = strenghtPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

	local image3 = spiritePanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text3 = spiritePanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")
	
	--天资
	local image4 = talentPanel.transform:FindChild("Image").transform:FindChild("Image"):GetComponent(UnityEngine_UI_Image)
	local text4 = talentPanel.transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")

    --当前等级的天赋
    local data1,data2 = dataUse.getHeroTalentIncludeAwake(self.hero_id,heroInfo.talent,heroInfo.awakenLevel)

	--武力
	local power = data2[ServerEnum.HERO_TALENT_TYPE.FORCE]
	local maxValue = power[2] - power[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.FORCE] - power[1]
	print("minValue maxValue wtf ",minValue,maxValue)
	image1.fillAmount = minValue / maxValue
	text1.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.FORCE],power[2] )

	--体魄
	local power = data2[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE]
	local maxValue = power[2] - power[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE] - power[1]
	image2.fillAmount = minValue / maxValue 
	text2.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.PHYSIQUE],power[2] )

	--灵力
	local power = data2[ServerEnum.HERO_TALENT_TYPE.FLEXABLE]
	local maxValue = power[2] - power[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.FLEXABLE] - power[1]
	image3.fillAmount = minValue / maxValue 
	text3.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.FLEXABLE],power[2] )
	--设置道具
	-- self:setItemView("talent")

	--天赋 
	local talent = data2[ServerEnum.HERO_TALENT_TYPE.MULTIPLE]
	local maxValue = talent[2] - talent[1]
	local minValue = data1[ServerEnum.HERO_TALENT_TYPE.MULTIPLE] - talent[1]
	image4.fillAmount = minValue / maxValue
	text4.text = string.format("%d/%d",data1[ServerEnum.HERO_TALENT_TYPE.MULTIPLE],talent[2] )
end


function talentGroup:item_update()
	--消耗道具
	local item_id = item_list[self.type]
	gf_set_item(item_id, self.refer:Get(9), self.refer:Get(8))
	--背包中的数量 bType,sType,ServerServerEnum.BAG_TYPE.NORMAL
	local count = gf_getItemObject("bag"):get_count_in_bag(item_id)
	self.refer:Get(10).text = count
end

function talentGroup:use_item(type)
	if type == 1 then
		local item = self:get_item_for_type(big_type,small_type,ServerEnum.BAG_TYPE.NORMAL)
		local guid = -1
		table.sort(item,function(a,b) return a.data.bind > b.data.bind end)
		--优先绑定的
	end
end

function talentGroup:item_click(item)
	print("self.type click:",self.type)
	if self.last_bg ~= item then
		gf_setImageTexture(self.last_bg, res[2])
	end
	gf_setImageTexture(item, res[3])
	self.last_bg = item

end

function talentGroup:is_max()
	local heroInfo = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	local data1,data2 = dataUse.getHeroTalentIncludeAwake(self.hero_id,heroInfo.talent,heroInfo.awakenLevel)
	if data1[self.type] >= data2[self.type][2] then
		gf_message_tips(string.format(commom_string[5],dataUse.getTalentName(self.type)))
		return true
	end
	return false
end

--鼠标单击事件
function talentGroup:on_click( obj, arg)
	local event_name = obj.name
	print("talentGroup click",event_name)
    if event_name == "talent_btn_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "btnUse" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if not self:is_max() then
    		gf_getItemObject("hero"):send_to_add_talent(self.hero_id,self.type,1)
    	end
    	

    elseif event_name == "btnOneKeyUse" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	if not self:is_max() then
    		gf_getItemObject("hero"):send_to_add_talent(self.hero_id,self.type,0)
    	end


    elseif event_name == "talent_up" or event_name == "power_up" or event_name == "strenght_up" or event_name == "spirite_up" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self.type = to_type[event_name]
    	self:item_click(arg)
    	self:init_ui()
    	return true
    end
end

function talentGroup:on_showed()
	StateManager:register_view(self)
end

function talentGroup:clear()
	StateManager:remove_register_view(self)
end

function talentGroup:on_hided()
	self:clear()
end
-- 释放资源
function talentGroup:dispose()
	self:clear()
    self._base.dispose(self)
end

function talentGroup:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "AddTalentByItemR") then
			if msg.err == 0 then
				self:init_ui()
			end
			
		end
	end
end

return talentGroup