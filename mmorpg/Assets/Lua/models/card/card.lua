--[[--
-- 七煞牌局数据类
-- @Author:Seven
-- @DateTime:2017-10-24 12:09:09
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Card = LuaItemManager:get_item_obejct("card")
--UI资源
Card.assets=
{
    View("CardView", Card) 
}
Card.event_name = "card_view_on_click"
--点击事件
function Card:on_click(obj,arg)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

--初始化函数只会调用一次
function Card:initialize()
	self.state = 0 --正在进行哪个步骤
	self.myInfo = {} -- 我的信息
	self.hisInfo = {} -- 对手信息
	self.dailyRewards = 0 -- 每日胜场奖励领取情况 二进制
	self.scoreList = {} -- 这局游戏对战记录
	self.roundEndTime = 0 -- 本回合结束时间
	self.lastDiscard = {} -- 当前出牌信息
	self.surePlay = false -- 确认出牌
end

function Card:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("task") then
		if id2== Net:get_id2("task", "GetCardsGameInfoR") then
			gf_print_table(msg,"CardDeBug:收到协议 打开界面获取需要显示的信息")
			-- 打开界面获取需要显示的信息
			self:GetCardsGameInfo_s2c(msg)
		elseif id2== Net:get_id2("task", "CardsGameMatchR") then
			gf_print_table(msg,"CardDeBug:收到协议 牌局开始匹配")
			-- 牌局开始匹配
			self:CardsGameMatch_s2c()
		elseif id2== Net:get_id2("task", "UpdateCardsGameInfo") then
			gf_print_table(msg,"CardDeBug:收到协议 更新牌局游戏信息(全部都可缺省,只修改有内容的字段)")
			-- 更新牌局游戏信息(全部都可缺省,只修改有内容的字段)
			self:UpdateCardsGameInfo_s2c(msg)
		elseif id2== Net:get_id2("task", "CardsGameDiscardR") then
			gf_print_table(msg,"CardDeBug:收到协议 出牌返回")
			-- 出牌返回
			self:CardsGameDiscard_s2c(msg)

		end
	end
end

-- 出牌返回结果
function Card:CardsGameDiscard_s2c(msg)
	if msg.err==0 then
		self.surePlay = true
		print("DE_BUG:出牌返回了，锁定卡牌",self.surePlay)
	end
end

-- 打开界面获取需要显示的信息
function Card:GetCardsGameInfo_s2c(msg)
	self.state = msg.state or 1
	self.myInfo = msg.myInfo or {}
	self.hisInfo = msg.hisInfo or {}
	self.dailyRewards = msg.dailyRewards or 0
	self.scoreList = msg.scoreList or {}
	self.roundEndTime = msg.roundEndTime or 0
	self.lastDiscard = msg.lastDiscard or {}
		if self.state==ServerEnum.CARDS_GAME_STATE.CHOOSING then -- 重置确认出牌
			if msg.lastDiscard and msg.lastDiscard.myDiscard and #msg.lastDiscard.myDiscard==5 then
				self.surePlay = true
			else
				self.surePlay = false
			end
		end
end
-- 牌局开始匹配
function Card:CardsGameMatch_s2c(msg)
end
-- 更新牌局游戏信息(全部都可缺省,只修改有内容的字段)
function Card:UpdateCardsGameInfo_s2c(msg)
	if msg.state then
		self.state = msg.state
		if self.state==ServerEnum.CARDS_GAME_STATE.MATCHING then -- 清空分数记录
			self.scoreList = {}
			if self.myInfo then
				self.myInfo.roundWinTimes = 0
			end
			if self.hisInfo then
				self.hisInfo.roundWinTimes = 0
			end
		end
		if self.state==ServerEnum.CARDS_GAME_STATE.BATTLE then -- 清空确认出牌
			self.surePlay = false
		end
		if self.state==ServerEnum.CARDS_GAME_STATE.CHOOSING then -- 清空确认出牌
			self.lastDiscard = {}
		end
	end
	print("今日胜场msg.myInfo",msg.myInfo)
	if msg.myInfo then
		if msg.myInfo.head then
			self.myInfo.head = msg.myInfo.head
		end
		if msg.myInfo.name then
			self.myInfo.name = msg.myInfo.name
		end
		if msg.myInfo.roundWinTimes then
			self.myInfo.roundWinTimes = msg.myInfo.roundWinTimes
		end
		if msg.myInfo.cardsList then
			self.myInfo.cardsList = msg.myInfo.cardsList
		end
		if msg.myInfo.winTimesToday then
			self.myInfo.winTimesToday = msg.myInfo.winTimesToday
		end
		if msg.myInfo.winTimesWeek then
			self.myInfo.winTimesWeek = msg.myInfo.winTimesWeek
		end
		if msg.myInfo.timesWeek then
			self.myInfo.timesWeek = msg.myInfo.timesWeek
		end
	end
	if msg.hisInfo then
		if msg.hisInfo.head then
			self.hisInfo.head = msg.hisInfo.head
		end
		if msg.hisInfo.name then
			self.hisInfo.name = msg.hisInfo.name
		end
		if msg.hisInfo.roundWinTimes then
			self.hisInfo.roundWinTimes = msg.hisInfo.roundWinTimes
		end
		if msg.hisInfo.cardsList then
			self.hisInfo.cardsList = msg.hisInfo.cardsList
		end
		if msg.hisInfo.winTimesWeek then
			self.hisInfo.winTimesWeek = msg.hisInfo.winTimesWeek
		end
		if msg.hisInfo.timesWeek then
			self.hisInfo.timesWeek = msg.hisInfo.timesWeek
		end
	end
	if msg.dailyRewards then
		self.dailyRewards = msg.dailyRewards
	end
	if msg.scoreList then
		self.scoreList = msg.scoreList
	end
	if msg.roundEndTime then
		self.roundEndTime = msg.roundEndTime
	end
	if msg.lastDiscard then
		self.lastDiscard = msg.lastDiscard
	end
end

-- 打开界面获取需要显示的信息
function Card:GetCardsGameInfo_c2s()
	print("CardDeBug:发送协议 打开界面获取需要显示的信息")
	Net:send({},"task","GetCardsGameInfo")
end
-- 牌局开始匹配
function Card:CardsGameMatch_c2s()
	print("CardDeBug:发送协议 牌局开始匹配")
	Net:send({},"task","CardsGameMatch")
end
-- 确认本次出牌
function Card:CardsGameDiscard_c2s(discardList)
	print("CardDeBug:发送协议 确认本次出牌")
	gf_print_table(discardList)
	Net:send({discardList = discardList},"task","CardsGameDiscard")	
end
-- 牌局取消匹配
function Card:CardsGameMatchCancel_c2s()
	print("CardDeBug:发送协议 牌局取消匹配")
	Net:send({},"task","CardsGameMatchCancel")
end

-- 一些函数	-- 获取信息

-- 我的头像
function Card:get_mine_head()
	return self.myInfo.head or LuaItemManager:get_item_obejct("game"):getHead()
end
-- 我的名字
function Card:get_mine_name()
	return self.myInfo.name or LuaItemManager:get_item_obejct("game"):getName()
end
-- 本日胜场
function Card:get_win_today()
	return self.myInfo and self.myInfo.winTimesToday or 0
end
-- 本周胜场
function Card:get_mine_win_week()
	return self.myInfo and self.myInfo.winTimesWeek or 0
end
-- 本周场次
function Card:get_mine_times_week()
	return self.myInfo and self.myInfo.timesWeek or 0
end
-- 我的本局胜场
function Card:get_mine_round_win_times()
	return self.myInfo and self.myInfo.roundWinTimes or 0
end
-- 剩余可用卡牌
function Card:get_mine_cards_list()
	return self.myInfo and self.myInfo.cardsList or {}
end

-- 敌人头像
function Card:get_enemy_head()
	return self.hisInfo.head or LuaItemManager:get_item_obejct("game"):getHead()
end
-- 敌人名字
function Card:get_enemy_name()
	return self.hisInfo.name or LuaItemManager:get_item_obejct("game"):getName()
end
-- 本周胜场
function Card:get_enemy_win_week()
	return self.hisInfo and self.hisInfo.winTimesWeek or 0
end
-- 本周场次
function Card:get_enemy_times_week()
	return self.hisInfo and self.hisInfo.timesWeek or 0
end
-- 敌人本局胜场
function Card:get_enemy_round_win_times()
	return self.hisInfo and self.hisInfo.roundWinTimes or 0
end
-- 敌人剩余卡牌
function Card:get_enemy_cards_list()
	return self.hisInfo and self.hisInfo.cardsList or {}
end

-- 正在进行哪个步骤
function Card:get_card_state()
	local b = bit._rshift(0x80000000,32-(self.state or 1))
	return b
end
-- 每日胜场奖励领取情况(id) 返回是否有领取
function Card:get_daily_rewards(b)
	local c = bit._rshift(0x80000000,32-b)
	return bit._and(self.dailyRewards,c) == c
end
-- 这局游戏对战记录
function Card:get_score_list()
	return self.scoreList or {}
end
-- 本回合结束时间
function Card:get_round_end_time()
	return self.roundEndTime or 0
end
-- 当前出牌信息
function Card:get_last_discard()
	return self.lastDiscard or {}
end

-- 获取自己的当前出牌
function Card:get_mine_last_discard()
	return self.lastDiscard and self.lastDiscard.myDiscard or {}
end

-- 获取敌人的当前出牌
function Card:get_enemy_discard()
	return self.lastDiscard and self.lastDiscard.hisDiscard or {}
end

-- 获取当前是否确认出牌
function Card:get_sure_play()
	return self.surePlay
end

-- 设置确认出牌
function Card:set_sure_play()
	self.surePlay = true
end