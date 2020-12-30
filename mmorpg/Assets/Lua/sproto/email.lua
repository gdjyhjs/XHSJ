local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

#装备属性构造体
.EquipAttrR
{
	attr 0 : integer  #属性 为enum.COMBAT_ATTR 中的值
	value 1 : integer #数值
}

#军团仓库装备构造体
.Equip
{
	guid 			0 : integer 			#唯一id
	num 			1 : integer				#数量（一般情况下=1)
	protoId 		2 : integer				#对应物品表中的code
	formulaId 		3 : integer				#打造id，对应config/equip_formula中的formulaId
	slot 			4 : integer				#槽
	color 			5 : integer				#品质
	spec 			6 : integer				#特效 为 equip_spec表中的id
	prefix 			7 : integer				#前缀 为 enum.EQUIP_PREFIX_TYPE 中的值
	baseAttr 		8 : *EquipAttrR			#基础属性
	exAttr 			9 : *EquipAttrR			#额外属性(HJS)
}

#附件物品
.Reward
{
	code 	0 : integer 	#物品id
	num 	1 : integer		#数量
	equip 	2 : Equip 		#装备构造体
}

#邮件结构体
.Email
{
	guid    0 : integer  #邮件唯一id
	type    1 : integer  #邮件大类(附件/普通),枚举enum.EMAIL_TYPE
	time    2 : integer	 #发邮件时间
	isRead  3 : boolean	 #true-已读,false-未读
	isTaken 4 : boolean  #true-已领,false-未领
	detail  5 : string	 #详细内容，json格式，用来拼接详细内容
	reward  6 : *Reward  #奖励,注:非附件类邮件该字段为空
}

.Result{
	err  0 : integer	#0-成功，其他为错误码
	guid 1 : integer    #邮件guid
}

#获取邮件协议
.GetEmailList
{

}
.GetEmailListR
{
	emails 0 : *Email
}

#读取邮件,已读邮件不需要再调用此接口
.ReadEmail
{
	guid 0 : integer	#邮件guid
}
.ReadEmailR
{
	err  0 : integer	#0-成功，其他为错误码
	guid 1 : integer    #邮件guid
}

#领取N封邮件奖励
.GetEmailReward
{
	guids 0 :   *integer #邮件guid数组
}
.GetEmailRewardR
{
	results 0 : *Result #结果数组
}

#删除N封邮件
.DeleteEmail
{
	guids 0 :   *integer #邮件guid数组
}
.DeleteEmailR
{
	results 0 : *Result #结果数组
}

#新邮件推送
.UpdateNewEmailR
{
	emailList 0 : *Email
}

#外挂添加email 
.DebugAddEmail
{
    type 0   : integer  #邮件大类(附件/普通),枚举enum.EMAIL_TYPE
    detail 1 : string       #邮件内容
    reward 2 : *Reward      #奖励内容
}
.DebugAddEmailR
{
    err 0 : integer #0-成功,其他为错误码
}

#上线获取邮箱状态
.LoginGetEmailInfo
{
}
.LoginGetEmailInfoR
{
	offlineNew     0 : integer   #离线期间是否有新邮件       1有0没
	notReadOrItems 1 : integer   #有未读或者未领取附件的邮件 1有0没
	totalCount     2 : integer   #邮件总数量
}

#为避免打开界面期间删除了正在读的邮件 现在是前端打开或关闭邮件界面时 发送此协议让后端删除该删除的邮件
.CheckDelete
{
}
.CheckDeleteR
{
	delList 0 : *integer #邮件guid列表
}

]]