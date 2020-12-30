--[[
	战旗界面  属性
	create at 17.10.31
	by xin
]]
local model_name = "alliance"

local dataUse = require("models.legion.dataUse")

local res = 
{
	[1] = "legion_battle_flag.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("当前等级:%d"),
	[2] = gf_localize_string("%d贡献"),
	[3] = gf_localize_string("升级战旗可提高战旗属性，确定要消耗<color=#B01FE5>%s</color>资金将战旗升级到<color=#B01FE5>%d</color>级？\n当前军团资金：%s"),
	[4] = gf_localize_string("战旗等级已满，请提升军团等级再试"),
    [5] = gf_localize_string("下一等级:%d"),
}


local legionFlag = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("legion")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function legionFlag:on_asset_load(key,asset)
    self:init_ui()
end

function legionFlag:init_ui()
	self:permission_view_init()

	local legion_info = gf_getItemObject("legion"):get_info()
		
	self:update_time()
	self:start_scheduler()

	--剩余次数
	self.refer:Get(3).text = ConfigMgr:get_config("t_misc").alliance.warFlagInspireTimesLimit - gf_getItemObject("legion"):get_inspire_times()

	--属性--
	local cur_level = legion_info.warFlagLevel
	local max = dataUse.getFlagMaxLevel(legion_info.level)
	self.refer:Get(1).text = string.format(commom_string[1],cur_level)

	--鼓舞消耗
	local cost = ConfigMgr:get_config("t_misc").alliance.warFlagInspireCostDonation
	self.refer:Get(9).text = string.format(commom_string[2],cost)

	local attr = dataUse.get_flag_attr(cur_level)
	gf_print_table(attr, "wtf attr:")
	--属性值
	for i,v in ipairs(attr or {}) do
		local value = self.refer:Get(7).transform:FindChild("p"..i):GetComponent("UnityEngine.UI.Text")
		value.text = string.format("%s + %d",ConfigMgr:get_config("propertyname")[v[2]].name,v[4])
	end

	if cur_level + 1 > max then
		self.refer:Get(5).transform.localPosition = Vector3(139,0,0)
		self.refer:Get(6):SetActive(false)
		return
	end
	--如果没有满级 
	self.refer:Get(2).text = string.format(commom_string[5],cur_level + 1)
	
	local attr = dataUse.get_flag_attr(cur_level + 1)
	for i,v in ipairs(attr or {}) do
		local value = self.refer:Get(8).transform:FindChild("p"..i):GetComponent("UnityEngine.UI.Text")
		value.text = string.format("%s + %d",ConfigMgr:get_config("propertyname")[v[2]].name,v[4])
	end

	
end

function legionFlag:permission_view_init()
	local can_flag_upgrade = gf_getItemObject("legion"):get_permissions(ServerEnum.ALLIANCE_MANAGE.WAR_FLAG_LEVELUP)
	
	self.refer:Get(10):SetActive(can_flag_upgrade)
	
end

function legionFlag:update_time()
	print("update_time:")
	--剩余时间
	local left = gf_getItemObject("legion"):get_inspire_expired_time() - Net:get_server_time_s()
	left = left <= 0 and 0 or left
	self.refer:Get(4).text = gf_convert_timeEx(left)
	if left <= 0 then
		self:stop_schedule()
	end

end

function legionFlag:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		self:update_time()
	end
	update()
	self.schedule_id = Schedule(update, 0.5)
end

function legionFlag:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function legionFlag:upgrade_level_up()
	local sure_fun = function()
		gf_getItemObject("legion"):send_to_upgrade_flag()
	end
	local legion_info = gf_getItemObject("legion"):get_info()

	local max = dataUse.getFlagMaxLevel(legion_info.level)

	if max == legion_info.warFlagLevel then
		gf_message_tips(commom_string[4])
		return
	end

	local flag_info = dataUse.getFlagInfo(legion_info.warFlagLevel)
	local content = string.format(commom_string[3],flag_info.need_fund,legion_info.warFlagLevel + 1,legion_info.fund)
	gf_getItemObject("cCMP"):ok_cancle_message(content,sure_fun)
end

--鼠标单击事件
function legionFlag:on_click( obj, arg)
	local event_name = obj.name
	print("legionFlag click",event_name)
    if event_name == "gw_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	gf_getItemObject("legion"):send_to_spirit()

    elseif event_name == "upgrade_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	self:upgrade_level_up()

    elseif event_name == "help_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
    	gf_show_doubt(1133)

    end
end

function legionFlag:on_showed()
	StateManager:register_view(self)
end

function legionFlag:clear()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function legionFlag:on_hided()
	self:clear()
end
-- 释放资源
function legionFlag:dispose()
	self:clear()
    self._base.dispose(self)
end

function legionFlag:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "WarFlagLevelUpR") then
			self:init_ui()

		elseif id2 == Net:get_id2(model_name, "WarFlagInspireR") then
			self:init_ui()

		end
	end
end

return legionFlag