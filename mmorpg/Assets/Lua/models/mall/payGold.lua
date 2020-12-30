--[[--
--
-- @Author:Seven
-- @DateTime:2018-01-05 12:05:36
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local payGold=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "pay_gold.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function payGold:on_asset_load(key,asset)
	self:init_ui()
	self.init = true
end

function payGold:init_ui()
	self.fullLvGo = self.refer:Get("fullLvGo") -- 满级了
	self.curVipLv = self.refer:Get("curVipLv") -- 当前vip等级
	self.nextVipNeed = self.refer:Get("nextVipNeed") -- 下一级需要充值的元宝
	self.nextVipStr = self.refer:Get("nextVipStr") -- 下一级vip等级
	self.curRechargeSlider = self.refer:Get("curRechargeSlider") -- 当前充值进度条
	self.curRechargeText = self.refer:Get("curRechargeText") -- 当前充值进度
	self.haveMoney = self.refer:Get("haveMoney") -- 拥有的元宝
	self.nextVipNeedGo = self.refer:Get("nextVipNeedGo") -- 拥有的元宝
	self:init_list()
	self:update_vip_lv() --更新vip等级
        	self:update_money()
end

function payGold:init_list()
	local goodsItemRoot = self.refer:Get("goodsItemRoot") -- 充值
	local allChild = LuaHelper.GetAllChild(goodsItemRoot)
	local data = self.item_obj:get_recharge_data()
	for i=1,#allChild do
		local child = allChild[i]
		local d = data[i]
		if d then
			child:Find("cost"):GetComponent("UnityEngine.UI.Text").text = "¥ "..d.cost
			gf_setImageTexture(child:Find("icon"):GetComponent(UnityEngine_UI_Image),d.icon)
			child:Find("gold"):GetComponent("UnityEngine.UI.Text").text = d.gold.." 元宝"
			if not self.item_obj:is_frist_pay(d.goods_id) then
				local first = child:Find("first")
				-- gf_setImageTexture(first:GetComponent(UnityEngine_UI_Image),d.tag_icon)
				-- first:Find("firstName"):GetComponent("UnityEngine.UI.Text").text = "赠送"
				first:Find("firstGold"):GetComponent("UnityEngine.UI.Text").text = d.frist_gold
				first.gameObject:SetActive(true)
				child:Find("tagIcon").gameObject:SetActive(false)
			elseif d.tag then
				local tag = child:Find("tagIcon")
				gf_setImageTexture(tag:GetComponent(UnityEngine_UI_Image),d.tag_icon)
				tag:GetComponentInChildren("UnityEngine.UI.Text").text = d.tag
				tag.gameObject:SetActive(true)
				child:Find("first").gameObject:SetActive(false)
			end
		end
	end
end

function payGold:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "goodsItem" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local idx = obj.transform:GetSiblingIndex()+1
		local d = self.item_obj:get_recharge_data()[idx]
		if DEBUG then
			Net:send({gold=d.gold},"shop","FakeCharge") --模拟充值
		else
			SdkMgr:pay(d.goods_id,d.goods_name,1,d.cost,d.cp_order_id)
		end
	elseif string.find(cmd, "toModule_") then -- 功能跳转
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:hide()
		gf_open_model(tonumber(string.split(cmd,"_")[2]))
	end
end

function payGold:on_receive( msg, id1, id2, sid )
	if not self.init then return end
    if id1==Net:get_id1("shop") then
		if id2== Net:get_id2("shop", "GetVipInfoR")
		or id2== Net:get_id2("shop", "UpdateVipLvlR") then
			self:update_vip_lv() --更新vip等级
		end
	elseif(id1==Net:get_id1("base"))then
        if(id2== Net:get_id2("base", "UpdateResR"))then
        	self:update_money()
        end
	end
end

function payGold:update_vip_lv()
	local VipPrivileged = LuaItemManager:get_item_obejct("vipPrivileged")
	local data = ConfigMgr:get_config("vip")
	local cur_vip_data = data[VipPrivileged:get_vip_lv()] -- 获取当前vip等级的配置文件
	local cur_vip_isFullLv = VipPrivileged:get_vip_lv()>=#data --当前vip等级是否满级

	self.curVipLv.text = VipPrivileged:get_vip_lv()	-- 设置当前vip艺术字

	if not cur_vip_isFullLv then -- 如果不是满级
		self.nextVipStr.text = VipPrivileged:get_vip_lv() + 1					-- 设置充值到下一级vip的等级字符串
		self.nextVipNeed.text = cur_vip_data.exp-VipPrivileged:get_cur_exp()	-- 设置充值到下一级vip需要的元宝数量
		self.curRechargeText.text = string.format("%d/%d",VipPrivileged:get_cur_exp(),cur_vip_data.exp)	-- 设置当前充值文本
		self.curRechargeSlider.value = VipPrivileged:get_cur_exp()/cur_vip_data.exp -- 设置当前充值进度条
	else
		self.curRechargeText.text = string.format("%d/%d",VipPrivileged:get_cur_exp(),cur_vip_data.exp)	-- 设置当前充值文本
		self.curRechargeSlider.value = 1							-- 设置当前充值进度条
	end
		self.nextVipNeedGo:SetActive(not cur_vip_isFullLv)				-- 设置下一级字符串
		self.fullLvGo:SetActive(cur_vip_isFullLv)						-- 设置当前充值文本
end

function payGold:update_money()
    		local game = LuaItemManager:get_item_obejct("game")
        	self.refer:Get("haveMoney").text= gf_format_count(game.role_info.baseRes[ServerEnum.BASE_RES.GOLD])
end

function payGold:on_showed()
	print("注册 payGold")
    StateManager:register_view( self )
    if self.init then
		self:init_list()
		self:update_vip_lv() --更新vip等级
        	self:update_money()
    end
end

function payGold:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function payGold:dispose()
	self:hide()
	self.init = nil
    self._base.dispose(self)
 end

return payGold

