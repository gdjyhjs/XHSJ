--[[--
-- 魔族
-- @Author:xcb
-- @DateTime:2017-09-05 09:56:49
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Mozu = LuaItemManager:get_item_obejct("mozu")
--UI资源
Mozu.assets=
{
    View("mozuView", Mozu) 
}

function Mozu:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "activeInfoR") then
			self.begin_time = msg.beginTime
			self.ready_time = msg.readyTime
			self.end_time = msg.endTime
		elseif id2 == Net:get_id2("copy", "BossBornInfoR") then
			print("skdjfslkdjflsdkjflsdf11111",msg.bornTime)
			self.boss_apper_time = msg.bornTime or 0
			--self.monster_wave = msg.wave
			--self.next_refresh_time = msg.nextWaveTime
			if self.boss_apper_time <= Net:get_server_time_s() then
				print("sdfasdfsdfsdfdsf111")
				self.is_show_effect = true
			end
		elseif id2 == Net:get_id2("copy", "BossHurtListR") then
			print("BossHurtListR")
			self.rank_list = {}
			for i,v in ipairs(msg.hurtList) do
				self.rank_list[i] = {}
				self.rank_list[i].name = v.name
				self.rank_list[i].hurt = v.value
				print("BossHurtListR",self.rank_list[i].name,self.rank_list[i].hurt)
			end
			self.my_rank.rank = msg.myRank
			self.my_rank.hurt = msg.myHurt
			self.my_rank.coin = msg.coin
			--[[
			local origin_rank = 0
			for i,v in ipairs(self.rank_list) do
				if v ~= nil and v.charId == msg.charId then
					origin_rank = i
				end
			end
			if origin_rank == msg.rank then
				self.rank_list[msg.rank].char_id = msg.charId				
				self.rank_list[msg.rank].name = msg.name
				self.rank_list[msg.rank].hurt = msg.hurt
			elseif origin_rank == 0 then
				if self.rank_list[msg.rank] == nil then
					self.rank_list[msg.rank] = {}
					self.rank_list[msg.rank].char_id = msg.charId
					self.rank_list[msg.rank].name = msg.name
					self.rank_list[msg.rank].hurt = msg.hurt
				else
					local temp = {char_id = msg.charId,name = msg.name,hurt = msg.hurt}
					table.insert(self.rank_list,msg.rank,temp)
					table.remove(self.rank_list)
				end
			else
				local i = origin_rank
				while msg.rank < i do
					self.rank_list[i].char_id = self.rank_list[i - 1].char_id
					self.rank_list[i].name = self.rank_list[i - 1].name
					self.rank_list[i].hurt = self.rank_list[i - 1].hurt
					i = i - 1
				end
				self.rank_list[msg.rank].char_id = msg.charId
				self.rank_list[msg.rank].name = msg.name
				self.rank_list[msg.rank].hurt = msg.hurt
			end]]
		elseif id2 == Net:get_id2("copy","BuildingHurtR") then
			self.build_hurt = msg.hurt
		elseif id2 == Net:get_id2("copy","PassCopyR") then
			print("PassCopyR")
		elseif id2 == Net:get_id2("copy", "ExitCopyR") then
			self.is_show_effect = false
		end
	end
	if id1 == ClientProto.FinishScene then
		if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.PROTECT_CITY) then
			require("models.mainui.hurtRankView")()
		end
	end

end

function Mozu:get_boss_appear_time()
	return self.boss_apper_time
end
--点击事件
function Mozu:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
end

--初始化函数只会调用一次
function Mozu:initialize()
	self.boss_apper_time = 0
	self.monster_wave = 0
	self.next_refresh_time = 0
	self.rank_list = {}
	self.my_rank = {rank = 0,hurt = 0,coin = 0}
	self.schedule_id = nil
	self.build_hurt = 0
	self.is_show_effect = false
end

function Mozu:get_is_show_effect()
	return self.is_show_effect
end



