local ret = {
	[1] = {
		type = 1, --[[广播类型]]
		content = "恭喜<901,v1,v2>获得了<902,v3,v4>", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,prid,num}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[2] = {
		type = 2, --[[广播类型]]
		content = "<908,v1>出现在<905,v2,v3,v4>，最恐怖的领主出现了！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{bossId,mapId,x,y}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[3] = {
		type = 3, --[[广播类型]]
		content = "<901,v1,v2>使用了<902,v4>，激活了<909,v3>的幻化，从此坐骑变化无穷!", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,horseId,prid}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[4] = {
		type = 4, --[[广播类型]]
		content = "<901,v1,v2>将坐骑<909,v3>封灵达到<910,v4>级，<909,v3>更显神骏了", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,horseId,soullevel}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[5] = {
		type = 5, --[[广播类型]]
		content = "天道酬勤!经过不懈努力，<901,v1,v2>终于将坐骑进阶至<910,v4>阶，幻化成<909,v3>", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,horseId,grade}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[6] = {
		type = 6, --[[广播类型]]
		content = "<901,v1,v2>向<901,v3,v4>赠送了<910,v5>朵<902,v6>，大家快来围观吧~", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId, roleName, toRoleId, toRoleName,num, flowerId, flowerName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[7] = {
		type = 7, --[[广播类型]]
		content = "<901,v1,v2>通过神谕藏宝图召唤了远古魔兽<905,v3,v4,v5>，击杀可获得丰厚奖励！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName, mapId,x,y}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[8] = {
		type = 8, --[[广播类型]]
		content = "[<901,v1,v2>]悄悄地走了，正如悄悄地来。", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[9] = {
		type = 9, --[[广播类型]]
		content = "欢迎[<901,v1,v2>]加入本军团！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[10] = {
		type = 10, --[[广播类型]]
		content = "[<901,v1,v2>]已被踢出本军团！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[11] = {
		type = 11, --[[广播类型]]
		content = "<901,v1,v2>将<901,v3,v4>的职位从<color=#00ff1e><910,v5></color>调整为<color=#00ff1e><910,v6></color>。", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,roleId,roleName,titleName,titleName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[12] = {
		type = 12, --[[广播类型]]
		content = "在全体成员的努力下，军团等级提升到了<910,v1>级！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{allianceLevel}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[13] = {
		type = 13, --[[广播类型]]
		content = "由于没有在指定时间内收集足够的物资，施工队罢工不干啦！没办法只有等下次了 TAT", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[14] = {
		type = 14, --[[广播类型]]
		content = "兽神出现在军团领地了！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[15] = {
		type = 15, --[[广播类型]]
		content = "[<901,v1,v2>]被[<901,v3,v4>]禁言了1个小时！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,roleId,roleName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[16] = {
		type = 16, --[[广播类型]]
		content = "军团仓库的物品已经开始拍卖，大家快去抢呀！。", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[17] = {
		type = 17, --[[广播类型]]
		content = "神秘玩家对[<902,v1,v2>]进行了出价。", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{prid,num}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[18] = {
		type = 18, --[[广播类型]]
		content = "好运连连，<901,v1,v2>在秘境中寻获了<902,v3,v4>", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,protoId,num}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[19] = {
		type = 19, --[[广播类型]]
		content = "双倍护送美人活动即将开始，海量经验，绝代美人等你领。速来参加吧。", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[20] = {
		type = 20, --[[广播类型]]
		content = "<901,v1,v2>运气大爆发，竟然刷新到美人貂蝉，正准备护送前往<910,v3>处！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,npcName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[21] = {
		type = 21, --[[广播类型]]
		content = "逐鹿战场马上就要开始了，各位英雄可优先进入场地准备，调整最佳状态！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[22] = {
		type = 22, --[[广播类型]]
		content = "逐鹿战场已经开启了！请各位在战场里尽情驰骋，一展身手！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[23] = {
		type = 23, --[[广播类型]]
		content = "<901,v1,v2>杀死了<901,v3,v4>，获得了本次战场的第一滴血！获得奖励翻倍！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[24] = {
		type = 24, --[[广播类型]]
		content = "我方战旗正在被攻击，请各位勇士速度回援，抗击敌人！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[25] = {
		type = 25, --[[广播类型]]
		content = "<901,v1,v2>连破5人！已大开杀戒！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[26] = {
		type = 26, --[[广播类型]]
		content = "<901,v1,v2>连破10人！已杀人如麻！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[27] = {
		type = 27, --[[广播类型]]
		content = "<901,v1,v2>连破15人！已无人能敌！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[28] = {
		type = 28, --[[广播类型]]
		content = "<901,v1,v2>连破20人！已嗜杀成性！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[29] = {
		type = 29, --[[广播类型]]
		content = "<901,v1,v2>连破25人！已疯狂杀戮！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[30] = {
		type = 30, --[[广播类型]]
		content = "<901,v1,v2>连破30人！已变态杀戮！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[31] = {
		type = 31, --[[广播类型]]
		content = "<901,v1,v2>连破35人！已万夫莫敌！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[32] = {
		type = 32, --[[广播类型]]
		content = "<901,v1,v2>连破40人！已主宰战场！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[33] = {
		type = 33, --[[广播类型]]
		content = "<901,v1,v2>连破45人！已毁天灭地！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[34] = {
		type = 34, --[[广播类型]]
		content = "<901,v1,v2>连破<910，v3>人！达到超神之境！谁敢与之决一死战！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[35] = {
		type = 35, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的大开杀戒！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[36] = {
		type = 36, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的杀人如麻！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[37] = {
		type = 37, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的无人能敌！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[38] = {
		type = 38, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的嗜杀成性！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[39] = {
		type = 39, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的疯狂杀戮！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[40] = {
		type = 40, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的变态杀戮！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[41] = {
		type = 41, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的万夫莫敌！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[42] = {
		type = 42, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的主宰战场！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[43] = {
		type = 43, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的毁天灭地！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[44] = {
		type = 44, --[[广播类型]]
		content = "<901,v1,v2>终结了<901,v3,v4>的超神杀戮！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[45] = {
		type = 45, --[[广播类型]]
		content = "<901,v1,v2>完成了一次双杀！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[46] = {
		type = 46, --[[广播类型]]
		content = "<901,v1,v2>完成了一次三杀！！！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[47] = {
		type = 47, --[[广播类型]]
		content = "<901,v1,v2>完成了一次四杀！！！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[48] = {
		type = 48, --[[广播类型]]
		content = "<901,v1,v2>完成了一次<910，v3>杀！正在暴走！！！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[49] = {
		type = 49, --[[广播类型]]
		content = "<913,v1>的勇士<901,v2,v3>奋不顾身，成功拆除了敌方<913,v4>的一座守护之塔！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[50] = {
		type = 50, --[[广播类型]]
		content = "恭喜以下各位英雄获得骰子排名奖励！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[51] = {
		type = 51, --[[广播类型]]
		content = "「<901,v1,v2>」骰子<910,v3>点", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,diceNo}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[52] = {
		type = 52, --[[广播类型]]
		content = "军团领地内出现大量宝箱，请各位英雄速速领取。", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[53] = {
		type = 53, --[[广播类型]]
		content = "散财童子被宴会佳肴吸引来了，大家快去找它沾些财气吧！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[54] = {
		type = 54, --[[广播类型]]
		content = "<901,v1,v2>请大家喝酒，经验倍率提升了！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[55] = {
		type = 55, --[[广播类型]]
		content = "<901,v1,v2>创建军团：[<color=#E100F6><910,v3></color>]！正邀请天下豪杰加入！<914,v4>", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,allianceName,allianceId}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[56] = {
		type = 56, --[[广播类型]]
		content = "<901,v1,v2>进入了队伍！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[57] = {
		type = 57, --[[广播类型]]
		content = "<901,v1,v2>离开了队伍！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[58] = {
		type = 58, --[[广播类型]]
		content = "统帅：<901,v1,v2>在深思熟虑之后决定将军团名更改为：[<color=#E100F6><910,v3></color>]！<914,v4>", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,allianceName,allianceId}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[59] = {
		type = 59, --[[广播类型]]
		content = "<901,v1,v2>参透了藏宝图的惊世秘密，寻得秘宝<903,v3,v4,v5,v6>，可喜可贺！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,equipGuid,protoId,0,color}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[60] = {
		type = 60, --[[广播类型]]
		content = "<901,v1,v2>打败了守护神谕宝藏的远古魔兽，获得秘宝<903,v3,v4,v5,v6>，可喜可贺！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
		args_comment = "{roleId,roleName,equipGuid,protoId,0,color}", --[[服务端返回args这个只是用来做一个注释]]
	} ,
	[61] = {
		type = 61, --[[广播类型]]
		content = "烽火3v3战场即将开启，请各路英雄豪杰做好准备，在战场中大展身手吧！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[62] = {
		type = 62, --[[广播类型]]
		content = "烽火3v3战场已经开启了！请各位在战场里尽情驰骋，一展身手！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[63] = {
		type = 63, --[[广播类型]]
		content = "军团篝火开始了,前往军团领地挂机可得大量经验挂机奖励！喝酒、答题、抢宝箱！快来与战友共享军团福利！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[64] = {
		type = 64, --[[广播类型]]
		content = "军团宴会开始了,前往军团领地挂机可得大量经验挂机奖励！更有军团佳肴等你来尝！和军团里的伙伴们尽情饮宴吧！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[65] = {
		type = 65, --[[广播类型]]
		content = "据探子回报，魔族统领即将率领部下大举进攻临光城，大军将于5分钟后抵达。", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[66] = {
		type = 66, --[[广播类型]]
		content = "魔族统领大军兵临城下，临光城危在旦夕！请各位勇士即刻回援！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[67] = {
		type = 67, --[[广播类型]]
		content = "魔族统领于临光城现身，来势汹汹，万夫莫当！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[68] = {
		type = 68, --[[广播类型]]
		content = "众勇士合力誓死捍卫之下，终于将魔族统领血量降至<910,v1>%！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[69] = {
		type = 69, --[[广播类型]]
		content = " 临光城血量已降至<910,v1>%，危在旦夕！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[70] = {
		type = 70, --[[广播类型]]
		content = "<901,v1,v2>给魔族统领致命一击，获得了魔族统领陨落礼包！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[71] = {
		type = 71, --[[广播类型]]
		content = "临光城众英雄回援，成功击退了魔族的进攻！其中<color=#E100F6><910,v1></color>超逸绝伦居功至伟！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[72] = {
		type = 72, --[[广播类型]]
		content = "魔族统领攻入临光，主城中枢圣光爆发成功击退魔族使临光城幸免蒙难。<color=#E100F6><910,v1></color>浴血奋战受人瞩目！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[73] = {
		type = 73, --[[广播类型]]
		content = "魔族统领退兵，临光城暂时恢复了和平。魔族统领灭临光之心不死，必将卷土重来，众勇士不可懈怠！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[74] = {
		type = 74, --[[广播类型]]
		content = "烽火对决马上就要开始了，请各路英雄豪杰做好准备，在战场中大展身手吧！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[75] = {
		type = 75, --[[广播类型]]
		content = "烽火对决已经开启了！请各位在战场里尽情驰骋，一展身手！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
	[76] = {
		type = 76, --[[广播类型]]
		content = "七煞卡牌活动即将开启，丰富奖励等着你！", --[[广播内容 玩家：<t,id，名字> 道具：<t,protoId,数量> 装备：<t，guid,protoId,玩家id,品质，前缀> 武将：<t,guid,玩家id> 位置：<t,地图id，x,y> 怪物<t,名字>    PLAYER = 901, -- 玩家(玩家id)  PROP = 902, --道具(原型id)  EQUIP = 903, --装备(guid,归属玩家)  HERO = 904, --武将(guid,归属玩家)  POSITION = 905, --位置（地图id,x,y)  PLAYMSG = 906, -- 播放语音(语音id)  SPEECH_TO_TEX = 907, -- 音转字(语音id)  MONSTER = 908, --怪物(怪物名字)monster     909为坐骑    910为直接读那个数字    911为申请进入该军团  <913,v> 表示一个阵营 ]]
	} ,
}
return ret