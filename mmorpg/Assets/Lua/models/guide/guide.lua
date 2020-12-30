--[[--
-- 新手引导
-- @Author:Seven
-- @DateTime:2017-05-31 09:26:54
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local GuideMask = require("models.guide.guideMask")

local Guide = LuaItemManager:get_item_obejct("guide")
Guide.priority = ClientEnum.PRIORITY.LOADING_MASK
Guide.forced_click = true -- 开启点击事件接收


-- 是否有新手引导
function Guide:is_open()
	return self.open
end

function Guide:set_open( open )
	self.open = open
end

function Guide:get_big_step()
	return self.big_step
end

function Guide:get_cur_big_step()
	return self.cur_big_step
end

function Guide:is_func_open(enum)
	return self.big_step>enum
end

function Guide:get_step()-- 当前小步骤步骤
	return self.step
end

function Guide:is_guide()
	return self.step~=nil and self.step~=0
end

function Guide:get_data()
	return self.guide_data
end

function Guide:get_canvas_pos()
	return self.canvas_pos
end

function Guide:check( asset )
	print("指引大步骤",self.cur_big_step)
	if self.cur_big_step == ClientEnum.GUIDE_BIG_STEP.HERO  then   --武将
		local tp =  LuaItemManager:get_item_obejct("horse"):get_get_type()
		if asset.url == "pet_get.u3d" and tp == ClientEnum.SHOW_TYPE.HERO then
			LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(false)
			Net:receive({id=ClientEnum.MAIN_UI_BTN.HERO,visible = true},ClientProto.ShowOrHideMainuiBtn)	
			self:next(1015)
			LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(false)
		end
	elseif self.cur_big_step == ClientEnum.GUIDE_BIG_STEP.HORSE then	--坐骑
		local tp =  LuaItemManager:get_item_obejct("horse"):get_get_type()
		if asset.url == "pet_get.u3d" and tp == ClientEnum.SHOW_TYPE.HORSE then
			LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(false)
			Net:receive({id=ClientEnum.MAIN_UI_BTN.MOUNT,visible = true},ClientProto.ShowOrHideMainuiBtn)
			self:next(1038)
			LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(false)
		end
	end
end

function Guide:show_hightlight(asset)
	print("指引asset",asset)
	local obj
	local root
	if asset then
		self:check(asset)
		if not self.guide_data then
			return
		end
		print("指引:",asset.url,self.guide_data.ui_name..".u3d")
		if asset.url ~= self.guide_data.ui_name..".u3d" then
			return
		end
		self.asset = asset
		root = asset.root
	else
		root = LuaHelper.Find(self.guide_data.ui_name)
		if not root then
			print("指引找不到root")
			return
		end
	end
	print("指引物品root:",root)
	if self.guide_data.guide_type == 0 or self.guide_data.guide_type == 4 then
		obj = LuaHelper.FindChild(root,self.guide_data.obj_name)
		self.guide_name = self.guide_data.obj_name
	elseif self.guide_data.guide_type == 1 then
		local num = LuaItemManager:get_item_obejct("game").role_info.career
		local key = "obj"..num.."_name"
		obj = LuaHelper.FindChild(root,self.guide_data[key])
		self.guide_name = self.guide_data.obj_name
	elseif self.guide_data.guide_type == 2 then
		obj = LuaHelper.FindChild(root,self.guide_data.obj_name)
		self.img =  LuaHelper.GetComponent(obj,UnityEngine_UI_Image)
		if self.img then
			self.img.enabled = true
		end
		self.guide_name = self.guide_data.obj_name
	elseif self.guide_data.guide_type == 3 then
		--local can_pos = Seven.PublicFun.CovertToCanvasPosition(root, obj)
		--self.canvas_pos = Vector3(self.guide_data.guide_tf[1]+can_pos.x,self.guide_data.guide_tf[2]+can_pos.y,0)
		self.mask = GuideMask(self)
		self.touch_up = true
		return
	end
	
	if not obj then
		print("找不到指引按钮:",self.guide_name)
		return
	elseif self.current_obj == obj then
		print("指引重复:",obj)
		self.current_guide = true
		return
	end
	self.current_obj = obj
	local can_pos = Seven.PublicFun.CovertToCanvasPosition(root, obj)
	self.canvas_pos = Vector3(self.guide_data.guide_tf[1]+can_pos.x,self.guide_data.guide_tf[2]+can_pos.y,0)
	self.mask = GuideMask(self)

	if self.guide_data.add_button == 1 then -- 是否需要加按钮 LuaHelper.Instantiate(gameObject)
		self.new_obj = UnityEngine.GameObject()
		local tf = self.new_obj:AddComponent("UnityEngine.RectTransform") 
		local obj_tf = LuaHelper.GetComponent(obj,"UnityEngine.RectTransform") 
		tf.sizeDelta =obj_tf.sizeDelta
		local img =self.new_obj:AddComponent(UnityEngine_UI_Image)
		img.color = UnityEngine.Color(1,1,1,0)
 		self.new_obj.transform:SetParent(obj.transform,false)
 		self.new_obj.name ="btn_background"
		self.add_btn = Seven.PublicFun.AddButton(self.new_obj)
	end

	local canvas = obj:AddComponent("UnityEngine.Canvas")
	print("指引canvas.overrideSorting1",canvas.overrideSorting)
	canvas.overrideSorting = true
	canvas.sortingOrder = 100
	print("指引canvas",canvas)
	print("指引canvas.overrideSorting2",canvas.overrideSorting)
	self.canvas = canvas
	self.gray = obj:AddComponent("UnityEngine.UI.GraphicRaycaster")
	-- StateManager:input_enable()
	self.current_guide = true
end

function Guide:next(step)
	if not self:is_open() then
		return
	end
	self.step = step
	self:stop_move()

	print("指引step",step)
	local data = ConfigMgr:get_config("guide")[step]
	if not data then
		print("找不到指引表格数据,步骤：",step)
		return
	end

	self.guide_data = data

	-- 是否要隐藏主界面攻击面板
	if data.show_atk_panel then
		Net:receive(data.show_atk_panel == 0, ClientProto.ShowATKPanel)
	end

	-- if data.delay_time then
	-- 	local delay_cb = function()
	-- 		self:show_hightlight()
	-- 	end
	-- 	delay(delay_cb, data.delay_time)
	-- else
		self:show_hightlight()
	-- end
		-- 保存当前完成的新手步骤到服务器
	if self.guide_data.big_step and	self.big_step ~= self.guide_data.big_step  then --确保一次
		self.big_step = self.guide_data.big_step
		self:set_guide_step_c2s(self.guide_data.big_step)
		print("指引大步骤发送成功",self.guide_data.big_step)
		self.cur_big_step = self.guide_data.big_step + 1
	end
end

function Guide:stop_move()
	local player =  LuaItemManager:get_item_obejct("battle"):get_character()
	if player then
		player:stop_auto_move()
	end
	Net:receive({visible = false}, ClientProto.ShowMainUIAutoPath)
end


function Guide:cancel_hightlight( obj )
	if not self.guide_data then
		print("指引没guide_data return",obj.name)
		return
	end
	-- print("指引点击")
	if obj~= nil and not string.find(obj.name,self.guide_data.obj_name) then
		print("指引return",self.guide_name,obj.name)
		return
	end
	if self.guide_data.guide_type == 4 then
		Net:receive({},ClientProto.GuideClose)
	end
	if self.gray then
		LuaHelper.Destroy(self.gray)
	end
	if self.canvas then
		LuaHelper.Destroy(self.canvas)
	end
	self.gray = nil
	self.canvas = nil
	if self.img then
		self.img.enabled = false
		self.img = nil
	end
	if self.add_btn then
		LuaHelper.Destroy(self.add_btn.gameObject)
		self.add_btn = nil
	end

	self.step = self.guide_data.next_guide

	self:guide_add_event(self.guide_data.butten_event) --添加事件


	if not self.step or self.step == 0 then
		print("指引结束",self.guide_data.disc)
		self:guide_over()
		self.guide_data = nil
		self.mask:hide()
		self.mask = nil
		-- StateManager:input_disable()
		return
	end
	if self.guide_data and self.guide_data.delay_time then
		local delay_cb = function()
			self.mask:hide()
			self.mask = nil
			self:next(self.step)
		end
		delay(delay_cb, self.guide_data.delay_time)
		return
	else
		self.mask:hide()
		self.mask = nil
	end
	print("指引下一个id",self.step)
	self:next(self.step)
end

function Guide:guide_over()
	LuaItemManager:get_item_obejct("functionUnlock"):open_fun_over()--功能开启结束
end

--点击事件
function Guide:on_click(obj,arg)
	if not self.is_open then
		return
	end
	self:call_event("guide_on_click",false,obj,arg)
	if  self.current_guide and string.find(obj.name, self.guide_name) then
		return true
	else
		return
	end
	-- print("指引点击",obj.name)
end

function Guide:on_drag(obj,position)
	print("向上滑了啊y",position.y)
	if self.touch_up then
		if not self.up_y then
			self.up_y = position.y
		end
		if position.y - self.up_y >= 20 then
			self.up_y = nil
			self.touch_up = false
			-- LuaItemManager:get_item_obejct("battle"):get_character():start_ride(1, true)
			self:cancel_hightlight()
			self:guide_over()
		end
	end
	-- if self.touch_up then
	-- 	print("向上滑了啊")
	-- 	self.touch_up = false
	-- 	LuaItemManager:get_item_obejct("battle"):get_character():start_ride(1, true)
	-- 	self:cancel_hightlight()
	-- end
	return true
end

function Guide:on_press_up(obj,eventData)
	if obj.name == "touch_up" then
		if self.up_y then
			self.up_y = nil
		end
	end
	return true
end

function Guide:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("base") then
		if id2 == Net:get_id2("base", "GetNewerStepR") then
			self:get_guide_step_s2c(msg)
		end
	elseif id1 == ClientProto.ForceGuideNext then -- 强制新手引导到下一步
		self.current_guide = false
		self:cancel_hightlight(self.current_obj)
	end
end

-- 设置新手步骤
function Guide:set_guide_step_c2s( step )
	Net:send({step = step}, "base", "SetNewerStep")
	if step == 1 then
		self.countdown = Schedule(handler(self, function()
					self:next(1043)
					self.countdown:stop()
					end), 5)
	end
end

-- 获取新手步骤
function Guide:get_guide_step_c2s()
	Net:send({}, "base", "GetNewerStep")
end

function Guide:get_guide_step_s2c( msg )
	gf_print_table(msg,"wtf receive GetNewerStepR")
	self.big_step = msg.step or 0
	if self.big_step > 0 then
		self.cur_big_step = self.big_step+1
	end
end


--每次显示时候调用
function Guide:on_showed()

end

--初始化函数只会调用一次
function Guide:initialize()
	print("初始化指引数据类")
	self.open = true -- 是否开启
	self.step = 0 -- 当前小步骤步骤
	self.big_step = 0 -- 记录当前大步骤（主要用来判断某个步骤是否完成
	self.cur_big_step = 0
	self.guide_data = nil -- 当前引导的新手数据
	self.current_guide = false
	self.canvas_pos = nil-- 保存引导按钮的画布坐标
end


function Guide:guide_add_event(num)
	if num == 1 then
		gf_create_model_view("pvp")
		LuaItemManager:get_item_obejct("activeDaily").assets[1]:hide()
	elseif num == 2 then
		LuaItemManager:get_item_obejct("pvp"):send_to_challenge_first()
	elseif num == 3 then
		local data = ConfigMgr:get_config("daily")[1008]
		LuaItemManager:get_item_obejct("activeDaily"):active_enter(data)
		LuaItemManager:get_item_obejct("activeDaily").assets[1]:hide()
		
	elseif num == 4 then
		local data = ConfigMgr:get_config("function_unlock")
		for k,v in pairs(data) do
		 	if v.guide_id== self.guide_data.guide_id then
		 		local index =  "career_"..LuaItemManager:get_item_obejct("game"):get_career()
		 		local item_id =  ConfigMgr:get_config("task")[v.open_need_id][index][1][1]
		 		local surface_id = ConfigMgr:get_config("item")[item_id].effect[1]
		 		LuaItemManager:get_item_obejct("surface"):open_view( surface_id )
		 		return
		 	end
		end
		-- LuaItemManager:get_item_obejct("surface"):open_view( 140011 )
	elseif num == 5 then
		LuaItemManager:get_item_obejct("equip"):set_open_mode(3)
		LuaItemManager:get_item_obejct("equip"):add_to_state()
	elseif num == 6 then
		local tb = LuaItemManager:get_item_obejct("task"):get_task_list()
		for k,v in pairs(tb) do
			if v.type == ServerEnum.TASK_TYPE.MAIN then
				Net:receive({task_data = v},ClientProto.OnTouchNpcTask)
			end
		end
		Net:receive(false,ClientProto.OpenAutoDoTask)
	elseif num == 7 then
		gf_create_model_view("copy",ServerEnum.COPY_TYPE_VIEW.TOWER)
	elseif num == 8 then
		local Player = LuaItemManager:get_item_obejct("player")
		Player:select_player_page(3,3)
		Player:add_to_state()
	end
end

function Guide:guide_continue(g_id)
	if g_id > self.big_step then
		if  LuaItemManager:get_item_obejct("functionUnlock"):check_ishave_fun(1) then
			self:next(1044)
		end
	end
end

