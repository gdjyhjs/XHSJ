--[[
	pvp排行榜界面  
	create at 17.8.1
	by xin
]]

local dataUse = require("models.pvp.dataUse")
local dataUse1 = require("models.hero.dataUse")
local LuaHelper = LuaHelper
local Enum = require("enum.enum")
local model_name = "copy"

local res = 
{
	[1] = "arena_battle.u3d",
}

local commom_string = 
{
	[1] = gf_localize_string(""),
}

local pvpPanel = class(UIBase,function(self)

	local item_obj = LuaItemManager:get_item_obejct("pvp")
	self.item_obj = item_obj
	
	UIBase._ctor(self, res[1], item_obj)
end)


--资源加载完成
function pvpPanel:on_asset_load(key,asset)
	print("pvpPanel init")
	StateManager:register_view(self)
	self:data_init()
    self:init_ui()
end

function pvpPanel:data_init()
	self.blood_line 			= self.refer:Get(10)
	self.other_blood_line 		= self.refer:Get(11)
	self.blood_line_hero 		= self.refer:Get(16)
	self.other_blood_line_hero 	= self.refer:Get(17)
	self.hero_head 				= self.refer:Get(19)
	self.other_hero_head 	    = self.refer:Get(20)
	self.is_start = false

	self.level_text 			= self.refer:Get(21)
	self.other_level_text 		= self.refer:Get(22)
end

function pvpPanel:init_ui()
	self:state_change(false)
	--开始计时 3 * 60 + 3秒开始
	self.time = ConfigMgr:get_config("t_misc").pvp_total_time + 3
	self.cur_time = Net:get_server_time_s()
	self:start_scheduler()

	self:enemy_info_init()
	self:my_info_init()

	
end

function pvpPanel:state_change(is_begin)
	print("set state :",is_begin)
	self.refer:Get(18):SetActive(not is_begin)
	gf_auto_atk(is_begin)
end

function pvpPanel:enemy_info_init()
	local enemy_data = gf_getItemObject("copy"):get_enemy_data()
	gf_print_table(enemy_data, "enemy_data:")
	--名字
	self.refer:Get(5).text = enemy_data.name
	--等级
	self.refer:Get(4).text = enemy_data.level
	--段位
	local stage = dataUse.get_stage_by_score(enemy_data.score)
	local name = dataUse.get_stage_name(stage)
	self.refer:Get(2).text = name
	--s_icon 
	local icon = dataUse.get_stage_sicon(stage)
	gf_setImageTexture(self.refer:Get(13), icon)
	--头像
	gf_set_head_ico(self.refer:Get(3), enemy_data.head)
end


function pvpPanel:my_info_init()
	local model_data = gf_getItemObject("game")
	local my_data = gf_getItemObject("pvp"):get_my_pvp_data()
	--名字
	self.refer:Get(8).text = model_data:getName()
	--等级
	self.refer:Get(7).text = model_data:getLevel()
	--段位
	local stage = dataUse.get_stage_by_score(my_data.score)
	local name = dataUse.get_stage_name(stage)
	self.refer:Get(9).text = name
	--s_icon 
	local icon = dataUse.get_stage_sicon(stage)
	gf_setImageTexture(self.refer:Get(12), icon)
	--头像
	gf_set_head_ico(self.refer:Get(6), model_data:getHead())

end

function pvpPanel:start_scheduler()
	if self.schedule_id then
		self:stop_schedule()
	end
	
	local update = function()
		if self.is_dead then
			self.is_dead = nil
			self:stop_schedule()
		end
		--8秒自动离开副本
		if self.tick_time then
			if Net:get_server_time_s() - self.tick_time >= 8 then
				LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
				self:stop_schedule()
				self.tick_time = nil
			end
		end
		local leave_time = Net:get_server_time_s() - self.cur_time
		local time = self.time - leave_time
		time = time <= 0 and 0 or time
		time = time > ConfigMgr:get_config("t_misc").pvp_total_time and ConfigMgr:get_config("t_misc").pvp_total_time or time

		self:update_time(time)
		if time <= 0 and not self.tick_time then
			require("models.copy.challengeDefault")()
			self.tick_time = Net:get_server_time_s()
			return
		end
		
	end
	update()
	self.schedule_id = Schedule(update, 0.1)
end

function pvpPanel:update_time(time)
	if time < ConfigMgr:get_config("t_misc").pvp_total_time and not self.is_start then
		self.is_start = true
		--开始挂机 关闭屏蔽点击层
		self:state_change(true)
	end
	self.refer:Get(1).text = gf_convert_time_ms(time)
end

function pvpPanel:auto_leave_copy()
	--主动退出副本

end

function pvpPanel:update_my_blood(hp,max_hp)
	self.is_dead = hp <= 0
	self.blood_line.fillAmount = hp / max_hp
end
function pvpPanel:update_other_blood(hp,max_hp)
	self.other_blood_line.fillAmount = hp / max_hp
end

function pvpPanel:stop_schedule()
	if self.schedule_id then
		self.schedule_id:stop()
		self.schedule_id = nil
	end
end

--鼠标单击事件
function pvpPanel:on_click( obj, arg)
    local event_name = obj.name
    print("event_name wtf ",event_name)
    if event_name == "" then 
    	Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
    end
end

function pvpPanel:clear()
	self:stop_schedule()
	StateManager:register_view(self)
end

function pvpPanel:on_hided()
	self:clear()
end

-- 释放资源
function pvpPanel:dispose()
	self:clear()
    self._base.dispose(self)
end

function pvpPanel:update_object(msg,is_init)
	print("wtf update object:")
	--血量
	for k,v in pairs(LuaItemManager:get_item_obejct("battle"):get_character_list()) do
		if v.is_self then -- 玩家自己
			self:update_my_blood(v:get_hp(),v:get_max_hp())
			local hero = v:get_hero()
			if hero then
				print("my level:",hero:get_level())
				self.blood_line_hero.fillAmount = hero:get_hp() / hero:get_max_hp()
				self.blood_line_hero.gameObject:SetActive(true)

				local hero_id = hero:get_code()
				if self.my_hero_id ~= hero_id then
					self.hero_head.gameObject:SetActive(true)
					self.my_hero_id = hero_id
					local head = dataUse1.getHeroHeadIcon(hero_id)
					gf_setImageTexture(self.hero_head , head)

					self.level_text.text = hero:get_level()
				end

			else
				self.blood_line_hero.gameObject:SetActive(false)
			end
		else
			self:update_other_blood(v:get_hp(),v:get_max_hp())
			local hero = v:get_hero()
			if hero then
				print("other level:",hero:get_level())
				self.other_blood_line_hero.fillAmount = hero:get_hp() / hero:get_max_hp()
				self.other_blood_line_hero.gameObject:SetActive(true)

				local hero_id = hero:get_code()

				if self.other_hero_id ~= hero_id then
					self.other_hero_head.gameObject:SetActive(true)
					self.other_hero_id = hero_id
					local head = dataUse1.getHeroHeadIcon(hero_id)
					gf_setImageTexture(self.other_hero_head , head)

					self.other_level_text.text = hero:get_level()
				end

			else
				self.other_blood_line_hero.gameObject:SetActive(false)
			end
			
		end
	end
	
end

function pvpPanel:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1(model_name) then
		if id2 == Net:get_id2(model_name, "ExitCopyR") then
			self:dispose()

		end
	end
	if id1==Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "UpdateObjectR") then -- 创建,更新,移除通用协议
			self:update_object(msg)
		end
	end

	if id1 == ClientProto.HeroLoaderFinish then
		self:update_object(nil,true)
	end
end

return pvpPanel