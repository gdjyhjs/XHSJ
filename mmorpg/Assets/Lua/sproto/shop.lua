--商城相关协议
local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[
#物品购买次数
.BoughtTimes
{
	goodsId 0 :  integer	#商品id
	times 1 :   integer #已购买次数
}

#获取已购买次数列表,有限制数量的商品才有次数
.GetBoughtTimesList
{
}
.GetBoughtTimesListR
{
	list 0 : *BoughtTimes              #已购买次数列表
}

.Buy
{
	goodsId 0 : integer   #商品id
	num 1 : integer      #数量
}

.BuyR
{
    err 0 : integer
}

#----------------摇钱树 begin-----------------------------
#获取摇钱树的状态
.MoneyTreeInfo
{

}
.MoneyTreeInfoR
{
	times 0 : integer        #今天已经摇过的次数
	awardTimesList 1 : *integer   #已经领过的奖励列表
	bIntRemind    2 : integer   #0:没有提醒，1:已经提醒过了
}

#今天不再提醒
.NotRemindToday
{

}
.NotRemindTodayR
{
}

#摇钱树摇一下
.MoneyTreeShake
{
	times 0 : integer             #摇多少次
}
.MoneyTreeShakeR
{
	err 0 : integer
	times 1 : integer             #今天摇过多少次了
}

#摇钱树额外奖历
.MoneyTreeAward
{
	times 0 : integer
}

.MoneyTreeAwardR
{
	err 0 : integer
	times 1 : integer
}

#----------------摇钱树 end-----------------------------

#----------------vip begin-----------------------------
#模拟充值
.FakeCharge
{
	gold 0 : integer            #充值数
}
.FakeChargeR
{
	err 0 : integer
	gold 1 : integer            #玩家身上的钱
}
.VipGift
{
	vipLevel 0 : integer 			#领的是哪个vip等级的礼包
}
.VipGiftR
{
	err 0 : integer          
	vipLevel 1 : integer 			#领的是哪个vip等级的礼包
}

#获取vip信息
.GetVipInfo
{
}
.GetVipInfoR
{
	vipLevel 0 : integer                   #vip等级
	vipExp 1 : integer                     #vip经验
	vipGiftMask 2 : integer                #已经领过的礼包(二进制式)
}

#更新vip等级
.UpdateVipLvlR
{
	vipLevel 0 : integer
	vipExp 1 : integer
}
#----------------vip end-----------------------------
#----------------market begin-----------------------------
#---从bag里面copy过来的  begin 有相应删减
.EquipAttrR
{
	attr 0 : integer  #属性 为enum.COMBAT_ATTR 中的值
	value 1 : integer #数值
}
.Item
{
	guid 0 : integer #物品唯一id
	protoId 1: integer  #物品原型
	num  2 : integer    #格子内的堆叠数量
}

.Equip
{
	guid 0 : integer 	            #唯一id
	protoId 1 : integer             #对应物品表中的code
	formulaId 2 : integer           #打造id，对应config/equip_formula中的formulaId
	color 3 : integer               #品质
	spec 4 : integer                #特效 为 equip_spec表中的id
	prefix 5 : integer              #前缀 为 enum.EQUIP_PREFIX_TYPE 中的值
	baseAttr 6 : *EquipAttrR        #基础属性
	exAttr 7 : *EquipAttrR          #额外属性(HJS)
}
#---从bag里面copy过来的  end


.UnlockMarket {
}
.UnlockMarketR
{
	err 0 : integer
	capacity 1 : integer  #容量
}

#自己挂售商品信息
.SellItemInfo
{
	item 0 : Item        #物品信息  与equip两者存一
	equip 1 : Equip        #装备信息  与item两者存一
	price 2 : integer     #价格
	timestamp 4 : integer #结束时间轴
}
.History{
	protoId 0 : integer     #原型id
	star 1 : integer        #如果是装备为星级，其它情况为0
	color 2 : integer       #如果是装备为品质，其它情况为0
	timestamp 3 : integer   #在什么时候卖出的
	price 4 : integer        #你收获了多少 如果是购买，则为负数
	prefix 5 : integer      #装备前缀
	num 6 : integer      #数量
	tax 7 : integer      #税收
}
#获取自己的市场信息
.GetMarketInfo
{
}
.GetMarketInfoR
{
	err 0 : integer          #当玩家没有开启这个功能的时候是不能打开的
	list 1 : *SellItemInfo          #正在挂售的商品
	capacity 2 : integer            #容量
	historys 3 :*History         #历史记录
}

#市场上的挂售商品信息
.MarketItemInfo
{
	item 0 : Item        #物品信息  两者存一
	equip 1 : Equip        #装备信息  两者存一
	price 2 : integer     #价格
	timestamp 4 : integer #结束时间轴
}
#自己将物品挂售出去
.SellMarketItems
{
	guid 0 : integer   #guid
	num 1 : integer  #数量
	price 2 : integer  #总价格
}
.SellMarketItemsR
{
	err 0 : integer
	sellItemInfo 1 : SellItemInfo   #挂售出去的信息体
}

#取消挂售
.CancelSellMarketItem
{
	guid 0 : integer     #取消的guid挂售
}
.CancelSellMarketItemR
{
	err 0 : integer
	guid 1 : integer     #取消的guid挂售
}

#获取哪个大类的在售数
.GetMarketTypeCounts{
	type 0 : integer
}

.GetMarketTypeCountsR{
	err 0 : integer          #当玩家还没开启这个功能的时候返回err
	sub_types 1 : *integer   #小类  与 counts 一一对应
	counts 2 : *integer      #数量  与 counts 一一对应
	type 3 : integer         #大类
}
#获取市场上的挂售商品
.GetMarketItemInfoList
{
	unit_type 0 : integer        #唯一类型 这个值填了，type就为0
	type 1 :  integer            #大类，这个值填了，unit_type就为0
	sort 2 : integer             #排序的种类 1按时间顺序 2按价格从高到低，3按价格从低到高
								 #                       4按价格从高到低，5按价格从低到高
	page 3 : integer             #第几页，一页50个 从1开始
}
.GetMarketItemInfoListR
{
	err 0 : integer          # 当玩家还没开启这个功能的时候返回err
	list 1 : *MarketItemInfo # 挂售列表
	unit_type 2 : integer    # 唯一类型
	type 3 :  integer            #大类，这个值填了，unit_type就为0
	sort 4 : integer             #排序的种类 1按时间顺序 2按价格从高到低，3按价格从低到高
								 #                       4按总价格从高到低，5按总价格从低到高   0:因为不足一页，没有排序
	page 5 : integer             #第几页，一页50个 从1开始
	finalPage 6 : integer        # 0 不是，1 是
}

#购买市场上的物品
.BuyMarketItem
{
	guid 0 : integer           #guid
	protoId 1 : integer        #增加此参数是为了加快查找
}

#当购买后，给玩家更新的推送
.BuyMarketItemR
{
	err 0 : integer         #
	guid 1 : integer           #俊山需要
	marketItemInfo 2: MarketItemInfo #购买到的物品
}
#当别人购买了自己的物品，自己又在线上的时候，会有一个推送
.SellItemR{
	guid 0 : integer
}

#搜索
.SearchMarket{
	type 0 : integer    # 哪个大类
	unit_type 1 : integer #哪个唯一类
	protoIds 2 : *integer # 物品原型id
	prefixs 3 : *integer  # 装备的前缀
}
.SearchMarketR{
	err 0 : integer          # 当玩家还没开启这个功能的时候返回err
	unit_type 1 : integer #哪个唯一类
	list 2 : *MarketItemInfo # 挂售列表
	type 3 : integer         # 哪个大类
}

.TheCheapest{
	protoId 0 : integer   #原型id
}
.TheCheapestR{
	err 0 : integer   #error
	list 1 : *MarketItemInfo  #挂售列表
}

#----------------market end-----------------------------
#----------------invest begin-----------------------------
#投资信息
.InvestInfo
{
}
.InvestInfoR
{
	status 0 : integer   #0:没有进行投资  1在投资中  2投资的收益全部领完
	days 1 : *integer   #已经领过的领包
	investStartTimestamp 2 : integer #开始投资的时间轴
}

#投资
.DoInvest
{

}
.DoInvestR
{
	err 0 : integer
}

#领投资的礼包
.DrawInvestGift
{
	day 0 : integer
}
.DrawInvestGiftR
{
	err 0 : integer
	day 1 : integer
}
#----------------invest end-----------------------------

#----------------recharge begin-----------------------------
.Recharge
{
	chargeId 0 : integer
}
.RechargeR
{
	err 0 : integer
	chargeId 1 : integer
	gold 2 : integer
}
#----------------recharge end-----------------------------
#----------------weekmonth_card begin-----------------------------
.WeekMonthCardInfo
{

}
.WeekMonthCardInfoR
{
	timestamp 0 : *integer #购买周卡时间轴  index=1的为周卡 =2为月卡
	drawGiftTimestamp 1 : *integer #领取的时间轴 index=1的为周卡 =2为月卡
}
.DrawWeekCardGift
{
}
.DrawWeekCardGiftR
{
	err 0 : integer
}
.DrawMonthCardGift
{
}
.DrawMonthCardGiftR
{
	err 0 : integer
}
#----------------weekmonth_card end-----------------------------
#----------------freestrength begin-----------------------------
.FreeStrenghtInfo{
}
.FreeStrenghtInfoR{
	freeStrength 0 : *integer  # 下标1的为午餐， 2的为晚餐   值为0则没有领过 1为领过了
}
.GainFreeStrength{
	type 0 : integer    #方式 0:正常领  补领:1
	freeType 1 : integer  # 1 午餐  2 晚餐
}
.GainFreeStrengthR{
	err 0 : integer
	freeType 1 : integer  # 1 午餐  2 晚餐
}
#----------------freestrength end-----------------------------
#
]]
