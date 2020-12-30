--[[--
--
-- @Author:Seven
-- @DateTime:2017-10-12 14:31:22
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local HusongClearing=class(UIBase,function(self)
	self.item_obj = LuaItemManager:get_item_obejct("husong")
    UIBase._ctor(self, "double_escort_award.u3d", self.item_obj) -- 资源名字全部是小写
end)

-- 资源加载完成
function HusongClearing:on_asset_load(key,asset)
	StateManager:register_view(self)
	local data = ConfigMgr:get_config("task")[self.item_obj.husong_task_id]
	local lv = LuaItemManager:get_item_obejct("game"):getLevel()
	local award = data.exp_reward[1] + (lv-data.exp_reward[2])*data.exp_reward[3]
	local fame 	= data.money_reward[1][2][1] +(lv-data.money_reward[1][2][2])*data.money_reward[1][2][3]
	local xp = ConfigMgr:get_config("task_escort_quality")[self.item_obj.beauty_quality].reward_coef*0.01
	local player_vip = LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_lv()
	local add_vip =1 + ConfigMgr:get_config("vip")[player_vip].battle_exp/10000
	self.exp = award *xp*add_vip
	self.fame = fame *xp
	if	self.item_obj.isExpired == 1 then
		self.exp =self.exp *0.5
		self.fame =self.fame *0.5
	end
	if self.item_obj.isDouble == 1 then
		if	self.item_obj.isExpired == 1 then
			self.refer:Get("txt_multiple").text = gf_localize_string("美人等待时间太久啦，只能获得100%收益哟。")
		else
			self.refer:Get("txt_multiple").text = gf_localize_string("本次护送获得 200% 收益！")
		end
		self:mach_double(4)
	else
		if	self.item_obj.isExpired == 1 then
			self.refer:Get("txt_multiple").text = gf_localize_string("美人等待时间太久啦，只能获得50%收益哟。")
		else
			self.refer:Get("txt_multiple").text = gf_localize_string("本次护送获得 100% 收益！")
		end
		self:mach_double(2)
	end
	if self.item_obj.todayTimes == 0 then
		self.refer:Get(6):SetActive(true)
	else
		self.refer:Get(5):SetActive(true)
	end
	self.refer:Get(3).text = self.item_obj.todayTimes
end

function HusongClearing:mach_double(num)
	local item = self.refer:Get(1)
	for i=1,num do
		local obj = item:Get(i)
		obj.gameObject:SetActive(true)
		local i_id = 0
		if i%2 == 0 then
			i_id = ConfigMgr:get_config("base_res")[ServerEnum.BASE_RES.FAME].item_code
			obj:Get(2).text = math.floor(self.fame)
		else
			i_id = ConfigMgr:get_config("base_res")[ServerEnum.BASE_RES.EXP].item_code
			if	self.exp/10000 <0 then
				obj:Get(2).text = math.floor(self.exp)
			else
				obj:Get(2).text = gf_localize_string(string.format("%0.2f",self.exp/10000).."万")
			end
		end
		gf_set_item(i_id,obj:Get(1),obj:Get(3))
		gf_set_click_prop_tips(obj:Get(3).gameObject,i_id)
	end
end

function HusongClearing:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd == "sureBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
       self.item_obj:transfer_husong()
       self:dispose()
    elseif cmd == "bgBtn" or cmd =="cancleBtn" then
    	self:dispose()
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN)
	end
end

-- 释放资源
function HusongClearing:dispose()
	StateManager:remove_register_view( self )
    self._base.dispose(self)
 end

return HusongClearing

