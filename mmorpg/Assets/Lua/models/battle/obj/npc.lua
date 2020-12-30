--[[--
-- NPC类
-- @Author:Seven
-- @DateTime:2017-04-20 09:47:06
--]]
local SpriteBase = require("common.spriteBase")
local Effect = require("common.effect")
local PlayerPrefs = UnityEngine.PlayerPrefs
local Quaternion = UnityEngine.Quaternion
local Vector3 = UnityEngine.Vector3
local NPC = class(SpriteBase, function(self, config_data, task_data, ...)

    self.config_data = config_data
    self.task_data = task_data
    self.game_item = LuaItemManager:get_item_obejct("game")
    self.is_npc = true
    self.is_hide = false

	SpriteBase._ctor(self, self.config_data.model..".u3d", ...)
end)

function NPC:set_guid( guid )
	self.guid = guid
end

function NPC:set_server_npc( server_npc )
	self.server_npc = server_npc
end

-- 是否是服务器控制的npc
function NPC:is_server_npc()
	return self.server_npc
end

function NPC:move_to( pos, cb ,dis,ani)
	if self.normal_move then
		if self.cur_data.type == 1 then
			self.normal_move:MoveTo(pos, cb, dis or 0.3,ani or "")
		else
			self.normal_move:MoveTo(pos, cb)
		end
	
	end
end

function NPC:set_task_data( task_data )
	self.task_data = task_data
	self:refresh_effect(task_data)
end

function NPC:show_finish_effect()
	if self.finish_effect then
		self.finish_effect:show()
	end
	if self.receive_effect then
		self.receive_effect:hide()
	end
end

function NPC:show_receive_effect()
	if self.finish_effect then
		self.finish_effect:hide()
	end
	if self.receive_effect then
		self.receive_effect:show()
	end
end

function NPC:hide_all_effect()
	if self.finish_effect then
		self.finish_effect:hide()
	end
	if self.receive_effect then
		self.receive_effect:hide()
	end
end

function NPC:init()
	LuaHelper.SetLayerToAllChild(self.transform, ClientEnum.Layer.CHARACTER)-- 不碰撞层
	Seven.PublicFun.SetRenderQueue(self.root, 2501) -- 设置选渲染队列（主角为2500）

	LuaHelper.RemoveComponent(self.root, "UnityEngine.AI.NavMeshAgent")
	if self.config_data.move == 1 or self.config_data.talk== 1 then
		if not self.schedule then
			self.schedule = Schedule(handler(self, self.on_update), 0.034)
		end
	end
	self.animator = LuaHelper.GetComponent(self.root, "UnityEngine.Animator") -- 动画控制器
	if self.animator then
		self.animator:SetBool("idle", true)
	end

	self.head_node = LuaHelper.FindChild(self.root, "HP")
	if self.head_node == nil then
		gf_error_tips("NPC找不到HP啊啊啊"..self.config_data.model)
	end
	if self.config_data.touch == 1 then -- 可以点击
		local collider = self.root:AddComponent("UnityEngine.BoxCollider")
		collider.size = Vector3(1,self.head_node.transform.position.y,1)
		collider.center = Vector3(0,self.head_node.transform.position.y/2,0)
		collider.isTrigger = true
		self.collider = collider

		-- self.collider_event = self.root:AddComponent("Seven.ColliderEvent")
		-- self.collider_event.onMouseUpFn = handler(self, self.on_touch_up)
		self.touch = self.root:AddComponent("Seven.Touch.Touch3DModel")
		self.touch.onTouchedFn = handler(self, self.on_touch_up)

	end

	local scale = self.config_data.model_scale or 1
	self:set_scale(Vector3(scale, scale, scale))
	if self.head_node then
		self:init_effect()
	end
	if not self.normal_move and  self.config_data.move == 1 then
		-- self.root:GetComponent("")
		self.cur_data = ConfigMgr:get_config("npc_move")[self.config_data.code]
		-- self.c_controller =LuaHelper.GetComponent(self.root,"UnityEngine.CharacterController")
		if  self.cur_data and self.cur_data.type == 1 then
			self.normal_move = self.root:AddComponent("Seven.Move.NormalMove")
			-- if self.c_controller then
			-- 	self.c_controller.enable = true
			-- else
			-- 	-- self.c_controller = LuaHelper.AddComponent(self.root, "UnityEngine.CharacterController")
			-- end
		else
			-- if self.c_controller then
			-- 	self.c_controller.enable = false
			-- end
			self.normal_move = self.root:AddComponent("Seven.Move.NpcMove")
		end
		if self.cur_data then
			self.npc_move_tb = self.cur_data.load_move
			self.npc_print  = 2
			self.npc_wait_time = self.npc_move_tb[self.npc_print][4] or 0.1
			self.normal_move.speed = self.cur_data.speed or 3 
			self:init_move()
		end
	else
		LuaHelper.RemoveComponent(self.root, "UnityEngine.CharacterController")
	end
end

-- 初始化特效
function NPC:init_effect()
	local finish_fn = function( effect, key )
		LuaHelper.SetLayerToAllChild(effect.transform, ClientEnum.Layer.CHARACTER)

		local pos = self.head_node.transform.position
		pos.y = pos.y+2
		effect:set_parent(self.transform)
		effect:set_position(pos)
		if self.task_data then
			local status = self.task_data.status
			
			if key == "receive" then
				effect:set_visible(status == ServerEnum.TASK_STATUS.AVAILABLE)
			end

			if key == "finish" then
				effect:set_visible(status == ServerEnum.TASK_STATUS.COMPLETE)
			end
		else
			effect:hide()
		end
	end
	if not self.receive_effect and not self.finish_effect then
		self.receive_effect = Effect("41000013.u3d", finish_fn, "receive") -- 感叹号
		self.finish_effect = Effect("41000008.u3d", finish_fn, "finish") -- 问号
	end
end

function NPC:refresh_effect( task_data )
	local status = -1
	if task_data then
		status = task_data.status
	end
	self.receive_effect:set_visible(status == ServerEnum.TASK_STATUS.AVAILABLE)
	self.finish_effect:set_visible(status == ServerEnum.TASK_STATUS.COMPLETE)
	if task_data and task_data.sub_type == ServerEnum.TASK_SUB_TYPE.NPC_GOSSIP and status == ServerEnum.TASK_STATUS.PROGRESS then
		self.finish_effect:set_visible(status == ServerEnum.TASK_STATUS.PROGRESS)
	end
	
end

function NPC:set_blood_line( blood_line )
	if not self.head_node then 
		self.blood_line:hide()
		return 
	end
	self.blood_line = blood_line
	self.blood_line:set_target(self.head_node.transform)
	-- local data = ConfigMgr:get_config("npc_talk")[self.config_data.code]
	-- if data then
	-- 	self.blood_line:set_npc_talk_text(data.talk)
	-- end
	if self.config_data.touch == 1 then
		self.blood_line:set_info(self.config_data.name)
		self.blood_line:set_title(self.config_data.title)
	else
		-- blood_line:dispose()
		self.blood_line:set_info("")
		self.blood_line:set_title("")
	end
end

function NPC:look_at( position )
	position.y = self.position.y
	self.transform:LookAt(position)
end

function NPC:get_event()
	return gf_get_npc_event(self.config_data.code)
end

function NPC:on_touch_up()
	print("点击Npc", self.config_data.code,self.task_data)

	local status = -1
	if self.task_data then
		status = self.task_data.status
	else
		self.task_data = LuaItemManager:get_item_obejct("task"):get_task_data(self.config_data.code)
		if self.task_data then
			status = self.task_data.status
		end
	end

	local event_list = gf_get_npc_event(self.config_data.code, status)

	if self.task_data then
		if self.task_data.type == ServerEnum.TASK_TYPE.ESCORT then
			Net:receive({task_data = self.task_data, event = event_list,data = self.config_data}, ClientProto.OnTouchNpcTask)
		elseif self.task_data.status == ServerEnum.TASK_STATUS.FINISH then -- self.task_data.status == ServerEnum.TASK_STATUS.PROGRESS or 
			Net:receive({data = self.config_data, event = event_list}, ClientProto.OnTouchNpcNoTask)
		else
			Net:receive({task_data = self.task_data, event = event_list,data = self.config_data}, ClientProto.OnTouchNpcTask)
		end
	elseif self.config_data.talk == 0 then
		local tb = ConfigMgr:get_config("npc_event")[self.config_data.event[1]]
		if tb.content_ty == ClientEnum.NPC_CONTENT_TY.HUSONG then
			if LuaItemManager:get_item_obejct("activeDaily"):is_open_husong() then
				gf_create_model_view("husong")
				-- 点击npc的时候，玩家和npc对望
				LuaItemManager:get_item_obejct("battle"):npc_lookat_character(self.config_data.code)
			else
				Net:receive({data = self.config_data}, ClientProto.OnTouchNpcNoTask)
			end
		end
	else
		Net:receive({data = self.config_data, event = event_list}, ClientProto.OnTouchNpcNoTask)
	end
end

function NPC:on_update( dt )
	if self.is_hide then
		return
	end
	if self.npc_move then
		local cb = function()
			self.npc_move = false
			if	self.npc_move_tb[self.npc_print][4] or self.npc_move_tb[self.npc_print][4] ~=0 then
				self.normal_move:StopMove()
			end
			if self.npc_move_tb[self.npc_print][5] then
				if self.root then
					if not self.countdown2 then
						self.cur_print = self.npc_print
						self.cur_p = Quaternion.Euler(0,self.npc_move_tb[self.cur_print][5],0).y 
						self.cur_y = self.root.transform.localRotation.y
						print("npc行走1",self.root.transform.localRotation)
						if self.cur_y <self.cur_p then
							self.direction = true
						else
							self.direction = false
						end
					 	self.countdown2 = Schedule(handler(self,self.move_rotation),0.01)
					 end
				end
			end
			if not self.countdown then
				self.countdown = Schedule(handler(self,self.move_cb),self.npc_wait_time)
			end
		end
		self:move_to(self.pos,cb)
	end
end

function NPC:move_cb()
	self.npc_print = self.npc_print+1
	if self.npc_print > #self.npc_move_tb then
		self.npc_print = 1
	end
	self.pos = Vector3(self.npc_move_tb[self.npc_print][1],self.npc_move_tb[self.npc_print][2],self.npc_move_tb[self.npc_print][3])
	self.npc_wait_time = self.npc_move_tb[self.npc_print][4] or 0
	self.countdown:stop()
	self.countdown = nil
	self.npc_move = true
end

function NPC:move_rotation(dt)
	if self.npc_move then
		self.countdown2:stop()
		self.countdown2 = nil
		return
	end
	-- local x = false
	-- if self.direction then
	-- 	self.cur_y = self.cur_y+ dt*0.5
	-- 	if self.cur_y >=self.cur_p then
	-- 		x = true
	-- 	end
	-- else
	-- 	self.cur_y = self.cur_y- dt*0.5
	-- 	if self.cur_y <=self.cur_p then
	-- 		x = true
	-- 	end
	-- end
	-- print("npc行走",self.cur_y,self.cur_p)
	-- if x then
		-- print("npc行走a",self.cur_y)
		-- self.root.transform.localRotation =Vector3(0,self.npc_move_tb[self.cur_print][5],0)
		-- self.root.transform.localRotation = Quaternion.RotateTowards(self.root.transform.localRotation, Vector3(0,self.npc_move_tb[self.cur_print][5],0), dt*0.1);
		self.root.transform.localRotation = Quaternion.LerpUnclamped(self.root.transform.localRotation, Vector3(0,self.npc_move_tb[self.cur_print][5],0), dt);
		-- self.countdown2:stop()
		-- self.countdown2 = nil
	-- else
	-- 	local qu = Quaternion.Euler(0,self.npc_move_tb[self.cur_print][5],0)
	-- 	self.root.transform.localRotation = Quaternion(qu.x,self.cur_y,qu.z,qu.w)
	-- end
end


function NPC:init_move()
	self.pos = Vector3(self.npc_move_tb[self.npc_print][1],self.npc_move_tb[self.npc_print][2],self.npc_move_tb[self.npc_print][3])
	self.npc_move = true
	self.normal_move:StartMove()
end

function NPC:update_talk()
	if not self.talk_tb then
 		self.talk_tb = {}
 		local data =  LuaItemManager:get_item_obejct("npc").npc_talk_tb 
 		for k,v in pairs(data) do
 			if v.code == self.config_data.code then
 				local x = #self.talk_tb+1
 				self.talk_tb[x] = v
 				if v.cur then
 					self.cur_talk_num = x
 				end
 			end
 		end
 	end
 	if #self.talk_tb == 0 then return end
 	if not self.cur_talk_num  then
 		self.cur_talk_num = 1
 		self.talk_tb[1].cur = 1
 		self:talk_cd_show(self.talk_tb[self.cur_talk_num])
 	else
 		self:talk_cd_show(self.talk_tb[self.cur_talk_num])
 	end
 	self.blood_line:set_npc_talk_text(self.talk_tb[self.cur_talk_num].talk)
end

function NPC:talk_cd_show(tb)
	local now_time = Net:get_server_time_s()
 	if not tb.cur_time or now_time-tb.cur_time>=tb.time then
 		self.blood_line:show_npc_talk(true)
 		self:talk_hide(tb.keep,tb.time)
 		self.first = true
 	else
 		local wait_time = tb.time-(now_time-tb.cur_time)
 		self.blood_line:hide_npc_talk()
 		self:talk_show(wait_time,tb.keep)
 	end
end

function NPC:talk_hide(keep_time,wait_time)
	if not self.countdown1 then
		self.countdown1 = Schedule(handler(self, function()
					for k,v in pairs(self.talk_tb or {} ) do
						v.cur_time = Net:get_server_time_s()
					end
					if not wait_time then
						wait_time =self.talk_tb[self.cur_talk_num].time
					end
 					self.blood_line:show_npc_talk(false)
 					self:talk_show(wait_time,keep_time,true)
 					self.countdown1:stop()
 					self.countdown1 = nil
 					print("npctalk_1")
 		end),keep_time)
	end
end

function NPC:talk_show(wait_time,keep_time,tf)
	if tf then
		self.cur_talk_num  = self.cur_talk_num +1
		if  self.cur_talk_num > #self.talk_tb then
			self.cur_talk_num = 1
		end
		print("npctalk_2")
	end
	if not self.countdown2 then
		self.countdown2 = Schedule(handler(self, function()
						print("npctalk_3")
						self.blood_line:set_npc_talk_text(self.talk_tb[self.cur_talk_num].talk)
 						self.blood_line:show_npc_talk(true)
 						self:talk_hide(keep_time,nil)
 						self.countdown2:stop()
 						self.countdown2 = nil		
 		end),wait_time)
	end
end


function NPC:dispose()
	if self.blood_line then
		self.blood_line:dispose()
	end
	if self.countdown1 then
		self.countdown1:stop()
	end
	if self.countdown2 then
		self.countdown2:stop()
	end
	if self.schedule then
		self.schedule:stop()
	end

	NPC._base.dispose(self)
end

function NPC:faraway()
	NPC._base.faraway(self)
	if self.blood_line then
		if self.config_data.talk== 1 then 
			self.blood_line:hide_npc_talk()
		end
		self.blood_line:hide()
	end
	if self.countdown1 then
		self.countdown1:stop()
	end
	if self.countdown2 then
		self.countdown2:stop()
	end
	if not self.config_data.move then
		self.is_hide = true
	end
end

function NPC:reset(data)
	print("创建npc完成",data.name)
	self.config_data = data
	self.task_data = LuaItemManager:get_item_obejct("task"):get_task_data(self.config_data.code)
	self:init()
	if self.blood_line then
		self:set_blood_line(self.blood_line)
		self.blood_line:show()
		if self.config_data.talk== 1 then 
			self.talk_tb = nil
			self:update_talk()
		end
	end
	self.is_hide = false
	if 	self.task_data then
		print("npcopen1")
		self:refresh_effect(self.task_data)
	end
end

return NPC