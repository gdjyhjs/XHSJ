--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-25 09:44:18
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local BatchBuy=class(UIBase,function(self,item_obj,goodsInfo,ui)
    UIBase._ctor(self, "buy_goods.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj = item_obj
    self.goodsInfo = goodsInfo
    self.maxCount = goodsInfo.num
    self.curCount = 1
    self.ui = ui
end)
-- 资源加载完成
function BatchBuy:on_asset_load(key,asset)
	--设置父亲
	self.root.transform:SetParent(self.ui.root.transform,false)

	local data = ConfigMgr:get_config("item")[self.goodsInfo.protoId]
	--设置物品图标
	gf_set_item(self.goodsInfo.protoId,self.refer:Get("icon"),self.refer:Get("bg"))
	--设置物品可点击
	gf_set_click_prop_tips(self.refer:Get("bg").gameObject,self.goodsInfo.protoId)
	--设置数量
	self.refer:Get("count").text = self.maxCount
	--设置名字
	self.refer:Get("name").text = data.name
	--设置价格
	self.refer:Get("onePriceText").text = self.goodsInfo.price
	--设置数量和总价
	self:set_count_and_price()
end

function BatchBuy:on_click(obj,arg)
	print("点击批量购买",obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "closeBuyGoods" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "cutBuyCount" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--减少数量
		self.curCount = self.curCount - 1 < 1 and 1 or self.curCount - 1
		self:set_count_and_price()
	elseif cmd == "addBuyCount" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--增加数量
		self.curCount = self.curCount + 1 > self.maxCount and self.maxCount or self.curCount+1
		self:set_count_and_price()
	elseif cmd == "buyGoodsBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--购买物品
		self.item_obj:buy_market_item_c2s(self.goodsInfo.guid,self.curCount,self.goodsInfo.protoId)
		self:dispose()
	elseif cmd == "buyCountText" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--输入数量
		local surefun = function(value)
			self.curCount = value == "" and self.curCount or value
			self:set_count_and_price()
		end
		LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(a,self.maxCount,1,"left","right","rightBottom",nil,surefun)
	end
end

function BatchBuy:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("shop")) and self.open then
		if id2== Net:get_id2("shop", "GetMarketItemInfoListR") then
			self.open = false
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message("商品有变化，请重试！",function()self:dispose()end)
		end
	end
end

--设置数量和总价
function BatchBuy:set_count_and_price()
	print("设置数量和总价",self.curCount,self.goodsInfo.price * self.curCount)
	self.refer:Get("buyCountText").text = self.curCount
	self.refer:Get("allPriceText").text = self.goodsInfo.price * self.curCount
end

function BatchBuy:on_showed()
	StateManager:register_view( self )
	self.open = true
end

function BatchBuy:on_hided()
	StateManager:register_view( self )
end

-- 释放资源
function BatchBuy:dispose()
	self:hide()
    self._base.dispose(self)
 end

return BatchBuy

