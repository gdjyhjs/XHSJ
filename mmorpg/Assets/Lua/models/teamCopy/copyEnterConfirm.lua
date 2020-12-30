--[[
	pvp排行榜界面  
	create at 17.8.1
	by xin
]]

-- local dataUse = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local res = 
{
	[1] = "copy_enter_confirm.u3d",
}

local save_key = "team_copy_reward"

local commom_string = 
{
	[1] = gf_localize_string("今天组队副本次数已用完，帮助其他玩家通关副本1次可获500荣誉（<color=#00FF37>%d/%d</color>）"),
	[2] = gf_localize_string("今天组队副本次数和助战次数均已用完，确定要帮助其他玩家通关副本？"),
	[3] = gf_localize_string("同意(%d)"),
}

local copyEnterConfirm = class(UIBase,function(self,end_time)
	self.end_time = end_time
	local item_obj = LuaItemManager:get_item_obejct("team")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function copyEnterConfirm:on_asset_load(key,asset)
	self:init_ui()
end

function copyEnterConfirm:init_ui()
	local is_leader = gf_getItemObject("team"):isLeader()

	print("wtf fff:",gf_getItemObject("team"):get_my_wait_state())

	if is_leader then
		self.refer:Get(11).interactable = false
		self.refer:Get(12).interactable = false
	else
		self.refer:Get(11).interactable = not gf_getItemObject("team"):get_my_wait_state()
		self.refer:Get(12).interactable = not gf_getItemObject("team"):get_my_wait_state()

	end

	self:update_state()

	self:start_scheduler()
end

function copyEnterConfirm:update_state()
	local team_data = gf_getItemObject("team"):getTeamData()
	gf_print_table(team_data, "wtf team_data:")
	for i,v in ipairs(team_data.members or {}) do
		--没有确认 不显示头像
		local head_item = self.refer:Get(1+i)
		
		--隐藏头像
		if v.roleId ~= team_data.leader then
			head_item.transform:FindChild("head").gameObject:SetActive(v.confirm or false)
		end

		head_item.transform:FindChild("name"):GetComponent("UnityEngine.UI.Text").text = v.name

		gf_set_head_ico(head_item.transform:FindChild("head"):GetComponent(UnityEngine_UI_Image), v.head)

		head_item.transform:FindChild("level"):GetComponent("UnityEngine.UI.Text").text = v.level

	end

	for i=#team_data.members + 1,gf_get_config_const("team_member_count") do
		self.refer:Get(i+1):SetActive(false)
	end
end

function copyEnterConfirm:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local end_time = self.end_time
	local update = function()
		local left_time = self.end_time - Net:get_server_time_s()
		
		left_time = left_time <= 0 and 0 or left_time
		self.refer:Get(13).text = string.format(commom_string[3],left_time)
		if left_time <= 0 then
			self:hide()
		end
	end
	update()
	self.schedule_id = Schedule(update, 0.5)
end

function copyEnterConfirm:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

--鼠标单击事件
function copyEnterConfirm:on_click( obj, arg)
    local event_name = obj.name
    if event_name == "btnClose" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效

    	local is_leader = gf_getItemObject("team"):isLeader()
    	--如果是队长
    	if is_leader then
    		gf_getItemObject("copy"):comfirm_enter_team_copy_c2s(false)
    		return
    	end

    	self:dispose()

    elseif  event_name == "btnSure" then
    	gf_getItemObject("team"):sendToGetEnterCount()

    elseif  event_name == "btnRefuse" then
    	gf_getItemObject("copy"):comfirm_enter_team_copy_c2s(false)

    end
end

function copyEnterConfirm:on_receive( msg, id1, id2, sid )
	print("copyEnterConfirm on receive",id1,id2)
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "EnterCopyR") then -- 取章节信息
			print("copyEnterConfirm dipspose")
			self:dispose()
		
		end
	end

	if id1 == Net:get_id1("team") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if id2 == Net:get_id2("team", "TeamCopyRejectNotifyR") or id2 == Net:get_id2("team", "TeamVsCopyRejectNotifyR") then
			self:dispose()

		elseif id2 == Net:get_id2("team", "TeamCopyAgreeNotifyR") then
			--如果是队长拒绝 关闭按钮
			local team_data = gf_getItemObject("team"):getTeamData()
			if not msg.agree and msg.roleId == team_data.leader then
				self:dispose()
				return
			end
			--如果是自己关闭
			local roleId = gf_getItemObject("game"):getId()
			if not msg.agree and roleId == msg.roleId then
				self:dispose()
				return
			end
			self:update_state()

		elseif id2 == Net:get_id2("team", "TeamCopyPassTimesR") then
			gf_print_table(msg, "TeamCopyPassTimesR wtf:")
			if msg.times <= 3 then
				gf_getItemObject("copy"):comfirm_enter_team_copy_c2s(true)
				return
			end
			
			local show_content = msg.times > gf_get_config_const("team_copy_enter_count") and commom_string[2] or string.format(commom_string[1],msg.times,gf_get_config_const("team_copy_enter_count"))

			local c_date = os.date("%x",Net:get_server_time_s())

			local my_role_id = gf_getItemObject("game"):getId()
			local s_date = PlayerPrefs.GetString(string.format(save_key,my_role_id),os.date("%x",Net:get_server_time_s() - 24 * 60 * 60))

			if c_date == s_date then
				gf_getItemObject("copy"):comfirm_enter_team_copy_c2s(true)
				return
			end

			local save = function()
				PlayerPrefs.SetString(string.format(save_key,my_role_id),c_date)
			end

			local sfunc = function(a,b)
				if b then
					save()
				end
				gf_getItemObject("copy"):comfirm_enter_team_copy_c2s(true)
			end
			local cfunc = function(a,b)
				if b then
					save()
				end
			end


			LuaItemManager:get_item_obejct("cCMP"):toggle_message(show_content,false,commom_string[1],sfunc,cfunc,"取消","助战")

			


		end
	end
	if id1 == Net:get_id1("scene") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			self:dispose()
		end
	end
	
end

function copyEnterConfirm:clear()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function copyEnterConfirm:on_showed()
	StateManager:register_view(self)
end

function copyEnterConfirm:on_hided()
	self:clear()
	
end
-- 释放资源
function copyEnterConfirm:dispose()
	self:clear()
    self._base.dispose(self)
end

return copyEnterConfirm