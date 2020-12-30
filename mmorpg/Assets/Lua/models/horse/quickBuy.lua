--[[
	快速购买界面
	create at 17.6.21
	by xin
]]
local LuaHelper = LuaHelper

local res = 
{
	[1] = "horse_buyquick.u3d",
}

local dataUse = require("models.horse.dataUse")

local commom_string = 
{
}


local quickBuy = class(UIBase,function(self,item_id,count,goods)

	self.item_id = item_id
	self.count = count
	self.goods = goods
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function quickBuy:on_asset_load(key,asset)
    self:init_ui()
end

function quickBuy:init_ui()

	local goods = self.goods
	-- gf_print_table(goods, "wft goods:")
	local pItem = self.refer:Get(2)
	local copyItem = self.refer:Get(1)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end


  	local dataModel = gf_getItemObject("horse")

	for i,v in ipairs(goods or {}) do
		local cItem = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		cItem.gameObject:SetActive(true)
		cItem.name = "item_good_"..i
 
		local refer = cItem:GetComponent("ReferGameObjects")

		--名字
		refer:Get(2).text = v.offer
		--价格
		refer:Get(3).text = v.name
		--道具背景
		gf_set_item(v.item_code,refer:Get(4), refer:Get(5))
		--货币icon 
		gf_setImageTexture(refer:Get(1), gf_getItemObject("itemSys"):get_coin_icon(v.base_res_type))
	end
end

function quickBuy:item_click(event_name)
	local index = string.gsub(event_name,"item_good_","")
	index = tonumber(index)
	local goods = self.goods
	require("models.horse.buyConfirm")(goods[index].goods_id,self.count)
end

--鼠标单击事件
function quickBuy:on_click( obj, arg)
	print("quickBuy click")
    local event_name = obj.name
    if event_name == "quickbuy_close" then
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:hide()

    elseif string.find(event_name,"item_good_") then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(event_name)

    end
end

-- 释放资源
function quickBuy:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function quickBuy:on_receive( msg, id1, id2, sid )
	-- if id1 == Net:get_id1(modelName) then
	-- 	if id2 == Net:get_id2(modelName, "WakeUpHeroR") then
	-- 	end
	-- end
end

return quickBuy