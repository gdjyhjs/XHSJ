--[[
	武将重生  属性
	create at 17.10.17
	by xin
]]
local dataUse = require("models.hero.dataUse")
local model_name = "hero"

local res = 
{
	[1] = "hero_rebron.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("战力:%d"),
	[2] = gf_localize_string("%d级"),
	[3] = gf_localize_string("觉醒%d"),
	[4] = gf_localize_string("重生消耗%s"),
	[5] = gf_localize_string("金币不足"),
}

local exp_item = 
{
	gf_get_config_const("hero_exp_book3"),gf_get_config_const("hero_exp_book2"),gf_get_config_const("hero_exp_book1"),
}

local heroReborn = class(UIBase,function(self,hero_id)
	self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroReborn:on_asset_load(key,asset)
	gf_getItemObject("hero"):sendToGetTalentItemHistory(self.hero_id)
    -- self:init_ui()
end

function heroReborn:init_ui()
	local hero_bg = self.refer:Get(1)
	local hero_icon = self.refer:Get(2)

	gf_setImageTexture(hero_icon, dataUse.getHeroHeadIcon(self.hero_id) )

	local heroType = dataUse.getHeroQuality(self.hero_id)
	local qualityIcon = dataUse.getHeroQualityIcon(heroType)
	gf_setImageTexture(hero_bg,qualityIcon)

	local hero_info = gf_getItemObject("hero"):getHeroInfo(self.hero_id)

	self.refer:Get(3).text = dataUse.getHeroName(self.hero_id)
	self.refer:Get(4).text = string.format(commom_string[1],gf_getItemObject("hero"):get_hero_power(self.hero_id))
	self.refer:Get(5).text = string.format(commom_string[2],hero_info.level)
	self.refer:Get(6).text = string.format(commom_string[3],hero_info.awakenLevel)

	local data = self:get_reborn_item()
	gf_print_table(data, "wtf data item:")
	for i=1,10 do
		local item = self.refer:Get(8).transform:FindChild("item"..i)
		item.transform:FindChild("icon").gameObject:SetActive(false)
		item.transform:FindChild("bg").gameObject:SetActive(false)
		-- gf_setImageTexture(bg, "item_color_0")
		item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text").text = ""
		item.transform:FindChild("binding").gameObject:SetActive(false)
	end
	for i=1,10 do
		local v = data[i]
		
		local item = self.refer:Get(8).transform:FindChild("item"..i)
		item.transform:FindChild("icon").gameObject:SetActive(true)
		item.transform:FindChild("bg").gameObject:SetActive(true)
		if next(v or {}) then
			local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
			local bg = item.transform:FindChild("bg"):GetComponent(UnityEngine_UI_Image)
			gf_set_item(v.protoId, icon, bg)
			item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text").text = v.count
			item.transform:FindChild("binding").gameObject:SetActive(true)
		end
		
	end

	--需要小号铜币
	local count = ConfigMgr:get_config("t_misc").hero.recycle_need_coin
	self.refer:Get(7).text = string.format(commom_string[4],gf_format_count(count))
end

function heroReborn:get_reborn_item()
	local hero_info = gf_getItemObject("hero"):getHeroInfo(self.hero_id)
	--经验书
	local total_exp = dataUse.getHeroTotalExp(self.hero_id,hero_info.level) + hero_info.exp
	total_exp = total_exp * 0.8
	print("total_exp:",total_exp)
	local temp = {}
	for i,v in ipairs(exp_item) do
		local item = gf_getItemObject("itemSys"):get_item_for_id(v)
		local count = math.floor(total_exp / item.effect[1])
		if count > 0 then
			local tb = {}
			tb.protoId = v
			tb.count = count
			total_exp = total_exp % item.effect[1]
			table.insert(temp,tb)
		end
	end

	--武将碎片
	local chip = dataUse.getHeroTotalChip(self.hero_id,hero_info.awakenLevel)
	if chip > 0 then
		tb = {}
		tb.protoId = dataUse.getHeroChipId(self.hero_id)
		tb.count = chip 
		table.insert(temp,tb)
	end

	for i,v in ipairs(self.talentItemHistory or {}) do
		v.count = math.floor(v.count * gf_get_config_table("t_misc").hero.recycle_pecent.talent / 10000)
		table.insert(temp,v)
	end

	return temp
end

--鼠标单击事件
function heroReborn:on_click( obj, arg)
	local event_name = obj.name
	print("heroReborn click",event_name)
    if event_name == "reborn_btn_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:dispose()

    elseif event_name == "btn_Rebron" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:dispose()
    	gf_getItemObject("hero"):sendToLetItGo(self.hero_id)

    end
end

function heroReborn:on_showed()
	StateManager:register_view(self)
end

function heroReborn:clear()
	StateManager:remove_register_view(self)
end

function heroReborn:on_hided()
	self:clear()
end
-- 释放资源
function heroReborn:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroReborn:get_talent_item_history_back(msg)
	if msg.err == 0 then
		self.talentItemHistory = msg.talentItemHistory 
		self:init_ui()
	end
end

function heroReborn:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "GetTalentItemHistoryR") then
			gf_print_table(msg, "GetTalentItemHistoryR:")
			self:get_talent_item_history_back(msg)

		end
	end
end

return heroReborn