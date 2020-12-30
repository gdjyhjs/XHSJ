--[[--
-- 打坐
-- @Author:Seven
-- @DateTime:2017-06-26 12:31:39
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Sit = LuaItemManager:get_item_obejct("sit")
--UI资源
Sit.assets=
{
    View("sitView", Sit) 
}

--点击事件
function Sit:on_click(obj,arg)
	self:call_event("on_clict", false, obj, arg)
end

--每次显示时候调用
function Sit:on_showed( ... )

end

--初始化函数只会调用一次
function Sit:initialize()
	self._is_pair = false

	self.sit_level = ConfigMgr:get_config("t_misc").rest.player_level -- 可以打坐等级
end

function Sit:dispose()
	self.start_sit_time = nil
	self._is_pair = false
	Sit._base.dispose(self)
end

-- 是否可以打坐
function Sit:is_can_sit()
	if LuaItemManager:get_item_obejct("game"):getLevel() < self.sit_level or 
	   LuaItemManager:get_item_obejct("battle"):get_map_permissions(ServerEnum.MAP_FLAG.FORBID_REST) then
		return false
	end
	return true
end

-- 获取邀请列表
function Sit:get_invite_list()
	return self.can_invite_list
end

-- 是否处于打坐
function Sit:is_sit()
	return self.start_sit_time ~= nil
end

-- 获取打坐时间
function Sit:get_sit_time()
	if not self.start_sit_time then
		return 0
	end

	local time = Net:get_server_time_s() - self.start_sit_time
	if time < 0 then
		time = 0
	end
	return time
end

-- 中断邀请
function Sit:break_off_accept()
	if self.is_accept then
		self.is_accept = false
		self:b_refuse_a_invite_c2s(self.invite_role_id)
		self.invite_role_id = nil
	end
end

-- 是否是双人打坐
function Sit:is_pair()
	return self._is_pair
end

function Sit:set_pair( pair )
	self._is_pair = pair
	Net:receive(pair, ClientProto.ShowSitEffect)
end

function Sit:clear_temp_data()
	self.is_accept = false
	self.invite_role_id = nil
	self.inviter_data = nil
end

function Sit:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "StartRestR") then -- 开始打坐
			self:start_rest_s2c(msg)

		elseif id2 == Net:get_id2("scene", "EndRestR") then -- 取消打坐
			self:end_rest_s2c(msg)

		elseif id2 == Net:get_id2("scene", "NearRoleListR") then -- 可以邀请列表
			self:get_near_role_list_s2c(msg)

		elseif id2 == Net:get_id2("scene", "AcceptInviteRestR") then -- 接受返回
			self:assept_invite_rest_s2c(msg)

		elseif id2 == Net:get_id2("scene", "AcceptInviteRestAMsgR") then -- 有人接受邀请的推送
			self:assept_invite_rest_a_mag_s2c(msg)

		elseif id2 == Net:get_id2("scene", "SetAutoAcceptR") then -- 设置自动接受邀请
			self:set_auto_accept_s2c(msg)

		elseif id2 == Net:get_id2("scene", "GetAutoAcceptR") then -- 对方中断邀请返回
			gf_print_table(msg,"wtf receive GetAutoAcceptR")
			self:get_auto_accept_s2c(msg)

		elseif id2 == Net:get_id2("scene", "BeInvitedRestR") then -- 有人邀请你打坐推送
			print("有人邀请你打坐推送")
			Net:receive({id=ClientEnum.MAIN_UI_BTN.SIT, visible = true}, ClientProto.ShowOrHideMainuiBtn)

		elseif id2 == Net:get_id2("scene", "GetBeInviteListR") then -- 获取收到邀请列表
			self:get_be_invite_list_s2c(msg)

		elseif id2 == Net:get_id2("scene", "NoticeStartOrEndRest") then -- 通知开始或者结束双人打坐
			self:notice_start_or_end_rest_s2c(msg)

		end
	end

	if id1 == ClientProto.StarOrEndSit then -- 开始或者结束打坐
		if msg then -- 开始
			self:start_rest_c2s(self.invite_role_id)
		else -- 结束
			if not self.is_accept then -- 在打坐的时候接受打坐邀请，不发送结束打坐
				self:end_rest_c2s()
			end
		end

	elseif id1 == ClientProto.PlayerSelfBeAttacked then -- 被攻击，结束打坐
		self:end_rest_c2s()

	elseif id1 == ClientProto.PlayerSelfAttack then -- 攻击取消打坐
		self:end_rest_c2s()
		
	elseif id1 == ClientProto.PlayerAutoMove then
		self:end_rest_c2s()

	elseif id1 == ClientProto.JoystickStartMove or id1 == ClientProto.MouseClick then -- 开始移动摇杆
		self:break_off_accept()
		self:end_rest_c2s()

	end
end

-- 开始打坐
function Sit:start_rest_c2s(role_id)
	if not self:is_can_sit() then
		return
	end

	role_id = role_id or 0
	print("开始打坐",role_id)

	Net:send({ARoleId = role_id}, "scene", "StartRest")
end

function Sit:start_rest_s2c( msg )
	gf_print_table(msg, "开始打坐返回")
	
	if msg.err ~= 0 then
		return
	end

	self.start_sit_time = msg.startTimeStamp -- 时间搓
	self:set_pair(msg.ARoleId > 0)
end

-- 取消打坐
function Sit:end_rest_c2s()
	if not self:is_sit() then
		return
	end

	print("结束打坐")
	self.start_sit_time = nil
	Net:send({}, "scene", "EndRest")
end

function Sit:end_rest_s2c( msg )
	if msg.err ~= 0 then
		return
	end
	self.start_sit_time = nil
	self._is_pair = false
end

-- 获取附件可以邀请的玩家
function Sit:get_near_role_list_c2s()
	print("获取附件可以邀请的玩家")
	Net:send({}, "scene", "GetNearRoleList")
end

function Sit:get_near_role_list_s2c( msg )
	gf_print_table(msg, "获取附件可以邀请的玩家返回")
	self.can_invite_list = msg.roleList
end

-- 邀请打坐
function Sit:invite_rest_c2s( role_id )
	print("邀请打坐", role_id)
	Net:send({BRoleId=role_id}, "scene", "InviteRest")
end

function Sit:invite_rest_s2c( msg )
	if msg.err ~= 0 then
		return
	end

end

-- 一键邀请
function Sit:one_key_invite_near_c2s()
	Net:send({}, "scene", "OneKeyInviteNear")
end

function Sit:one_key_invite_near_s2c( msg )
	
end

-- 设置是否自动接受
function Sit:set_auto_accept_c2s( flag )
	Net:send({bIntAutoAccept = flag}, "scene", "SetAutoAccept")
end

function Sit:set_auto_accept_s2c( msg )
	self.is_auto_accept = msg.bIntAutoAccept == 1
end

-- 接受邀请
function Sit:assept_invite_rest_c2s( role_id )
	Net:send({ARoleId = role_id}, "scene", "AcceptInviteRest")
end

function Sit:assept_invite_rest_s2c( msg )
	gf_print_table(msg, "接受邀请返回")
	if msg.err ~= 0 then
		return
	end

	self.is_accept = true
	self.invite_role_id = msg.AInfo.roleId -- 邀请人的id
	self.inviter_data = msg.AInfo -- 邀请者的数据

	local battle_item = LuaItemManager:get_item_obejct("battle")

	local delay_cb = function() -- 延迟1帧去打坐，保证移动停止已经发给服务器
		LuaItemManager:get_item_obejct("horse"):send_to_ride(0)
		self:start_rest_c2s(self.invite_role_id)
	end

	function finish_cb() -- 寻路完成，发送双休协议
		delay(delay_cb, 0.034)
	end
	-- 自动寻路到邀请玩家
	battle_item:move_to(msg.mapId, msg.x, msg.y, finish_cb, 4)
end

-- 有人接受邀请的推送
function Sit:assept_invite_rest_a_mag_s2c( msg )
	gf_print_table(msg, "有人接受邀请的推送返回")
	gf_message_tips(gf_localize_string(msg.BRoleInfo.name.."接受了你的邀请"))
	self.accept_player_data = msg.BRoleInfo -- 接受请求玩家数据
end

-- 中途中断邀请
function Sit:b_refuse_a_invite_c2s( role_id )
	if not self:is_sit() then
		gf_message_tips(gf_localize_string("已拒绝邀请"))
	end
	Net:send({ARoleId = role_id}, "scene", "BRefuseAInvite")
end

-- 一键拒绝
function Sit:one_key_refuse_invite_c2s()
	Net:send({}, "scene", "OneKeyRefuseInvite")
end

function Sit:one_key_refuse_invite_s2c( msg )
	if msg.err ~= 0 then
		return
	end

	gf_message_tips(gf_localize_string("已拒绝邀请"))
end

-- 获取是否设置了自动接受
function Sit:get_auto_accept_c2s()
	Net:send({}, "scene", "GetAutoAccept")
end

function Sit:get_auto_accept_s2c( msg )
	self.is_auto_accept = msg.bIntAutoAccept == 1
end

-- 获取邀请列表
function Sit:get_be_invite_list_c2s()
	Net:send({}, "scene", "GetBeInviteList")
end

function Sit:get_be_invite_list_s2c( msg )
	gf_print_table(msg, "获取邀请列表返回")

	self.be_invite_list = msg.roleList
end

-- 通知开始或者结束双人打坐（对方通知)
function Sit:notice_start_or_end_rest_s2c( msg )
	gf_print_table(msg, "通知开始或者结束双人打坐（对方通知)")

	if msg.type == 1 then -- 开始双人打坐
		self:set_pair(true)
	elseif msg.type == 2 then -- 结束双人打坐
		self:set_pair(false)
		if msg.name then
			gf_message_tips(gf_localize_string(msg.name.."结束打坐"))
		end

	elseif msg.type == 0 then -- 对方应邀过来过程中取消
		self:set_pair(false)
		gf_message_tips(gf_localize_string(msg.name.."无法接受邀请"))

	elseif msg.type == 3 then -- 对方拒绝邀请
		gf_message_tips(msg.name..gf_localize_string("拒绝邀请"))
	end

	self.start_sit_time = msg.startTimeStamp -- 开始打坐时间
end




