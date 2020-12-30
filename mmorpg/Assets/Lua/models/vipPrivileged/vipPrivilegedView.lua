--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-06 10:57:05
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PageMgr = require("common.pageMgr")

local VipPrivilegedView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "vip.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function VipPrivilegedView:on_asset_load(key,asset)
	self:update_vip_lv() --更新vip等级

	self.look_vip = self.item_obj:get_vip_lv()
	self.look_vip = self.look_vip<1 and 1 or self.look_vip
	for i=self.look_vip,1,-1 do
		if not self.item_obj:is_tack_gift(i) then
			self.look_vip = i
			break
		end
	end

    self.page_mgr = PageMgr(self.refer:Get("select_vip_root"))
    self:select_page(self.look_vip)
end

function VipPrivilegedView:select_page( page )
    if not self.page_mgr then
        return
    end
    self.page_mgr:select_page(page)

    self:update_vip_des(page)
end

function VipPrivilegedView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "exitVipBtn" then
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		--关闭按钮
		self:dispose()
	elseif cmd == "rechargeBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--充值按钮
		gf_open_model(ClientEnum.MODULE_TYPE.KRYPTON_GOLD)
	elseif cmd == "takeVipGiftBtn" then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		--领取按钮
		self.item_obj:vip_gift_c2s(self.look_vip)
	elseif cmd == "vipPage" then -- 切换查看vip
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_page(obj.transform:GetSiblingIndex()+1)
	end
end

 --服务器返回
function VipPrivilegedView:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("shop"))then
		gf_print_table(msg,"id1=shop 协议")
		if id2== Net:get_id2("shop", "GetVipInfoR") then
			-- 获取VIP信息
			self:update_vip_lv() --更新vip等级
			self:update_vip_des()
		elseif id2== Net:get_id2("shop", "VipGiftR") then
			-- 更新vip奖励
			self:update_vip_des()
		elseif id2== Net:get_id2("shop", "UpdateVipLvlR") then
			-- 更新VIP等级
			self:update_vip_lv() --更新vip等级
			self:update_vip_des()
		end
	end
end

--更新vip等级
function VipPrivilegedView:update_vip_lv()
	local data = ConfigMgr:get_config("vip")
	local cur_vip_data = data[self.item_obj:get_vip_lv()] -- 获取当前vip等级的配置文件
	local cur_vip_isFullLv = self.item_obj:get_vip_lv()>=#data --当前vip等级是否满级

	self.refer:Get("curVipLv").text = self.item_obj:get_vip_lv()							-- 设置当前vip艺术字

	if not cur_vip_isFullLv then -- 如果不是满级
		self.refer:Get("nextVipLv").text = self.item_obj:get_vip_lv() + 1					-- 设置下一级vip艺术字
		self.refer:Get("nextVipNeed").text = cur_vip_data.exp-self.item_obj:get_cur_exp()	-- 设置充值到下一级vip需要的元宝数量
		self.refer:Get("nextVipStr").text = self.item_obj:get_vip_lv() + 1					-- 设置充值到下一级vip的等级字符串
		self.refer:Get("curRechargeText").text = string.format("%d/%d",self.item_obj:get_cur_exp(),cur_vip_data.exp)	-- 设置当前充值文本
		self.refer:Get("curRechargeSlider").value = self.item_obj:get_cur_exp()/cur_vip_data.exp						-- 设置当前充值进度条
	else
		self.refer:Get("nextVipLv").text = self.item_obj:get_vip_lv()					-- 设置下一级vip艺术字
		self.refer:Get("curRechargeText").text = string.format("%d/%d",self.item_obj:get_cur_exp(),cur_vip_data.exp)	-- 设置当前充值文本
		self.refer:Get("curRechargeSlider").value = 1							-- 设置当前充值进度条
	end

		self.refer:Get("nextVipNeedGo"):SetActive(not cur_vip_isFullLv)				-- 设置下一级字符串
		self.refer:Get("fullLvGo"):SetActive(cur_vip_isFullLv)						-- 设置当前充值文本
end

--更新vip描述
function VipPrivilegedView:update_vip_des(vipLv)
	local data = ConfigMgr:get_config("vip")
	self.look_vip = vipLv or self.look_vip
	local ref = self.refer
	local cur_look_data = data[self.look_vip]					-- 获得当前在看的vip等级配置文件
	local cur_look_isFullLv = self.look_vip>#data		-- 正在查看的是否满级的vip
	local content = cur_look_data.content -- 获取要显示的主内容

	-- 设置领取奖励按钮
	local gift = cur_look_data.gift
	local tex = ref:Get("gift_des")
	local btn = ref:Get("takeVipGiftBtn")
	if self.look_vip>self.item_obj:get_vip_lv() then
		btn.gameObject:SetActive(false)
		tex.gameObject:SetActive(true)
		tex.text = cur_look_data.gift_des
	else
		tex.gameObject:SetActive(false)
		local is_tack = self.item_obj:is_tack_gift(self.look_vip)
		btn.gameObject:SetActive(true)
		btn.interactable = not is_tack --设置可领取按钮
		ref:Get("takeVipGiftText").text = is_tack and gf_localize_string("已领取") or string.format(gf_localize_string("VIP%d礼包"),self.look_vip) --设置可领取文本
	end

	-- 设置可领取的奖励
	local root = ref:Get("giftRoot")
	while(root.childCount<#gift)do
		LuaHelper.InstantiateLocal(root:GetChild(0).gameObject,root.gameObject)
	end
	for i=1,root.childCount do
		local v = gift[i]
		local item = root:GetChild(i-1).gameObject
		if v then
			item:SetActive(true)
			local r = item:GetComponent("ReferGameObjects")
			local data = ConfigMgr:get_config("item")[v[1]]	
			gf_set_item(v[1],r:Get("icon"),r:Get("bg"))
			r:Get("binding"):SetActive(LuaItemManager:get_item_obejct("itemSys"):calculate_item_is_bind(v[1]))
			r:Get("count").text = v[2]
			gf_set_click_prop_tips(item,v[1])
		else
			item:SetActive(false)
		end
	end
	-- 设置特权描述
	local root = ref:Get("vip_content_root")
	while(root.childCount<#content)do
		LuaHelper.InstantiateLocal(root:GetChild(0).gameObject,root.gameObject)
	end
	for i=1,root.childCount do
		local v = content[i]
		local item = root:GetChild(i-1).gameObject
		if v then
			item:SetActive(true)
			local r = item:GetComponent("ReferGameObjects")
			r:Get("name").text = v[1]
			r:Get("value").text = v[2]
		else
			item:SetActive(false)
		end
	end
	ref:Get("vipTitle").text = "VIP"..self.look_vip.."特权福利"		-- 设置vip字样
end

function VipPrivilegedView:register()
    self.item_obj:register_event(self.item_obj.event_name, handler(self, self.on_click))
end

function VipPrivilegedView:cancel_register()
    self.item_obj:register_event(self.item_obj.event_name, nil)
end

function VipPrivilegedView:on_showed()
	self:register()
end

function VipPrivilegedView:on_hide()
	self:dispose()
end

-- 释放资源
function VipPrivilegedView:dispose()
	self:cancel_register()
    self._base.dispose(self)
    -- self:set_bg_visible( false )
 end

return VipPrivilegedView

