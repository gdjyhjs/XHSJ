
--[[
	武将觉醒界面  属性
	create at 17.6.9
	by xin
]]
local dataUse = require("models.hero.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_awaken.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("觉醒%s"),
	[2] = gf_localize_string("前"),
}


local heroAwaken = class(UIBase,function(self,hero_id)
	print("wtf you heroAwaken")
	self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj

	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroAwaken:on_asset_load(key,asset)
	self._base.on_asset_load(self)
    self:init_ui()
end

function heroAwaken:init_ui(is_awaken)

	if not is_awaken then
		SetHeroModel(self.refer:Get(1),self.hero_id,nil,1)
	end
	
	--品质
	local heroType = dataUse.getHeroQuality(self.hero_id)
	local iconName = dataUse.getHeroIcon(heroType)
	gf_setImageTexture(self.refer:Get(9),iconName )
	--名字 
	self.refer:Get(10).text = dataUse.getHeroName(self.hero_id)  

	local qualityIcon = dataUse.getHeroQualityIcon(heroType)
	gf_setImageTexture(self.refer:Get(2),qualityIcon)

	gf_setImageTexture(self.refer:Get(3), dataUse.getHeroHeadIcon(self.hero_id))

	local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	local max_data = dataUse.get_awake_max_data(self.hero_id)
	
	--当前等级的天赋
	local data1,data2 = dataUse.getHeroTalentIncludeAwake(self.hero_id,hero_data.talent,hero_data.awakenLevel)

	
	
	self:init_talent_view(self.refer:Get(11),data1,data2)
	self.refer:Get(7).text = string.format(commom_string[1],hero_data.awakenLevel == 0  and commom_string[2] or hero_data.awakenLevel)
	self.refer:Get(5).text = gf_getItemObject("hero"):get_hero_power(self.hero_id)

	gf_print_table(hero_data, "wtf  fff hero_data")

	--如果已经满级
	local chip = gf_getItemObject("hero"):getHeroLeftChip(self.hero_id)
	if max_data.awaken_level == hero_data.awakenLevel then
		
		self:init_talent_view(self.refer:Get(12),data1,data2)

		self.refer:Get(8).text = string.format(commom_string[1],hero_data.awakenLevel)
		
		self.refer:Get(6).text = gf_getItemObject("hero"):get_hero_power(self.hero_id)

		--数量
		local awake_info = dataUse.getHeroAwakeData(self.hero_id,hero_data.awakenLevel )
		self.refer:Get(4).text = string.format("%d/%d",chip,awake_info.chip_count)

	else
		--数量
		local awake_info = dataUse.getHeroAwakeData(self.hero_id,hero_data.awakenLevel + 1)
		self.refer:Get(4).text = string.format("%d/%d",chip,awake_info.chip_count)

		local ndata1,ndata2 = dataUse.getHeroTalentIncludeAwake(self.hero_id,hero_data.talent,hero_data.awakenLevel + 1)
		self:init_talent_view(self.refer:Get(12),ndata1,ndata2)

		self.refer:Get(8).text = string.format(commom_string[1],hero_data.awakenLevel + 1)

		self.refer:Get(6).text = gf_getItemObject("hero"):get_hero_power(self.hero_id,ndata1)
	end
	
end

function heroAwaken:init_talent_view(node,data1,data2)
	SetHeroTalent(node,data1,data2,self.hero_id)
end

--鼠标单击事件
function heroAwaken:on_click( obj, arg)
	local event_name = obj.name
	print("heroAwaken click",event_name)
    if event_name == "awake_btn_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()
    	
    elseif event_name == "btnAwaken" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_getItemObject("hero"):sendToAwakenHero(self.hero_id)

    elseif event_name == "awaken_btnHelp" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_show_doubt(1083)

    end
end

function heroAwaken:on_showed()
	StateManager:register_view(self)
end

function heroAwaken:clear()
	StateManager:remove_register_view(self)
end

function heroAwaken:on_hided()
	self:clear()
end
-- 释放资源
function heroAwaken:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroAwaken:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "AwakenHeroR") then
			if msg.err == 0 then
				self.refer:Get(13):SetActive(false)
    			self.refer:Get(13):SetActive(true)
				self:init_ui(true)
			end

		elseif id2 == Net:get_id2(model_name, "GainHeroChipR") then
			-- self:init_ui()

		end
	end
end

return heroAwaken