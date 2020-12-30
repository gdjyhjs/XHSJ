local ret = {
	[1001] = {
		code = 1001, --[[题目id]]
		content = "军团的统帅是谁", --[[题目正文]]
		answer_1 = "%AllianceLeader", --[[答案1]]
		answer_2 = "%RandomUser", --[[答案2]]
		answer_3 = "%RandomUser", --[[答案3]]
		answer_4 = "%RandomUser", --[[答案4]]
		right_answer = "%AllianceLeader", --[[正确答案]]
	} ,
	[1002] = {
		code = 1002, --[[题目id]]
		content = "战力排行榜的第2位是谁", --[[题目正文]]
		answer_1 = "%PowerList#2", --[[答案1]]
		answer_2 = "%RandomUser", --[[答案2]]
		answer_3 = "%RandomUser", --[[答案3]]
		answer_4 = "%RandomUser", --[[答案4]]
		right_answer = "%PowerList#2", --[[正确答案]]
	} ,
	[1003] = {
		code = 1003, --[[题目id]]
		content = "本次活动开始前，最后加入军团的玩家名称", --[[题目正文]]
		answer_1 = "%LastJoin", --[[答案1]]
		answer_2 = "%RandomUser", --[[答案2]]
		answer_3 = "%RandomUser", --[[答案3]]
		answer_4 = "%RandomUser", --[[答案4]]
		right_answer = "%LastJoin", --[[正确答案]]
	} ,
	[1004] = {
		code = 1004, --[[题目id]]
		content = "军团目前的人数有多少", --[[题目正文]]
		answer_1 = "%MemberCount", --[[答案1]]
		answer_2 = "%RandomMemberCount", --[[答案2]]
		answer_3 = "%RandomMemberCount", --[[答案3]]
		answer_4 = "%RandomMemberCount", --[[答案4]]
		right_answer = "%MemberCount", --[[正确答案]]
	} ,
	[1005] = {
		code = 1005, --[[题目id]]
		content = "军团中战力最高的是谁", --[[题目正文]]
		answer_1 = "%AlliancePowerList#1", --[[答案1]]
		answer_2 = "%RandomUser", --[[答案2]]
		answer_3 = "%RandomUser", --[[答案3]]
		answer_4 = "%RandomUser", --[[答案4]]
		right_answer = "%AlliancePowerList#1", --[[正确答案]]
	} ,
	[1006] = {
		code = 1006, --[[题目id]]
		content = "军团中总贡献最多的是谁", --[[题目正文]]
		answer_1 = "%TotalDonateList#1", --[[答案1]]
		answer_2 = "%RandomUser", --[[答案2]]
		answer_3 = "%RandomUser", --[[答案3]]
		answer_4 = "%RandomUser", --[[答案4]]
		right_answer = "%TotalDonateList#1", --[[正确答案]]
	} ,
	[1007] = {
		code = 1007, --[[题目id]]
		content = "目前军团等级是多少", --[[题目正文]]
		answer_1 = "%AllianceLevel", --[[答案1]]
		answer_2 = "%RandomAllianceLevel", --[[答案2]]
		answer_3 = "%RandomAllianceLevel", --[[答案3]]
		answer_4 = "%RandomAllianceLevel", --[[答案4]]
		right_answer = "%AllianceLevel", --[[正确答案]]
	} ,
	[1008] = {
		code = 1008, --[[题目id]]
		content = "军团中等级最高的是谁", --[[题目正文]]
		answer_1 = "%MemberLevelRole#1", --[[答案1]]
		answer_2 = "%MemberLevelRole", --[[答案2]]
		answer_3 = "%MemberLevelRole", --[[答案3]]
		answer_4 = "%MemberLevelRole", --[[答案4]]
		right_answer = "%MemberLevelRole#1", --[[正确答案]]
	} ,
	[1009] = {
		code = 1009, --[[题目id]]
		content = "军团职务中最高的叫什么", --[[题目正文]]
		answer_1 = "%PositionName#1", --[[答案1]]
		answer_2 = "%RandomPositionName", --[[答案2]]
		answer_3 = "%RandomPositionName", --[[答案3]]
		answer_4 = "%RandomPositionName", --[[答案4]]
		right_answer = "%PositionName#1", --[[正确答案]]
	} ,
	[1010] = {
		code = 1010, --[[题目id]]
		content = "军团中等级最高的人有多少级", --[[题目正文]]
		answer_1 = "%MemberLevel#1", --[[答案1]]
		answer_2 = "%RandomLevel", --[[答案2]]
		answer_3 = "%RandomLevel", --[[答案3]]
		answer_4 = "%RandomLevel", --[[答案4]]
		right_answer = "%MemberLevel#1", --[[正确答案]]
	} ,
}
return ret