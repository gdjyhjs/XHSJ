--[[--
--签到
-- @Author:Seven
-- @DateTime:2017-09-01 17:13:57
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SignDayView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "welfare_sign.u3d", item_obj) -- 资源名字全部是小写
    self.item_obj=item_obj
    self:set_level(UIMgr.LEVEL_STATIC)
end)
-- 资源加载完成
function SignDayView:on_asset_load(key,asset)
	self:init_ui()
	self:init_info()
end

function SignDayView:init_ui()
	self.scroll_right_table = self.refer:Get("Content")
	self.scroll_right_table.onItemRender = handler(self,self.update_right_item)
	StateManager:register_view(self)
	self.img_award = self.refer:Get("img_award")
	self.keep_day_text = self.refer:Get("keep_day_text")
	self.award_day_text = self.refer:Get("award_day_text")
	self.get_award_btn = self.refer:Get("get_award_btn")
end


--初始化信息
function SignDayView:init_info()
	self.cur_down_num = self.item_obj:find_cur_award(self.item_obj.keep_sign_data)
	self:refresh_right(self.item_obj.sign_data)
	self:update_down(self.cur_down_num)
	self:sign_left_show()
end
--更新信息
function SignDayView:update_info()
	self:refresh_right(self.item_obj.sign_data)
	self:update_down(self.cur_down_num)
	if self.show_effect then
		self.refer:Get(13):SetActive(true)
		self.effect_cd = Schedule(handler(self, function()
						self.refer:Get(13):SetActive(false)
						self.show_effect = false
						self.effect_cd:stop()
						self.effect_cd = nil
					end), 0.5) 
	end
end

function SignDayView:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "get_award_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:get_keep_award()
	elseif cmd == "btn_left" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.cur_down_num == 1 then
			self:update_down(self.cur_down_num)
		else
			self.cur_down_num = self.cur_down_num -1
			self:update_down(self.cur_down_num)
			self:sign_left_show()
		end
	elseif cmd == "btn_right" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if self.cur_down_num == #self.item_obj.keep_sign_data then
			self:update_down(self.cur_down_num)
		else
			self.cur_down_num = self.cur_down_num + 1
			self:update_down(self.cur_down_num)
			self:sign_left_show()
		end
	elseif cmd == "sign_item(Clone)" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:sign_today(arg)
	end
end

function SignDayView:sign_left_show()
	if self.cur_down_num == 1 then
		self.refer:Get(11):SetActive(false)
	elseif self.cur_down_num == #self.item_obj.keep_sign_data then
		self.refer:Get(12):SetActive(false)
	else
		self.refer:Get(11):SetActive(true)
		self.refer:Get(12):SetActive(true)
	end
end


--签到
function SignDayView:sign_today(item)
	if item.data.today then
		self.item_obj:drag_today_gift_c2s()
		return
	end
end
--更新右边信息
function SignDayView:update_down(num)
	self:update_down_award(self.item_obj.keep_sign_data[num])
	self:update_keep_sign(self.item_obj.keep_sign_data[num].days)
end

function SignDayView:get_keep_award()
	self.show_effect = true
	self.item_obj:drag_accmulate_gift_c2s(self.item_obj.keep_sign_data[self.cur_down_num].days)
end

--设置累计登录4项奖励和图标
function SignDayView:update_down_award(data)
	local tb = ConfigMgr:get_config("item")
	for k,v in pairs(data.gain_item) do
		local item = self.refer:Get("award_item"..k)
		if tb[v[1]].bind ==1 then
			item:Get("binding"):SetActive(true)
		else
			item:Get("binding"):SetActive(false)
		end
		gf_set_item( v[1], item:Get(2), item:Get(1))
		item:Get(3).text = v[2]
		gf_set_click_prop_tips(item.gameObject,v[1])
	end
	self.refer:Get("award_day_text").text =data.days
	if data.open then
		self.refer:Get("get_award_btn"):Get(1).text = gf_localize_string("已领取")
		self.refer:Get("get_award_btn"):Get(2):SetActive(true)
		self.refer:Get("img_award1").gameObject:SetActive(false)
		self.refer:Get("img_award2").gameObject:SetActive(true)
		gf_setImageTexture(self.refer:Get("img_award2"),data.open_icon)
	elseif data.open == false then
		self.refer:Get("img_award1").gameObject:SetActive(true)
		self.refer:Get("img_award2").gameObject:SetActive(false)
		self.refer:Get("get_award_btn"):Get(1).text = gf_localize_string("领取")
		self.refer:Get("get_award_btn"):Get(2):SetActive(false)
		gf_setImageTexture(self.refer:Get("img_award1"),data.unlock_icon)
	else
		self.refer:Get("img_award1").gameObject:SetActive(true)
		self.refer:Get("img_award2").gameObject:SetActive(false)
		self.refer:Get("get_award_btn"):Get(1).text = gf_localize_string("领取")
		self.refer:Get("get_award_btn"):Get(2):SetActive(true)
		gf_setImageTexture(self.refer:Get("img_award1"),data.unlock_icon)
	end
end

--设置当前累计签到次数
function SignDayView:update_keep_sign(day)
	self.refer:Get("keep_day_text").text =gf_localize_string("已签到 <color=#18a700>"..self.item_obj.keep_sign_day.."</color>/"..day .." 天")
end


function SignDayView:refresh_right(data)
	self.scroll_right_table.data = data
	self.scroll_right_table:Refresh(0 ,-1) --显示列表
end


function SignDayView:update_right_item(item,index,data)
	local tb = ConfigMgr:get_config("item")
	if tb[data.gain_item[1][1]].bind == 1 then
		item:Get("binding"):SetActive(true)
	else
		item:Get("binding"):SetActive(false)
	end
	gf_set_item( data.gain_item[1][1], item:Get("icon"), item:Get("bg"))
	item:Get("count").text = data.gain_item[1][2]
	if data.double_vip_level ~= 0 then
		item:Get("vip_up"):SetActive(true)
		item:Get("Text").text = gf_localize_string("<size= 16><color=#fff339>V"..data.double_vip_level.."</color></size>翻倍")
	end
	if data.open then
		item:Get("get_over"):SetActive(true)
	end
	if not data.today then
		gf_set_click_prop_tips(item.gameObject,data.gain_item[1][1])
		item:Get("30000001"):SetActive(false)
	else
		item:Get("30000001"):SetActive(true)
	end
end

function SignDayView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("bag")) then
		if id2 == Net:get_id2("bag","DragTodayGiftR") or id2 == Net:get_id2("bag","DragAccmulateGiftR")then--累计签到
			if msg.err == 0 then
				self:update_info()
			end
		end
	end
end


-- 释放资源
function SignDayView:dispose()
	if self.effect_cd then
		self.show_effect = false
		self.effect_cd:stop()
		self.effect_cd = nil
	end
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return SignDayView

