--[[--
--摇钱树界面
-- @Author:Seven
-- @DateTime:2017-07-03 11:57:56
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local MoneyTreeView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "money_tree.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function MoneyTreeView:on_asset_load(key,asset)
	self:init_info()
	self:init_ui()
	self:register()
end

function MoneyTreeView:init_ui()
	self.txt_gain_money = self.refer:Get("txt_gain_money")
	self.txt_yb = self.refer:Get("txt_yb")
	self.use_amount = self.refer:Get("use_amount")
	self.remain_amount = self.refer:Get("remain_amount")
	self:update_info()
end

function MoneyTreeView:init_info()
	self.item_obj.is_month_card = LuaItemManager:get_item_obejct("sign"):is_month_card()
	self.item_obj.is_week_card = LuaItemManager:get_item_obejct("sign"):is_week_card()
	self.money_do = true
	local lv = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
	if self.item_obj.player_lv == lv then 
		return 
	end
	local times = ConfigMgr:get_config("vip")[lv].money_tree
	self.item_obj.remain_amount = ConfigMgr:get_config("t_misc").money_tree.shake_max_times + times
	if times >0 then
		self.item_obj.is_vip = true
	end
end
function MoneyTreeView:register()
	self.item_obj:register_event("gameOfTitle_view_on_click",handler(self,self.on_click))
end

function MoneyTreeView:on_click(item_obj,obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	print("点击了",cmd)
	if cmd == "is_double" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:double_state()
	elseif cmd == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "lucky_bag1" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:open_lucky_bag(1)
	elseif cmd == "lucky_bag2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:open_lucky_bag(2)
	elseif cmd == "lucky_bag3" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:open_lucky_bag(3)
	elseif cmd == "lucky_bag4" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:open_lucky_bag(4)
	elseif cmd == "lucky_bag5" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:open_lucky_bag(5)
	elseif cmd == "lucky_bag6" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:open_lucky_bag(6)
	elseif cmd == "shake_one_money" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:moneytree_shake_c2s(1)
		if self.money_do and self.times~=0 then
			self:effect_money()
		end
	elseif cmd == "shake_ten_money" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:moneytree_shake()
		if self.money_do and self.times~=0 then
			self:effect_money()
		end
 	end
end
--摇10次情况
function MoneyTreeView:moneytree_shake()
	local tc = self.item_obj.remain_amount - self.item_obj.treetime
	if tc > 10 then
		tc = 10
	elseif tc <= 0 then
		LuaItemManager:get_item_obejct("floatTextSys").assets[1]:add_leftbottom_broadcast("已无可用次数")
		return
	end
	local yb =self.item_obj:get_next_yb(self.item_obj.treetime)
	local sum = 0
	local tb = tc
	if self.item_obj.treetime <= 3 then 
		tb = 10 - 3 + self.item_obj.treetime
		yb = self.item_obj.money_tree[4].need_gold
	end
	for i=1,tb do
		yb =self.item_obj:get_next_yb(self.item_obj.treetime-1+i)
		if yb < 20 then
			sum = sum + yb
		else
			sum = sum + 20
		end
	end
	-- local tq = self.item_obj:get_next_money()
	local tq =100000
	tq = tq*tc
	
	local talk ="确定花费<color=#B01FE5>".. sum .."元宝</color>进行摇钱<color=#B01FE5>" .. tc .."次</color>，获得<color=#B01FE5>".. tq.."铜钱</color>吗？(花费随当天摇钱次数增加而增加，最高<color=#B01FE5>30</color>元宝/次)" 
	local use_ten = true
	local fun_yes = function(a,b) 
	print("摇钱确认")
		if b then
			self.item_obj:not_remind_today_c2s()
			self.item_obj.today_show = false
		end
		self.item_obj:moneytree_shake_c2s(tc)
	end
	if self.item_obj.today_show then
		use_ten = false
		LuaItemManager:get_item_obejct("cCMP"):toggle_message(talk,false,"今日不再提醒",fun_yes,nil,"确认","取消")
	end
	--请求10次
	if use_ten  then
		self.item_obj:moneytree_shake_c2s(tc)
	end
end

function MoneyTreeView:open_lucky_bag(bid)
	local t = self.item_obj.money_tree_award[bid]
	if t.state then
		print("摇钱树奖励1")
		self.item_obj:moneytree_award_c2s(t.times)
	else
		self.item_obj:open_lucky_bag(bid)
	end
end

--是否双倍
function MoneyTreeView:double_state()
	if self.item_obj.is_month_card or self.item_obj.is_week_card then
		local talk = "购买周卡/月卡即可自动激活，享受所有摇钱收益均为2倍的福利。\n当前状态：<color=#67F858>已激活</color>"
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message(talk)
	else
		local talk = "购买周卡/月卡即可自动激活，享受所有摇钱收益均为2倍的福利。\n当前状态：<color=red>未激活</color>"
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(talk,function()
			self:dispose()
			LuaItemManager:get_item_obejct("sign"):open_index_view(4)
		 end,nil,"前往购买","容我三思")
	end
end

--获得铜钱
function MoneyTreeView:get_money_amount()
	-- self.txt_gain_money.text =self.item_obj:get_next_money()
	 self.txt_gain_money.text = 100000
end

--获取元宝
function MoneyTreeView:get_yb_amount()
	self.txt_yb.text =self.item_obj:get_next_yb(self.item_obj.treetime)
end
--更新信息
function MoneyTreeView:update_info()
	self.refer:Get("use_amount").text = self.item_obj.treetime
	self.times = self.item_obj.remain_amount - self.item_obj.treetime
	self.refer:Get("remain_amount").text = self.times
	if self.times < 10 and self.times>0 then
		self.refer:Get("txt_ten").text =  "摇钱"..  self.times .."次"
	elseif self.times <= 0  then
		self.refer:Get("txt_ten").text =  "摇钱10次"
		self.refer:Get("remain_amount").text = 0
	end
	if self.item_obj.is_month_card or self.item_obj.is_week_card then
		self.refer:Get("is_double").color = UnityEngine.Color(1,1,1,1)
	else
		self.refer:Get("is_double").color = UnityEngine.Color(0.3,0.3,0.3,1)
	end
	self:get_money_amount()
	self:get_yb_amount()
	local txt
	if self.item_obj.is_vip then --vip
		self.refer:Get("vip"):SetActive(true)
		txt = self.refer:Get("txt_time1")
	else
		self.refer:Get("no_vip"):SetActive(true)
		txt = self.refer:Get("txt_time2")
	end
	if self.item_obj.treetime >=3 then  --次数
		self.refer:Get("needyb"):SetActive(true)
		txt.text = "摇钱1次"     
		self.refer:Get("freetimes"):SetActive(false)
	else
		self.refer:Get("freetimes"):SetActive(true)
	end
	self:award_open()
end

function MoneyTreeView:award_open()
	local t = self.item_obj.money_tree_award
	for k,v in pairs(t) do
		if v.state ~=nil then
			if v.state then
				self.refer:Get("luck"..k):SetActive(true)
			else
				self.refer:Get("lucky_bag"..k).gameObject:SetActive(false)
				self.refer:Get("luck"..k):SetActive(false)
			end
		end
	end
end

function MoneyTreeView:effect_money()
	self.money_do = false
	self.refer:Get("41000092"):SetActive(true)
	self.countdown_effect = Schedule(handler(self, function()
					self.refer:Get("41000092"):SetActive(false)
					self.countdown_effect:stop()
					self.money_do = true
					end), 2)
end

-- 释放资源
function MoneyTreeView:dispose()
	self.item_obj:register_event("gameOfTitle_view_on_click",nil)
	if self.countdown_effect then
		self.countdown_effect:stop()
		self.countdown_effect = nil
	end
    self._base.dispose(self)
 end

return MoneyTreeView

