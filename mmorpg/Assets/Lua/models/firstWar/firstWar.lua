--[[--
-- 首场战斗
-- @Author:Seven
-- @DateTime:2017-08-14 21:49:21
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Effect = require("common.effect")
local SpriteBase = require("common.spriteBase")
local XPEffect = require("models.battle.obj.xpEffect")

local FirstWar = LuaItemManager:get_item_obejct("firstWar")
FirstWar.priority = 100
FirstWar.forced_click = true

local NodeList = 
{
	[ServerEnum.CAREER.MAGIC]  = "111101",
	[ServerEnum.CAREER.BOWMAN] = "112101",
	[ServerEnum.CAREER.SOLDER] = "114101",
}

local TimeList = 
{
	[ServerEnum.CAREER.MAGIC]  = 8.14,
	[ServerEnum.CAREER.BOWMAN] = 8.06,
	[ServerEnum.CAREER.SOLDER] = 8.14,
}

--点击事件
function FirstWar:on_click(obj,arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	
	if cmd == "skill5" then
		Net:receive(false, ClientProto.ShowXPBtn)
	elseif cmd == "skill1" then
		self.character:enable_joystick(true)
	end

end

--初始化函数只会调用一次
function FirstWar:initialize()
	self.war_data = ConfigMgr:get_config("first_war")
	self.index = 1

	self.guide_item = LuaItemManager:get_item_obejct("guide")
	self.battle_item = LuaItemManager:get_item_obejct("battle")
	self.story_item = LuaItemManager:get_item_obejct("story")

	-- 用来判断是否需要显示资源播放技能
	self.first_pos = nil -- 第一波怪的位置
	self.range_d = 100
	self.time = 0
end

function FirstWar:is_pass()
	return self.guide_item:get_big_step() >= 1
end

function FirstWar:init_xp(cb)
	-- cb()

	if self:is_pass() then
		cb()
		return
	end
	local career = LuaItemManager:get_item_obejct("game"):get_career()
	local effect_cb = function(effect)
		effect:set_local_position(Vector3(30.5,25.35,-47.96))
		cb()
	end
	self.xp = XPEffect({effect = NodeList[career].."@jump"}, effect_cb)
end

function FirstWar:init_wave_monster_num()
	local config_table = ConfigMgr:get_config("map.mapMonsters")
	local map_id = self.battle_item.map_id
	
	local list = config_table[map_id][ServerEnum.MAP_OBJECT_TYPE.CREATURE]

	self.wave_1_num = 0
	self.wave_2_num = 0
	self.wave_3_num = 0

	for i,v in ipairs(list or {}) do
		if v.wave == 1 then
			self.monster_id_1 = v.code
			self.wave_1_num = self.wave_1_num + 1
		elseif v.wave == 2 then
			self.monster_id_2 = v.code
			self.wave_2_num = self.wave_2_num + 1
		elseif v.wave == 3 then
			self.monster_id_3 = v.code
			self.wave_3_num = self.wave_3_num + 1
		end
	end
	self.dead_num = 0
end

function FirstWar:init_transform()
	self.monster_t = LuaHelper.Find("Monster").transform
	self.ui_t = LuaHelper.Find("UI").transform
end

function FirstWar:dispose()
	FirstWar._base.dispose(self)
	gf_remove_update(self)
end

function FirstWar:on_receive( msg, id1, id2, sid )
	if self:is_pass() then
		return
	end
	
	if id1 == ClientProto.PlayerLoaderFinish then -- 进入

		if self.battle_item.map_id == 160201 then -- 首场战斗地图

			StateManager:get_current_state():add_item(self)
			gf_register_update(self)
			self:init_wave_monster_num()
			self.character = self.battle_item:get_character()
			self.first_pos = Vector3(40, 45.3, 37.6) -- 第一波怪的位置
			--缓存特效
			self.effect_list = {}
			self.effect_list["22510002_show"] = XPEffect({effect = "510002@show"})
			self.effect_list["22510002_xp"] = XPEffect({effect = "510002@xp"})

			self.finger = View("fingerGuide", self)

			local career = self.character.config_data.career
			local UI = LuaHelper.Find("UI")
			local node = LuaHelper.Find(NodeList[career])
			local jump = LuaHelper.FindChild(node, NodeList[career].."@jump")

			local delay_fn = function()
				Net:receive(false, ClientProto.FristBattleMainui)
				Net:receive(false, ClientProto.HideOrShowATKPanel)
				-- jump:SetActive(false)
				self.character:show()
				BeginCamera:SetActive(true)
				UI:SetActive(true)
				self:check_step(1)
			end

			-- 播放跳跃动作
			self.xp:set_finish_cb(delay_fn)
			Sound:play_fx("opening",false,self.root)
			self.character:hide()
			self.xp:show_effect(true)

			-- if jump then
			-- 	Sound:play_fx("opening",false,self.root)
			-- 	self.character:hide()
			-- 	jump:SetActive(true)
			-- 	BeginCamera:SetActive(false)
			-- 	UI:SetActive(false)
			-- 	delay(delay_fn, TimeList[career])
			-- end

		else -- 新手村地图
			Net:receive(true, ClientProto.FristBattleMainui)
			--缓存特效
			self.effect_list = {}
			self.effect_list["41000079"] = Effect("41000079.u3d",cb)

			self.main_camera = LuaHelper.Find("Main Camera")

			local camera_obj = LuaHelper.Find("CameraObj")
			self.camera_1 = LuaHelper.FindChild(camera_obj, "Camera1")
			self.camera_2 = LuaHelper.FindChild(camera_obj, "Camera2")
			LuaHelper.SetCameraOnlyRenderLayer(LuaHelper.GetComponent(self.camera_1, "UnityEngine.Camera"), ClientEnum.Layer.DEFAULT)
			LuaHelper.SetCameraOnlyRenderLayer(LuaHelper.GetComponent(self.camera_2, "UnityEngine.Camera"), ClientEnum.Layer.DEFAULT)

			self.npc_parent = LuaHelper.Find("NPC")
			self.hp_parent = LuaHelper.Find("HP")
			self.player_parent = LuaHelper.Find("Player")

			self.canvas = LuaHelper.FindChild(LuaHelper.Find("UI"), "Canvas")

			self.camera_follow = LuaHelper.GetComponent(self.camera_2, "Seven.TargetFollow")

			self.ui = LuaHelper.Find("UI")
			self.ui:SetActive(false)

			self.fade_view = View("fadeView", self)

			self:check_step(8)
		end

	elseif id1 == ClientProto.JoystickStartMove then
		if self.index == 2 then
			-- Net:receive(nil, ClientProto.ForceGuideNext)
			self.finger:dispose()
		end

	elseif id1 == ClientProto.PlayerSelfBeAttacked then
		if self.index == 5 then -- 玩家被攻击触发
			self:show_xp_skill_btn()
		end

	elseif id1 == ClientProto.StoyFinish then
		if self.index == 9 then -- 进眨眼
			self:check_step(9)
		end

	elseif id1==Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "UpdateObjectR") then -- 创建,更新,移除通用协议
			for i,v in ipairs(msg.objList or {}) do
				if v.updateType == ServerEnum.OBJECT_UPDATE_TYPE.OUT_OF_RANGE_OBJECTS then -- 移除
					--[[local model = self.battle_item:get_model(v.guid)
					if model and model.dead then
						self.dead_num = self.dead_num + 1
						print("首场删除",self.index,self.dead_num,self.wave_1_num,self.wave_2_num,self.wave_3_num)
						if self.index == 3 and self.dead_num == self.wave_1_num then -- 第一波怪死亡，行走到第二波怪的触发点

							self:check_step(3)
				
						elseif self.index == 6 and self.dead_num == (self.wave_1_num + self.wave_2_num) then -- 第二波怪死亡，触发boss
							local cb = function()
								-- self:next_wave_c2s(3)
								self:check_step(6)
							end
							delay(cb, 1.5)

						elseif self.index == 7 and self.dead_num >= (self.wave_1_num + self.wave_2_num+ self.wave_3_num) then -- boss死亡触发
							self:check_step(7)
							
						end
					end]]

				-- elseif v.updateType == ServerEnum.OBJECT_UPDATE_TYPE.VALUES then -- 属性变化

				elseif v.updateType == ServerEnum.OBJECT_UPDATE_TYPE.CREATE_OBJECT then -- 创建对象
					if v.objType == ServerEnum.OBJ_TYPE.CREATURE then -- 怪物
						local update_value = self.battle_item:get_update_value(v)
						local monster_id = update_value[ServerEnum.OBJ_FIELDS.OBJ_PROTO_ID]
						if self.index == 4 and self.monster_id_2 == monster_id then -- 第二波怪穿件触发怪物剧情
							self:check_step(4)
							local cb = function()
								self:show_xp_skill_btn()
							end
							delay(cb, 5)
							break
						end
					end
				end
			end
		end
	elseif id1==Net:get_id1("copy") then
		if id2 == Net:get_id2("copy", "CreatureWaveNotifyR") then
			if msg.wave == 2 then
				print("CreaturewaveNotifyR_wtf",msg.wave)
				self:check_step(3)
			elseif msg.wave == 3 then
				local cb = function()
					self:check_step(6)
				end
				delay(cb, 1.5)
				print("CreaturewaveNotifyR_wtf",msg.wave)
			elseif msg.wave == 0 then
				print("CreaturewaveNotifyR_wtf",msg.wave)
				self:check_step(7)
			end
		end 
	end
end

function FirstWar:show_xp_skill_btn()
	if self.is_show_xp_skill then
		return
	end
	self.is_show_xp_skill = true
	Net:receive(true, ClientProto.ShowXPBtn)
	self:check_step(5)
	self.mask:dispose()
end

function FirstWar:check_step( event )
	local data = self.war_data[self.index]
	print("首场战斗",data.event,event,self.index)
	if data.event == event then
		self.index = self.index+1
		if data.guide then
			print("sjfoewife",1,data.guide) -- 技能指引
			self.guide_item:next(data.guide)
		end

		if data.story then
			print("sjfoewife",2,data.story) -- 到达圆盘
			local data = ConfigMgr:get_config("story")[data.story]
			self.story_item:set_data(data)
		end

		if data.effect then
			print("sjfoewife",3,data.effect) -- 播放特效 
			-- 恢复摇杆控制权
			local battle = LuaItemManager:get_item_obejct("battle")
			battle:get_character():enable_joystick(true)
			self.story_item.story_view.root.transform.parent = self.monster_t
			local finish_cb = function()
				print("firstWar effect finish_cb",self.index)
				self.story_item.story_view.root.transform.parent = self.ui_t
				if self.index == 8 then
					StateManager:show_transform()
					-- 退出副本,进入新手村
					LuaItemManager:get_item_obejct("copy"):exit_copy_c2s()

				elseif self.index == 10 then -- 显示玩家模型
					self:check_step(10)

				end
			end

			local cb = function( effect )
				effect:set_parent(LuaHelper.Find("Effect").transform)
				if self.index < 9 then
					effect:show_effect()
					if self.index == 7 then -- 请求刷新boss
						self:next_wave_c2s(3)
					end
				else
					effect:show_effect()
				end

				effect:set_finish_cb(finish_cb)
				UICamera:SetActive(true)
			end

			local url = data.effect

			local effect = self.effect_list[url]

			if not effect then
				Effect(url..".u3d",cb)
			else
				cb(effect)
			end
		end

		if data.d_pos then
			print("sjfoewife",4,data.d_pos) -- 自动寻路 此处到圆盘
			self.mask = View("warMask", self)

			--此处判断玩家如果在滑动摇杆，要强行终止
			-- 关闭摇杆控制权
			local battle = LuaItemManager:get_item_obejct("battle")
			battle:get_character():stop_move()
			battle:get_character().animator:Play("EmptyState",1)
			battle:get_character():enable_joystick(false)

			local cb = function()
				self:next_wave_c2s(2)
				battle:get_character():enable_joystick(true)
				-- mask:dispose()
			end
			self.battle_item:move_to(nil, data.d_pos[1], data.d_pos[2], cb, 0.2)
		end

		if data.model_id then
			print("sjfoewife",5,data.model_id)
			local cb = function( spr )
				LuaHelper.SetLayerToAllChild(spr.transform, ClientEnum.Layer.DEFAULT)
				spr:set_parent(LuaHelper.Find("NPC1").transform)
				spr.transform.localPosition = Vector3(0,0,0)
				spr.transform.localRotation = Vector3(0,0,0)
				local animator = LuaHelper.GetComponent(spr.root, "UnityEngine.Animator")
				animator:SetBool("idle", true)
				animator:SetTrigger("sidle")
				self.hp_parent:SetActive(false)
				self.camera_1:SetActive(true)
				self.camera_2:SetActive(false)
				self.main_camera:SetActive(false)


			end
			self.npc = SpriteBase(data.model_id..".u3d", cb)
		end

		if data.fade_in_time then -- 界面从透明到黑再到透明的时间
			print("sjfoewife",6,data.fade_in_time)
			if self.fade_view then
				self.fade_view.root.transform.parent = LuaHelper.Find("NPC1").transform.parent
				self.fade_view:set_time(data.fade_in_time*0.001,data.fade_out_time*0.001,data.fade_stop_time*0.001)
			end

			-- 首场结束
			if self.index > #self.war_data then
				local cb = function( view )
					view.root.transform.parent = LuaHelper.Find("NPC1").transform
				end

				-- 打开章节显示
				local view = View("chapterView", LuaItemManager:get_item_obejct("mainui"), nil, ConfigMgr:get_config("task_section")[101], nil, cb)
				view:set_touch(false)
				

				self.player:set_parent(self.player_parent.transform)
				self.player:faraway()
				self.battle_item.pool:add_character(self.player)

				self.ui:SetActive(true)

				self.hp_parent:SetActive(true)
				for i,v in pairs(self.battle_item.character_list) do
					v.animator:SetBool("idle", true)
				end

				self.main_camera:SetActive(true)
				self.camera_2:SetActive(false)
				-- 结束首场战斗
				self.guide_item.big_step = 1
				self.guide_item:set_guide_step_c2s(1)


				Net:receive(nil, ClientProto.RefreshMainUI)
			end
		end

		if data.player and data.player == 1 then
			print("sjfoewife",8,data.player)
			local next_cb = function()
				self:check_step(11) -- 显示章节
			end

			local cb = function(player)
				player:set_parent(LuaHelper.Find("NPC2").transform)
				player.transform.localPosition = Vector3(0,0,0)
				player.transform.localRotation = Vector3(0,0,0)
				player.animator:SetBool("idle", true)
				player.animator:SetTrigger("sidle")
				self.battle_item.pool:get_weapon(nil, player)
				LuaHelper.SetLayerToAllChild(player.transform, ClientEnum.Layer.DEFAULT)

				delay(next_cb, 5)
			end
			local career = LuaItemManager:get_item_obejct("game"):get_career()
			self.player = self.battle_item.pool:get_character(nil, career, 1, cb)

			local change_camera = function()
				self.npc:dispose()
				self.player.animator:SetTrigger("sidle")

				self.camera_2:SetActive(true)
				self.camera_1:SetActive(false)

			end
			delay(change_camera, data.fade_in_time*0.001)

		end

		if data.distance and data.distance > 0 then -- 拉近相机
			print("sjfoewife",9,data.distance)
			self.camera_follow:SetCameraScale(
				data.scale_time*0.001,
				data.stop_time*0.001,
				data.resume_time*0.001,
				data.late_time*0.001,
				data.distance
			)
		end
	end
end

function FirstWar:show_atk_guide()
	if not self.character:is_move() then
		return
	end

	local pos = self.battle_item:get_character():get_position()
	local dx = self.first_pos.x - pos.x
	local dy = self.first_pos.y - pos.y
	local dz = self.first_pos.z - pos.z

	local distance = dx^2 + dy^2 + dz^2

	if distance <= self.range_d then
		self:next_wave_c2s(1)
		gf_remove_update(self)
		self.character:enable_joystick(false)
		self.character:stop_move()
		Net:receive(true, ClientProto.HideOrShowATKPanel)
		self:check_step(2) -- 引导攻击
	end
end

function FirstWar:check_end( dt )
	if self.time > 0 then
		self.time = self.time - dt
		if self.time <= 0 then
			gf_remove_update(self)
			
		end
	end
end

function FirstWar:on_update( dt )
	self:show_atk_guide()
	self:check_end(dt)
end

-- 请求副本怪物
function FirstWar:next_wave_c2s( wave )
	print("请求副本怪物",wave)
	Net:send({wave = wave}, "copy", "NextWave")
end

function FirstWar:next_wave_s2c()
	
end

