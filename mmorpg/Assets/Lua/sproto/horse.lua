local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[
.Horse
{
	horseId 0 : integer            #坐骑id
	soulLevel 1 : integer          #封灵等级
	slotLevel 2 : *integer         #封灵槽等级(5个)
}

#在玩家获得坐骑的时候会推送此内容
.HorseR
{
	horse 0 : Horse                 #坐骑信息
}

#获取信息
.GetHorseInfo
{
}

.GetHorseInfoR
{
	level 0 : integer                #等级
	exp 1 : integer                  #经验
	bHorse 2 : integer               #是否骑乘 0:否 1:是
	viewHorseId 3 : integer          #幻化坐骑id
	feedLevel 4 : integer            #喂养等级
	feedExp 5 : integer              #喂养经验
	horse 6 : *Horse                 #坐骑信息
}

.ExpAdd
{
    exp 0 : integer    #经验
    times 1 : integer    #次数
}

#进阶操作
.AddExpByItem
{
	addType 0 : integer          #1:使用一个;2:为一键进阶;
	bAutoBuyItem 1 : integer     #是否道具不足自动购买 0:否 1:是
}

.AddExpByItemR
{
	err 0 : integer
	exp 1 : integer       #经过使用道具之后，当前等级经验值
	expArr 2 : *ExpAdd   #每次加的经验
	level 3 : integer     #等级
}

#设置骑乘状态的坐骑
.SetHorseRiding
{
	bIntRide 0 : integer #0为不坐，1为骑乘
}

.SetHorseRidingR
{
	err 0 : integer
	bHorse 1 : integer   # 0为休息 1为骑
}

#设置当前幻化的的坐骑
.ChangeHorseView
{
	horseId 0 : integer   #设置当前幻化的的坐骑id
}

.ChangeHorseViewR
{
	err 0 : integer
	horseId 1 : integer
}

#封灵坐骑的哪个位置
.HorseSlotLevelUp
{
	horseId 0 : integer    #坐骑id
	slot 1 : integer       #槽(1~5)
}

.HorseSlotLevelUpR
{
	err 0 : integer
	horseId 1 : integer    #坐骑id
	slot 2 : integer       #槽(1~5)
	level 3 : integer      #槽等级(0~4)0时为soul升一级 全部slot变回0级
	horse 4 : Horse        #当level==0时增加这个信息
}

#喂养坐骑
.FeedHorse
{
 	guid 0 : *integer        #物品
}
.FeedHorseR
{
 	err 0 : integer
	feedexp 1 : integer     #当前喂养等级的经验
	feedlevel 2 : integer   #喂养等级
}

.FeedHorseByMemory
{
}
.FeedHorseByMemoryR
{
 	err 0 : integer
	feedexp 1 : integer     #当前喂养等级的经验
	feedlevel 2 : integer   #喂养等级
}

.SaveItemToFeedMemory
{
	protoIdArr 0 : *integer  #设置的喂养物品列表
}
.SaveItemToFeedMemoryR
{
 	err 0 : integer
	protoIdArr 1 : *integer  #设置的喂养物品列表
}

.RmItemToFeedMemory
{
	protoIdArr 0 : *integer  #设置的喂养物品的删除列表
}

.RmItemToFeedMemoryR
{
	protoIdArr 0 : *integer  #设置的喂养物品列表
}

.GetItemToFeedMemory
{
}
.GetItemToFeedMemoryR
{
	protoIdArr 0 : *integer  #设置的喂养物品列表
}

]]
