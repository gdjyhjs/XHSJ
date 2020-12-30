--[[
	pvp挑战界面  
	create at 17.8.1
	by xin
]]

local dataUse = require("models.pvp.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local res = 
{
	[1] = "pvp_challenge.u3d",
	[2] = "arena_icon_01",
	[3] = "arena_icon_02",
}
local save_key = "%d_pvp"

local commom_string = 
{
	[1] = gf_localize_string("排名：%d"),
	[2] = gf_localize_string("积分：%d"),
	[3] = gf_localize_string("剩余次数：%d"),
	[4] = gf_localize_string("连胜次数：%d"),
	[5] = gf_localize_string("确定要花费<color=#B01FE5>%d</color>元宝增加<color=#B01FE5>1</color>次挑战次数吗?今日还可增加<color=#B01FE5>%d</color>次"),
	[6] = gf_localize_string("今日不再提醒"),
	[7] = gf_localize_string("还没到结算时间"),
	[8] = gf_localize_string("今日购买挑战次数已用完，提升VIP等级可增加购买次数！"),
	[9] = gf_localize_string("今日挑战次数已用完"),
	[10] = gf_localize_string("排名:未上榜"),
	[11] = gf_localize_string("积分:未挑战"),
	[12] = gf_localize_string("还没有和别人战斗过，赶紧去进行本周第一次竞技吧！"),
	[13] = gf_localize_string("%d<color=#C03E3EFF>-%d</color>"),
	[14] = gf_localize_string("%d<color=#53A43DFF>+%d</color>"),
	[15] = gf_localize_string("胜利"),
	[16] = gf_localize_string("失败"),
	[17] = gf_localize_string("不能挑战自己"),

}	


local challenge = class(UIBase,function(self,type)
	self.type = type
	local item_obj = LuaItemManager:get_item_obejct("pvp")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function challenge:on_asset_load(key,asset)
	
end

--初始化我的排名数据
function challenge:init_my_view()

	self:update_button_state()

	gf_getItemObject("pvp"):send_to_get_left_buy()

	local data = gf_getItemObject("pvp"):get_my_pvp_data()
	local rank_num = data.rank
	local num = data.score
	local left_count = data.leftTime
	local win_count = data.winStreak


	local refresh_time = gf_get_server_zero_time() + ConfigMgr:get_config("t_misc").pvp_reward_refresh_time
	self.refresh_time = refresh_time

	--排名
	self.refer:Get(1).text = rank_num <=0 and commom_string[10] or string.format(commom_string[1],rank_num)
	
	--积分
	self.refer:Get(2).text = num <= 0 and commom_string[11] or string.format(commom_string[2],num) 
	
	--挑战次数
	self.refer:Get(3).text = string.format(commom_string[3],left_count)  
	--连胜次数
	self.refer:Get(4).text = string.format(commom_string[4],win_count)   

	--奖励发放时间
	self:set_refresh_time(refresh_time)

	--段位奖励
	local rank = dataUse.get_stage_by_score(num)
	local reward = dataUse.get_rank_reward(rank)
	self.refer:Get(6).text = reward[1][2]
	self.refer:Get(8).text = reward[2][2]

	gf_set_money_ico(self.refer:Get(7), reward[1][1])
	gf_set_money_ico(self.refer:Get(9), reward[2][1])

	--排名icon
	gf_setImageTexture(self.refer:Get(10), dataUse.get_stage_icon(rank))

end

function challenge:update_button_state()
	local data = gf_getItemObject("pvp"):get_my_pvp_data()
	--如果到时间 而且可领取
	if data.canGetReward then
		--添加特效
	end
end

function challenge:init_scrollview(viewData)
	local scroll_rect_table = self.refer:Get(11)
 		
 	scroll_rect_table.data = {}

 	if not next(viewData or {}) then
 		self.refer:Get(12).gameObject:SetActive(true)
 		return
 	else
 		self.refer:Get(12).gameObject:SetActive(false)
 	end

 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数
		scroll_rect_item.gameObject:SetActive(true) --显示项
		--头像
		gf_set_head_ico(scroll_rect_item:Get(1), data_item.head)
		--名字
		scroll_rect_item:Get(3).text = data_item.name
		--等级
		scroll_rect_item:Get(2).text = data_item.level
		--积分
		scroll_rect_item:Get(4).text = data_item.score
		
		scroll_rect_item:Get(6).gameObject:SetActive(false)
		if data_item.heroCode and data_item.heroCode > 0 then
			scroll_rect_item:Get(6).gameObject:SetActive(true)
			local dataUse = require("models.hero.dataUse")
			local heroType = dataUse.getHeroQuality(data_item.heroCode)
			local qualityIcon = dataUse.getHeroQualityIcon(heroType)
			--武将品质
			gf_setImageTexture(scroll_rect_item:Get(5), qualityIcon)
			--武将头像
			gf_setImageTexture(scroll_rect_item:Get(6), dataUse.getHeroHeadIcon(data_item.heroCode))
		else
			--武将品质
			gf_setImageTexture(scroll_rect_item:Get(5), "item_color_0")
			--武将头像
			gf_setImageTexture(scroll_rect_item:Get(6), "transparent")
		end
		print("wtf index:",index)
		if index == #scroll_rect_table.data then
			scroll_rect_item:Get(7):SetActive(false)
		else
			scroll_rect_item:Get(7):SetActive(true)
		end

	end

	for i,v in ipairs(viewData) do
        local index = scroll_rect_table:InsertData(v, -1)
        scroll_rect_table:Refresh(index-1, index)
    end
end

function challenge:init_scrollview_recode(viewData)
	local scroll_rect_table = self.refer:Get(15)
 		
 	scroll_rect_table.data = {}

 	--排序
 	table.sort(viewData,function(a,b) return a.challengeTime > b.challengeTime end)

 	if not next(viewData or {}) then
 		self.refer:Get(12).gameObject:SetActive(true)
 		return
 	else
 		self.refer:Get(12).gameObject:SetActive(false)
 	end

 	scroll_rect_table.onItemRender = function(scroll_rect_item,index,data_item) --设置渲染函数

 	-- 	local FightRecord = 
		-- {
		-- 	win         	= math.random(0,1) == 1 and true or false,
		-- 	score       	=1,
		-- 	changeScore 	=1,
		-- 	attack      	=math.random(0,1) == 1 and true or false,
		-- 	name        	="test",
		-- 	head        	="1111",
		-- 	level       	=99,
		-- 	challengeTime 	=Net:get_server_time_s(),
		-- }

		scroll_rect_item.gameObject:SetActive(true) --显示项
		-- --头像
		gf_set_head_ico(scroll_rect_item:Get(2), data_item.head)
		-- --名字
		scroll_rect_item:Get(6).text = data_item.name
		-- --等级
		scroll_rect_item:Get(3).text = data_item.level
		-- --积分
		scroll_rect_item:Get(8).text = not data_item.win and string.format(commom_string[13],data_item.score,data_item.changeScore) or string.format(commom_string[14],data_item.score,data_item.changeScore)
		--胜利或失败标志
		gf_setImageTexture(scroll_rect_item:Get(5), data_item.win and res[2] or res[3])
		--胜利或失败标志 字
		scroll_rect_item:Get(1).text = data_item.win and commom_string[15] or commom_string[16]
		--挑战时间
		local time = Net:get_server_time_s() - data_item.challengeTime
		time = time <= 60 and 60 or time
		scroll_rect_item:Get(7).text = gf_convert_time_dhm_ch(time) 
		
		--vip
		scroll_rect_item:Get(9):SetActive((data_item.vipLevel and data_item.vipLevel > 0 or false))
		scroll_rect_item:Get(10).text = data_item.vipLevel or 0

		-- scroll_rect_item:Get(6).gameObject:SetActive(false)
		-- if data_item.heroCode > 0 then
		-- 	scroll_rect_item:Get(6).gameObject:SetActive(true)
		-- 	local dataUse = require("models.hero.dataUse")
		-- 	local heroType = dataUse.getHeroQuality(data_item.heroCode)
		-- 	local qualityIcon = dataUse.getHeroQualityIcon(heroType)
		-- 	--武将品质
		-- 	gf_setImageTexture(scroll_rect_item:Get(5), qualityIcon)
		-- 	--武将头像
		-- 	gf_setImageTexture(scroll_rect_item:Get(6), dataUse.getHeroHeadIcon(data_item.heroCode))
			
		-- end

	end

	for i,v in ipairs(viewData) do
        local index = scroll_rect_table:InsertData(v, -1)
        scroll_rect_table:Refresh(index-1, index)
    end
end

function challenge:set_refresh_time(refresh_time)
	if refresh_time >=0 then
		self:start_scheduler(refresh_time)
	end
end
function challenge:start_scheduler(refresh_time)
	if self.schedule_id then
		self:stop_schedule()
	end
	local update = function()
		local left_time = refresh_time - Net:get_server_time_s()
		left_time = left_time <= 0 and 0 or left_time
		self.refer:Get(5).text = gf_convert_time(left_time)
		if left_time <= 0 then
			self:stop_schedule()
		end
	end
	self.schedule_id = Schedule(update, 0.5)
end
function challenge:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function challenge:item_click(arg)

	local left_time = gf_getItemObject("pvp"):get_my_pvp_data().leftTime
	local left_buy_time = gf_getItemObject("pvp"):get_left_buy_count()
	if left_time <= 0 and left_buy_time <= 0 then
		gf_message_tips(commom_string[9])
		return
	end
	if left_time <= 0 and left_buy_time > 0 then
		self:add_count_click()
		return
	end
	local item = arg:GetComponent("Hugula.UGUIExtend.ScrollRectItem")
	local index = item.index + 1 		 --索引从零开始

	local roleId = self.enemyList[index].roleId
	local my_role_id = gf_getItemObject("game"):getId()
	if my_role_id == roleId then
		gf_message_tips(commom_string[17])
		return
	end
	gf_getItemObject("copy"):enter_copy_c2s(ConfigMgr:get_config("t_misc").special_copy_code.arena,nil,roleId,self.enemyList[index])

end

function challenge:add_count_click()
	local left_time = gf_getItemObject("pvp"):get_left_buy_count()
	local c_date = os.date("%x",Net:get_server_time_s())

	local my_role_id = gf_getItemObject("game"):getId()
	local s_date = PlayerPrefs.GetString(string.format(save_key,my_role_id),os.date("%x",Net:get_server_time_s() - 24 * 60 * 60))

	local check_func = function()
		if left_time <= 0 then
			return true
		end
		return false
	end

	if c_date == s_date then
		if check_func() then
			LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(commom_string[8])
			return
		end
		gf_getItemObject("pvp"):send_to_add_challenge_count()
		return
	end

	local save = function()
		PlayerPrefs.SetString(string.format(save_key,my_role_id),c_date)
	end

	local sfunc = function(a,b)
		if b then
			save()
		end
		if check_func() then
			return
		end
		gf_getItemObject("pvp"):send_to_add_challenge_count()
	end
	local cfunc = function(a,b)
		if b then
			save()
		end
	end

	
	print("wtf left_time:",left_time)
	--次数不足
	if left_time <= 0 then
		LuaItemManager:get_item_obejct("cCMP"):ok_cancle_message(commom_string[8])
		return
	end

	local price  = ConfigMgr:get_config("t_misc").arena.add_challenge_cost[2]
	local show_content = string.format(commom_string[5],price,left_time)
	LuaItemManager:get_item_obejct("cCMP"):toggle_message(show_content,false,commom_string[6],sfunc,cfunc)
end

function challenge:change_click()
	gf_getItemObject("pvp"):send_to_refresh()
end

function challenge:get_reward_click()
	--如果未到奖励时间
	local data = gf_getItemObject("pvp"):get_my_pvp_data()
	-- if not data.canGetReward then
	-- 	gf_message_tips(commom_string[7])
	-- 	return
	-- end
	gf_getItemObject("pvp"):send_to_get_reward()
end

function challenge:shop_click()
	gf_open_model(ClientEnum.MODULE_TYPE.MALL,3,1,gf_get_config_const("shop_coin_type"))
end

--鼠标单击事件
function challenge:on_click( obj, arg)
    local event_name = obj.name
    print("event_name:",event_name)
    if event_name == "challenge_btn" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:item_click(arg)

    elseif event_name == "add_count_button" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:add_count_click()

    elseif event_name == "btn_change" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:change_click()

    elseif event_name == "btn_b_heBing" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:get_reward_click()

    elseif event_name == "btn_shop" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	self:shop_click()

    elseif event_name == "help_btn" then
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    	gf_show_doubt(1041)

    end
end

function challenge:on_showed()
	StateManager:register_view(self)

	-- self:init_scrollview({})

	if self.type == 1 then
		gf_getItemObject("pvp"):send_to_get_pvp_data()
	elseif self.type == 2 then
		gf_getItemObject("pvp"):send_to_get_record()

		-- local FightRecord = 
		-- {
		-- 	win         	= math.random(0,1) == 1 and true or false,
		-- 	score       	=1,
		-- 	changeScore 	=1,
		-- 	attack      	=math.random(0,1) == 1 and true or false,
		-- 	name        	="test",
		-- 	head        	="1111",
		-- 	level       	=99,
		-- 	challengeTime 	= Net:get_server_time_s() - 3800,
		-- }
		-- local msg = {}
		-- msg.record = {FightRecord,FightRecord,FightRecord}
		-- gf_send_and_receive(msg,"copy","ArenaFightRecordR")

	end
	
end

-- 释放资源
function challenge:dispose()
	self:stop_schedule()
	StateManager:remove_register_view(self)
    self._base.dispose(self)
end
function challenge:on_hided()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function challenge:hide_clear()
	self:stop_schedule()
	StateManager:remove_register_view(self)
end

function challenge:recArenaInfo(msg)
	gf_print_table(msg, "wtf ArenaInfoR:")
	
	self:init_my_view()

	self:init_enemy_list(msg.enemyList)
end

function challenge:show_scroll_view(show)
	self.refer:Get(16):SetActive(show)
	self.refer:Get(17):SetActive(not show)

end


function challenge:init_enemy_list(list)
	self.enemyList = list
	self:show_scroll_view(true)
	self:init_scrollview_recode({})
	self:init_scrollview(list)
end

function challenge:recRecordInfo(msg)
	gf_print_table(msg, "ArenaFightRecordR:")
	local enemyList = msg.record
	self:init_scrollview({})
	self:init_my_view()
	self:show_scroll_view(false)
	self:init_scrollview_recode(enemyList)
end

function challenge:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ArenaInfoR") then
			self:recArenaInfo(msg)

		elseif id2 == Net:get_id2(model_name, "ArenaFightRecordR") then
			self:recRecordInfo(msg)

		elseif id2 == Net:get_id2(model_name,"RefreshMatchR") then
			self:init_enemy_list(msg.enemyList)
		
		elseif id2 == Net:get_id2(model_name,"AddChallengeTimesR") then
			self:init_my_view()

		elseif id2 == Net:get_id2(model_name,"GetAddTimesLeftR") then
			-- self:add_count_click()

		end
	end
end

return challenge