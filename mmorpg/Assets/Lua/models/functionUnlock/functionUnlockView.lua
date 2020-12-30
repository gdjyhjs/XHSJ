--[[--
--
-- @Author:HuangJunShan
-- @DateTime:2017-05-31 15:36:57
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local FunctionUnlockView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "function_unlock.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function FunctionUnlockView:on_asset_load(key,asset)
	self.function_ico=self.refer:Get("function_ico")
	self.function_text=self.refer:Get("function_text")
	self.need_hide = self.refer:Get("need_hide")
	self.img_bg = self.refer:Get("img_bg_gb")
	self.tween_position = self.refer:Get("img_bg_tp")
	self.tween_position.worldSpace=true
	self.ico_start_position=self.function_ico.transform.position
	self.tween_position.from=self.ico_start_position
	self.img_fun_open =self.refer:Get("img_fun_open")
	self.fun_a=0
	--注册点击事件
    self.item_obj:register_event("function_unlock_view_on_click", handler(self, self.on_click))
	self:init_show()
	if self.item_obj.fun_type == 1 then
		self.refer:Get(8):SetActive(true)
		Net:receive(false,ClientProto.ShowATKPanel)
	elseif self.item_obj.fun_type == 2 then
		self.refer:Get(9):SetActive(true)
		Net:receive(true,ClientProto.ShowATKPanel)
	end
	self.item_obj:open_fun_do(false)
	self:fun_show()
	self.can_click = false
	self.schedule_click = Schedule(handler(self, function()
		self.schedule_click:stop()
		self.can_click = true
	end), 2)
	LuaItemManager:get_item_obejct("battle"):get_character():stop_auto_move()
end

function FunctionUnlockView:fun_show()
	if not self.schedule_show then
		self.schedule_show = Schedule(handler(self, function()
			self.fun_a =self.fun_a + 0.1
			self.img_fun_open.color= UnityEngine.Color(1,1,1,self.fun_a)
			if self.fun_a == 1 then
				self.schedule_show:stop()
				self.schedule_show = nil
			end
		end), 0.1)
	end
end

-- 释放资源
function FunctionUnlockView:dispose()
	if  self.schedule_show then
		self.schedule_show:stop()
		self.schedule_show = nil
	end
	self.item_obj.fun_type = 0
	self.can_click = false
	self.item_obj:register_event("function_unlock_view_on_click", nil)
    self._base.dispose(self)
 end

--激活显示时
function FunctionUnlockView:init_show()
	print("引导弹框被激活")
	print(self.item_obj.target_obj)
	if self.function_ico then
		-- self.function_ico.sprite = self.item_obj.sprite or nil
		gf_setImageTexture(self.function_ico, self.item_obj.icon)
		self.tween_position:ResetToBeginning()
		-- self.function_ico.transform.position = self.ico_start_position
	end
	if self.function_text then
		self.function_text.text = self.item_obj.function_name or "新功能"
	end
	if self.item_obj.fun_type == 1 then
		self.refer:Get("icon_tf").transform.localPosition = Vector3(self.item_obj.current_fun_item.icon_tf[1],self.item_obj.current_fun_item.icon_tf[2],0)
	end
end

function FunctionUnlockView:on_click(item_obj,obj,arg)
 	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="lookBtn" then --去看看
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:show_func()
	elseif cmd=="bgBtn" then  --隐藏界面，图标特效
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:show_func()
	end
end

function FunctionUnlockView:on_receive( msg, id1, id2, sid )
	if id1 ==  ClientProto.AutoDotask then 
        if not msg then
            self:show_func()
            Net:receive(true, ClientProto.AutoDotask)
        end
    end
end
--功能导航
function FunctionUnlockView:show_func()
	if not self.can_click then return end
	self.need_hide:SetActive(false)
	self.tween_position.to=self.item_obj.obj.transform.position
	print("self.item_obj.target_pos",self.item_obj.target_pos)
	self.tween_position:PlayForward()
	self.img_bg.transform:GetChild(0).gameObject:SetActive(false)
	self.schedule_hide = Schedule(handler(self, function()
			-- self.img_bg.transform:GetChild(0).gameObject:SetActive(true)
			self.schedule_hide:stop()
			if self.item_obj.fun_type == 1 then
				self.item_obj.obj:SetActive(true)
				self:dispose()
				self:open_guide()
			elseif self.item_obj.fun_type == 2 then
				self:dispose()
				self.item_obj:open_skill_func()
			end
			-- local unlock = LuaItemManager:get_item_obejct("mainui").assets[1].child_ui.functionunlock
			-- if  unlock:judge_need_switchBtn(self.item_obj.function_id) then  
			-- 	-- unlock.switchBtn.transform:GetChild(0).gameObject:SetActive(true)
			-- 	-- LuaItemManager:get_item_obejct("mainui"):show_red_point(ClientEnum.MAIN_UI_BTN.SWITCH,true)
			-- end
			-- self.item_obj.obj.transform:GetChild(1).gameObject:SetActive(true)
		end), 1)
end
--开启指引
function FunctionUnlockView:open_guide()
	print("开启按钮特效1")
	local guide =  LuaItemManager:get_item_obejct("guide")
	local fun_tb = ConfigMgr:get_config("function_unlock")[self.item_obj.function_id]
	local guide_id = fun_tb.guide_id
	if guide_id ~= 0 then --指引开启
		guide:next(guide_id)
		return
	elseif  fun_tb.effect == 1 then
		print("开启按钮特效")
		self.item_obj:fun_effect_save(fun_tb.obj_name)
		Net:receive({ btn_id = fun_tb.obj_name ,visible = true}, ClientProto.ShowAwardEffect)
	end
	self.item_obj:open_fun_over()
end


return FunctionUnlockView

