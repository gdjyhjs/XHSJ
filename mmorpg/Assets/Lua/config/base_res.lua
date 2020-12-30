local ret = {
	[1] = {
		money_id = 1, --[[资源类型]]
		name = "铜钱", --[[名字]]
		icon = "money_silver_01", --[[图标]]
		item_icon = "49990001", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990001, --[[物品原型]]
		get_way = 5, --[[获取途径]]
		get_way_desc = "<color=green>铜钱</color>可通过<color=green>摇钱树</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[2] = {
		money_id = 2, --[[资源类型]]
		name = "元宝", --[[名字]]
		icon = "money_gold_01", --[[图标]]
		item_icon = "40031201", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990002, --[[物品原型]]
		get_way = 1, --[[获取途径]]
	} ,
	[3] = {
		money_id = 3, --[[资源类型]]
		name = "绑定元宝", --[[名字]]
		icon = "money_gold_02", --[[图标]]
		item_icon = "40031301", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990003, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>绑定元宝</color>可通过<color=green>每周累计在线奖励</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[4] = {
		money_id = 4, --[[资源类型]]
		name = "体力", --[[名字]]
		icon = "fuben_icon_01", --[[图标]]
		item_icon = "fuben_icon_01", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990004, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>体力</color>可通过<color=green>剧情副本界面购买</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[5] = {
		money_id = 5, --[[资源类型]]
		name = "经验", --[[名字]]
		icon = "exp", --[[图标]]
		item_icon = "exp", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990005, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>经验</color>可通过<color=green>日常活动</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[6] = {
		money_id = 6, --[[资源类型]]
		name = "军团贡献", --[[名字]]
		icon = "49990006", --[[图标]]
		item_icon = "49990006", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990006, --[[物品原型]]
		get_way = 8, --[[获取途径]]
		get_way_desc = "<color=green>军团贡献</color>可通过<color=green>军团任务和活动</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[7] = {
		money_id = 7, --[[资源类型]]
		name = "名望", --[[名字]]
		icon = "49990007", --[[图标]]
		item_icon = "49990007", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990007, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>名望</color>可通过<color=green>日常活动</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[8] = {
		money_id = 8, --[[资源类型]]
		name = "战功", --[[名字]]
		icon = "49990008", --[[图标]]
		item_icon = "49990008", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990008, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>战功</color>可通过<color=green>pvp类活动</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[9] = {
		money_id = 9, --[[资源类型]]
		name = "斗币", --[[名字]]
		icon = "49990009", --[[图标]]
		item_icon = "49990009", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990009, --[[物品原型]]
		get_way = 2, --[[获取途径]]
		get_way_desc = "<color=green>斗币</color>可通过<color=green>1V1竞技</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[10] = {
		money_id = 10, --[[资源类型]]
		name = "淬火", --[[名字]]
		icon = "49990010", --[[图标]]
		item_icon = "49990010", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990010, --[[物品原型]]
		get_way = 4, --[[获取途径]]
		get_way_desc = "<color=green>淬火</color>可通过<color=green>装备熔炼</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[11] = {
		money_id = 11, --[[资源类型]]
		name = "荣誉", --[[名字]]
		icon = "49990011", --[[图标]]
		item_icon = "49990011", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990011, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>荣誉</color>可通过<color=green>逐鹿战场活动</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[12] = {
		money_id = 12, --[[资源类型]]
		name = "寻宝积分", --[[名字]]
		icon = "49990012", --[[图标]]
		item_icon = "49990012", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990012, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>寻宝积分</color>可通过<color=green>寻宝活动</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[13] = {
		money_id = 13, --[[资源类型]]
		name = "纹章", --[[名字]]
		icon = "49990013", --[[图标]]
		item_icon = "49990013", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990013, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>纹章</color>可通过<color=green>3V3烽火对决活动</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[14] = {
		money_id = 14, --[[资源类型]]
		name = "仓库积分", --[[名字]]
		icon = "49990012", --[[图标]]
		item_icon = "49990012", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990014, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>仓库积分</color>可通过<color=green>捐献装备到军团仓库里</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
	[15] = {
		money_id = 15, --[[资源类型]]
		name = "天命精粹", --[[名字]]
		icon = "49990015", --[[图标]]
		item_icon = "49990015", --[[物品图标]]
		color = 3, --[[物品图标底色]]
		item_code = 49990015, --[[物品原型]]
		get_way = 0, --[[获取途径]]
		get_way_desc = "<color=green>天命精粹</color>可通过<color=green>分解天命</color>获得", --[[获得途径描述（兑换商城最下面的文字）]]
	} ,
}
return ret