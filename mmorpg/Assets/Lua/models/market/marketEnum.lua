--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-19 18:32:47
--]]

local MarketEnum = {}

MarketEnum.MODE = {
	BUY = 1,
	SELL = 2,
}

--税收比率
MarketEnum.TAX_RATIO = {
	NORMAL = 0,	--正常
	DOUBLE = 1, --双倍
	HALF = -1, --一半
}

MarketEnum.SELL_STATE = {
	LOCK = 1, --锁定
	NONE = 2, --空
	SELL = 3, --正在出售
	SOLD = 4,	--有售出
	SOLD_OUT = 5,	--超时
}

-- 取消下架时的sid
MarketEnum.CancelSellSid = {
	NONE = 1, -- 普通下架
	AGAIN_UP = 2, -- 重新上架
}


return MarketEnum
