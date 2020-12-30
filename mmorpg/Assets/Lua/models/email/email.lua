--[[--
--
-- @Author:HuangJuNShan
-- @DateTime:2017-08-17 14:25:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local max_count = ConfigMgr:get_config( "t_misc" ).email.maxCount -- 最多显示50封数量
local max_second = ConfigMgr:get_config( "t_misc" ).email.validTime -- 最多存在时间：未读 
local warning_count = max_count*0.9 -- 警告数量

local Email = LuaItemManager:get_item_obejct("email")
--UI资源
Email.assets=
{
    View("emailView", Email) 
}

--点击事件
function Email:on_click(obj,arg)
	self:call_event("email_on_click", false, obj, arg)
	return true
end

--初始化函数只会调用一次
function Email:initialize()
	self.left_get_email_count = 0 -- 剩余获取的邮件数量
	self.emailList = {} -- 邮件列表
end

--服务器返回
function Email:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("email") then
		if(id2== Net:get_id2("email", "GetEmailListR"))then
			gf_print_table(msg,"服务器返回：获取邮件协议")
			self:get_email_list_s2c(msg)
		elseif(id2== Net:get_id2("email", "ReadEmailR"))then
			gf_print_table(msg,"服务器返回：读取邮件")
			self:read_email_s2c(msg)
		elseif(id2== Net:get_id2("email", "GetEmailRewardR"))then
			gf_print_table(msg,"服务器返回：领取多封邮件奖励")
			self:get_email_reward_s2c(msg,sid)
		elseif(id2== Net:get_id2("email", "DeleteEmailR"))then
			gf_print_table(msg,"服务器返回：删除多封邮件")
			self:delete_email_s2c(msg,sid)
		elseif(id2== Net:get_id2("email", "UpdateNewEmailR"))then
			gf_print_table(msg,"服务器返回：新邮件推送")
			self:update_new_email_s2c(msg)
		elseif(id2== Net:get_id2("email", "LoginGetEmailInfoR"))then
			gf_print_table(msg,"wtf receive LoginGetEmailInfoR")
			gf_print_table(msg,"服务器返回：上线获取邮箱状态")
			self:login_get_email_info_s2c(msg)
		elseif(id2== Net:get_id2("email", "CheckDeleteR"))then
			gf_print_table(msg,"服务器返回：自动删除返回")
			self:check_delete_s2c(msg)
		end
	end
end

---------------------邮件协议------------------------------
--获取邮件列表
function Email:get_email_list_c2s()
	print("获取邮件列表")
	Net:send({},"email","GetEmailList")
end
--读取邮件,已读邮件不需要再调用此接口
function Email:read_amail_c2s(guid)
	print("读取多封邮件",guid)
	Net:send({guid=guid},"email","ReadEmail")
end
--领取邮件奖励
function Email:get_email_reward_c2s(guids)
	guids = type(guids) == "table" and guids or {guids}
	local msg = {guids=guids}
	gf_print_table(msg,"发送领取邮件奖励协议")
	Net:send(msg,"email","GetEmailReward")
end
--删除邮件
function Email:delete_email_c2s(guids)
	guids = type(guids) == "table" and guids or {guids}
	Net:send({guids=guids},"email","DeleteEmail")
end

--上线获取邮箱状态
function Email:login_get_email_info_c2s()
	Net:send({},"email","LoginGetEmailInfo")
end

--为避免打开界面期间删除了正在读的邮件 现在是前端打开或关闭邮件界面时 发送此协议让后端删除该删除的邮件
function Email:check_delete_c2s()
	Net:send({},"email","CheckDelete")
end

--获取邮件列表返回
function Email:get_email_list_s2c(msg)
	self.left_get_email_count = 0
	local list = msg.emails or {}
	table.sort(list,function(a,b) return a.time>b.time end)
	for i,v in ipairs(list) do
		self.emailList[#self.emailList+1] = v
	end
	self:red_point_change()
end

--读取邮件返回
function Email:read_email_s2c(msg)
	if msg.err==0 then
		for i,v in ipairs(self.emailList) do
			if v.guid == msg.guid then
				v.isRead = true
				break
			end
		end
		self:red_point_change()
	end
end

--领取邮件奖励
function Email:get_email_reward_s2c(msg)
	local get_list = {}
	for i,v in ipairs(msg.results or {}) do
		if v.err == 0 then
	    	get_list[v.guid] = v.err
		else
			gf_message_tips(Net:error_code(v.err))
		end
	end
	for i,v in ipairs(self.emailList) do
		if get_list[v.guid] then
			v.isRead = true
			v.isTaken = true
		end
	end
	self:red_point_change()
end

--删除多封邮件
function Email:delete_email_s2c(msg)
	local get_list = {}
	for i,v in ipairs(msg.results or {}) do
		if v.err == 0 then
	    	get_list[v.guid] = v.err
		else
			gf_message_tips(Net:error_code(v.err))
		end
	end
	for i=#self.emailList,1,-1 do
		local v = self.emailList[i]
		if get_list[v.guid] then
			v.type = nil
			table.remove(self.emailList,i)
		end
	end
	self:red_point_change()
end

--新邮件推送
function Email:update_new_email_s2c(msg)
	gf_message_tips("收到新邮件！")
	local list = msg.emailList
	table.sort(list,function(a,b) return a.time>b.time end)
	for i,v in ipairs(list) do
		table.insert(self.emailList,i,v)
	end
	if (#self.emailList+self.left_get_email_count)>=max_count then
		gf_message_tips("邮箱已满，请及时清理！")
	elseif (#self.emailList+self.left_get_email_count)>=warning_count then
		gf_message_tips("邮箱将满，请及时清理！")
	end
	self:red_point_change()
	self.have_new_email = true
	Net:receive({id=ClientEnum.MAIN_UI_BTN.NEW_EMAIL, visible=self.have_new_email,msg.offlineNew==1}, ClientProto.ShowOrHideMainuiBtn)
end

--上线获取邮箱状态
function Email:login_get_email_info_s2c(msg)
	self.have_red_point = msg.notReadOrItems==1
	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.MAIL, visible=self.have_red_point}, ClientProto.ShowHotPoint)

	self.have_new_email = msg.offlineNew==1
	Net:receive({id=ClientEnum.MAIN_UI_BTN.NEW_EMAIL, visible=self.have_new_email,msg.offlineNew==1}, ClientProto.ShowOrHideMainuiBtn)

	self.left_get_email_count = msg.totalCount or 0
end

--为避免打开界面期间删除了正在读的邮件 现在是前端打开或关闭邮件界面时 发送此协议让后端删除该删除的邮件
function Email:check_delete_s2c(msg)
	local get_list = {}
	for i,v in ipairs(msg.delList or {}) do
	    get_list[v] = v
	end
	for i=#self.emailList,1,-1 do
		local v = self.emailList[i]
		if get_list[v.guid] then
			v.type = nil
			table.remove(self.emailList,i)
		end
	end
	self:red_point_change()
end

-- 获取是否有红点
function Email:is_have_red_point()
	return self.have_red_point
end

-- 是否有新邮件
function Email:is_have_new_email()
	return self.have_new_email
end

-- 通知红点变化 社交红点
function Email:red_point_change()
	self.have_red_point = false
	for i,v in ipairs(self.emailList) do
		-- if v.reward and not v.isTaken or not v.isRead then
		if not v.isRead then
			self.have_red_point = true
			break
		end
	end
	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.MAIL, visible=self.have_red_point}, ClientProto.ShowHotPoint)
end