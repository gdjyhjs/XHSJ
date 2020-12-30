--[[--
-- 玩家角色模型
-- @Author:Seven
-- @DateTime:2017-04-20 10:36:52
--]]

local ModelBase = require("models.battle.obj.modelBase")
local SpriteBase = require("common.spriteBase")
local Effect = require("common.effect")
local ModelEffect = require("models.battle.obj.modelEffect")

local CharParent = LuaHelper.Find("Player").transform

local CMD = 
{
	NORMAL_1 	= "atk1",
	NORMAL_2 	= "atk2",
	NORMAL_3 	= "atk3",
	ONE 	 	= "skill1",
	TWO 		= "skill2",
	THREE 		= "skill3",
	FOUR 		= "skill4",
	XP 			= "skill5",
}

local SkillCMD = 
{
	[ServerEnum.SKILL_POS.NORMAL_1] = "atk1",
	[ServerEnum.SKILL_POS.NORMAL_2] = "atk2",
	[ServerEnum.SKILL_POS.NORMAL_3] = "atk3",
	[ServerEnum.SKILL_POS.ONE] 		= "skill1",
	[ServerEnum.SKILL_POS.TWO] 		= "skill2",
	[ServerEnum.SKILL_POS.THREE] 	= "skill3",
	[ServerEnum.SKILL_POS.FOUR] 	= "skill4",
	[ServerEnum.SKILL_POS.XP] 		= "skill5",
}

local Character = class(ModelBase, function( self, config_data, ... )
	ModelBase._ctor(self, config_data, ...)
end)

-- 设置pk模式
function Character:set_pk_mode( mode )
	self.pk_mode = mode
end

function Character:get_pk_mode()
	return self.pk_mode
end

-- 设置为镜像（竞技场到）
function Character:set_mirror( mirror )
	self._is_mirror = mirror
end

function Character:is_mirror()
	return self._is_mirror
end

-- 创建的时候设置血量
function Character:init_hp( hp, max_hp )
	print("Character:init_hp")
	self.hp = hp or 1
	self.max_hp = max_hp or 1
	self.hp_percent = self.hp/self.max_hp
	self.dead = self.hp<=0
	if self.dead then
		self.animator:Play("dead", 1, 0.95)
	end
end

function Character:set_hp( hp, max_hp )
	if self.is_self and hp > self.hp then -- 玩家回血飘字
		--[[local dh = hp-self.hp
		if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
			dh = dh*math.random(90,99)
		end
		LuaItemManager:get_item_obejct("floatTextSys"):battle_float_text(self.transform,"zhiliao",dh)]]
	end

	if self.dead and hp > 0 then
		self:reset()
	end

	Character._base.set_hp(self, hp, max_hp)

	if self.is_self then
		Net:receive({player_hp = self.hp_percent, hp = hp, max_hp = max_hp}, ClientProto.PlayerBlood)
	end

	if self.dead then
		self.item_obj:hide_select(self.guid)
		self:dead_view_show()
	end
end

-- 设置相机跟随
function Character:set_camera()
	if self.is_init then
		self.camera_follow:SetTarget(self.root)
	end
end

function Character:set_camera_target( target )
	self.camera_follow:SetTarget(target)
end

function Character:reset_camera()
	self.camera_follow:Reset()
end

-- 是否允许摇杆操作角色
function Character:enable_joystick( enable )
	-- print("是否允许摇杆操作角色",enable)
	self.is_joystick = enable or false

	if self.is_init then
		self.normal_move:EnableJoysick(enable)
	end
end

-- 设置自动攻击
function Character:set_auto_attack(flag)
	self.is_auto_attack = flag
	if flag then
		self.is_move_to_target = false
		-- self._send_auto_atk_msg = false
		self:set_target(nil)
	end
end

-- xp播放几率
function Character:set_xp_per( xp_per )
	self.xp_per = xp_per or 0
end

-- 设置是玩家自己
function Character:set_self( flag )
	self.is_self = flag or false
	if self.is_self then
		self.root.tag = "Player"
		Seven.PublicFun.ChangeShader(self.root, "Seven/PlayerDiffuse")
		local render = LuaHelper.GetComponentInChildren(self.root, "UnityEngine.Renderer")
		render.material:SetColor("_RimColor", Color(0,223/255,1,1))

		self.play_state = LuaHelper.AddComponent(self.root, "Seven.Player.PlayerState")

		-- 接收屏幕上下滑动的回调
		local finger_touch_ctr = TOUCH:GetComponent("Seven.Touch.FingerTouchController")
		finger_touch_ctr.onFingerMoveUpFn = handler(self, self.on_finger_move_up)
		finger_touch_ctr.onFingerMoveDownFn = handler(self, self.on_finger_move_down)

		self.camera_follow = LuaHelper.GetComponent(LuaHelper.Find("Main Camera"), "Seven.TargetFollow")
		
		self.is_can_sit = LuaItemManager:get_item_obejct("sit"):is_can_sit()

		-- 鼠标点击特效
		self.mouse_effect = self.item_obj.pool:get_effect("41000003.u3d")

		gf_register_update(self)

	else
		self.root.tag = "Untagged"
		Seven.PublicFun.ChangeShader(self.root, "Unlit/Texture")
		Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）

		-- 设置模型点击
		self.touch = self.root:AddComponent("Seven.Touch.Touch3DModel")
		self.touch.onTouchedFn = handler(self, self.on_touch_down)
	end
	self:enable_touch_move(self.is_self)

	print("设置血条",self.guid)
	local game = LuaItemManager:get_item_obejct("game")
	self.blood_line:set_vip(self.guid==game:getId() and game:getRoleInfo().vipLevel or 0)
	self.blood_line:set_hp(self.hp_percent)
	self.blood_line:set_info(self.config_data.name or "", self.config_data.title or "")
	self:init_atk_mgr_param()
end

-- 复活
function Character:revive(hp)
	self:reset()
	self:init_hp(hp, self.max_hp)
	self.blood_line:set_hp(self.hp_percent)
	self.animator.speed = 1 -- 开启动画
	self:set_speed(self.normal_speed)
	if self.is_self then
		--通知角色复活 
		gf_receive_client_prot({},ClientProto.PlayerRelive)
	end
	
end

function Character:set_can_transport( transport )
	-- self.can_transport = transport
	self.can_transport = true
end

-- 获取武将
function Character:get_hero()
	return self.hero
end

-- 设置武将
function Character:set_hero( hero )
	self.hero = hero
	if hero then
		self.hero:set_is_self(self.is_self)
		-- 是否需要显示模型
		local visible = self.is_self or not self.setting_item:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_HERO)
		if self.show_hero ~= nil then
			visible = self.show_hero
			self.show_hero = nil
		end
		self.hero:set_mesh_enable(visible)
		-- 是否需要跟随人物
		if self.battle_flag then
			self.hero:start_atk()
		else
			self.hero:stop_atk()
		end
	end
end

-- 设置坐骑
function Character:set_horse( horse )
	
	if horse then
		if self.is_self then
			self:enable_joystick(false)
			self:enable_touch_move(false)
			horse.root.tag = "Player"
		end

		local obj = self
		if self.horse then -- 换马
			obj = self.horse
		end
		self.animator:SetBool("ride_idle", true)

		horse:set_position(obj.transform.position)
		horse:set_parent(self.item_obj.pool.char_parent)
		horse:set_local_euler_angles(obj.transform.localEulerAngles)
		horse:set_atk_range(self.atk_range)

		if self.horse then
			self.item_obj.pool:add_horse(self.horse)
		end
		self.horse = horse
		self.blood_line:set_target(horse.head_node.transform)

		horse.normal_move.joystickStartFn = handler(self, self.joystick_start)
		horse.normal_move.joystickMoveFn = handler(self, self.joystick_move)
		horse.normal_move.joystickMoveEndFn = handler(self, self.joystick_move_end)
		horse.normal_move.aniChangeFn = handler(self, self.on_ani_change)

		horse.auto_move.pathCallbackFn = handler(self, self.path_callback)
		horse.auto_move.arriveDestinationFn = handler(self, self.arrive_destination_callback)
		horse.auto_move.aniChangeFn = handler(self, self.on_ani_change)

		horse.normal_move.speed = self.speed
		horse.auto_move.speed = self.speed

		self.horse.animator:SetBool("idle", true)
		if self:is_move() then
			if self.is_self then
				self.auto_move:StopMove(true)
				self.horse.auto_move.minDistance = self.auto_move.minDistance
				print("检查坐骑是否需要移动",self._destination_pos)
				if self._destination_pos then
					self.horse.auto_move:SetDestination(self._destination_pos, true, false)
				end
			else
				self.normal_move:SetMoveForward(false)
				self.normal_move.charCtr.radius = 0.1
				self.horse.normal_move:SetMoveForward(true)
			end
			self.animator:Play("ride_walk", 0)
		end

		self:set_parent(self.horse.ride_transform)
		self.transform.localPosition = Vector3(0,0,0)

		if self.is_self then
			self.camera_follow:SetTarget(horse.root)

			function delay_fn() -- 延迟设置摇杆控制
				if self:is_horse() then
					horse:enable_joystick(true)
					horse:enable_touch_move(true)
				end
			end
			delay(delay_fn, 0.5)
		end

		if self.hero then
			self.hero:set_speed(horse.speed)
			self.hero:set_follow_target(horse)
			self.hero:set_target_follow_move(self:is_follow_move())
		end

		if self.is_follow then
			self:change_follow(self.horse)
		end

		-- 把脚底阴影移到坐骑上
		if self.effect_list.shadow then
			self.effect_list.shadow:set_parent(horse.transform)
			self.effect_list.shadow.transform.localPosition = Vector3(0,0,0)
		end

		self._is_horse = true

		horse:set_mesh_enable(self:is_mesh_enable())
		self.horse.config_data.level = self.config_data.level
		self.horse.battle_flag = self.battle_flag
	else
		self._is_horse = false
		
		self.event_mgr:AddEvent("atkidle", 0.1, "atkidle")
		self.animator:SetBool("ride_idle", false)

		self:set_parent(self.item_obj.pool.char_parent)
		if self.horse then
			self.transform.localPosition = self.horse.transform.localPosition
			self.transform.localEulerAngles = self.horse.transform.localEulerAngles
			if self.is_self then
				self.horse:enable_joystick(false)
				self.horse:enable_touch_move(false)
			end
		end

		if self.is_self then
			self:enable_joystick(true)
			self:enable_touch_move(true)
		end

		self.blood_line:set_target(self.head_node.transform)

		self.normal_move.joystickStartFn = handler(self, self.joystick_start)
		self.normal_move.joystickMoveFn = handler(self, self.joystick_move)
		self.normal_move.joystickMoveEndFn = handler(self, self.joystick_move_end)
		self.normal_move.aniChangeFn = handler(self, self.on_ani_change)

		self.auto_move.pathCallbackFn = handler(self, self.path_callback)
		self.auto_move.arriveDestinationFn = handler(self, self.arrive_destination_callback)
		self.auto_move.aniChangeFn = handler(self, self.on_ani_change)
		self.normal_move.speed = self.speed
		self.auto_move.speed = self.speed

		if self.horse and self.horse:is_move() then

			if self.is_self then
				self.horse.auto_move:StopMove(true)
				self.auto_move.minDistance = self.horse.auto_move.minDistance
				if self._destination_pos then
					self.auto_move:SetDestination(self._destination_pos, false, true)
				end
				self.animator:Play("walk", 0)
			else
				self.horse.normal_move:SetMoveForward(false)
				self.normal_move:SetMoveForward(true)
				self.animator:Play("walk", 0)
			end
		end


		if self.is_self then
			self.camera_follow:SetTarget(self.root)
		end

		if self.hero then
			self.hero:set_speed(self.speed)
			self.hero:set_follow_target(self)
			self.hero:set_target_follow_move(self:is_follow_move())
		end

		if self.is_follow then
			self:change_follow(self)
		end

		if self.effect_list.shadow then
			self.effect_list.shadow:set_parent(self.transform)
			self.effect_list.shadow.transform.localPosition = Vector3(0,0,0)
		end

		self.item_obj.pool:add_horse(self.horse)
		self.horse = nil
	end

	if self.guid == LuaItemManager:get_item_obejct("battle")._last_select_guid then
		LuaItemManager:get_item_obejct("battle"):show_select( self.guid )
	end
end

-- 设置翅膀
function Character:set_wing( wing )
	self.wing = wing
	if self.wing then
		self.wing:set_mesh_enable(self:is_mesh_enable())
	end
end

-- 设置武器
function Character:set_weapon( weapon )
	self.weapon = weapon
	if self.weapon then
		self.weapon:set_mesh_enable(self:is_mesh_enable())
	end
end

-- 设置气息
function Character:set_surround( surround )
	self.surround = surround
end

-- 设置选中目标
function Character:set_select_target( target )
	self.select_target = target
end

-- 设置移动速度
function Character:set_speed( speed )
	print("设置速度:",speed,self.is_player)
	self.speed = speed
	if self:is_horse() then
		self.horse.normal_move.speed = speed
		self.horse.auto_move.speed = speed
	else
		self.normal_move.speed = speed
		self.auto_move.speed = speed
	end
end

function Character:look_at( position )
	if self:is_horse() then
		position.y = self.horse.transform.position.y
		self.horse.transform:LookAt(position)
	else
		position.y = self.transform.position.y
		self.transform:LookAt(position)
	end
end

function Character:start_sit()
	if self.dead or not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
		return
	end

	if self:is_horse() then
		self:start_ride(0)
		return
	end

	if not self.is_can_sit or self.item_obj:is_auto_atk() then
		return
	end

	if not self:is_move() and not self.battle_flag and not self.is_sit then


		self.is_sit = true

		if self.is_self then
			Net:receive(true, ClientProto.StarOrEndSit)
		end
	end
end

function Character:sit()
	self.event_mgr:AddEvent("sit", 0.1, "startSit")
	self.animator:SetBool("sit", true)
	-- self:show_effect("sit")
end

function Character:cancel_sit()
	self.is_sit = false
	
	self:reset_sit_time()
	self.animator:SetBool("sit", false)

	if self.effect_list.sit then
		self.effect_list.sit:hide()
	end

	if self.effect_list.pair_sit then
		self.effect_list.pair_sit:hide()
	end
end

function Character:reset_sit_time()
	if self.is_self then
		self.leisure_time = Net:get_server_time_s() + 60
	end
end

function Character:show_sit_effect( pair )
	if self.effect_list.sit then
		self.effect_list.sit:set_visible(not pair)
	end

	if self.effect_list.pair_sit then
		self.effect_list.pair_sit:set_visible(pair)
	end
	self.is_pair_sit = pair
end

function Character:check_mesh_show()
	-- 判断是否需要显示模型
	local visible = self.is_self or not self.setting_item:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_PLAYER)
	if not self.is_self and visible then
		-- 判断最大同屏玩家数量，如果超过者隐藏
		local num = self.setting_item:get_setting_value(ClientEnum.SETTING.DISPLAY_NUMBER)
		local player_num = gf_table_length(self.item_obj:get_character_list()) - 1
		visible = num>=player_num
		self.show_hero = visible
	end
	self:set_mesh_enable(visible)

	if self.horse then
		self.horse:set_mesh_enable(visible)
	end

	if self.weapon then
		self.weapon:set_mesh_enable(visible)
	end

	if self.wing then
		self.wing:set_mesh_enable(visible)
	end
end

function Character:reset()
	Character._base.reset(self)
	
	self:check_mesh_show()
end

function Character:faraway()
	self.item_obj:hide_select(self.guid)
	self:stop_move()
	self:set_move_forward(false)
	if self.horse then
		self.item_obj.pool:add_horse(self.horse)
		self.horse = nil
		self._is_horse = false
		self.animator:SetBool("ride_idle", false)
	end
	self.animator:Play("EmptyState", 0)
	self.animator:Play("EmptyState", 1)
	self.animator:SetBool("ui_idle", false)
	self.animator:SetBool("move", false)

	if self.hero then
		self.item_obj:remove_model(self.hero.guid)
		self.hero = nil
	end

	if self.effect_list.skill1 then
		self.effect_list.skill1:hide()
	end

	if self.effect_list.skill2 then
		self.effect_list.skill2:hide()
	end

	if self.effect_list.skill3 then
		self.effect_list.skill3:hide()
	end

	if self.effect_list.skill4 then
		self.effect_list.skill4:hide()
	end

	if self.effect_list.skill5 then
		self.effect_list.skill5:hide()
	end

	Character._base.faraway(self)
end

function Character:start_ride(ride, show_tips)
	-- print("上坐骑",LuaItemManager:get_item_obejct("guide"):get_big_step(),self.item_obj:get_map_permissions(ServerEnum.MAP_FLAG.FORBID_RIDE))
	if self.dead or not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
		return
	end
	if self:is_horse() then
		if self.horse.auto_move:IsTouchMove() then
			return
		end
	else
		if self.auto_move:IsTouchMove() then -- 点击移动，不让上下坐骑
			return
		end
	end
	if ride == 1 then
		if self.battle_flag then
			if show_tips then
				gf_message_tips(gf_localize_string("战斗状态中不能上坐骑"))
			end
			return
		end

		if self.item_obj:get_map_permissions(ServerEnum.MAP_FLAG.FORBID_RIDE) then -- 此地图不允许上坐骑
			if show_tips then
				gf_message_tips(gf_localize_string("此地图不允许上坐骑"))
			end
			return
		end

		if  LuaItemManager:get_item_obejct("husong"):is_husong() then
			if show_tips then
				gf_message_tips(gf_localize_string("护送中不能上坐骑"))
			end
			return
		end

		if self.is_sit then
			LuaItemManager:get_item_obejct("sit"):end_rest_c2s()
			return
		end

		if not self.animator:GetCurrentAnimatorStateInfo (1):IsName ("EmptyState") then -- 如果AtkLayer不在空状态，不可以上坐骑
			return
		end
	end

	if (not self:is_horse() and ride == 1) or (self:is_horse() and ride == 0) then
		if ride == 1 then
			self:enable_touch_move(false) -- 上坐骑，停止鼠标点击移动
		end
		--如果不在坐骑指引状态下才请求坐骑
		print("wtf  guild state :",LuaItemManager:get_item_obejct("guide"):get_big_step())
		if LuaItemManager:get_item_obejct("guide"):get_big_step() >= 5 or LuaItemManager:get_item_obejct("guide"):get_big_step() == 0 then
			--[[if ride == 0 then
				self._is_horse = false
			end]]
		-- if
			LuaItemManager:get_item_obejct("horse"):send_to_ride(ride)
		end
	end
end

function Character:set_position( pos )
	self.position = pos or UnityEngine.Vector3.zero
	if not self.is_init then
		return
	end

	if self:is_horse() then
		self.horse.transform.position = self.position
	else
		self.transform.position = self.position
	end
end

function Character:set_local_euler_angles( angles )
	if self:is_horse() then
		self.horse.transform.localEulerAngles = angles
	else
		self.transform.localEulerAngles = angles
	end
end

function Character:get_estination_pos()
	return self._destination_pos
end

function Character:get_min_distance()
	if self:is_horse() then
		return self.horse.auto_move.minDistance
	else
		return self.auto_move.minDistance
	end
end
--[[
pos:目的坐标
end_fn:到达回调
min_distance:距离目标多远停下
force:强制移动
is_path:是否返回路径
]]
function Character:move_to( pos, end_fn, min_distance, force, horse)
	print("Character:move_to",pos)
	min_distance = min_distance or self.atk_range
	force = force or false
	horse = horse == nil and true or horse
	
	self._destination_pos = pos

	if self.is_self 		and 
	   self.is_use_joystick and -- 真正使用摇杆，不能自动寻路
	   not force 			then 
		return false
	end

	if not self.is_init 	or 
	   not self.auto_move 	or 
	   not pos 				then
		return false
	end

	if self.is_self and horse then
		if Seven.PublicFun.GetDistanceSquare(pos, self.transform.position) >= 100 then
			self:start_ride(1)
			self:reset_sit_time()
			Net:receive(is_horse, ClientProto.PlayerAutoMove)
		end
	end

	self.attack_mgr:StopMove()
	self.auto_move_end_fn = end_fn

	if self:is_horse() then
		self.horse.auto_move.minDistance = min_distance
		return self.horse.auto_move:SetDestination3(pos, force)
	else
		self.auto_move.minDistance = min_distance
		return self.auto_move:SetDestination3(pos, force)
	end

	return false
end

function Character:task_move( pos, end_fn, min_distance, force )
	print("Character:task_move",pos)
	min_distance = min_distance or self.atk_range
	force = force or false

	self._destination_pos = pos

	if self.is_self 		and 
	   self.is_use_joystick and -- 真正使用摇杆，不能自动寻路
	   not force 			then 
		return false
	end

	if not self.is_init 	or 
	   not self.auto_move 	or 
	   not pos 				then
		return false
	end

	if self.is_self then
		if Seven.PublicFun.GetDistanceSquare(pos, self.transform.position) >= 100 then -- 大于10，才上坐骑
			self:start_ride(1)
			self:reset_sit_time()
			Net:receive(is_horse, ClientProto.PlayerAutoMove)
		end
	end

	self:stop_follow()
	self.attack_mgr:StopMove()
	self.auto_move_end_fn = end_fn

	if self:is_horse() then
		self.horse.auto_move.minDistance = min_distance
		return self.horse.auto_move:SetDestination(pos, force, true)
	else
		self.auto_move.minDistance = min_distance
		return self.auto_move:SetDestination(pos, force, true)
	end

	return false
end

--[[
直线移动
]]
function Character:move_to2( pos, cb, dis, ani )
	dis = dis or self.atk_range
	ani = ani or ""

	self:reset_sit_time()
	if not pos 				or 
	   not self.is_init 	or 
	   not self.normal_move then
		return false
	end

	if self:is_horse() then
		return self.horse.normal_move:MoveTo(pos, cb, dis, ani)
	else
		return self.normal_move:MoveTo(pos, cb, dis, ani)
	end

	return false
end

-- 设置向前移动
function Character:set_move_forward( flag )
	if not self.is_init then
		return
	end

	if self:is_horse() then
		self.horse.auto_move:StopMove(true)
		self.horse.normal_move:SetMoveForward(flag)
		if flag then
			self.normal_move.charCtr.radius = 0.1
		else
			self.normal_move.charCtr.radius = 1
		end
	else
		if self.cancel_sit then
			self:cancel_sit()
		end
		self.auto_move:StopMove(true)
		self.normal_move:SetMoveForward(flag)
	end
end

-- 停止自动寻路
function Character:stop_auto_move( stop_ani )
	stop_ani = stop_ani == nil and true or stop_ani
	if self:is_horse() then
		self.horse.auto_move:StopMove(stop_ani)
	else
		self.auto_move:StopMove(stop_ani)
	end
	-- 通知隐藏自动寻路ui特效
	Net:receive({visible = false}, ClientProto.ShowMainUIAutoPath)
end

function Character:stop_move()
	if self:is_horse() then
		self.horse.auto_move:StopMove(true)
		self.horse.normal_move:StopMove()
	else
		if self.auto_move then
			self.auto_move:StopMove(true)
		end
		if self.normal_move then
			self.normal_move:StopMove()
		end
	end
end

-- 是否真正移动
function Character:is_move()
	if not self.is_init then
		return false
	end

	if self:is_horse() then
		return self.horse.normal_move:IsMove() 		or 
			   self.horse.auto_move:IsAutoMove() 	or 
			   self.horse.attack_mgr:IsMove()
	else
		return self.normal_move:IsMove() 	or 
			   self.auto_move:IsAutoMove() 	or 
			   self.attack_mgr:IsMove()
	end

	return false
end

function Character:is_auto_move()
	if self:is_horse() then
		return self.horse.auto_move:IsAutoMove()
	else
		return self.auto_move:IsAutoMove()
	end
end

-- 是否有坐骑
function Character:is_horse()
	return self._is_horse
end

function Character:set_is_horse( horse )
	self._is_horse = horse
	self.horse = nil
end

-- 更换材质球贴图
function Character:change_material_img( img_name )
	if not img_name then
		return
	end
	self.material_img = img_name

	if not self:is_loaded() then
		return
	end
	
	if not self.material then
		local render = LuaHelper.GetComponentInChildren(self.root, "UnityEngine.Renderer")
		self.material = render.material
	end
	gf_change_material_img(self.material, img_name)
end

-- 鼠标点击移动
function Character:enable_touch_move( enable )
	if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
		return
	end

	if enable then
		self.auto_move.touchMoveFn = handler(self, self.on_touch_move)
		-- 延迟1秒设置
		local delay_fn = function()
			self.auto_move:EnableTouchMove(true)
		end
		delay(delay_fn, 1)
	else
		self.auto_move:EnableTouchMove(false)
		self.auto_move.touchMoveFn = nil
		print("取消鼠标点击")
	end
end

-- 是否有能量珠
function Character:is_have_energy()
	return self.blood_line:is_have_energy()
end

-----------------------------------------------------------------------------------------------------------------
----------------------------------------跟随相关------------------------------------------------------------------

-- 初始化跟随
function Character:init_follow()
	if not self.follow_move then
		if self:is_horse() then
			self:change_follow(self.horse)
		else
			self:change_follow(self)
		end
	end
end

function Character:change_follow( ower )
	print("设置跟随",ower.root)
	local temp_follow_move = self.follow_move

	self.follow_move = ower.root:AddComponent("Seven.Move.FollowMove")
	self.follow_move.speed = ower.speed
	self.follow_move:SetFollowDistance(ConfigMgr:get_const("team_follow_d"))
	self.follow_move:SetStopDistance(ConfigMgr:get_const("team_follow_stop_d"))
	self.follow_move.stopMoveFn = handler(self, self.on_follow_move_stop)
	self.follow_move.starMoveFn = handler(self, self.on_follow_move_start)

	local leader = LuaItemManager:get_item_obejct("team"):get_leader()
	if leader and leader:is_horse() then
		self:set_follow_target(leader.horse)
	else
		self:set_follow_target(leader)
	end

	if temp_follow_move then
		self.follow_move:SetFollow(temp_follow_move:IsFollow())
		temp_follow_move:SetTarget(nil)
		LuaHelper.Destroy(temp_follow_move)
	end
end

-- 设置跟随
function Character:set_follow( follow )
	if not self.is_self then
		return
	end
	self.is_follow = follow
	self:init_follow()
	self.follow_move:SetFollow(follow)
	self.camera_follow:SetTeamFollow(follow)

	if follow then
		Net:receive(false, ClientProto.StarOrEndSit) -- 取消打坐
	end

	if self.hero then
		self.hero:set_target_follow_move(follow)
	end
end

-- 设置跟随目标
function Character:set_follow_target( target )
	self:init_follow()
	self.follow_target = target
	if target then
		self.follow_move:SetTarget(target.root)
		
	else
		self.follow_move:SetTarget(nil)
	end
end

-- 停止跟随
function Character:stop_follow()
	if self.is_follow then
		self.is_stop_follow = true
		self.check_follow_time = ConfigMgr:get_const("team_refollow_t") -- 手动操作后多久恢复跟随
		self.follow_move:SetFollow(false)
	end
end

-- 是否要把移动同步给服务器
function Character:is_team_move_notice()
	return self.is_follow and not self.is_stop_follow and self:is_follow_move()
end

function Character:is_follow_move()
	if self.is_follow then
		return self.follow_move:IsMove()
	end
	return false
end

-- 是否是队长攻击（如果是跟随状态，跟随队长攻击）
function Character:is_leader_atk(atker, target)
	if self.follow_target == atker then
		self:set_target(target)
		self:play_auto_atk()
	end
end

-- 检查是否需要恢复跟随
function Character:check_follow(dt)
	if self.is_follow and self.is_stop_follow then
		if self:is_move() then
			return
		end

		self.check_follow_time = self.check_follow_time - dt
		if self.check_follow_time <= 0 then
			self.is_stop_follow = false
			local item = LuaItemManager:get_item_obejct("team")
			if item:is_in_team() then
				gf_message_tips(gf_localize_string("跟随队长"))
				local leader = item:get_leader()
				if not leader then -- 队长不在可视范围，请求队长位置
					if not self.is_send_get_leader_pos then
						self.is_send_get_leader_pos = true
						item:leader_position_req_c2s()
					end
				else
					if leader:is_horse() then
						leader = leader.horse
					end
					self:set_follow_target(leader)
					if self:check_in_atk_range(leader, ConfigMgr:get_const("team_follow_d")^2) then
						self:set_follow(true)
					else
						local end_cb = function()
							self:set_follow(true)
						end
						self:move_to(leader.transform.position, end_cb, ConfigMgr:get_const("team_follow_d"))
					end
				end
			else
				self.is_stop_follow = false
				self:set_follow(false)
				self:set_follow_target(nil)
			end
		end
	end
end

---------------------------------------------------------------------------------------------------------
------------------------------------------------private--------------------------------------------------
---------------------------------------------------------------------------------------------------------
function Character:pre_init()
	Character._base.pre_init(self)

	-- 是否可以传送
	self.can_transport = false
	self.effect_list = {} -- 技能列表

	-- pk 模式
	self.pk_mode = ServerEnum.PK_MODE.PEACE
	self.is_player = true

	-- 选中目标（手动选中）
	self.select_target = nil 

	self.is_can_sit = false

	self.xp_per = 0
	self.is_use_joystick = false -- 是否真正使用摇杆

	self._is_horse = false -- 是否有坐骑

	self.auto_hand_time = 0 -- 记录自动寻路时，点击攻击按钮的时间
	self:reset_hand_time()
	self.leisure_time = Net:get_server_time_s() + 60 -- 空闲时间 用来判断是否需要打坐（1分钟后打坐
end

function Character:init()
	self:change_material_img(self.material_img)

	self.normal_move.joystickStartFn = handler(self, self.joystick_start)
	-- self.normal_move.joystickMoveFn = handler(self, self.joystick_move)
	self.normal_move.joystickMoveEndFn = handler(self, self.joystick_move_end)
	self.auto_move.pathCallbackFn = handler(self, self.path_callback)
	self.normal_move.aniChangeFn = handler(self, self.on_ani_change)
	self.auto_move.aniChangeFn = handler(self, self.on_ani_change)

	self.max_search_range = self.config_data.max_search_range*0.1 or 15 -- 最大搜索范围
	self.min_search_range = self.config_data.min_search_range*0.1 or 5 -- 最小搜索范围

	self.is_auto_attack = false -- 是否是自动攻击
	self.is_once = false -- 自动攻击一个目标，直到目标死亡
	self.auto_atk_cmd = {"atk", "skill1", "skill2", "skill3", "skill4", "skill5"} -- 自动攻击命令列表

	self.item_obj = LuaItemManager:get_item_obejct("battle") -- 战斗数据类
	self.skill_item = LuaItemManager:get_item_obejct("skill")
	self.setting_item = LuaItemManager:get_item_obejct("setting")

	self.path = nil -- 玩家行走路径

	self.sound_list = 
	{
		dead = "dead_11"..self.config_data.career.."101",
		hit = nil,
		atk1 = "atk_11"..self.config_data.career.."101_1",
		atk2 = "atk_11"..self.config_data.career.."101_2",
		atk3 = "atk_11"..self.config_data.career.."101_3",
		skill1 = "skill_11"..self.config_data.career.."101_1",
		skill2 = "skill_11"..self.config_data.career.."101_2",
		skill3 = "skill_11"..self.config_data.career.."101_3",
		skill4 = "skill_11"..self.config_data.career.."101_4",
		skill5 = "xp_11"..self.config_data.career.."101_2",
		xp = "xp_11"..self.config_data.career.."101_1",
	}
	if self.wing ~= nil then
		self.wing:set_player(self)
	end
	if self.weapon ~= nil then
		self.weapon:set_player(self)
	end
	if self.is_in_pool == true then
		self.transform.parent = Character
		LuaHelper.SetLayerToAllChild(self.transform, ClientEnum.Layer.CHARACTER)
	end
	self.recover_hp = 0
end

function Character:init_atk_mgr_param()

	local skill_list = ClientEnum.SKILL_ID_LIST[self.config_data.career]
	for i,v in pairs(skill_list or {}) do
		local data
		if i < ServerEnum.SKILL_POS.NORMAL_1 then
			data = ConfigMgr:get_config("atk_move_distance")[math.floor(v*0.001)] -- 如果不是普攻，技能id去掉后面等级3位
		else
			data = ConfigMgr:get_config("atk_move_distance")[v] -- 普攻
		end
		local cmd = SkillCMD[i]
		if data then
			self.attack_mgr:AddAtkMoveTime(cmd, data.time)
			self.attack_mgr:AddAtkMoveDistance(cmd, data.atk_move_distance)
			self.attack_mgr:AddAtkMoveSpeed(cmd, data.speed)
		end
	end

	self.attack_mgr.exitTime1 = ConfigMgr:get_config("animator")[self.config_data.career].exit_time_1*0.01
	self.attack_mgr.exitTime2 = ConfigMgr:get_config("animator")[self.config_data.career].exit_time_2*0.01
	self.attack_mgr.exitTime2 = ConfigMgr:get_config("animator")[self.config_data.career].exit_time_3*0.01
	self.attack_mgr.connectTime = ConfigMgr:get_const("ani_connect_t")
end

-- 重设手动时间(如果自动攻击，手动时间停止1秒后开始自动攻击)
function Character:reset_hand_time()
	self.hand_time = Net:get_server_time_s() + 1
end

-- 重新刷新血条位置TODO有问题，暂时屏蔽
function Character:reset_blood_line()
	-- self.head_node.transform.position = LuaHelper.FindChild(self.root, "head").transform.position
	-- self.head_node.transform.position.y = self.head_node.transform.position.y + 3
	-- self.blood_line:set_update(true)
	-- self.blood_line:refresh_hp(true)
	-- self.blood_line:set_update(false)
end

-- 添加特效
function Character:init_effect()
	local key_list = {"skill1","skill2","skill3","skill4","skill5","atk1","atk2","atk3"}
	local career = self.config_data.career

	for i,v in ipairs(ClientEnum.SKILL_ID_LIST[career]) do
		local effect = ModelEffect(v, self)
		self:add_effect(effect, key_list[i])
		-- 技能是否可以跟随移动
		if effect:is_follow() then
			self.normal_move:AddSkill(key_list[i])
		end
	end
end

function Character:get_effect_list()
	return self.effect_list
end

function Character:add_effect( effect, key )
	self.effect_list[key] = effect
end

function Character:show_effect( key, cb )
	local effect = self.effect_list[key]
	
	if effect then
		if key == "xp" then
			effect:set_finish_cb(handler(self, self.xp_finish_cb))
			self.item_obj:stop_ai_updata_c2s(effect:get_hide_time()*1000)
			effect:show_effect()
			self.blood_line:set_update(false)
		else
			effect:show_effect(key)
		end
		-- if key == "xp"
		-- 	or key == "atk1"
		-- 	or key == "atk2"
		-- 	or key == "atk3"
		-- 	or key == "skill1"
		-- 	or key == "skill2"
		-- 	or key == "skill3"
		-- 	or key == "skill4"
		-- 	or key == "skill5" then
		-- 	print("技能",key)
		-- 	-- Sound:play_fx(ConfigMgr:get_config("skill")[effect.config_data.code].music,false,self.root)
		-- else
		-- 	print("其他",key)
		-- end
	end
end

function Character:show_fly_effect( cmd )
	local effect = self.effect_list[CMD[cmd]]
	if effect then
		effect:show_fly_effect()
	end
end

-- 初始化帧事件
function Character:init_ani_event()
	local key = {
		['atk1'] = "NORMAL_1",
		['atk2'] = "NORMAL_2",
		['atk3'] = "NORMAL_3",
		['skill1'] = "ONE",
		['skill2'] = "TWO",
		['skill3'] = "THREE",
		['skill4'] = "FOUR",
	}
	for k,v in pairs(self.effect_list or {}) do
		self.event_mgr:AddEvent(k, v:get_atk_percent(), key[k])
		self.event_mgr:AddEvent(k, 0.01, k)
	end

	if self.effect_list.skill5 then
		self.event_mgr:AddEvent("skill5", self.effect_list.skill5:get_atk_percent(), "XP")
	end

	self.event_mgr:AddEvent("dead", 0.90, "dead")

	-- 播放特效
	self.event_mgr:AddEvent("xp", 0.01, "xp")
	self.event_mgr:AddEvent("skill5", 0.01, "skill5")
	self.event_mgr:AddEvent("forward", 0.01, "forward")
end

--死亡界面展示和处理
function Character:dead_view_show()
	if not self.is_self then
		return
	end
	--通知角色死亡
	gf_receive_client_prot({},ClientProto.PlayerDie)

	--3v3竞技场没有复活界面
	if gf_getItemObject("copy"):is_pvptvt() then
		require("models.pvp3v3.relive")()
		return
	end
	if gf_getItemObject("copy"):is_challenge() or gf_getItemObject("copy"):is_pvp() then
		require("models.copy.challengeDefault")()
		return
	end
	if LuaItemManager:get_item_obejct("copy"):is_copy_type(ServerEnum.COPY_TYPE.SMALL_GAME) then
		-- LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()
		require("models.pvp3v3.relive")()
		return
	end
	if LuaItemManager:get_item_obejct("setting"):get_setting_value(ClientEnum.SETTING.REVIVE) then
		if LuaItemManager:get_item_obejct("bag"):get_item_count(40070301,ServerEnum.BAG_TYPE.NORMAL) ~= 0 then
			LuaItemManager:get_item_obejct("fuhuo"):thispoint()
			print("复活自动")
			gf_message_tips("已自动使用<color="..gf_get_color_by_item(40070301)..">回魂丹</color>原地恢复")
			return
		end
	end
	print("复活界面打开")
	LuaItemManager:get_item_obejct("fuhuo"):open_fuhuo_view()
end

--------------------------------------------------------------------------------------------------
---------------------------------攻击相关-------------------------------------------------------------
--------------------------------------------------------------------------------------------------

function Character:hurt( dmg, result )
	self._base.hurt(self, dmg, result)
	self:set_hp_visible(self.hp_percent<1)

	if self.is_self then
		Net:receive({player_hp = self.hp_percent}, ClientProto.PlayerBlood)
		Net:receive(nil, ClientProto.PlayerSelfBeAttacked)
		-- 被攻击下马
		if self:is_horse() then
			self:start_ride(0)
		end
	end

end

function Character:is_target_dead(target)
	if not target or target.dead or target.is_faraway then
		self:set_target(nil)
		return true
	end
	return false
end

function Character:init_atk(find_taget, range)
	
	-- 真正移动
	if self:is_move() then
		-- print("玩家正在移动！")
		return ClientEnum.MODEL_STATE.MOVING
	end

	if self.select_target then
		local select_range = ConfigMgr:get_const("select_lose_r_"..self.config_data.career)^2 -- 选中失效距离
		if not self:is_target_dead(self.select_target) and self:check_in_atk_range(self.select_target, select_range) then
			self:set_target(self.select_target)
		else
			if self.select_target then
				self.item_obj:hide_select(self.select_target.guid)
			end
			self.select_target = nil
			self:set_target(nil)
		end
	end
	
	if self:is_target_dead(self.target) then -- 没有攻击目标
		if find_taget then
			self:set_target(self:get_target())
			if self:is_target_dead(self.target) then
				return ClientEnum.MODEL_STATE.NO_TARGET
			else
				self._send_auto_atk_msg = false

				self.target:set_target(self)
				self.item_obj:show_select(self.target.guid)
			end
		else
			return ClientEnum.MODEL_STATE.NO_TARGET
		end
	end

	local effect = self.effect_list[self.cur_atk_cmd]
	range = range + (self.target.config_data.vluame_r or 0)*0.1 -- 攻击范围加上怪物体积半径
	print("攻击距离",range,self.target.config_data.vluame_r)
	if not self:is_move() and not self:check_in_atk_range(self.target, range^2) then
		--移动到攻击目标
		-- print("移动到攻击目标",effect:is_forward())
		if effect and effect:is_forward() then
			effect:show_forward()
		else
			self.is_move_to_target = self:move_to(self.target.transform.position, handler(self, self.arrive_destination_callback), range, false, false)
		end

		return ClientEnum.MODEL_STATE.MOVE_TO_TARGET
	end

	if effect and effect:is_forward() then
		effect:show_forward_effect()
		return ClientEnum.MODEL_STATE.MOVE_TO_TARGET
	end

	if self.target then
		local pos = self.target:get_position()
		pos.y = self.transform.position.y
		self.transform:LookAt(pos)
		-- 如果是怪物，显示显示血条
		if self.target.is_monster then
			self.target:show_blood(true)
		end
	end

	return ClientEnum.MODEL_STATE.ATK
end

-- 播放攻击动作(玩家自己)
function Character:play_atk( cmd )
	if self.is_dizzy then
		return false
	end

	self.is_use_joystick = false

	Net:receive(nil, ClientProto.PlayerSelfAttack)
	self:reset_sit_time()

	-- 只要发生攻击动作，就下坐骑
	if self:is_horse() and self.is_self then
		self:start_ride(0)
	end

	self.cur_atk_cmd = cmd
	local state = ClientEnum.MODEL_STATE.NONE
	local atk = false

	print("手动选中目标",self.select_target)
	local skill_data
	if cmd == "atk" then
		skill_data = self.skill_item:get_data_by_index(ServerEnum.SKILL_POS.NORMAL_1)
	else
		skill_data = self.skill_item:get_data_by_cmd(cmd)
	end

	if skill_data then
		if (self.is_auto_attack and Net:get_server_time_s() > self.hand_time) or self.select_target then -- 自动攻击自动寻找目标,或者有选中目标
			state = self:init_atk(true, skill_data.cast_distance*0.1)
		else
			local skill_target_ty = skill_data.target_select -- 技能选择目标类型
			print("技能类型",skill_target_ty)
			if skill_target_ty == ServerEnum.SKILL_TARGET_SELECT.TARGET then -- 指定目标，要选择目标才可以播放
				state = self:init_atk(false, skill_data.cast_distance*0.1)

			elseif skill_target_ty == ServerEnum.SKILL_TARGET_SELECT.SELF_POS then -- 以自我为中心,立即播放，不用寻找目标
				atk = true
				self._send_auto_atk_msg = false
				self:stop_move()
				
			elseif skill_target_ty == ServerEnum.SKILL_TARGET_SELECT.AUTO_SELECT then -- 自动寻找目标，15米范围内可以找目标，则寻路过去，否则空放
				state = self:init_atk(true, skill_data.cast_distance*0.1)
				if state == ClientEnum.MODEL_STATE.NO_TARGET then -- 找不到目标空放
					atk = true
					self._send_auto_atk_msg = false
					self:stop_move()
				end
			end
		end
	else
		gf_error_tips("找不到技能数据",cmd)
		atk = true
	end

	if state == ClientEnum.MODEL_STATE.NO_TARGET then
		if not self.is_auto_attack then
			atk = true
		else
			if not atk and self.item_obj:is_auto_atk() and not self._send_auto_atk_msg then
				self._send_auto_atk_msg = true
				print("向服务器请求挂机点")
				gf_auto_atk(true)
			end
		end
	end
	
	if state == ClientEnum.MODEL_STATE.ATK then
		atk = true
	end
	print("攻击",atk,cmd,state)
	if atk == true then
		if cmd == "skill5" and self.xp_per > 0 and math.random(0,100) <= self.xp_per then -- 转镜头
			self.cur_atk_cmd = "xp"
			self.animator:Play("xp", 1)
		else
			self.attack_mgr:PlayAttack(cmd)
		end
	end

	return atk
end

function Character:play_auto_atk()
	if self:is_move() or self.dead or self.is_use_joystick then
		return
	end

	if Net:get_server_time_s() < self.hand_time then -- 手动操作，停止1s后再自动挂机
		return
	end
	
	if self.cur_atk_cmd == "xp" then -- 如果在播放转镜，停止自动攻击
		return
	end

	local cmd

	if not cmd then
		if self.is_once then -- 手动选中自动攻击，一直用普攻攻击
			cmd = "atk"
		else
			local cmd_list = {}
			for i,v in ipairs(self.auto_atk_cmd) do
				if LuaItemManager:get_item_obejct("skill"):is_skill_can_use(v) then -- 空闲的技能
					cmd_list[v] = v
				end
			end
			cmd = cmd_list["skill1"]
			if not cmd then
				cmd = cmd_list["skill2"]
			end
			if not cmd then
				cmd = cmd_list["skill3"]
			end
			if not cmd then
				cmd = cmd_list["skill4"]
			end
		end
		
		if not cmd then
			cmd = "atk"
		end
	end

	self.cur_atk_cmd = nil
	self:play_atk(cmd)
end

-- 播放其他玩家攻击
function Character:play_atk_other( target, cmd )
	-- print("其他玩家攻击",target.guid,cmd)
	self:set_target(target)
	if target then
		self.transform:LookAt(target.transform)
	end
	self.attack_mgr:PlayAttack(cmd)
end

-- 选中普攻攻击目标(选中在攻击范围内的目标)
function Character:init_normal_target(cmd)
	if (self.is_auto_attack and Net:get_server_time_s() > self.hand_time) or self.select_target then -- 自动攻击不做处理
		return
	end

	if cmd == "atk1" or cmd == "atk2" or cmd == "atk3" then
		local skill_data = self.skill_item:get_data_by_cmd(cmd)
		local range = skill_data.cast_distance*0.1
		self:set_target(self:get_target())
		if self.target then
			self.transform:LookAt(self.target.transform)
			self.item_obj:show_select(self.target.guid)
		end
	end
end

-- 检查攻击目标是否在攻击范围内，不在移动到攻击范围
function Character:check_in_atk_range( target, range )
	if not target then
		return true
	end
	
	range = range or self.atk_range_d
	local distance = Seven.PublicFun.GetDistanceSquare(self.transform, target.transform)-0.5
	print("检查是否在攻击范围",distance,range)
	if distance > range then -- 移动到攻击范围内
		return false
	end

	return true
end

-- 获取攻击目标, 如果monster_id不为空，那寻找最近的monster_id怪物
function Character:get_target(monster_id)
	return self.item_obj:get_target(monster_id, nil, self.is_auto_attack)
end

-- 设置战斗状态
function Character:set_battle_flag( flag, not_show_tips )
	Character._base.set_battle_flag(self, flag)
	if self.play_state then
		self.play_state:SetOpen(not flag)
	end

	if self.hero then
		if flag then
			self.hero:start_atk()
		else
			self.hero:stop_atk()
		end
	end

	if not LuaItemManager:get_item_obejct("firstWar"):is_pass() then
		return
	end

	if not_show_tips then
		return
	end

	if flag then
		LuaItemManager:get_item_obejct("floatTextSys"):in_battle_flag()
	else
		LuaItemManager:get_item_obejct("floatTextSys"):out_battle_flag()
	end
end


function Character:set_target( target )
	-- print("设置攻击目标1",target)
	self.target = target
end



--------------------------------------------------------------------------------------------------
---------------------------------更新-------------------------------------------------------------
--------------------------------------------------------------------------------------------------

function Character:on_auto_atk_update( dt )
	if not self.target or self.target:is_dead() then
		if self.is_once and not self.item_obj:is_auto_atk() then
			self:set_auto_attack(false)
		end
		self.is_once = false
	end

	-- 是否是自动攻击
	if self.is_auto_attack then
		self:play_auto_atk()
	end
end

function Character:update_sit( dt )
	if not self.is_self then
		return
	end

	if self.is_sit or self:is_follow_move() then
		return
	end

	if self.is_can_sit and not self:is_horse() then
		if Net:get_server_time_s() >= self.leisure_time then
			self:start_sit()
		end
	end
end

function Character:on_update( dt )
	self:on_auto_atk_update(dt)
	self:update_shake(dt)

	self:update_sit(dt)
	self:check_follow(dt)
end

function Character:check_battle_effect( cmd )
	local skill_data = self.skill_item:get_data_by_cmd(cmd)
	if not skill_data then
		return
	end
	local skill_id = skill_data.code

	-- 检查是否需要震屏
	local show_shake = not self.setting_item:get_setting_value(ClientEnum.SETTING.SHAKE_OFF)
	-- print("检查是否需要震屏", show_shake)
	if show_shake then
		local data = ConfigMgr:get_config("shake")[skill_id]
		if data then
			self.shake_data = data
			self.shake_time = (data.late_time or 0)*0.001
			self.is_shake = true
			if self.shake_time == 0 then
				self.item_obj:shake_screen(data.dir[1],data.dir[2],data.dir[3],data.time*0.001)
				self.is_shake = false
			end
		end
	end

	-- 检查是否需要缩放镜头
	data = ConfigMgr:get_config("camera_scale")[skill_id]
	if data then
		self.camera_follow:SetCameraScale(
			data.scale_time*0.001,
			data.stop_time*0.001,
			data.resume_time*0.001,
			data.late_time*0.001,
			data.distance
		)
	end
end

function Character:update_shake(dt)
	if not self.is_shake then
		return
	end

	if self.shake_time > 0 then
		self.shake_time = self.shake_time - dt
		if self.shake_time <= 0 then
			self.is_shake = false
			self.item_obj:shake_screen(self.shake_data.dir[1],self.shake_data.dir[2],self.shake_data.dir[3],self.shake_data.time*0.001)
		end
	end
end

-- 清除攻击目标
function Character:clear_target(force)
	if self.is_clear_target and not force then
		return
	end
	self.is_clear_target = true
	self.normal_move.speed = self.speed
	self:reset_sit_time()
	self.is_move_to_target = false -- 清除正在移动过去的标志
	self:set_target(nil)
	self._send_auto_atk_msg = false

	if self.is_once and not self.item_obj:is_auto_atk() then
		self:set_auto_attack(false)
	end
	self.is_once = false
end




-----------------------------------回调函数---------------------------------------
-- 动画帧事件回调
function Character:ani_event_callback( arg )
	self._base.ani_event_callback(self, arg)
	
	if arg == "dead" then -- 死亡动画播放完成动画
		-- self:hide()
		-- self.animator.speed = 0 -- 停止动画

		-- self:dead_view_show()

		return
	end


	if self.is_self then
		-- 加入技播放能列表
		-- self.skill_item:add_play_skill(arg)
		-- 检查是否有需要震屏，缩放
		self:check_battle_effect(arg)

		self:init_normal_target(arg)
	end

	local show_effect = self:is_mesh_enable()
	if not self.is_self and show_effect then
		show_effect = not self.setting_item:get_setting_value(ClientEnum.SETTING.SHIELD_OTHER_EFFECTS)
	end

	-- 播放特效
	if show_effect then
		self:show_effect(arg)
	end


	print(">>>Character:动画帧事件回调:",arg)
	-- 处理伤血
	if arg == "ONE" or 
	   arg == "TWO" or 
	   arg == "THREE" or
	   arg == "FOUR" or
	   arg == "XP" or
	   arg == "NORMAL_1" or 
	   arg == "NORMAL_2" or
	   arg == "NORMAL_3" then

	   	if show_effect then
		   	self:show_fly_effect(arg)
	    end

	    if not self.is_self then
			return
		end

		local t_guid
		if self.target then
			t_guid = self.target.guid
		end
	 
		self.item_obj:skill_cast_c2s(
			LuaItemManager:get_item_obejct("skill"):get_skill_id(ClientEnum.SKILL_POS[arg]), 
			self.transform.position.x, 
			self.transform.position.z,
			self.transform.localEulerAngles.y,
			t_guid,
			self.guid
		)

	elseif arg == "ride_idle" then
		self.event_mgr:RemoveEvent("ride_idle", "ride_idle")
		self:reset_blood_line()

	elseif arg == "atkidle" then
		self.event_mgr:RemoveEvent(arg, arg)
		self:reset_blood_line()

	elseif arg == "startSit" then
		self.event_mgr:RemoveEvent("sit", arg)
		self:reset_blood_line()

	end

end

-- 寻路路径返回
function Character:path_callback( path )
	if self:is_horse() then
		self.animator:SetBool("move", true)
	end

	self.path = path
end

-- 玩家到达目的地回调
function Character:arrive_destination_callback()
	print("-----sb----玩家到达目的地回调")
	Character._base.arrive_destination_callback(self)
	self:reset_sit_time()

	if self:is_horse() then
		self.animator:SetBool("move", false)
	end

	if self.is_move_to_target then
		self.is_move_to_target = false
		self:play_atk(self.cur_atk_cmd)
	end
end

-- xp转镜播放完成回调
function Character:xp_finish_cb()
	self.blood_line:set_update(true)
	local delay_cb = function() -- 延时1帧
		self.cur_atk_cmd = "skill5"
	end

	local skill_id = LuaItemManager:get_item_obejct("skill"):get_skill_id(ServerEnum.SKILL_POS.XP)
	local data = ConfigMgr:get_config("xp_back")[skill_id]
	self.animator:Play("skill5", 1, data.per) -- 动作开始播放的百分比
	local effect = self.effect_list["skill5"]
	if effect then
		local dtime = self.event_mgr:GetAniTime("XP2")*data.per
		effect:reset_delay_time(dtime)
		effect:show_effect("skill5")
	end
	-- self.skill_item:add_play_skill("skill5")
	
	delay(delay_cb, 0.034)
end

-- 点击事件
function Character:on_click( obj, arg )
    local cmd= not Seven.PublicFun.IsNull(obj) and obj.name or "nil"
	if cmd == "atk" or cmd == "skill1" or cmd == "skill2"  or cmd == "skill3" or cmd == "skill4" or cmd == "skill5" then -- 普通攻击
        -- Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
        self:stop_follow()
		self:reset_hand_time()

        if not self.is_auto_attack and self:is_auto_move() and not self.auto_move:IsTouchMove() then -- 如果在自动寻路，1.5秒内点击两次，中断移动，播放攻击动作
        	local t = Net:get_server_time_s()
        	if self.auto_hand_time == 0 then
        		self.auto_hand_time = t
        	elseif t - self.auto_hand_time <= 1.5 then -- 两次点击小于1.5s，停止自动寻路，播放攻击
        		self.auto_hand_time = 0
        		self:stop_move()
				Net:receive({visible = false}, ClientProto.ShowMainUIAutoPath) -- 通知隐藏自动寻路ui特效
        		self:play_atk(cmd)
        	else
        		self.auto_hand_time = t
        	end
        else
        	self.auto_hand_time = 0
			self:play_atk(cmd)
        end
	end
end

function Character:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "StartRestR") then -- 开始打坐
			if msg.err == 0 then
				Sound:play(ClientEnum.SOUND_KEY.SIT) -- 下滑打坐或取消打坐时播放的音效
				self.is_sit = true
				self:sit()
			else
				self.is_sit = false
				self:reset_sit_time()
			end

		elseif id2 == Net:get_id2("scene", "EndRestR") then -- 取消打坐
			Sound:play(ClientEnum.SOUND_KEY.SIT) -- 下滑打坐或取消打坐时播放的音效
			self:cancel_sit()
		end

	elseif id1== Net:get_id1("base") then
        if id2 == Net:get_id2("base", "UpdateLvlR") then
        	self.is_can_sit = LuaItemManager:get_item_obejct("sit"):is_can_sit()
        	self:set_level(msg.level)
        elseif id2 == Net:get_id2("base", "UpdateCombatR") then
			local max_hp = msg.combatAttr[ServerEnum.COMBAT_ATTR.HP]
			if max_hp then
				self.max_hp = max_hp
			end
        end

    elseif id1== Net:get_id1("shop") then
        if id2 == Net:get_id2("shop", "UpdateVipLvlR") then
        	self.blood_line:set_vip(msg.vipLevel)

        end

    elseif id1 == Net:get_id1("team") then
    	if id2 == Net:get_id2("team", "LeaderPositionReqR") then
    		self.is_send_get_leader_pos = false
    	end

	elseif id1 == ClientProto.ShowSitEffect then
		self:show_sit_effect(msg)

	elseif id1 == ClientProto.TouchMonster then -- 点击怪物，做技能释放
		if msg.target.is_monster and msg.target:is_collect() then -- 采集怪
			self.item_obj:collect(msg, 1)
			self.select_target = nil
		else
			self.select_target = msg.target
			if msg.auto_atk then
				self:set_target(msg.target)
			end
			self.is_once = msg.auto_atk
			if not self.is_auto_attack then
				self:set_auto_attack(msg.auto_atk)
			end
		end

	elseif id1 == ClientProto.TitleChange then
		self.config_data.title = msg.title_id
		self.blood_line:set_info(self.config_data.name or "", self.config_data.title or "")

	elseif id1 == ClientProto.ShowMainUIAutoAtk then -- 自动挂机
		if msg.visible then
			self:start_ride(0)
		end
	end

	if self.hero then
		self.hero:on_receive(msg, id1, id2, sid)
	end
end

-- 摇杆开始移动
function Character:joystick_start()
	print("开始移动摇杆")
	Net:receive(nil, ClientProto.JoystickStartMove)
	self.is_use_joystick = true
	self.is_clear_target = false

	self:stop_move()
	self:stop_follow()
end

-- 摇杆移动回调
function Character:joystick_move()
	self:clear_target()
end

-- 摇杆停止移动
function Character:joystick_move_end()
	self.is_use_joystick = false
	self.is_move_to_target = false -- 清除正在移动过去的标志
	self.is_clear_target = false

	self:reset_sit_time()
	self:stop_move()

end

-- 模型点击
function Character:on_touch_down()
	print(">>>点击模型")
	-- 显示玩家头像
	LuaItemManager:get_item_obejct("mainui").assets[1]:set_other_player_head_visible(true, self.guid, self.config_data)

	-- 设置选中目标
	if self.item_obj:is_can_atk_player(self) then
		Net:receive({target = self, auto_atk = true}, ClientProto.TouchMonster)
	end

	if not self.is_self then
		self.item_obj:show_select(self.guid)
	end
end

-- 添加碰撞体(只是玩家自己才添加)
function Character:on_collider_hit(hit)
	if hit.gameObject.tag == "Wall" then
	end
end

function Character:on_finger_move_up()
	print("上坐骑")
	self:start_ride(1, true)
end

function Character:on_finger_move_down()
	print("打坐",self:is_horse())

	self:start_sit()
end

-- 动画改变
function Character:on_ani_change( is_move )
	if self:is_horse() then
		self.animator:SetBool("move", is_move or false)
	end

	if self.wing then
		self.wing:on_ani_change(is_move)
	end
end

-- 鼠标点击移动
function Character:on_touch_move( point )
	print("鼠标点击 玩家",point)
	Net:receive(nil, ClientProto.MouseClick)

	if self.mouse_effect then
		self.mouse_effect:set_position(point)
		self.mouse_effect:show_effect()
	end

	self:clear_target(true)
	self:stop_follow()
end

-- 跟随移动停止
function Character:on_follow_move_stop()
	-- if self:is_horse() then
	-- 	self.item_obj:player_stop_move(self.horse)
	-- else
	-- 	self.item_obj:player_stop_move(self)
	-- end
	self:reset_sit_time()
end

-- 开始跟随移动
function Character:on_follow_move_start()
	LuaItemManager:get_item_obejct("sit"):end_rest_c2s()
	self:reset_sit_time()
end

---------------------------------------------------------------------------------

function Character:dispose()
	gf_remove_update(self)

	for k,v in pairs(self.effect_list) do
		v:dispose()
	end
	self.effect_list = {}

	if self.horse then
		self.horse:dispose()
		self.horse = nil
	end
	self._is_horse = false

	if self.hero then
		self.hero:dispose()
		self.hero = nil
	end

	if self.wing then
		self.wing:dispose()
		self.wing = nil
	end

	if self.weapon then
		self.weapon:dispose()
		self.weapon = nil
	end

	if self.surround then
		self.surround:dispose()
		self.surround = nil
	end
	
	self.play_state = nil
	self.camera_follow = nil
	self.touch = nil

	if self.mouse_effect then
		self.mouse_effect:dispose()
	end
	self.mouse_effect = nil

	Character._base.dispose(self)
end

return Character
