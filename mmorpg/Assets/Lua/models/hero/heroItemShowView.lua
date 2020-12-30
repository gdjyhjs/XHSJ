--[[
	背包 武将招募按钮界面
	create at 17.11.16
	by xin
]]
require("models.hero.heroConfig")
require("models.hero.heroPublicFunc")
local LuaHelper = LuaHelper
local dataUse = require("models.hero.dataUse")
local dataUse1 = require("models.horse.dataUse")
local modelName = "hero"
local Enum = require("enum.enum")

local res = 
{
	[1] = "wujiang_mianview_tip.u3d",
}


local commomString = 
{
	[1] = gf_localize_string(""),
}

--@isMain  是否跳转到主ui
local heroItemShowView = class(UIBase,function(self,itemId,guid)
	-- roleId = gf_getItemObject("game"):getId()
	self.itemId = itemId 
	self.guid = guid
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroItemShowView:on_asset_load(key,asset)
	StateManager:register_view(self)
	--如果不是自己的武将 发协议获取 否则拿本地
	self:init_ui()
end

function heroItemShowView:init_ui()

	local item_data = ConfigMgr:get_config("item")[self.itemId]

	local hero_id = item_data.effect[1]

	local heroInfo = ConfigMgr:get_config("hero")[hero_id]
	self.heroInfo = heroInfo
	--名字 品级
	local name_panel = self.refer:Get(7)
	name_panel.text = heroInfo.name

	self.refer:Get(9).text = heroInfo.desc

	--品质
	local bgImage = self.refer:Get(8)
	local heroType = dataUse.getHeroQuality(hero_id)
	local iconName = dataUse.getHeroIcon(heroType)
	gf_setImageTexture(bgImage,iconName )


	--模型
	local model = self.refer:Get(6)
	if model.transform:FindChild("my_model") then
 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
 	end
		
	local callback = function(c_model)
		if model.transform:FindChild("my_model") then
	 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
	 	end
		c_model.name = "my_model"
	end
  	local scale = dataUse.getHeroScaleShow(hero_id)
	local heroModel = dataUse.getHeroModel(hero_id)
	local modelView = require("common.uiModel")(model.gameObject,Vector3(0,-2,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,158,0),scale_rate=Vector3(scale,scale,scale)},callback)

	local skill = {}
	for i=1,8 do
		if heroInfo.skill[i] then
			local entry = {}
			entry.type = 0
			entry.skill = heroInfo.skill[i][2]
			table.insert(skill,entry)
		else
			local entry = {}
			entry.type = -1
			table.insert(skill,entry)
		end
	end

	--技能
	gf_set_skill_panel(hero_id,skill,self.refer:Get(5),self.refer:Get(1))


	--天赋--
	--天资 
	self.refer:Get(10).text = string.format("%d-%d",heroInfo.multiple[1],heroInfo.multiple[2])
	self.refer:Get(11).text = string.format("%d-%d",heroInfo.force[1],heroInfo.force[2])
	self.refer:Get(12).text = string.format("%d-%d",heroInfo.physique[1],heroInfo.physique[2])
	self.refer:Get(13).text = string.format("%d-%d",heroInfo.flexable[1],heroInfo.flexable[2])

	for i,v in ipairs(heroInfo.inherit_attr or {}) do
		self.refer:Get(12 + i * 2).text = ConfigMgr:get_config("propertyname")[v[1]].name
		self.refer:Get(13 + i * 2 ).text = v[2]
	end
end

function heroItemShowView:skill_click(eventName)
	local skill = self.heroInfo.skill
	local index = string.split(eventName,"_")[3]
	index = tonumber(index)

	if skill[index] then
		gf_getItemObject('itemSys'):skill_tips(skill[index][2])
	end

end


function heroItemShowView:call_click()
	gf_getItemObject("bag"):use_item_c2s(self.guid,1,self.itemId)
	self:dispose()
end

--鼠标单击事件
function heroItemShowView:on_click(obj, arg)
	print("heroItemShowView click")
    local eventName = obj.name
    if eventName == "hero_mask" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

    elseif string.find(eventName,"hero_skill") then
    	self:skill_click(eventName)

    elseif eventName == "heroRecruitBtn" then
    	print("招募")
    	self:call_click()

    end
end

function heroItemShowView:clear()
end
-- 释放资源
function heroItemShowView:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroItemShowView:on_showed()
end

function heroItemShowView:on_hided()
	StateManager:remove_register_view(self)
end


function heroItemShowView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("hero") then
		if id2 == Net:get_id2("hero", "OtherPlayerHeroR") then
		end
	end
end

return heroItemShowView