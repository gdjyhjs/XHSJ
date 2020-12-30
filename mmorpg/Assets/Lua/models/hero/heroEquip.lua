--[[
	武将装备界面  属性
	create at 17.10.11
	by xin
]]

local res = 
{
	[1] = "hero_equip.u3d",
}
local dataUse = require("models.hero.dataUse")

local model_name = "hero"

local commom_string = 
{
	[1] = gf_localize_string(""),
}

local equip_pos = 
{
	[1] = ServerEnum.HERO_EQUIP_TYPE.WEAPON,
	[2] = ServerEnum.HERO_EQUIP_TYPE.ARMOR,
	[3] = ServerEnum.HERO_EQUIP_TYPE.DECORATION,
}
local heroEquip = class(UIBase,function(self,hero_id)
	self.hero_id = hero_id
	local item_obj = LuaItemManager:get_item_obejct("hero")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function heroEquip:on_asset_load(key,asset)
	self._base.on_asset_load(self)
    self:init_ui()
end

function heroEquip:init_ui()

	SetHeroModel(self.refer:Get(2),self.hero_id,nil,1)

	self.refer:Get(3).text = gf_getItemObject("hero"):get_hero_power(self.hero_id)

	--品质
	local heroType = dataUse.getHeroQuality(self.hero_id)
	local iconName = dataUse.getHeroIcon(heroType)
	gf_setImageTexture(self.refer:Get(5),iconName )
	--名字 
	self.refer:Get(4).text = dataUse.getHeroName(self.hero_id) 

	self.slider_page = self.refer:Get(1)
	self.slider_page.OnUpdateFn = handler(self, self.update_page_item)

	local data = gf_deep_copy(gf_getItemObject("hero"):getEquipData())

	local page_count = math.floor(#data / 16) + math.ceil((#data % 16) / 16)
	page_count = page_count > 3 and page_count or 3
	self.slider_page:SetData(data)
	self.slider_page:SetPage(page_count)
	--装备
	self:setHeroEquipView()
end
--设置武将装备
function heroEquip:setHeroEquipView()
	print("setHeroEquipView")
	local pNode = self.refer:Get(6)

	local heroEquipInfo = gf_getItemObject("hero"):getHeroEquip(self.hero_id)
	SetHeroEquipView(pNode, heroEquipInfo, "militayr_hero_equip")

end
function heroEquip:update_page_item(item)
	item.gameObject.transform.localScale = Vector3(1,1,1)
	local data = item.data
	if next(data or {}) then
		item:Get(1).gameObject:SetActive(true)
		gf_set_item(data.protoId, item:Get(1), item:Get(4))
	else
		item:Get(1).gameObject:SetActive(false)
		gf_setImageTexture(item:Get(4), "item_color_0")
	end

end

function heroEquip:item_click(arg)
	if not next(arg.data or {}) then
		return
	end
	local function callback(count)
		gf_getItemObject("hero"):sendToEquip(self.hero_id,arg.data.guid)
	end

	gf_getItemObject("itemSys"):add_tips_btn("装备",callback)
	gf_getItemObject("itemSys"):hero_equip_tips(arg.data.guid)
end
function heroEquip:equip_item_click(event_name)
	local index = string.gsub(event_name,"militayr_hero_equip","")
	index = tonumber(index)

	local equip_data = gf_getItemObject("hero"):getHeroEquip(self.hero_id)[equip_pos[index]]

	if not next(equip_data or {}) then
		return
	end

	local function callback(count)
		gf_getItemObject("hero"):sendUnloadHeroEquip(self.hero_id,equip_data.guid)
	end

	gf_getItemObject("itemSys"):add_tips_btn("卸下",callback)
	gf_getItemObject("itemSys"):hero_equip_tips(equip_data.guid)
end

--鼠标单击事件
function heroEquip:on_click( obj, arg)
	local event_name = obj.name
	print("heroEquip click",event_name)
    if event_name == "equip_btn_close" then
    	self:dispose()

    elseif string.find(event_name,"b_item") then
    	self:item_click(arg)

    elseif string.find(event_name,"militayr_hero_equip") then
    	self:equip_item_click(event_name)

    end
end

function heroEquip:on_showed()
	StateManager:register_view(self)
end

function heroEquip:clear()
	StateManager:remove_register_view(self)
end

function heroEquip:on_hided()
	self:clear()
end
-- 释放资源
function heroEquip:dispose()
	self:clear()
    self._base.dispose(self)
end

function heroEquip:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then 
		if id2 == Net:get_id2(model_name, "SetHeroEquipR") or id2 == Net:get_id2(model_name, "UnloadHeroEquipR") then
			if msg.err == 0 then
				self:init_ui()
			end
			
		end
	end
	
end

return heroEquip