--[[--
--投资基金
-- @Author:Seven
-- @DateTime:2017-10-09 11:55:34
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local InvestmentView=class(UIBase,function(self,item_obj)
	self.item_obj = item_obj
    UIBase._ctor(self, "welfare_investment.u3d",item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function InvestmentView:on_asset_load(key,asset)
	if self.item_obj.invest_status == 0 then
		self.item_obj:check_invest_award()
	end
	self.scroll_table = self.refer:Get("Content")
	self.scroll_table.onItemRender = handler(self,self.update_item)
	StateManager:register_view(self)
	self.item_obj:sort_invest_award()
	self:refresh(self.item_obj.invest_data)
end
function InvestmentView:refresh(data)
	self.scroll_table.data = data
	self.scroll_table:Refresh(0 ,-1) --显示列表
end

function InvestmentView:update_item(item,index,data)
	item:Get(1).text = gf_localize_string("第"..data.day .."天")
	local gold_code =  ConfigMgr:get_config("base_res")[ServerEnum.BASE_RES.BIND_GOLD].item_code
	local obj_gold = item:Get(3):Get(1)
	gf_set_item(gold_code, obj_gold:Get(2), obj_gold:Get(1))
	gf_set_click_prop_tips(obj_gold.gameObject,gold_code)
	item:Get(3):Get(1):Get(3).text = data.bind_gold
	local tb = ConfigMgr:get_config("item")
	if tb[gold_code].bind == 1 then
		obj_gold:Get("binding"):SetActive(true)
	else
		obj_gold:Get("binding"):SetActive(false)
	end
	for i=1,4 do
		if data.award[i] then
			local obj = item:Get(3):Get(i+1)
			gf_set_item( data.award[i][1],obj:Get(2),obj:Get(1))
			gf_set_click_prop_tips(obj.gameObject,data.award[i][1])
			obj:Get(3).text = data.award[i][2]
			obj.gameObject:SetActive(true)
			if tb[gold_code].bind == 1 then
				obj:Get("binding"):SetActive(true)
			else
				obj:Get("binding"):SetActive(false)
			end
		else
			item:Get(3):Get(i+1).gameObject:SetActive(false)
		end
	end
	if data.open == false then
		item:Get(2):SetActive(true)
		item:Get(4):SetActive(false)
		item:Get(5):SetActive(true)
		item:Get(7).gameObject:SetActive(false)			
		item:Get(6).text=gf_localize_string("已领取")
	elseif data.open then
		item:Get(2):SetActive(false)
		item:Get(4):SetActive(true)
		item:Get(5):SetActive(true)
		item:Get(7).gameObject:SetActive(false)	
		item:Get(6).text=gf_localize_string("可领取")
	else
		item:Get(4):SetActive(false)
		item:Get(2):SetActive(false)
		if	data.day == 1 and self.item_obj.invest_status == 0 then
			item:Get(5):SetActive(true)
			item:Get(7).gameObject:SetActive(false)
			item:Get(6).text=gf_localize_string("立即投资")
		else
			item:Get(5):SetActive(false)
			item:Get(7).gameObject:SetActive(true)
			item:Get(7).text = gf_localize_string("第"..data.day.."天可领取")
		end
	end
end

function InvestmentView:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "get_award_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.select_item = arg
		if	self.item_obj.invest_status == 0 then
			if	arg.data.day == 1 then
				gf_mask_show(true)
				self.item_obj:do_invest_c2s()
			else
				gf_message_tips("未投资")
			end 
		else 
			if arg.data.open then
				gf_mask_show(true)
				self.item_obj:draw_invest_gift_c2s(arg.data.day)
			elseif arg.data.open == nil then
				gf_message_tips("暂不可领")
			else
				gf_message_tips("已领取")
			end
		end
	end
end

function InvestmentView:update_view()
	if self.select_item.data.day == 1 and self.select_item.data.open then
		self.select_item:Get(2):SetActive(false)
		self.select_item:Get(4):SetActive(true)
		self.select_item:Get(6).text=gf_localize_string("可领取")
	else
		self.select_item:Get(2):SetActive(true)
		self.select_item:Get(4):SetActive(false)
		self.select_item:Get(6).text=gf_localize_string("已领取")
	end
end

function InvestmentView:update_mask()
	gf_mask_show(false)
end

function InvestmentView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("shop")) then
		if id2 == Net:get_id2("shop","DrawInvestGiftR") or id2 == Net:get_id2("shop","DoInvestR") then 
			if msg.err == 0 then
				self:update_view()
			end
		end
	end
end

-- 释放资源
function InvestmentView:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return InvestmentView

