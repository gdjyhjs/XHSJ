--[[--
--
-- @Author:Seven
-- @DateTime:2017-06-19 19:03:41
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local PlayerTips=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "information_tip.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function PlayerTips:on_asset_load(key,asset)
	self.init = true
	self:init_ui()
end

function PlayerTips:set_player_data(player_data)
	self.player_data = player_data
	if self.init then
		self:init_ui()
	end
end

function PlayerTips:init_ui()
	if not self.init or not self.player_data then
		return
	end
	self.ui = self.root

	self:set_info(self.player_data)

	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self, self.update_item)
	
	local data = 
	{
		{name = gf_localize_string("查看信息"), cb = function() 
			self.item_obj:show_other_player(self.player_data.roleId) 
		end},

		{name = gf_localize_string("赠送礼物"), cb = function() 
			 LuaItemManager:get_item_obejct("gift"):show_view(self.player_data)
		end},

		{name = gf_localize_string("拉黑名单"), cb = function()
			LuaItemManager:get_item_obejct("social"):black_friend_c2s(self.player_data.roleId)
		end},

		{name = gf_localize_string("发送信息"), cb = function() 
			LuaItemManager:get_item_obejct("chat"):open_private_chat_ui(self.player_data.roleId)
		end},
		
	}

	local social = LuaItemManager:get_item_obejct("social")
	if self.player_data.intimacy and self.player_data.intimacy>0 then
		data[#data+1] = {name = gf_localize_string("删除好友"), cb = function()
			social:delete_friend_c2s(self.player_data.roleId)
		end}
	else
		data[#data+1] = {name = gf_localize_string("加为好友"), cb = function()
			social:apply_friend_c2s(self.player_data.roleId)
		end}
	end



	local dh = 0
	print("-- 没有军团邀请权限，隐藏按钮")
	-- if LuaItemManager:get_item_obejct("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.ACCEPT_APPLY) then
	-- 	data[#data+1] = {name = gf_localize_string("邀请进团"), cb = function()

	-- 	end}
	-- end

	local isLeader = LuaItemManager:get_item_obejct("team"):isLeader()
	local is_my_teamer = LuaItemManager:get_item_obejct("team"):is_my_teamer(self.player_data.roleId)
	print("是否队长",isLeader)
	print("是否我的队员",is_my_teamer)
	if isLeader and is_my_teamer then
		data[#data+1] = {name = gf_localize_string("踢出队伍"), cb = function() 
			print("踢出队伍")
			LuaItemManager:get_item_obejct("team"):sendToKickMember(self.player_data.roleId)
		end}

		data[#data+1] = {name = gf_localize_string("升为队长"), cb = function()
			print("升为队长")
			LuaItemManager:get_item_obejct("team"):sendToChangeLeader(self.player_data.roleId)
		end}
	end
	if not is_my_teamer then
		data[#data+1] = {name = gf_localize_string("邀请入队"), cb = function() 
			--判断对方是否有队伍
			if self.player_data.teamId > 0 then
				gf_message_tips(gf_localize_string("对方已有队伍"))
				return
			end
			LuaItemManager:get_item_obejct("team"):sendToInvite(self.player_data.roleId)
		end}
	end
	if not isLeader then
		data[#data+1] = {name = gf_localize_string("申请入队"), cb = function() 
			if gf_getItemObject("team"):is_in_team() then
				gf_message_tips(gf_localize_string("已有队伍，无法申请。"))
				return
			end 
			LuaItemManager:get_item_obejct("team"):sendToJoinTeam(self.player_data.teamId)
		end}
	end

	local flag = false
	-- 战斗对比
	if flag then
		data[#data+1] = {name = gf_localize_string("战力对比"), cb = function() 
		end}
	end

	if flag then
		data[#data+1] = {name = gf_localize_string("邀请共乘"), cb = function() 
		end}
	end

	if flag then
		data[#data+1] = {name = gf_localize_string("查看摆摊"), cb = function() 
		end}
	end

	dh = math.ceil((11-#data)/2)*60

	local dh2 = dh-10
	self.refer:Get("bg1").transform.sizeDelta = Vector2(359, 463.5 - dh2)
	local position = self.refer:Get("bg1").transform.position
	position.y = position.y + dh2/2
	self.refer:Get("bg1").transform.position = position

	self.refer:Get("Scroll View").transform.sizeDelta = Vector2(359, 346 - dh)
	local position = self.refer:Get("Scroll View").transform.position
	position.y = position.y + dh/2
	self.refer:Get("Scroll View").transform.position = position


	self:refresh(data)

	self.is_init = true
end

function PlayerTips:refresh( data )
	self.scroll_table.data = data
	self.scroll_table:Refresh(-1,-1)
end

function PlayerTips:update_item( item, index, data )
	item:Get(1).text = data.name
end

function PlayerTips:set_info(info)
	if self.player_data==info and self.is_init then
		return
	else
		self.player_data=info
	end

	--玩家名字
	self.refer:Get("nameTxt").text = self.player_data.name

	self.refer:Get("level_text").text = self.player_data.level

	--玩家头像
	gf_set_head_ico(self.refer:Get("head_icon"),self.player_data.head)

	--军团
	self.refer:Get("legionTxt").text = self.player_data.allianceName or "暂无"

	--战力
	self.refer:Get("powerTxt").text = self.player_data.power
end

function PlayerTips:on_click(obj, arg)
	print("点击其他玩家tips按钮",obj)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "preItem(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		arg.data.cb()
	end

	self:dispose()
end

function PlayerTips:on_showed()
	StateManager:register_view( self )

end

function PlayerTips:on_hided()
	StateManager:remove_register_view( self )
end

-- 释放资源
function PlayerTips:dispose()
	self.init = nil
	self.item_obj.player_tips_ui = nil
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return PlayerTips