--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 09:57:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local offline_item_id = math.floor(ConfigMgr:get_config("game_const")["offline_exp_id2"].value)

local OfflineView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "welfare_offline_statistics.u3d") -- 资源名字全部是小写
    self.item_obj = item_obj
end)

OfflineView.level = UIMgr.LEVEL_STATIC

local has_pop_sub_ui = false
-- 资源加载完成
function OfflineView:on_asset_load(key,asset)
end

function OfflineView:init_ui()
	self.txt_max_time = self.refer:Get(1)	--可积累离线时间
	self.txt_time = self.refer:Get(2)		--当前积累离线时间
	self.text_lv_to = self.refer:Get(3)		--领取经验后等级
	self.txt_get_exp = self.refer:Get(4)	--可获经验
	self.txt_max_time.text = self.item_obj:get_time_str(self.item_obj.can_use_offline_times)
	self.txt_time.text = self.item_obj:get_time_str(self.item_obj.cur_use_offline_times)

	local exp_per_min = 0
	local play_lv = LuaItemManager:get_item_obejct("game"):getLevel()
	if ConfigMgr:get_config("offline_exp")[play_lv] ~= nil then
		exp_per_min = ConfigMgr:get_config("offline_exp")[play_lv].exp_per_min
	end
	local exp = self.item_obj.cur_use_offline_times * ( exp_per_min + math.floor(LuaItemManager:get_item_obejct("game"):getPower()/ConfigMgr:get_config("t_misc").offline.power_to_exp_coef))
	local str
	if 10000 < exp then
		str = string.format("%.2f万",exp / 10000)
	else
		str = tostring(exp)
	end
	self.txt_get_exp.text = str

	local to_lv = LuaItemManager:get_item_obejct("game"):get_can_to_lv(exp)
	if play_lv < to_lv then
		str = string.format(gf_localize_string("%d级→%d级"),play_lv,to_lv)
	else
		str = string.format(gf_localize_string("%d级"),play_lv)
	end
	self.text_lv_to.text = str

	if (self.item_obj.can_use_offline_times)/ 60 < 5 then
		print("has_pop_sub_ui",has_pop_sub_ui)
		if self.sub_ui == nil and has_pop_sub_ui == false then
			self.sub_ui = require("models.offline.offlineTips")()
			has_pop_sub_ui = true
		end
	end
end

function OfflineView:on_click( item_obj, obj, arg )
	local event_name = obj.name
	if event_name == "btnAddMaxTime" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local list = LuaItemManager:get_item_obejct("bag"):get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.OFFLINE_EXP_TIME,ServerEnum.BAG_TYPE.NORMAL)
		local config = ConfigMgr:get_config("item")
		local function sort(a,b)
			local value_a = config[a.item.protoId].effect[1]
			local value_b = config[b.item.protoId].effect[1]
			return value_b < value_a
		end
		table.sort(list,sort)
		if #list == 0 then
			local goods = LuaItemManager:get_item_obejct("mall"):get_goods_for_prodId(offline_item_id)
			gf_open_model(ClientEnum.MODULE_TYPE.MALL,2,2,goods.goods_id)
			Net:receive({}, ClientProto.CloseOffline)
		else
			local item_id = list[1].item.protoId
			local count = list[1].item.num
			if count == 1 then
				--Net:send()
				LuaItemManager:get_item_obejct("bag"):use_item_c2s(list[1].item.guid,1,list[1].item.protoId)
			else				
				require("models.offline.offlineBuy")()
			end
		end
	elseif event_name == "btnExplain" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		LuaItemManager:get_item_obejct("sign").goto_index = 7
		gf_create_model_view("sign")
		--self.item_obj:pop_ui(self.item_obj.ui_priority.offline)
		--self:dispose()
	elseif event_name == "btnGet" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		if self.item_obj.cur_use_offline_times <= 0 then
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("当前没有离线经验可领取"))
		else
			Net:send({},"base","GetOfflineExpReward")
		end
	elseif event_name == "close_btn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self.item_obj:pop_ui(self.item_obj.ui_priority.offline)
		self:dispose()
	end
end
		
function OfflineView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function OfflineView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function OfflineView:on_showed()
	self:register()
	self:init_ui()
end

function OfflineView:on_hided( )
	self:cancel_register()
	self.item_obj:pop_ui(self.item_obj.ui_priority.offline)
end

function OfflineView:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("base") then
        if id2 == Net:get_id2("base", "GetOfflineExpRewardR") then
			if msg.err == 0 then
			--	self:init_ui()
				if self.sub_ui == nil and (self.item_obj.can_use_offline_times)/ 60 < 5 and has_pop_sub_ui == false then
					self.sub_ui = require("models.offline.offlineTips")()
					has_pop_sub_ui = true
				end
				self.item_obj:pop_ui(self.item_obj.ui_priority.offline)
				self:dispose()
			end
		elseif id2 == Net:get_id2("base","UpdateOfflineExpMaxTimeR") then
			self:init_ui() 	
        end
    end
    if id1 == ClientProto.CloseOffline then
  		if self.sub_ui ~= nil then
			--self.sub_ui:dispose()
			self.sub_ui = nil
		end
  	end
end
-- 释放资源
function OfflineView:dispose()
	--Net:receive({}, ClientProto.CloseOffline)
	--[[if self.sub_ui ~= nil then
		self.sub_ui:dispose()
		self.sub_ui = nil
	end]]
	self:cancel_register()
    self._base.dispose(self)
end

return OfflineView