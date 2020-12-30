--[[--
--
-- @Author:Seven
-- @DateTime:2017-07-17 17:42:19
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local GiftView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "gift.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function GiftView:on_asset_load(key,asset)
	self.item_obj:init()
	self:init_ui()
	self:register()
	self.item_obj:get_friend_list_c2s()
	self:init_info()
end
function GiftView:init_ui()
	self.left = self.refer:Get("left")
	self.right = self.refer:Get("right")
	self:init_left()
	self:init_right()
	self:refresh_right(self.item_obj.gift_data)
	self.refer:Get("checkmark"):SetActive(self.item_obj.auto_buy)
end
function GiftView:register()
	self.item_obj:register_event("Gift_view_on_click",handler(self,self.on_click))
end
function GiftView:init_info()
	self.send_flo_amount = 1
end

function GiftView:on_click(item_obj,obj,arg)
	local  cmd  = obj.name
	if cmd == "closeSocialBtn" then
		Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		self:dispose()
	elseif cmd == "flower_item(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_right_position(arg)
	elseif cmd == "friend_item(Clone)" then
	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:select_left_position(arg)
	elseif cmd == "btn_down" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:math_gift_amount(arg,false)
	elseif cmd == "btn_up" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:math_gift_amount(arg,true)
	elseif cmd == "btn_one_key" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj.auto_buy = not self.item_obj.auto_buy
		arg:SetActive(self.item_obj.auto_buy)
	elseif cmd == "btn_amount" then 
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:show_number_keyboard(arg)
	elseif cmd == "btn_give_present" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:send_gift()
	elseif cmd == "btn_flower" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_set_click_prop_tips(obj,data.item_code)
	elseif cmd == "btn_expression" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		LuaItemManager:get_item_obejct("chat"):open_emoji_ui(self.right:Get("comments_box"),Enum.CHAT_CHANNEL.END,ClientEnum.EMOJI_TYPE.EMOJI)
	end
end

function GiftView:on_receive(msg,id1,id2,sid)
	if id1==Net:get_id1("shop") then
    	if id2== Net:get_id2("shop", "BuyR") then
    		if self.buy_flower then
    			if msg.err == 0 then
    				local count1 = LuaItemManager:get_item_obejct("bag"):get_item_count(self.lastselect.data.item_code) --现有的
    				local count3 = self.lastselect.data.amount --以前背包
    				if self.leftselect.data.intimacy == 0 then
    					self.lastselect.data.amount =count1
    					self.lastselect:Get("count").text = count1
    					LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message("你和<color=#B01FE5>"..self.leftselect.data.name.."</color>不是好友，送礼不会增加亲密度，是否继续送礼？",
    						function() 
    							self:auto_send_gift(count1)
    							self:refresh_left(self.left_data)
    							end,
    							function()
    								end,"送礼","取消")
    				else
    					self:auto_send_gift(count1)
    					self:refresh_left(self.left_data)
    				end
    				self.send_flo_amount  = count1
    				self.right:Get("goldCountTxt").text = count1
    				self.buy_flower = false
     	 		end
     	 	end
    	end
    end
end
---------------------------------------------左边列表-------------------------------------------------
function GiftView:init_left()
	self.scroll_left_table = self.left:Get("Content")
	self.scroll_left_table.onItemRender = handler(self,self.update_left_item)
end

function GiftView:refresh_left(data)
	self.scroll_left_table.data = data
	self.scroll_left_table:Refresh(0, - 1) --显示列表
end

function GiftView:update_left_item(item,index,data)
	item:Get("friend_name").text = data.name
	print("礼物头像",data.head)
	gf_set_head_ico(item:Get("head_icon"),data.head)
	item:Get("level_text").text = data.level
	if data.intimacy == 0 then
		item:Get("txt_friend"):SetActive(false)
		item:Get("not_friend"):SetActive(true)
	else
		item:Get("txt_friend"):SetActive(true)
		item:Get("not_friend"):SetActive(false)
		item:Get("intimacy_value").text = data.intimacy
	end
	if data.vipLevel and data.vipLevel>0 then
		item:Get("vipLvBg"):SetActive(true)
		item:Get("vipText").text = data.vipLevel
	else
		item:Get("vipLvBg"):SetActive(false)
	end
	if self.item_obj.default_left_select and self.item_obj.default_left_select == data.roleId and  self.leftselect ==nil then
		self.leftselect = item
		self:select_left_position(item)
	end
end
--选择
function GiftView:select_left_position(item,tf)
	self.leftselect:Get("img_select"):SetActive(false)
	item:Get("img_select"):SetActive(true)
	self.leftselect = item
end
-----------------------------------------------------------------------------------------------------
---------------------------------------------右边花列表------------------------------------------------
function GiftView:init_right()
	self.scroll_right_table = self.right:Get("content")
	self.scroll_right_table.onItemRender = handler(self,self.update_right_item)
end

function GiftView:refresh_right(data)
	self.scroll_right_table.data = data
	self.scroll_right_table:Refresh(0, - 1) --显示列表
end

function GiftView:update_right_item(item,index,data)
	gf_set_item(data.item_code,item:Get("icon"),item:Get("btn_flower"))
	gf_set_click_prop_tips(item:Get("btn_flower").gameObject,data.item_code)
	item:Get("txt_flower_name").text = data.name
	item:Get("goldCountTxt").text = data.offer
	item:Get("count").text =data.amount
	if self.item_obj.default_select == data.goods_id and  self.lastselect == nil then
		self.lastselect = item
		self:select_right_position(item)
	end
end
--选择
function GiftView:select_right_position(item,tf)
	self.lastselect:Get("img_select"):SetActive(false)
	item:Get("img_select"):SetActive(true)
	self.lastselect = item
	self.flo_max_amount = LuaItemManager:get_item_obejct("mall"):get_goods_purchasing_power(item.data.goods_id)+item.data.amount
	-- if self.send_flo_amount >= self.flo_max_amount then 
	-- 	self.send_flo_amount = self.flo_max_amount
	-- end
	self.right:Get("goldCountTxt").text = self.send_flo_amount
	self.right:Get("txt_all_value").text = self.send_flo_amount * item.data.effect
end
-----------------------------------------------------------------------------------------------------
--计算鲜花的数量
function GiftView:math_gift_amount(text,tf)
	if tf then
		if self.send_flo_amount >= self.flo_max_amount then 
			self.send_flo_amount = 1
		else
			self.send_flo_amount =  self.send_flo_amount + 1
		end
		text.text = self.send_flo_amount 
		self.right:Get("txt_all_value").text = self.send_flo_amount * self.lastselect.data.effect
	else
		if self.send_flo_amount <= 1 then 
			self.send_flo_amount =  self.flo_max_amount
		else
			self.send_flo_amount =  self.send_flo_amount - 1
		end
		text.text = self.send_flo_amount
		self.right:Get("txt_all_value").text = self.send_flo_amount * self.lastselect.data.effect
	end
end
function GiftView:show_number_keyboard(text)
	local exit_kb = function(result)
		result = tonumber(result) or 1
		if result == 0 then
		 	result = 1
		end
		self.send_flo_amount = result

		text.text = self.send_flo_amount
		self.right:Get("txt_all_value").text = self.send_flo_amount * self.lastselect.data.effect
	end
	local num =  LuaItemManager:get_item_obejct("mall"):get_goods_purchasing_power(self.lastselect.data.goods_id)+self.lastselect.data.amount
	if num > self.lastselect.data.overlay then
		num = self.lastselect.data.overlay
	end
	LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(text,num,1,nil,nil,nil,text.text,exit_kb,nil)
end

function GiftView:update_comments_box(text)
	print("礼物录音",text)
	self.right:Get("comments_box").text = self.right:Get("comments_box").text .. text
end
--赠送
function GiftView:send_gift()
	if self.send_flo_amount <=self.flo_max_amount or self.send_flo_amount <= self.lastselect.data.amount then
		if self.lastselect.data.amount < self.send_flo_amount and not self.item_obj.auto_buy then
			self.buy_flower = true
			gf_create_quick_buy(self.lastselect.data.item_code,self.send_flo_amount-self.lastselect.data.amount)
		else
			if self.leftselect then
				if self.leftselect.data.intimacy == 0 then
					LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message("你和<color=#B01FE5>"..self.leftselect.data.name.."</color>不是好友，送礼不会增加亲密度，是否继续送礼？",
						function() 
							self:auto_send_gift(self.send_flo_amount)
							end,
							function()
								end,"送礼","取消")
				else
					self:auto_send_gift(self.send_flo_amount)
				end
			else
				local txt = gf_localize_string("请先添加好友")
				LuaItemManager:get_item_obejct("floatTextSys").assets[1]:add_leftbottom_broadcast(txt)
			end
		end
	else
		local talk = "余额不足,当前元宝只能购买<color=#B01FE5>"..self.flo_max_amount.."</color>朵"..self.lastselect.data.name
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(talk,function() gf_open_model(ClientEnum.MODULE_TYPE.KRYPTON_GOLD) end,nil,"前往充值","容我三思")
	end
end

function GiftView:auto_send_gift(f_num)
	local data = self.leftselect.data
	local flo_amount = ConfigMgr:get_config("item")[self.lastselect.data.item_code].color
	self.item_obj:give_flower_c2s(data.roleId,flo_amount,f_num,self.item_obj.auto_buy)
	local flower_name = ConfigMgr:get_config("item")[self.lastselect.data.item_code].name
	local color =  ConfigMgr:get_config("color")[flo_amount].color
	local txt = "送你<color=#B01FE5>".. f_num .."</color>朵<color=".. color ..">"..flower_name.."</color>,希望我们的友谊天长地久"
	if  self.right:Get("txt_comments_box").text ~= "" then
		self.item_obj.send_player_info = {roleId=data.roleId,num =f_num ,name=data.name, content1 = txt,content2 = self.right:Get("txt_comments_box").text}
	else
		self.item_obj.send_player_info = {roleId=data.roleId,num =f_num ,name=data.name,content1 = txt,content2 = nil}
	end	-- body
end

-- 释放资源
function GiftView:dispose()
	self.lastselect = nil
	self.leftselect = nil
	self.item_obj.need_get_friend_list = nil
	self.item_obj:register_event("Gift_view_on_click",nil)
    self._base.dispose(self)
end

return GiftView

