
--[[
	武将图鉴界面  属性
	create at 17.10.16
	by xin
]]
local dataUse = require("models.hero.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_illustration.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("觉醒:%d"),
}
local type_to_node = 
{
	toggleAll			= 0,
	togglleHave			= -1,
	togglleSoldier		= ServerEnum.HERO_FUNC_TYPE.PALADIN 	,
	togglleStrategist	= ServerEnum.HERO_FUNC_TYPE.WIZARD 		,
	togglleTank			= ServerEnum.HERO_FUNC_TYPE.MUSCLEMAN 	,
	togglleAssist		= ServerEnum.HERO_FUNC_TYPE.SUPPORT 	,
}

local heroIllustration = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroIllustration:on_asset_load(key,asset)
    self:init_ui()
end

function heroIllustration:init_ui()
	self.select_condition_left = type_to_node.toggleAll
	self.select_condition_right = {}

	self.toggle = 
	{
		toggleAll			= self.refer:Get(5),
		togglleHave			= self.refer:Get(4),
	}
	
	self:init_check_state()

	local scroll_view = self.refer:Get(1)

	self.item_list = {}

	scroll_view.onItemRender = function(item,index,data)
			
		self:update_item(item,data,index)
		
		self.item_list[data.hero_id] = item

	end
	
	self:refresh_data()

end

function heroIllustration:update_item(item,data,index)
	--品质
	-- local heroType = dataUse.getHeroQuality(data.heroId)
	local iconName = dataUse.getHeroQualityIcon(data.hero_type)
	gf_setImageTexture(item:Get(2),iconName )


	-- gf_setImageTexture(item:Get(1),dataUse.getHeroHeadIcon(data.heroId))
	gf_setImageTexture(item:Get(1),data.icon)

	--名字 
	-- item:Get(3).text = dataUse.getHeroName(data.heroId) 
	item:Get(3).text = data.name --dataUse.getHeroName(data.heroId) 
	
	--等级
	item:Get(7):SetActive(false)
	item:Get(11):SetActive(true)
	item:Get(9):SetActive(true)
	item:Get(6).text = ""
	--碎片 
	--如果获得了
	-- item:Get(7):SetActive(false)
	local hero_data = gf_getItemObject("hero"):getHeroInfo(data.hero_id)
	item:Get(1).material = self.refer:Get(7)
	if next(hero_data or {}) then 
		local chip = gf_getItemObject("hero"):getHeroLeftChip(data.hero_id)
		if hero_data.level > 0 then
			item:Get(11):SetActive(false)
			item:Get(1).material = nil
			item:Get(9):SetActive(false)
			--觉醒
			item:Get(7):SetActive(true)
			item:Get(8).text = string.format("Lv. %d",hero_data.level)
			local max_data = dataUse.get_awake_max_data(data.hero_id)
			item:Get(6).text = string.format(commom_string[1],hero_data.awakenLevel) 
			local awake_info = hero_data.awakenLevel == max_data.awaken_level and dataUse.getHeroAwakeData(hero_data.heroId,hero_data.awakenLevel ) or dataUse.getHeroAwakeData(hero_data.heroId,hero_data.awakenLevel + 1)
			local total_chip = dataUse.getHeroName(hero_data.heroId)
			item:Get(4).text = string.format("%d/%d",chip,awake_info.chip_count)
			item:Get(5).fillAmount = chip/awake_info.chip_count
		    item:Get(11):SetActive(false)
		else
			local awake_info = dataUse.getHeroAwakeData(hero_data.heroId,0)
			item:Get(4).text = string.format("%d/%d",chip,awake_info.chip_count)
			item:Get(5).fillAmount = chip/awake_info.chip_count
		end
		
	else

		local awake_info = dataUse.getHeroAwakeData(data.hero_id,0)
		item:Get(4).text = string.format("%d/%d",0,awake_info.chip_count)
		item:Get(5).fillAmount = 0
	end
end

function heroIllustration:refresh_data()
	local data = self:get_select_data()

	self.refer:Get(6):SetActive(false)
	if not next(data or {}) then
		self.refer:Get(6):SetActive(true)
	end

	local scroll_view = self.refer:Get(1)
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
end

function heroIllustration:get_hero_have()
	local data = gf_getItemObject("hero"):get_hero_have()
	local temp = {}
	for i,v in ipairs(data or {}) do
		local hero_info = dataUse.getHeroInfoById(v.heroId)
		table.insert(temp,hero_info)
	end
	return temp
end

function heroIllustration:get_select_data()
	local data 

	if self.select_condition_left == type_to_node.togglleHave then
		data = self:get_hero_have()
		--排序
		table.sort(data,function(a,b)return a.hero_id < b.hero_id end)
	else
		data = dataUse.getHeroConfig()
	end

	--筛选
	if next(self.select_condition_right) then
		local temp = {}
		for i,v in ipairs(data or {}) do
			for ii,vv in ipairs(self.select_condition_right or {}) do
				if vv == v.func_type then
					table.insert(temp,v)
				end
			end
		end
		data = temp
	end
	return data
end

function heroIllustration:hero_item_click(arg)
	local hero_data = gf_getItemObject("hero"):getHeroInfo(arg.data.hero_id)
	if hero_data and hero_data.level > 0 then
		require("models.hero.heroTrainNew")(arg.data.hero_id)

	else
		require("models.hero.heroDetails")(arg.data.hero_id)
	end
end

--鼠标单击事件
function heroIllustration:on_click( obj, arg)
	local event_name = obj.name
	print("heroIllustration click",event_name)
    if event_name == "hero_relive" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	require("models.hero.heroBattle")()


    elseif event_name == "togglleSoldier" or 
    	event_name == "togglleStrategist" or 
    	event_name == "togglleTank" or 
    	event_name == "togglleAssist" then
    		
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效

    	arg:SetActive(not arg.activeSelf)
    	
		if arg.activeSelf then
    		table.insert(self.select_condition_right,type_to_node[event_name])
    	else
    		for i,v in ipairs(self.select_condition_right or {}) do
    			if type_to_node[event_name] == v then
    				table.remove(self.select_condition_right,i)
    			end
    		end
    	end
    	gf_print_table(self.select_condition_right, "wtf self.select_condition_right:")
    	self:refresh_data()
    	
    elseif event_name == "toggleAll" or event_name == "togglleHave" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self.select_condition_left = type_to_node[event_name]

    	arg:SetActive(not arg.activeSelf)

    	self:refresh_data()

    elseif string.find(event_name,"illust_hero_item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:hero_item_click(arg)

    elseif event_name == "illust_btnHelp" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_show_doubt(1081)
    	
    end
end


--初始化选中状态
function heroIllustration:init_check_state()
	self.refer:Get(2).isOn = true
	self.refer:Get(3):SetActive(true)
end


function heroIllustration:on_showed()
	StateManager:register_view(self)
end

function heroIllustration:clear()
	StateManager:remove_register_view(self)
end

function heroIllustration:on_hided()
	self:clear()
end
-- 释放资源
function heroIllustration:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroIllustration:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "AwakenHeroR") then
			if msg.err == 0 then
				local hero_id,chip = unpack(Net:get_sid_param(sid))

				if self.item_list[hero_id] then
					local item = self.item_list[hero_id]
					local data = item.data
					local index = item.index
					self:update_item(item,data,index)
				end

			end

		end
	end
end

return heroIllustration