--[[--
--
-- @Author:LiYunFei
-- @DateTime:2017-03-25 15:39:14
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local Skill = LuaItemManager:get_item_obejct("skill")
Skill.priority = 1
--UI资源
Skill.assets=
{
    View("skillView", Skill) 
}

Skill.StartId = 
{
	[ServerEnum.CAREER.MAGIC] = {11101, 11102, 11103, 11104, 11105},
	[ServerEnum.CAREER.BOWMAN] = {11201, 11202, 11203, 11204, 11205},
	[ServerEnum.CAREER.SOLDER] = {11401, 11402, 11403, 11404, 11405},
}

local SkillIndex = 
{
	atk1   = ServerEnum.SKILL_POS.NORMAL_1,
	atk2   = ServerEnum.SKILL_POS.NORMAL_2,
	atk3   = ServerEnum.SKILL_POS.NORMAL_3,
	skill1 = ServerEnum.SKILL_POS.ONE,
	skill2 = ServerEnum.SKILL_POS.TWO,
	skill3 = ServerEnum.SKILL_POS.THREE,
	skill4 = ServerEnum.SKILL_POS.FOUR,
	skill5 = ServerEnum.SKILL_POS.XP,
}

local SkillCMD = 
{
	[ServerEnum.SKILL_POS.NORMAL_1] = "atk",
	[ServerEnum.SKILL_POS.NORMAL_2] = "atk",
	[ServerEnum.SKILL_POS.NORMAL_3] = "atk",
	[ServerEnum.SKILL_POS.ONE] = "skill1",
	[ServerEnum.SKILL_POS.TWO] = "skill2",
	[ServerEnum.SKILL_POS.THREE] = "skill3",
	[ServerEnum.SKILL_POS.FOUR] = "skill4",
	[ServerEnum.SKILL_POS.XP] = "skill5",
}

-- 获取技能命令
function Skill:get_cmd( skill_id )
	local index = tonumber(string.sub(skill_id.."",5,5))
	return SkillCMD[index], index
end

-- 通过命令获得技能数据
function Skill:get_data_by_cmd( cmd )
	local index = SkillIndex[cmd]
	return self.skill_list[index], index
end

function Skill:get_data_by_index( index )
	if not self.skill_list then
		return nil
	end
	return self.skill_list[index]
end

-- 判断当前技能是否可以释放
function Skill:is_can_play( cmd, target )
	local data = self:get_data_by_cmd(cmd)
	if not data then
		return true
	end
	
	-- if data.target_select == ServerEnum.SKILL_TARGET_SELECT.TARGET and not target then
	-- 	gf_message_tips(gf_localize_string("请选择攻击目标"))
	-- 	return false
	-- end
	return true
end

-- 通过攻击类型获取技能id
function Skill:get_skill_id(ty)
	if ty == ServerEnum.SKILL_POS.NORMAL_1 or 
	   ty == ServerEnum.SKILL_POS.NORMAL_2 or
	   ty == ServerEnum.SKILL_POS.NORMAL_3 then
		return 11000000+LuaItemManager:get_item_obejct("game"):get_career()*100000+6000+(ty - 5)
	end

	return self.skill_list[ty].code
end

function Skill:add_play_skill( s_id )
	local skill_index =  ConfigMgr:get_config("skill")[s_id].pos_type
	local skill_data = self:get_data_by_index(skill_index)
	-- local skill_data,skill_index  = self:get_data_by_cmd(cmd)
	if not skill_data or not skill_index then
		return
	end

	self.play_list[skill_index] = {
		skill_data = skill_data, 
		start_time = Net:get_server_time_s(),
		skill_index = skill_index
	}
end

function Skill:remove_play_skill(index)
	self.play_list[index] = nil
end

function Skill:get_play_list()
	return self.play_list
end

-- 通过技能下标获取当前技能是否可以释放
function Skill:is_skill_can_use( index )
	if not self._is_can_use then
		return false
	end

	if type(index) == "string" then
		index = SkillIndex[index]
	end

	if self.first_war:is_pass() then
		if not self.unlock_data then
			self.unlock_data = ConfigMgr:get_config("skill_unlock")
		end
		local data = self.unlock_data[index]

		if data and data.open_level > self.game_item:getLevel() then
			return false
		end
	end

	return self.play_list[index] == nil
end

-- 设置不可使用技能
function Skill:set_can_use( use )
	-- print("设置是否可以使用技能",use)
	if self._is_can_use == use then
		return
	end
	self._is_can_use = use
	Net:receive(self._is_can_use, ClientProto.IsCanUseSkill)
end

-- 获取是否可以使用技能
function Skill:is_can_use()
	return self._is_can_use
end

--点击事件
function Skill:on_click(obj,arg)
	self:call_event("on_click", false, obj, arg)
	return true
end

function Skill:on_receive( msg, id1, id2, sid )

	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "GetSkillListR") then
			gf_print_table(msg,"wtf receive GetSkillListR")
			self:get_skill_list_s2c(msg)
		elseif id2 == Net:get_id2("scene", "SkillLevelUpR") then -- 升级成功
			self:skill_level_up_s2c(msg, sid)
		elseif id2 == Net:get_id2("scene", "LearnSkillR") then -- 学习
			self:learn_skill_s2c(msg, sid)
		end
	end
end

--初始化函数只会调用一次
function Skill:initialize()
	self.play_list = {} -- 真正播放的技能
	self._is_can_use = true
	self.game_item = LuaItemManager:get_item_obejct("game")
	self.first_war = LuaItemManager:get_item_obejct("firstWar")
end

-- 获取当前技能列表
function Skill:get_skill_list_c2c()
	Net:send({}, "scene", "GetSkillList")

	-- Net:receive({skillList = {11101001,0,0,0}}, "scene", "GetSkillList", 0)
end

function Skill:get_skill_list_s2c( msg )
	gf_print_table(msg, "技能列表返回")
	local list = {}
	for i,v in ipairs(msg.skillList) do
		if i ~= ServerEnum.SKILL_POS.NORMAL_1 and 
		   i ~= ServerEnum.SKILL_POS.NORMAL_2 and
		   i ~= ServerEnum.SKILL_POS.NORMAL_3 then
			if v == 0 then
				-- self:learn_skill_c2s(i)
				list[i] = {skill_id = self.StartId[LuaItemManager:get_item_obejct("game"):get_career()][i]*1000+1, open = ClientEnum.SKILL_STATE.LOCK}
			else
				list[i] = {skill_id = v, open = ClientEnum.SKILL_STATE.OPEN}
			end
		else
			list[i] = {skill_id = v, open = ClientEnum.SKILL_STATE.OPEN}
		end
	end
	local level = LuaItemManager:get_item_obejct("game"):getLevel()
	local d = {}
	for i,v in ipairs(list) do
		d[i] = ConfigMgr:get_config("skill")[v.skill_id]
		d[i].open = v.open

		local nd = ConfigMgr:get_config("skill")[d[i].code+1]
		if nd then
			d[i].is_can_up = level >= nd.limited_level-- 是否可以升级
		else
			d[i].is_can_up = false
		end
		if v.open == ClientEnum.SKILL_STATE.LOCK then
			d[i].is_can_up = false
		end
	end
	self.skill_list = d
	gf_print_table(self.skill_list, "技能列表")
end

-- 学习技能
function Skill:learn_skill_c2s( skill_index )
	local msg = {skillIndex = skill_index}
	gf_print_table(msg, "学习升级:")
	Net:send(msg, "scene", "LearnSkill", skill_index)
end

function Skill:learn_skill_s2c( msg, skill_index )
	print("学习返回")
	if msg.err ~= 0 then
		return
	end
	self.skill_list[skill_index].open = ClientEnum.SKILL_STATE.OPEN
end

-- 技能升级
function Skill:skill_level_up_c2s(skill_index)
	local msg = {skillIndex = skill_index}
	gf_print_table(msg, "技能升级:")
	Net:send(msg, "scene", "SkillLevelUp", skill_index)
	-- Net:receive({err = 0}, Net:get_id1("scene"), Net:get_id2("scene", "SkillLevelUpR"), skill_index)
end

function Skill:skill_level_up_s2c( msg , skill_index)
	print("技能升级返回")
	if msg.err ~= 0 then
		return
	end
	local level = LuaItemManager:get_item_obejct("game"):getLevel()
	local last_data = self.skill_list[skill_index]
	local data = ConfigMgr:get_config("skill")[last_data.code+1]
	if data then
		data.open = ClientEnum.SKILL_STATE.OPEN
		local nd = ConfigMgr:get_config("skill")[data.code+1]
		if nd then
			data.is_can_up = level >= nd.limited_level-- 是否可以升级
		else
			data.is_can_up = false
		end
	end
	self.skill_list[skill_index] = data
end

-- 全部升级
function Skill:one_key_skill_level_up_c2s()
	Net:send({}, "scene", "OneKeySkillLevelUp")
end

function Skill:one_key_skill_level_up_s2c(msg)
	if msg.err == 0 then
		print("技能全部升级成功!")
	end
end

function Skill:open_skill(skill_type,skill_index)
	self.skill_index = skill_index
end
