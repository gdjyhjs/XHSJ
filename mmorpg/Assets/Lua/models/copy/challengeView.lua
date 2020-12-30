--[[
	过关斩将系统主界面
	create at 17.7.17
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local model_name = "copy"

local dataUse = require("models.challenge.dataUse")

local res = 
{
	[1] = "challenge.u3d",
}


local commom_string = 
{
    [1] = gf_localize_string("一"),
    [2] = gf_localize_string("二"),
    [3] = gf_localize_string("三"),
    [4] = gf_localize_string("四"),
    [5] = gf_localize_string("五"),
    [6] = gf_localize_string("六"),
    [7] = gf_localize_string("七"),
    [8] = gf_localize_string("八"),
    [9] = gf_localize_string("九"),
    [10] = gf_localize_string("十"),
    [11] = gf_localize_string("十一"),
    [12] = gf_localize_string("十二"),
    [13] = gf_localize_string("十三"),
    [14] = gf_localize_string("十四"),

    [100] = gf_localize_string("第%s章 · %s"),
    [101] = gf_localize_string("%d分%d秒后才能再次挑战。"),
    [102] = gf_localize_string("奖励已领取"),
    [103] = gf_localize_string("获得%s"),
    [104] = gf_localize_string("第%s关"),
    [105] = gf_localize_string("没有奖励"),

}

local challengeView = class(UIBase,function(self,item_obj)
	self.item_obj = item_obj
	StateManager:register_view(self)
	UIBase._ctor(self, res[1], item_obj)
end)

--资源加载完成
function challengeView:on_asset_load(key,asset)

end
 
function challengeView:data_init()
	self.copy_code = -1
	self.cd_time = -1
end

function challengeView:init_ui(index)
	self:init_right_view(self.copy_code)
	self:update_button_state()
	self:init_view_max(self.copy_code)
end

function challengeView:init_right_view(copy_code)
	print("init copy_code:",copy_code)
	local info = dataUse.getCopyInfo(copy_code)
	gf_print_table(info, "info wtf:")
	if not next(info or {}) then
		return
	end
	--章节
	self.refer:Get(5).text = string.format(commom_string[100],commom_string[info.chapter_code],info.chapter_name)
	-- self.refer:Get(6).text = info.name
		
	--节
	self.refer:Get(10).text = string.format(commom_string[104],commom_string[info.section_code])
	
	--称号
	local title_info = ConfigMgr:get_config("title")[info.title_reward]
		
	--颜色
	local color = gf_get_color(title_info.color_limit)
	local str = "<color=%s>%s</color>"
	self.refer:Get(8).text = string.format(str,color,title_info.name)

	--boss模型
	local model = self.refer:Get(9)
	
	if model.transform:FindChild("my_model") then
 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
 	end
		
	local callback = function(c_model)
		if model.transform:FindChild("my_model") then
	 		LuaHelper.Destroy(model.transform:FindChild("my_model").gameObject)
	 	end
		c_model.name = "my_model"
	end

  	local boss_info = ConfigMgr:get_config("creature")[info.boss_id]
	local heroModel = boss_info.model_id
	local scale = info.scale
	local modelView = require("common.uiModel")(model.gameObject,Vector3(-0.1,-1,4),false,career,{model_name = heroModel..".u3d",default_angles= Vector3(0,158,0),scale_rate=Vector3(scale,scale,scale)},callback)

	--boss name
	self.refer:Get(11).text = boss_info.name
end

function challengeView:init_view_max(copy_code)
	local info = dataUse.getCopyInfo(copy_code)
	if next(info or {}) then
		return
	end
	self:init_right_view(self.copy_code - 1)

	self.refer:Get(12):SetActive(true)
	self.refer:Get(13).interactable = false

end

--更新按钮状态
function challengeView:update_button_state()
	--如果在cd中
	if self:is_cd() and self.is_touch then
		self.refer:Get(3):SetActive(false)
		self.refer:Get(4):SetActive(true)
		self.refer:Get(7).interactable = false
		self:start_scheduler()
		return
	end
	self.refer:Get(3):SetActive(true)
	self.refer:Get(4):SetActive(false)
	self.refer:Get(7).interactable = true
end

function challengeView:start_scheduler()
	print("start_scheduler wtf")
	if self.schedule_id then
		self:stop_schedule()
	end
	local end_time = self:get_cd_time()
	local update = function()
		local left_time = end_time - Net:get_server_time_s()
		if left_time <= 0 then
			self:stop_schedule()
			self:update_button_state()
			return
		end
		local str = gf_convert_time_ms(left_time)
		self.refer:Get(2).text = str
	end
	update()
	self.schedule_id = Schedule(update, 0.5)
end
function challengeView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function challengeView:is_cd()
	local end_time = self:get_cd_time()
	local left_time = end_time - Net:get_server_time_s()
	if end_time > 0 and left_time > 0 then
		return true
	end
	return false
end

function challengeView:title_click()
	-- gf_message_tips("查看称号")
	local info = ConfigMgr:get_config("holy_copy")[self.copy_code]
	if next(info or {}) then
		require("models.challenge.titleTip")(info.title_reward)
	end
end

function challengeView:strenge_click()
	require("models.challenge.holyView")()
end

function challengeView:challenge_click()
	if self:is_cd() then
		self.is_touch = true
		local end_time = self:get_cd_time()
		local left_time = end_time - Net:get_server_time_s()
		local s = left_time%60
    	local m = (math.floor(left_time/60))%60

    	gf_message_tips(string.format(commom_string[101],m,s))

		self:update_button_state()
		return
	end
	Sound:play(ClientEnum.SOUND_KEY.INTO_COPY_BTN)
	gf_getItemObject("challenge"):send_to_enter_challenge()
end

function challengeView:daily_reward_click()
	-- gf_message_tips("日常奖励")
	gf_getItemObject("challenge"):send_to_get_reward()
end

--鼠标单击事件
function challengeView:on_click(obj, arg)
    local event_name = obj.name
    print("challenge view click:",event_name)
    if event_name == "closeBtn" then 
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效

    elseif event_name == "title_button" then
    	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:title_click()

    elseif event_name == "halidom_Strengthen_btn" then
    	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:strenge_click()

    elseif event_name == "challenge_btn" then
    	        -- Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:challenge_click()
    	-- self:hide()

    elseif event_name == "get_daily_award" then
    	        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:daily_reward_click()

    end

end

function challengeView:clear()
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function challengeView:dispose()
	self:clear()
	self:stop_schedule()
    self._base.dispose(self)
end

function challengeView:on_showed()
	gf_getItemObject("challenge"):send_to_get_challenge_data()
end

function challengeView:on_hided()
	self:stop_schedule()
end

function challengeView:get_cd_time()
	return self.cd_time
end
function challengeView:get_copy_code()
	return self.copy_code
end
function challengeView:rec_data(msg)
	self.copy_code = msg.code
	self.cd_time = msg.cdTime or 0
	self:init_ui()
end

function challengeView:rec_reward(msg)
	gf_print_table(msg, name)

	if not msg.reward then
		gf_message_tips(commom_string[105])
		return
	end
	--空表 飘字奖励已领取
	if not next(msg.reward or {}) then
		gf_message_tips(commom_string[102])
		return
	end
	local str = ""
	gf_print_table(msg.reward, "wtf reward:")
	for i,v in ipairs(msg.reward or {}) do
		local name = dataUse.getHolyInfo(v.code).coin_name
		local count = v.num
		str = str .. string.format("%s*%d",name,count)
		if i ~= #msg.reward then
			str = str .. " "
		end
	end
	print("str:",str,string.format(commom_string[103],str))
	gf_message_tips(string.format(commom_string[103],str))
end

function challengeView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "GetHolyCopyInfoR") then
			self:rec_data(msg)

		elseif id2 == Net:get_id2(model_name, "DailyRewardR") then
			self:rec_reward(msg)

		end
	end

end

return challengeView





--[[

function challengeView:sitem_click(event_name,arg)
	if self.arg then
		gf_setImageTexture(self.arg, res[3])
	end
	self.arg = arg
	gf_setImageTexture(self.arg, res[2])
	local index = string.gsub(event_name,"sitem","")
	index = tonumber(index)
	self.sindex = index
	self.lbindex = self.index
end

function challengeView:item_click(event_name)
	self.arg = nil
	self.is_get = false
	local index = string.gsub(event_name,"bitem","")
	index = tonumber(index)
	if self.index and self.index == index then
		self.index = nil
		self:init_ui(-1)
		return
	end
	self.index = index
	self:init_left_view(index)
end

function challengeView:init_left_view(index)
	local data = dataUse.get_rank_data_ex(index or -1)
	gf_print_table(data, "data:")
	local pItem = self.refer:Get(1)
	local copyItem1 = self.refer:Get(2)
	local copyItem2 = self.refer:Get(3)
	local copyItem3 = self.refer:Get(4)
	-- local copyItem4 = self.refer:Get(5)

	for i=1,pItem.transform.childCount do
  		local go = pItem.transform:GetChild(i - 1).gameObject
		LuaHelper.Destroy(go)
  	end

	for i,v in ipairs(data or {}) do
		local copyItem = index == i and copyItem1 or copyItem2
		local item = LuaHelper.InstantiateLocal(copyItem.gameObject,pItem.gameObject)
		item.name = "bitem"..i
		item.gameObject:SetActive(true)
		item.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = v[1].sname
		--如果是打开项
		if index == i then
			for ii,vv in ipairs(v) do
				local item = LuaHelper.InstantiateLocal(copyItem3.gameObject,pItem.gameObject)
				item.gameObject:SetActive(true)
				--是否被选中
				if self.lbindex and self.lbindex == i and self.sindex == ii then
					local image = item:GetComponent(UnityEngine_UI_Image)
					self.arg = image
					gf_setImageTexture(image, res[2])
				end 
				item.transform.transform:FindChild("Text"):GetComponent("UnityEngine.UI.Text").text = vv.name
				item.transform.name = "sitem"..ii
			end
		end
	end
end]]