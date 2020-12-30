local socialEnum = {}

--社交模块
socialEnum.MODE = { --要对应ui的ReferGameObjets
	FRIEND = 1,	--好友
	MAIL = 2,	--邮件
	JIEHUN = 3, --结婚（未开封）
	JIEBAI = 4, --结拜（未开封）
}

--好友项
socialEnum.FRIEND_ITEM = { --要对应ui的ReferGameObjets
	MY = 1, --我的
	RECOMMEND = 2, --推荐
	GET_ENERGY = 3, --获取体力
	RECENT_CONTACT = 4, --最近联系
	FRIENDS_APPLY = 5, --好友申请
	ENEMY = 6, --仇人
	BLACK = 7, --黑名单
	NULL_ITEM_IMG = 8, --空项图片
	FIND_PLAYER = 9, --查找玩家
	FRIEND_MANAGE = 10, --好友管理
}


return socialEnum