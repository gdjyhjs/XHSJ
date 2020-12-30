--[[
	过关斩将结算界面
	create at 17.7.20
	by xin
]]
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "challenge_end.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}


local challengeEnd = class(UIBase,function(self,msg)
	gf_print_table(msg, "msg wtf:")
	self.msg = msg
	self.time = Net:get_server_time_s()
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function challengeEnd:on_asset_load(key,asset)
	self:init_ui()
end        

function challengeEnd:init_ui()
	local copy_id = gf_getItemObject("copy"):get_copy_id()	
	if copy_id > 0 then
		local copy_code = self.msg.holyCode--gf_getItemObject("challenge"):get_copy_code()
		local info = dataUse.getCopyInfo(copy_code)
		--通关时间
		local leave_time = self.msg.costTime --- gf_getItemObject("copy"):get_time()
		self.refer:Get(1).text = gf_convert_time_ms_ch(leave_time)
		--通关奖励
		self:scroll_view_init({info.holy_coin_reward})
		--通关称号
		local title_info = ConfigMgr:get_config("title")[info.title_reward]
		self.refer:Get(2).text = title_info.name

		local career = LuaItemManager:get_item_obejct("game").role_info.career
		gf_win_icon(self.refer:Get(4),career)
	end	
end

function challengeEnd:scroll_view_init(data)
	local scroll_rect_table = self.refer:Get(3)
	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		scroll_rect_item.gameObject:SetActive(true)
		local holy_info = dataUse.getHolyInfo(data_item[1])
		local icon = scroll_rect_item.transform:FindChild("icon"):GetComponent(UnityEngine_UI_Image)
		gf_setImageTexture(icon,holy_info.coin_icon)

		local count_text = scroll_rect_item.transform:FindChild("numTxt"):GetComponent("UnityEngine.UI.Text")
		count_text.text = data_item[2]

	end
	scroll_rect_table.data = data
	scroll_rect_table:Refresh(-1,-1)
end

--鼠标单击事件
function challengeEnd:on_click( obj, arg)
	print("wtf challengeEnd click",obj.name)
    local event_name = obj.name

    --如果小于两秒 不给点击
    if Net:get_server_time_s() - self.time <= ConfigMgr:get_config("t_misc").copy.pass_wait_time then
    	return
    end

    if event_name == "back_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
    	self:dispose()
    	LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()

    elseif event_name == "continue_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	local copy_code = gf_getItemObject("challenge"):get_copy_code()
    	--如果不是最后一章 
    	if dataUse.getNextCopyCode(copy_code) then
    		self:dispose()
    		gf_getItemObject("copy"):continue_challenge_c2s(copy_code + 1)
    	end
    end
end

-- 释放资源
function challengeEnd:dispose()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end

function challengeEnd:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then 
		if id2 == Net:get_id2("copy", "PassCopyR") then
			
		end
	end
end

return challengeEnd