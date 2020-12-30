local Enum = require("enum.enum")

RANK_PROPERTY = 
{ 
	[Enum.RANKING_TYPE.POWER] 				= {	"name",		"career",				"power",},
	[Enum.RANKING_TYPE.LEVEL] 				= {	"name",		"career",				"level"	,		},
	[Enum.RANKING_TYPE.HERO]  				= {	"name",		{"hero","heroName"},	{"hero","heroPower"},},
	[Enum.RANKING_TYPE.ALLIANCE_FUND] 		= {	"name",		"level",				"fund",	},
	[Enum.RANKING_TYPE.ALLIANCE_DONATE] 	= {	"name",		"alliName",				"donation",	},
	[Enum.RANKING_TYPE.QUESTION_DAILY]  	= {	"name",		"costTime",				"rightTimes",	},
	[Enum.RANKING_TYPE.HORSE]  				= {	"name",		{"horse","horseCode"},	{"horse","horseLevel"},},
	[Enum.RANKING_TYPE.ALLIANCE_LEVEL]  	= {	"name",		"leaderName",			"level",},
	[Enum.RANKING_TYPE.TOWER]  				= {	"name",		"power",				"floor",},
} 
DEFAULT_CHOOSE = Enum.RANKING_TYPE.LEVEL

RANK_PAGE_COUNT = 7
