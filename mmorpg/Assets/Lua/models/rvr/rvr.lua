--[[--
-- 战场
-- @Author:Seven
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Rvr = LuaItemManager:get_item_obejct("rvr")
--UI资源
Rvr.assets=
{
    View("rvrView", Rvr) 
}

-- 是否是战场
function Rvr:is_rvr()
	return self._is_rvr
end

-- 能量储备
function Rvr:get_energy()
	return self._energy
end

-- 击杀数量
function Rvr:get_kill_num()
	return self._kill_num
end

-- 获取我方积分
function Rvr:get_our_score()
	return self._our_score
end

-- 获取敌方积分
function Rvr:get_enemy_score()
	return self._enemy_score
end

-- 助攻
function Rvr:get_assist()
	return self._assist
end

-- 荣誉
function Rvr:get_honor()
	return self._honor
end

-- 战功
function Rvr:get_feats()
	return self._feats
end

function Rvr:get_rank_list()
	return self.rank_list
end

function Rvr:get_id()
	return self._rvr_id
end

-- #1为战旗, 2-5为防御塔
function Rvr:get_left_flags(index)
	local value = self._left_flags[index] or 100
	return value*0.01
end

-- #1为战旗, 2-5为防御塔
function Rvr:get_right_flags(index)
	local value = self._right_flags[index] or 100
	return value*0.01
end

function Rvr:on_receive( msg, id1, id2, sid )
	if id1==Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "TransferMapR") then -- 切换场景返回
			if msg.dstCopyCode then
				self._is_rvr = msg.dstCopyCode == self._rvr_id
			else
				self._is_rvr = false
			end
		end

	elseif id1==Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "FactionRankR") then --排行榜
			self:faction_rank_s2c(msg, sid)

		elseif id2 == Net:get_id2("copy", "ExitCopyR") then -- 退出副本
			self._is_rvr = false
			
		elseif id2 == Net:get_id2("copy", "FactionStatisticsR") then -- 战场实时数据
			gf_print_table(msg, "战场实时数据")
			self._our_score = msg.starScore or self._our_score -- 我方积分
			self._enemy_score = msg.sunScore or self._enemy_score -- 敌方积分
			self._kill_num = msg.kill or self._kill_num -- 击杀数量
			self._assist = msg.assist or self._assist -- 助攻
			self._honor = msg.honor or self._honor -- 荣誉
			self._feats = msg.feats or self._feats -- 战功
			self._energy = msg.energy or self._energy -- 能量储备

			for k,v in pairs(msg.starFlags or {}) do
				self._left_flags[k] = v
			end

			for k,v in pairs(msg.sunFlags or {}) do
				self._right_flags[k] = v
			end

		elseif id2 == Net:get_id2("copy", "PassCopyR") then -- 通关
			if not self:is_rvr() then
				return
			end
			
			local function cb( view )
				view:show_exit_btn()
			end
			local view = View("rvrStatisticsView", self, nil, cb)

		end

	elseif id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "LoginR") then -- 注册返回
			local copy_id = msg.role.copyCode
			if copy_id and copy_id > 0 then
				copy_data = ConfigMgr:get_config("copy")[copy_id]
				if copy_data and copy_data.maps[1] == msg.role.mapId then
					self._is_rvr = copy_id == self._rvr_id
				else
					self._is_rvr = false
				end
			else
				self._is_rvr = false
			end
		end

	elseif id1 == ClientProto.FinishScene then -- 进入场景，刷新主ui
		if not self:is_rvr() then
			if self.score_view then
				self.score_view:dispose()
				self.score_view = nil
			end
			return
		end
		self.score_view = View("scoreView", self)
	end


end

--点击事件
function Rvr:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end

--初始化函数只会调用一次
function Rvr:initialize()
	self._is_rvr = false -- 是否是战场
	self._rvr_id = ConfigMgr:get_config("t_misc").special_copy_code.faction
	
	self._our_score = 0-- 我方积分
	self._enemy_score = 0 -- 敌方积分
	self._kill_num = 0 -- 击杀数量
	self._assist = 0 -- 助攻
	self._honor = 0 -- 荣誉
	self._feats = 0 -- 战功
	self._energy = 0-- 能量储备

	self._left_flags = {}
	self._right_flags = {}
end

-- 排行榜 
function Rvr:faction_rank_c2s()
	print("请求战场数据")
	Net:send({}, "copy", "FactionRank")
end

function Rvr:faction_rank_s2c( msg )
	gf_print_table(msg, "战场排行榜")
	self.rank_list = msg.rankList
end

-- 提交采集珠给军需官
function Rvr:faction_hand_up_c2s()
	print("提交采集珠给军需官")
	Net:send({}, "copy", "FactionHandUp")
end

function Rvr:faction_hand_up_s2c( msg )
	
end



