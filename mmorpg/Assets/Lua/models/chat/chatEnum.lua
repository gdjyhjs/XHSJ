local chatEnum={}

chatEnum.MESSAGE_TYPE = {
	SELF = 1, --自己
	OTHER = 2, --其他人
	SYSTEM = 3, --系统
	TIME = 4, --时间
	PSELF = 5, --自己发出的私聊
	POTHER = 6, --其他玩家发来的私聊
}

--获取朋友在类型
chatEnum.GET_FRIEND_TYPE = {
	RECENT_CONTACT = 1, --最近联系人
	CHAT_ROLE = 2, --聊天列表的人

}

return chatEnum