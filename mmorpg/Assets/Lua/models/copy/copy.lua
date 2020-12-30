--[[--
-- 副本
-- @Author:Seven
-- @DateTime:2017-05-31 15:29:10
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
require("models.teamCopy.publicFunc")
local Copy = LuaItemManager:get_item_obejct("copy")

local dataUse = require("models.copy.dataUse")

--UI资源
Copy.assets=
{
    View("copyBaseView", Copy) 
}

local TowerIdList = {30001,30002,30003}

--初始化函数只会调用一次
function Copy:initialize()
	print("copy initialize")
	self.chapter_info = {}
	self.story_data = nil
	self.copy_id = -1
	self.is_have_box_server_ =false
	self.tower_sweep_storehouse = {}
	--兵来将挡 时间宝库
	self.material_copy_data = {}
	self.team_copy_enter_time = 0

	
end

function Copy:get_team_copy_enter_time()
	return self.team_copy_enter_time
end

function Copy:clera_chapter_info()
	self.chapter_info = {}
end

function Copy:get_chapter_data_info()
	return self.chapter_info
end

function Copy:is_have_box_server()
	local flag = self.is_have_box_server_
	return flag
end

function Copy:set_default_copy(copy_id)
	self.default_copy_id = copy_id
end

function Copy:get_default_copy()
	return self.default_copy_id 
end

--判断副本是否有宝箱可以开启
function Copy:is_have_box()
	function find_is_open(chapter,idx)
		local getReward = self:get_chapter_info(chapter).getReward
		for i,v in ipairs(getReward or {}) do
			if v == idx then
				return true
			end
		end
		return false
	end

	local chapter_datas = ConfigMgr:get_config("copy_chapter")
	for k,v in pairs(chapter_datas or {}) do
		local chapter_data = gf_getItemObject("copy"):get_chapter_info(v.code)
		local star_count = 0
		for i,v in ipairs(chapter_data.copyInfo or {}) do
			star_count = star_count + v.star
		end
		for i=1,3 do
			return v["star_num_"..i] <= star_count and not find_is_open(v.code,i) 
		end
	end
	return false
end

function Copy:get_chapter_star(chapter_id)
	local star = 0
	for i,v in ipairs(self.chapter_info or {}) do
		if v.chapter == chapter_id then
			for ii,vv in ipairs(v.copyInfo or {}) do
				star = star + vv.star
			end
		end
	end
	return star
end
-- function Copy:create_copy_view(index)
-- 	-- self:set_view_param(index)
-- 	gf_create_model_view("copy",index)
-- end

-- function Copy:set_view_param(index)
-- 	self.index = index
-- end

-- function Copy:get_view_param()
-- 	return self.index 
-- end
-- 设置当前进入副本的数据
function Copy:set_cur_copy_data( data )
	self.cur_data = data
	if self:is_story() then
		self:set_story_data(ConfigMgr:get_config("story_copy")[data.code])
	end
end

function Copy:get_chapter_info(chapter)
	for i,v in ipairs(self.chapter_info or {}) do
		if v.chapter == chapter then
			return v
		end
	end
	return nil
end

function Copy:get_challege_count(copy_id)
	for k,v in ipairs(self.chapter_info or {}) do
		for ii,vv in ipairs(v.copyInfo or {}) do
			if vv.copyCode == copy_id then
				return vv.challenge
			end
		end
	end
	return 0
end

function Copy:get_chapter_data(chapter,copy_id)
	for ii,vv in ipairs(self.chapter_info or {}) do
		for i,v in ipairs(vv.copyInfo or {}) do
			if v.copyCode == copy_id then
				return v
			end
		end
	end
	return nil
end

function Copy:get_chapter_data_byid(copy_id)
	for i,v in ipairs(self.chapter_info or {}) do
		for ii,vv in ipairs(v.copyInfo or {}) do
			if vv.copyCode == copy_id then
				return vv
			end
		end
	end
	return {}
end

function Copy:get_cur_copy_data()
	return self.cur_data
end

function Copy:set_copy_id(id)
	print("set copy id",id)
	self.copy_id = id
end

function Copy:get_copy_id()
	return self.copy_id
end

--判断当前副本类型
function Copy:is_copy_type(copy_type)
	print("self.copy_id :",self.copy_id,copy_type)
	if self.copy_id and self.copy_id > 0 and dataUse.getCopyType(self.copy_id) == copy_type then
		return true
	end
	return false
end

function Copy:is_copy()
	return self.copy_id > 0
	-- return self.cur_data ~= nil
end

-- 是否是剧情副本
function Copy:is_story()
	if not self.cur_data then
		return false
	end
	return self.cur_data.type == ServerEnum.COPY_TYPE.STORY
end

-- 是否是过关砍将
function Copy:is_challenge()
	return self.copy_id == ConfigMgr:get_config("t_misc").copy.holy_copy_code
end

function Copy:is_pvp()
	return self.copy_id == ConfigMgr:get_config("t_misc").special_copy_code.arena
end

function Copy:is_material_defence()
	return self:is_copy_type(ServerEnum.COPY_TYPE.MATERIAL)
end
function Copy:is_material_time_treasury()
	return self:is_copy_type(ServerEnum.COPY_TYPE.MATERIAL2)
end
function Copy:is_pvptvt()
	return self:is_copy_type(ServerEnum.COPY_TYPE.TEAM_VS)
end

function Copy:is_mozu()
	return self:is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY)
end
-- 是否是爬塔
function Copy:is_tower()
	if not self.cur_data then
		return false
	end
	return self.cur_data.type == ServerEnum.COPY_TYPE.TOWER
end

--是否是组队副本
function Copy:is_team()
	return self:is_copy_type(ServerEnum.COPY_TYPE.TEAM)
end

function Copy:set_story_data( data )
	self.story_data = data
end

function Copy:get_story_data()
	return self.story_data
end

-- 是否要在任务面板显示副本信息
function Copy:is_show_task()
	return self:is_story() or self:is_tower() or self:is_copy_type(ServerEnum.COPY_TYPE.MATERIAL)
end

-- 是否要隐藏主界面右上角ui
function Copy:is_hide_right_top_mainui()
	return self:is_story() or self:is_challenge() or self:is_tower() or LuaItemManager:get_item_obejct("boss"):is_boss_scene() or self:is_pvp() or LuaItemManager:get_item_obejct("boss"):is_magic()
end

-- 设置进入副本的事件搓
function Copy:set_time( time )
	self.time = time
end

function Copy:get_time()
	return self.time
end

-- 通过时间获取星星数量
function Copy:get_star_num( time )
	if time <= self.story_data.star3_time then
		return 3
	end

	if time <= self.story_data.star2_time then
		return 2
	end

	return 1
end

-- 通过副本id获取爬塔副本的最高通过层数
-- function Copy:get_tower_floor( copy_id )
-- 	local floor = self.tower_floor[copy_id]
-- 	if not floor then
-- 		return 1
-- 	end
-- 	return floor
-- end

--判断是否已经通过次副本
function Copy:get_is_pass(copy_id)
	-- gf_print_table(self.chapter_info, "self.chapter_info:")
	for k,v in ipairs(self.chapter_info or {}) do
		for ii,vv in ipairs(v.copyInfo or {}) do
			if vv.copyCode == copy_id and vv.star == 3 then
				return true
			end
		end
	end
	return false
end

function Copy:set_copy_pass_count(copy_id,count)
	for k,v in pairs(self.chapter_info or {}) do
		for ii,vv in ipairs(v.copyInfo or {}) do
			if vv.copyCode == copy_id then
				vv.challenge = count
			end
		end
	end
end
function Copy:set_copy_reset_count(copy_id,count)
	for k,v in pairs(self.chapter_info or {}) do
		for ii,vv in ipairs(v.copyInfo or {}) do
			if vv.copyCode == copy_id then
				vv.reset = vv.reset + count
			end
		end
	end
end
-- 通过副本id获取爬塔状态
function Copy:get_tower_state( copy_id )
	local state = self.tower_state[copy_id]
	if not state then
		return ServerEnum.COPY_TOWER_STATE.OPEN
	end
	return state
end

--获取pvp敌人数据
function Copy:get_enemy_data()
	return self.enemyData
end

-- 获取爬塔扫荡仓库物品
function Copy:get_tower_sweep_storehouse()
	return self.tower_sweep_storehouse
end

-- 获取爬塔副本列表
function Copy:get_tower_id_list()
	return TowerIdList
end

-- 获取爬塔副本层数数据
function Copy:get_tower_floor_data()
	return ConfigMgr:get_config("copy_tower")[self.tower_floor_code]
end

-- 主动退出副本
--is_complete 完成退出
function Copy:exit()
	
	--退出当失败处理 如果是完成副本后的主动退出 奖励界面显示之后清理失败预现界面 self.default_copy_id
	-- 如果是逐鹿战场 不处理
	if not LuaItemManager:get_item_obejct("rvr"):is_rvr() then
		self:set_default_copy(self.copy_id)
	end
	

	self:exit_copy_c2s()
	
end

--点击事件
function Copy:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end

--每次显示时候调用
function Copy:on_showed()
end

function Copy:on_hided()
end

function Copy:clear_data()
	self.cur_data = nil
	self.story_data = nil
	self.copy_id = -1
	self.wave_data = {}
	print("clear data :",self.copy_id)
end

function Copy:test_chapter_data()
	
	local msg = {}

	local StoryCopyInfo = 
	{
		copyCode = 10001,
		star = 2,
		challenge = 1,
		reset = 0,
	}

	local chapter = {
		chapter = 1001,
		copyInfo = {StoryCopyInfo,},
		getReward = {},
	}

	msg.info = {chapter,}

	gf_send_and_receive(msg, "copy", "GetStoryCopyInfoR", sid)
end

function Copy:on_receive(msg, id1, id2, sid)
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "GetStoryCopyInfoR") then -- 取章节信息
			gf_print_table(msg, "wtf GetStoryCopyInfoR")
			self:get_chapter_info_s2c(msg,sid)

		elseif id2 == Net:get_id2("copy", "OpenChapterBoxR") then -- 领取宝箱
			self:get_chapter_box_s2c(msg, sid)

		elseif id2 == Net:get_id2("copy", "EnterCopyR") then -- 进入副本
			self:enter_copy_s2c(msg,sid)

		elseif id2 == Net:get_id2("copy", "PassCopyR") then -- 通关
			self:pass_copy_s2c(msg)

		elseif id2 == Net:get_id2("copy", "SweepCopyR") then -- 扫荡
			self:sweep_copy_s2c(msg,sid)

		elseif id2 == Net:get_id2("copy", "ResetCopyR") then -- 重置
			self:reset_copy_s2c(msg,sid)

		elseif id2 == Net:get_id2("copy", "ExitCopyR") then -- 退出副本
			self:clear_data()
			LuaItemManager:get_item_obejct("battle"):change_scene(msg.mapId)

		elseif id2 == Net:get_id2("copy", "GetTowerInfoR") then -- 获取爬塔副本信息
			gf_print_table(msg,"wtf receive GetTowerInfoR")
			self:get_tower_info_s2c(msg)

		elseif id2 == Net:get_id2("copy", "PassTowerFloorR") then -- 爬塔通过推送
			self:pass_tower_floor_s2c(msg)

		elseif id2 == Net:get_id2("copy", "ContinueChallengeR") then -- 继续挑战
			gf_print_table(msg, "ContinueChallengeR:")
			self:continue_challenge_s2c(msg)

		elseif id2 == Net:get_id2("copy", "GetTowerSweepRewardR") then
			self:get_tower_sweep_reward_s2c(msg)

		elseif id2 == Net:get_id2("copy", "TowerExpiredCopyR") then
			self:tower_exipred_copy_s2c(msg)

		elseif id2 == Net:get_id2("copy", "SweepTowerCopyR") then
			self:sweep_tower_copy_s2c(msg)

		elseif id2 == Net:get_id2("copy", "GetMaterialCopyInfoR") then
			gf_print_table(msg,"wtf receive GetMaterialCopyInfoR")
			self:get_material_copy_data_s2c(msg) 

		elseif id2 == Net:get_id2("copy", "BuyMaterialTimesR") then
			self:material_copy_buy_count_s2c(msg,sid) 

		elseif id2 == Net:get_id2("copy", "RewardNotifyR") then
			gf_print_table(msg, "RewardNotifyR:")
			self.is_have_box_server_ = msg.flag or false
			-- gf_update_mainui_effect(ClientEnum.Copy_Box_Effect)

			Net:receive({ btn_id = ClientEnum.MAIN_UI_BTN.COPY ,visible = self.is_have_box_server_}, ClientProto.ShowAwardEffect)

		elseif id2 == Net:get_id2("copy", "TeamBeginBattleNotifyR") then
			gf_print_table(msg, "wtf TeamBeginBattleNotifyR:")
			self.pvp3v3_begin_time = msg.beginTime

		elseif id2 == Net:get_id2("copy", "CreatureWaveNotifyR") then
			self:rec_wave_notify(msg)

		elseif id2 == Net:get_id2("copy", "SmallGameInfoR") then
			gf_print_table(msg,"wtf SmallGameInfoR ")

		end
	end


	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 取章节信息
			gf_print_table(msg, "TransferMapR:")
			if msg.dstCopyCode and msg.dstCopyCode > 0 then
				self:set_copy_id(msg.dstCopyCode)

			end
		end		
	end

	if id1 == Net:get_id1("team") then
		if id2 == Net:get_id2("team", "TeamCopyPassTimesR") then -- 取章节信息
			gf_print_table(msg,"wtf receive TeamCopyPassTimesR")
			self.team_copy_enter_time = msg.times

		end
	end

	if id1 == ClientProto.FinishScene then
		self:scene_view_show()

	end
end

--根据波次删除遮挡物
function Copy:rec_wave_notify(msg)
	gf_print_table(msg,"CreatureWaveNotifyR:")
	if msg and msg.wave then
		self.wave_data = msg
		gf_getItemObject("battle"):check_block(msg.wave)
	end

end

function Copy:get_wave_data()
	return self.wave_data
end

function Copy:enter_team_copy_c2s(copy_id)
	local msg = {}
	msg.copyCode = copy_id
	Net:send(msg,"team","TeamCopyReady")
end


function Copy:comfirm_enter_team_copy_c2s(agree)
	local msg = {}
	msg.agree = agree
	Net:send(msg,"team","TeamCopyAgree")
end
function Copy:pass_copy_s2c(msg)
	gf_print_table(msg, "pass_copy_s2c wtf:")

	-- 战场
	if LuaItemManager:get_item_obejct("rvr"):is_rvr() then
		return
	end
	if self:is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME) then
		return
	end
	--过关斩将结算
	if self:is_challenge() then
		require("models.copyEnd.challengeEnd")(msg)
		return
	end

	if self:is_team() then
		self.team_copy_enter_time = self.team_copy_enter_time - 1
	end

	if self:is_pvp() then
		require("models.copyEnd.pvpEnd")(msg.arenaInfo)
		return
	end

	if self:is_pvptvt() then
		require("models.copyEnd.tvtEnd")(msg.teamVsCopyInfo)
		return
	end
	if msg.protectCityInfo ~= nil then
		--LuaItemManager:get_item_obejct("activeDaily"):daily_icon_hide(2007)
		if self:is_mozu() then
			if 0 < #msg.protectCityInfo then
				require("models.mozu.MozuSettlement")()
			else
				require("models.mozu.MozuSettlementFail")()
			end
		end
		return
	end

	--立即结算
	self.pre_copy_id = self.copy_id
	self.pre_msg = msg
	require("models.copyEnd.copyEndView")(self, self.pre_msg,self.pre_copy_id)
	self:clear_data()
end

function Copy:clear_pre_data()
	self.pre_copy_id = nil
	self.pre_msg = nil
	self.default_copy_id = nil
end

-- 取章节信息
function Copy:get_chapter_info_c2s(  )
	-- local msg = {chapter = chapter}
	local msg = {}
	Net:send(msg, "copy", "GetStoryCopyInfo",sid)
	-- self.chapter = chapter
end

function Copy:get_chapter_info_s2c( msg ,sid)
	gf_print_table(msg, "获取副本章节返回")
	table.sort(msg.info or {},function(a,b)return a.chapter < b.chapter end)
	self.chapter_info = msg.info or {}
end

--过关斩将继续挑战下一关
function Copy:continue_challenge_c2s(copy_id)
	local msg = {}
	local sid = Net:set_sid_param(copy_id)
	Net:send(msg, "copy", "ContinueChallenge",sid)
end

function Copy:continue_challenge_s2c( msg )
	self.tower_floor_code = msg.floorCode 
	self:set_time(Net:get_server_time_s())
end

function Copy:get_material_copy_data_c2s()
	print("GetMaterialCopyInfo")
	Net:send({copyType = ServerEnum.COPY_TYPE.MATERIAL}, "copy", "GetMaterialCopyInfo")
	Net:send({copyType = ServerEnum.COPY_TYPE.MATERIAL2}, "copy", "GetMaterialCopyInfo")

	-- if DEBUG then

	-- 	local copy1 = {
	-- 		copyCode 	= 100001,	
	-- 		star 		= 1,	
	-- 	}
	-- 	local copy2 = {
	-- 		copyCode 	= 100002,	
	-- 		star 		= 1,	
	-- 	}

	-- 	local copy3 = {
	-- 		copyCode 	= 100003,	
	-- 		star 		= 1,	
	-- 	}


	-- 	local msg = {}
	-- 	msg.copyType 	= copyType
	-- 	msg.buyTimes 	= 10
	-- 	msg.validTimes 	= 2
	-- 	msg.starList 	= {}
	-- 	gf_send_and_receive(msg, "copy", "GetMaterialCopyInfoR", sid)
	-- end
end

function Copy:get_material_copy_data_s2c(msg)
	gf_print_table(msg, "GetMaterialCopyInfoR:")
	table.sort(msg.starList,function(a,b)return a.copyCode < b.copyCode end)
	self.material_copy_data[msg.copyType] = msg
end

function Copy:get_material_copy_data(type)
	gf_print_table(self.material_copy_data,"wtf self.material_copy_data:"..type)
	return self.material_copy_data[type] or {}
end

function Copy:get_material_copy_data_id(type,id)
	for i,v in ipairs(self.material_copy_data[type].starList or {}) do
		if v.copyCode == id then
			return v
		end
	end
	return nil
end

function Copy:get_tvt_begin_time()
	return self.pvp3v3_begin_time or Net:get_server_time_s()
end

function Copy:material_copy_buy_count_c2s(copyType)
	local msg = {}
	msg.copyType = copyType
	local sid = Net:set_sid_param(copyType)
	Net:send(msg, "copy", "BuyMaterialTimes",sid)

	-- if DEBUG then
	-- 	local msg = {}
	-- 	msg.err = 0
	-- 	gf_send_and_receive(msg, "copy", "BuyMaterialTimesR", sid)
	-- end
	
end

function Copy:material_copy_buy_count_s2c(msg,sid)
	gf_print_table(msg,"BuyMaterialTimesR:")
	if msg.err == 0 then
		local copy_type = unpack(Net:get_sid_param(sid) or {})
		print("wtf set copy_type:",copy_type)
		self:set_material_copy_data(copy_type,1)
	end
end

function Copy:cut_material_copy_count(copy_type,count)
	if self.material_copy_data[copy_type] then
		self.material_copy_data[copy_type].validTimes = self.material_copy_data[copy_type].validTimes - count
	end
end

function Copy:set_material_copy_data(copy_type,count)
	if self.material_copy_data[copy_type] then
		self.material_copy_data[copy_type].buyTimes = self.material_copy_data[copy_type].buyTimes + 1
		self.material_copy_data[copy_type].validTimes = self.material_copy_data[copy_type].validTimes + count

	end
end
function Copy:get_material_copy_count(copy_type)
	if self.material_copy_data[copy_type] then
		return self.material_copy_data[copy_type].validTimes
	end
	return 0
end
function Copy:get_material_copy_buy_count(copy_type)
	if self.material_copy_data[copy_type] then
		return self.material_copy_data[copy_type].buyTimes
	end
	return 0
end
-- 领取宝箱
function Copy:get_chapter_box_c2s( chapter, index )
	local msg = {chapter = chapter, index = index}
	gf_print_table(msg, "领取宝箱:")
	local sid = Net:set_sid_param(chapter,index)
	Net:send(msg, "copy", "OpenChapterBox", sid)
end

function Copy:get_chapter_box_s2c( msg, index )
	if msg.err == 0 then
		print("领取宝箱成功",index,self.chapter)
		-- 刷新领取数据
		local chapter, sindex = unpack(Net:get_sid_param(index))
		
		for i,v in ipairs(self.chapter_info or {}) do
			if v.chapter == chapter then
				table.insert(self.chapter_info[i].getReward,sindex)
			end
		end

	end
end

-- 进入副本 
function Copy:enter_copy_c2s( copyId,isDouble,enemyGuid,enemyData)
	local msg = {copyCode = copyId,isDouble = isDouble,enemyGuid = enemyGuid}
	gf_print_table(msg, "EnterCopy:")
	local sid = Net:set_sid_param(copyId,enemyData)
	Net:send(msg, "copy", "EnterCopy",sid)
end

function Copy:enter_copy_s2c( msg,sid )
	gf_print_table(msg, "wtf enter copy =====:"..sid)
	if msg.err == 0 then
		self.tower_floor_code = msg.floorCode -- 爬塔副本才会有
		self.is_double = msg.isDouble

		local param = Net:get_sid_param(sid)
		local copy_id,enemyData = param[1],param[2]
		self.enemyData = enemyData
		print("copy_id:",copy_id)
		local copy_data = ConfigMgr:get_config("copy")[copy_id]
		local enter_map = copy_data.enter_map
		--记录副本id
		self:set_copy_id(copy_id)
		self:set_cur_copy_data(copy_data)
		--记录时间
		self:set_time(Net:get_server_time_s())

		--如果是进入材料副本 次数减1
		if self:is_material_defence() then 
			self:cut_material_copy_count(ServerEnum.COPY_TYPE.MATERIAL,1)
		end
		if self:is_material_time_treasury() then
			self:cut_material_copy_count(ServerEnum.COPY_TYPE.MATERIAL2,1)
		end
	end
end



function Copy:copy_state_show()

    --主界面显示状态
    gf_receive_client_prot( ServerEnum.MAINUI_UI_MODLE.MAP,    	ClientProto.MainUiShowControl)
    gf_receive_client_prot( ServerEnum.MAINUI_UI_MODLE.BUTTON, 	ClientProto.MainUiShowControl)
    gf_receive_client_prot( ServerEnum.MAINUI_UI_MODLE.BOTTLE, 	ClientProto.MainUiShowControl)
    gf_receive_client_prot( ServerEnum.MAINUI_UI_MODLE.EP, 		ClientProto.MainUiShowControl)
    gf_receive_client_prot( ServerEnum.MAINUI_UI_MODLE.TASK, 	ClientProto.MainUiShowControl)
	gf_receive_client_prot( ServerEnum.MAINUI_UI_MODLE.HEAD, 	ClientProto.MainUiShowControl)
	gf_receive_client_prot( ServerEnum.MAINUI_UI_MODLE.FUNCOPEN,ClientProto.MainUiShowControl)
   

    
end

--进入场景之后要显示什么界面
function Copy:scene_view_show()
    if self:is_challenge() then
        require("models.copyStateShow.challengeView")()

    elseif self:is_story() or self:is_material_defence() or self:is_material_time_treasury() then
    	require("models.copyStateShow.storyView")()

    elseif self:is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME) then
    	require("models.copyStateShow.smallGameState")()

	elseif gf_getItemObject("copy"):is_pvp() then
		require("models.pvp.pvpPanel")()

	elseif self.pre_copy_id and self.pre_copy_id > 0 then
		-- require("models.copyEnd.copyEndViewTest")(self, self.pre_msg,self.pre_copy_id)
		self:clear_pre_data()

	elseif self.default_copy_id and self.default_copy_id > 0 then
		-- require("models.copyEnd.defaultEnd")()
		self:set_default_copy()

    end
end
function Copy:exit_copy_c2s()
	self:set_cur_copy_data(nil)
	self:clear_data()
	Net:send({}, "copy", "ExitCopy")
	--如果有退出特效 删除
	gf_receive_client_prot({visible = false}, ClientProto.CopyExitButtonEffect)
end

--[[
扫荡
copy_id:副本id
count：扫荡次数
]]
function Copy:sweep_copy_c2s(copy_id, count)
	local sid = Net:set_sid_param(copy_id,count)
	local msg = {copyCode = copy_id, count = count}
	Net:send(msg, "copy", "SweepCopy",sid)
	gf_print_table(msg, "扫荡：")
end

function Copy:sweep_copy_s2c( msg ,sid)
	gf_print_table(msg,"SweepCopyR")
	if msg.err ~= 0 then
		return
	end
	local copy_id,count = Net:get_sid_param(sid)[1],Net:get_sid_param(sid)[2]
	--如果是材料副本
	local copy_type =  gf_get_config_table("copy")[copy_id].type
	if copy_type == ServerEnum.COPY_TYPE.MATERIAL or copy_type == ServerEnum.COPY_TYPE.MATERIAL2 then
		--次数减1
		self:cut_material_copy_count(copy_type,1)

		--转换格式
		local temp = {}
		temp = gf_deep_copy(msg.itemDrops[1].itemLs)
		msg.itemDrops = temp
		require("models.copyEnd.copyEndView")(self,msg,copy_id)
		return
	end
	self:set_copy_pass_count(copy_id,msg.challenge)
	-- self.sweep_copy_id = nil
	gf_print_table(msg, "扫荡返回:")
end

function Copy:reset_copy_c2s( copy_id )
	local sid = Net:set_sid_param(copy_id)
	Net:send({copyCode = copy_id}, "copy", "ResetCopy",sid)
end

function Copy:reset_copy_s2c( msg ,sid)
	if msg.err == 0 then
		print("重置扫荡成功")
		local copy_id = Net:get_sid_param(sid)[1]
		self:set_copy_pass_count(copy_id,0)
		self:set_copy_reset_count(copy_id,1)
		self.sweep_copy_id = nil
	end
end

-- 获取爬塔副本信息
function Copy:get_tower_info_c2s()
	print("获取爬塔副本信息")
	Net:send({}, "copy", "GetTowerInfo")
end

function Copy:get_tower_info_s2c( msg )
	gf_print_table(msg, "获取爬塔副本信息返回")

	self.curFloor = msg.curFloor

	-- self.tower_floor = {} -- 通过层数

	-- for k,v in pairs(msg.copyList or {}) do
	-- 	local max_floor = dataUse.getTowerMax(v.copyCode) 
	-- 	self.tower_floor[v.copyCode] = v.todayFloor > max_floor and max_floor or v.todayFloor
	-- end

	-- self.tower_state = {}
	-- for k,v in pairs(msg.stateList or {}) do
	-- 	self.tower_state[v.copyCode] = v.state
	-- end

	-- self.tower_sweep_storehouse = msg.sweepStorehouse or {} -- 扫荡仓库物品

	-- Net:receive(#self.tower_sweep_storehouse > 0, ClientProto.TowerStorehouseChange)

end

function Copy:get_tower_floor()
	return (self.curFloor % 30000) or 1
end

function Copy:get_tower_copy_id()
	return self.curFloor
end
-- function Copy:get_tower_data(copy_code)
-- 	for i,v in ipairs(self.tower_data or {}) do
-- 		if v.copyCode == copy_code then
-- 			return v
-- 		end
-- 	end
-- end

--获得组队副本进入次数
function Copy:get_team_copy_enter_time_c2s()
	Net:send({}, "team", "TeamCopyPassTimes")
end	
-- 一键获取扫荡仓库里的奖励
function Copy:get_tower_sweep_reward_c2s()
	Net:send({}, "copy", "GetTowerSweepReward")
end

function Copy:get_tower_sweep_reward_s2c(msg)
	if msg.err ~= 0 then
		return
	end
	self.tower_sweep_storehouse = {}
	Net:receive(false, ClientProto.TowerStorehouseChange)
end

-- 通知前端通过了本层 出现带倒计时的传送进度ui 
-- 倒计时结束后向后端请求继续挑战协议ContinueChallenge
function Copy:pass_tower_floor_s2c( msg )
	print("爬塔通过,继续挑战下一关")
	local view = LuaItemManager:get_item_obejct("mainui"):collect_view()
	if view then
		view:set_is_transmit(true)
		view:set_time(3)
		view:set_name(gf_localize_string("传送中"))

		local function cb()
			self:continue_challenge_c2s()
		end
		view:set_finish_cb(cb)
	end
end

-- 主动退出爬塔，返回通关层数列表，用来显示结算界面
function Copy:tower_exipred_copy_c2s()
	print("退出爬塔")
	Net:send({}, "copy", "TowerExpiredCopy")
end

function Copy:tower_exipred_copy_s2c(msg)
	gf_print_table(msg, "主动退出爬塔，返回通关层数列表")
	gf_auto_atk(false)
	-- 爬塔结算奖励
	local tower_end_reward = 
	{
		itemDrops = {},
		coin = 0,
		exp = 0,
	}
	local config_table = ConfigMgr:get_config("copy_tower")

	for k,v in ipairs(msg.passFloors or {}) do
		local data = config_table[v]
		for i,d in ipairs(data.reward_item) do
			tower_end_reward.itemDrops[#tower_end_reward.itemDrops+1] = {code = d[1], num = d[2]}
		end
		tower_end_reward.coin = tower_end_reward.coin + data.reward_coin
		tower_end_reward.exp = tower_end_reward.exp + data.reward_exp
	end
	
	require("models.copyEnd.copyEndView")(self, tower_end_reward)
end

-- 尝试扫荡到之前通关过的最高层 成功则尝试进入下一层
function Copy:sweep_tower_copy_c2s( copy_code, is_double )
	local msg = {copyCode = copy_code, isDouble = is_double}
	Net:send(msg, "copy", "SweepTowerCopy")

end

function Copy:sweep_tower_copy_s2c( msg )
	if msg.err ~= 0 then
		return
	end
	self.tower_sweep_storehouse = msg.sweepStorehouse or {}
	self:enter_copy_s2c(msg.enterErr, 1)
	Net:receive(#self.tower_sweep_storehouse > 0, ClientProto.TowerStorehouseChange)
end

function Copy:power_add()
	local save_key = "%d_story_copy"
	local c_date = os.date("%x",Net:get_server_time_s())

	local my_role_id = gf_getItemObject("game"):getId()
	local s_date = PlayerPrefs.GetString(string.format(save_key,my_role_id),os.date("%x",Net:get_server_time_s() - 24 * 60 * 60))
	local left_count = gf_getItemObject("game"):get_strenght_buy_count()

	local str4 = gf_localize_string("今日购买体力次数已用完，提升VIP等级可增加购买次数！")
	local str1 = gf_localize_string("今日不再提醒")
	local str2 = gf_localize_string("确定要花费<color=#B01FE5>%d</color>元宝购买<color=#B01FE5>%d</color>点体力？今日还可购买<color=#B01FE5>%d</color>次。")
	
	if c_date == s_date then
		if left_count == 0 then
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(str4)
			return
		end
		gf_getItemObject("game"):buy_strenght_c2s()
		return
	end

	local save = function()
		PlayerPrefs.SetString(string.format(save_key,my_role_id),c_date)
	end

	local sfunc = function(a,b)
		print("购买体力")
		if b then
			save()
		end
		gf_getItemObject("game"):buy_strenght_c2s()
	end
	local cfunc = function(a,b)
		if b then
			save()
		end
	end
	local constant_info = ConfigMgr:get_config("t_misc")
	local price = constant_info.strength.buy_cost[2]
	local count = constant_info.strength.buy_num
	
	local show_content = string.format(str2,price,count,left_count)

	if left_count == 0 then
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message(str4)
		return
	end

	LuaItemManager:get_item_obejct("cCMP"):toggle_message(show_content,false,str1,sfunc,cfunc)
end

function Copy:reset_copy(copy_id)
	local save_key = "%d_story_copy_reset"
	local c_date = os.date("%x",Net:get_server_time_s())

	local my_role_id = gf_getItemObject("game"):getId()
	local s_date = PlayerPrefs.GetString(string.format(save_key,my_role_id),os.date("%x",Net:get_server_time_s() - 24 * 60 * 60))

	local constant_info = ConfigMgr:get_config("t_misc")
	local price = constant_info.strength.reset_cost[2]
	local count = constant_info.strength.reset_cost[1]
	local use_count = self:get_chapter_data_byid(copy_id).reset or 0
	local copy_name = gf_get_config_table("copy")[copy_id].name
	local left_count = count - use_count

	local str4 = gf_localize_string("重置次数已用完")
	local str1 = gf_localize_string("今日不再提醒")
	local str2 = gf_localize_string("确定要花费<color=#B01FE5>%d</color>元宝重置副本<color=#B01FE5>%s</color>的挑战次数吗？今日还可重置<color=#B01FE5>%d</color>次。")
	
	if c_date == s_date then
		if left_count <= 0 then
			LuaItemManager:get_item_obejct("cCMP"):only_ok_message(str4)
			return
		end
		self:reset_copy_c2s( copy_id )
		return
	end

	local save = function()
		PlayerPrefs.SetString(string.format(save_key,my_role_id),c_date)
	end

	local sfunc = function(a,b)
		if b then
			save()
		end
		self:reset_copy_c2s( copy_id )
	end
	local cfunc = function(a,b)
		if b then
			save()
		end
	end

	local show_content = string.format(str2,price,copy_name,left_count)

	if left_count == 0 then
		LuaItemManager:get_item_obejct("cCMP"):only_ok_message(str4)
		return
	end

	LuaItemManager:get_item_obejct("cCMP"):toggle_message(show_content,false,str1,sfunc,cfunc)
end