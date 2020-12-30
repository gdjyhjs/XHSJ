--[[--
-- 模型基本类
-- @Author:Seven
-- @DateTime:2017-04-20 09:47:06
--]]
local SpriteBase = require("common.spriteBase")

local LocalString = 
{
	[1] = gf_localize_string("%s[%d级]"),
}

local ModelBase = class(SpriteBase, function( self, config_data, ...)
	self.config_data = config_data
	self.battle_item = LuaItemManager:get_item_obejct("battle")
	self.model_id = config_data.model_id
	
	SpriteBase._ctor(self, config_data.model_id..".u3d", ...)
	if not self.sound_list then
		self.sound_list = {}
	end
end)

--[[
*移动到某个位置
*pos：要移动的位置
*end_fn:移动结束的回调
*force:强制移动，不管出于什么动画
*is_path:是否要返回一条路径
]]
function ModelBase:move_to( pos, end_fn, min_distance, force, is_path )
	if self.is_boss then
		print("wtf boss move to :",pos.x,pos.y,pos.z)
	end
	self._destination_pos = pos
	if not self.is_init or not self.auto_move or not pos then
		return false
	end

	self.attack_mgr:StopMove()
	self.auto_move_end_fn = end_fn

	self.auto_move.minDistance = min_distance or self.atk_range

	return self.auto_move:SetDestination(pos, force or false, is_path or true)
end

function ModelBase:move_to2( pos, cb, dis, ani )
	if not pos or not self.is_init or not self.normal_move then
		return false
	end
	return self.normal_move:MoveTo(pos, cb, dis or self.atk_range, ani or "")
end

-- 设置向前移动
function ModelBase:set_move_forward( flag )
	if not self.is_init then
		return
	end

	if not self.normal_move then
		return
	end

	self.move_forward = flag
	self.auto_move:StopMove(true)
	self.normal_move:SetMoveForward(flag)
	if self.animator then
		self.animator:SetBool ("move", flag)
	end
end

function ModelBase:is_move_forward()
	return self.move_forward
end

-- 设置不可移动
function ModelBase:set_can_not_move( not_move )
	self.normal_move.canNotMove = not_move
	self.auto_move.canNotMove = not_move
end

-- 是否真正移动
function ModelBase:is_move()
	if not self.is_init then
		return false
	end
	return self.normal_move:IsMove() or self.auto_move:IsAutoMove() 
	-- or self.attack_mgr:IsMove()
end

function ModelBase:is_auto_move()
	return self.auto_move:IsAutoMove()
end

-- 是否真正攻击
function ModelBase:is_atk()
	return self.animator:GetCurrentAnimatorStateInfo (1):IsName ("EmptyState") == false
end

-- 设置移动速度
function ModelBase:set_speed( speed )
	print("设置速度:",speed,self.is_player)
	self.speed = speed
	self.normal_move.speed = speed
	self.auto_move.speed = speed
end

function ModelBase:get_hp()
	return self.hp
end

function ModelBase:get_max_hp()
	return self.max_hp
end

function ModelBase:set_hp( hp, max_hp )

	self.hp = hp or 1

	-- 特殊处理。第一场战斗，不让玩家死亡
	if self.is_self then
		if self.hp <= 0 and not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
			self.hp = 1
		end
	end

	self.max_hp = max_hp or 1
	self.hp_percent = self.hp/self.max_hp

	self.dead = self.hp<=0
	if self.blood_line then
		self.blood_line:set_hp(self.hp_percent)
	end

	if self.dead then
		self:show_dead()
	else
		self.is_show_dead = false
	end


end

function ModelBase:set_guid( guid )
	self.guid = guid
end

function ModelBase:get_guid()
	return self.guid
end

-- 设置攻击者
function ModelBase:set_attacker( attacker )
	self.attacker = attacker
end

function ModelBase:get_attacker()
	return self.attacker
end

function ModelBase:set_level( level )
	self.config_data.level = level
end

function ModelBase:get_level()
	return self.config_data.level
end

function ModelBase:get_name()
	return self.config_data.name
end

-- 是否处于眩晕(冰冻)不可以进行任何战斗操作
function ModelBase:set_dizzy( dizzy )
	self.is_dizzy = dizzy
end

function ModelBase:show_dead()
	-- if self.is_show_dead then
	-- 	return
	-- end
	-- self.is_show_dead = true
	-- self.animator:SetTrigger("dead")
	self:stop_move()
	self.animator:Play("dead", 1)
	-- 死亡声效
	if self.sound_list.dead then
		print("死亡音效播放",self.sound_list.dead)
		Sound:play_fx(self.sound_list.dead,false,self.root)
	end

	-- 移除buffer
	if self.buffer then
		print("删除buffer",self.buffer.guid)
		self.battle_item:remove_buffer(self.buffer.guid)
	end
end

-- 设置血条
function ModelBase:set_hp_visible( visible )
	if not self.blood_line then
		return
	end
	self.blood_line_visible = visible
	self.blood_line:set_hp_visible(self.blood_line_visible)
end

-- 设置是否显示名字
function ModelBase:set_name_visible( visible )
	if not self.blood_line then
		return
	end
	self.blood_line:set_name_visible(visible)
end

function ModelBase:set_eulerAngles( angle )
	ModelBase._base.set_eulerAngles(self, angle)
end

function ModelBase:set_mesh_enable( enabled )
	self.mesh_enable = enabled
	if self.mesh then
		for i=1,self.mesh.Length do
			self.mesh[i].enabled = enabled
		end
	end
end

function ModelBase:is_mesh_enable()
	return self.mesh_enable
end

function ModelBase:set_buffer( buffer )
	if self.buffer then
		self.battle_item:remove_buffer(self.buffer.guid)
	end
	self.buffer = buffer
end

function ModelBase:get_buffer()
	return self.buffer
end

function ModelBase:faraway()
	ModelBase._base.faraway(self)

	self.is_faraway = true

	self.normal_move.enabled = false
	self.auto_move.enabled = false
	self.attack_mgr.enabled = false
	self:stop_move()
	
	if self.blood_line then
		self.blood_line:hide()
	end

	if self.animator and self.animator:GetCurrentAnimatorStateInfo (1):IsName ("EmptyState") == false then
		self.animator:SetTrigger("cancel")
	end
end

function ModelBase:reset()
	self.is_faraway = false
	
	self.normal_move.enabled = true
	self.auto_move.enabled = true
	self.attack_mgr.enabled = true

	if self.blood_line then
		self.blood_line:show()
	end

	if self.animator and self.animator:GetCurrentAnimatorStateInfo (1):IsName ("EmptyState") == false then
		self.animator:SetTrigger("cancel")
	end
	if self.animator  then
		self.animator:SetBool("idle", true)
		self.animator:SetBool("move", false)
	end
end

function ModelBase:hurt( dmg, result )
	if not self.is_init then
		return
	end
	self.hp = self.hp - dmg
	self:set_hp(self.hp, self.max_hp)

	if not self.is_player then
		print("受击音效播放",self.sound_list.hit)
		Sound:play_fx(self.sound_list.hit,false,self.root) -- 受击音效
	end

	if self.hp > 0 then
		if dmg/self.max_hp >= 0.2 then -- 单次受到的伤害>=最大生命值的20%时，必定会造成0.5s硬直并执行受击动作
			self:show_hit_ani()
			if self.root.tag == "player" and self.sound_list.hit then
				print("受击音效播放",self.sound_list.hit)
				Sound:play_fx(self.sound_list.hit,false,self.root) -- 受击音效
			end
		elseif math.random(0, 100) <= 5 then -- 单次受击，有百分5的几率播放受击动作
			self:show_hit_ani()
			if self.root.tag == "player" and self.sound_list.hit then
				print("受击音效播放",self.sound_list.hit)
				Sound:play_fx(self.sound_list.hit,false,self.root) -- 受击音效
			end
		end
	end

end

function ModelBase:show_hit_ani()
	if self.animator then
		self.animator:SetTrigger("hit")
	end
end

function ModelBase:is_dead()
	return self.dead
end

function ModelBase:have_dead_ani()
	return self.dead_time > 0
end

-- 设置战斗状态
function ModelBase:set_battle_flag( flag )
	self.battle_flag = flag
	if flag then
		self:set_attacker(nil)
	end
end

-- 获取战斗状态
function ModelBase:get_battle_flag()
	return self.battle_flag
end

-- 设置怪物攻击目标
function ModelBase:set_target( target )
	self.target = target
end

-- 停止自动寻路
function ModelBase:stop_auto_move()
	self.auto_move:StopMove(true)
end

function ModelBase:stop_move()
	self.auto_move:StopMove(true)
	self.normal_move:StopMove()
end

-- 设置阵营(战场用到)
function ModelBase:set_faction( faction )
	self.faction = faction
end

function ModelBase:get_faction()
	return self.faction
end

function ModelBase:on_showed()
	if not self.is_init then
		return
	end

	self.animator:SetBool("ride_idle", false)
	self.animator:SetBool("idle", true)
	
	self.blood_line:show()
end

function ModelBase:on_hided()
	if not self.is_init then
		return
	end
	
	self.blood_line:hide()
end

function ModelBase:dispose()
	if self.blood_line then
		self.blood_line:dispose()
		self.blood_line = nil
	end

	self.mesh = nil
	self.normal_move = nil
	self.animator = nil
	self.auto_move = nil
	self.event_mgr = nil
	self.head_node = nil

	ModelBase._base.dispose(self)
end

-- 初始化特效
function ModelBase:init_effect()
	
end

-- 初始化帧数事件
function ModelBase:init_ani_event()
	
end

-- 帧事件回调
function ModelBase:ani_event_callback( arg )
	print("动画帧回调",arg)
	if self.sound_list[arg] then
		print("动画帧回调 音效播放",arg)
		Sound:play_fx(self.sound_list[arg],false,arg ~= "xp" and self.root or nil)
	end
end

-- 自动寻路到达目的地回调
function ModelBase:arrive_destination_callback()
	if self.auto_move_end_fn then
		local cb = self.auto_move_end_fn
		self.auto_move_end_fn = nil
		cb()
	end
end

----------------------------private-------------------
function ModelBase:pre_init()

    self.target = nil -- 玩家攻击目标

	self.speed = self.config_data.speed*0.1 or 15 -- 玩家速度
	self.normal_speed = self.speed
	print("初始化速度",self.normal_speed)
	self.hp = self.config_data.hp or 0 -- 玩家血量
	self.max_hp = self.config_data.max_hp or 100 -- 最大血量
	self.hp_percent = self.hp/self.max_hp

	self.dead = self.hp_percent <= 0 -- 是否死亡
	self.atk = self.config_data.phy_attack or 10 -- 攻击力

	self.atk_range = self.config_data.attack_distance*0.1
	self.atk_range_d = self.atk_range*self.atk_range
	
	self.model_height = 4 -- 模型高度
	self.dead_time = 0
	self.blood_line = nil -- 血条
	self.blood_line_visible = false
	self.blood_pos = nil

	self.guid = -1 -- 唯一id，服务器下发

	self.auto_move_end_fn = nil

	-- 战斗状态
	self.battle_flag = false

	self.target = nil
	self.mesh_enable = true
end

function ModelBase:base_init()
	self.transform = self.root.transform

	LuaHelper.SetLayerToAllChild(self.transform, ClientEnum.Layer.CHARACTER)-- 不碰撞层
	Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）

	self.mesh = LuaHelper.GetComponentsInChildren(self.root, "UnityEngine.SkinnedMeshRenderer")
	self.normal_move = self.root:AddComponent("Seven.Move.NormalMove")
	self.animator = LuaHelper.GetComponent(self.root, "UnityEngine.Animator") -- 动画控制器

	self.auto_move = self.root:AddComponent("Seven.Move.AutoMove")
	self.auto_move.arriveDestinationFn = handler(self, self.arrive_destination_callback)

	self.event_mgr = self.root:AddComponent("Seven.DynamicAddEvents")
	self.event_mgr.CallBackFn = handler(self, self.ani_event_callback)

	if self.is_player then
		self.attack_mgr = self.root:AddComponent("Seven.Attack.PlayerAttack")
	else
		self.attack_mgr = self.root:AddComponent("Seven.Attack.MonsterAttack")
	end


	self.auto_move.minDistance = self.atk_range -- 设置攻击范围

	self.head_node = LuaHelper.FindChild(self.root, "HP")
	if self.head_node then
		self.model_height = self.head_node.transform.position.y
	else
		print_error("找不到血条点",self.url,self.config_data.code)
	end

	self.is_init = true

	self.dead_time = self.event_mgr:GetAniTime("dead") -- 死亡动画时间
	self.run_dead_time = 0
	if self.animator then
		self.animator:SetBool("idle", true)
	end
	self:set_position(self.position)
	self:set_parent(self.parent)
	self:set_scale(self.scale)
	self:set_eulerAngles(self.eulerAngles)

	self:init()
	print("ModelBase:base_init1111",self.model_id)
	self:init_effect()
	print("ModelBase:base_init2222",self.model_id)
	self:init_ani_event()

	if self.loaded_cb then
		print("ModelBase:base_init33333",self.model_id)
		self.loaded_cb(self, unpack(self._param))
		print("ModelBase:base_init44444",self.model_id)
	end
end

function ModelBase:set_blood_line( blood_line )
	if self.head_node then
		self.blood_line = blood_line
		self.blood_line:set_target(self.head_node.transform)
		self.blood_line:set_hp(self.hp_percent)
		if self.is_monster then
			self.blood_line:set_info(string.format(LocalString[1], self.config_data.name, self.config_data.level), self.config_data.title or "")
		else
			self.blood_line:set_info(self.config_data.name or "", self.config_data.title or "")
		end
		self:set_hp_visible(false)
	end
end

function ModelBase:set_blood_line_visble(tag)
	if self.blood_line ~= nil then
		if tag ~= true then
			self.blood_line:hide()
		else
			self.blood_line:show()
		end
	end
end

return ModelBase
