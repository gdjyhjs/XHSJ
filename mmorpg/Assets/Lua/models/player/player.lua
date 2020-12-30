--[[--
--
-- @Author:Seven
-- @DateTime:2017-05-15 12:24:08
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PlayerEnum = require("models.player.playerEnum")

local Player = LuaItemManager:get_item_obejct("player")
--UI资源
Player.assets=
{
    View("playerBaseView", Player) 
}

--点击事件
function Player:on_click(obj,arg)
	self:call_event("on_clict", false, obj, arg)
	return true
end

--每次显示时候调用
function Player:on_showed( ... )

end

--初始化函数只会调用一次
function Player:initialize()
	self.red_pos = {}
	self.other_player_info={}
	self.base_page = 1
end

function Player:select_player_page(num,b,c,d)
	print("设置选择页签",num,b,c,d)
	self.base_page = num or 1
	self.page2 = b
	self.page3 = c
	self.page4 = d
end

--服务器返回
function Player:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1("base"))then
        if(id2== Net:get_id2("base", "OtherPlayerInfoR"))then
			print("Player服务器返回 msg, id1, id2, sid   ",msg, id1, id2, sid)
            self:other_player_info_s2c(msg,sid)
        end
	elseif id1 == ClientProto.UIRedPoint then -- 红点
		if msg.module == ClientEnum.MODULE_TYPE.PLAYER_INFO then
			local key = (msg.a or "")..(msg.b or "")..(msg.c or "")..(msg.d or "")
			self.red_pos[key] = msg.show or nil
			self:have_red_point()
    	end
    elseif(id1==Net:get_id1("bag"))then
        if(id2== Net:get_id2("bag", "ChangeNameR"))then
            self:change_name_s2c(msg)
        end
    end
end

function Player:have_red_point()
	-- 根据变强通知设置红点start
    local show = (function()
	                    for k,v in pairs(self.red_pos) do
	                    	if v then
	                        	return true
	                        end
	                    end
	                end)()
	show = show or LuaItemManager:get_item_obejct("officerPosition"):is_award()
	show = show or LuaItemManager:get_item_obejct("gameOfTitle"):is_redpoint()
	Net:receive({btn_id=ClientEnum.MAIN_UI_BTN.HEAD, visible=show or false}, ClientProto.ShowHotPoint)
end

-- 查看其它玩家信息
function Player:other_player_info_c2s( guid ,sid )
	if guid ~= LuaItemManager:get_item_obejct("game").role_id then
		local msg = {guid = guid}
		gf_print_table(msg, "发送查看其他玩家：")
		print("sid = ",sid)
		Net:send(msg, "base", "OtherPlayerInfo",sid)
	end
end

--sid 看玩家枚举 PlayerEnum.APPLY_DATA_USE
function Player:other_player_info_s2c( msg,sid )
	print(">>>查看其他玩家信息返回 sid = ",sid)
	gf_print_table(msg,">>>查看其他玩家信息返回")
	if msg.err == 0 then
		self.other_player_info[msg.info.roleId] = msg.info
		if sid == PlayerEnum.APPLY_DATA_USE.MAINUI_HEAD then
			print("更新主界面头像显示")
			LuaItemManager:get_item_obejct("mainui").assets[1]:set_other_player_head_visible(true, msg.info.roleId, msg.info)
		elseif sid == PlayerEnum.APPLY_DATA_USE.OTHER_PLAYER then
			print("更新其他玩家信息")
			self:show_other_player(msg.info.roleId,true)
		elseif sid == PlayerEnum.APPLY_DATA_USE.PLAYER_TIPS then
			print("更新玩家Tips信息")
			self:show_player_tips(msg.info.roleId,true)
		end
	end
end

--显示其他玩家信息
function Player:show_other_player(role_id,is_new_info)
	if self.other_player_info[role_id] then
		require("models.player.otherPlayerView")(Player, self.other_player_info[role_id])
		return
	end
	if not is_new_info then
		self:other_player_info_c2s(role_id,PlayerEnum.APPLY_DATA_USE.OTHER_PLAYER)
	end
end

--[[玩家tips
 role_id,
 is_new_info, --是否新信息 如果不是新信息会向服务器请求数据
 pos,pivot,anchor
 ]]
function Player:show_player_tips(role_id,is_new_info)
	if not is_new_info then
		print("tips 向服务器申请数据")
		self:other_player_info_c2s(role_id,PlayerEnum.APPLY_DATA_USE.PLAYER_TIPS)
	elseif  self.other_player_info[role_id] then
		print("tips 显示")
		local view = self:get_player_tips_ui()
		view:set_player_data(self.other_player_info[role_id])
		-- require("models.player.playerTips")(Player, self.other_player_info[role_id])
	end
end

function Player:get_player_tips_ui()
	if not self.player_tips_ui then
		self.player_tips_ui = View("playerTips",self)
	end
	return self.player_tips_ui
end

--获取其他玩家简略装备信息
function Player:other_player_simple_equip(roleId)
	Net:send({roleId=roleId},"bag","OtherPlayerSimpleEquip")
end

--玩家改名字
function Player:change_name_c2s(name)
	self.change_player_name = true
	gf_mask_show(true)
	Net:send({newName=name,type = ServerEnum.CHANGE_NAME_TYPE.PLAYER},"bag","ChangeName")
	self.change_name = name
end

function Player:change_name_s2c(msg)
	if not self.change_player_name then 
		return
	else
		self.change_player_name = nil
	end
	if msg.err == 0 then
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message("改名成功")
		LuaItemManager:get_item_obejct("game"):setName(self.change_name)
		Net:receive({}, ClientProto.refreshPlayerName)
		local player =  LuaItemManager:get_item_obejct("battle"):get_character()
		player.blood_line:set_name(self.change_name)
	elseif msg.err == 1013 then
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message("名字已存在")
		LuaItemManager:get_item_obejct("game"):setName(self.change_name)
		Net:receive({}, ClientProto.refreshPlayerName)
		local player =  LuaItemManager:get_item_obejct("battle"):get_character()
		player.blood_line:set_name(self.change_name)
	end
	gf_mask_show(false)
end

function Player:change_name_tip()
	local txt = "使用<color=red>改名卡</color>修改您的昵称\n"
	local txt2 = "点击输入您的新名字"
	local inputFieldText = ""

	LuaItemManager:get_item_obejct("cCMP"):add_message(txt,
		function(a,b,c) 
			if #c~=0 then
				if not checkChar(c) then
					self:change_name_c2s(c)
				else
					gf_message_tips("您的名字中包含违规内容，请重新输入!")
				end

			else
				gf_message_tips("角色名字不能为空！")
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
			end), 0.02)
	end
end