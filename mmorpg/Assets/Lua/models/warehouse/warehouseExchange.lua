--[[--
-- 任务栏管理ui
-- @Author:Seven
-- @DateTime:2017-06-23 18:23:22
--]]

--重新登录后伤害排名没有推
--boss出现时间到时为啥获取到的是nil
local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local kouliang_shop_id = 20010001
local WarehouseExchange=class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("warehouse")
    UIBase._ctor(self, "legion_rations_exchange.u3d", item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function WarehouseExchange:on_asset_load(key,asset)
	
end

function WarehouseExchange:init_ui()
	self.icon = self.refer:Get(2)
	self.txt_buy_count = self.refer:Get(3)
	self.txt_need_score = self.refer:Get(4)
	self.txt_my_score = self.refer:Get(5)
	self.select_count = 1

	self.my_score = LuaItemManager:get_item_obejct("game"):get_money(ServerEnum.BASE_RES.ALLIANCE_STORE_POINT)
	self.single_cost_score = ConfigMgr:get_config("goods")[kouliang_shop_id].offer

	self.txt_buy_count.text = "0"
	self.txt_need_score.text = "0"
	self.txt_my_score.text = tostring(self.my_score)

	local code = ConfigMgr:get_config("goods")[kouliang_shop_id].item_code

	local item_back = self.refer:Get(6)
	local color_img = item_back:GetComponent(UnityEngine_UI_Image)
	gf_set_item( code, self.icon , color_img)
	self:refresh()
end

function WarehouseExchange:refresh()
	self.txt_buy_count.text = tostring(self.select_count)
	local need_score = self.select_count * self.single_cost_score
	self.txt_need_score.text = tostring(need_score)
end
function WarehouseExchange:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("base") then
        if id2 == Net:get_id2("base", "UpdateResR") then
        	self:init_ui()
        end
    end
end

function WarehouseExchange:on_click( obj, arg )
	local event_name = obj.name
	if event_name == "btnAddCount" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local max_count = math.floor(self.my_score / self.single_cost_score)
		if max_count <= self.select_count then
			self.select_count = 1
		else
			self.select_count = self.select_count + 1
		end
		self:refresh()
	elseif event_name == "btnMineCount" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		if 1 < self.select_count then
			self.select_count = self.select_count - 1
		else
			local max_count = math.floor(self.my_score / self.single_cost_score)
			self.select_count = math.max(max_count,1)
		end
		self:refresh()
	elseif event_name == "btnExchange" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		if 0 < self.select_count then
			if self.select_count * self.single_cost_score < self.my_score then
				LuaItemManager:get_item_obejct("mall"):buy_c2s(kouliang_shop_id,self.select_count)
				self:dispose()
			else
				LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("军团仓库积分不足"))
			end
		else
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("请选择购买数量"))
		end
	elseif event_name == "btnClose" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
	elseif event_name == "txtBuyCount" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:show_number_keyboard()
	end
end

function WarehouseExchange:show_number_keyboard()
	local function exit_kb(result)
		result = tonumber(result) or 1
		self.select_count = result
		local max_count = math.floor(self.my_score / self.single_cost_score)
		if max_count < self.select_count then
			self.select_count = max_count
		end
		self:refresh()
	end
	local max_count = math.floor(self.my_score / self.single_cost_score)
	LuaItemManager:get_item_obejct("keyboard"):use_number_keyboard(self.txt_buy_count,max_count,1,Vector3(self.txt_buy_count.gameObject.transform.position.x + 250,200,0),nil,nil,nil,exit_kb,nil)
end

function WarehouseExchange:register()
	StateManager:register_view( self )
end

function WarehouseExchange:cancel_register()
	StateManager:remove_register_view( self )
end

function WarehouseExchange:on_showed()
	self:register()
	self:init_ui()
end

function WarehouseExchange:on_hided()
end

-- 释放资源
function WarehouseExchange:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return WarehouseExchange

