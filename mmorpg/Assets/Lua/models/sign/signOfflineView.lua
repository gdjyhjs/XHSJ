--[[--
--
-- @Author:xcb
-- @DateTime:2017-09-07 11:29:50
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local offline_item_id = math.floor(ConfigMgr:get_config("game_const")["offline_exp_id2"].value)

local SignOfflineView=class(UIBase,function(self,item_obj)
    UIBase._ctor(self, "welfare_offline.u3d", item_obj) -- 资源名字全部是小写
    self:set_level(UIMgr.LEVEL_STATIC)
end)

-- 资源加载完成
function SignOfflineView:on_asset_load(key,asset)
	self:register()
	self:init_ui()
end

function SignOfflineView:init_ui()
	self.txt_max_time = self.refer:Get(1)	--可积累离线时间
	self.txt_time = self.refer:Get(2)		--当前积累离线时间
	self.text_lv_to = self.refer:Get(3)		--领取经验后等级
	self.txt_get_exp = self.refer:Get(4)	--可获经验
	self.btn = self.refer:Get(5)
	local item_obj = LuaItemManager:get_item_obejct("offline")
	self.txt_max_time.text = item_obj:get_time_str(item_obj.can_use_offline_times)
	self.txt_time.text = item_obj:get_time_str(item_obj.cur_use_offline_times)

	local exp_per_min = 0
	local play_lv = LuaItemManager:get_item_obejct("game"):getLevel()
	if ConfigMgr:get_config("offline_exp")[play_lv] ~= nil then
		exp_per_min = ConfigMgr:get_config("offline_exp")[play_lv].exp_per_min
	end

	local exp = item_obj.cur_use_offline_times * ( exp_per_min + math.floor(LuaItemManager:get_item_obejct("game"):getPower()/500))
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
	self.gray = self.refer:Get(6)
	if item_obj.cur_use_offline_times <= 0 then
		--self.btn.gameObject:SetActive(false)
		self.gray.gameObject:SetActive(true)
	else
		--self.btn.gameObject:SetActive(true)
		self.gray.gameObject:SetActive(false)
	end
end

function SignOfflineView:on_click(obj,arg)
	local cmd = obj.name
	if cmd == "btnAddMaxTime" then
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
			--gf_open_model(ClientEnum.MODULE_TYPE.MALL,2,2,offline_item_id)
			local goods = LuaItemManager:get_item_obejct("mall"):get_goods_for_prodId(offline_item_id)
			gf_open_model(ClientEnum.MODULE_TYPE.MALL,2,2,goods.goods_id)
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
	elseif cmd == "btnGet" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local item_obj = LuaItemManager:get_item_obejct("offline")
		if item_obj.cur_use_offline_times <= 0 then
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(gf_localize_string("当前没有离线经验可领取"))
		else
			Net:send({},"base","GetOfflineExpReward")
		end
	elseif cmd == "btnHelp" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		gf_show_doubt(1201)
	end
end

function SignOfflineView:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("base")) then
		if id2 == Net:get_id2("base","GetOfflineExpRewardR")then   --领取今天的时间礼包
			if msg.err == 0 then
				self:init_ui()
			end
		elseif id2 == Net:get_id2("base","UpdateOfflineExpMaxTimeR") then
			self:init_ui()
		end
	end
end

function SignOfflineView:register()
	StateManager:register_view( self )
end

function SignOfflineView:cancel_register()
	StateManager:remove_register_view( self )
end

function SignOfflineView:on_showed()
--	self:register()
--	self:init_ui()
end

function SignOfflineView:on_hided( )
--	self:cancel_register()
end
-- 释放资源
function SignOfflineView:dispose()
	self:cancel_register()
    self._base.dispose(self)
end

return SignOfflineView

