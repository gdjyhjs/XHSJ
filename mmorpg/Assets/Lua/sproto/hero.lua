local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[
.ExpBookObj{
	guid 0 : integer 	#使用经验书的唯一id
	count 1 : integer	#使用多少本
}

#通过经验书给武将加经验
.AddHeroExpByBook
{
	bookList 0 : *ExpBookObj   # 使用经验书的列表
	heroId   1 : integer 	   # 对哪个武将使用
}

.AddHeroExpByBookR
{
	err 0 : integer
	heroId 1 : integer # 对哪个武将使用
	exp 2 : integer    # 当前等级经验
	level 3 : integer  # 等级
}

.EquipAttrR
{
	attr 0 : integer  #属性 为enum.COMBAT_ATTR 中的值
	value 1 : integer #数值
}

#武将装备信息
.HeroEquip
{
	guid 0 : integer              # 唯一id
	num 1 : integer               # 数量（一般情况下=1)
	protoId 2 : integer           # 对应物品表中的code
	createId 3 : integer          # hero_equip对应的create_id
	slot 4 : integer              # 槽
	heroEquipAttr 5 : *EquipAttrR # 属性值
	skills 6 : *integer           # 技能列表
}

#武将信息
.HeroInfo
{
	chip 0 : integer             # 武将碎片
	heroId 1 : integer           # 武将id
	level 2 : integer            # 武将等级  ==0时 表示它只是碎片（后面那些值都不再发送）
	awakenLevel 3 : integer      # 觉醒等级
	exp 4 : integer              # 武将当前等级经验
	deadTime 5 : integer         # 武将挂掉的时间轴
	talent 6 : *integer          # 武将天资   下标：(1:武力 2体魄 3灵动,4天资)
	skill 7 : *integer           # 武将技能id列表
	heroEquipInfo 8 : *HeroEquip # 武将的装备信息
	name 9 : string              # 名字
	polishTalent 10 : *integer   # 武将天资   下标：(1:武力 2体魄 3灵动,4天资)
	polishSkill 11 : *integer    # 武将技能id列表
}


#阵位信息
.SquarePosInfo
{
	posId 0 : integer     #阵位
	level 1 : integer     #阵位等级
	exp 2 : integer       #阵位经验
	heroId 3 : integer    #阵位上的武将
}

#布阵信息
.SquareInfo
{
	squareId 0 : integer         #布阵id
	posInfo 1 : *SquarePosInfo   #阵位信息
}

#获取武将信息
.GetHeroInfo
{

}
.GetHeroInfoR
{
	hero 0 : *HeroInfo           # 武将信息
	size 1 : integer             # 大小
	fightHeroIdList 2 : *integer # 设置出战武将id [1]位置上的为设置为出战武将
	fightIngHeroId 3 : integer   # 当前正在战斗中武将id  -1是休息
	square  4 : *SquareInfo      # 布阵信息
	squareId 5 : integer         # 生效的布阵id
	heroEquips 6 : *HeroEquip    # 装备仓库中的装备
}

#保存
.SavePolishHero
{
	heroId 0 : integer
}
.SavePolishHeroR
{
	err 0 : integer
	heroId 1 : integer
}
#洗练武将
.PolishHero
{
	heroId 0 : integer          # 需要洗炼的武将
	lockSkillIdArr 1 : *integer # 锁住的技能
	bIntAutoBuy 2 : integer     # 是否自动购买 0：非，1：自动购买
}

.PolishHeroR
{
	err 0 : integer
	heroId 1 : integer    #需要洗炼的武将
	talent 2 : *integer      #洗炼出来的武将天资   下标：(1:武力 2体魄 3灵动 4天资)
	skill 3 : *integer       #洗炼出来的武将技能id列表
}

#穿上装备
.SetHeroEquip
{
	heroId 0 : integer   #武将id
	guid 1 : integer      #需要装上的武器
}

.SetHeroEquipR
{
	err 0 : integer
	heroId 1 : integer               #武将id
	guid 2 : integer      #需要装上的武器
}
#卸下装备
.UnloadHeroEquip
{
	heroId 0 : integer   #武将id
	guid 1 : integer      #需要卸下的的武器
}

.UnloadHeroEquipR
{
	err 0 : integer
	heroId 1 : integer               #武将id
	guid 2 : integer      #需要卸下的的武器
}

#学习或替换技能
.GainSkillByBook
{
	heroId 0 : integer  #武将id
	guid 1 : integer     #需要使用的武将技能书
	skillIdx 2 : integer   #被设置的武将技能index(若是发生替换的时候，则原index中会存在有skillId)
}

.GainSkillByBookR
{
	err 0 : integer
	heroId 1 : integer    #武将id
	skillIdx 2 : integer   #被设置的武将技能index(若是发生替换的时候，则原index中会存在有skillId)
	skillId 3 : integer    #武将获得的技能id
}

#当一个武将被玩家获得的时候，推送的信息
.GainHeroR
{
	heroId 0 : integer   # 武将id
	chip 1 : integer     # 碎片数量
	talent 2 : *integer  # 武将天资   下标：(1:武力 2体魄 3灵动 4天资)
	skills 3 : *integer  # 技能列表
	fightIdx 4 : integer # 此武将在出战列表中的位置 0为不出现在列表中
}
#当获得武将碎片时候的推送
.GainHeroChipR
{
	heroId 0 : integer    #武将id
	chip 1 : integer    #碎片数量
}

#设置出战武将
.SetHeroFight
{
	heroId 0 : integer        #武将id
}

.SetHeroFightR
{
	err 0 : integer
	heroId 1 : integer        #武将id
}

#开锁
.UnlockHeroSlot
{
}
.UnlockHeroSlotR
{
	err 0 : integer
	size 1 : integer  #武将容量
}

#解锁阵法位 升级也是用这个协议
.UnlockSquarePos
{
	squareId 0 : integer      #阵法id
	pos 1 : integer           #阵位id
}
.UnlockSquarePosR
{
	err 0 : integer 
	squareId 1 : integer      #阵法id
	pos 2 : integer           #阵位id
}

#将武将放到某个阵位上
.PutHeroToSquarePos
{
	heroId 0 : integer     #武将id  =0时为下阵
	squareId 1 : integer    #阵法id
	pos 2 : integer         #阵位
}
.PutHeroToSquarePosR
{
	err 0 : integer
	heroId 1 : integer     #武将id
	squareId 2 : integer    #阵法id
	pos 3 : integer         #阵位
}

#重生
.RecycleHero
{
	heroId 0 : integer   #武将id
}
.RecycleHeroR
{
	err 0 : integer
	heroId 1 : integer   #武将id
	talent 2 : *integer  #武将天资   下标：(1:武力 2体魄 3灵动 4天资)
	skill 3 : *integer   #武将技能id列表
}

#设置生效的阵法
.SetSquare
{
	squareId 0 : integer         #设置生效的阵法
}

.SetSquareR
{
	err 0 : integer
	squareId 1 : integer         #设置生效的阵法
}

#重命名
.RenameHero
{
	heroId 0 : integer #武将id
	name 1 : string     #武将名
}
.RenameHeroR
{
	err 0 : integer
	heroId 1 : integer #武将id
	name 2 : string     #武将名
}

#查看其他玩家的武将
.OtherPlayerHero
{
	roleId 0 : integer
	heroId 1 : integer       #武将id
}
.OtherPlayerHeroR
{
	err 0 : integer
	hero 1 : HeroInfo
	heroAttr 2 : *EquipAttrR
}
.AddTalentByItem
{
	heroId 0 : integer #武将id
	talentType 1 : integer
	countType 2 : integer    # 0 全部，1 一个
}

.AddTalentByItemR
{
	err 0 : integer
	heroId 1 : integer #武将id
	talentType 2 : integer #资质类型
	talentValue 3 : integer #资质值
}

############## new
#将武将放到出战列表中去
.SetHeroToFightList
{
	heroId 0 : integer
	action 1 : integer  #1:上阵，2:下阵
}
.SetHeroToFightListR
{
	err 0 : integer
	heroId 1 : integer
	action 2 : integer  #1:上阵，2:下阵
}
#所有武将均不出战
.Rest{

}
.RestR{
	err 0 : integer
}
#觉醒
.AwakenHero{
	heroId 0 : integer    #要觉醒的武将
}
.AwakenHeroR{
	err 0 : integer
}
#当玩家获得一件武将装备的时候才会有这个推送（在给武将穿上装备和卸下装备的时候没有这个推送）
.UpdateHeroEquipR{
	list 0 : *HeroEquip   #装备列表信息
}
.TalentItemHistory{
	protoId 0 : integer #原型id
	count 1 : integer #数量
}
#获取给这个武将增加使用过增加天资的道具
.GetTalentItemHistory{
	heroId 0 : integer
}
.GetTalentItemHistoryR{
	err 0 : integer
	heroId 1 : integer
	talentItemHistory 2 : *TalentItemHistory
}

#在场景中挂掉的推送
.HeroDieR{
	heroId 0 : integer  #0为没有新的武将出来
	deadHeroId 1 : integer
	deadTime 2 : integer         # 武将挂掉的时间轴
}
]]
