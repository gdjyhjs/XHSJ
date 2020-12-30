

local tbl ={
	[1] = 'Item',
	[2] = 'EnterCopy',
	[3] = 'EnterCopyR',
	[4] = 'ExitCopy',
	[5] = 'ExitCopyR',
	[6] = 'PassCopyR',
	[7] = 'ItemList',
	[8] = 'SweepCopy',
	[9] = 'SweepCopyR',
	[10] = 'ResetCopy',
	[11] = 'ResetCopyR',
	[12] = 'RewardNotifyR',
	[13] = 'CreatureWaveNotifyR',
	[14] = 'CopyScheduleR',
	[15] = 'StoryCopyInfo',
	[16] = 'GetStoryCopyInfo',
	[17] = 'GetStoryCopyInfoR',
	[18] = 'ChapterInfo',
	[19] = 'OpenChapterBox',
	[20] = 'OpenChapterBoxR',
	[21] = 'GetHolyCopyInfo',
	[22] = 'GetHolyCopyInfoR',
	[23] = 'DailyReward',
	[24] = 'DailyRewardR',
	[25] = 'HolyInfo',
	[26] = 'GetHolyInfo',
	[27] = 'GetHolyInfoR',
	[28] = 'StrengthenHoly',
	[29] = 'StrengthenHolyR',
	[30] = 'ContinueChallenge',
	[31] = 'ContinueChallengeR',
	[32] = 'GetTowerInfo',
	[33] = 'GetTowerInfoR',
	[34] = 'EnemyInfo',
	[35] = 'ArenaInfo',
	[36] = 'ArenaInfoR',
	[37] = 'FightRecord',
	[38] = 'ArenaFightRecord',
	[39] = 'ArenaFightRecordR',
	[40] = 'ArenaRankList',
	[41] = 'ArenaRankListR',
	[42] = 'RefreshMatch',
	[43] = 'RefreshMatchR',
	[44] = 'GetArenaDailyReward',
	[45] = 'GetArenaDailyRewardR',
	[46] = 'AddChallengeTimes',
	[47] = 'AddChallengeTimesR',
	[48] = 'GetAddTimesLeft',
	[49] = 'GetAddTimesLeftR',
	[50] = 'NextWave',
	[51] = 'NextWaveR',
	[52] = 'FactionRankInfo',
	[53] = 'FactionRank',
	[54] = 'FactionRankR',
	[55] = 'FactionStatisticsR',
	[56] = 'FactionHandUp',
	[57] = 'FactionHandUpR',
	[58] = 'TeamVsCopyLoadProgress',
	[59] = 'TeamVsCopyLoadProgressNotifyR',
	[60] = 'TeamBeginBattleNotifyR',
	[61] = 'TeamRecord',
	[62] = 'TeamVsCopyInfo',
	[63] = 'TeamVsCopyInfoR',
	[64] = 'TeamScoreR',
	[65] = 'TeamRecordList',
	[66] = 'TeamRecordListR',
	[67] = 'Member',
	[68] = 'MemberListR',
	[69] = 'MemberAttrChangeNotifyR',
	[70] = 'KillEnemyR',
	[71] = 'MemberResultInfo',
	[72] = 'TeamPassInfo',
	[73] = 'MaterialCopyInfo',
	[74] = 'GetMaterialCopyInfo',
	[75] = 'GetMaterialCopyInfoR',
	[76] = 'BuyMaterialTimes',
	[77] = 'BuyMaterialTimesR',
	[78] = 'BossBornInfoR',
	[79] = 'BossHurtListR',
	[80] = 'BossHurtInfo',
	[81] = 'BuildingHurtR',
	[82] = 'SmallGameInfoR',
	[83] = 'SmallGameTipsR',
	GetMaterialCopyInfoR = 75,
	ChapterInfo = 18,
	FightRecord = 37,
	SweepCopy = 8,
	FactionHandUp = 56,
	StrengthenHoly = 28,
	AddChallengeTimes = 46,
	HolyInfo = 25,
	GetStoryCopyInfo = 16,
	RewardNotifyR = 12,
	GetHolyInfoR = 27,
	EnterCopyR = 3,
	FactionRankInfo = 52,
	BuildingHurtR = 81,
	CreatureWaveNotifyR = 13,
	OpenChapterBoxR = 20,
	ArenaInfoR = 36,
	TeamVsCopyInfoR = 63,
	GetHolyInfo = 26,
	ArenaFightRecord = 38,
	AddChallengeTimesR = 47,
	MemberResultInfo = 71,
	GetTowerInfoR = 33,
	SmallGameTipsR = 83,
	StoryCopyInfo = 15,
	FactionStatisticsR = 55,
	ItemList = 7,
	RefreshMatch = 42,
	GetHolyCopyInfo = 21,
	FactionHandUpR = 57,
	GetAddTimesLeft = 48,
	ArenaRankListR = 41,
	GetArenaDailyReward = 44,
	TeamScoreR = 64,
	OpenChapterBox = 19,
	Item = 1,
	KillEnemyR = 70,
	GetHolyCopyInfoR = 22,
	StrengthenHolyR = 29,
	SmallGameInfoR = 82,
	BossBornInfoR = 78,
	BossHurtInfo = 80,
	BossHurtListR = 79,
	BuyMaterialTimes = 76,
	TeamRecordList = 65,
	PassCopyR = 6,
	SweepCopyR = 9,
	EnemyInfo = 34,
	ArenaInfo = 35,
	GetMaterialCopyInfo = 74,
	NextWaveR = 51,
	MaterialCopyInfo = 73,
	TeamPassInfo = 72,
	MemberAttrChangeNotifyR = 69,
	ResetCopyR = 11,
	MemberListR = 68,
	FactionRank = 53,
	Member = 67,
	TeamVsCopyLoadProgress = 58,
	GetTowerInfo = 32,
	RefreshMatchR = 43,
	GetStoryCopyInfoR = 17,
	TeamVsCopyInfo = 62,
	TeamRecord = 61,
	TeamBeginBattleNotifyR = 60,
	ContinueChallengeR = 31,
	ExitCopyR = 5,
	ResetCopy = 10,
	TeamRecordListR = 66,
	ExitCopy = 4,
	DailyRewardR = 24,
	FactionRankR = 54,
	TeamVsCopyLoadProgressNotifyR = 59,
	GetAddTimesLeftR = 49,
	GetArenaDailyRewardR = 45,
	DailyReward = 23,
	NextWave = 50,
	CopyScheduleR = 14,
	ContinueChallenge = 30,
	ArenaRankList = 40,
	EnterCopy = 2,
	ArenaFightRecordR = 39,
	BuyMaterialTimesR = 77,
}

return tbl
