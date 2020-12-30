
--协议包对应id
local tbl = {
	login = 1,		--登陆服的协议
	base = 2,		--游戏服基本协议
	bag = 3,		--背包相关协议
	copy = 4, 	    --副本系统
	alliance = 5,  	--联盟协议
	email = 6, 		--邮件协议
	task = 7,		--任务/活动
	team = 8,       --组队
	--activity = 9,   --活动（迁移到task)
	hero = 10,		--英雄
	shop = 11,		--商店
	friend = 12,	--好友
	--rank = 13,		--排行榜协议(迁移到base)
	scene = 14,     --同步相关
	horse = 15,     --坐骑相关
}


--
local ret = {}
for k, v in pairs(tbl) do
	ret[k] = v
	ret[v] = k
end
return ret
