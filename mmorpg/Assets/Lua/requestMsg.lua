--[[--
-- 登录需要请求的协议
-- @Author:Seven
-- @DateTime:2017-06-08 21:01:53
--]]

local tbl = {}

function tbl:request_msg()
	LuaItemManager:get_item_obejct("guide"):get_guide_step_c2s() 						--GetNewerStep
	LuaItemManager:get_item_obejct("vipPrivileged"):get_vip_info_c2s()					--GetVipInfo
	LuaItemManager:get_item_obejct("team"):sendToGetTeamInfo()							--GetPlayerTeam
	LuaItemManager:get_item_obejct("hero"):sendToGetHeroInfo()							--GetHeroInfo
	LuaItemManager:get_item_obejct("horse"):send_to_get_horse_info()					--GetHorseInfo
	LuaItemManager:get_item_obejct("skill"):get_skill_list_c2c()						--GetSkillList
	LuaItemManager:get_item_obejct("legion"):get_my_info_c2s()							--GetMyInfo
	LuaItemManager:get_item_obejct("legion"):get_member_list_c2s()						--"alliance", "GetMemberList"
	LuaItemManager:get_item_obejct("legion"):get_base_info_c2s()						--"alliance", "GetBaseInfo"
	LuaItemManager:get_item_obejct("legion"):get_apply_list_c2s()						--"alliance", "GetApplyList"
	LuaItemManager:get_item_obejct("offline"):get_offline_times()--获取离线经验			--"base","GetOfflineExpInfo"
	
	LuaItemManager:get_item_obejct("gameOfTitle"):get_title_list_c2s()					--"scene","GetTitleList"
	LuaItemManager:get_item_obejct("sit"):get_auto_accept_c2s()							--"scene", "GetAutoAccept"
	LuaItemManager:get_item_obejct("activeDaily"):get_daily_list_c2s()					--"task","GetDailyList"
	LuaItemManager:get_item_obejct("activeDaily"):get_everyday_taskinfo_c2s()			--"task","GetEveryDayTaskInfo"
	LuaItemManager:get_item_obejct("moneyTree"):moneytree_info_c2s()					--"shop","MoneyTreeInfo"
	LuaItemManager:get_item_obejct("train"):send_to_get_train_data()					--"alliance","GetTrainInfo"
	LuaItemManager:get_item_obejct("setting"):get_auto_combat_conf_c2s()				--"scene", "GetAutoCombatConf"
	LuaItemManager:get_item_obejct("skyTask"):get_daily_task_info_c2s()					--"task", "GetDailyTaskInfo"
	LuaItemManager:get_item_obejct("bag"):get_bag_item_list_c2s(1,1)--获取普通背包		--"bag","GetBagInfo
	LuaItemManager:get_item_obejct("bag"):get_bag_item_list_c2s(2,2)--获取身上			
	LuaItemManager:get_item_obejct("bag"):get_bag_item_list_c2s(3,3)--获取仓库
	LuaItemManager:get_item_obejct("equip"):formula_accumulate_c2s()--获取神器值 		--"bag","FormulaAccumulate"
	LuaItemManager:get_item_obejct("equip"):enhance_info_c2s()--获取强化信息			--"bag","EnhanceInfo"
	LuaItemManager:get_item_obejct("equip"):equip_gem_c2s()--获取宝石镶嵌信息			--"bag","GemInfo"
	LuaItemManager:get_item_obejct("equip"):get_polish_info_c2s()--获取宝石镶嵌信息		--"bag","GetPolishInfo"
	LuaItemManager:get_item_obejct("officerPosition"):get_office_info_c2s()				--"base","GetOfficeInfo"
	LuaItemManager:get_item_obejct("copy"):get_tower_info_c2s()							--"copy", "GetTowerInfo"

	LuaItemManager:get_item_obejct("pvp"):send_to_get_pvp_data()						--"copy","ArenaInfo"

	LuaItemManager:get_item_obejct("copy"):get_material_copy_data_c2s()					--"copy", "GetMaterialCopyInfo"

	LuaItemManager:get_item_obejct("copy"):get_team_copy_enter_time_c2s()				-- "team", "TeamCopyPassTimes"

	LuaItemManager:get_item_obejct("market"):get_market_info_c2s()						--"shop","GetMarketInfo"
	LuaItemManager:get_item_obejct("email"):login_get_email_info_c2s()					--"email","LoginGetEmailInfo"
	-- LuaItemManager:get_item_obejct("chat"):get_history_chat_c2s() -- 世界频道消息记录			          
	LuaItemManager:get_item_obejct("chat"):get_chat_list_c2s() -- 私聊离线消息列表							--"friend","GetChatList"			
	LuaItemManager:get_item_obejct("social"):friend_preread_c2s() -- 获取离线好友信息（有没有申请加好友） 	--"friend","FriendPreread"
	LuaItemManager:get_item_obejct("social"):get_black_list_c2s() -- 私聊黑名单								--"friend","GetBlackList"
	LuaItemManager:get_item_obejct("husong"):escort_openui_c2s() --护送任务									-- "task", "EscortOpenUI"
	LuaItemManager:get_item_obejct("sign"):get_signin_info_c2s() --签到信息									--"bag","GetSigninInfo"
	LuaItemManager:get_item_obejct("sign"):online_gift_info_c2s() --签到信息								--"bag","OnlineGiftInfo"
	LuaItemManager:get_item_obejct("sign"):get_level_gift_list_c2s() --等级礼包信息							--"base","GetLevelGiftList"
	LuaItemManager:get_item_obejct("sign"):get_login_gift_list_c2s()--15天登录信息							--"base","GetLoginGiftList"
	LuaItemManager:get_item_obejct("sign"):invest_info_c2s()--投资信息										--"shop","InvestInfo"
	LuaItemManager:get_item_obejct("sign"):week_month_card_info_c2s()--月卡信息								--"shop","WeekMonthCardInfo"
	LuaItemManager:get_item_obejct("sign"):free_strenght_info_c2s()--体力午餐晚餐信息						--"shop","FreeStrenghtInfo"
	LuaItemManager:get_item_obejct("zorkPractice"):practice_time_c2s()--获取魔域十倍修炼时间和开启状态		--"scene","GetDeathtrapInfo"
	LuaItemManager:get_item_obejct("surface"):get_surface_info_c2s()--获取外观								--"bag", "GetSurfaceInfo"
	LuaItemManager:get_item_obejct("luckyDraw"):GetLotteryInfo_c2s()--获取秘境寻宝初始信息					--"base", "GetLotteryInfo"
	LuaItemManager:get_item_obejct("destiny"):get_all_destiny_for_sever() -- 获取天命背包信息				--"bag","GetDestinyVOArr"
	LuaItemManager:get_item_obejct("setting"):get_safty_state_c2s()--获取安全锁状态							--"base", "GetSaftyState"
end

return tbl