--[[
	boss血条界面  属性
	create at 17.9.21
	by xin
]]

local res = 
{
	[1] = "blood_line_boss.u3d",
}

local blood_line_res = 
{
	[5] = "blood_line_boss_03",
	[4] = "blood_line_boss_05",
	[3] = "blood_line_boss_04",
	[2] = "blood_line_boss_01",
	[1] = "blood_line_boss_02",
	[0] = "blood_line_boss_03",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}

local bossBloodLineView = class(UIBase,function(self)
	local item_obj = LuaItemManager:get_item_obejct("mainui")
	self.item_obj = item_obj
	UIBase._ctor(self, res[1], item_obj)
	self:set_always_receive(true)
	self:set_level(UIMgr.LEVEL_STATIC)
end)


--资源加载完成
function bossBloodLineView:on_asset_load(key,asset)
	self:init_ui()
end

function bossBloodLineView:init_boss_name()
	local monster = self.monster
	print("wtf boss name:", self.monster.config_data.name)
	if LuaItemManager:get_item_obejct("firstWar"):is_pass() then
		self.refer:Get(2).text = string.format("%s[%d级]" ,monster.config_data.name , monster.config_data.level)
	else
		self.refer:Get(2).text = string.format("%s[%d级]" ,monster.config_data.name , ConfigMgr:get_const("first_war_lv"))
	end
end

function bossBloodLineView:init_ui()
	self:update_view()
end

function bossBloodLineView:show_boss_view(monster,hurt_hp)
	print("wtf boss hp:",monster:get_hp(),monster:get_max_hp())
	if monster:get_hp() <= 0 then
		self:hide()
		return
	else
		self:show()
	end

	self.star_time = Net:get_server_time_s()
	--开启定时器 如果当前有定时器 而且是同一只怪物 合并遗失血量 并开始新的定时器执行动画
	if self.schedule_id then
		if self.monster and self.monster.guid == monster.guid then
			if self.left_hp then
				hurt_hp = hurt_hp + (self.left_hp or 0)
				self.left_hp = 0
			end
		end

		self:stop_schedule()

	end
	self.monster = monster
	self:start_scheduler(monster:get_hp(),hurt_hp,monster:get_max_hp())

end

--@monster 
--@hurt_hp 扣除血量 
function bossBloodLineView:start_scheduler(hp,hurt_hp,max_hp)
	--总的执行时间
	local total_time = 0.2

	local update = function()
		--动作结束
		if Net:get_server_time_s() - self.star_time >= total_time then
			self:stop_schedule()
			self:update_monster_cur_hp(self.monster.guid)
			return
		end
		local time = Net:get_server_time_s() - self.star_time
		local rate = time / total_time

		local t_hp = Mathf.Lerp(hurt_hp + hp,hp,rate)
		self.left_hp = hurt_hp * (1 - rate)
		self:update_blood_line(t_hp,max_hp)

	end
	self.schedule_id = Schedule(update, 0.01)
end

function bossBloodLineView:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

function bossBloodLineView:update_blood_line(cur_hp,max_hp)
	-- if not self.name_init then
	self:init_boss_name(self.monster)
		-- self.name_init = true
	-- end

	local duration = max_hp / 20 			--没管血量

	local left = cur_hp % duration
	left = left <= 0 and duration or left

	local count = math.floor(cur_hp / duration) + 1
	count = count >= 20 and 20 or count

	print("当前是第"..count.."管血")
	self.refer:Get(4).text = "x"..count
    self.refer:Get(5).text =math.floor(cur_hp*100/max_hp).."%" --血量百分比

	self.refer:Get(3).gameObject:SetActive(count ~= 1)

	local res_count = count % 5
	res_count = res_count <= 0 and 5 or res_count

	gf_setImageTexture(self.refer:Get(1), blood_line_res[res_count])
	gf_setImageTexture(self.refer:Get(3), blood_line_res[res_count - 1])

	self.refer:Get(1).fillAmount = left / duration
end

function bossBloodLineView:update_monster_cur_hp(guid)
	print("wtf update last:",guid)
	local monster_list = gf_getItemObject("battle"):get_enemy_list()
	for i,v in pairs(monster_list or {}) do
		if guid == v.guid and (v.config_data.type == ServerEnum.CREATURE_TYPE.BOSS or v.config_data.type == ServerEnum.CREATURE_TYPE.WORLD_BOSS) then
			self:show()
			self.monster = v
			self:update_blood_line(v:get_hp(),v:get_max_hp())
		end
	end
end

function bossBloodLineView:update_view()
	local monster_list = gf_getItemObject("battle"):get_enemy_list()
	local have = false
	for i,v in pairs(monster_list or {}) do
		if v.config_data.type == ServerEnum.CREATURE_TYPE.BOSS or v.config_data.type == ServerEnum.CREATURE_TYPE.WORLD_BOSS then
			self:show()
			self.monster = v
			self:update_blood_line(v:get_hp(),v:get_max_hp())
			have = true
		end
	end
	if not have then
		self:hide()
	end
end

--鼠标单击事件
function bossBloodLineView:on_click( obj, arg)
end

function bossBloodLineView:on_showed()
	StateManager:register_view(self)
end

function bossBloodLineView:clear()
	StateManager:remove_register_view(self)
end

function bossBloodLineView:on_hided()
end
-- 释放资源
function bossBloodLineView:dispose()
	self:clear()
    self._base.dispose(self)
end

function bossBloodLineView:on_receive( msg, id1, id2, sid )
	if id1 == ClientProto.MonsterLoaderFinish or id1 == ClientProto.RemoveMapModel then
		self:update_view()

	elseif id1 == ClientProto.FinishScene then
		self:hide()

	elseif id1 == ClientProto.BossBlood then
		gf_print_table(msg,"wtf wtf monster")
		local monster_list = gf_getItemObject("battle"):get_enemy_list()
		if monster_list[msg.guid] then
			self:show_boss_view(monster_list[msg.guid],msg.hp)

		end

	end

end

return bossBloodLineView