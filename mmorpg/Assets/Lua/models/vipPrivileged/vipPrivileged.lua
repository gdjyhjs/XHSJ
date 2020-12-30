--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-17 12:07:51
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local VipPrivileged = LuaItemManager:get_item_obejct("vipPrivileged")
--UI资源
VipPrivileged.assets=
{
    View("vipPrivilegedView", VipPrivileged) 
}

local vipLv = 0
local curExp = 0
local vipGift = 0

local FristTopUpDay = 0 -- 首冲天数
local FristTopUpReward = 0 -- 已领取首冲奖励

VipPrivileged.event_name = "vip_view_on_click"
--点击事件
function VipPrivileged:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event(self.event_name, false, obj, arg)
	return true
end

--初始化函数只会调用一次
function VipPrivileged:initialize()
	print("初始化vip")
	-- self:get_first_recharge_reward_list_c2s()
end

--服务器返回
function VipPrivileged:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("shop"))then
		if id2== Net:get_id2("shop", "GetVipInfoR") then
			gf_print_table(msg,"wtf receive GetVipInfoR 获取VIP信息")
			-- 获取VIP信息
			self:get_vip_info_s2c(msg)
		elseif id2== Net:get_id2("shop", "VipGiftR") then
			gf_print_table(msg,"更新vip奖励")
			-- 更新vip奖励
			self:vip_gift_s2c(msg)
		elseif id2== Net:get_id2("shop", "UpdateVipLvlR") then
			gf_print_table(msg,"更新VIP等级")
			-- 更新VIP等级
			self:update_vip_lvl_s2c(msg)
		end
	elseif(id1==Net:get_id1("base"))then
		if id2== Net:get_id2("base", "GetFirstRechargeRewardListR") then
			gf_print_table(msg,"打印返回 更新vip奖励")
			-- 获取VIP信息
			self:get_first_recharge_reward_list_s2c(msg)
		elseif id2== Net:get_id2("base", "GetFirstRechargeRewardR") then
			gf_print_table(msg,"打印返回 更新vip奖励")
			-- 更新vip奖励
			self:get_first_recharge_reward_s2c(msg)
		elseif id2 == Net:get_id2("base", "OnNewDayR") then
			if self:get_vip_lv()>0 then
				FristTopUpDay = FristTopUpDay + 1
			end
		end
	end
end


--获取首冲奖励信息
function VipPrivileged:get_first_recharge_reward_list_c2s()
	Net:send({},"base","GetFirstRechargeRewardList")
end
--领取首冲奖励
function VipPrivileged:get_first_recharge_reward_c2s(day)
	Net:send({day=day},"base","GetFirstRechargeReward")
end
-- 领取vip奖励
function VipPrivileged:vip_gift_c2s(vipLevel)
	Net:send({vipLevel=vipLevel},"shop","VipGift")
end
-- 获取vip信息
function VipPrivileged:get_vip_info_c2s()
	Net:send({},"shop","GetVipInfo")
end

--获取首冲奖励信息
function VipPrivileged:get_first_recharge_reward_list_s2c(msg)
	FristTopUpDay = msg.todayDay
	FristTopUpReward = msg.firstRechargeGiftMask
	-- print("领取首冲奖励信息",FristTopUpReward,(FristTopUpReward%2)..(math.floor(FristTopUpReward/2)%2)..(math.floor(math.floor(FristTopUpReward/2)/2)%2),math.floor((math.floor(math.floor(FristTopUpReward/2))/2)%2))
	self:set_frist_top_up_icon()
end
--领取首冲奖励
function VipPrivileged:get_first_recharge_reward_s2c(msg)
	if msg.err == 0 then
		print("vip---原已领礼包",FristTopUpReward)
		local b = bit._rshift(0x80000000,32-msg.day)
		FristTopUpReward = bit._or(FristTopUpReward,b)
		print("vip---领取的vip奖励等级",msg.day)
		print("vip---二进制是",b)
		print("vip---当前领取的礼包",vipGift)
		print("领取首冲奖励信息",FristTopUpReward,(FristTopUpReward%2)..(math.floor(FristTopUpReward/2)%2)..(math.floor(math.floor(FristTopUpReward/2)/2)%2),math.floor((math.floor(math.floor(FristTopUpReward/2))/2)%2))
	end
	self:set_frist_top_up_icon()
end
-- 领取vip奖励
function VipPrivileged:vip_gift_s2c(msg)
	if msg.err == 0 then
		print("vip---原已领礼包",vipGift)
		local b = bit._rshift(0x80000000,31-msg.vipLevel)
		vipGift = bit._or(vipGift,b)
		print("vip---领取的vip奖励等级",msg.vipLevel)
		print("vip---二进制是",b)
		print("vip---当前领取的礼包",vipGift)
	end
end
-- 获取vip信息
function VipPrivileged:get_vip_info_s2c(msg)
	vipLv = msg.vipLevel
	curExp = msg.vipExp
	vipGift = msg.vipGiftMask

	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.FIRSTTIME, visible=self:is_have_red_point()}, ClientProto.ShowAwardEffect)
end
-- 更新vip等级
function VipPrivileged:update_vip_lvl_s2c(msg)
	if msg.vipLevel>vipLv then
		 -- 获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
		Sound:play(ClientEnum.SOUND_KEY.GET_ITEMS)
	end
	vipLv = msg.vipLevel
	curExp = msg.vipExp
end


-- 获取vip等级
function VipPrivileged:get_vip_lv()
	return vipLv
end
-- 获取当前经验值
function VipPrivileged:get_cur_exp()
	return curExp
end
-- 获取某个等级的礼包是否被领取
function VipPrivileged:is_tack_gift(lv)
	local b = bit._rshift(0x80000000,31-lv)
	return bit._and(vipGift,b)==b
end

--获取今天是首冲后的第几天
function VipPrivileged:get_FristTopUpDay()
	if (self:get_vip_lv()>0 or self:get_cur_exp()>0) and FristTopUpDay==0 then
		FristTopUpDay = 1
	end
	return FristTopUpDay
end

--获取礼包是否可领
function VipPrivileged:get_FristTopUpReward(day)
	local b = bit._rshift(0x80000000,32-day)
	print("hjs万岁万岁万万岁 获取礼包是否可领","第几天",day,"已经领取的",FristTopUpReward,"要领取的",b,"是否可领",bit._and(FristTopUpReward,b)==b)
	return bit._and(FristTopUpReward,b)~=b
end

--是否领完礼包
function VipPrivileged:is_get_all_reward()
	print(FristTopUpReward,"是否领完礼包",FristTopUpReward == 7)
	return FristTopUpReward == 7
end

-- 设置首充图标是否显示
function VipPrivileged:set_frist_top_up_icon()
	if self:is_get_all_reward() then
		Net:receive({id=ClientEnum.MAIN_UI_BTN.FIRSTTIME, visible=false}, ClientProto.ShowOrHideMainuiBtn)
	end
end

-- 判断是否显示首冲按钮特效
function VipPrivileged:is_have_red_point()
	if self:get_vip_lv()>0 or self:get_cur_exp()>0 then
		print("首冲天数",FristTopUpDay>3 and 3 or FristTopUpDay)
		for i=1,FristTopUpDay>3 and 3 or FristTopUpDay do
			if self:get_FristTopUpReward(i) then
				return true
			end
		end
	else
		return true
	end
	return false
end

-- get -- -- get -- -- get -- -- get -- -- get -- -- get -- -- get -- 

-- 获取vip 打坐增加的经验
function VipPrivileged:get_sit_exp()
	return ConfigMgr:get_config("vip")[vipLv].rest_exp
end

-- vip 经验加成
function VipPrivileged:get_battle_exp()
	return ConfigMgr:get_config("vip")[vipLv].battle_exp
end