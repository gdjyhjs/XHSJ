--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-07-06 16:12:37
--]]

local BagEnum = {}

BagEnum.MODE = {
	KNAPSACK = 1, --背包 knapsack
	DEPOT = 2,	--仓库
	FUSION = 3,		--炼化合成
	SET = 4,	--设置
}

BagEnum.ITEM_STATE = {
NONE = 0,			--0=空
HAVE = 1,			--1=有
CAN_UNLOCK = 2,		--2=可解锁
UNLOCKING = 3,		--3=解锁中
LOCK = 4,			--4=锁定
}

BagEnum.FUSION_TYPE ={
	NORMAL = 1, --普通炼化
	SPECIA = 2, --特殊炼化
}

BagEnum.PAGE = {
	LAST=1, --上一页
	CUR=2, --当前页
	NEXT=3, --下一页
}

return BagEnum