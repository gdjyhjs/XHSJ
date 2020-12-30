--[[
	武将系统 查看武将信息
	create at 17.6.6
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
	[1] = "hero_world_channel.u3d",
}

local switch_type = 
{
	property = 1,
	talent 	 = 2,
}

local commomString = 
{
	[1] = gf_localize_string("觉醒%d"),
	[2] = gf_localize_string("未觉醒"),
}

--@isMain  是否跳转到主ui
local heroShowHeroInfo = class(UIBase,function(self,roleId,heroId)
	-- roleId = gf_getItemObject("game"):getId()
	print("wtf roleId,heroId:",roleId,heroId)
	self.roleId = roleId 
	self.heroId = heroId or 420002
	self.heroInfo = nil
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
		
end)

function heroShowHeroInfo:uiLoad()
	local resName = res[1]
	Asset._ctor(self, resName) -- 资源名字全部是小写
end

--资源加载完成
function heroShowHeroInfo:on_asset_load(key,asset)
	StateManager:register_view(self)
	--如果不是自己的武将 发协议获取 否则拿本地
	local myRoleId = gf_getItemObject("game"):getId()
	if myRoleId == self.roleId then
		local heroInfo = gf_getItemObject("hero"):getHeroInfo(self.heroId)
		local propertyData = gf_getItemObject("hero"):getHeroProperty(self.heroId)
		if next(heroInfo or {}) then
			self.heroInfo = heroInfo
			self.property = propertyData
			self:init_ui()
		end
		return
	end
	gf_getItemObject("hero"):sendToCheckOtherHero(self.roleId,self.heroId)
end

function heroShowHeroInfo:init_ui()
	--发送协议获取武将
	self:clear()
	self:heroInfoInit()
end

function heroShowHeroInfo:heroInfoInit()

	local heroInfo = self.heroInfo

	--名字 品级
	local name_panel = self.refer:Get(13)
	local heroName = dataUse.getHeroName(self.heroInfo.heroId)
	name_panel.text = heroName

	self:switch_info(switch_type.property)
 	
	--品质
	local bgImage = self.refer:Get(5)
	local heroType = dataUse.getHeroQuality(self.heroInfo.heroId)
	local iconName = dataUse.getHeroIcon(heroType)
	gf_setImageTexture(bgImage,iconName )

	--装备
	SetHeroEquipView(self.refer:Get(1),heroInfo.heroEquipInfo,"militayr_train_equip")

	--模型
	local model = self.refer:Get(3)
	if model.transform:FindChild("my_model") then
 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
 	end
		
	local callback = function(c_model)
		if model.transform:FindChild("my_model") then
	 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
	 	end
		c_model.name = "my_model"
	end
  	local scale = dataUse.getHeroScaleShow(self.heroInfo.heroId)
	local heroModel = dataUse.getHeroModel(self.heroInfo.heroId) or 420005
	local modelView = require("common.uiModel")(model.gameObject,Vector3(0,-2,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,158,0),scale_rate=Vector3(scale,scale,scale)},callback)

	local skill = {}
	for i=1,8 do
		if self.heroInfo.skill[i] then
			local entry = {}
			entry.type = 0
			entry.skill = self.heroInfo.skill[i]
			table.insert(skill,entry)
		else
			local entry = {}
			entry.type = -1
			table.insert(skill,entry)
		end
	end

	--技能
	gf_set_skill_panel(self.heroId,skill,self.refer:Get(11),self.refer:Get(12))

	--觉醒等级 
	self.refer:Get(17).text = self.heroInfo.awakenLevel > 0 and string.format(commomString[1] , self.heroInfo.awakenLevel) or commomString[2]

	--战力
	local power = gf_getItemObject("hero"):get_power(self.property, self.heroInfo.skill, true)
	self.refer:Get(2).text = power

end

function heroShowHeroInfo:skill_click(eventName)
	local skill = self.heroInfo.skill
	local index = string.split(eventName,"_")[3]
	index = tonumber(index)

	if skill[index] then
		gf_getItemObject('itemSys'):skill_tips(skill[index])
	end

end


function heroShowHeroInfo:switch_info(type)
	self.refer:Get(14):SetActive(type == switch_type.property)
	self.refer:Get(15):SetActive(type == switch_type.talent)

	self.refer:Get(6):SetActive(type == switch_type.property)
	self.refer:Get(7):SetActive(type == switch_type.talent)

	if type == 1 then
		gf_print_table(self.property, "self.property:")
		SetHeroProperty(self.heroId,self.refer:Get(4),self.property)

	else
		local data1,data2 = dataUse.getHeroTalentIncludeAwake(self.heroId,self.heroInfo.talent,self.heroInfo.awakenLevel)
	    SetHeroTalent(self.refer:Get(7),data1,data2,self.heroId)

	end
end

--鼠标单击事件
function heroShowHeroInfo:on_click(obj, arg)
	print("heroShowHeroInfo click")
    local eventName = obj.name
    if eventName == "btn_close" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()

    elseif eventName == "hero_check_property" then
    	self:switch_info(switch_type.property)

    elseif eventName == "hero_check_talent" then
    	self:switch_info(switch_type.talent)

    elseif string.find(eventName,"hero_skill") then
    	self:skill_click(eventName)

    end
end

function heroShowHeroInfo:clear()
end
-- 释放资源
function heroShowHeroInfo:dispose()
	self:clear()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function heroShowHeroInfo:on_showed()
end

function heroShowHeroInfo:on_hided()
	StateManager:remove_register_view(self)
end

function heroShowHeroInfo:test()
	print("DEBUG:0",DEBUG)
	if DEBUG then
		local hero = {    
		      
		        deadTime = 0,    
		        exp = 0,    
		        skill = {    
		             12006006,    
		        },    
		        heroEquipInfo = {},
		        name ="",    
		        talent = {    
		            [1] = 703,    
		            [2] = 887,    
		            [3] = 793,    
		            [4] = 681,    },
		        chip = 10,    
		        level = 1,    
		        awakenLevel = 0,    
		        heroId = 420002,    
		       

		}

		local msg = {}
		msg.err = 0
		msg.hero = hero
		msg.heroAttr = {{1,20},{2,250},{3,20},{4,20},{5,20},{6,20},{7,20},{8,20},{9,20},{10,20},{11,20},{42,20}}

		gf_send_and_receive(msg, "hero", "OtherPlayerHeroR", sid)
	end
end



function heroShowHeroInfo:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("hero") then
		if id2 == Net:get_id2("hero", "OtherPlayerHeroR") then
			gf_print_table(msg, "接收到查看武将返回")
			if msg.err ~= 0 then
				self:hide()
				return
			end
			self.heroInfo = msg.hero
			--处理属性
			local temp = {}
			for i,v in ipairs(msg.heroAttr) do
				temp[v.attr] = v.value
				-- temp[v[1]] = v[2]
			end

			self.property = temp

			self:init_ui()
		end
	end
end

return heroShowHeroInfo