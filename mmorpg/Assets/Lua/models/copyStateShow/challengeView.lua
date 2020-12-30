--[[
	module:过关斩将任务面板
	at 2017.5.16
	by xin
]]


local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local commom_string = 
{
	[1] = gf_localize_string("[副]%s"),
	[2] = gf_localize_string("击败：%s"),
	[3] = gf_localize_string("时间：%s"),
	[4] = gf_localize_string("称号：%s"),
}

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "mainui_copy_challenge.u3d", 
}

local py1,py2 = 75.6,80 
local heightOff = 67.4

local challengeView=class(UIBase,function(self)
	local item_obj = gf_getItemObject("copy")
	UIBase._ctor(self, res[1], item_obj)
end)


function challengeView:dataInit()
	self:referInit()

end

-- 资源加载完成
function challengeView:on_asset_load(key,asset)
	StateManager:register_view(self)
	self:set_always_receive(true)
	self:init_ui()
end

function challengeView:referInit()
	self.action = self.root.transform:FindChild("copy_challenge"):GetComponent("TweenPosition")
	self.action.from = self.action.transform.localPosition
	self.action.to = self.action.transform.localPosition + Vector3(-265, 0, 0)
end

function challengeView:init_ui()
	self.copy_code = gf_getItemObject("challenge"):get_copy_code()

	print("self.copy_code wtf:",self.copy_code)

	if not LuaItemManager:get_item_obejct("copy"):is_challenge() then
		self:set_visible(false)
		return
	end
	self:set_visible(true)
	
	--关闭地图显示

	local cur_copy_info = dataUse.getCopyInfo(self.copy_code or 1)

	-- local copy_info = cur_copy_info or dataUse.getCopyInfo(self.copy_code - 1)

	--章节
	local copy_id = gf_getItemObject("copy"):get_copy_id()

	local chapter_name = cur_copy_info.chapter_name
	self.refer:Get(1).text = string.format(commom_string[1],chapter_name)

	--击败
	local boss_name = ConfigMgr:get_config("creature")[cur_copy_info.boss_id].name
	self.refer:Get(2).text = string.format(commom_string[2],boss_name)


	--时间
	local cur_copy_info = dataUse.getCopyInfo(self.copy_code or 1)
	local start_time = gf_getItemObject("copy"):get_time()
	local time_leave = Net:get_server_time_s() - start_time
	local time_left = cur_copy_info.time_limit - time_leave 
	time_left = time_left > 0 and time_left or 0
	self:set_time(time_left)
	self:start_scheduler()

	--称号
	local title_info = ConfigMgr:get_config("title")[cur_copy_info.title_reward]
	self.refer:Get(4).text = string.format(commom_string[4],title_info.name)

	if not next(cur_copy_info or {}) then
		self.refer:Get(12):SetActive(true)
		self.refer:Get(13).interactable = false
	end

end

function challengeView:set_time(time_left)
	local time_str = gf_convert_time_ms(time_left)
	self.refer:Get(3).text = string.format(commom_string[3],time_str)
end

--isShow  是否显示出来
function challengeView:showAction(isShow)
	if not self.action then
		return
	end
	if not isShow then
		self.action:PlayForward()
	else
		self.action:PlayReverse()
	end
end

function challengeView:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		local copy_info = dataUse.getCopyInfo(self.copy_code or 1)
		local start_time = gf_getItemObject("copy"):get_time()
		local time_leave = Net:get_server_time_s() - start_time
		local time_left = copy_info.time_limit - time_leave 
		time_left = time_left > 0 and time_left or 0
		self:set_time(time_left)
		if time_left <= 0 then
			require("models.copy.challengeDefault")()
			self:stop_schedule()
		end
	end
	self.schedule_id = Schedule(update, 0.5)
end
function challengeView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function challengeView:setParent(parent)
	parent:add_child(self.root)
end

--点击
function challengeView:on_click(obj,arg)
end

function challengeView:on_receive(msg, id1, id2, sid)
	
	if(id1==Net:get_id1("copy"))then
        if id2 == Net:get_id2("copy", "GetHolyCopyInfoR") then
        	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			-- self.copy_code = msg.code

		elseif id2 == Net:get_id2("copy", "ExitCopyR") then -- 通关
			Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
			self:dispose()

		elseif id2 == Net:get_id2("copy","EnterCopyR") or id2 == Net:get_id2("copy","ContinueChallengeR") then
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			self:init_ui()

		elseif  id2 == Net:get_id2("copy", "PassCopyR") then
			Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
			self:stop_schedule()

		end
	end
	if id1 == ClientProto.EnterChallengeCopy then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:init_ui()
	end
end
function challengeView:on_hided()
	self:stop_schedule()
end
-- 释放资源
function challengeView:dispose()
	self:stop_schedule()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
 end

return challengeView

