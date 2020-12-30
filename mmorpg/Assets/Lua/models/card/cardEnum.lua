local cardEnum = {}

cardEnum.STATE = {
	IDLE = 1,	-- 待机
	MATCHING = 2,	-- 匹配中
	SELECT_CARD = 4, -- 选牌
	BATTLE = 8,	-- 对战
	SETTLEMENT = 16, -- 结算
	ENEMY_RUN = 32, -- 对方逃跑
}

return cardEnum