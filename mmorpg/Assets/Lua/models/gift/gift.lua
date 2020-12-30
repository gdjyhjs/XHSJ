--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-17 17:42:25
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local GiftReturn = require("models.gift.giftReturn")
local Gift = LuaItemManager:get_item_obejct("gift")
--UI资源
Gift.assets=
{
    View("giftView", Gift) 
}

--点击事件
function Gift:on_click(obj,arg)
	self:call_event("Gift_view_on_click",false,obj,arg)
	return true
end

--每次显示时候调用
function Gift:on_showed()

end
--初始化函数只会调用一次
function Gift:initialize()
	self.auto_buy = false
end

function Gift:init()
	self.need_get_friend_list = true
	self.send_player_info ={}
	local data =  ConfigMgr:get_config("goods")
	self.gift_data = {}
	for k,v in pairs(data) do
		if v.shop_type == ClientEnum.SHOP_TYPE.GIFT then
			self.gift_data[#self.gift_data+1] = copy(data[k])
		end
	end
	for k,v in pairs(self.gift_data) do
		v.amount = LuaItemManager:get_item_obejct("bag"):get_item_count(v.item_code)
		v.effect = ConfigMgr:get_config("item")[v.item_code].effect[1]
		v.overlay = ConfigMgr:get_config("item")[v.item_code].overlay
	end
	local sortFunc = function(a,b)
		return a.goods_id > b.goods_id
    end
    table.sort(self.gift_data,sortFunc)
    gf_print_table(self.gift_data,"礼物")
    self.default_select = self.gift_data[1].goods_id
	for k,v in pairs(self.gift_data) do  -- 默认
		if self.default_cur_select  then 
			if self.default_cur_select == v.item_code or self.default_cur_select == ConfigMgr:get_config("item")[v.item_code].rel_code then
				self.default_select = v.goods_id
				return
			end
		else
			if v.amount ~= 0 then
				self.default_select = v.goods_id
				return
			end
		end
	end
end

function Gift:show_view(player_info,r_id)
	-- if 
	print("礼物",type(player_info) )
	print("礼物",player_info)
	self.default_cur_select = r_id
	if type(player_info) == "table" then
		self.select_player_info = player_info
	elseif type(player_info) == "number" then
		self.select_player_info ={roleId = player_info}
	end
	self.first_player = player_info
	local p_id = LuaItemManager:get_item_obejct("game").role_id
	if not self.select_player_info or self.select_player_info.roleId ~= p_id  then
		Gift:add_to_state()
	else
		LuaItemManager:get_item_obejct("floatTextSys").assets[1]:add_leftbottom_broadcast("不能给自己送礼物")
	end
end

function Gift:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("friend")) then
		if id2 == Net:get_id2("friend","GiveFlowerR")  then
			gf_print_table(msg,"礼物返回给赠送者")
			print("礼物err",msg.err)
			self:give_flower_s2c(msg)
		elseif id2 == Net:get_id2("friend","GetFlowerNoticeR")  then
			gf_print_table(msg,"礼物推送给受赠者")
			self:get_flower_notice_s2c(msg)
		elseif id2 == Net:get_id2("friend","GetFriendListR")  then
			gf_print_table(msg,"礼物获取好友列表")
			if self.need_get_friend_list then
				self:get_friend_list_s2c(msg)
			end
		elseif id2 == Net:get_id2("friend","FlowerEffectBroadcastR")  then
			gf_print_table(msg,"礼物鲜花特效广播给附近玩家")
			self:flower_effect_broadcast_s2c(msg)
		end
	elseif id1==ClientProto.VoiceMessageR then
		if self.need_get_friend_list then
      		gf_print_table(msg,"语音消息转文字结果")
      		 self.assets[1]:update_comments_box(msg.text) 
      	end
	end
end

--返回给赠送者
function Gift:give_flower_s2c(msg)
	if msg.err == 0 then
		if self.send_player_info.content2 ~= nil then
			LuaItemManager:get_item_obejct("chat"):send_give_flower(self.send_player_info.roleId,self.send_player_info.content1.."%s")
			local txt = require("models.chat.chatTools"):chat_msg_modification(self.send_player_info.content2)
			LuaItemManager:get_item_obejct("chat"):chat_c2s(self.send_player_info.roleId,txt)
		else
			LuaItemManager:get_item_obejct("chat"):send_give_flower(self.send_player_info.roleId,self.send_player_info.content1.."%s")
		end
		if self.assets[1] then
			self.assets[1]:refresh_left(self.left_data)
			local count1 = LuaItemManager:get_item_obejct("bag"):get_item_count(self.assets[1].lastselect.data.item_code)
			self.assets[1].lastselect.data.amount = count1
			print("礼物",self.assets[1].lastselect)
			self.assets[1].lastselect:Get("count").text = count1
			if msg.intimacy ~= 0 then
				self.assets[1].leftselect.data.not_friend = false
			end
			self.assets[1].leftselect.data.intimacy = msg.intimacy
			-- self.assets[1]:refresh_right(self.right_data)
		end
		-- self.assets[1]:dispose()
	end
end

--推送给受赠者
function Gift:get_flower_notice_s2c(msg)
	local data = ConfigMgr:get_config("item")[msg.flowerCode]
	self.send_flower_data = { roleId=msg.roleId , name = msg.name, head = msg.head, level =msg.level } 
	local f_color = ConfigMgr:get_config("color")[data.color].color
	self.return_txt = "向你赠送了"..msg.num.."朵<color="..f_color..">"..data.name.."</color>，引来了无数的羡慕目光，彼此的关系更加亲密了，快去感谢对方吧"
	local p_id = LuaItemManager:get_item_obejct("game").role_id
	-- local data = ConfigMgr:get_config("item")[self.current_flower]
	LuaItemManager:get_item_obejct("battle"):remove_model_effect( p_id, ClientEnum.EFFECT_INDEX.FLOWER)
	LuaItemManager:get_item_obejct("battle"):add_model_effect(p_id, data.effect_ex[1], ClientEnum.EFFECT_INDEX.FLOWER)
	-- self.current_flower = msg.flowerCode
	-- GiftReturn(self)
end
--赠送鲜花
function Gift:give_flower_c2s(r_id,f_color,amount,tf)
	print("礼物r_id",r_id)
	print("礼物f_color",f_color)
	print("礼物amount",amount)
	print("礼物tf",tf)
	Net:send({  roleId = r_id,
				flowerColor = f_color,
				num = amount,
				autoBuy = tf	     },"friend","GiveFlower")
end
--请求获取好友列表
function Gift:get_friend_list_c2s()
	Net:send({},"friend","GetFriendList")
end
function Gift:get_friend_list_s2c(msg)
	local friend_data = {}
	-- friend_data[1] = self.select_player_info   --好友消息或者是非好友消息
	local notfriend = true
	if msg.list ~= nil then
		local data = msg.list
		local sortFunc = function(a,b)
			if a.intimacy == b.intimacy then
				if a.level == b.level then
					if a.power == b.power then
						return a.roleId > b.roleId
					end
					return a.power > b.power
				end
				return a.level > b.level
			end
			return a.intimacy > b.intimacy
   	 	end
    	table.sort(data,sortFunc)
		if self.select_player_info == nil then
			self.select_player_info = data[1] 
		end
		for k,v in pairs(data) do
			if v.logoutTm == 0 then 
				if v.roleId ~= self.select_player_info.roleId  then
					friend_data[#friend_data+1] = v
				else
					self.select_player_info = v   --好友消息
					notfriend = false
				end
			end
		end
	end
	if notfriend and self.select_player_info then --非好友
		self.select_player_info.not_friend = true
	end
    self.left_data = {}
    if self.select_player_info then
    	for i=1 ,#friend_data+1 do
    		if i == 1 then
    			self.left_data[#self.left_data+1] = self.select_player_info
    		else
    			self.left_data[#self.left_data+1] = friend_data[i-1]
    		end
   		end
   	end
    gf_print_table(self.left_data,"礼物左边列表")
    if #self.left_data ~= 0 then
    	self.default_left_select = self.left_data[1].roleId
    else
    	self.default_left_select = nil
    end
    self.assets[1]:refresh_left(self.left_data)
end

--鲜花特效广播给附近玩家
function Gift:flower_effect_broadcast_s2c(msg)
	local data = ConfigMgr:get_config("item")[msg.flowerCode]
	print("礼物特效",data.name)
	LuaItemManager:get_item_obejct("battle"):remove_model_effect( msg.roleId, ClientEnum.EFFECT_INDEX.FLOWER)
	LuaItemManager:get_item_obejct("battle"):add_model_effect(msg.roleId, data.effect_ex[1], ClientEnum.EFFECT_INDEX.FLOWER)
end

-- function Gift:delay_show_effect()
-- 	if self.current_flower then
-- 		local p_id = LuaItemManager:get_item_obejct("game").role_id
-- 		local data = ConfigMgr:get_config("item")[self.current_flower]
-- 		LuaItemManager:get_item_obejct("battle"):remove_model_effect( p_id, ClientEnum.EFFECT_INDEX.FLOWER)
-- 		LuaItemManager:get_item_obejct("battle"):add_model_effect(p_id, data.effect_ex[1], ClientEnum.EFFECT_INDEX.FLOWER)
-- 		self.current_flower = nil
-- 	else
-- 		return
-- 	end
-- end

function Gift:on_press_down(obj,eventData)
    print("礼物界面按下",obj,eventData)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "btn_gift_record" then
        LuaItemManager:get_item_obejct("chat"):start_recording(Enum.CHAT_CHANNEL.END,eventData.position)
    end
    return true
end

function Gift:on_drag(obj,position)
    print("礼物界面按住",obj,position)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "btn_gift_record" then
        LuaItemManager:get_item_obejct("chat"):on_recording(Enum.CHAT_CHANNEL.END,position)
    end
    return true
end

function Gift:on_press_up(obj,eventData)
    print("礼物界面弹起",obj,eventData)
    local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
    if cmd == "btn_gift_record" then
        LuaItemManager:get_item_obejct("chat"):stop_recording(Enum.CHAT_CHANNEL.END,eventData.position)
    end
    return true
end
