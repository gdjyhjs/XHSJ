local ret = {
	[0] = {
		level = 0, --[[等级]]
		exp = 1000, --[[经验]]
		attack = 0, --[[攻击]]
		physical_defense = 0, --[[物防]]
		magic_defense = 0, --[[法防]]
		hp = 0, --[[生命]]
		dodge = 0, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[1] = {
		level = 1, --[[等级]]
		exp = 1300, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[2] = {
		level = 2, --[[等级]]
		exp = 1615, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[3] = {
		level = 3, --[[等级]]
		exp = 1945, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[4] = {
		level = 4, --[[等级]]
		exp = 2291, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[5] = {
		level = 5, --[[等级]]
		exp = 2653, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[6] = {
		level = 6, --[[等级]]
		exp = 3032, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[7] = {
		level = 7, --[[等级]]
		exp = 3428, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[8] = {
		level = 8, --[[等级]]
		exp = 3841, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[9] = {
		level = 9, --[[等级]]
		exp = 4272, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[10] = {
		level = 10, --[[等级]]
		exp = 4721, --[[经验]]
		attack = 4, --[[攻击]]
		physical_defense = 4, --[[物防]]
		magic_defense = 4, --[[法防]]
		hp = 80, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[11] = {
		level = 11, --[[等级]]
		exp = 5188, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[12] = {
		level = 12, --[[等级]]
		exp = 5674, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[13] = {
		level = 13, --[[等级]]
		exp = 6179, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[14] = {
		level = 14, --[[等级]]
		exp = 6703, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[15] = {
		level = 15, --[[等级]]
		exp = 7246, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[16] = {
		level = 16, --[[等级]]
		exp = 7809, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[17] = {
		level = 17, --[[等级]]
		exp = 8392, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[18] = {
		level = 18, --[[等级]]
		exp = 8995, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[19] = {
		level = 19, --[[等级]]
		exp = 9618, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[20] = {
		level = 20, --[[等级]]
		exp = 10261, --[[经验]]
		attack = 5, --[[攻击]]
		physical_defense = 5, --[[物防]]
		magic_defense = 5, --[[法防]]
		hp = 100, --[[生命]]
		dodge = 2, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[21] = {
		level = 21, --[[等级]]
		exp = 10924, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[22] = {
		level = 22, --[[等级]]
		exp = 11607, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[23] = {
		level = 23, --[[等级]]
		exp = 12310, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[24] = {
		level = 24, --[[等级]]
		exp = 13033, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[25] = {
		level = 25, --[[等级]]
		exp = 13776, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[26] = {
		level = 26, --[[等级]]
		exp = 14538, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[27] = {
		level = 27, --[[等级]]
		exp = 15319, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[28] = {
		level = 28, --[[等级]]
		exp = 16119, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[29] = {
		level = 29, --[[等级]]
		exp = 16937, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[30] = {
		level = 30, --[[等级]]
		exp = 17773, --[[经验]]
		attack = 6, --[[攻击]]
		physical_defense = 6, --[[物防]]
		magic_defense = 6, --[[法防]]
		hp = 120, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[31] = {
		level = 31, --[[等级]]
		exp = 18627, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[32] = {
		level = 32, --[[等级]]
		exp = 19499, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[33] = {
		level = 33, --[[等级]]
		exp = 20389, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[34] = {
		level = 34, --[[等级]]
		exp = 21297, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[35] = {
		level = 35, --[[等级]]
		exp = 22224, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[36] = {
		level = 36, --[[等级]]
		exp = 23170, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[37] = {
		level = 37, --[[等级]]
		exp = 24135, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[38] = {
		level = 38, --[[等级]]
		exp = 25120, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[39] = {
		level = 39, --[[等级]]
		exp = 26125, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[40] = {
		level = 40, --[[等级]]
		exp = 27150, --[[经验]]
		attack = 7, --[[攻击]]
		physical_defense = 7, --[[物防]]
		magic_defense = 7, --[[法防]]
		hp = 140, --[[生命]]
		dodge = 3, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[41] = {
		level = 41, --[[等级]]
		exp = 28196, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[42] = {
		level = 42, --[[等级]]
		exp = 29263, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[43] = {
		level = 43, --[[等级]]
		exp = 30351, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[44] = {
		level = 44, --[[等级]]
		exp = 31460, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[45] = {
		level = 45, --[[等级]]
		exp = 32591, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[46] = {
		level = 46, --[[等级]]
		exp = 33744, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[47] = {
		level = 47, --[[等级]]
		exp = 34919, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[48] = {
		level = 48, --[[等级]]
		exp = 36117, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[49] = {
		level = 49, --[[等级]]
		exp = 37338, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[50] = {
		level = 50, --[[等级]]
		exp = 38582, --[[经验]]
		attack = 8, --[[攻击]]
		physical_defense = 8, --[[物防]]
		magic_defense = 8, --[[法防]]
		hp = 160, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[51] = {
		level = 51, --[[等级]]
		exp = 39850, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[52] = {
		level = 52, --[[等级]]
		exp = 41142, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[53] = {
		level = 53, --[[等级]]
		exp = 42458, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[54] = {
		level = 54, --[[等级]]
		exp = 43799, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[55] = {
		level = 55, --[[等级]]
		exp = 45165, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[56] = {
		level = 56, --[[等级]]
		exp = 46556, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[57] = {
		level = 57, --[[等级]]
		exp = 47973, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[58] = {
		level = 58, --[[等级]]
		exp = 49416, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[59] = {
		level = 59, --[[等级]]
		exp = 50885, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[60] = {
		level = 60, --[[等级]]
		exp = 52381, --[[经验]]
		attack = 9, --[[攻击]]
		physical_defense = 9, --[[物防]]
		magic_defense = 9, --[[法防]]
		hp = 180, --[[生命]]
		dodge = 4, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[61] = {
		level = 61, --[[等级]]
		exp = 53904, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[62] = {
		level = 62, --[[等级]]
		exp = 55454, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[63] = {
		level = 63, --[[等级]]
		exp = 57032, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[64] = {
		level = 64, --[[等级]]
		exp = 58638, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[65] = {
		level = 65, --[[等级]]
		exp = 60272, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[66] = {
		level = 66, --[[等级]]
		exp = 61935, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[67] = {
		level = 67, --[[等级]]
		exp = 63627, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[68] = {
		level = 68, --[[等级]]
		exp = 65348, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[69] = {
		level = 69, --[[等级]]
		exp = 67099, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[70] = {
		level = 70, --[[等级]]
		exp = 68880, --[[经验]]
		attack = 10, --[[攻击]]
		physical_defense = 10, --[[物防]]
		magic_defense = 10, --[[法防]]
		hp = 200, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[71] = {
		level = 71, --[[等级]]
		exp = 70691, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[72] = {
		level = 72, --[[等级]]
		exp = 72533, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[73] = {
		level = 73, --[[等级]]
		exp = 74406, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[74] = {
		level = 74, --[[等级]]
		exp = 76310, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[75] = {
		level = 75, --[[等级]]
		exp = 78246, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[76] = {
		level = 76, --[[等级]]
		exp = 80214, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[77] = {
		level = 77, --[[等级]]
		exp = 82214, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[78] = {
		level = 78, --[[等级]]
		exp = 84247, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[79] = {
		level = 79, --[[等级]]
		exp = 86313, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[80] = {
		level = 80, --[[等级]]
		exp = 88412, --[[经验]]
		attack = 11, --[[攻击]]
		physical_defense = 11, --[[物防]]
		magic_defense = 11, --[[法防]]
		hp = 220, --[[生命]]
		dodge = 5, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[81] = {
		level = 81, --[[等级]]
		exp = 90545, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[82] = {
		level = 82, --[[等级]]
		exp = 92712, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[83] = {
		level = 83, --[[等级]]
		exp = 94913, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[84] = {
		level = 84, --[[等级]]
		exp = 97149, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[85] = {
		level = 85, --[[等级]]
		exp = 99420, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[86] = {
		level = 86, --[[等级]]
		exp = 101726, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[87] = {
		level = 87, --[[等级]]
		exp = 104068, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[88] = {
		level = 88, --[[等级]]
		exp = 106446, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[89] = {
		level = 89, --[[等级]]
		exp = 108860, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[90] = {
		level = 90, --[[等级]]
		exp = 111310, --[[经验]]
		attack = 12, --[[攻击]]
		physical_defense = 12, --[[物防]]
		magic_defense = 12, --[[法防]]
		hp = 240, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[91] = {
		level = 91, --[[等级]]
		exp = 113797, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[92] = {
		level = 92, --[[等级]]
		exp = 116321, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[93] = {
		level = 93, --[[等级]]
		exp = 118882, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[94] = {
		level = 94, --[[等级]]
		exp = 121481, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[95] = {
		level = 95, --[[等级]]
		exp = 124118, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[96] = {
		level = 96, --[[等级]]
		exp = 126793, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[97] = {
		level = 97, --[[等级]]
		exp = 129507, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[98] = {
		level = 98, --[[等级]]
		exp = 132260, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[99] = {
		level = 99, --[[等级]]
		exp = 135052, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[100] = {
		level = 100, --[[等级]]
		exp = 137883, --[[经验]]
		attack = 13, --[[攻击]]
		physical_defense = 13, --[[物防]]
		magic_defense = 13, --[[法防]]
		hp = 260, --[[生命]]
		dodge = 6, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[101] = {
		level = 101, --[[等级]]
		exp = 140754, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[102] = {
		level = 102, --[[等级]]
		exp = 143665, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[103] = {
		level = 103, --[[等级]]
		exp = 146616, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[104] = {
		level = 104, --[[等级]]
		exp = 149607, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[105] = {
		level = 105, --[[等级]]
		exp = 152639, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[106] = {
		level = 106, --[[等级]]
		exp = 155712, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[107] = {
		level = 107, --[[等级]]
		exp = 158826, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[108] = {
		level = 108, --[[等级]]
		exp = 161981, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[109] = {
		level = 109, --[[等级]]
		exp = 165178, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[110] = {
		level = 110, --[[等级]]
		exp = 168417, --[[经验]]
		attack = 14, --[[攻击]]
		physical_defense = 14, --[[物防]]
		magic_defense = 14, --[[法防]]
		hp = 280, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[111] = {
		level = 111, --[[等级]]
		exp = 171698, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[112] = {
		level = 112, --[[等级]]
		exp = 175021, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[113] = {
		level = 113, --[[等级]]
		exp = 178387, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[114] = {
		level = 114, --[[等级]]
		exp = 181796, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[115] = {
		level = 115, --[[等级]]
		exp = 185248, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[116] = {
		level = 116, --[[等级]]
		exp = 188743, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[117] = {
		level = 117, --[[等级]]
		exp = 192281, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[118] = {
		level = 118, --[[等级]]
		exp = 195863, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[119] = {
		level = 119, --[[等级]]
		exp = 199489, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[120] = {
		level = 120, --[[等级]]
		exp = 203159, --[[经验]]
		attack = 15, --[[攻击]]
		physical_defense = 15, --[[物防]]
		magic_defense = 15, --[[法防]]
		hp = 300, --[[生命]]
		dodge = 7, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[121] = {
		level = 121, --[[等级]]
		exp = 206873, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[122] = {
		level = 122, --[[等级]]
		exp = 210631, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[123] = {
		level = 123, --[[等级]]
		exp = 214433, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[124] = {
		level = 124, --[[等级]]
		exp = 218279, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[125] = {
		level = 125, --[[等级]]
		exp = 222170, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[126] = {
		level = 126, --[[等级]]
		exp = 226106, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[127] = {
		level = 127, --[[等级]]
		exp = 230087, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[128] = {
		level = 128, --[[等级]]
		exp = 234113, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[129] = {
		level = 129, --[[等级]]
		exp = 238184, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[130] = {
		level = 130, --[[等级]]
		exp = 242300, --[[经验]]
		attack = 16, --[[攻击]]
		physical_defense = 16, --[[物防]]
		magic_defense = 16, --[[法防]]
		hp = 320, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[131] = {
		level = 131, --[[等级]]
		exp = 246461, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[132] = {
		level = 132, --[[等级]]
		exp = 250667, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[133] = {
		level = 133, --[[等级]]
		exp = 254918, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[134] = {
		level = 134, --[[等级]]
		exp = 259214, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[135] = {
		level = 135, --[[等级]]
		exp = 263556, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[136] = {
		level = 136, --[[等级]]
		exp = 267944, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[137] = {
		level = 137, --[[等级]]
		exp = 272378, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[138] = {
		level = 138, --[[等级]]
		exp = 276858, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[139] = {
		level = 139, --[[等级]]
		exp = 281384, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[140] = {
		level = 140, --[[等级]]
		exp = 285956, --[[经验]]
		attack = 17, --[[攻击]]
		physical_defense = 17, --[[物防]]
		magic_defense = 17, --[[法防]]
		hp = 340, --[[生命]]
		dodge = 8, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[141] = {
		level = 141, --[[等级]]
		exp = 290574, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[142] = {
		level = 142, --[[等级]]
		exp = 295238, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[143] = {
		level = 143, --[[等级]]
		exp = 299948, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[144] = {
		level = 144, --[[等级]]
		exp = 304704, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[145] = {
		level = 145, --[[等级]]
		exp = 309506, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[146] = {
		level = 146, --[[等级]]
		exp = 314354, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[147] = {
		level = 147, --[[等级]]
		exp = 319248, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[148] = {
		level = 148, --[[等级]]
		exp = 324188, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[149] = {
		level = 149, --[[等级]]
		exp = 329173, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[150] = {
		level = 150, --[[等级]]
		exp = 334203, --[[经验]]
		attack = 18, --[[攻击]]
		physical_defense = 18, --[[物防]]
		magic_defense = 18, --[[法防]]
		hp = 360, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[151] = {
		level = 151, --[[等级]]
		exp = 339278, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[152] = {
		level = 152, --[[等级]]
		exp = 344398, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[153] = {
		level = 153, --[[等级]]
		exp = 349563, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[154] = {
		level = 154, --[[等级]]
		exp = 354773, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[155] = {
		level = 155, --[[等级]]
		exp = 360028, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[156] = {
		level = 156, --[[等级]]
		exp = 365328, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[157] = {
		level = 157, --[[等级]]
		exp = 370673, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[158] = {
		level = 158, --[[等级]]
		exp = 376062, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[159] = {
		level = 159, --[[等级]]
		exp = 381495, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[160] = {
		level = 160, --[[等级]]
		exp = 386972, --[[经验]]
		attack = 19, --[[攻击]]
		physical_defense = 19, --[[物防]]
		magic_defense = 19, --[[法防]]
		hp = 380, --[[生命]]
		dodge = 9, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[161] = {
		level = 161, --[[等级]]
		exp = 392493, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[162] = {
		level = 162, --[[等级]]
		exp = 398058, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[163] = {
		level = 163, --[[等级]]
		exp = 403666, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[164] = {
		level = 164, --[[等级]]
		exp = 409317, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[165] = {
		level = 165, --[[等级]]
		exp = 415011, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[166] = {
		level = 166, --[[等级]]
		exp = 420748, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[167] = {
		level = 167, --[[等级]]
		exp = 426527, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[168] = {
		level = 168, --[[等级]]
		exp = 432348, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[169] = {
		level = 169, --[[等级]]
		exp = 438211, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[170] = {
		level = 170, --[[等级]]
		exp = 444116, --[[经验]]
		attack = 20, --[[攻击]]
		physical_defense = 20, --[[物防]]
		magic_defense = 20, --[[法防]]
		hp = 400, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[171] = {
		level = 171, --[[等级]]
		exp = 450062, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[172] = {
		level = 172, --[[等级]]
		exp = 456049, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[173] = {
		level = 173, --[[等级]]
		exp = 462077, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[174] = {
		level = 174, --[[等级]]
		exp = 468145, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[175] = {
		level = 175, --[[等级]]
		exp = 474253, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[176] = {
		level = 176, --[[等级]]
		exp = 480401, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[177] = {
		level = 177, --[[等级]]
		exp = 486588, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[178] = {
		level = 178, --[[等级]]
		exp = 492814, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[179] = {
		level = 179, --[[等级]]
		exp = 499079, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[180] = {
		level = 180, --[[等级]]
		exp = 505382, --[[经验]]
		attack = 21, --[[攻击]]
		physical_defense = 21, --[[物防]]
		magic_defense = 21, --[[法防]]
		hp = 420, --[[生命]]
		dodge = 10, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[181] = {
		level = 181, --[[等级]]
		exp = 511723, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[182] = {
		level = 182, --[[等级]]
		exp = 518101, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[183] = {
		level = 183, --[[等级]]
		exp = 524516, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[184] = {
		level = 184, --[[等级]]
		exp = 530968, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[185] = {
		level = 185, --[[等级]]
		exp = 537456, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[186] = {
		level = 186, --[[等级]]
		exp = 543980, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[187] = {
		level = 187, --[[等级]]
		exp = 550539, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[188] = {
		level = 188, --[[等级]]
		exp = 557133, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[189] = {
		level = 189, --[[等级]]
		exp = 563761, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[190] = {
		level = 190, --[[等级]]
		exp = 570423, --[[经验]]
		attack = 22, --[[攻击]]
		physical_defense = 22, --[[物防]]
		magic_defense = 22, --[[法防]]
		hp = 440, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[191] = {
		level = 191, --[[等级]]
		exp = 577118, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[192] = {
		level = 192, --[[等级]]
		exp = 583846, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[193] = {
		level = 193, --[[等级]]
		exp = 590606, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[194] = {
		level = 194, --[[等级]]
		exp = 597398, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[195] = {
		level = 195, --[[等级]]
		exp = 604221, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[196] = {
		level = 196, --[[等级]]
		exp = 611075, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[197] = {
		level = 197, --[[等级]]
		exp = 617959, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[198] = {
		level = 198, --[[等级]]
		exp = 624873, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[199] = {
		level = 199, --[[等级]]
		exp = 631816, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[200] = {
		level = 200, --[[等级]]
		exp = 638787, --[[经验]]
		attack = 23, --[[攻击]]
		physical_defense = 23, --[[物防]]
		magic_defense = 23, --[[法防]]
		hp = 460, --[[生命]]
		dodge = 11, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[201] = {
		level = 201, --[[等级]]
		exp = 645786, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[202] = {
		level = 202, --[[等级]]
		exp = 652812, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[203] = {
		level = 203, --[[等级]]
		exp = 659865, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[204] = {
		level = 204, --[[等级]]
		exp = 666944, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[205] = {
		level = 205, --[[等级]]
		exp = 674048, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[206] = {
		level = 206, --[[等级]]
		exp = 681177, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[207] = {
		level = 207, --[[等级]]
		exp = 688331, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[208] = {
		level = 208, --[[等级]]
		exp = 695510, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[209] = {
		level = 209, --[[等级]]
		exp = 702714, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[210] = {
		level = 210, --[[等级]]
		exp = 709943, --[[经验]]
		attack = 24, --[[攻击]]
		physical_defense = 24, --[[物防]]
		magic_defense = 24, --[[法防]]
		hp = 480, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[211] = {
		level = 211, --[[等级]]
		exp = 717197, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[212] = {
		level = 212, --[[等级]]
		exp = 724476, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[213] = {
		level = 213, --[[等级]]
		exp = 731780, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[214] = {
		level = 214, --[[等级]]
		exp = 739110, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[215] = {
		level = 215, --[[等级]]
		exp = 746466, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[216] = {
		level = 216, --[[等级]]
		exp = 753848, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[217] = {
		level = 217, --[[等级]]
		exp = 761256, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[218] = {
		level = 218, --[[等级]]
		exp = 768690, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[219] = {
		level = 219, --[[等级]]
		exp = 776150, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[220] = {
		level = 220, --[[等级]]
		exp = 783636, --[[经验]]
		attack = 25, --[[攻击]]
		physical_defense = 25, --[[物防]]
		magic_defense = 25, --[[法防]]
		hp = 500, --[[生命]]
		dodge = 12, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[221] = {
		level = 221, --[[等级]]
		exp = 791148, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[222] = {
		level = 222, --[[等级]]
		exp = 798686, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[223] = {
		level = 223, --[[等级]]
		exp = 806250, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[224] = {
		level = 224, --[[等级]]
		exp = 813840, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[225] = {
		level = 225, --[[等级]]
		exp = 821457, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[226] = {
		level = 226, --[[等级]]
		exp = 829101, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[227] = {
		level = 227, --[[等级]]
		exp = 836772, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[228] = {
		level = 228, --[[等级]]
		exp = 844470, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[229] = {
		level = 229, --[[等级]]
		exp = 852195, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[230] = {
		level = 230, --[[等级]]
		exp = 859947, --[[经验]]
		attack = 26, --[[攻击]]
		physical_defense = 26, --[[物防]]
		magic_defense = 26, --[[法防]]
		hp = 520, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[231] = {
		level = 231, --[[等级]]
		exp = 867726, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[232] = {
		level = 232, --[[等级]]
		exp = 875532, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[233] = {
		level = 233, --[[等级]]
		exp = 883365, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[234] = {
		level = 234, --[[等级]]
		exp = 891225, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[235] = {
		level = 235, --[[等级]]
		exp = 899113, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[236] = {
		level = 236, --[[等级]]
		exp = 907029, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[237] = {
		level = 237, --[[等级]]
		exp = 914973, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[238] = {
		level = 238, --[[等级]]
		exp = 922945, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[239] = {
		level = 239, --[[等级]]
		exp = 930945, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[240] = {
		level = 240, --[[等级]]
		exp = 938973, --[[经验]]
		attack = 27, --[[攻击]]
		physical_defense = 27, --[[物防]]
		magic_defense = 27, --[[法防]]
		hp = 540, --[[生命]]
		dodge = 13, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[241] = {
		level = 241, --[[等级]]
		exp = 947029, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[242] = {
		level = 242, --[[等级]]
		exp = 955113, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[243] = {
		level = 243, --[[等级]]
		exp = 963225, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[244] = {
		level = 244, --[[等级]]
		exp = 971365, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[245] = {
		level = 245, --[[等级]]
		exp = 979533, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[246] = {
		level = 246, --[[等级]]
		exp = 987730, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[247] = {
		level = 247, --[[等级]]
		exp = 995956, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[248] = {
		level = 248, --[[等级]]
		exp = 1004211, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[249] = {
		level = 249, --[[等级]]
		exp = 1012495, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[250] = {
		level = 250, --[[等级]]
		exp = 1020808, --[[经验]]
		attack = 28, --[[攻击]]
		physical_defense = 28, --[[物防]]
		magic_defense = 28, --[[法防]]
		hp = 560, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[251] = {
		level = 251, --[[等级]]
		exp = 1029150, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[252] = {
		level = 252, --[[等级]]
		exp = 1037521, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[253] = {
		level = 253, --[[等级]]
		exp = 1045921, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[254] = {
		level = 254, --[[等级]]
		exp = 1054350, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[255] = {
		level = 255, --[[等级]]
		exp = 1062809, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[256] = {
		level = 256, --[[等级]]
		exp = 1071298, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[257] = {
		level = 257, --[[等级]]
		exp = 1079817, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[258] = {
		level = 258, --[[等级]]
		exp = 1088366, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[259] = {
		level = 259, --[[等级]]
		exp = 1096945, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[260] = {
		level = 260, --[[等级]]
		exp = 1105554, --[[经验]]
		attack = 29, --[[攻击]]
		physical_defense = 29, --[[物防]]
		magic_defense = 29, --[[法防]]
		hp = 580, --[[生命]]
		dodge = 14, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[261] = {
		level = 261, --[[等级]]
		exp = 1114193, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[262] = {
		level = 262, --[[等级]]
		exp = 1122862, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[263] = {
		level = 263, --[[等级]]
		exp = 1131561, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[264] = {
		level = 264, --[[等级]]
		exp = 1140290, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[265] = {
		level = 265, --[[等级]]
		exp = 1149050, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[266] = {
		level = 266, --[[等级]]
		exp = 1157841, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[267] = {
		level = 267, --[[等级]]
		exp = 1166663, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[268] = {
		level = 268, --[[等级]]
		exp = 1175516, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[269] = {
		level = 269, --[[等级]]
		exp = 1184400, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[270] = {
		level = 270, --[[等级]]
		exp = 1193315, --[[经验]]
		attack = 30, --[[攻击]]
		physical_defense = 30, --[[物防]]
		magic_defense = 30, --[[法防]]
		hp = 600, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[271] = {
		level = 271, --[[等级]]
		exp = 1202261, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[272] = {
		level = 272, --[[等级]]
		exp = 1211238, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[273] = {
		level = 273, --[[等级]]
		exp = 1220246, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[274] = {
		level = 274, --[[等级]]
		exp = 1229286, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[275] = {
		level = 275, --[[等级]]
		exp = 1238358, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[276] = {
		level = 276, --[[等级]]
		exp = 1247462, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[277] = {
		level = 277, --[[等级]]
		exp = 1256598, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[278] = {
		level = 278, --[[等级]]
		exp = 1265766, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[279] = {
		level = 279, --[[等级]]
		exp = 1274966, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[280] = {
		level = 280, --[[等级]]
		exp = 1284198, --[[经验]]
		attack = 31, --[[攻击]]
		physical_defense = 31, --[[物防]]
		magic_defense = 31, --[[法防]]
		hp = 620, --[[生命]]
		dodge = 15, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[281] = {
		level = 281, --[[等级]]
		exp = 1293462, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[282] = {
		level = 282, --[[等级]]
		exp = 1302758, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[283] = {
		level = 283, --[[等级]]
		exp = 1312087, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[284] = {
		level = 284, --[[等级]]
		exp = 1321449, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[285] = {
		level = 285, --[[等级]]
		exp = 1330844, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[286] = {
		level = 286, --[[等级]]
		exp = 1340272, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[287] = {
		level = 287, --[[等级]]
		exp = 1349733, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[288] = {
		level = 288, --[[等级]]
		exp = 1359227, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[289] = {
		level = 289, --[[等级]]
		exp = 1368754, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[290] = {
		level = 290, --[[等级]]
		exp = 1378314, --[[经验]]
		attack = 32, --[[攻击]]
		physical_defense = 32, --[[物防]]
		magic_defense = 32, --[[法防]]
		hp = 640, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[291] = {
		level = 291, --[[等级]]
		exp = 1387907, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[292] = {
		level = 292, --[[等级]]
		exp = 1397534, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[293] = {
		level = 293, --[[等级]]
		exp = 1407195, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[294] = {
		level = 294, --[[等级]]
		exp = 1416890, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[295] = {
		level = 295, --[[等级]]
		exp = 1426619, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[296] = {
		level = 296, --[[等级]]
		exp = 1436382, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[297] = {
		level = 297, --[[等级]]
		exp = 1446179, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[298] = {
		level = 298, --[[等级]]
		exp = 1456010, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[299] = {
		level = 299, --[[等级]]
		exp = 1465875, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[300] = {
		level = 300, --[[等级]]
		exp = 1475775, --[[经验]]
		attack = 33, --[[攻击]]
		physical_defense = 33, --[[物防]]
		magic_defense = 33, --[[法防]]
		hp = 660, --[[生命]]
		dodge = 16, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[301] = {
		level = 301, --[[等级]]
		exp = 1485710, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[302] = {
		level = 302, --[[等级]]
		exp = 1495680, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[303] = {
		level = 303, --[[等级]]
		exp = 1505685, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[304] = {
		level = 304, --[[等级]]
		exp = 1515725, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[305] = {
		level = 305, --[[等级]]
		exp = 1525800, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[306] = {
		level = 306, --[[等级]]
		exp = 1535910, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[307] = {
		level = 307, --[[等级]]
		exp = 1546055, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[308] = {
		level = 308, --[[等级]]
		exp = 1556236, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[309] = {
		level = 309, --[[等级]]
		exp = 1566453, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[310] = {
		level = 310, --[[等级]]
		exp = 1576706, --[[经验]]
		attack = 34, --[[攻击]]
		physical_defense = 34, --[[物防]]
		magic_defense = 34, --[[法防]]
		hp = 680, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[311] = {
		level = 311, --[[等级]]
		exp = 1586995, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[312] = {
		level = 312, --[[等级]]
		exp = 1597320, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[313] = {
		level = 313, --[[等级]]
		exp = 1607681, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[314] = {
		level = 314, --[[等级]]
		exp = 1618078, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[315] = {
		level = 315, --[[等级]]
		exp = 1628511, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[316] = {
		level = 316, --[[等级]]
		exp = 1638981, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[317] = {
		level = 317, --[[等级]]
		exp = 1649488, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[318] = {
		level = 318, --[[等级]]
		exp = 1660032, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[319] = {
		level = 319, --[[等级]]
		exp = 1670613, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[320] = {
		level = 320, --[[等级]]
		exp = 1681231, --[[经验]]
		attack = 35, --[[攻击]]
		physical_defense = 35, --[[物防]]
		magic_defense = 35, --[[法防]]
		hp = 700, --[[生命]]
		dodge = 17, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[321] = {
		level = 321, --[[等级]]
		exp = 1691886, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[322] = {
		level = 322, --[[等级]]
		exp = 1702578, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[323] = {
		level = 323, --[[等级]]
		exp = 1713307, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[324] = {
		level = 324, --[[等级]]
		exp = 1724074, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[325] = {
		level = 325, --[[等级]]
		exp = 1734879, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[326] = {
		level = 326, --[[等级]]
		exp = 1745722, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[327] = {
		level = 327, --[[等级]]
		exp = 1756603, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[328] = {
		level = 328, --[[等级]]
		exp = 1767522, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[329] = {
		level = 329, --[[等级]]
		exp = 1778479, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[330] = {
		level = 330, --[[等级]]
		exp = 1789474, --[[经验]]
		attack = 36, --[[攻击]]
		physical_defense = 36, --[[物防]]
		magic_defense = 36, --[[法防]]
		hp = 720, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[331] = {
		level = 331, --[[等级]]
		exp = 1800507, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[332] = {
		level = 332, --[[等级]]
		exp = 1811579, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[333] = {
		level = 333, --[[等级]]
		exp = 1822690, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[334] = {
		level = 334, --[[等级]]
		exp = 1833840, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[335] = {
		level = 335, --[[等级]]
		exp = 1845029, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[336] = {
		level = 336, --[[等级]]
		exp = 1856257, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[337] = {
		level = 337, --[[等级]]
		exp = 1867524, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[338] = {
		level = 338, --[[等级]]
		exp = 1878830, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[339] = {
		level = 339, --[[等级]]
		exp = 1890176, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[340] = {
		level = 340, --[[等级]]
		exp = 1901562, --[[经验]]
		attack = 37, --[[攻击]]
		physical_defense = 37, --[[物防]]
		magic_defense = 37, --[[法防]]
		hp = 740, --[[生命]]
		dodge = 18, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[341] = {
		level = 341, --[[等级]]
		exp = 1912988, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[342] = {
		level = 342, --[[等级]]
		exp = 1924454, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[343] = {
		level = 343, --[[等级]]
		exp = 1935960, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[344] = {
		level = 344, --[[等级]]
		exp = 1947506, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[345] = {
		level = 345, --[[等级]]
		exp = 1959092, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[346] = {
		level = 346, --[[等级]]
		exp = 1970719, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[347] = {
		level = 347, --[[等级]]
		exp = 1982387, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[348] = {
		level = 348, --[[等级]]
		exp = 1994096, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[349] = {
		level = 349, --[[等级]]
		exp = 2005846, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[350] = {
		level = 350, --[[等级]]
		exp = 2017637, --[[经验]]
		attack = 38, --[[攻击]]
		physical_defense = 38, --[[物防]]
		magic_defense = 38, --[[法防]]
		hp = 760, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[351] = {
		level = 351, --[[等级]]
		exp = 2029469, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[352] = {
		level = 352, --[[等级]]
		exp = 2041342, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[353] = {
		level = 353, --[[等级]]
		exp = 2053257, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[354] = {
		level = 354, --[[等级]]
		exp = 2065214, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[355] = {
		level = 355, --[[等级]]
		exp = 2077213, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[356] = {
		level = 356, --[[等级]]
		exp = 2089254, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[357] = {
		level = 357, --[[等级]]
		exp = 2101337, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[358] = {
		level = 358, --[[等级]]
		exp = 2113462, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[359] = {
		level = 359, --[[等级]]
		exp = 2125629, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[360] = {
		level = 360, --[[等级]]
		exp = 2137839, --[[经验]]
		attack = 39, --[[攻击]]
		physical_defense = 39, --[[物防]]
		magic_defense = 39, --[[法防]]
		hp = 780, --[[生命]]
		dodge = 19, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[361] = {
		level = 361, --[[等级]]
		exp = 2150092, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[362] = {
		level = 362, --[[等级]]
		exp = 2162388, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[363] = {
		level = 363, --[[等级]]
		exp = 2174727, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[364] = {
		level = 364, --[[等级]]
		exp = 2187109, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[365] = {
		level = 365, --[[等级]]
		exp = 2199534, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[366] = {
		level = 366, --[[等级]]
		exp = 2212002, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[367] = {
		level = 367, --[[等级]]
		exp = 2224514, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[368] = {
		level = 368, --[[等级]]
		exp = 2237070, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[369] = {
		level = 369, --[[等级]]
		exp = 2249670, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[370] = {
		level = 370, --[[等级]]
		exp = 2262314, --[[经验]]
		attack = 40, --[[攻击]]
		physical_defense = 40, --[[物防]]
		magic_defense = 40, --[[法防]]
		hp = 800, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[371] = {
		level = 371, --[[等级]]
		exp = 2275002, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[372] = {
		level = 372, --[[等级]]
		exp = 2287734, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[373] = {
		level = 373, --[[等级]]
		exp = 2300511, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[374] = {
		level = 374, --[[等级]]
		exp = 2313333, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[375] = {
		level = 375, --[[等级]]
		exp = 2326200, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[376] = {
		level = 376, --[[等级]]
		exp = 2339112, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[377] = {
		level = 377, --[[等级]]
		exp = 2352069, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[378] = {
		level = 378, --[[等级]]
		exp = 2365071, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[379] = {
		level = 379, --[[等级]]
		exp = 2378119, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[380] = {
		level = 380, --[[等级]]
		exp = 2391213, --[[经验]]
		attack = 41, --[[攻击]]
		physical_defense = 41, --[[物防]]
		magic_defense = 41, --[[法防]]
		hp = 820, --[[生命]]
		dodge = 20, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[381] = {
		level = 381, --[[等级]]
		exp = 2404353, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[382] = {
		level = 382, --[[等级]]
		exp = 2417539, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[383] = {
		level = 383, --[[等级]]
		exp = 2430771, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[384] = {
		level = 384, --[[等级]]
		exp = 2444049, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[385] = {
		level = 385, --[[等级]]
		exp = 2457373, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[386] = {
		level = 386, --[[等级]]
		exp = 2470744, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[387] = {
		level = 387, --[[等级]]
		exp = 2484162, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[388] = {
		level = 388, --[[等级]]
		exp = 2497627, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[389] = {
		level = 389, --[[等级]]
		exp = 2511139, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[390] = {
		level = 390, --[[等级]]
		exp = 2524698, --[[经验]]
		attack = 42, --[[攻击]]
		physical_defense = 42, --[[物防]]
		magic_defense = 42, --[[法防]]
		hp = 840, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[391] = {
		level = 391, --[[等级]]
		exp = 2538304, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[392] = {
		level = 392, --[[等级]]
		exp = 2551958, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[393] = {
		level = 393, --[[等级]]
		exp = 2565660, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[394] = {
		level = 394, --[[等级]]
		exp = 2579410, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[395] = {
		level = 395, --[[等级]]
		exp = 2593208, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[396] = {
		level = 396, --[[等级]]
		exp = 2607054, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[397] = {
		level = 397, --[[等级]]
		exp = 2620948, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[398] = {
		level = 398, --[[等级]]
		exp = 2634891, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[399] = {
		level = 399, --[[等级]]
		exp = 2648883, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[400] = {
		level = 400, --[[等级]]
		exp = 2662924, --[[经验]]
		attack = 43, --[[攻击]]
		physical_defense = 43, --[[物防]]
		magic_defense = 43, --[[法防]]
		hp = 860, --[[生命]]
		dodge = 21, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[401] = {
		level = 401, --[[等级]]
		exp = 2677014, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[402] = {
		level = 402, --[[等级]]
		exp = 2691153, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[403] = {
		level = 403, --[[等级]]
		exp = 2705341, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[404] = {
		level = 404, --[[等级]]
		exp = 2719579, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[405] = {
		level = 405, --[[等级]]
		exp = 2733867, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[406] = {
		level = 406, --[[等级]]
		exp = 2748205, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[407] = {
		level = 407, --[[等级]]
		exp = 2762593, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[408] = {
		level = 408, --[[等级]]
		exp = 2777031, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[409] = {
		level = 409, --[[等级]]
		exp = 2791520, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[410] = {
		level = 410, --[[等级]]
		exp = 2806060, --[[经验]]
		attack = 44, --[[攻击]]
		physical_defense = 44, --[[物防]]
		magic_defense = 44, --[[法防]]
		hp = 880, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[411] = {
		level = 411, --[[等级]]
		exp = 2820651, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[412] = {
		level = 412, --[[等级]]
		exp = 2835293, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[413] = {
		level = 413, --[[等级]]
		exp = 2849986, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[414] = {
		level = 414, --[[等级]]
		exp = 2864730, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[415] = {
		level = 415, --[[等级]]
		exp = 2879526, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[416] = {
		level = 416, --[[等级]]
		exp = 2894374, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[417] = {
		level = 417, --[[等级]]
		exp = 2909274, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[418] = {
		level = 418, --[[等级]]
		exp = 2924226, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[419] = {
		level = 419, --[[等级]]
		exp = 2939230, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[420] = {
		level = 420, --[[等级]]
		exp = 2954287, --[[经验]]
		attack = 45, --[[攻击]]
		physical_defense = 45, --[[物防]]
		magic_defense = 45, --[[法防]]
		hp = 900, --[[生命]]
		dodge = 22, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[421] = {
		level = 421, --[[等级]]
		exp = 2969397, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[422] = {
		level = 422, --[[等级]]
		exp = 2984560, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[423] = {
		level = 423, --[[等级]]
		exp = 2999776, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[424] = {
		level = 424, --[[等级]]
		exp = 3015045, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[425] = {
		level = 425, --[[等级]]
		exp = 3030367, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[426] = {
		level = 426, --[[等级]]
		exp = 3045743, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[427] = {
		level = 427, --[[等级]]
		exp = 3061173, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[428] = {
		level = 428, --[[等级]]
		exp = 3076657, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[429] = {
		level = 429, --[[等级]]
		exp = 3092195, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[430] = {
		level = 430, --[[等级]]
		exp = 3107787, --[[经验]]
		attack = 46, --[[攻击]]
		physical_defense = 46, --[[物防]]
		magic_defense = 46, --[[法防]]
		hp = 920, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[431] = {
		level = 431, --[[等级]]
		exp = 3123434, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[432] = {
		level = 432, --[[等级]]
		exp = 3139136, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[433] = {
		level = 433, --[[等级]]
		exp = 3154893, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[434] = {
		level = 434, --[[等级]]
		exp = 3170705, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[435] = {
		level = 435, --[[等级]]
		exp = 3186572, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[436] = {
		level = 436, --[[等级]]
		exp = 3202495, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[437] = {
		level = 437, --[[等级]]
		exp = 3218474, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[438] = {
		level = 438, --[[等级]]
		exp = 3234509, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[439] = {
		level = 439, --[[等级]]
		exp = 3250600, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[440] = {
		level = 440, --[[等级]]
		exp = 3266747, --[[经验]]
		attack = 47, --[[攻击]]
		physical_defense = 47, --[[物防]]
		magic_defense = 47, --[[法防]]
		hp = 940, --[[生命]]
		dodge = 23, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[441] = {
		level = 441, --[[等级]]
		exp = 3282951, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[442] = {
		level = 442, --[[等级]]
		exp = 3299212, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[443] = {
		level = 443, --[[等级]]
		exp = 3315530, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[444] = {
		level = 444, --[[等级]]
		exp = 3331905, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[445] = {
		level = 445, --[[等级]]
		exp = 3348337, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[446] = {
		level = 446, --[[等级]]
		exp = 3364827, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[447] = {
		level = 447, --[[等级]]
		exp = 3381375, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[448] = {
		level = 448, --[[等级]]
		exp = 3397981, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[449] = {
		level = 449, --[[等级]]
		exp = 3414645, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[450] = {
		level = 450, --[[等级]]
		exp = 3431367, --[[经验]]
		attack = 48, --[[攻击]]
		physical_defense = 48, --[[物防]]
		magic_defense = 48, --[[法防]]
		hp = 960, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[451] = {
		level = 451, --[[等级]]
		exp = 3448148, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[452] = {
		level = 452, --[[等级]]
		exp = 3464988, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[453] = {
		level = 453, --[[等级]]
		exp = 3481887, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[454] = {
		level = 454, --[[等级]]
		exp = 3498845, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[455] = {
		level = 455, --[[等级]]
		exp = 3515862, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[456] = {
		level = 456, --[[等级]]
		exp = 3532939, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[457] = {
		level = 457, --[[等级]]
		exp = 3550076, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[458] = {
		level = 458, --[[等级]]
		exp = 3567273, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[459] = {
		level = 459, --[[等级]]
		exp = 3584530, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[460] = {
		level = 460, --[[等级]]
		exp = 3601847, --[[经验]]
		attack = 49, --[[攻击]]
		physical_defense = 49, --[[物防]]
		magic_defense = 49, --[[法防]]
		hp = 980, --[[生命]]
		dodge = 24, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[461] = {
		level = 461, --[[等级]]
		exp = 3619225, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[462] = {
		level = 462, --[[等级]]
		exp = 3636664, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[463] = {
		level = 463, --[[等级]]
		exp = 3654164, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[464] = {
		level = 464, --[[等级]]
		exp = 3671725, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[465] = {
		level = 465, --[[等级]]
		exp = 3689347, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[466] = {
		level = 466, --[[等级]]
		exp = 3707031, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[467] = {
		level = 467, --[[等级]]
		exp = 3724777, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[468] = {
		level = 468, --[[等级]]
		exp = 3742585, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[469] = {
		level = 469, --[[等级]]
		exp = 3760455, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[470] = {
		level = 470, --[[等级]]
		exp = 3778388, --[[经验]]
		attack = 50, --[[攻击]]
		physical_defense = 50, --[[物防]]
		magic_defense = 50, --[[法防]]
		hp = 1000, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[471] = {
		level = 471, --[[等级]]
		exp = 3796384, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[472] = {
		level = 472, --[[等级]]
		exp = 3814443, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[473] = {
		level = 473, --[[等级]]
		exp = 3832565, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[474] = {
		level = 474, --[[等级]]
		exp = 3850750, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[475] = {
		level = 475, --[[等级]]
		exp = 3868999, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[476] = {
		level = 476, --[[等级]]
		exp = 3887312, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[477] = {
		level = 477, --[[等级]]
		exp = 3905689, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[478] = {
		level = 478, --[[等级]]
		exp = 3924130, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[479] = {
		level = 479, --[[等级]]
		exp = 3942636, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[480] = {
		level = 480, --[[等级]]
		exp = 3961207, --[[经验]]
		attack = 51, --[[攻击]]
		physical_defense = 51, --[[物防]]
		magic_defense = 51, --[[法防]]
		hp = 1020, --[[生命]]
		dodge = 25, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[481] = {
		level = 481, --[[等级]]
		exp = 3979843, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[482] = {
		level = 482, --[[等级]]
		exp = 3998544, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[483] = {
		level = 483, --[[等级]]
		exp = 4017310, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[484] = {
		level = 484, --[[等级]]
		exp = 4036142, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[485] = {
		level = 485, --[[等级]]
		exp = 4055040, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[486] = {
		level = 486, --[[等级]]
		exp = 4074004, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[487] = {
		level = 487, --[[等级]]
		exp = 4093034, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[488] = {
		level = 488, --[[等级]]
		exp = 4112131, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[489] = {
		level = 489, --[[等级]]
		exp = 4131295, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[490] = {
		level = 490, --[[等级]]
		exp = 4150526, --[[经验]]
		attack = 52, --[[攻击]]
		physical_defense = 52, --[[物防]]
		magic_defense = 52, --[[法防]]
		hp = 1040, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[491] = {
		level = 491, --[[等级]]
		exp = 4169824, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[492] = {
		level = 492, --[[等级]]
		exp = 4189190, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[493] = {
		level = 493, --[[等级]]
		exp = 4208624, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[494] = {
		level = 494, --[[等级]]
		exp = 4228126, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[495] = {
		level = 495, --[[等级]]
		exp = 4247696, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[496] = {
		level = 496, --[[等级]]
		exp = 4267334, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[497] = {
		level = 497, --[[等级]]
		exp = 4287041, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[498] = {
		level = 498, --[[等级]]
		exp = 4306817, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[499] = {
		level = 499, --[[等级]]
		exp = 4326662, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[500] = {
		level = 500, --[[等级]]
		exp = 4346576, --[[经验]]
		attack = 53, --[[攻击]]
		physical_defense = 53, --[[物防]]
		magic_defense = 53, --[[法防]]
		hp = 1060, --[[生命]]
		dodge = 26, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[501] = {
		level = 501, --[[等级]]
		exp = 4366560, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[502] = {
		level = 502, --[[等级]]
		exp = 4386614, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[503] = {
		level = 503, --[[等级]]
		exp = 4406738, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[504] = {
		level = 504, --[[等级]]
		exp = 4426932, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[505] = {
		level = 505, --[[等级]]
		exp = 4447197, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[506] = {
		level = 506, --[[等级]]
		exp = 4467533, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[507] = {
		level = 507, --[[等级]]
		exp = 4487940, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[508] = {
		level = 508, --[[等级]]
		exp = 4508418, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[509] = {
		level = 509, --[[等级]]
		exp = 4528968, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[510] = {
		level = 510, --[[等级]]
		exp = 4549590, --[[经验]]
		attack = 54, --[[攻击]]
		physical_defense = 54, --[[物防]]
		magic_defense = 54, --[[法防]]
		hp = 1080, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[511] = {
		level = 511, --[[等级]]
		exp = 4570284, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[512] = {
		level = 512, --[[等级]]
		exp = 4591050, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[513] = {
		level = 513, --[[等级]]
		exp = 4611889, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[514] = {
		level = 514, --[[等级]]
		exp = 4632801, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[515] = {
		level = 515, --[[等级]]
		exp = 4653786, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[516] = {
		level = 516, --[[等级]]
		exp = 4674844, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[517] = {
		level = 517, --[[等级]]
		exp = 4695976, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[518] = {
		level = 518, --[[等级]]
		exp = 4717182, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[519] = {
		level = 519, --[[等级]]
		exp = 4738462, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[520] = {
		level = 520, --[[等级]]
		exp = 4759816, --[[经验]]
		attack = 55, --[[攻击]]
		physical_defense = 55, --[[物防]]
		magic_defense = 55, --[[法防]]
		hp = 1100, --[[生命]]
		dodge = 27, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[521] = {
		level = 521, --[[等级]]
		exp = 4781245, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[522] = {
		level = 522, --[[等级]]
		exp = 4802749, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[523] = {
		level = 523, --[[等级]]
		exp = 4824328, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[524] = {
		level = 524, --[[等级]]
		exp = 4845983, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[525] = {
		level = 525, --[[等级]]
		exp = 4867714, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[526] = {
		level = 526, --[[等级]]
		exp = 4889521, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[527] = {
		level = 527, --[[等级]]
		exp = 4911404, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[528] = {
		level = 528, --[[等级]]
		exp = 4933364, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[529] = {
		level = 529, --[[等级]]
		exp = 4955401, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[530] = {
		level = 530, --[[等级]]
		exp = 4977515, --[[经验]]
		attack = 56, --[[攻击]]
		physical_defense = 56, --[[物防]]
		magic_defense = 56, --[[法防]]
		hp = 1120, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[531] = {
		level = 531, --[[等级]]
		exp = 4999706, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[532] = {
		level = 532, --[[等级]]
		exp = 5021975, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[533] = {
		level = 533, --[[等级]]
		exp = 5044322, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[534] = {
		level = 534, --[[等级]]
		exp = 5066747, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[535] = {
		level = 535, --[[等级]]
		exp = 5089250, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[536] = {
		level = 536, --[[等级]]
		exp = 5111832, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[537] = {
		level = 537, --[[等级]]
		exp = 5134493, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[538] = {
		level = 538, --[[等级]]
		exp = 5157233, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[539] = {
		level = 539, --[[等级]]
		exp = 5180053, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[540] = {
		level = 540, --[[等级]]
		exp = 5202953, --[[经验]]
		attack = 57, --[[攻击]]
		physical_defense = 57, --[[物防]]
		magic_defense = 57, --[[法防]]
		hp = 1140, --[[生命]]
		dodge = 28, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[541] = {
		level = 541, --[[等级]]
		exp = 5225933, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[542] = {
		level = 542, --[[等级]]
		exp = 5248993, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[543] = {
		level = 543, --[[等级]]
		exp = 5272134, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[544] = {
		level = 544, --[[等级]]
		exp = 5295356, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[545] = {
		level = 545, --[[等级]]
		exp = 5318659, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[546] = {
		level = 546, --[[等级]]
		exp = 5342044, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[547] = {
		level = 547, --[[等级]]
		exp = 5365511, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[548] = {
		level = 548, --[[等级]]
		exp = 5389060, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[549] = {
		level = 549, --[[等级]]
		exp = 5412691, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[550] = {
		level = 550, --[[等级]]
		exp = 5436405, --[[经验]]
		attack = 58, --[[攻击]]
		physical_defense = 58, --[[物防]]
		magic_defense = 58, --[[法防]]
		hp = 1160, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[551] = {
		level = 551, --[[等级]]
		exp = 5460202, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[552] = {
		level = 552, --[[等级]]
		exp = 5484082, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[553] = {
		level = 553, --[[等级]]
		exp = 5508046, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[554] = {
		level = 554, --[[等级]]
		exp = 5532094, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[555] = {
		level = 555, --[[等级]]
		exp = 5556226, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[556] = {
		level = 556, --[[等级]]
		exp = 5580442, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[557] = {
		level = 557, --[[等级]]
		exp = 5604743, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[558] = {
		level = 558, --[[等级]]
		exp = 5629129, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[559] = {
		level = 559, --[[等级]]
		exp = 5653600, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[560] = {
		level = 560, --[[等级]]
		exp = 5678157, --[[经验]]
		attack = 59, --[[攻击]]
		physical_defense = 59, --[[物防]]
		magic_defense = 59, --[[法防]]
		hp = 1180, --[[生命]]
		dodge = 29, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[561] = {
		level = 561, --[[等级]]
		exp = 5702800, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[562] = {
		level = 562, --[[等级]]
		exp = 5727529, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[563] = {
		level = 563, --[[等级]]
		exp = 5752345, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[564] = {
		level = 564, --[[等级]]
		exp = 5777248, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[565] = {
		level = 565, --[[等级]]
		exp = 5802238, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[566] = {
		level = 566, --[[等级]]
		exp = 5827315, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[567] = {
		level = 567, --[[等级]]
		exp = 5852480, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[568] = {
		level = 568, --[[等级]]
		exp = 5877733, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[569] = {
		level = 569, --[[等级]]
		exp = 5903074, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[570] = {
		level = 570, --[[等级]]
		exp = 5928504, --[[经验]]
		attack = 60, --[[攻击]]
		physical_defense = 60, --[[物防]]
		magic_defense = 60, --[[法防]]
		hp = 1200, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[571] = {
		level = 571, --[[等级]]
		exp = 5954023, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[572] = {
		level = 572, --[[等级]]
		exp = 5979631, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[573] = {
		level = 573, --[[等级]]
		exp = 6005329, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[574] = {
		level = 574, --[[等级]]
		exp = 6031117, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[575] = {
		level = 575, --[[等级]]
		exp = 6056995, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[576] = {
		level = 576, --[[等级]]
		exp = 6082964, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[577] = {
		level = 577, --[[等级]]
		exp = 6109024, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[578] = {
		level = 578, --[[等级]]
		exp = 6135175, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[579] = {
		level = 579, --[[等级]]
		exp = 6161418, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[580] = {
		level = 580, --[[等级]]
		exp = 6187753, --[[经验]]
		attack = 61, --[[攻击]]
		physical_defense = 61, --[[物防]]
		magic_defense = 61, --[[法防]]
		hp = 1220, --[[生命]]
		dodge = 30, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[581] = {
		level = 581, --[[等级]]
		exp = 6214180, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[582] = {
		level = 582, --[[等级]]
		exp = 6240699, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[583] = {
		level = 583, --[[等级]]
		exp = 6267311, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[584] = {
		level = 584, --[[等级]]
		exp = 6294016, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[585] = {
		level = 585, --[[等级]]
		exp = 6320814, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[586] = {
		level = 586, --[[等级]]
		exp = 6347706, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[587] = {
		level = 587, --[[等级]]
		exp = 6374692, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[588] = {
		level = 588, --[[等级]]
		exp = 6401772, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[589] = {
		level = 589, --[[等级]]
		exp = 6428947, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[590] = {
		level = 590, --[[等级]]
		exp = 6456217, --[[经验]]
		attack = 62, --[[攻击]]
		physical_defense = 62, --[[物防]]
		magic_defense = 62, --[[法防]]
		hp = 1240, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[591] = {
		level = 591, --[[等级]]
		exp = 6483582, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[592] = {
		level = 592, --[[等级]]
		exp = 6511043, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[593] = {
		level = 593, --[[等级]]
		exp = 6538600, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[594] = {
		level = 594, --[[等级]]
		exp = 6566253, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[595] = {
		level = 595, --[[等级]]
		exp = 6594003, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[596] = {
		level = 596, --[[等级]]
		exp = 6621850, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[597] = {
		level = 597, --[[等级]]
		exp = 6649794, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[598] = {
		level = 598, --[[等级]]
		exp = 6677836, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[599] = {
		level = 599, --[[等级]]
		exp = 6705976, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[600] = {
		level = 600, --[[等级]]
		exp = 6734214, --[[经验]]
		attack = 63, --[[攻击]]
		physical_defense = 63, --[[物防]]
		magic_defense = 63, --[[法防]]
		hp = 1260, --[[生命]]
		dodge = 31, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[601] = {
		level = 601, --[[等级]]
		exp = 6762551, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[602] = {
		level = 602, --[[等级]]
		exp = 6790987, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[603] = {
		level = 603, --[[等级]]
		exp = 6819523, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[604] = {
		level = 604, --[[等级]]
		exp = 6848159, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[605] = {
		level = 605, --[[等级]]
		exp = 6876895, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[606] = {
		level = 606, --[[等级]]
		exp = 6905732, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[607] = {
		level = 607, --[[等级]]
		exp = 6934670, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[608] = {
		level = 608, --[[等级]]
		exp = 6963709, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[609] = {
		level = 609, --[[等级]]
		exp = 6992850, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[610] = {
		level = 610, --[[等级]]
		exp = 7022093, --[[经验]]
		attack = 64, --[[攻击]]
		physical_defense = 64, --[[物防]]
		magic_defense = 64, --[[法防]]
		hp = 1280, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[611] = {
		level = 611, --[[等级]]
		exp = 7051438, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[612] = {
		level = 612, --[[等级]]
		exp = 7080886, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[613] = {
		level = 613, --[[等级]]
		exp = 7110437, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[614] = {
		level = 614, --[[等级]]
		exp = 7140091, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[615] = {
		level = 615, --[[等级]]
		exp = 7169849, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[616] = {
		level = 616, --[[等级]]
		exp = 7199711, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[617] = {
		level = 617, --[[等级]]
		exp = 7229678, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[618] = {
		level = 618, --[[等级]]
		exp = 7259750, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[619] = {
		level = 619, --[[等级]]
		exp = 7289927, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[620] = {
		level = 620, --[[等级]]
		exp = 7320210, --[[经验]]
		attack = 65, --[[攻击]]
		physical_defense = 65, --[[物防]]
		magic_defense = 65, --[[法防]]
		hp = 1300, --[[生命]]
		dodge = 32, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[621] = {
		level = 621, --[[等级]]
		exp = 7350599, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[622] = {
		level = 622, --[[等级]]
		exp = 7381094, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[623] = {
		level = 623, --[[等级]]
		exp = 7411696, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[624] = {
		level = 624, --[[等级]]
		exp = 7442405, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[625] = {
		level = 625, --[[等级]]
		exp = 7473221, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[626] = {
		level = 626, --[[等级]]
		exp = 7504145, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[627] = {
		level = 627, --[[等级]]
		exp = 7535177, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[628] = {
		level = 628, --[[等级]]
		exp = 7566318, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[629] = {
		level = 629, --[[等级]]
		exp = 7597568, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[630] = {
		level = 630, --[[等级]]
		exp = 7628927, --[[经验]]
		attack = 66, --[[攻击]]
		physical_defense = 66, --[[物防]]
		magic_defense = 66, --[[法防]]
		hp = 1320, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[631] = {
		level = 631, --[[等级]]
		exp = 7660396, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[632] = {
		level = 632, --[[等级]]
		exp = 7691975, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[633] = {
		level = 633, --[[等级]]
		exp = 7723665, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[634] = {
		level = 634, --[[等级]]
		exp = 7755466, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[635] = {
		level = 635, --[[等级]]
		exp = 7787378, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[636] = {
		level = 636, --[[等级]]
		exp = 7819402, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[637] = {
		level = 637, --[[等级]]
		exp = 7851538, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[638] = {
		level = 638, --[[等级]]
		exp = 7883786, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[639] = {
		level = 639, --[[等级]]
		exp = 7916147, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[640] = {
		level = 640, --[[等级]]
		exp = 7948621, --[[经验]]
		attack = 67, --[[攻击]]
		physical_defense = 67, --[[物防]]
		magic_defense = 67, --[[法防]]
		hp = 1340, --[[生命]]
		dodge = 33, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[641] = {
		level = 641, --[[等级]]
		exp = 7981209, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[642] = {
		level = 642, --[[等级]]
		exp = 8013911, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[643] = {
		level = 643, --[[等级]]
		exp = 8046727, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[644] = {
		level = 644, --[[等级]]
		exp = 8079658, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[645] = {
		level = 645, --[[等级]]
		exp = 8112704, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[646] = {
		level = 646, --[[等级]]
		exp = 8145866, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[647] = {
		level = 647, --[[等级]]
		exp = 8179144, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[648] = {
		level = 648, --[[等级]]
		exp = 8212538, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[649] = {
		level = 649, --[[等级]]
		exp = 8246049, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[650] = {
		level = 650, --[[等级]]
		exp = 8279677, --[[经验]]
		attack = 68, --[[攻击]]
		physical_defense = 68, --[[物防]]
		magic_defense = 68, --[[法防]]
		hp = 1360, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[651] = {
		level = 651, --[[等级]]
		exp = 8313423, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[652] = {
		level = 652, --[[等级]]
		exp = 8347287, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[653] = {
		level = 653, --[[等级]]
		exp = 8381270, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[654] = {
		level = 654, --[[等级]]
		exp = 8415372, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[655] = {
		level = 655, --[[等级]]
		exp = 8449593, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[656] = {
		level = 656, --[[等级]]
		exp = 8483934, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[657] = {
		level = 657, --[[等级]]
		exp = 8518395, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[658] = {
		level = 658, --[[等级]]
		exp = 8552977, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[659] = {
		level = 659, --[[等级]]
		exp = 8587680, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[660] = {
		level = 660, --[[等级]]
		exp = 8622504, --[[经验]]
		attack = 69, --[[攻击]]
		physical_defense = 69, --[[物防]]
		magic_defense = 69, --[[法防]]
		hp = 1380, --[[生命]]
		dodge = 34, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[661] = {
		level = 661, --[[等级]]
		exp = 8657450, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[662] = {
		level = 662, --[[等级]]
		exp = 8692518, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[663] = {
		level = 663, --[[等级]]
		exp = 8727709, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[664] = {
		level = 664, --[[等级]]
		exp = 8763023, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[665] = {
		level = 665, --[[等级]]
		exp = 8798461, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[666] = {
		level = 666, --[[等级]]
		exp = 8834023, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[667] = {
		level = 667, --[[等级]]
		exp = 8869709, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[668] = {
		level = 668, --[[等级]]
		exp = 8905520, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[669] = {
		level = 669, --[[等级]]
		exp = 8941456, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[670] = {
		level = 670, --[[等级]]
		exp = 8977518, --[[经验]]
		attack = 70, --[[攻击]]
		physical_defense = 70, --[[物防]]
		magic_defense = 70, --[[法防]]
		hp = 1400, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[671] = {
		level = 671, --[[等级]]
		exp = 9013706, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[672] = {
		level = 672, --[[等级]]
		exp = 9050021, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[673] = {
		level = 673, --[[等级]]
		exp = 9086463, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[674] = {
		level = 674, --[[等级]]
		exp = 9123033, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[675] = {
		level = 675, --[[等级]]
		exp = 9159731, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[676] = {
		level = 676, --[[等级]]
		exp = 9196557, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[677] = {
		level = 677, --[[等级]]
		exp = 9233512, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[678] = {
		level = 678, --[[等级]]
		exp = 9270596, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[679] = {
		level = 679, --[[等级]]
		exp = 9307810, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[680] = {
		level = 680, --[[等级]]
		exp = 9345154, --[[经验]]
		attack = 71, --[[攻击]]
		physical_defense = 71, --[[物防]]
		magic_defense = 71, --[[法防]]
		hp = 1420, --[[生命]]
		dodge = 35, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[681] = {
		level = 681, --[[等级]]
		exp = 9382629, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[682] = {
		level = 682, --[[等级]]
		exp = 9420235, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[683] = {
		level = 683, --[[等级]]
		exp = 9457973, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[684] = {
		level = 684, --[[等级]]
		exp = 9495843, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[685] = {
		level = 685, --[[等级]]
		exp = 9533846, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[686] = {
		level = 686, --[[等级]]
		exp = 9571982, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[687] = {
		level = 687, --[[等级]]
		exp = 9610251, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[688] = {
		level = 688, --[[等级]]
		exp = 9648654, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[689] = {
		level = 689, --[[等级]]
		exp = 9687191, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[690] = {
		level = 690, --[[等级]]
		exp = 9725863, --[[经验]]
		attack = 72, --[[攻击]]
		physical_defense = 72, --[[物防]]
		magic_defense = 72, --[[法防]]
		hp = 1440, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[691] = {
		level = 691, --[[等级]]
		exp = 9764670, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[692] = {
		level = 692, --[[等级]]
		exp = 9803613, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[693] = {
		level = 693, --[[等级]]
		exp = 9842692, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[694] = {
		level = 694, --[[等级]]
		exp = 9881908, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[695] = {
		level = 695, --[[等级]]
		exp = 9921261, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[696] = {
		level = 696, --[[等级]]
		exp = 9960752, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[697] = {
		level = 697, --[[等级]]
		exp = 10000381, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[698] = {
		level = 698, --[[等级]]
		exp = 10040149, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[699] = {
		level = 699, --[[等级]]
		exp = 10080056, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[700] = {
		level = 700, --[[等级]]
		exp = 10120103, --[[经验]]
		attack = 73, --[[攻击]]
		physical_defense = 73, --[[物防]]
		magic_defense = 73, --[[法防]]
		hp = 1460, --[[生命]]
		dodge = 36, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[701] = {
		level = 701, --[[等级]]
		exp = 10160290, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[702] = {
		level = 702, --[[等级]]
		exp = 10200618, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[703] = {
		level = 703, --[[等级]]
		exp = 10241087, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[704] = {
		level = 704, --[[等级]]
		exp = 10281698, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[705] = {
		level = 705, --[[等级]]
		exp = 10322451, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[706] = {
		level = 706, --[[等级]]
		exp = 10363347, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[707] = {
		level = 707, --[[等级]]
		exp = 10404386, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[708] = {
		level = 708, --[[等级]]
		exp = 10445569, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[709] = {
		level = 709, --[[等级]]
		exp = 10486896, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[710] = {
		level = 710, --[[等级]]
		exp = 10528368, --[[经验]]
		attack = 74, --[[攻击]]
		physical_defense = 74, --[[物防]]
		magic_defense = 74, --[[法防]]
		hp = 1480, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[711] = {
		level = 711, --[[等级]]
		exp = 10569985, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[712] = {
		level = 712, --[[等级]]
		exp = 10611748, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[713] = {
		level = 713, --[[等级]]
		exp = 10653657, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[714] = {
		level = 714, --[[等级]]
		exp = 10695713, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[715] = {
		level = 715, --[[等级]]
		exp = 10737916, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[716] = {
		level = 716, --[[等级]]
		exp = 10780267, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[717] = {
		level = 717, --[[等级]]
		exp = 10822766, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[718] = {
		level = 718, --[[等级]]
		exp = 10865414, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[719] = {
		level = 719, --[[等级]]
		exp = 10908211, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[720] = {
		level = 720, --[[等级]]
		exp = 10951158, --[[经验]]
		attack = 75, --[[攻击]]
		physical_defense = 75, --[[物防]]
		magic_defense = 75, --[[法防]]
		hp = 1500, --[[生命]]
		dodge = 37, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[721] = {
		level = 721, --[[等级]]
		exp = 10994255, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[722] = {
		level = 722, --[[等级]]
		exp = 11037503, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[723] = {
		level = 723, --[[等级]]
		exp = 11080902, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[724] = {
		level = 724, --[[等级]]
		exp = 11124453, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[725] = {
		level = 725, --[[等级]]
		exp = 11168156, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[726] = {
		level = 726, --[[等级]]
		exp = 11212012, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[727] = {
		level = 727, --[[等级]]
		exp = 11256021, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[728] = {
		level = 728, --[[等级]]
		exp = 11300184, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[729] = {
		level = 729, --[[等级]]
		exp = 11344502, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[730] = {
		level = 730, --[[等级]]
		exp = 11388975, --[[经验]]
		attack = 76, --[[攻击]]
		physical_defense = 76, --[[物防]]
		magic_defense = 76, --[[法防]]
		hp = 1520, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[731] = {
		level = 731, --[[等级]]
		exp = 11433604, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[732] = {
		level = 732, --[[等级]]
		exp = 11478389, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[733] = {
		level = 733, --[[等级]]
		exp = 11523331, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[734] = {
		level = 734, --[[等级]]
		exp = 11568430, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[735] = {
		level = 735, --[[等级]]
		exp = 11613687, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[736] = {
		level = 736, --[[等级]]
		exp = 11659102, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[737] = {
		level = 737, --[[等级]]
		exp = 11704676, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[738] = {
		level = 738, --[[等级]]
		exp = 11750410, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[739] = {
		level = 739, --[[等级]]
		exp = 11796304, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[740] = {
		level = 740, --[[等级]]
		exp = 11842359, --[[经验]]
		attack = 77, --[[攻击]]
		physical_defense = 77, --[[物防]]
		magic_defense = 77, --[[法防]]
		hp = 1540, --[[生命]]
		dodge = 38, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[741] = {
		level = 741, --[[等级]]
		exp = 11888575, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[742] = {
		level = 742, --[[等级]]
		exp = 11934953, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[743] = {
		level = 743, --[[等级]]
		exp = 11981493, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[744] = {
		level = 744, --[[等级]]
		exp = 12028196, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[745] = {
		level = 745, --[[等级]]
		exp = 12075062, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[746] = {
		level = 746, --[[等级]]
		exp = 12122092, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[747] = {
		level = 747, --[[等级]]
		exp = 12169287, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[748] = {
		level = 748, --[[等级]]
		exp = 12216647, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[749] = {
		level = 749, --[[等级]]
		exp = 12264173, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[750] = {
		level = 750, --[[等级]]
		exp = 12311865, --[[经验]]
		attack = 78, --[[攻击]]
		physical_defense = 78, --[[物防]]
		magic_defense = 78, --[[法防]]
		hp = 1560, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[751] = {
		level = 751, --[[等级]]
		exp = 12359724, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[752] = {
		level = 752, --[[等级]]
		exp = 12407751, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[753] = {
		level = 753, --[[等级]]
		exp = 12455946, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[754] = {
		level = 754, --[[等级]]
		exp = 12504310, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[755] = {
		level = 755, --[[等级]]
		exp = 12552843, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[756] = {
		level = 756, --[[等级]]
		exp = 12601546, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[757] = {
		level = 757, --[[等级]]
		exp = 12650419, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[758] = {
		level = 758, --[[等级]]
		exp = 12699463, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[759] = {
		level = 759, --[[等级]]
		exp = 12748679, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[760] = {
		level = 760, --[[等级]]
		exp = 12798067, --[[经验]]
		attack = 79, --[[攻击]]
		physical_defense = 79, --[[物防]]
		magic_defense = 79, --[[法防]]
		hp = 1580, --[[生命]]
		dodge = 39, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[761] = {
		level = 761, --[[等级]]
		exp = 12847628, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[762] = {
		level = 762, --[[等级]]
		exp = 12897362, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[763] = {
		level = 763, --[[等级]]
		exp = 12947270, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[764] = {
		level = 764, --[[等级]]
		exp = 12997353, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[765] = {
		level = 765, --[[等级]]
		exp = 13047611, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[766] = {
		level = 766, --[[等级]]
		exp = 13098045, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[767] = {
		level = 767, --[[等级]]
		exp = 13148656, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[768] = {
		level = 768, --[[等级]]
		exp = 13199444, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[769] = {
		level = 769, --[[等级]]
		exp = 13250410, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[770] = {
		level = 770, --[[等级]]
		exp = 13301554, --[[经验]]
		attack = 80, --[[攻击]]
		physical_defense = 80, --[[物防]]
		magic_defense = 80, --[[法防]]
		hp = 1600, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[771] = {
		level = 771, --[[等级]]
		exp = 13352877, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[772] = {
		level = 772, --[[等级]]
		exp = 13404380, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[773] = {
		level = 773, --[[等级]]
		exp = 13456063, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[774] = {
		level = 774, --[[等级]]
		exp = 13507927, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[775] = {
		level = 775, --[[等级]]
		exp = 13559973, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[776] = {
		level = 776, --[[等级]]
		exp = 13612201, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[777] = {
		level = 777, --[[等级]]
		exp = 13664612, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[778] = {
		level = 778, --[[等级]]
		exp = 13717206, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[779] = {
		level = 779, --[[等级]]
		exp = 13769984, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[780] = {
		level = 780, --[[等级]]
		exp = 13822947, --[[经验]]
		attack = 81, --[[攻击]]
		physical_defense = 81, --[[物防]]
		magic_defense = 81, --[[法防]]
		hp = 1620, --[[生命]]
		dodge = 40, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[781] = {
		level = 781, --[[等级]]
		exp = 13876095, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[782] = {
		level = 782, --[[等级]]
		exp = 13929429, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[783] = {
		level = 783, --[[等级]]
		exp = 13982950, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[784] = {
		level = 784, --[[等级]]
		exp = 14036658, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[785] = {
		level = 785, --[[等级]]
		exp = 14090554, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[786] = {
		level = 786, --[[等级]]
		exp = 14144639, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[787] = {
		level = 787, --[[等级]]
		exp = 14198913, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[788] = {
		level = 788, --[[等级]]
		exp = 14253377, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[789] = {
		level = 789, --[[等级]]
		exp = 14308032, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[790] = {
		level = 790, --[[等级]]
		exp = 14362878, --[[经验]]
		attack = 82, --[[攻击]]
		physical_defense = 82, --[[物防]]
		magic_defense = 82, --[[法防]]
		hp = 1640, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[791] = {
		level = 791, --[[等级]]
		exp = 14417916, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[792] = {
		level = 792, --[[等级]]
		exp = 14473147, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[793] = {
		level = 793, --[[等级]]
		exp = 14528571, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[794] = {
		level = 794, --[[等级]]
		exp = 14584189, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[795] = {
		level = 795, --[[等级]]
		exp = 14640002, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[796] = {
		level = 796, --[[等级]]
		exp = 14696010, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[797] = {
		level = 797, --[[等级]]
		exp = 14752214, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[798] = {
		level = 798, --[[等级]]
		exp = 14808615, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[799] = {
		level = 799, --[[等级]]
		exp = 14865213, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[800] = {
		level = 800, --[[等级]]
		exp = 14922009, --[[经验]]
		attack = 83, --[[攻击]]
		physical_defense = 83, --[[物防]]
		magic_defense = 83, --[[法防]]
		hp = 1660, --[[生命]]
		dodge = 41, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[801] = {
		level = 801, --[[等级]]
		exp = 14979004, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[802] = {
		level = 802, --[[等级]]
		exp = 15036198, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[803] = {
		level = 803, --[[等级]]
		exp = 15093592, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[804] = {
		level = 804, --[[等级]]
		exp = 15151187, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[805] = {
		level = 805, --[[等级]]
		exp = 15208984, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[806] = {
		level = 806, --[[等级]]
		exp = 15266983, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[807] = {
		level = 807, --[[等级]]
		exp = 15325185, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[808] = {
		level = 808, --[[等级]]
		exp = 15383591, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[809] = {
		level = 809, --[[等级]]
		exp = 15442201, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[810] = {
		level = 810, --[[等级]]
		exp = 15501016, --[[经验]]
		attack = 84, --[[攻击]]
		physical_defense = 84, --[[物防]]
		magic_defense = 84, --[[法防]]
		hp = 1680, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[811] = {
		level = 811, --[[等级]]
		exp = 15560037, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[812] = {
		level = 812, --[[等级]]
		exp = 15619265, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[813] = {
		level = 813, --[[等级]]
		exp = 15678700, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[814] = {
		level = 814, --[[等级]]
		exp = 15738343, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[815] = {
		level = 815, --[[等级]]
		exp = 15798195, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[816] = {
		level = 816, --[[等级]]
		exp = 15858256, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[817] = {
		level = 817, --[[等级]]
		exp = 15918527, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[818] = {
		level = 818, --[[等级]]
		exp = 15979009, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[819] = {
		level = 819, --[[等级]]
		exp = 16039703, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[820] = {
		level = 820, --[[等级]]
		exp = 16100609, --[[经验]]
		attack = 85, --[[攻击]]
		physical_defense = 85, --[[物防]]
		magic_defense = 85, --[[法防]]
		hp = 1700, --[[生命]]
		dodge = 42, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[821] = {
		level = 821, --[[等级]]
		exp = 16161728, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[822] = {
		level = 822, --[[等级]]
		exp = 16223061, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[823] = {
		level = 823, --[[等级]]
		exp = 16284609, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[824] = {
		level = 824, --[[等级]]
		exp = 16346372, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[825] = {
		level = 825, --[[等级]]
		exp = 16408351, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[826] = {
		level = 826, --[[等级]]
		exp = 16470547, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[827] = {
		level = 827, --[[等级]]
		exp = 16532961, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[828] = {
		level = 828, --[[等级]]
		exp = 16595593, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[829] = {
		level = 829, --[[等级]]
		exp = 16658444, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[830] = {
		level = 830, --[[等级]]
		exp = 16721515, --[[经验]]
		attack = 86, --[[攻击]]
		physical_defense = 86, --[[物防]]
		magic_defense = 86, --[[法防]]
		hp = 1720, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[831] = {
		level = 831, --[[等级]]
		exp = 16784807, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[832] = {
		level = 832, --[[等级]]
		exp = 16848321, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[833] = {
		level = 833, --[[等级]]
		exp = 16912057, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[834] = {
		level = 834, --[[等级]]
		exp = 16976016, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[835] = {
		level = 835, --[[等级]]
		exp = 17040199, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[836] = {
		level = 836, --[[等级]]
		exp = 17104607, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[837] = {
		level = 837, --[[等级]]
		exp = 17169240, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[838] = {
		level = 838, --[[等级]]
		exp = 17234099, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[839] = {
		level = 839, --[[等级]]
		exp = 17299185, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[840] = {
		level = 840, --[[等级]]
		exp = 17364499, --[[经验]]
		attack = 87, --[[攻击]]
		physical_defense = 87, --[[物防]]
		magic_defense = 87, --[[法防]]
		hp = 1740, --[[生命]]
		dodge = 43, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[841] = {
		level = 841, --[[等级]]
		exp = 17430042, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[842] = {
		level = 842, --[[等级]]
		exp = 17495814, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[843] = {
		level = 843, --[[等级]]
		exp = 17561816, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[844] = {
		level = 844, --[[等级]]
		exp = 17628049, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[845] = {
		level = 845, --[[等级]]
		exp = 17694514, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[846] = {
		level = 846, --[[等级]]
		exp = 17761212, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[847] = {
		level = 847, --[[等级]]
		exp = 17828143, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[848] = {
		level = 848, --[[等级]]
		exp = 17895308, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[849] = {
		level = 849, --[[等级]]
		exp = 17962708, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[850] = {
		level = 850, --[[等级]]
		exp = 18030344, --[[经验]]
		attack = 88, --[[攻击]]
		physical_defense = 88, --[[物防]]
		magic_defense = 88, --[[法防]]
		hp = 1760, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[851] = {
		level = 851, --[[等级]]
		exp = 18098217, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[852] = {
		level = 852, --[[等级]]
		exp = 18166328, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[853] = {
		level = 853, --[[等级]]
		exp = 18234677, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[854] = {
		level = 854, --[[等级]]
		exp = 18303265, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[855] = {
		level = 855, --[[等级]]
		exp = 18372093, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[856] = {
		level = 856, --[[等级]]
		exp = 18441162, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[857] = {
		level = 857, --[[等级]]
		exp = 18510473, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[858] = {
		level = 858, --[[等级]]
		exp = 18580027, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[859] = {
		level = 859, --[[等级]]
		exp = 18649824, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[860] = {
		level = 860, --[[等级]]
		exp = 18719865, --[[经验]]
		attack = 89, --[[攻击]]
		physical_defense = 89, --[[物防]]
		magic_defense = 89, --[[法防]]
		hp = 1780, --[[生命]]
		dodge = 44, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[861] = {
		level = 861, --[[等级]]
		exp = 18790151, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[862] = {
		level = 862, --[[等级]]
		exp = 18860683, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[863] = {
		level = 863, --[[等级]]
		exp = 18931462, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[864] = {
		level = 864, --[[等级]]
		exp = 19002489, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[865] = {
		level = 865, --[[等级]]
		exp = 19073765, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[866] = {
		level = 866, --[[等级]]
		exp = 19145290, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[867] = {
		level = 867, --[[等级]]
		exp = 19217065, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[868] = {
		level = 868, --[[等级]]
		exp = 19289091, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[869] = {
		level = 869, --[[等级]]
		exp = 19361369, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[870] = {
		level = 870, --[[等级]]
		exp = 19433900, --[[经验]]
		attack = 90, --[[攻击]]
		physical_defense = 90, --[[物防]]
		magic_defense = 90, --[[法防]]
		hp = 1800, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[871] = {
		level = 871, --[[等级]]
		exp = 19506685, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[872] = {
		level = 872, --[[等级]]
		exp = 19579725, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[873] = {
		level = 873, --[[等级]]
		exp = 19653021, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[874] = {
		level = 874, --[[等级]]
		exp = 19726574, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[875] = {
		level = 875, --[[等级]]
		exp = 19800384, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[876] = {
		level = 876, --[[等级]]
		exp = 19874452, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[877] = {
		level = 877, --[[等级]]
		exp = 19948779, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[878] = {
		level = 878, --[[等级]]
		exp = 20023366, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[879] = {
		level = 879, --[[等级]]
		exp = 20098214, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[880] = {
		level = 880, --[[等级]]
		exp = 20173324, --[[经验]]
		attack = 91, --[[攻击]]
		physical_defense = 91, --[[物防]]
		magic_defense = 91, --[[法防]]
		hp = 1820, --[[生命]]
		dodge = 45, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[881] = {
		level = 881, --[[等级]]
		exp = 20248697, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[882] = {
		level = 882, --[[等级]]
		exp = 20324334, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[883] = {
		level = 883, --[[等级]]
		exp = 20400236, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[884] = {
		level = 884, --[[等级]]
		exp = 20476404, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[885] = {
		level = 885, --[[等级]]
		exp = 20552839, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[886] = {
		level = 886, --[[等级]]
		exp = 20629542, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[887] = {
		level = 887, --[[等级]]
		exp = 20706513, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[888] = {
		level = 888, --[[等级]]
		exp = 20783753, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[889] = {
		level = 889, --[[等级]]
		exp = 20861263, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[890] = {
		level = 890, --[[等级]]
		exp = 20939044, --[[经验]]
		attack = 92, --[[攻击]]
		physical_defense = 92, --[[物防]]
		magic_defense = 92, --[[法防]]
		hp = 1840, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[891] = {
		level = 891, --[[等级]]
		exp = 21017097, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[892] = {
		level = 892, --[[等级]]
		exp = 21095423, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[893] = {
		level = 893, --[[等级]]
		exp = 21174023, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[894] = {
		level = 894, --[[等级]]
		exp = 21252898, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[895] = {
		level = 895, --[[等级]]
		exp = 21332049, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[896] = {
		level = 896, --[[等级]]
		exp = 21411477, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[897] = {
		level = 897, --[[等级]]
		exp = 21491183, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[898] = {
		level = 898, --[[等级]]
		exp = 21571168, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[899] = {
		level = 899, --[[等级]]
		exp = 21651433, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[900] = {
		level = 900, --[[等级]]
		exp = 21731979, --[[经验]]
		attack = 93, --[[攻击]]
		physical_defense = 93, --[[物防]]
		magic_defense = 93, --[[法防]]
		hp = 1860, --[[生命]]
		dodge = 46, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[901] = {
		level = 901, --[[等级]]
		exp = 21812807, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[902] = {
		level = 902, --[[等级]]
		exp = 21893918, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[903] = {
		level = 903, --[[等级]]
		exp = 21975313, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[904] = {
		level = 904, --[[等级]]
		exp = 22056993, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[905] = {
		level = 905, --[[等级]]
		exp = 22138959, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[906] = {
		level = 906, --[[等级]]
		exp = 22221212, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[907] = {
		level = 907, --[[等级]]
		exp = 22303753, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[908] = {
		level = 908, --[[等级]]
		exp = 22386583, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[909] = {
		level = 909, --[[等级]]
		exp = 22469703, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[910] = {
		level = 910, --[[等级]]
		exp = 22553114, --[[经验]]
		attack = 94, --[[攻击]]
		physical_defense = 94, --[[物防]]
		magic_defense = 94, --[[法防]]
		hp = 1880, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[911] = {
		level = 911, --[[等级]]
		exp = 22636817, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[912] = {
		level = 912, --[[等级]]
		exp = 22720813, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[913] = {
		level = 913, --[[等级]]
		exp = 22805103, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[914] = {
		level = 914, --[[等级]]
		exp = 22889688, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[915] = {
		level = 915, --[[等级]]
		exp = 22974569, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[916] = {
		level = 916, --[[等级]]
		exp = 23059747, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[917] = {
		level = 917, --[[等级]]
		exp = 23145223, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[918] = {
		level = 918, --[[等级]]
		exp = 23230998, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[919] = {
		level = 919, --[[等级]]
		exp = 23317073, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[920] = {
		level = 920, --[[等级]]
		exp = 23403449, --[[经验]]
		attack = 95, --[[攻击]]
		physical_defense = 95, --[[物防]]
		magic_defense = 95, --[[法防]]
		hp = 1900, --[[生命]]
		dodge = 47, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[921] = {
		level = 921, --[[等级]]
		exp = 23490127, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[922] = {
		level = 922, --[[等级]]
		exp = 23577108, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[923] = {
		level = 923, --[[等级]]
		exp = 23664393, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[924] = {
		level = 924, --[[等级]]
		exp = 23751983, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[925] = {
		level = 925, --[[等级]]
		exp = 23839880, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[926] = {
		level = 926, --[[等级]]
		exp = 23928085, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[927] = {
		level = 927, --[[等级]]
		exp = 24016599, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[928] = {
		level = 928, --[[等级]]
		exp = 24105423, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[929] = {
		level = 929, --[[等级]]
		exp = 24194558, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[930] = {
		level = 930, --[[等级]]
		exp = 24284005, --[[经验]]
		attack = 96, --[[攻击]]
		physical_defense = 96, --[[物防]]
		magic_defense = 96, --[[法防]]
		hp = 1920, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[931] = {
		level = 931, --[[等级]]
		exp = 24373765, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[932] = {
		level = 932, --[[等级]]
		exp = 24463839, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[933] = {
		level = 933, --[[等级]]
		exp = 24554228, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[934] = {
		level = 934, --[[等级]]
		exp = 24644933, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[935] = {
		level = 935, --[[等级]]
		exp = 24735955, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[936] = {
		level = 936, --[[等级]]
		exp = 24827296, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[937] = {
		level = 937, --[[等级]]
		exp = 24918957, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[938] = {
		level = 938, --[[等级]]
		exp = 25010939, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[939] = {
		level = 939, --[[等级]]
		exp = 25103243, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[940] = {
		level = 940, --[[等级]]
		exp = 25195870, --[[经验]]
		attack = 97, --[[攻击]]
		physical_defense = 97, --[[物防]]
		magic_defense = 97, --[[法防]]
		hp = 1940, --[[生命]]
		dodge = 48, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[941] = {
		level = 941, --[[等级]]
		exp = 25288821, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[942] = {
		level = 942, --[[等级]]
		exp = 25382097, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[943] = {
		level = 943, --[[等级]]
		exp = 25475699, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[944] = {
		level = 944, --[[等级]]
		exp = 25569629, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[945] = {
		level = 945, --[[等级]]
		exp = 25663888, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[946] = {
		level = 946, --[[等级]]
		exp = 25758477, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[947] = {
		level = 947, --[[等级]]
		exp = 25853397, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[948] = {
		level = 948, --[[等级]]
		exp = 25948649, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[949] = {
		level = 949, --[[等级]]
		exp = 26044234, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[950] = {
		level = 950, --[[等级]]
		exp = 26140154, --[[经验]]
		attack = 98, --[[攻击]]
		physical_defense = 98, --[[物防]]
		magic_defense = 98, --[[法防]]
		hp = 1960, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[951] = {
		level = 951, --[[等级]]
		exp = 26236410, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[952] = {
		level = 952, --[[等级]]
		exp = 26333003, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[953] = {
		level = 953, --[[等级]]
		exp = 26429934, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[954] = {
		level = 954, --[[等级]]
		exp = 26527204, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[955] = {
		level = 955, --[[等级]]
		exp = 26624814, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[956] = {
		level = 956, --[[等级]]
		exp = 26722766, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[957] = {
		level = 957, --[[等级]]
		exp = 26821061, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[958] = {
		level = 958, --[[等级]]
		exp = 26919700, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[959] = {
		level = 959, --[[等级]]
		exp = 27018684, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[960] = {
		level = 960, --[[等级]]
		exp = 27118014, --[[经验]]
		attack = 99, --[[攻击]]
		physical_defense = 99, --[[物防]]
		magic_defense = 99, --[[法防]]
		hp = 1980, --[[生命]]
		dodge = 49, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[961] = {
		level = 961, --[[等级]]
		exp = 27217692, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[962] = {
		level = 962, --[[等级]]
		exp = 27317719, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[963] = {
		level = 963, --[[等级]]
		exp = 27418096, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[964] = {
		level = 964, --[[等级]]
		exp = 27518824, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[965] = {
		level = 965, --[[等级]]
		exp = 27619905, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[966] = {
		level = 966, --[[等级]]
		exp = 27721340, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[967] = {
		level = 967, --[[等级]]
		exp = 27823130, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[968] = {
		level = 968, --[[等级]]
		exp = 27925276, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[969] = {
		level = 969, --[[等级]]
		exp = 28027780, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[970] = {
		level = 970, --[[等级]]
		exp = 28130643, --[[经验]]
		attack = 100, --[[攻击]]
		physical_defense = 100, --[[物防]]
		magic_defense = 100, --[[法防]]
		hp = 2000, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[971] = {
		level = 971, --[[等级]]
		exp = 28233866, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[972] = {
		level = 972, --[[等级]]
		exp = 28337450, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[973] = {
		level = 973, --[[等级]]
		exp = 28441397, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[974] = {
		level = 974, --[[等级]]
		exp = 28545708, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[975] = {
		level = 975, --[[等级]]
		exp = 28650384, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[976] = {
		level = 976, --[[等级]]
		exp = 28755426, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[977] = {
		level = 977, --[[等级]]
		exp = 28860836, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[978] = {
		level = 978, --[[等级]]
		exp = 28966615, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[979] = {
		level = 979, --[[等级]]
		exp = 29072764, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[980] = {
		level = 980, --[[等级]]
		exp = 29179285, --[[经验]]
		attack = 101, --[[攻击]]
		physical_defense = 101, --[[物防]]
		magic_defense = 101, --[[法防]]
		hp = 2020, --[[生命]]
		dodge = 50, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[981] = {
		level = 981, --[[等级]]
		exp = 29286179, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[982] = {
		level = 982, --[[等级]]
		exp = 29393447, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[983] = {
		level = 983, --[[等级]]
		exp = 29501090, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[984] = {
		level = 984, --[[等级]]
		exp = 29609110, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[985] = {
		level = 985, --[[等级]]
		exp = 29717508, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[986] = {
		level = 986, --[[等级]]
		exp = 29826285, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[987] = {
		level = 987, --[[等级]]
		exp = 29935443, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[988] = {
		level = 988, --[[等级]]
		exp = 30044983, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[989] = {
		level = 989, --[[等级]]
		exp = 30154906, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[990] = {
		level = 990, --[[等级]]
		exp = 30265214, --[[经验]]
		attack = 102, --[[攻击]]
		physical_defense = 102, --[[物防]]
		magic_defense = 102, --[[法防]]
		hp = 2040, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[991] = {
		level = 991, --[[等级]]
		exp = 30375908, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[992] = {
		level = 992, --[[等级]]
		exp = 30486989, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[993] = {
		level = 993, --[[等级]]
		exp = 30598459, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[994] = {
		level = 994, --[[等级]]
		exp = 30710319, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[995] = {
		level = 995, --[[等级]]
		exp = 30822571, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[996] = {
		level = 996, --[[等级]]
		exp = 30935216, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[997] = {
		level = 997, --[[等级]]
		exp = 31048255, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[998] = {
		level = 998, --[[等级]]
		exp = 31161690, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[999] = {
		level = 999, --[[等级]]
		exp = 31275522, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
	[1000] = {
		level = 1000, --[[等级]]
		exp = 31389752, --[[经验]]
		attack = 103, --[[攻击]]
		physical_defense = 103, --[[物防]]
		magic_defense = 103, --[[法防]]
		hp = 2060, --[[生命]]
		dodge = 51, --[[闪避]]
		skill = {13001001,13002001,13003001,13004001,13005001,13006001}, --[[当前激活技能{skillid1,skillId2,skillId3}注：填入所有已激活技能]]
	} ,
}
return ret