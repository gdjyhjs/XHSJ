--[[--
--
-- @Author:Seven
-- @DateTime:2017-04-12 14:37:37
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Game = LuaItemManager:get_item_obejct("game")
local Enum = require "enum.enum"
local PowerChange = require("models.game.powerChange")
local AttributeChange = require("models.game.attributeChange")
Game.priority = 10000

local player_account_key = "player_account"
local palyer_password_key = "player_password"
local select_area_key = "select_area"

--初始化函数只会调用一次
function Game:initialize()
	-- 角色id
	self.role_id = 0

	-- 角色信息
	self.role_info = {}
	
	-- 玩家账号
	self.player_account = PlayerPrefs.GetString(player_account_key,"")
	-- 玩家密码
	self.palyer_password = PlayerPrefs.GetString(palyer_password_key,"")

	-- 玩家头像
	self.player_head = ""

	-- 区id
	self.area_id = -1
	-- 区名字
	self.area_name = ""

	--体力购买次数
	self.strenght_buy_count = 0

	self.server_open_time = 0		--服务器开服时间

	--设置游戏质量等级
	local value = 2
	if PlayerPrefs.HasKey("QualityLevel") then
		value = UnityEngine.PlayerPrefs.GetInt("QualityLevel", value)
	else
		local data =  ConfigMgr:get_config("graphics_card")
		local gpu = UnityEngine.SystemInfo.graphicsDeviceName
		if #data== 0 then return end
		for k,v in pairs(data) do
			if string.find(gpu, v.name) and string.find(gpu, v.value) then
				value = v.quality or value
			end
		end
	end
	self:set_quality_level(value)

	-- self:get_strenght_left_count_c2s()
	self.attribute_change_stack = nil -- 属性变化队列
end

-----get **************************************************************************************
function Game:set_quality_level(value)
	print("设置质量等级",value)
	if value > #UnityEngine.QualitySettings.names then
		value = #UnityEngine.QualitySettings.names
	end
	self.quality_level = value
	UnityEngine.QualitySettings.SetQualityLevel (value, true)
	UnityEngine.PlayerPrefs.SetInt("QualityLevel",value)
	print(UnityEngine.QualitySettings.names[value])
end

function Game:get_quality_level()
	print("获取质量等级",self.quality_level)
	return self.quality_level or 2
end


function Game:getRoleInfo()
	return self.role_info
end	

-- 获取角色id
function Game:getId()
	return self.role_info.roleId or 0
end

function Game:getServerId()
	return self.role_info.serverId or 0
end
-- 获取角色名字
function Game:getName()
	return self.role_info.name
end
-- 获取角色名字
function Game:setName(name)
	self.role_info.name = name
end


-- 获取称号
function Game:get_title()
	if not self.role_info.title or self.role_info.title == 0 then
		return ""
	end
	return ConfigMgr:get_config("title")[self.role_info.title].name or ""
end

-- 获取玩家等级
function Game:getLevel()
	return self.role_info.level
end

--获取购买体力次数
function Game:get_strenght_buy_count()
	return self.strenght_buy_count
end

--获取玩家战力
function Game:getPower()
	return self.role_info.power
end

--获取玩家头像
function Game:getHead()
	return self.role_info.head
end

--[[
获取钱
ty:Enum.BASE_RES
]]
function Game:get_money( ty )
	return self.role_info.baseRes[ty]
end

function Game:get_career()
	return self.role_info.career
end

-- 获取体力
function Game:get_strenght()
	return self.role_info.baseRes[ServerEnum.BASE_RES.STRENGTH] or 0
end

-- 获取最大体力
function Game:get_max_strenght()
	return ConfigMgr:get_config("t_misc").strength.max_strength or 0
end

-- 获取经验
function Game:get_exp()
	return self.role_info.baseRes[ServerEnum.BASE_RES.EXP]
end

-- 最大经验
function Game:get_max_exp()
	return ConfigMgr:get_config("player")[self:getLevel()].exp
end

-- 获取铜钱
function Game:get_coin()
	return self.role_info.baseRes[ServerEnum.BASE_RES.COIN]
end

-- 获取元宝
function Game:get_gold()
	return self.role_info.baseRes[ServerEnum.BASE_RES.GOLD]
end

-- 获取绑定元宝
function Game:get_bind_gold()
	return self.role_info.baseRes[ServerEnum.BASE_RES.BIND_GOLD]
end

function Game:get_donation()
	return self.role_info.baseRes[ServerEnum.BASE_RES.ALLIANCE_DONATE]
end

-- 设置玩家账号
function Game:set_player_account( name )
	self.player_account = name
	PlayerPrefs.SetString(player_account_key, name)
end

-- 设置玩家密码
function Game:set_player_password( password )
	self.palyer_password = password
	PlayerPrefs.SetString(palyer_password_key, password)
end

-- 获取服务器名字
function Game:get_server_name()
	return self.area_name
end

-- 区id
function Game:get_area_id()
	return self.area_id
end

-- 获取攻击力
function Game:get_atk()
	return self.role_info.combatAttr[ServerEnum.COMBAT_ATTR.ATTACK]
end

-- 设置当前地图id
function Game:set_map_id( map_id )
	self.role_info.mapId = map_id
end

-- 获取当前地图id
function Game:get_map_id()
	return self.role_info.mapId
end

-- 获取血量
function Game:get_hp()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.HP]
end

function Game:get_cur_hp()
	return self.role_info.curHp
end

-- 获取物理防御
function Game:get_phy_def()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.PHY_DEF]
end

-- 获取法术防御
function Game:get_magic_def()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.MAGIC_DEF]
end

-- 获取暴击
function Game:get_crit()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.CRIT]
end

-- 命中
function Game:get_hit()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.HIT]
end

-- 穿透
function Game:get_through()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.THROUGH]
end

-- 格挡
function Game:get_block()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.BLOCK]
end

-- 闪避
function Game:get_dodge()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.DODGE]
end

-- 坚韧
function Game:get_crit_def()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.CRIT_DEF]
end

-- 免伤
function Game:get_damage_down()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.DAMAGE_DOWN]
end

--回血
function Game:get_recover()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.RECOVER] or 0
end

--伤害加深
function Game:get_final_damage_prob()
    return self.role_info.combatAttr[Enum.COMBAT_ATTR.FINAL_DAMAGE_PROB] or 0
end
  
--免伤率
function Game:get_damage_down_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.DAMAGE_DOWN_PROB] or 0
end

--暴击率
function Game:get_crit_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.CRIT_PROB] or 0
end

--暴击伤害
function Game:get_crit_hurt_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.CRIT_HURT_PROB] or 0
end

--命中率
function Game:get_hit_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.HIT_PROB] or 0
end

--闪避率
function Game:get_dodge_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.DODGE_PROB] or 0
end

--穿透率
function Game:get_through_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.THROUGH_PROB] or 0
end

--坚韧率
function Game:get_crit_def_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.CRIT_DEF_PROB] or 0
end

--格挡率
function Game:get_block_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.BLOCK_PROB] or 0
end

--回血率
function Game:get_recover_prob()
	return self.role_info.combatAttr[Enum.COMBAT_ATTR.RECOVER_PROB] or 0
end

-- 获取当前战斗模式
function Game:get_pk_mode()
	return self.role_info.pkMode
end

--send 

--获取体力购买剩余次数
function Game:get_strenght_left_count_c2s()
	local msg = {}
	Net:send(msg, "base", "StrengthLeftBuyTimes")
end

--返回体力购买次数 
function Game:get_strenght_left_count_s2c(msg)
	self.strenght_buy_count = msg.leftBuyTimes 
end

function Game:set_server_open_time(open_time)
	self.server_open_time = open_time
end

function Game:get_server_open_time()
	return self.server_open_time
end

function Game:get_can_to_lv(add_exp)
	local cur_exp = self:get_exp()
	local lv = self:getLevel()
	local data = ConfigMgr:get_config("player")
	local left_exp = cur_exp + add_exp
	print("wtffffffff",cur_exp,add_exp)
	while 0 < left_exp do
		left_exp = left_exp - data[lv].exp
		if 0 <= left_exp then
			if data[lv + 1] == nil then
				break
			else
				lv = lv + 1
			end
		end
	end
	return lv
end
--购买体力
function Game:buy_strenght_c2s()
	local msg = {}
	Net:send(msg, "base", "BuyStrength")
end

--购买体力返回
function Game:buy_strenght_s2c(msg)
end


---------------------------------------------------private--------------------------------------------------

--服务器返回
function Game:on_receive( msg, id1, id2, sid )
    -- print("mainui服务器返回")
    if(id1==Net:get_id1("base"))then
        if id2 == Net:get_id2("base", "UpdateResR") then
        	-- gf_print_table(msg,"打印更新基础资源")
            --更新玩家資源
            for i,v in ipairs(msg.baseRes) do
            	if v~=self.role_info.baseRes[i] then
        			local c = v - self.role_info.baseRes[i]
        			if i == Enum.BASE_RES.EXP then
        				-- print("获得的经验",c,"---------------------------------------------------------")
        				-- if self.up_level then
        				-- 	--升级所需经验，减去原有经验，算出差多少经验升级d
        				-- 	print("玩家升了几级",self.up_level,"---------------------------------------------------------")
        				-- 	for i=1,self.up_level do
            -- 					local d = ConfigMgr:get_config("player")[self:getLevel()-i].exp
            -- 					print(self:getLevel()-i,"级的经验",d,"---------------------------------------------------------")
            -- 					c = d + c
        				-- 	end
        				-- 	self.up_level = nil
        				-- end
        				-- print("最终经验",c,"---------------------------------------------------------")
        				-- print("原有经验%d，现有经验%s，新增数量%s",self.role_info.baseRes[i],v,c)
        				-- print("飘字：经验变更",v,"原本经验",self.role_info.baseRes[i])
        				self:char_add_exp(c)
        			else
            			if c>0 then
            				gf_message_tips(string.format("获得<color="..LuaItemManager:get_item_obejct("itemSys"):get_item_color("GREEN")..">%d%s</color>",c,gf_get_money_name(i)))
            			else
            				gf_message_tips(string.format("消耗<color="..LuaItemManager:get_item_obejct("itemSys"):get_item_color("GREEN")..">%d%s</color>",-c,gf_get_money_name(i)))
            			end
            		end
            	end

            end
            self.role_info.baseRes=msg.baseRes

        elseif id2 == Net:get_id2("base", "UpdateLvlR") then
        	-- gf_print_table(msg,"打印升级协议")
        	gf_message_tips(string.format("升到了<color="..LuaItemManager:get_item_obejct("itemSys"):get_item_color("GREEN")..">%d</color>级",msg.level))
        	self.role_info.level = msg.level

        	local cur_exp = self.role_info.baseRes[Enum.BASE_RES.EXP]
        	local cur_up_level_exp = ConfigMgr:get_config("player")[self:getLevel()].exp
        	if msg.exp < cur_up_level_exp then --print("-- 飘字：不能再升级了","升级消耗了经验",ConfigMgr:get_config("player")[self:getLevel()-1].exp)
        		local exp = msg.exp + ConfigMgr:get_config("player")[self:getLevel()-1].exp - cur_exp + (self.up_level_add_exp or 0)
        		self.up_level_add_exp = nil
        		self:char_add_exp(exp)
    			self.role_info.baseRes[Enum.BASE_RES.EXP] = msg.exp
        	else --print("-- 飘字：还能再继续升级","升级消耗了经验",ConfigMgr:get_config("player")[self:getLevel()-1].exp)
        		self.up_level_add_exp = (self.up_level_add_exp or 0) + ConfigMgr:get_config("player")[self:getLevel()-1].exp
        	end

        	-- print("升级了人物")
			 -- 角色、坐骑、武将升级时播放的音效
			Sound:play(ClientEnum.SOUND_KEY.LEVEL_UP)
        	-- LuaItemManager:get_item_obejct("battle"):remove_model_effect(self.role_id, ClientEnum.EFFECT_INDEX.UPLEVEL)
			LuaItemManager:get_item_obejct("battle"):add_model_effect(self.role_id,"41000014.u3d", ClientEnum.EFFECT_INDEX.UPLEVEL)
			
        elseif id2 == Net:get_id2("base", "StrengthLeftBuyTimesR") then
        	gf_print_table(msg, "StrengthLeftBuyTimesR:")
        	self:get_strenght_left_count_s2c(msg)

        elseif id2 == Net:get_id2("base", "UpdateCombatR") then
        	-- gf_print_table(msg,"更新属性")
        	if not self.role_info.combatAttr then
        		self.role_info.combatAttr = {}
        	end

        	local attr_change = false
        	local data = ConfigMgr:get_config("t_misc").attribute_change.show_attr
        	for k,v in pairs(msg.combatAttr or {}) do
        		if self.role_info.combatAttr[k] and data[k] and (not self.attribute_change_stack or self.attribute_count<ConfigMgr:get_config("t_misc").attribute_change.max_cache) and self.role_info.combatAttr[k] < v then
        			if not self.attribute_change_stack then
        				attr_change = true
        				self.attribute_change_stack = {}
        				self.attribute_count = 0
        			end
        			-- print(Time.time,"保存一条属性增加","当前保存的数量",#self.attribute_change_stack)
        			self.attribute_count = self.attribute_count + 1
        			self.attribute_change_stack[#self.attribute_change_stack+1] = {attr = k,value = v - self.role_info.combatAttr[k]}
        		-- elseif self.role_info.combatAttr[k] and data[k] and self.role_info.combatAttr[k] < v then
        		-- 	print(Time.time,"属性增加超过最大保存数量，不保存","当前保存的数量",self.attribute_change_stack and #self.attribute_change_stack or 0)
        		end
        		self.role_info.combatAttr[k] = v
        	end
        	if attr_change then
        		AttributeChange(self)
        	end
        elseif(id2== Net:get_id2("base", "UpdatePowerR"))then
        	if self.role_info.power ~= msg.power then
				PowerChange(self,self.role_info.power,msg.power)
	            self.role_info.power = msg.power
	        end
	    elseif (id2== Net:get_id2("base", "BuyStrengthR")) then
	    	gf_print_table(msg,"BuyStrengthR")
	    	if msg.err == 0 then
	    		self.strenght_buy_count = self.strenght_buy_count - 1
	    	end

        end
	elseif id1==Net:get_id1("base") then
		if id2 == Net:get_id2("scene", "SetPkModeR") then -- 战斗模式
        	if msg.err ~= 0 then
        		return
        	end
        	self.role_info.pkMode = msg.mode
        end
   


    elseif id1 == ClientProto.PlayerBlood then -- 血量刷新
    	if msg.hp or msg.max_hp then
    		self.role_info.curHp = msg.hp
    		self.role_info.combatAttr[Enum.COMBAT_ATTR.HP] =msg.max_hp
    	end
    end
end

-- 角色获得经验
function Game:char_add_exp(exp)
	local char = LuaItemManager:get_item_obejct("battle"):get_character()
	if char then
		local tf = char.transform
		local btf_type = 1
		LuaItemManager:get_item_obejct("floatTextSys"):battle_float_text(tf,"jingyan",exp)
	end
end