local ret = {
	[141001] = {
		code = 141001, --[[副本id]]
		name = "仙山树冠", --[[副本名字]]
		target_desc1 = "击杀boss", --[[通关目标描述]]
		pass_tips = "躲避或击杀自爆怪，以避免大幅伤害！", --[[通关目标描述]]
		condition_type = {1}, --[[通关条件]]
		condition_param = {20701101}, --[[通关怪的id]]
		target = {1}, --[[通关目标]]
		limit_time = 300, --[[限制时间 (单位秒)]]
		refresh_script = {{15,1},{30,1},{45,1},{60,1},{75,1},{90,1},{105,1},{120,1},{135,1},{150,1},{165,1},{180,1},{195,1},{210,1},{225,1},{240,1},{255,1},{270,1},{285,1}}, --[[刷怪脚本]]
		creature_talk = {{20701001,1}}, --[[怪物喊话]]
		creature_death_tips = {}, --[[怪物死亡飘字]]
		combat_param = {{0.017,-0.32,77.5},{0.017,-0.32,77.5}}, --[[属性变化参数]]
	} ,
	[141002] = {
		code = 141002, --[[副本id]]
		name = "千山魔宫", --[[副本名字]]
		target_desc1 = "摧毁战旗", --[[通关目标描述]]
		target_desc2 = "击杀怪物", --[[通关目标描述]]
		pass_tips = "打坏旗帜可使周围怪物血量降低一半！", --[[通关目标描述]]
		condition_type = {1,1}, --[[通关条件]]
		condition_param = {20801101,20801001}, --[[通关怪的id]]
		target = {1,6}, --[[通关目标]]
		limit_time = 300, --[[限制时间 (单位秒)]]
		creature_talk = {{20801001,8}}, --[[怪物喊话]]
		creature_death_tips = {{20801101,10}}, --[[怪物死亡飘字]]
		combat_param = {{0.017,-0.32,77.5},{0.017,-0.32,77.5}}, --[[属性变化参数]]
	} ,
	[141003] = {
		code = 141003, --[[副本id]]
		name = "炼狱火山", --[[副本名字]]
		target_desc1 = "击杀火魔", --[[通关目标描述]]
		pass_tips = "击杀小怪可大大降低火魔的攻击和防御！", --[[通关目标描述]]
		condition_type = {1}, --[[通关条件]]
		condition_param = {20901101}, --[[通关怪的id]]
		target = {1}, --[[通关目标]]
		limit_time = 300, --[[限制时间 (单位秒)]]
		creature_talk = {{20901001,2},{20901002,3}}, --[[怪物喊话]]
		creature_death_tips = {{20901001,4},{20901002,5}}, --[[怪物死亡飘字]]
		combat_param = {{0.017,-0.32,77.5},{0.017,-0.32,77.5}}, --[[属性变化参数]]
	} ,
	[141004] = {
		code = 141004, --[[副本id]]
		name = "幻影沙漠", --[[副本名字]]
		target_desc1 = "击杀boss", --[[通关目标描述]]
		pass_tips = "躲开魔王范围攻击，可避免大额伤害！", --[[通关目标描述]]
		condition_type = {1}, --[[通关条件]]
		condition_param = {21001101}, --[[通关怪的id]]
		target = {1}, --[[通关目标]]
		limit_time = 300, --[[限制时间 (单位秒)]]
		creature_talk = {}, --[[怪物喊话]]
		creature_death_tips = {}, --[[怪物死亡飘字]]
		combat_param = {{0.017,-0.32,77.5},{0.017,-0.32,77.5}}, --[[属性变化参数]]
	} ,
	[141005] = {
		code = 141005, --[[副本id]]
		name = "仙丹内阁", --[[副本名字]]
		target_desc1 = "打败桃花妖", --[[通关目标描述]]
		target_desc2 = "打败肥猫怪", --[[通关目标描述]]
		pass_tips = "优先击败会给怪物回血的桃花妖！", --[[通关目标描述]]
		condition_type = {1,1}, --[[通关条件]]
		condition_param = {21101001,21101002}, --[[通关怪的id]]
		target = {4,6}, --[[通关目标]]
		limit_time = 300, --[[限制时间 (单位秒)]]
		creature_talk = {{21101001,6},{21101001,9}}, --[[怪物喊话]]
		creature_death_tips = {}, --[[怪物死亡飘字]]
		combat_param = {{0.017,-0.32,77.5},{0.017,-0.32,77.5}}, --[[属性变化参数]]
	} ,
	[141006] = {
		code = 141006, --[[副本id]]
		name = "保护玩法副本", --[[副本名字]]
		target_desc1 = "击杀怪物玄霜", --[[通关目标描述]]
		pass_tips = "保护少女不被攻击，少女重伤副本失败！", --[[通关目标描述]]
		condition_type = {1}, --[[通关条件]]
		condition_param = {21201101}, --[[通关怪的id]]
		target = {1}, --[[通关目标]]
		limit_time = 300, --[[限制时间 (单位秒)]]
		fail_param = {21201004}, --[[ 怪物死亡失败]]
		fail_target = {1}, --[[失败]]
		refresh_script = {{15,1,7},{30,2,7},{45,3,11}}, --[[刷怪脚本]]
		creature_talk = {}, --[[怪物喊话]]
		creature_death_tips = {}, --[[怪物死亡飘字]]
		combat_param = {{0.017,-0.32,77.5},{0.017,-0.32,77.5}}, --[[属性变化参数]]
		player_faction = 1, --[[玩家阵营]]
	} ,
}
return ret