--[[
	武将详情界面  属性
	create at 17.6.9
	by xin
]]
local dataUse = require("models.hero.dataUse")
local dataUse1 = require("models.horse.dataUse")
require("models.hero.heroPublicFunc")
local model_name = "hero"

local res = 
{
	[1] = "hero_intro.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local heroDetails = class(UIBase,function(self,hero_id)
	self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroDetails:on_asset_load(key,asset)
    self:init_ui()
end

function heroDetails:init_ui()
	SetHeroModel(self.refer:Get(1),self.hero_id,nil,1)

	local hero_info = dataUse.getHeroInfoById(self.hero_id)

	--品质
	local heroType = dataUse.getHeroQuality(self.hero_id)
	local iconName = dataUse.getHeroIcon(heroType)
	gf_setImageTexture(self.refer:Get(2),iconName )
	--名字 
	self.refer:Get(3).text = dataUse.getHeroName(self.hero_id) 

	self.refer:Get(6).text = hero_info.desc

	--天资
	local data = dataUse.getHeroTalent(self.hero_id)
	self.refer:Get(7).text = string.format("%d-%d",data[1],data[2])

	local data = dataUse.getHeroTalentPower(self.hero_id)
	self.refer:Get(8).text = string.format("%d-%d",data[1],data[2])

	local data = dataUse.getHeroTalentStrength(self.hero_id)
	self.refer:Get(9).text = string.format("%d-%d",data[1],data[2])

	local data = dataUse.getHeroTalentSpirit(self.hero_id)
	self.refer:Get(10).text = string.format("%d-%d",data[1],data[2])


	--继承
	-- self.refer:Get(11).text = ConfigMgr:get_config("propertyname")[hero_info.inherit_attr].name
	-- self.refer:Get(12).text = hero_info.inherit_attr_value

	local p_node = self.refer:Get(5)
 	local inherit_attr = gf_get_config_table("hero")[self.hero_id].inherit_attr
 	gf_print_table(inherit_attr, "wtf inherit_attr:")
 	for i,v in ipairs(inherit_attr or {}) do
 		local name = p_node.transform:FindChild("p"..i).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
 		name.text = ConfigMgr:get_config("propertyname")[v[1]].name
 		local value = p_node.transform:FindChild("p"..i).transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")
 		value.text = v[2]
 	end

 	--隐藏剩余
 	for i=#inherit_attr + 1,4 do
 		local name = p_node.transform:FindChild("p"..i).transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text")
 		name.text = ""
 		local value = p_node.transform:FindChild("p"..i).transform:FindChild("Text (1)"):GetComponent("UnityEngine.UI.Text")
 		value.text = ""
 	end

	for i=1,8 do 
		local skill_item = self.refer:Get(13).transform:FindChild("item_item"..i)
		skill_item.transform:FindChild("icon").gameObject:SetActive(false)
		if skill_item.transform:FindChild("Image") then
			skill_item.transform:FindChild("Image").gameObject:SetActive(false)
		end
		
	end

	--技能
	local skill = hero_info.skill
	for i,v in ipairs(skill) do
		local skill_item = self.refer:Get(13).transform:FindChild("item_item"..i)
		skill_item.transform:FindChild("icon").gameObject:SetActive(true)
		-- local icon = skill_item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		-- local icon_res = dataUse1.get_skill_icon(v[2])
		-- gf_setImageTexture(icon, icon_res)

		-- local color = dataUse1.get_skill_color(v[2])

		-- gf_set_quality_bg(bg,color)

		gf_set_hero_skill(v[2],skill_item)

		if skill_item.transform:FindChild("Image") then
			print("v[2] == dataUse.getOwnSkill(self.hero_id):",v[2] , dataUse.getOwnSkill(self.hero_id))
			skill_item.transform:FindChild("Image").gameObject:SetActive(v[2] == dataUse.getOwnSkill(self.hero_id) )
			-- skill_item.transform:FindChild("Image").gameObject:SetActive(v[2] ~= dataUse.getOwnSkill(self.hero_id) )
		end
		
	end
end

--鼠标单击事件
function heroDetails:on_click( obj, arg)
	local event_name = obj.name
	print("heroDetails click",event_name)
    if event_name == "train_btn_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif string.find(event_name,"item_item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local index = string.gsub(event_name,"item_item","")
    	index = tonumber(index)
    	local hero_info = dataUse.getHeroInfoById(self.hero_id)
		local skill = hero_info.skill[index]
		if skill then
			gf_getItemObject('itemSys'):skill_tips(skill[2])
		end
    	
    end
end

function heroDetails:on_showed()
	StateManager:register_view(self)
end

function heroDetails:clear()
	StateManager:remove_register_view(self)
end

function heroDetails:on_hided()
	self:clear()
end
-- 释放资源
function heroDetails:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroDetails:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "WakeUpHeroR") then
		end
	end
end

return heroDetails