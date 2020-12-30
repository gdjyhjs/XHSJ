--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-02 19:12:09
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PlayerPrefs = UnityEngine.PlayerPrefs
local socialEnum = require("models.social.socialEnum")
local socialTools = require("models.social.socialTools")

local Social = LuaItemManager:get_item_obejct("social")
--UI资源
Social.assets=
{
    View("socialView", Social) 
}
--点击事件
function Social:on_click(obj,arg)
	self:call_event("social_on_click", false, obj, arg)
	return true
end

--初始化函数只会调用一次
function Social:initialize()
	print("社交初始化完毕")
	self.friendList = {} -- 好友列表
	self.strengthGivensList = {} -- 已赠送体力的好友列表 [id= id]
	self.finendRoleIdList = {} -- 好友id列表 记录好友
	self.recommendList = {} -- 推荐联系人列表
	self.StrengthList = {leftCount=0,todayGet=0} -- 体力列表
	self.FriendApplyList = {} -- 好友申请列表
	self.EnemyList = {} -- 仇人列表
	self.BlackList = {} -- 黑名单列表
	self.BlackRoleIdList = {} --黑名单id列表，id为键方便判断某人是否黑名单
	self.findName = "" -- 要查找的玩家名字
	self.findList = {} -- 查找玩家结果
end

--服务器返回
function Social:on_receive( msg, id1, id2, sid )
	if(id1==Net:get_id1("friend"))then
		gf_print_table(msg,"服务器社交系统返回")
		if(id2== Net:get_id2("friend", "GetFriendListR"))then
		print("服务器返回：取到好友列表")
		self:get_friend_list_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GetRecommendListR"))then
		print("服务器返回：推荐好友列表")
		self:get_recommend_list_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GetApplyListR"))then
		print("服务器返回：好友申请列表")
		self:get_apply_list_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GetBlackListR"))then
		gf_print_table(msg,"wtf receive GetBlackListR")
		print("服务器返回：黑名单列表")
		self:get_black_list_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GetEnemyListR"))then
		print("服务器返回：取仇人列表")
		self:get_enemy_list_s2c(msg)
		elseif(id2== Net:get_id2("friend", "ApplyFriendR"))then
		print("服务器返回：申请好友返回")
		self:apply_friend_s2c(msg)
		elseif(id2== Net:get_id2("friend", "ApplyFriendNotifyR"))then
		print("服务器返回：别人申请好友")
		self:apply_friend_notify_s2c(msg)
		elseif(id2== Net:get_id2("friend", "ReplyApplyR"))then
		print("服务器返回：回复答应别人申请好友")
		self:reply_apply_s2c(msg)
		elseif(id2== Net:get_id2("friend", "DeleteFriendR"))then
		print("服务器返回：删除好友")
		self:delete_friend_s2c(msg)
		elseif(id2== Net:get_id2("friend", "BlackFriendR"))then
		print("服务器返回：拉黑好友")
		self:black_friend_s2c(msg,sid)
		elseif(id2== Net:get_id2("friend", "RelieveBlackListR"))then
		print("服务器返回：解除黑名单")
		self:relieve_black_list_s2c(msg)
		elseif(id2== Net:get_id2("friend", "DeleteEnemyR"))then
		print("服务器返回：解除仇人")
		self:delete_enemy_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GiveStrengthR"))then
		print("服务器返回：赠送体力")
		self:give_strength_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GetStrengthR"))then
		print("服务器返回：领取体力")
		self:get_strength_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GiveFlowerR"))then
		print("服务器返回：赠送鲜花")
		self:give_flower_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GetFlowerR"))then
		print("服务器返回：领取鲜花")
		self:get_flower_s2c(msg)
		elseif(id2== Net:get_id2("friend", "FindPlayerR"))then
		print("服务器返回：查找到的玩家")
		self:friend_player_s2c(msg)
		elseif(id2== Net:get_id2("friend", "AddFriendR"))then
		print("服务器返回：添加好友成功推送")
		self:add_friend_s2c(msg)
		elseif(id2== Net:get_id2("friend", "FriendPrereadR"))then
		gf_print_table(msg,"wtf receive FriendPrereadR")
		print("服务器返回：好友系统预读")
		self:friend_preread_s2c(msg)
		elseif(id2== Net:get_id2("friend", "BeGiveR"))then
		print("服务器返回：被赠送体力提示")
		self:be_five_s2c(msg)
		elseif(id2== Net:get_id2("friend", "StrengthListR"))then
		print("服务器返回：可领体力列表")
		self:strength_list_s2c(msg)
		elseif(id2== Net:get_id2("friend", "GetFriendInfoR"))then
		print("服务器返回：获取朋友信息")
		self:get_friend_info_s2c(msg)
		end
	end
end
--好友系统预读
function Social:friend_preread_s2c(msg)
	if msg.apply == 1 then
		self.FriendApplyList = {1}
	end
	if msg.offlineNew == 1 then
		self:have_new_appay_friend_change(true)
	end
	self.StrengthList.leftCount = msg.give

	self:red_point_change()
end

--取到好友列表
function Social:get_friend_list_s2c(msg)
	-- 体力列表是索引
	self.friendList = socialTools.friend_sort(msg.list or {})

	self.finendRoleIdList = {}
	for i,v in ipairs(self.friendList) do
		self.finendRoleIdList[v.roleId] = v
	end

	for i,v in ipairs(msg.strengthGivens or {}) do
		self.strengthGivensList[v] = v
	end
end

--取到推荐好友列表
function Social:get_recommend_list_s2c(msg)
	self.recommendList = msg.list or {}
end

--取到好友申请列表
function Social:get_apply_list_s2c(msg)
	self.FriendApplyList = msg.list or {}
	self:red_point_change()
end

--黑名单列表
function Social:get_black_list_s2c(msg)
	self.BlackList = socialTools.friend_sort(msg.list or {})
	for i,v in ipairs(self.BlackList) do
		self.BlackRoleIdList[v.roleId] = v.roleId
	end
end

--仇人列表
function Social:get_enemy_list_s2c(msg)
	self.EnemyList = socialTools.enemy_sort(msg.list or {})
end

--申请好友返回
function Social:apply_friend_s2c(msg)
	if msg.err==0 then
		gf_message_tips("成功发送好友请求")
	else
		-- gf_message_tips("添加失败")
	end
end

--别人申请添加好友
function Social:apply_friend_notify_s2c(msg)
	local name = msg.friend.name
	local color = gf_get_text_color(ClientEnum.SET_GM_COLOR.NAME_OWN)
	gf_message_tips(string.format("<color=%s>%s</color>申请添加你为好友",color,name))
	table.insert(self.FriendApplyList,msg.friend)
	self:red_point_change()
	self:have_new_appay_friend_change(true)
end

--回复答应别人申请好友
function Social:reply_apply_s2c(msg)
	if msg.err==0 then
		--刷新好友申请列表
		-- gf_message_tips("有人同意了你的好友请求")
		self:get_apply_list_c2s()
	end
end

--删除好友
function Social:delete_friend_s2c(msg)
	if msg.err == 0 then
		self.finendRoleIdList[msg.roleId] = nil
		for i,v in ipairs(self.friendList) do
			if v.roleId == msg.roleId then
				table.remove(self.friendList,i)
				return
			end
		end
	else
		-- gf_message_tips("删除好友失败")
	end
end

--拉黑好友
function Social:black_friend_s2c(msg,sid)
	if msg.err == 0 then
		gf_message_tips("拉黑成功")
		local roleId = Net:get_sid_param(sid)[1]
		table.insert(self.BlackList,{roleId=roleId})
		self.BlackRoleIdList[roleId] = roleId
	else
		-- gf_message_tips("拉黑失败")
	end
end

--删除黑名单
function Social:relieve_black_list_s2c(msg)
	if msg.err == 0 then
		gf_message_tips("解除黑名单成功")
	else
		-- gf_message_tips("解除黑名单失败")
	end
end

--删除仇人
function Social:delete_enemy_s2c(msg)
	if msg.err == 0 then
		gf_message_tips("删除仇人成功")
	else
		-- gf_message_tips("删除仇人失败")
	end
end

--赠送体力
function Social:give_strength_s2c(msg)
	if msg.err == 0 then
		gf_message_tips("赠送成功")
	else
		-- gf_message_tips("赠送体力失败")
	end
end

--领取体力
function Social:get_strength_s2c(msg)
	if msg.err == 0 then
		gf_message_tips("领取体力成功")
		self:strength_list_c2s()
	else
		-- gf_message_tips("领取体力失败")
	end
end

--赠送鲜花
function Social:give_flower_s2c(msg)
	if msg.err == 0 then
		gf_message_tips("赠送鲜花成功")
	else
		-- gf_message_tips("赠送鲜花失败")
	end
end

--领取鲜花
function Social:get_flower_s2c(msg)
	if msg.err == 0 then
		gf_message_tips("领取鲜花成功")
	else
		-- gf_message_tips("领取鲜花失败")
	end
end


--查找到的玩家
function Social:friend_player_s2c(msg)
	self.findList = msg.friend
	-- find_player_list = msg.friend
	-- if self:get_social_view() then
	-- 	self:get_social_view():find_player_result()
	-- end
end

--添加好友成功推送
function Social:add_friend_s2c(msg)
	local name = msg.friend.name
	local color = gf_get_text_color(ClientEnum.SET_GM_COLOR.NAME_OWN)
	gf_message_tips(string.format("<color=%s>%s</color>加入好友列表",color,name))
	table.insert(self.friendList,msg.friend)
	self.friendList = socialTools.friend_sort(self.friendList or {})

	self.finendRoleIdList[msg.friend.roleId] = msg.friend

	if msg.give == 1 then
		self.strengthGivensList[msg.friend.roleId] = 1
	end
end

--被赠送体力提示
function Social:be_five_s2c(msg)
	-- gf_message_tips("你的好友赠送给你1点体力")
	if self.StrengthList.todayGet < 25 then
		self.StrengthList.leftCount = self.StrengthList.leftCount+1
	end
	self:red_point_change()
end

--取到可领体力列表
function Social:strength_list_s2c(msg)
	self.StrengthList = msg or {}
end

--取朋友信息列表
function Social:get_friend_info_s2c(roleIdArr)
	-- print("取好友信息")
end

----------------------------------------------------------------客户端到服务器
--好友系统预读
function Social:friend_preread_c2s(roleIdArr)
	print("好友系统预读")
	Net:send({},"friend","FriendPreread")
end

--取朋友信息列表
function Social:get_friend_info_c2s(roleIdArr)
	print("取好友信息")
	Net:send({roleId=roleIdArr},"friend","GetFriendInfo")
end

--取可领体力列表
function Social:strength_list_c2s()
	print("取可领体力列表")
	Net:send({},"friend","StrengthList")
end

--取好友列表,应该只需要打开面板的时候取一次
function Social:get_friend_list_c2s()
	print("取好友列表,应该只需要打开面板的时候取一次")
	Net:send({},"friend","GetFriendList")
end

--获取推荐好友列表
function Social:get_recommend_list_c2s()
	print("获取推荐好友列表")
	Net:send({},"friend","GetRecommendList")
end

--获取好友申请列表
function Social:get_apply_list_c2s()
	print("获取好友申请列表")
	Net:send({},"friend","GetApplyList")
end

--获取黑名单列表
function Social:get_black_list_c2s()
	print("获取黑名单列表")
	Net:send({},"friend","GetBlackList")
end

--仇人列表
function Social:get_enemy_list_c2s()
	print("获取仇人列表")
	Net:send({},"friend","GetEnemyList")
end

--申请好友
function Social:apply_friend_c2s(role_id_list)
	print("申请好友")
	if type(role_id_list)~="table" then --用于可以不传表，只传单个角色id
		role_id_list = {role_id_list}
	end
	Net:send({roleIdList=role_id_list},"friend","ApplyFriend")
end

--回复申请好友(同意id，拒绝id)
function Social:reply_apply_c2s(agree_id,reject_id)
	print("回复答应申请好友",agree_id)
	Net:send({agreeId=agree_id,rejectId=reject_id},"friend","ReplyApply")
end

--删除好友
function Social:delete_friend_c2s(role_id)
	print("删除好友")
	Net:send({roleId=role_id},"friend","DeleteFriend")
end

--拉黑好友
function Social:black_friend_c2s(role_id)
	print("拉黑好友")
	local sid = Net:set_sid_param(role_id)
	Net:send({roleId=role_id},"friend","BlackFriend",sid)
end

--删除黑名单
function Social:relieve_black_list_c2s(role_id)
	print("删除黑名单")
	Net:send({roleId=role_id},"friend","RelieveBlackList")
	self.BlackRoleIdList[role_id] = nil
end

--删除仇人
function Social:delete_enemy_c2s(role_id)
	print("删除仇人")
	Net:send({roleId=role_id},"friend","DeleteEnemy")
end

--赠送体力
function Social:give_strength_c2s(roleId)
	print("赠送体力")
	Net:send({roleId=roleId},"friend","GiveStrength")
end

--领取体力
function Social:get_strength_c2s()
	print("领取体力")
	Net:send({},"friend","GetStrength")
end

--赠送鲜花
function Social:give_flower_c2s(roleId)
	print("领取体力")
	Net:send({roleId=roleId},"friend","GiveFlower")
end

--领取鲜花
function Social:get_flower_c2s(roleId)
	print("领取体力")
	Net:send({roleId=roleId},"friend","GetFlower")
end

--查找玩家
function Social:friend_player_c2s(player_name)
	print("查找玩家")
	Net:send({name=player_name},"friend","FindPlayer")
end

function Social:set_open_mode(page_index,item_index)
	self.open_page = page_index
	self.open_item = item_index
end

-- 判断某人是否黑名单
function Social:is_blackList(roleId)
	return self.BlackRoleIdList[roleId] ~= nil
end

-- 获取是否有红点
function Social:is_have_red_point()
	return self.have_red_point or false
end

-- 通知红点变化 -- 社交红点
function Social:red_point_change()
	print("社交红点","好友申请数量",#self.FriendApplyList,"被送体力数量",self.StrengthList.leftCount,#self.FriendApplyList>0 or self.StrengthList.leftCount>0)
	self.have_red_point = #self.FriendApplyList>0 or self.StrengthList.leftCount>0
	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.MAIL, visible=self.have_red_point}, ClientProto.ShowHotPoint)
end

-- 是否有新的好友申请
function Social:is_have_new_appay_friend()
	return self.have_new_appay_friend or false
end

--通知红点变化 新的朋友申请
function Social:have_new_appay_friend_change(value)
	self.have_new_appay_friend = value
	Net:receive({id=ClientEnum.MAIN_UI_BTN.NEW_FRIEND, visible=self.have_new_appay_friend}, ClientProto.ShowOrHideMainuiBtn)
end