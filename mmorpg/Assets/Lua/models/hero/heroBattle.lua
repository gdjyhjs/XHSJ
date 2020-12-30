--[[
	出战选择界面  属性
	create at 17.10.16
	by xin
]]
require("models.hero.heroPublicFunc")
local dataUse = require("models.hero.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_battle_array.u3d",
}
local item_name 		= "hero_b_item_fight"
local empty_item_name 	= "empty_hero_fight"
local lock_item_name 	= "lock_hero_fight"

local commom_string = 
{
	[1] = gf_localize_string("%d级"),
	[2] = gf_localize_string("武将<color=#B01FE5>%s</color>上阵"),
	[3] = gf_localize_string("武将<color=#B01FE5>%s</color>下阵"),
	[4] = gf_localize_string("出战武将不能下阵"),
	[5] = gf_localize_string("确定花费<color=#B01FE5>%d</color>元宝，开启一个新的栏位？(优先使用绑定元宝)"),
}

local type_to_node = 
{
		togglleSoldier		= ServerEnum.HERO_FUNC_TYPE.PALADIN 	,
		toggleStrategist	= ServerEnum.HERO_FUNC_TYPE.WIZARD 		,
		togglleTank			= ServerEnum.HERO_FUNC_TYPE.MUSCLEMAN 	,
		togglleAssist		= ServerEnum.HERO_FUNC_TYPE.SUPPORT 	,
}

local heroBattle = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroBattle:on_asset_load(key,asset)
	self.select_condition = {}
    self:init_ui()
end

function heroBattle:init_ui()
	self:init_battle_list()
	self:init_prepare_list()
end

--出战中队列
function heroBattle:init_battle_list()
	local pItem = self.refer:Get(3)
	local copyItem = self.refer:Get(2)

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

	local list = SetHeroList(pItem,copyItem,heroList,item_name,empty_item_name,lock_item_name)


end

--未出战队列
function heroBattle:init_prepare_list()
	local data = self:get_prepare_list()
	data = HeroSort(data)	
	if next(data or {}) then
		self.refer:Get(4):SetActive(false)
	else
		self.refer:Get(4):SetActive(true)
	end

	local scroll_view = self.refer:Get(1)

	scroll_view.onItemRender = function(item,index,data)
		
		--头像
		gf_setImageTexture(item:Get(6), dataUse.getHeroHeadIcon(data.heroId))
		
		--名字
		item:Get(1).text = dataUse.getHeroName(data.heroId)
		
		local heroType = dataUse.getHeroQuality(data.heroId)

		--品质框
		local qualityIcon = dataUse.getHeroQualityIcon(heroType)
		gf_setImageTexture(item:Get(5),qualityIcon)

		--战力
		item:Get(4).text = gf_getItemObject("hero"):get_hero_power(data.heroId)
		--觉醒等级
		item:Get(3).text = data.awakenLevel
		--等级
		item:Get(2).text = string.format(commom_string[1],data.level)

	end
		
	scroll_view.data = data
	scroll_view:Refresh(-1,-1)
end

--筛选
function heroBattle:get_prepare_list()
	local data = gf_getItemObject("hero"):get_prepare_hero()
	if next(self.select_condition) then
		local temp = {}
		for i,v in ipairs(data or {}) do
			for ii,vv in ipairs(self.select_condition or {}) do
				local heroInfo = dataUse.getHeroInfoById(v.heroId)
				if vv == heroInfo.func_type then
					table.insert(temp,v)
				end
			end
		end
		data = temp
	end
	return data
end


function heroBattle:hero_select(arg)
	local data = arg.data
	-- gf_print_table(data, "data wtf :")
	gf_getItemObject("hero"):send_to_add_to_fight_list(data.heroId,1)
	-- gf_getItemObject("hero"):test_add_to_fight(data.heroId,1)
end

function heroBattle:hero_remove_fight(event_name)
	local hero_id = string.gsub(event_name,item_name,"")
	hero_id = tonumber(hero_id)

	if hero_id == gf_getItemObject("hero"):getFightId() then
		gf_message_tips(commom_string[4])
		return
	end
	gf_getItemObject("hero"):send_to_add_to_fight_list(hero_id,2)
	-- gf_getItemObject("hero"):test_add_to_fight(hero_id,2)
end

function heroBattle:item_lock_click()
	
	local sure_fun = function()
		gf_getItemObject("hero"):sendToUnLockHeroSlot()
	end
	local size = gf_getItemObject("hero"):getHeroPrepareSize()
	local count = dataUse.getOpenPrice(size + 1)
	local content = string.format(commom_string[5],count)
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun,cancle_fun)
end
--鼠标单击事件
function heroBattle:on_click( obj, arg)
	local event_name = obj.name
	print("heroBattle click",event_name)
    if event_name == "btn_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "togglleSoldier" or event_name == "toggleStrategist" or event_name == "togglleTank" or event_name == "togglleAssist" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	arg:SetActive(not arg.activeSelf)
    	if arg.activeSelf then
    		table.insert(self.select_condition,type_to_node[event_name])
    	else
    		for i,v in ipairs(self.select_condition or {}) do
    			if type_to_node[event_name] == v then
    				table.remove(self.select_condition,i)
    			end 
    		end
    	end 
    	gf_print_table(self.select_condition, "wtf self.select_condition:")
    	self:init_prepare_list()

    elseif string.find(event_name , "prepare_hero_item") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:hero_select(arg)

   	elseif string.find(event_name , item_name) then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		self:hero_remove_fight(event_name)

   	elseif event_name == lock_item_name then
   		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
   		self:item_lock_click()

   	elseif event_name == "battle_btn_close" then
   		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
   		self:dispose()

    end
end

function heroBattle:on_showed()
	StateManager:register_view(self)
end

function heroBattle:clear()
	StateManager:remove_register_view(self)
end

function heroBattle:on_hided()
	self:clear()
end
-- 释放资源
function heroBattle:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroBattle:on_receive( msg, id1, id2, sid ) 
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "SetHeroToFightListR") then
			if msg.err == 0 then
				local hero_name = dataUse.getHeroName(msg.heroId)
				if msg.action == 1 then
					gf_message_tips(string.format(commom_string[2],hero_name))
				else
					gf_message_tips(string.format(commom_string[3],hero_name))
				end
				self:init_ui()
			end

		elseif id2 == Net:get_id2(model_name, "UnlockHeroSlotR") then
			self:init_ui()
		end
	end
end

return heroBattle