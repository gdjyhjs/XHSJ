--[[--
-- 周卡月卡
-- @Author:Seven
-- @DateTime:2017-10-10 09:58:58
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local WeekMonthCardView=class(UIBase,function(self,item_obj)
	self.item_obj = item_obj
    UIBase._ctor(self, "monthcard.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function WeekMonthCardView:on_asset_load(key,asset)
	self.item_obj:week_month_card_award()	
	self.left = self.refer:Get(1)
	self.right = self.refer:Get(2)
	StateManager:register_view(self)
	self.player_level = LuaItemManager:get_item_obejct("game"):getLevel()
	self:update_view()
end

function WeekMonthCardView:update_left()
	local data = nil
	for k,v in pairs(self.item_obj.week_data) do
		if k ~= #self.item_obj.week_data then
			if self.player_level >= v.level and self.player_level < self.item_obj.week_data[k+1].level then
				data = v
				break
			end
		else
			data = v
		end
	end 
	self:update_item(self.left,data) 
end

function WeekMonthCardView:update_right()
	local data = nil
	for k,v in pairs(self.item_obj.month_data) do
		if k ~= #self.item_obj.month_data then
			if self.player_level >= v.level and self.player_level < self.item_obj.month_data[k+1].level then
				data = v
				break
			end
		else
			data = v
		end
	end 
	self:update_item(self.right,data) 
end

function WeekMonthCardView:update_item(item,data)
	local open = nil
	if data.type == ServerEnum.RECHARGE_TYPE.WEEK_CARD then
		if self.item_obj.timestamp_week ~=0 and gf_time_diff(Net:get_server_time_s(),self.item_obj.timestamp_week).day<7 then
			if os.date("%Y%m%d",Net:get_server_time_s()) ~= self.item_obj.drawGiftTimestamp_week then
				open = true
			else
				open = false
			end
		end
		self.open_week = open
	elseif data.type == ServerEnum.RECHARGE_TYPE.MONTH_CARD then
		if self.item_obj.timestamp_month ~=0 and gf_time_diff(Net:get_server_time_s(),self.item_obj.timestamp_month).day<30 then
			if os.date("%Y%m%d",Net:get_server_time_s()) ~= self.item_obj.drawGiftTimestamp_month then
				open = true
			else
				open = false
			end
		end
		self.open_month = open
	end

	-- if open == nil then
	-- 	if data.type == ServerEnum.RECHARGE_TYPE.WEEK_CARD then
	-- 		item:Get(1).text = gf_localize_string("花费")
	-- 		item:Get(11).text = gf_localize_string("购买周卡")
	-- 	else
	-- 		item:Get(1).text = gf_localize_string("花费")
	-- 		item:Get(11).text = gf_localize_string("购买月卡")
	-- 	end
	-- 	gf_set_money_ico(item:Get(10),ServerEnum.BASE_RES.GOLD)
	-- 	local tb = ConfigMgr:get_config("recharge")
	-- 	for k,v in pairs(tb) do
	-- 		if v.type == data.type then
	-- 			item:Get(2).text = v.gold
	-- 		end
	-- 	end
	-- 	-- local money = tb[10000+data.type].price
	-- 	item:Get(8).text = gf_localize_string("购买")
	-- else
		item:Get(11).text = ""
		item:Get(1).text = gf_localize_string("每天领取")
		gf_set_money_ico(item:Get(10),ServerEnum.BASE_RES.BIND_GOLD)
		item:Get(2).text =data.bind_gold
	-- end
	item:Get(3).text = gf_localize_string("每日赠送价值".. data.gold_value .."元宝的道具")	
	local tb_item = ConfigMgr:get_config("item")
	for i=1,4 do
		local obj = item:Get("item"..i)
		obj.gameObject:SetActive(true)
		gf_set_item( data.award[i][1],obj:Get(2),obj:Get(1))
		gf_set_click_prop_tips(obj.gameObject,data.award[i][1])
		obj:Get(3).text = data.award[i][2]
		if tb_item[data.award[i][1]].bind == 1 then
			obj:Get("binding"):SetActive(true)
		else
			obj:Get("binding"):SetActive(false)
		end
	end
	if open then
		item:Get(8).text = gf_localize_string("可领取")
	elseif open == false then
		item:Get(8).text = gf_localize_string("已领取")
		item:Get(9):SetActive(true)
	else
		local tb = ConfigMgr:get_config("recharge")
		for k,v in pairs(tb) do
			if v.type == data.type then
				item:Get(8).text = gf_localize_string(v.gold.."元宝")
			end
		end
	end
end

function WeekMonthCardView:update_view()
	self:update_left()
	self:update_right()
end

function WeekMonthCardView:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "btn_help" then
		gf_show_doubt(1111)
	elseif cmd == "get_week_award" then
		if self.open_week == nil then
			-- local txt = "是否花费<color=#B01FE5>"..ConfigMgr:get_config("recharge")[10000+ServerEnum.RECHARGE_TYPE.WEEK_CARD].gold.."</color>元宝购买<color=#B01FE5>周卡</color>\n"
			-- LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(txt,
			-- 	function()
				self.item_obj:recharge_c2s(ServerEnum.RECHARGE_TYPE.WEEK_CARD)
				-- end,function()  end,"确认","取消")
		elseif self.open_week then
			self.item_obj:draw_week_card_gift_c2s()
		else
			gf_message_tips("该礼包已领取")
		end
	elseif cmd == "get_month_award" then
		if self.open_month == nil then
			-- local txt = "是否花费<color=#B01FE5>"..ConfigMgr:get_config("recharge")[10000+ServerEnum.RECHARGE_TYPE.MONTH_CARD].gold.."</color>元宝购买<color=#B01FE5>月卡</color>\n"
			-- LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(txt,
			-- 	function()
				self.item_obj:recharge_c2s(ServerEnum.RECHARGE_TYPE.MONTH_CARD)
				-- end,function()  end,"确认","取消")
		elseif self.open_month then
			self.item_obj:draw_month_card_gift_c2s()
		else
			gf_message_tips("该礼包已领取")
		end
	end
end

function WeekMonthCardView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("shop")) then
		if id2 == Net:get_id2("shop","DrawWeekCardGiftR") or id2 == Net:get_id2("shop","DrawMonthCardGiftR") or  id2 == Net:get_id2("shop","RechargeR")  then --月卡奖励
			if msg.err == 0 then
				self:update_view()
			end
		end
	end
end

-- 释放资源
function WeekMonthCardView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return WeekMonthCardView

