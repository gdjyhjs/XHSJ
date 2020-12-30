--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-07 11:29:50
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local SignOnlineView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "welfare_online.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function SignOnlineView:on_asset_load(key,asset)
	self:init_ui()
	StateManager:register_view(self)
	self:init_info()
end

function SignOnlineView:init_ui()
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	self.today_online = self.refer:Get("today_online")
	self.all_online_time = self.refer:Get("all_online_time")
	self.all_online_gold = self.refer:Get("all_online_gold")
	self.cur_text = self.refer:Get(5)
	self.get_btn = self.refer:Get(6)
	gf_set_money_ico(self.refer:Get(7),ServerEnum.BASE_RES.BIND_GOLD)
end

function SignOnlineView:init_info()
	local now_time = Net:get_server_time_s()
	print("获取在线时长的礼包1T",now_time)
	if now_time - self.item_obj.cur_online <0 then
		self.item_obj.cur_online = now_time
	end
	if now_time - self.item_obj.cur_week_online <0 then
		self.item_obj.cur_week_online = now_time
	end
	self.today_online.text = gf_convert_time(now_time - self.item_obj.cur_online)
	local all_week_time = now_time - self.item_obj.cur_week_online
	self.all_online_time.text  = gf_convert_time(all_week_time)					
	self:refresh(self.item_obj.online_data)
	local level = LuaItemManager:get_item_obejct("game"):getLevel()
	local data =  ConfigMgr:get_config("t_misc").online_gift
	self.gold_up = data.week_limit
	self.gold_double = data.week_bind_gold
	self.s=Schedule(handler(self,self.countdown),1)
end

function SignOnlineView:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function SignOnlineView:update_item(item,index,data)
	data.index = index
	item:Get(4).text = gf_localize_string("在线".. data.time_seconds/60 .."分钟可领取")
	if data.open then
		item:Get(5).gameObject:SetActive(false)
		item:Get(6):SetActive(true)
		item:Get(7):SetActive(false)
		item:Get(8).gameObject:SetActive(false)
		gf_setImageTexture(item:Get(9),data.icon)
	elseif data.open == false then
		-- gf_setImageTexture(item:Get(9),data.open_icon)
		item:Get(5).gameObject:SetActive(false)
		item:Get(6):SetActive(true)
		item:Get(7):SetActive(true)
		item:Get(8).gameObject:SetActive(true)
		if data.get_id then
			gf_set_item(data.get_id, item:Get(2), item:Get(1))
			item:Get(3).text = data.get_count
			gf_set_click_prop_tips(item:Get(8).gameObject,data.get_id)
			local tb = ConfigMgr:get_config("item")
			if tb[data.get_id].bind == 1 then
				item:Get("binding"):SetActive(true)
			else
				item:Get("binding"):SetActive(false)
			end
		end
		if not data.show then
			data.show = true
			item:Get(10).enabled = true
			item:Get(8).enabled = true
			-- self.show_award = Schedule(handler(self, function()
			-- 		item:Get(9).gameObject:SetActive(false)
			-- 		self.show_award:stop()
			-- 		self.show_award = nil
			-- 		end), 0.9)
		else
			item:Get(8).gameObject.transform.localScale = Vector3(1,1,1)
			item:Get(9).gameObject:SetActive(false)
		end
	else
		item:Get(5).gameObject:SetActive(true)
		item:Get(6):SetActive(false)
		item:Get(8).gameObject:SetActive(false)
		gf_setImageTexture(item:Get(9),data.icon)
		local now_time = Net:get_server_time_s()
		local time = data.time_seconds - (now_time - self.item_obj.cur_online)
		if time <= 0 then
			item:Get(5).gameObject:SetActive(false)
			item:Get(6):SetActive(true)
			item:Get(7):SetActive(false)
		else
			item:Get(5).text = gf_localize_string(gf_convert_time(time).."后可领取")
		end
	end
end

function SignOnlineView:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "icon" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		-- if self.online_tips then
		-- 	self.online_tips.data = arg.data.rand_table
		-- 	self.online_tips:show()
		-- else
		-- 	self.online_tips = 
		require("models.sign.signOnlineTips")(arg.data.rand_table,arg.data.index)
		-- end
	elseif cmd == "get_award_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_mask_show(true)
		self.item_obj:draw_online_gift_c2s(arg.data.time_seconds)
	elseif cmd == "get_last_award" then
		gf_mask_show(true)
		self.item_obj:draw_last_week_online_gift_c2s()
	elseif cmd == "btn_help" then	
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		gf_show_doubt(1051)
	end
end

-- function SignOnlineView:dis_tips()
-- 	if self.online_tips then
-- 		self.online_tips:dispose()
-- 		self.online_tips = nil
-- 	end
-- end


function SignOnlineView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("bag")) then
		if id2 == Net:get_id2("bag","DrawOnlineGiftR")then   --领取今天的时间礼包
			if msg.err == 0 then
				print("领取今天的时间礼包刷新界面")
				self:refresh(self.item_obj.online_data)
			end
		end
	end
end


function SignOnlineView:countdown()
	local now_time = Net:get_server_time_s()
	self.today_online.text = gf_convert_time(now_time - self.item_obj.cur_online)
	self.all_online_time.text = gf_convert_time(now_time - self.item_obj.cur_week_online)
	if self.item_obj.last_week_online == 0 then
		self:add_get_gold()
		self.cur_text.text = gf_localize_string("下周可领：")
		self.get_btn:SetActive(false)
	else
		local level = LuaItemManager:get_item_obejct("game"):getLevel()
		local data =  ConfigMgr:get_config("online_week")[level]
		self.last_week_gold = math.floor(self.item_obj.last_week_online/600)*data.bind_gold
		if self.last_week_gold  == 0 then
			self.item_obj.last_week_online = 0
		elseif self.last_week_gold  > data.limit then
			 self.last_week_gold = data.limit
		end
		self.cur_text.text = gf_localize_string("本周可领：")
		self.all_online_gold.text =gf_localize_string(self.last_week_gold)	
		self.get_btn:SetActive(true)
	end
	local is_update = false
	-- for k,v in pairs(self.item_obj.online_data) do
	--  	if not v.open then
	--  		is_update = true
	--  	end 
	--  end 
	-- if is_update then
		self:refresh(self.item_obj.online_data) 
	-- end
end


function SignOnlineView:add_get_gold()
	local now_time = Net:get_server_time_s()
	local all_week_time = now_time - self.item_obj.cur_week_online
	local gold = math.floor(all_week_time/600)*self.gold_double
	--累计获得元宝
	if gold>self.gold_up then
		gold = self.gold_up
	end
	self.all_online_gold.text =gf_localize_string(gold)
end

-- 释放资源
function SignOnlineView:dispose()
	if self.s then
		self.s:stop()
	end
	if self.online_tips then
		self.online_tips:dispose()
	end
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return SignOnlineView

