--[[
	坐骑系统数据模块
	create at 17.6.19
	by xin
]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local boss = LuaItemManager:get_item_obejct("boss")

local Enum = require("enum.enum")
local model_name = "scene"
--UI资源
boss.assets=
{
    View("bossView", boss) ,
}

--点击事件
function boss:on_click(obj,arg)
	--通知事件(点击事件)
	self:call_event("boss_view_on_click", false, obj, arg)
	return true
end


--初始化函数只会调用一次
function boss:initialize()
end

--判断是否是boss场景
function boss:is_boss_scene()
	local map_id = gf_getItemObject("battle"):get_map_id()
	local map_info = ConfigMgr:get_config("mapinfo")[map_id]
	if map_info then
		return map_info.sub_type == Enum.MAP_SUB_TYPE.HOLE_BOSS
	end
	return false
end

-- 是否是魔狱首领
function boss:is_magic()
	local map_id = gf_getItemObject("battle"):get_map_id()
	local map_info = ConfigMgr:get_config("mapinfo")[map_id]
	if map_info then
		return map_info.sub_type == Enum.MAP_SUB_TYPE.MAGIC_BOSS
	end
	return false
end

function boss:move_to_transform(boss_id)
	local dataUse = require("models.boss.dataUse")
	local boss_info = dataUse.getBossInfo(boss_id)

	local transform = dataUse.getTransformPos(boss_info.map_id)

	local function find(transform_id)
			
		local transform_list = gf_getItemObject("battle").transport_list

		for k,v in pairs(transform_list or {}) do
			if v.config_data.code == transform_id then
				return true,v.position
			end
		end

		return false
	end

	--仅支持当前地图是对应boss地图传送
	for i,v in ipairs(transform or {}) do
		local is_in,pos = find(v.code)
		if is_in then
			local posx,posy = pos[1],pos[3]
			-- gf_getItemObject("battle"):move_to(map_id,posx,posy)
			print("开始寻路 wtf",posx,posy)
			LuaItemManager:get_item_obejct("map"):move_to_point({x = posx, z = posy})
			return true
		end
	end
	--并没有传送阵 传送到传送阵所在地图
	self.boss_id = boss_id
	local map_id = transform[1].belong_map
	gf_getItemObject("battle"):transfer_map_c2s(map_id, nil, nil,true)
	return true
end

-- 移动到某个boss的位置
function boss:move_to_boss( boss_id )
	local data = ConfigMgr:get_config("world_boss")[boss_id]
	local map_id = data.map_id
	local map_data = ConfigMgr:get_config("map.mapMonsters")[map_id]
	local monster_list = map_data[ServerEnum.MAP_OBJECT_TYPE.CREATURE] or {}
	local cb = function() -- 到达目的地，开始自动挂机
		gf_auto_atk(true)
	end
	for i,v in ipairs(monster_list) do
		if v.code == boss_id then
			gf_auto_atk(false)
			gf_getItemObject("battle"):move_to(map_id, v.pos.x, v.pos.y, cb, 12)
			break
		end
	end
	return true
end

function boss:find_boss(boss_id)
	local dataUse = require("models.boss.dataUse")
	local boss_info = dataUse.getBossInfo(boss_id)
	if boss_info.type == ServerEnum.BOSS_TYPE.HOLE_BOSS then
		return self:move_to_transform(boss_id)

	elseif boss_info.type == ServerEnum.BOSS_TYPE.WILD_BOSS then
		return self:find_wild_boss(boss_id)

	elseif boss_info.type == ServerEnum.BOSS_TYPE.MAGIC_BOSS then
		return self:move_to_boss(boss_id)
	end
end

--寻找地洞boss
function boss:find_wild_boss(boss_id)
	local dataUse = require("models.boss.dataUse")
	local boss_info = dataUse.getBossInfo(boss_id)
	local map_id = gf_getItemObject("battle"):get_map_id()
	if boss_info.map_id == map_id then
		gf_message_tips(gf_localize_string("领主正在此地"))
		return true
	end
	gf_message_tips(gf_localize_string("正在前往讨伐领主"))
	gf_getItemObject("battle"):transfer_map_c2s(boss_info.map_id, nil, nil,true)
	return true
end

--get ***********************************************************************************
-- 魔狱首领疲劳值
function boss:get_magic_tired()
	return self.magic_tired
end

-- 魔狱首领击杀玩家
function boss:get_magic_kill_name()
	return self.magic_kill_name
end

-- 获取掉落列表
function boss:get_drop_list()
	return self.drop_list
end

--set ***********************************************************************************



--send ***********************************************************************************
function boss:send_to_get_boss_data(boss_id)
	local msg = {}
	msg.bossId = boss_id
	Net:send(msg,model_name,"WorldBossInfo")
	testReceive(msg, model_name, "WorldBossInfoR")
end

-- 魔狱首领信息
function boss:magic_boss_info_c2s(boss_id)
	print("魔狱首领信息",boss_id)
	Net:send({bossCode = boss_id}, "scene", "MagicBossInfo")
end

-- 掉落记录
function boss:drop_record_c2s()
	Net:send({}, model_name, "DropRecordL")
end

-- 关注/取消关注
function boss:magic_boss_focus_c2s( boss_id, focus )
	local msg = {bossCode = boss_id, focus = focus}
	Net:send(msg, model_name, "MagicBossFocus")
end

-- boss 刷新列表
function boss:magic_boss_refresh_list_c2s()
	Net:send({}, model_name, "MagicBossRefreshList")
end

--rec ***********************************************************************************

function boss:is_need_move_to_boss()
	if self.boss_id then
		self:move_to_transform(self.boss_id)
		self.boss_id = nil
	end
end

function boss:magic_boss_info_s2c( msg )
	gf_print_table(msg, "魔狱首领信息返回")
	self.magic_tired = msg.tired
	self.magic_kill_name = ""

	for i,v in ipairs(msg.killerNameL or {}) do
		self.magic_kill_name = self.magic_kill_name..v.."\n"
	end

	self.focus = msg.focus or false
end

function boss:drop_record_s2c( msg )
	self.drop_list = msg.list or {}
end

--服务器返回
function boss:on_receive( msg, id1, id2, sid )
    if(id1==Net:get_id1(model_name))then
        if id2 == Net:get_id2(model_name, "WorldBossHurtListR") then

        elseif id2 == Net:get_id2(model_name, "MagicBossInfoR") then
        	self:magic_boss_info_s2c(msg)

        elseif id2 == Net:get_id2(model_name, "MagicBossRefreshNotifyR") then
        	print("boss关注提示")
        	View("bossTipsView", self, nil, msg.bossCode)
        end
    end
    if id1 == ClientProto.JoystickStartMove or id1 == ClientProto.ShowMainUIAutoPath or 
    	id1 == ClientProto.PlayerSelfBeAttacked or id1 == ClientProto.PlayerSelAttack then

    	self.boss_id = nil

    end
end


