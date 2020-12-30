--[[--
--摇钱树数据类
-- @Author:Seven
-- @DateTime:2017-07-03 11:58:10
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local LuckyBag = require("models.moneyTree.luckyBag")
local MoneyTree = LuaItemManager:get_item_obejct("moneyTree")
--UI资源
MoneyTree.assets=
{
    View("moneyTreeView", MoneyTree) 
}

--点击事件
function MoneyTree:on_click(obj,arg)
	self:call_event("gameOfTitle_view_on_click",false,obj,arg)
	return true
end

--每次显示时候调用
function MoneyTree:on_showed( ... )

end

--初始化函数只会调用一次
function MoneyTree:initialize()

end
function MoneyTree:init()
	self.is_month_card = false--月卡
	self.is_week_card = false--周卡
	self.remain_amount = ConfigMgr:get_config("t_misc").money_tree.shake_max_times--总次数
	self.player_lv = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
	print("摇钱树VIP",self.player_lv)
	local times = ConfigMgr:get_config("vip")[self.player_lv].money_tree
	if self.player_lv==0 then
		self.is_vip = false--vip
	else
		self.remain_amount = self.remain_amount + times --总次数
		self.is_vip = true--vip
	end
	print("摇钱树总次数",self.remain_amount)
end
--初始化信息
function MoneyTree:init_info()
	self.today_show=true --今天提示
	self.money_tree = ConfigMgr:get_config("money_tree")
	local t =ConfigMgr:get_config("money_tree_award")
    local sortFunc = function(a, b)
        return a.times < b.times
    end
    local st = {}
    for k,v in pairs(t) do 
    	st[#st+1] = copy(t[k]) 
    end
	table.sort(st, sortFunc)
	-- gf_print_table(st,"摇钱树排序")
	self.money_tree_award = st
end

--更新奖励表
function MoneyTree:update_award_info()
	for k,v in pairs(self.money_tree_award) do
		if v.times <= self.treetime and v.state == nil then
			v.state = true
		end
	end

end

function MoneyTree:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("shop")) then
		if id2 == Net:get_id2("shop","MoneyTreeInfoR") then
			gf_print_table(msg,"摇钱树1")
			gf_print_table(msg,"wtf receive MoneyTreeInfoR")
			self:init()
			self:init_info()
			self:moneytree_info_s2c(msg)
		elseif id2 == Net:get_id2("shop","MoneyTreeShakeR") then
			gf_print_table(msg,"摇钱树2")	
			self:moneytree_shake_s2c(msg)
		elseif id2 == Net:get_id2("shop","MoneyTreeAwardR") then
			gf_print_table(msg,"摇钱树3")
			self:moneytree_award_s2c(msg)
		elseif id2== Net:get_id2("shop", "UpdateVipLvlR") then
			local times = ConfigMgr:get_config("vip")[msg.vipLevel].money_tree
			local x = ConfigMgr:get_config("t_misc").money_tree.shake_max_times + times
			if self.remain_amount < x then
				self:finish_tree(true)
			end
		end
	elseif(id1 == Net:get_id1("base")) then
		if id2 == Net:get_id2("base","OnNewDayR") then
			self:init()
			self:init_info()
			self.treetime = 0
		end
	end
end
--获取摇钱树的状态
function MoneyTree:moneytree_info_s2c(msg)
	self.treetime =  msg.times
	if msg.bIntRemind == 0 then
		self.today_show=true
	else
		self.today_show=false
	end
	self:update_award_info()
	local list = msg.awardTimesList
	for i=1,#list do
		for k,v in pairs(self.money_tree_award) do
			if v.times == list[i] then
				v.state = false
			end
		end
	end
	if self.remain_amount - self.treetime == 0 then 
		self:finish_tree(false)
		for k,v in pairs(self.money_tree_award) do
			if v.state then
				self:finish_tree(true)
			end
		end
	end	
end
function MoneyTree:moneytree_info_c2s()
	Net:send({},"shop","MoneyTreeInfo")
end
--今日提醒
function MoneyTree:not_remind_today_c2s()
	Net:send({},"shop","NotRemindToday")
end

--摇钱树摇
function MoneyTree:moneytree_shake_s2c(msg)
	if msg.err == 0 then
		self.treetime = msg.times
		self:update_award_info()
		print("摇钱树次数",self.treetime)
		if self.treetime >3 then
			local g 
			if self.treetime < #self.money_tree then
				g = self.money_tree[self.treetime].need_gold
			else
				g = self.money_tree[#self.money_tree].need_gold
			end
		end
		local m = self:get_next_money()
		self.assets[1]:update_info()
		if self.remain_amount - self.treetime == 0 then 
			for k,v in pairs(self.money_tree_award) do
				if v.state then
					return
				end
			end
			self:finish_tree(false)
		end	
	end
end
function MoneyTree:moneytree_shake_c2s(t)
	Net:send({ times = t },"shop","MoneyTreeShake")
end

--摇钱树额外奖历
function MoneyTree:moneytree_award_s2c(msg)
	if msg.err ~=0 then 
		return 
	end
	for k,v in pairs(self.money_tree_award) do
		if v.times == msg.times then
			v.state = false
		end
	end
	self.assets[1]:award_open()
	if self.lucky_Bag ~=nil then
		self.lucky_Bag:update_view()
	end
	if self.remain_amount - self.treetime == 0 then 
		for k,v in pairs(self.money_tree_award) do
			if v.state then
				return
			end
		end
		self:finish_tree(false)
	end	
end
function MoneyTree:moneytree_award_c2s(t)
	Net:send({ times = t},"shop","MoneyTreeAward")
end

--获取下一次铜钱
function MoneyTree:get_next_money()
	local lv = LuaItemManager:get_item_obejct("game").role_info.level
	self.next_money = 9900+lv*100
	return self.next_money
end

--获取下一次元宝
function MoneyTree:get_next_yb(time)
	local t = 1
	if time < #self.money_tree then
		t = time+1
	else
		t = #self.money_tree
	end
	self.next_yb = self.money_tree[t].need_gold
	print("摇钱树元宝",self.next_yb)
	return self.next_yb 
end
--开启福袋
function MoneyTree:open_lucky_bag(bid)
	self.lucky_Bag =LuckyBag(self)
	self.lucky_bag_num = bid
end

--通知完成
function MoneyTree:finish_tree(tf)
	 LuaItemManager:get_item_obejct("activeDaily"):daily_finish(ClientEnum.DAILY_NAME.MONEYOFTREE,tf)
end