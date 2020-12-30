--[[
	坐骑进阶界面  属性
	create at 17.6.9
	by xin
]]
local dataUse = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local model_name = "hero"

local res = 
{
	[1] = "wujiang_train.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("%d级"),
}


local heroTrain = class(UIBase,function(self,hero_uid)
	self.hero_uid = hero_uid
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroTrain:on_asset_load(key,asset)
    self:init_ui()
end

function heroTrain:init_ui()

	self:hero_init()

	self:exp_init()

	self:item_init()

end

function heroTrain:hero_init()
	local hero_id = gf_getItemObject("hero"):getHeroInfo(self.hero_uid).heroId
	local head = dataUse.getHeroHeadIcon(hero_id)
	gf_setImageTexture(self.refer:Get(7), head)
end

function heroTrain:exp_init() 
	local hero_data = gf_getItemObject("hero"):getHeroInfo(self.hero_uid)
	self.refer:Get(3).text = string.format(commom_string[1],hero_data.level )
	self.refer:Get(4).text = string.format("%d/%d",hero_data.exp , dataUse.getHeroLevelExp(hero_data.level))
	self.refer:Get(5).fillAmount = hero_data.exp / dataUse.getHeroLevelExp(hero_data.level)

	
end

function heroTrain:item_init()
	--获取背包经验道具
	local items = self:get_bag_items()--require("models.bag.bagUserData"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.HERO_EXP_BOOK)
	local pItem = self.refer:Get(2)
	local copyItem = self.refer:Get(1) 

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	for i,v in ipairs(items or {}) do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)
		
		local item = cItem.transform:FindChild("hero_item")

		--bg --icon
		local bg = item:GetComponent(UnityEngine_UI_Image)
		local icon = item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		gf_set_item(v.item.item.protoId, icon, bg, color)

		--count
		local count_text = item.transform:FindChild("count"):GetComponent("UnityEngine.UI.Text")
		count_text.text = v.count

		item.name = "exp_item_"..v.item.item.protoId

		cItem.transform:FindChild("hero_train_item_use").name = "hero_train_item_use"..v.item.item.protoId

	end
end

--整合道具
function heroTrain:get_bag_items()
	local items = gf_getItemObject("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.HERO_EXP_BOOK,ServerEnum.BAG_TYPE.NORMAL)
	gf_print_table(items, "wtf items:")
	local temp = {}
	for i,v in ipairs(items or {}) do
		if not temp[v.data.effect[1]] then
			temp[v.data.effect[1]] = {}
			temp[v.data.effect[1]].item = v
			temp[v.data.effect[1]].count = 0
		end
		temp[v.data.effect[1]].count = temp[v.data.effect[1]].count + v.item.num
	end
	--排序
	local tempex = {}
	for k,v in pairs(temp or {}) do
		table.insert(tempex,v)
	end

	table.sort(tempex ,function(a,b)return a.item.data.effect[1] < b.item.data.effect[1] end)
	return tempex
end

function heroTrain:group_level_click()
end

function heroTrain:group_top_click()
end

function heroTrain:item_click(event_name)
	local item_id = string.gsub(event_name,"exp_item_","")
	item_id = tonumber(item_id)
	gf_getItemObject("itemSys"):common_show_item_info(item_id)

end

function heroTrain:item_use_click(event_name)
	local item_id = string.gsub(event_name,"hero_train_item_use","")
	item_id = tonumber(item_id)

end

--鼠标单击事件
function heroTrain:on_click( obj, arg)
    local event_name = obj.name
    print("heroTrain click",event_name)
    if event_name == "hero_train_close" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()

    elseif event_name == "next_level" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:group_level_click()

    elseif event_name == "top_level" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:group_top_click()

    elseif string.find(event_name,"exp_item_") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(event_name)

    elseif string.find(event_name,"hero_train_item_use") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_use_click(event_name)

    end
end

function heroTrain:on_showed()
	StateManager:register_view(self)
end

function heroTrain:clear()
	StateManager:remove_register_view(self)
end

function heroTrain:on_hided()
	self:clear()
end
-- 释放资源
function heroTrain:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroTrain:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(modelName) then
		if id2 == Net:get_id2(modelName, "WakeUpHeroR") then
		end
	end
end

return heroTrain