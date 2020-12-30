local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[
#物品(道具、装备等)
.Item
{
	guid 0 : integer #物品唯一id
	protoId 1: integer  #物品原型
	num  2 : integer    #格子内的堆叠数量, 为0则证明清除该物品
	slot 3 : integer    #所在格子
	logT 4 : integer    #是什么系统引起的物品数量变化
}

.PolishAttr{
	attr 0 : integer    #属性
	value 1 : integer   #值
}

.PolishInfo
{
	equipType 0 : integer
	attrs 1 : *PolishAttr   #洗炼属性数组
}

#使用物品
.UseItem
{
	guid 0 : integer #物品唯一id
	num  1 : integer #使用数量，不能大于当前物品堆叠数
}

.UseItemR
{
	err  0 : integer #0-正确，其他为错误码
	protoId 1 : integer # 1 原型id(俊山需要)
}

#批量使用物品
.MultiUseItem
{
	guid 0 : *integer #物品唯一id
	num  1 : *integer #使用数量，不能大于当前物品堆叠数
}

.MultiUseItemR
{
	errs  0 : *integer #0-正确，其他为错误码
	protoId 1 : *integer # 1 原型id
}

#使用藏宝图返回
.UseTreasureMapR
{
	treasureMapInfo 0 : *integer #藏宝图藏宝位置 {mapid, x, y} 用于自动寻路
	guid            1 : integer  #自动寻路 返回guid
}

#开始挖宝
.DigTreasureMap
{
	guid  0 : integer #物品唯一id 此处是宝图
}
#返回结果事件 但奖励不会立即发送 等前端播放完动画 请求TreasureMapReward时再发送奖励
.DigTreasureMapR
{
	err         0 : integer 	#0-成功，其他为错误码
	eventCode   1 : integer 	#返回触发事件 treasure_map_event导表code
	equipList 	2 : *Equip 		#装备列表
}

#宝图怪物死后奖励推送
.TreasureMapMonsterRewardR
{
	eventCode   0 : integer 	#返回触发事件 treasure_map_event导表code
	equipList 	1 : *Equip 		#装备列表
}

#物品整理
.SortItem
{
	type 0 : integer   #背包类型,对应enum.BAG_TYPE(无返回)
}

#拆分物品
.SplitItem
{
	guid 0 : integer #物品唯一id
	num  1 : integer #使用数量，不能大于等于当前物品堆叠数
}

.SplitItemR
{
	err  0 : integer #0-正确，其他为错误码
}

#出售物品
.SellItem
{
	guid 0 : integer #物品唯一id
	num  1 : integer #使用数量，不能大于等于当前物品堆叠数
}
.SellItemR
{
	err  0 : integer #0-正确，其他为错误码
}

#物品合并
.MergeItem
{
	type 0 : integer  #背包类型,对应enum.BAG_TYPE(无返回)
}

#物品交换位置
.SwapItem
{
	srcSlot 0 : integer  #源物品位置
	destSlot 1 : integer #目标物品位置
}

.SwapItemR
{
	err 0 : integer      #
	srcSlot 1 : integer  #源物品位置
	destSlot 2 : integer #目标物品位置
}

#更新物品信息
.UpdateItemR
{
	itemList 0 : *Item     #物品列表
}


#开启格子
.UnlockSlot
{
	slot 0 : integer    #slotid  #需要开启的格子
}

.UnlockSlotR
{
	err 0 : integer
}

#更新背包大小
.UpdateBagSizeR
{
	type 0 : integer
	size 1 : integer
}

.EquipAttrR
{
	attr 0 : integer  #属性 为enum.COMBAT_ATTR 中的值
	value 1 : integer #数值
}

.Equip
{
	guid 0 : integer 	            #唯一id
	num 1 : integer                 #数量（一般情况下=1)
	protoId 2 : integer             #对应物品表中的code
	formulaId 3 : integer           #打造id，对应config/equip_formula中的formulaId
	slot 4 : integer                #槽
	color 5 : integer               #品质
	spec 6 : integer                #特效 为 equip_spec表中的id
	prefix 7 : integer              #前缀 为 enum.EQUIP_PREFIX_TYPE 中的值
	baseAttr 8 : *EquipAttrR        #基础属性
	exAttr 9 : *EquipAttrR          #额外属性(HJS)
}

.UpdateEquipR
{
	equipList 0 : *Equip
}

.OtherEnhanceGemInfo
{
	enhanceId 0 : integer
	gemIds 1 : *integer
}


#武将装备信息
.HeroEquip
{
	guid 0 : integer                 #唯一id
	num 1 : integer                 #数量（一般情况下=1)
	protoId 2 : integer             #对应物品表中的code
	createId 3 : integer            #hero_equip对应的create_id
	slot 4 : integer                #槽
	heroEquipAttr 5 : *EquipAttrR            #属性值
	skills 6 : *integer           #技能列表
}
.UpdateHeroEquipR
{
	heroEquipList 0 : *HeroEquip
}

#获取背包道具列表
.GetBagInfo
{
	type 			0 : integer 	#背包类型,对应enum.BAG_TYPE
}

.GetBagInfoR
{
	itemList 		0 : *Item 		#背包道具列表
	equips 			1 : *Equip 		#背包装备列表
	size 			2 : integer 	#背包大小
	unlockTimeLeft 	3 : integer 	#开启下一个格子剩余时间, 0为可开启
	heroEquips 		4 : *HeroEquip 	#背包武将装备列表
	type 			5 : integer 	#背包类型,对应enum.BAG_TYPE
}

#更新整个背包
.UpdateBagR
{
	type 0 : integer     #背包类型
	itemList 1 : *Item   #详细内容
	equips 2 : *Equip #背包装备列表
	heroEquips 3 : *HeroEquip #背包武将装备列表
}

#打造装备
.FormulaEquip
{
	formulaId 0 :integer    #打造id，对应config/equip_formula中的formulaId
	protoId 1 :integer         #用来进行品质保底打造的物品
	starProtoId 2 :integer         #用来进行星魂保底打造的物品
}
.FormulaEquipR
{
	err   0 : integer
	equip 1 : Equip
}

#升级镶嵌了的宝石
.GemLevelUpInLay
{
	equipType 0 : integer       #装备小类
	protoId 1 : integer        #使用哪个物品来升级这个
	idx 2 : integer        #镶嵌哪个位置上的
}

.GemLevelUpInLayR
{
	err 0 : integer
}

#当镶嵌宝石发生变化时
.GemUpdateR
{
	equipType 0 : integer       #装备小类
	protoId 1 : integer         #镶嵌上去后升级的那个宝石 0为卸下
	idx 2 : integer        #镶嵌哪个位置上的
}

#宝石升级(对已镶嵌在装备上的宝石)
#这个功能，换个策划就换个逻辑，为了避免又换回这个逻辑之后我又要改，那我就不删好了。
.GemLevelUp
{
	equipType 0 : integer       #装备小类
	idx 1 : integer           #位置(1~6)
}
.GemLevelUpR
{
	err 0 : integer
}

#宝石智能升级 
#因理解宝石升级的操作有误导致 GemLevelUp不能满足需求又想保留 所以才有这一条协议
#相对而言，SmartGemLevelUp 比 GemLevelUp更智能，故称为 SmartGemLevelUp
#这个功能，换个策划就换个逻辑，为了避免又换回这个逻辑之后我又要改，那我就不删好了。
.SmartGemLevelUp
{
	targetGemProtoId 0 : integer     #希望合成的宝石code
	bUseGrandsonGem 1 : boolean      #是否使用比自己小2个等级以及以下的宝石来升级
}
.SmartGemLevelUpR
{
	err 0 : integer
}

#镶嵌宝石
.InlayGem
{
	guid 0 : integer              #唯一id
	equipType 1 : integer        #装备类型 为 enum.EQUIP_TYPE 中的值
	gemIdx 2 : integer           #下标从1开始
}
.InlayGemR
{
	err 0 : integer
	#protoId 1 : integer       #原型id
	#equipType 2 : integer        #装备类型 为 enum.EQUIP_TYPE 中的值
	#gemIdx 3 : integer           #下标从1开始
}

#拆卸宝石
.UnloadGem
{
	equipType 0 : integer        #装备类型 为 enum.EQUIP_TYPE 中的值
	gemIdx 1 : integer
}
.UnloadGemR
{
	err 0 : integer
}

#强化装备
.EnhanceEquip
{
	equipType 0 : integer        #装备类型 为 enum.EQUIP_TYPE 中的值
}
.EnhanceEquipR
{
	err 0 : integer
	exp 1 : integer  #强化后的最终经验
	enhanceId 2 : integer  #强化后的最终enhanceid(HJS)
}


#获取强化信息
.EnhanceInfo
{
}
.EnhanceInfoR
{
	enhanceIds 0 : *integer  #以equipType为下标的数组
	exp 1 : *integer      #以equipType为下标的数组  经验值(HJS)
}

#获取宝石镶嵌列表
.EquipGem
{
	gemIds 0 : *integer   #一个装备槽能放三个宝石
}


#获取宝石信息
.GemInfo
{
}

.GemInfoR
{
	equipTyMapGem 0 : *EquipGem   #以equip_type为key 的宝石列表的列表
}


.GetPolishInfo{

}
.GetPolishInfoR
{
	equipTypePolishInfo 0 : *PolishInfo  #
}


#洗炼(HJS2)
.PolishEquip
{
	equipType 0 : integer  #装备类型
	lock 1 : *integer  #锁定的属性下标（1~4)的数组 比如[2,3,4] 意为锁定第2，3，4条
	purple 2 : integer  #是否使用元宝必出紫色(0:否，1：是)
}

.PolishEquipR
{
	err 0 : integer   
	attrs 1 : *PolishAttr   #洗炼过后未保存的属性数组
	equipType 2 : integer  #装备类型
}

#获取未保存的洗炼得到的值(HJS2)
.GetPolishAttr
{
	equipType 0 : integer
}

.GetPolishAttrR
{
	err 0 : integer
	attrs 1 : *EquipAttrR #返回装备属性列表
	equipType 2 : integer
}

#保存洗炼得到的属性(HJS2)作废 
.SavePolish
{
	equipType 0 : integer
}

.SavePolishR
{
	err 0 : integer
	equipType 1 : integer
}

#查看其他玩家装备强化和镶嵌信息 可能会废弃
.OtherPlayerEnhanceGemInfo
{
	roleId 0 : integer
	equipType 1 : integer       #某一装备槽的信息  ==0 时为全身的装备槽
}

.OtherPlayerEnhanceGemInfoR
{
	err 0 : integer   #错误码
	infos 1 : *OtherEnhanceGemInfo
	equipType 2 : integer
	roleId 3 : integer
}

#查看其它玩家装备
.OtherPlayerEquip
{
	roleId 0 : integer         #查看roleId的装备
	guid 1 : integer            #查看guid的装备
}

.OtherPlayerEquipR
{
	err 0 : integer           
	equip 1 : Equip
	roleId 2 : integer
	enhanceId 3 : integer         #该装备类型的强化
	gemIds 4 : *integer           #该装备类型的镶嵌
	setMask 5 : integer           #该装备套装二进制数组 equiptype为index
	attrs 6 : *PolishAttr         #洗炼属性数组
}

#简略信息装备
.SimpleEquip
{
	protoId 0 : integer #原型id
	color 1 : integer   #品质
	guid 2 : integer    #物品guid
	star 3: integer      #装备星级
}

#查看其它玩家的所有简略信息装备
.OtherPlayerSimpleEquip
{
	roleId 0 : integer         #查看roleId的装备
}
.OtherPlayerSimpleEquipR
{
	err 0 : integer
	roleId 1 : integer         #查看roleId的装备
	list 2 : *SimpleEquip
}

#装备淬火
.RecycleEquip
{
	guidArr 0 : *integer     #需要回收的装备guid数组
}
.RecycleEquipR
{
	err 0 : integer
}

#----------------------------- 熔炼系统 ------------begin
.SmeltItem
{
	smeltId  0 : integer      #熔炼id
	num 	 1 : integer      #数量
}
.SmeltItemR
{
	err 0 : integer   #合成成功0 合成失败1 其他错误码
	protoIdArr 1 : *integer          #熔炼得到的的物品原型id array
	protoNumArr 2 : *integer     #熔炼得到的物品数量 array
}

#获取是否只显示能打造的
.GetOnlyShowCan
{
}
.GetOnlyShowCanR
{
	bOnlyShowCan 0 : boolean
}

#设置是否只显示能打造的
.SetOnlyShowCan
{
	bOnlyShowCan 0 : boolean
}
.SetOnlyShowCanR
{
}

#----------------------------- 熔炼系统 ------------end

#------------------------------天命系统 ------------begin

#分解
.ResolveDestiny
{
	resolveDuidArr  0 : *integer   #选择要分解的 duidArr  duid为天命唯一id
}
.ResolveDestinyR
{
	err         0 : integer
	successDuid 1 : *integer 	   #返回分解成功的duid集合
}

#升级
.UplevelDestiny
{
	slot 		0 : integer    #哪个槽位
}
.UplevelDestinyR
{
	err         0 : integer
	duid        1 : integer    #升级的那个duid
	destinyId   2 : integer    #对应天命表【destiny_level】中的destiny_id
}

#将某个天命装到身上的某个槽上
.SetDestinyToSlot
{
	duid   0 : integer   #天命uid   0为脱
	slot   1 : integer   #哪个槽位
}
.SetDestinyToSlotR
{
	err    0 : integer
	duid   1 : integer   #天命uid
	slot   2 : integer   #哪个槽位
}

.DestinyDrawInfo
{
	duid  	  0 : integer     #天命唯一id
	destinyId 1 : integer 	  #对应天命表【destiny_level】中的destiny_id
}

#抽取天命(元宝)
.DrawDestiny
{
	countType 0 : integer     # 1:1次 2:10次 
}
.DrawDestinyR
{
	err 0 : integer
	destinyDrawInfoArr   1 : *DestinyDrawInfo #抽奖得到的
}

#铜钱抽取天命结果对象
.DestinyDrawResult
{
	err 				 0 : integer
	destinyDrawInfo 	 1 : DestinyDrawInfo  #抽奖得到的结果
	newDrawIndex 		 2 : integer 		  #下次可抽取的目录
}

#抽取天命(铜钱)
.DrawDestinyCoin
{
	countType 			0 : integer     	  # 1:1次 2:一键猎命 
	drawIndex 			1 : integer 	  	  # 抽取时点击的目录，只有单抽的时候才有效
}
.DrawDestinyCoinR
{
	destinyDrawResultArr  0 : *DestinyDrawResult 	#抽取结果列表
	drawIndex 			  1 : integer 				#用于单抽时匹配信息
}

#当通过打怪，开礼包等方式获得的时候，会有此推送
.GainDestinyR
{
	destinyDrawInfoArr   0 : *DestinyDrawInfo #抽奖得到的
}

.DestinyVO
{
	duid      0      : integer     #天命唯一id
	destinyId 1 	 : integer     #天命ID    对应天命表【destiny_level】中的destiny_id
	slot      2      : integer     #槽位  -->只有在身上的时候，这个信息才有效
}
#获取当前可抽的天命目录(new)
.GetDestinyCanDraw
{
}
.GetDestinyCanDrawR
{
	destinyCanDraw 		 0 : integer 		  #返回可抽取的目录，二进制最高5位(new)
}

#获取天命背包列表
.GetDestinyVOArr
{
	type 0 : integer       #1背包 2抽奖面板  3身上 enum.DESTINY_CONTIANER_TYPE 【v1.0.5:抽奖面板已取消(new)】
}
.GetDestinyVOArrR
{
	destinyVOArr   0 : *DestinyVO #
	type 1 : integer       #1背包 2抽奖面板  3身上 	【v1.0.5:抽奖面板已取消(new)】
}


#------------------------------天命系统 ------------end
#------------------------------签到系统 ------------begin
#获取签到信息
.GetSigninInfo
{
}
.GetSigninInfoR
{
	daysTotal 0 : integer           # 累计签到天数
	bIntTodayDraw 1 : integer       # 今天是否已经领过礼包
	giftGroupId 2 : integer         # 正在生效的奖励组
	accmulateGiftIdArr 3 : *integer # 已经领过的 累计签到礼包的天数
}
#今天签到
.DragTodayGift
{

}
.DragTodayGiftR
{
	err 0 : integer
}
#累计签到
.DragAccmulateGift
{
	days 0 : integer
}
.DragAccmulateGiftR
{
	err 0 : integer
	days 1 : integer
}
#------------------------------签到系统 ------------end
#------------------------------在线奖励 ------------begin
#获取在线时长的礼包
.OnlineGiftInfo
{

}
.OnlineGiftInfoR
{
	secondArr 0 : *integer        # 已经领取过的时长礼包
	protoIdArr 1 : *integer       # 已经领取过的时长礼包得到的原型id
	thisWeekOnlineTm 2 : integer  # 这周的登陆时间长度
	lastWeekOnlineTm 3 : integer  # 上一周登陆时间长度 如果为0则表示已经领过了或者上周玩家还没注册或者说上周压根就没上线
	todayOnlineTm 4 : integer     # 今天在线时间长度
}
#领取今天的时间礼包
.DrawOnlineGift
{
	second 0 : integer  #领取的时间礼秒数
}
.DrawOnlineGiftR
{
	err 0 : integer
	second 1 : integer
	protoId 2 : integer
}

#领取上周的时间礼包
.DrawLastWeekOnlineGift
{
}
.DrawLastWeekOnlineGiftR
{
	err 0 : integer
}
#------------------------------在线奖励 ------------end
#------------------------------外观时装 ------------begin
#获取外观列表
.GetSurfaceInfo
{
}
.GetSurfaceInfoR
{
	surfaceIdArr 0 : *integer # 外观id列表
	wearSurfaceId 1 : *integer   # 穿在身上的外观id列表 以enum.SURFACE_TYPE 为index的数组
}
#激活外观
.ActiveSurface
{
	surfaceId 0 : integer
}
.ActiveSurfaceR
{
	err 0 : integer
	surfaceId 1 : integer
}
#穿上外观
.WearSurface
{
	surfaceId 0 : integer
}
.WearSurfaceR
{
	err 0 : integer
	surfaceId 1 : integer
}
#卸下外观
.UnWearSurface
{
	type 0 : integer    #值为enum.SURFACE_TYPE 中的值
}
.UnWearSurfaceR
{
	err 0 : integer
	type 1 : integer
}
.ForAccPoint{
	equipLv 0 : integer
	point 1 : integer
}
#获取神器值
.FormulaAccumulate{
}
.FormulaAccumulateR{
	forAccPoint 0 : *ForAccPoint #神器值
}
#------------------------------外观时装 ------------end

#------------------------------改名卡 ------------begin
#改名接口
.ChangeName{
	newName 0 : string 		#新名称
	type 	1 : integer 	#更名种类 	1：玩家更名；2：军团更名
}
.ChangeNameR{
	err 	0 : integer 	#错误代码 	0：成功；其他为失败
}
#------------------------------改名卡 ------------end
]]
