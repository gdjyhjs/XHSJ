local sprotoparser = require "sprotoparser"
return sprotoparser.parse [[

#注册账号
.Regist
{
	account 0 : string		#账号
	password 1 : string		#密码
	platform 2 : string 	#平台
	deviceId 3 : string		#设备id
	nickName 4 : string 	#昵称
	mobile 	 5 : string 	#手机号
}

.RegistR
{
	err 0 : integer			#错误码
}


#登陆
.Login
{
	account 0 : string		#账号
	password 1 : string		#密码 md5(key..password)
	deviceId 2 : string		#设备id
	thirdSDK 3 : string		#第三方sdk验证:QuickSDK
	token 4 : string		#第三方sdk验证token
	uid 5 : string          #用户uid
}


#登陆返回信息
.LoginR
{
	err 0 : integer			#错误码
	head 1 : string 		#头像，非首次登陆才有
	area 2 : integer		#服务器id
	areaName 3 : string		#服务器名
	state 4 : integer       #服务器状态
}

#连接成功时服务器主动推送
.ConnectR
{
	key 0 : string		#用于登陆验证
	notice 1 : string 	#公告
	config 2 : string 	#调试配置
}

#登陆某区
.LoginGame
{
	area 0 : integer	#区id
	name 1 : string		#新角色要填名字
	career 2 : integer  #职业(新角色)
}
.LoginGameR
{
	err 0 : integer		
	roleId 1 : integer	
	area 2 : integer	#区id
	ip 3 : string
	port 4 : integer
	dns 5 : string		#域名,如果不为nil,则先连域名
	createTm 6 : integer
}

.Role
{
	roleId 0 : integer
	area 1 : integer
	name 2 : string
	level 3 : integer
	head 4 : string
	lastTm 5 : integer		#最近登陆时间
}

.Server
{
	code 0 : integer       #区服id
	name 1 : string        #
	state 2 : integer      #状态，对应enum.SERVER_STATUS
	new 3 : boolean        #true 为新服
}

#获得服务器(区)列表
.AreaList
{
}
.AreaListR
{
	roleList 0 : *Role(area) #已有角色
	recommend 1 : *integer	#推荐服
	changeList 2 : *Server  #变更列表
}

#获得随机名字
.RandomRoleName{
	areaId 0 : integer #服务器id
	sex_type 1 : integer #1:男 2女
	bSymbol 2 : boolean #是否加符号
}

.RandomRoleNameR{
	err 0 : integer
	name 1 : string
}
#获得最少人选择的职业
.MinCareer{
	areaId 0 : integer #服务器id
}
.MinCareerR{
	career 0 : integer
}
]]

