--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-19 16:16:06
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Legion = LuaItemManager:get_item_obejct("legion")
--UI资源
Legion.assets=
{
    View("legionBaseView", Legion) 
}
    

--点击事件
function Legion:on_click(obj,arg)
	self:call_event("on_clict", false, obj, arg)
end
-- repeatTaskTimes
function Legion:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("alliance") then
		if id2 == Net:get_id2("alliance", "BuildR") then
			self:build_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "GetMyInfoR") then
			gf_print_table(msg,"wtf receive GetMyInfoR")
			self:get_my_info_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "AllianceListR") then
			self:alliance_list_s2c(msg, sid)

		elseif id2 == Net:get_id2("alliance", "MyApplyR") then
			self:my_apply_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "ApplyJoinR") then
			self:apply_join_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "GetBaseInfoR") then
			gf_print_table(msg,"wtf receive GetBaseInfoR")
			self:get_base_info_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "GetMemberListR") then
			gf_print_table(msg,"wtf receive GetMemberListR")
			self:get_member_list_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "QuitR") then
			self:quit_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "GetApplyListR") then
			gf_print_table(msg,"wtf receive GetApplyListR")
			self:get_apply_list_s2c(msg)

		elseif id2 == Net:get_id2("alliance", "ApplyReplyR") then
			self:apply_reply_s2c(msg)

		elseif id2 == Net:get_id2("alliance","HandInDailyTaskR") then
			gf_print_table(msg, "HandInDailyTaskR:")
			self.dailyTask.isDone = (msg.err == 0) and 1 or 0

		elseif id2 == Net:get_id2("alliance","AllianceAcceptRepeatTaskR") then
			self:accept_legion_task_s2c(msg)

		elseif id2 == Net:get_id2("alliance","ModifyInfoR") then
			gf_print_table(msg, "ModifyInfoR:"..sid)
			self:rec_edit_legion_message(msg,sid)

		elseif id2 == Net:get_id2("alliance","UpGradeR") then
			gf_print_table(msg, "UpGradeR:")
			self:rec_legion_up_grade(msg,sid)

		elseif id2 == Net:get_id2("alliance","DissolveR") then
			gf_print_table(msg, "DissolveR:")
			self:rec_legion_dissolve(msg,sid)
			self:quit_s2c(msg)

		elseif id2 == Net:get_id2("alliance","ModifyJoinLimitR") then
			self:rec_modify_join_limit(msg,sid)

		elseif id2 == Net:get_id2("alliance","KickOutR") then
			self:kick_out_s2c(msg)
			
		elseif id2 == Net:get_id2("alliance","AllianceDevoteR") then
			self:alliance_devote_s2c(msg)

		elseif id2 == Net:get_id2("alliance","AllianceAddFundR") then
			gf_message_tips("增加<color=green>"..msg.addFund.."军团资金</color>")

		elseif id2 == Net:get_id2("alliance","SendRedPointR") then
			gf_print_table(msg, "wtf red_point SendRedPointR:")
			self.red_point = msg.flag == 1
			self:refresh_red_point()


		elseif id2 == Net:get_id2("alliance","WarFlagLevelUpR") then
			self:rec_flag_upgrade(msg)

		elseif id2 == Net:get_id2("alliance","WarFlagInspireR") then
			self:rec_spirit(msg)			

		elseif id2 == Net:get_id2("alliance","UpdateLegionBossFoodR") then
			self.legion_base_info.foodCount = msg.food

		elseif id2 == Net:get_id2("alliance","AnnounceLegionBossStartR") then
			gf_print_table(msg, "wtf AnnounceLegionBossStartR:")
			self:rec_open_boss()

		elseif id2 == Net:get_id2("alliance", "SetTitleR") then
			self:rec_set_member_title(msg)
		end
	elseif id1 == Net:get_id1("bag") then
		if id2 == Net:get_id2("bag", "ChangeNameR") then
			self:change_name_s2c(msg)
		end
	end

	if id1 == ClientProto.AllLoaderFinish then
		if self.target then
			-- gf_auto_atk(true)
			-- gf_getItemObject("battle"):auto_find_npc(self.target)
			-- self.target = nil
			self:enter_scene(self.target)
		end		

	end
end

function Legion:rec_set_member_title(msg)
	if msg.err == 0 then
		local role_id = msg.role_id
		local title = msg.title 
		self:set_member_title(role_id,title)
		--如果设置的是统帅 修改我自己的数据成成员信息
		if title == ServerEnum.ALLIANCE_TITLE.LEADER and self.title == ServerEnum.ALLIANCE_TITLE.LEADER then
			self.title = ServerEnum.ALLIANCE_TITLE.MEMBER
		end
	end
end
function Legion:rec_open_boss()
	local str = gf_localize_string("军团兽神活动已开启，是否前往参加。")
	local function sure_func()
		if gf_getItemObject("copy"):is_copy() then
			gf_message_tips(gf_localize_string("请退出副本再试"))
			return
		end
		local data = ConfigMgr:get_config("legion_boss")[1]
		self:enter_scene(data.npc_id)
	end
	LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(str,sure_func)
end




--[[
	======================================
	新增
]]


--@type 修炼连类型
--@return 需要消耗的铜币，贡献
function Legion:get_train_nlv_cose(type)
	local train_data = gf_getItemObject("train"):get_train_data_by_type(type)
	local legion_level = self:get_info().level
	local dataUse = require("models.train.dataUse")
	local coin,donation = dataUse.get_next_level_cost(type,train_data.level,train_data.exp,legion_level)
	return coin,donation
end

function Legion:rec_spirit(msg)
	gf_print_table(msg, "WarFlagInspireR wtf msg:")
	if msg.err == 0 then
		self.inspireTimes = msg.inspireTimes
		self.inspireExpiredTime = msg.inspireExpiredTime
	end
end

function Legion:rec_flag_upgrade(msg)
	if msg.err == 0 then
		self._legion_info.warFlagLevel = self._legion_info.warFlagLevel + 1
	end
end

function Legion:rec_edit_legion_message(msg,sid)
	if msg.err == 0 then
		local paramt = Net:get_sid_param(sid)
		local announcement,qqGroup,titleList,introduction = paramt[1],paramt[2],paramt[3],paramt[4]--self.announcement,self.qqGroup,self.titleList,self.introduction 
		if announcement then
			self._legion_info.announcement = announcement 
		end
		if introduction then
			self._legion_info.introduction = introduction
		end
		if qqGroup then
			self._legion_info.qqGroup = qqGroup

		end
		if titleList then
			for i,v in ipairs(titleList) do
				self.title_list[v.titleCode] = v.titleName
			end
			-- self.title_list = titleList
		end
	end
end

function Legion:rec_legion_dissolve(msg,sid)
	if msg.err == 0 then
		self:clear_data()
		gf_message_tips(gf_localize_string("你已解散军团"))
	end
end

function Legion:rec_legion_up_grade(msg,sid)
	if msg.err == 0 then
		self._legion_info.level = self._legion_info.level + 1
	end
end

function Legion:rec_legion_impeach(msg)
	if msg.err == 0 then
		
	end
end

function Legion:send_to_impeach()
	local msg = {}
	Net:send(msg, "alliance", "Impeach")
end
--发送修改qq群
function Legion:send_to_edit_qq(str)
	self:modify_info_c2s(nil,str)
end
function Legion:send_to_upgrade()
	local msg = {}
	Net:send(msg, "alliance", "UpGrade")
end
function Legion:send_to_edit_notice(str)
	self:modify_info_c2s(str,nil)
end
function Legion:send_to_spirit()
	local msg = {}
	Net:send(msg, "alliance", "WarFlagInspire")
end
function Legion:send_to_upgrade_flag()
	local msg = {}
	Net:send(msg, "alliance", "WarFlagLevelUp")
end
function Legion:send_to_dissolve()
	local msg = {}
	Net:send(msg, "alliance", "Dissolve")
end
function Legion:send_to_dissolve_s2c(msg)
	if msg.err == 0 then
		self._legion_info = {}
	end
end

--上交口粮
function Legion:hand_boss_food_c2s()
	Net:send({}, "alliance", "HandInLegionBossFood")
end

--开启军团boss
function Legion:star_legion_boss_c2s()
	Net:send({}, "alliance", "StartLegionBoss")
end


-- function Legion:send_to_kickout(role_id,role_name)
-- 	self.role_name = role_name
-- 	local msg = {}
-- 	msg.roleId = role_id
-- 	Net:send(msg, "alliance", "KickOut")
-- end
-- function Legion:send_to_kickout_s2c(msg)
-- 	if msg.err == 0 then
-- 	end
-- end

function Legion:send_to_modify_join_limit(levelLimit,powerLimit,autoAllow )
	local sid = Net:set_sid_param(levelLimit,powerLimit,autoAllow)
	local msg = {}
	msg.levelLimit = levelLimit
	msg.powerLimit = powerLimit
	msg.autoAllow = autoAllow
	Net:send(msg, "alliance", "ModifyJoinLimit",sid)
end
function Legion:rec_modify_join_limit(msg ,sid)
	gf_print_table(msg, "ModifyJoinLimitR:")
	if msg.err == 0 then
		local paramt = Net:get_sid_param(sid)
		local levelLimit,powerLimit,autoAllow = paramt[1],paramt[2],paramt[3]
		if levelLimit then
			self._legion_info.levelLimit = levelLimit
		end
		if powerLimit then
			self._legion_info.powerLimit = powerLimit
		end
		if autoAllow then
			self.auto_allow = autoAllow
		end
	end
end
function Legion:get_auto_allow()
	return self.auto_allow or 0
end











function Legion:accept_legion_task_s2c(msg)
	if msg.err == 0 then
		self.repeatTaskTimes = msg.repeatTaskTimes
	end
end

--每次显示时候调用
function Legion:on_showed( ... )

end

function Legion:open_view()
	if self:is_in() then
		require("models.legion.legionCommon")()
	else
		require("models.legion.applyView")()
	end
end

function Legion:create_view(page,tag,param)
	self:set_param(page,tag,param)
	self:open_view()
end

function Legion:set_param(...)
	self.param = {...}
end

function Legion:get_param()
	return self.param
end

--初始化函数只会调用一次
function Legion:initialize()
	self.legion_id = 0
	self._temp_legion_list = {}
	self.apply_list = {}
	self.title_list = {}
	self.my_apply_list = {}
	-- self.legion_title = {}
end

function Legion:get_title_name(title)
	return self.title_list[title] or ClientEnum.LEGION_TITLE_NAME[title]
end

-- 是否在军团里
function Legion:is_in()
	return self.legion_id ~= 0
end

-- 获取军团列表
function Legion:get_legion_list()
	return self.legion_list
end

-- 获取成员列表
function Legion:get_member_list()
	return self.legion_member_list
end

function Legion:get_on_line_member_count()
	local count = 0
	for i,v in ipairs(self.legion_member_list or {}) do
		if v.logoutTm == 0 then
			count = count + 1
		end
	end
	return count
end

-- 通过名字搜索军团
function Legion:search_legion( name )
	local list = {}
	for k,v in pairs(self.legion_list or {}) do
		if string.find(v.name, name) then
			list[#list+1] = v
		end
	end
	return list
end

-- 获取军团信息
function Legion:get_info()
	return self._legion_info
end

-- 获取军团名字
function Legion:get_name()
	return self._legion_info.name
end

-- 获取军团等级
function Legion:get_level()
	return self._legion_info.level
end

-- 获取军团id
function Legion:get_id()
	return self._legion_info.id
end

-- 获取军团标志
function Legion:get_flag()
	return self._legion_info.flag
end

-- 获取军团成员数量
function Legion:get_number()
	return self._legion_info.memberSize
end

-- 获取军团资金
function Legion:get_fund()
	return self._legion_info.found
end

-- 获取军团宗旨
function Legion:get_introduction()
	return self._legion_info.introduction
end

-- 获取军团升级状态
function Legion:get_status()
	return self._legion_info.statu
end

-- 获取本周军团简历
function Legion:get_weed_reward()
	return self._legion_info.weekRewardLevel
end

-- 获取自己申请过的军团列表
function Legion:get_my_apply_list()
	return self.my_apply_list
end

-- 获取申请列表
function Legion:get_apply_list()
	return gf_deep_copy(self.apply_list)
end

-- 通过军团id获取是否申请过
function Legion:get_had_apply( legion_id )
	return self.my_apply_list[legion_id..""] ~= nil
end

function Legion:get_title()
	return self.title
end

function Legion:get_task()
	return self.dailyTask
end

--获取军团前十等级平均数
function Legion:get_average_level()
	local level = 0
	local count = 1
	local temp = gf_deep_copy(self.legion_member_list)
	table.sort(temp,function(a,b)return a.level > b.level end)

	for i=1,10 do
		if temp[i] then
			level = level + temp[i].level
			count = i
		end
	end
	return math.floor(level / count)
end

-- 获取权限 
--title  如果title为空则为查看自己的权限
function Legion:get_permissions( permissions ,title)
	local title = title or self.title
	local config_data = ConfigMgr:get_config("alliance_title")[title]
	gf_print_table(config_data, "wtf config_data:")
	if not config_data then
		return false
	end
	
	return config_data["manage_"..permissions] == 1
end

-- 删除成员
function Legion:remove_member( role_id )
	-- 从成员列表中删除
	local index = 0
	for k,v in pairs(self.legion_member_list or {}) do
		if v.roleId == role_id then
			index = k
			break
		end
	end
	if index > 0 then
		table.remove(self.legion_member_list, index)
	end
end

function Legion:set_member_title(role_id,title)
	for k,v in pairs(self.legion_member_list or {}) do
		if v.roleId == role_id then
			v.title = title
			return
		end
	end
end

-- 移除申请列表中的成员
function Legion:remove_apply_member( role_id )
	local index = 0
	for k,v in pairs(self.apply_list or {}) do
		if v.roleId == role_id then
			index = k
			break
		end
	end
	if index > 0 then
		table.remove(self.apply_list, index)
	end
end

function Legion:enter_copy()
	local copy_data = ConfigMgr:get_config("copy")[ConfigMgr:get_config("t_misc").alliance.copyCode]
	LuaItemManager:get_item_obejct("copy"):enter_copy_c2s(copy_data.code)
	return copy_data
end
-- 进入军团场景
function Legion:enter_scene(target)
	self.target = target
	--如果地图是军团场景
	if gf_getItemObject("battle"):get_map_id() == 150102 then
		if self.target then
			local callback = function()
				gf_auto_atk(true)
			end
			gf_getItemObject("battle"):auto_find_npc(self.target,callback)
			self.target = nil
			return
		end
	end
	LuaItemManager:get_item_obejct("battle"):transfer_map_c2s(150102,nil,nil, false)
end

--接受军团任务
function Legion:accept_legion_task_c2s()
	Net:send({}, "alliance", "AllianceAcceptRepeatTask")
end

-- 获取角色相关的信息
function Legion:get_my_info_c2s()
	Net:send({}, "alliance", "GetMyInfo")
end

function Legion:get_my_info_s2c( msg )
	gf_print_table(msg, "获取军团信息返回：")
	self.legion_id = msg.id
	self.title = msg.title
	self.dailyTask = msg.dailyTask
	self.repeatTaskTimes = msg.repeatTaskTimes
	self.devoteTimes = msg.devoteTimes
	self.inspireTimes = msg.inspireTimes
	self.inspireExpiredTime = msg.inspireExpiredTime
end

function Legion:get_inspire_times()
	return self.inspireTimes or 0
end

function Legion:get_inspire_expired_time()
	return self.inspireExpiredTime or 0
end

function Legion:get_repeate_task_time()
	return self.repeatTaskTimes or 0
end

function Legion:get_devote_times()
	return self.devoteTimes or 0
end

-- 服务器推送更新信息
function Legion:update_my_info_s2c( msg )
	gf_print_table(msg, "服务器推送更新信息")
	self.title = msg.title
end

--接受军团任务
function Legion:commit_task_c2s()
	local msg = {}
	Net:send(msg, "alliance", "HandInDailyTask")
	gf_print_table(msg, "提交军团任务")
end

-- 查找军团
function Legion:search_alliance_c2s( name )
	local msg = {keyWord = name}
	Net:send(msg, "alliance", "SearchAlliance")
	gf_print_table(msg, "查找军团")
end

function Legion:search_alliance_s2c( msg )
	gf_print_table(msg, "查找军团返回")
	self.search_result_list = msg.list
end

-- 获取军团列表
function Legion:alliance_list_c2s( page ,canJoin)
	if page == 1 then
		self.legion_list = {}
	end

	Net:send({page = page,canJoin= canJoin}, "alliance", "AllianceList", page)
	print("获取军团列表:",page)
end

function Legion:alliance_list_s2c( msg, page )
	gf_print_table(msg, "获取军团列表返回:")
	
	if not self.legion_list then
		self.legion_list = {}
	end
	for i,v in pairs(msg.list) do
		self.legion_list[#self.legion_list+1] = v
	end
end

-- 获取军团基础信息
function Legion:get_base_info_c2s()
	print("获取军团基础信息")
	Net:send({}, "alliance", "GetBaseInfo")
end

function Legion:get_base_info_s2c( msg )
	gf_print_table(msg, "获取军团基础信息返回")
	self._legion_info = msg.alliance
	self.title_list = msg.titleList or {}
	self.auto_allow = msg.autoAllow

	self.legion_base_info = msg

	gf_print_table(self._legion_info, "self._legion_info:")
end

function Legion:get_legion_boss()
	local legion_info = self:get_legion_base_info()
	local is_open = not (not legion_info.legionBossCurHP or legion_info.legionBossCurHP <= 0)
	local no_leave = (legion_info.legionBossLeaveTime or 0) > Net:get_server_time_s()
	print("is_open and no_leave:",is_open , no_leave)
	return is_open and no_leave
end

function Legion:get_legion_base_info()
	return self.legion_base_info
end

-- 获取成员列表
function Legion:get_member_list_c2s()
	print("获取成员列表")
	Net:send({}, "alliance", "GetMemberList")
end

function Legion:get_title_num()
	local temp = {}
	for i,v in ipairs(self.legion_member_list or {}) do
		if not temp[v.title] then
			temp[v.title] = {}
		end
		table.insert(temp[v.title],v)
	end
	return temp
end

function Legion:get_member_list_s2c( msg )
	gf_print_table(msg, "获取成员列表返回")
	self.legion_member_list = msg.memberList
end

-- 建立军团
function Legion:build_c2s( name, flag, word ,resType,introduction)
	local msg = {
		name = name,
		flag = flag,
		word = word,
		resType = resType,
		introduction = introduction,
	}
	Net:send(msg, "alliance", "Build")
	gf_print_table(msg, "建立军团")
end

function Legion:build_s2c( msg )
	gf_print_table(msg, "建立军团返回")
	if msg.err == 0 then
		self.legion_id = msg.id
		self.title = ServerEnum.ALLIANCE_TITLE.LEADER
		self.donated = 0
	end
end

-- 获取申请列表
function Legion:get_apply_list_c2s()
	Net:send({}, "alliance", "GetApplyList")
end

function Legion:get_apply_list_s2c( msg )
	gf_print_table(msg, "获取申请列表返回")
	self.apply_list = msg.applyList
	self:refresh_red_point()

end

function Legion:refresh_red_point()
	print("wtf refresh_red_point:",self.red_point)
	local tf = self.red_point or #self.apply_list > 0
	gf_receive_client_prot({ btn_id = ClientEnum.MAIN_UI_BTN.FAMILY ,visible = tf}, ClientProto.ShowHotPoint)
	gf_receive_client_prot({ btn_id = ClientEnum.MAIN_UI_BTN.SWITCH ,visible = tf}, ClientProto.ShowHotPoint)
end

function Legion:refresh_red_point_main_view()
	local tf = self.red_point or #self.apply_list > 0
	gf_receive_client_prot({ btn_id = ClientEnum.MAIN_UI_BTN.FAMILY ,visible = tf}, ClientProto.ShowHotPoint)
	gf_receive_client_prot({ btn_id = ClientEnum.MAIN_UI_BTN.SWITCH ,visible = tf}, ClientProto.ShowHotPoint)
	self.red_point = false
end

-- 获取自己的申请列表
function Legion:my_apply_c2s()
	Net:send({}, "alliance", "MyApply")
end

function Legion:my_apply_s2c( msg )
	gf_print_table(msg, "获取自己的申请列表返回")
	for k,v in pairs(msg.idList) do
		self.my_apply_list[v] = v
	end
end

-- 申请加入军团
function Legion:apply_join_c2s( legion_id )
	self.apply_legion_id = legion_id
	Net:send({id = legion_id}, "alliance", "ApplyJoin")
end

function Legion:apply_join_s2c( msg )
	gf_print_table(msg, "申请加入军团返回")
	if msg.err == 0 then -- 申请成功
		gf_message_tips(gf_localize_string("申请成功"))
		if self.apply_legion_id > 0 then
			self.my_apply_list[self.apply_legion_id..""] = self.apply_legion_id..""

		else
			-- 一键申请
			self:my_apply_c2s()
		end
	end
end

function Legion:open_mail_view()
	if self:is_in() then
		self:open_view()
		return true
	else
		gf_message_tips(gf_localize_string("你没有军团"))
		return false
	end
end

-- 退出军团
function Legion:quit_c2s()
	Net:send({}, "alliance", "Quit")
end

function Legion:quit_s2c( msg )
	if msg.err == 0 then -- 退出成功
		gf_message_tips(gf_localize_string("你已退出军团"))
		self:clear_data()
	end
end

function Legion:clear_data()
	self.apply_list = {}
	self.legion_id = 0
	self._legion_info = {}
	self:refresh_red_point()
end

-- 回复申请
function Legion:apply_reply_c2s( role_id, result )
	-- self:remove_apply_member(role_id)

	local msg = {roleId = role_id, result = result}
	Net:send(msg, "alliance", "ApplyReply")
	gf_print_table(msg, "回复申请")
end

function Legion:apply_reply_s2c(msg)
	gf_print_table(msg, "回复申请返回")
	if msg.err == 0 then   --同意申请返回0 拒绝不返回err
		gf_message_tips(gf_localize_string("同意入团申请"))
	end
end

-- 踢出军团
function Legion:kick_out_c2s( role_id ,role_name)
	-- 从成员列表中删除
	if  LuaItemManager:get_item_obejct("setting"):is_lock() then
		return
	end
	self.role_name = role_name
	self:remove_member(role_id)

	Net:send({roleId = role_id}, "alliance", "KickOut")
end

function Legion:kick_out_s2c( msg )
	if msg.err == 0 then
		gf_message_tips(string.format("已将<color=#B01FE5>%s</color>踢出军团",self.role_name))
		self.role_name = nil
	end
end

-- 一键拒绝
function Legion:one_key_reject_c2s()
	self.apply_list = {}
	Net:send({}, "alliance", "OneKeyReject")
	self:refresh_red_point()
end

-- 获取军团公告
function Legion:get_announcement_c2s()
	Net:send({}, "alliance", "GetAnnouncement")
end

function Legion:get_announcement_s2c( msg )
	if msg.err == 0 then
	end
end

-- 修改军团信息
function Legion:modify_info_c2s( announcement, qqGroup ,titles,introduction)
	local sid = Net:set_sid_param(announcement, qqGroup,titles,introduction)
	local msg = {announcement = announcement, qqGroup = qqGroup,titleList = titles,introduction = introduction}
	Net:send(msg, "alliance", "ModifyInfo",sid)
end

function Legion:modify_info_s2c( msg )
	if msg.err == 0 then

	end
end

-- 设置职位
function Legion:set_title_c2s( role_id, title )
	local sid = Net:set_sid_param(title)
	local msg = {roleId = role_id, title = title}
	Net:send(msg, "alliance", "SetTitle")
	gf_print_table(msg, "设置职位")
end

function Legion:set_title_s2c( msg )
	if msg.err == 0 then
		
	end
end

--军团捐献
function Legion:alliance_devote_c2s(d_id)
	Net:send({code=d_id}, "alliance", "AllianceDevote")
end
function Legion:alliance_devote_s2c(msg)
	if msg.err == 0 then
		self.devoteTimes = msg.devoteTimes
		self._legion_info.fund = msg.fund
	end
end


--军团改名
function Legion:change_name_c2s(name)
	self.change_legion_name = true
	Net:send({newName=name,type = ServerEnum.CHANGE_NAME_TYPE.ALLIANCE},"bag","ChangeName")
end

function Legion:change_name_s2c(msg)
	if not self.change_legion_name then 
		return
	else
		self.change_legion_name = nil
	end
	if msg.err == 0 then
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message("改名成功")
	elseif msg.err == 1013 then
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message("名字已存在")
	end
end

function Legion:change_name_tip()
	local txt = "使用<color=red>改名卡</color>来修改您的军团名称\n"
	local txt2 = "点击输入新的军团名称"
	LuaItemManager:get_item_obejct("cCMP"):add_message(txt,
		function(a,b,c) 
			if #c~=0 then
				if not checkChar(c) then
					self:change_name_c2s(c)
				else
					gf_message_tips("军团的名字中包含违规内容，请重新输入!")
				end

			else
				gf_message_tips("军团名字不能为空！!")
			end
			if  self.schedule_name then
				self.schedule_name:stop()
				self.schedule_name = nil
			end
		end
	,nil,nil,false,0,txt2,true,nil,nil,nil,
		function(a,b,c)
			if  self.schedule_name then
				self.schedule_name:stop()
				self.schedule_name = nil
			end
		end
		,nil,nil)
	local inputField = GameObject.Find("check_input"):GetComponent("UnityEngine.UI.InputField")
	if not self.schedule_name then
		self.schedule_name = Schedule(handler(self, function()
			if inputField.text ~= "" then
				if LuaHelper.GetStringWidth(inputField.text,inputField.textComponent) > 135 or gf_get_string_length(inputField.text)>12 then
					-- inputField.text = inputFieldText
					inputField.text = string.sub(inputField.text,1,-2)
				else
					inputFieldText = inputField.text
					-- print("输入了",gf_get_string_length(inputField.text))
				end
			end
			end), 0.01)
	end
end