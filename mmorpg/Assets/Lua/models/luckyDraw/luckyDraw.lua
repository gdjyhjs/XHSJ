--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-23 11:46:33
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local LuckyDraw = LuaItemManager:get_item_obejct("luckyDraw")


--UI资源
LuckyDraw.assets = 
{
    View("luckyDrawView", LuckyDraw) 
}
LuckyDraw.event_name = "lucky_draw_view_on_click"

--点击事件
function LuckyDraw:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

function LuckyDraw:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "GetLotteryInfoR") then -- 获取秘境寻宝初始信息
			gf_print_table(msg,"wtf receive GetLotteryInfoR")
			gf_print_table(msg,"秘境寻宝 获取秘境寻宝初始信息"..sid)
			self:GetLotteryInfoR_s2c(msg,sid)

		elseif id2 == Net:get_id2("base", "LotteryDrawR") then -- 秘境寻宝结果
			gf_print_table(msg,"秘境寻宝 秘境寻宝结果")
			self:LotteryDrawR_s2c(msg)

		elseif id2 == Net:get_id2("base", "GetLotteryStorehouseR") then -- 取出抽奖仓库物品
			gf_print_table(msg,"秘境寻宝 取出抽奖仓库物品")
			self:GetLotteryStorehouseR_s2c(msg)

		elseif id2 == Net:get_id2("base", "GetLotteryStorehouseInfoR") then -- 获取抽奖仓库物品列表
			gf_print_table(msg,"秘境寻宝 获取抽奖仓库物品列表")
			self:GetLotteryStorehouseInfoR_s2c(msg)

		elseif id2 == Net:get_id2("base", "ChatR") then -- 稀有奖励广播信息
			if msg.code == 18 then
				gf_print_table(msg,"秘境寻宝 稀有奖励广播信息")
				self:BroadcastInfo_s2c(msg)
			end
		end
	end
end

-- 稀有奖励广播信息
function LuckyDraw:BroadcastInfo_s2c(msg)
	local info = {
		roleId = msg.args[1],
		name = msg.args[2],
		code = msg.args[3],
		num = msg.args[4],
		broadcastId = msg.code,
	}
	self.serverRecord[#self.serverRecord+1] = info
	while(#self.serverRecord>self.message_max_count)do
		table.remove(self.serverRecord,1)
	end
end

-- 获取秘境寻宝初始信息
function LuckyDraw:GetLotteryInfoR_s2c(msg,sid)
	print("取秘境寻宝初始信息",sid)
		print("是否开启活动的返回",sid==2)
			print("是否开启活动",self.isOpen)
	self.needRemind = msg.needRemind == 1
	self:set_red_point(msg.storehouseReward == 1)
	self.serverRecord = msg.broadcastList or {}
	self.isOpen = msg.isOpen == 1
	if sid == 2 then
		if self.isOpen then
			self:add_to_state()
		else
			gf_message_tips("活动未开启")
		end
	end
	print("取秘境寻宝初始信息",sid)
		print("是否开启活动的返回",sid==2)
			print("是否开启活动",self.isOpen)
end

-- 获取秘境寻宝 秘境寻宝结果
function LuckyDraw:LotteryDrawR_s2c(msg)
	-- 更新消息到个人记录
	if msg.err == 0 then
		for i,v in ipairs(msg.rewardCodeList) do
			self.personalRecord[#self.personalRecord+1] = v
		end
		while(#self.personalRecord>self.message_max_count)do
			table.remove(self.personalRecord,1)
		end
		self:set_red_point(true)
		PlayerPrefs.SetString(LuaItemManager:get_item_obejct("game"):getId().."LuckyDrawRecord",serpent.dump(self.personalRecord))
	end
end

-- 取出抽奖仓库物品
function LuckyDraw:GetLotteryStorehouseR_s2c(msg)
	-- 此处不需要处理，做仓库的ui处理
end

-- 获取抽奖仓库物品列表
function LuckyDraw:GetLotteryStorehouseInfoR_s2c(msg)
	-- 此处不需要处理，打开仓库的ui自动更新
end

-- 获取秘境寻宝初始信息
function LuckyDraw:GetLotteryInfo_c2s(sid) -- sid 2 为打开 空为初始获取
	print("获取秘境寻宝初始信息 -- sid 2 为打开 空为初始获取 sid =",sid)
	local msg = {}
	Net:send(msg, "base", "GetLotteryInfo",sid)
end

-- 秘境寻宝结果
function LuckyDraw:LotteryDraw_c2s(count,needRemind)
	local msg = {times = count,needRemind = needRemind}
	Net:send(msg, "base", "LotteryDraw")
end

-- 取出抽奖仓库物品
function LuckyDraw:GetLotteryStorehouse_c2s(pos)
	local msg = {pos=pos}
	Net:send(msg, "base", "GetLotteryStorehouse")
end

-- 获取抽奖仓库物品列表
function LuckyDraw:GetLotteryStorehouseInfo_c2s()
	local msg = {}
	Net:send(msg, "base", "GetLotteryStorehouseInfo")
end

--初始化函数只会调用一次
function LuckyDraw:initialize()
	local s = PlayerPrefs.GetString(LuaItemManager:get_item_obejct("game"):getId().."LuckyDrawRecord", serpent.dump({}))
	self.personalRecord = loadstring(s)() -- 个人记录
	self.serverRecord = {} -- 全服记录
	self.isOpen = false -- 活动是否开启
	self.message_max_count = 20 -- 缓存最大消息数量
	self.needRemind = false -- 钥匙不足消耗元宝是否需要确认框
	self.storehouseReward = false -- 仓库是否有物品
end

--设置是否需要显示红店
function LuckyDraw:set_red_point(bool)
	self.storehouseReward = bool
	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.LUCKY_DRAW, visible=self.storehouseReward}, ClientProto.ShowHotPoint)
end

--获取是否需要显示红点
function LuckyDraw:get_red_point(bool)
	return self.storehouseReward
end

function LuckyDraw:open()
	self:get_config()
	if not self.lottery_config then
		gf_message_tips("等级不足,无法秘境寻宝")
		return
	end
	self:GetLotteryInfo_c2s(2)
end

function LuckyDraw:get_config()
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	for i,v in ipairs(ConfigMgr:get_config("lottery_config")) do
		if lv >= v.level_range[1] and lv <= v.level_range[2] then
			self.lottery_config = v
		end
	end
	return self.lottery_config
end