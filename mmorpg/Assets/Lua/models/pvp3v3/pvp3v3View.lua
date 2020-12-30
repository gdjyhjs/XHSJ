--[[
	3v3系统主界面
	create at 17.9.19
	by xin
]]
local Enum = require("enum.enum")
local LuaHelper = LuaHelper

local model_name = "team"

local res = 
{
	[1] = "rvr_3v3.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string("%d分钟后开启"),
	[2] = gf_localize_string("活动尚未开始，请注意开启时间"),
	[3] = gf_localize_string("请先退出当前队伍")
}

local dataUse = require("models.pvp3v3.dataUse")

local pk3v3View=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
	self.item_obj=item_obj
  	Asset._ctor(self, res[1]) -- 资源名字全部是小写
end)


--资源加载完成
function pk3v3View:on_asset_load(key,asset)
	self.item_obj:register_event("pvp3v3_view_on_click", handler(self, self.on_click))
end

function pk3v3View:init_ui()
	gf_mask_show(false)
	--开始时间
	self.refer:Get(3).text = string.format("%s-%s", gf_convert_time_hm(ConfigMgr:get_config("t_misc").pvp_3v3_open_time),gf_convert_time_hm(ConfigMgr:get_config("t_misc").pvp_3v3_open_time + ConfigMgr:get_config("t_misc").pvp_3v3_duration_time))
	
	local score = gf_getItemObject("pvp3v3"):get_my_score()
	local left = dataUse.get_left_score(score)
	--段位
	local data = dataUse.get_rank_data_by_score(score)
	self.refer:Get(1).text = data.name

	--积分
	self.refer:Get(2).text = string.format("%d/%d",left,data.score_max - data.score_min)
	--段位积分比例
	self.refer:Get(4).value = (left) / (data.score_max - data.score_min)

	gf_setImageTexture(self.refer:Get(5), data.icon)
end

function pk3v3View:shop_click()
	gf_open_model(ClientEnum.MODULE_TYPE.MALL,nil,nil,gf_get_config_const("shop_honor_type"))
end

function pk3v3View:record_click()
	require("models.pvp3v3.record")()
end

function pk3v3View:enter_click()
	local matching_time = gf_getItemObject("pvp3v3"):get_matching_time()
	print("Net:get_server_time_s() <= matching_time:",Net:get_server_time_s() , matching_time)
	if Net:get_server_time_s() <= matching_time then
		gf_message_tips(gf_localize_string("正在匹配，请稍后再试"))
		return
	end
	--如果是组队状态
	if gf_getItemObject("team"):is_in_team() then
		gf_message_tips(commom_string[3])
		return
	end
	gf_getItemObject("pvp3v3"):send_to_enter_fight_c2s()

	-- local MemberSimpleInfo1 = 		
	-- {
	-- 	name		="测试1",
	-- 	power 		=9999,
	-- 	career 		=2,
	-- }
	-- local MemberSimpleInfo2 = 		
	-- {
	-- 	name		="测试2",
	-- 	power 		=9999,
	-- 	career 		=1,
	-- }
	-- local MemberSimpleInfo3 = 		
	-- {
	-- 	name		="测试3",
	-- 	power 		=9999,
	-- 	career 		=4,
	-- }
	-- local MemberSimpleInfo4 = 		
	-- {
	-- 	name		="测试4",
	-- 	power 		=9999,
	-- 	career 		=2,
	-- }
	-- local MemberSimpleInfo5 = 		
	-- {
	-- 	name		="测试5",
	-- 	power 		=9999,
	-- 	career 		=4,
	-- }
	-- local MemberSimpleInfo6 = 		
	-- {
	-- 	name		="测试6",
	-- 	power 		=9999,
	-- 	career 		=1,
	-- }
	-- local msg = {teamInfo = {MemberSimpleInfo1,MemberSimpleInfo2,MemberSimpleInfo3,MemberSimpleInfo4,MemberSimpleInfo5,MemberSimpleInfo6}}

	-- gf_send_and_receive(msg, "team", "TeamVsCopyMatchSuccessNotifyR", sid)


	--如果是在等待时间中
	-- local zero_time = gf_get_server_zero_time()
	-- local sever_time = Net:get_server_time_s()
	-- local show_red = sever_time >= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time - ConfigMgr:get_config("t_misc").pvp_3v3_wait_time - ConfigMgr:get_config("t_misc").pvp_3v3_wait_effect_time and sever_time <= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time 
	-- if show_red then
	-- 	gf_message_tips(commom_string[1])
	-- 	return
	-- else
	-- 	local show = sever_time >= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time  and sever_time <= zero_time + ConfigMgr:get_config("t_misc").pvp_3v3_open_time + ConfigMgr:get_config("t_misc").pvp_3v3_duration_time
	-- 	if show then
	-- 		gf_getItemObject("pvp3v3"):send_to_enter_fight_c2s()
	-- 		return
	-- 	end
	-- 	gf_message_tips(commom_string[2])
	-- end
	
end

function pk3v3View:stage_click()
	require("models.pvp3v3.tvtGrade")()

end

--鼠标单击事件
function pk3v3View:on_click(item_obj, obj, arg)
    local event_name = obj.name
    print("pk3v3 click",event_name)
    if event_name == "close_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 通用按钮点击音效
    	self:hide()

    elseif event_name == "integral_shop_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:shop_click()

    elseif event_name == "battle_record_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:record_click()

    elseif event_name == "enter_battle_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:enter_click()

    elseif event_name == "stage_click" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:stage_click()

    elseif event_name == "help_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_show_doubt(1101)

    end

end
 
function pk3v3View:clear()
end
-- 释放资源 资源删除  lua对象没有删除 要及时清除lua引用
function pk3v3View:dispose()
	self:clear()
    self._base.dispose(self)
end

function pk3v3View:on_showed()
	-- self:init_ui()
	gf_getItemObject("pvp3v3"):send_to_get_myscore_c2s()

	gf_mask_show(true)

	-- local msg = {}
	-- msg.score = 499
	-- gf_send_and_receive(msg, "copy", "TeamVsCopyInfoR", sid)
end


function pk3v3View:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "TeamVsCopyMatchR") then
			self:hide()
			require("models.pvp3v3.waitView")(msg)
		end
	end
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "TeamVsCopyInfoR") then
			self:init_ui()
		end
	end

end

return pk3v3View