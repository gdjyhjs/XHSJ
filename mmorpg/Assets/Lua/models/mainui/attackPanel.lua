--[[--
-- 攻击面板
-- @Author:Seven
-- @DateTime:2017-04-18 12:13:10
--]]
local Open_skill = require("models.skill.open_skill")
local AttackPanel = class(function ( self, ui, item_obj )
	self.ui = ui
	self.item_obj = item_obj
	self.skill_item = LuaItemManager:get_item_obejct("skill")
	self.battle_item = LuaItemManager:get_item_obejct("battle")

	self.update_list = {} -- 正在更新的fill

	self:init()
end)

function AttackPanel:init()
	self:init_filled()
	self:init_auto_atk_btn()
	self:init_potionBtn()
end

-- 初始化技能加载
function AttackPanel:init_filled()
	--技能按钮列表
	self.filled_list = {}
	--获取攻击面板
	self.atkPanel_refer = self.ui.atkPanel
	local career = LuaItemManager:get_item_obejct("game"):getRoleInfo().career
	--技能按钮
	local data_unlock = ConfigMgr:get_config("skill_unlock")
	local data = ConfigMgr:get_config("skill")
	local level = LuaItemManager:get_item_obejct("game"):getLevel()
	local first_war = LuaItemManager:get_item_obejct("firstWar"):is_pass()
	for i=1,5 do
		local item = self.atkPanel_refer:Get("skill_"..i.."_obj")
		local skill_id = 11000001+career*100000+i*1000
		self.filled_list[i] = {
			obj = item.gameObject,
			icon =  item:Get("skill"..i),               
			filled =  item:Get("filled"),
			time = item:Get("time"),
			cool_time = data[skill_id].cooldown_time*0.001,
			effect1 = item:Get("41000057"),
			effect2 = item:Get("41000058"),
			effect3 = item:Get("41000046"),
			state = true, --技能状态
			unlock = item:Get("skill_lock"),
			unlock_text = item:Get("skill_unlock"),
			unlock_state = true,--解锁状态
			tb = data[skill_id]
		}
		gf_setImageTexture(self.filled_list[i].icon,data[skill_id].icon)
		-- gf_setImageTexture(self.filled_list[i].filled,data[skill_id].icon)
		self.filled_list[i].time.enabled = false
		self.filled_list[i].time.text = self.filled_list[i].cool_time
		self.filled_list[i].filled.gameObject:SetActive( false)
		self.filled_list[i].filled.fillAmount = 1.0
		self.filled_list[i].effect3:SetActive(false)
		if data_unlock[i].open_level > level and first_war then
			self.filled_list[i].unlock:SetActive(true)
			self.filled_list[i].unlock_state = false
			if i~=5 then
				self.filled_list[i].unlock_text.text = data_unlock[i].open_level .."级"
			else
				self.filled_list[i].unlock_text.text =gf_localize_string("名将技")
				self.filled_list[i].obj:SetActive(false)
			end
		else
			self.filled_list[i].unlock:SetActive(false)
			if i == 5 then  --XP技能
				self.filled_list[i].effect3:SetActive(true)
			end
		end
	end
	--吃药按钮
	local btn_ref = self.atkPanel_refer:Get("potionBtn")
	
	self.filled_list["potionBtn"]={
		btn = btn_ref.gameObject,
		icon = btn_ref:Get("icon"),
		filled =btn_ref:Get("filled"),
		count = btn_ref:Get("count"),
		time = btn_ref:Get("time"),
		effect2 = btn_ref:Get("41000058"),
	}
	self.filled_list["potionBtn"].filled.fillAmount = 1
	self.filled_list["potionBtn"].time.enabled = false
	self.filled_list["potionBtn"].filled.gameObject:SetActive( false)
	--普通攻击图标
	local atk_id = 11000001+career*100000+6*1000
	gf_setImageTexture(self.atkPanel_refer:Get(1),data[atk_id].icon)

	self:update_ui()
	if not first_war then
		self.wake_up_unlock = true
	else
		self:next_unluck()
	end
end

function AttackPanel:init_auto_atk_btn()
	local btn = self.ui:get_btn(ClientEnum.MAIN_UI_BTN.AUTO_ATK)
	self.auto_atk_hl_bg = LuaHelper.FindChild(btn, "select_bg")
	self.auto_atk_hl = LuaHelper.FindChild(btn, "select")

	self:set_auto_atk_btn_hl(self.battle_item:is_auto_atk())
end

function AttackPanel:set_auto_atk_btn_hl( hl )
	self.auto_atk_hl_bg:SetActive(hl)
	self.auto_atk_hl:SetActive(hl)
end

-- 技能不可以使用，所有按钮变灰
function AttackPanel:fade_all_skill()
	for k,v in pairs(self.filled_list) do
		v.filled.fillAmount = 1.0
		v.filled.gameObject:SetActive( true)
		v.state = false
	end
end

function AttackPanel:update_ui()
	-- for i,v in pairs(self.skill_item.skill_list or {}) do
	-- 	if v.open == ClientEnum.SKILL_STATE.OPEN and 
	-- 	   i ~= ServerEnum.SKILL_POS.NORMAL_1    and 
	-- 	   i ~= ServerEnum.SKILL_POS.NORMAL_2    and 
	-- 	   i ~= ServerEnum.SKILL_POS.NORMAL_3    then

	-- 		self.filled_list[i].filled.fillAmount = 0.0
	-- 		self.filled_list[i].filled.gameObject:SetActive( false)
	-- 		self.filled_list[i].time.enabled = false
	-- 		self.filled_list[i].state = true
	-- 	end
	-- end
	for k,v in pairs(self.filled_list) do
		v.filled.fillAmount = 0
		v.filled.gameObject:SetActive( false)
		v.state = true
	end
	self.filled_list.potionBtn.filled.fillAmount = 0.0
	self.filled_list.potionBtn.filled.gameObject:SetActive( false)
end

function AttackPanel:main_on_update( dt )
	if not self.skill_item:is_can_use() then -- 不可以使用技能
		return
	end

	local list = self.skill_item:get_play_list()
	for k,v in pairs(list) do
		if self.filled_list[k] then
			local t = Net:get_server_time_s() - v.start_time
			local ct = v.skill_data.cooldown_time*0.001
			if t > ct then
				self.skill_item:remove_play_skill(k)
				self.filled_list[k].filled.gameObject:SetActive( false)
				self.filled_list[k].time.enabled = false
				self.filled_list[k].state = true
				self.filled_list[k].effect2:SetActive(true)
				self.filled_list[k].countdown2 = Schedule(handler(self, function()
					self.filled_list[k].effect2:SetActive(false)
					self.filled_list[k].countdown2:stop()
					end), 1)
				if self.filled_list[k].effect3 and k == 5 then
					self.filled_list[k].effect3:SetActive(true)
				end
			else
				if self.filled_list[k].state then
					self.filled_list[k].state=false
					self.filled_list[k].effect3:SetActive(false)
					self.filled_list[k].effect1:SetActive(true)
					self.filled_list[k].countdown1 =Schedule(handler(self, function()
						self.filled_list[k].effect1:SetActive(false)
						self.filled_list[k].countdown1:stop()
					end), 1)
				end
				self.filled_list[k].time.enabled = true
				self.filled_list[k].time.text =math.ceil(ct - t)
				if self.filled_list[k].time.text == "0" then
					self.filled_list[k].time.text = ""
				end
				self.filled_list[k].filled.gameObject:SetActive( true)
				self.filled_list[k].filled.fillAmount = 1
			end
		end
	end
	if self.coolpotion then
		self.filled_list["potionBtn"].time.enabled = true
		self.filled_list["potionBtn"].filled.gameObject:SetActive( true)
		self.filled_list["potionBtn"].filled.fillAmount = 1
		local ct = self.cur_potion_time - Net:get_server_time_s()
		self.filled_list["potionBtn"].time.text = math.ceil(ct)
		if self.filled_list["potionBtn"].time.text == "0" then
			self.filled_list["potionBtn"].time.text = ""
		end
		if ct <= 0.05 then
			self.filled_list["potionBtn"].time.enabled = false
			self.filled_list["potionBtn"].filled.gameObject:SetActive( false)
			self.coolpotion = false
			self.filled_list["potionBtn"].effect2:SetActive(true)
			self.filled_list["potionBtn"].countdown2 = Schedule(handler(self, function()
					self.filled_list["potionBtn"].effect2:SetActive(false)
					self.filled_list["potionBtn"].countdown2:stop()
					end), 1)
		end
	end
end

function AttackPanel:refresh_auto_btn()
	self:set_auto_atk_btn_hl(self.battle_item:is_auto_atk())
	Net:receive({visible = self.battle_item:is_auto_atk()}, ClientProto.ShowMainUIAutoAtk)
end

--点击事件
function AttackPanel:on_click(item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if cmd=="autoBtn" then --自动打怪
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.battle_item:set_auto_atk(not self.battle_item:is_auto_atk())
		self:refresh_auto_btn()
		
	elseif cmd=="atk" then
		--普通攻击
	elseif cmd=="potionBtn" then
		
	end
	-- if self.open_skill_unlock then
	-- 	if self.close_effect_id ~=5 then
	-- 		self.filled_list[self.close_effect_id].effect3:SetActive(false)
	-- 	end
	-- 	self.open_skill_unlock:dispose()
	-- 	self.open_skill_unlock = nil
	-- 	LuaItemManager:get_item_obejct("functionUnlock"):open_fun_over()
	-- end
end

function AttackPanel:click_potion_btn(ty)
	if not self.coolpotion then
        Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self:use_potion(self.cur_potion,ty)
		-- self.coolpotion = true
	else
        Sound:play(ClientEnum.SOUND_KEY.CLOSE_BTN) -- 关闭按钮点击音效
		local txt = gf_localize_string("血瓶冷却中")
		LuaItemManager:get_item_obejct("floatTextSys").assets[1]:add_leftbottom_broadcast(txt)
	end
end

function AttackPanel:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "GetSkillListR") then
			self:update_ui()
		end
	end

	if id1 == ClientProto.AutoAtk then
		self.battle_item:set_auto_atk(msg)
		self:refresh_auto_btn()

	elseif id1 == ClientProto.IsCanUseSkill then -- 是否可以使用技能
		if msg then
			self:update_ui()
		else
			self:fade_all_skill()
		end
	elseif id1 == ClientProto.PlayerLoaderFinish then -- 进入地图

		local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
    	if ConfigMgr:get_config("open_fun_scene")[map_id] then
    		if self.wake_up_unlock then
    			self:wake_up_lock()
    		end
    		if self.wait_out_open then
    			self:open_skill_fun()
    			self.wait_out_open = nil
    		end
    	end
    elseif id1 == Net:get_id1("base") then
    	if id2 == Net:get_id2("base", "UpdateLvlR") then
    		if self.current_skill_unlock ~=nil then
    			if msg.level>= self.current_skill_unlock then
 					-- self.filled_list[self.current_skill_id].effect3:SetActive(true)
 					local map_id = LuaItemManager:get_item_obejct("battle"):get_map_id()
    				if not ConfigMgr:get_config("open_fun_scene")[map_id] then
    					self.wait_out_open = true
    					return
    				end
    				if LuaItemManager:get_item_obejct("guide"):is_guide() then
    					return
    				end
    				self:open_skill_fun()
    				-- self:wake_up_lock()
    			end
    		end
    	elseif id2 == Net:get_id2("base", "SetImmedAddHPItemR") then
    		print("血包设置",msg.protoId)
    		self:update_potionBtn(msg.protoId)
    	end
    elseif id1 == Net:get_id1("bag") then
    	if id2== Net:get_id2("bag","GetBagInfoR") and sid == ServerEnum.BAG_TYPE.NORMAL then  --初始化背包 --
			-- self:init_potionBtn()
			print("初始化血瓶",self.cur_potion_time)
		elseif id2== Net:get_id2("bag","UseItemR") and self.usepotion then
			if msg.err == 0 and msg.protoId == self.useprotoId then
				gf_print_table(msg,"使用血瓶")
				self.usepotion = false
				local now_time = Net:get_server_time_s()
				self.cur_potion_time =  now_time + ConfigMgr:get_config("item")[msg.protoId].effect_ex[1]
				self.coolpotion = true
				-- print("使用血瓶")
			end
		elseif id2== Net:get_id2("bag","UpdateItemR") then
			local data = ConfigMgr:get_config("item")
			if not msg.itemList and #msg.itemList == 0 then return end
			for k,v in pairs(msg.itemList) do
				local _d = data[self.cur_potion]
				if _d and _d.type ==ServerEnum.ITEM_TYPE.PROP and _d.sub_type == ServerEnum.PROP_TYPE.IMMED_ADD_HP_ITEM  then
					local on_bag = math.floor(v.slot/10000)
					print("血包更新",self.cur_potion)
					local potion_rel = data[self.cur_potion].rel_code
					if on_bag == ServerEnum.BAG_TYPE.NORMAL and (v.protoId == self.cur_potion or v.protoId == potion_rel)then
						self:update_potionBtn(v.protoId)
						print("血包更新2",v.protoId)
					elseif on_bag == ServerEnum.BAG_TYPE.NORMAL and self.cur_no_potion and data[v.protoId].sub_type ==  ServerEnum.PROP_TYPE.IMMED_ADD_HP_ITEM then
						self:update_potionBtn(v.protoId)
						self.cur_no_potion = nil
					end
				end
			end
		elseif id2== Net:get_id2("bag","SwapItemR") then
			if self.cur_potion~=nil then
				self:update_potionBtn(self.cur_potion)
			end
		end
	elseif id1 == ClientProto.OpenFuncSkill then
		self:wake_up_lock()
	elseif id1 == ClientProto.PlayerBlood then -- 血量刷新
		local Setting = LuaItemManager:get_item_obejct("setting")
		if msg.player_hp<=tonumber(Setting:get_setting_value(ClientEnum.SETTING.TAKE_MEDICINE))/100 then
			if not self.coolpotion then
				self:click_potion_btn(true)
			end
		end
	end
end

function AttackPanel:open_skill_fun()
	LuaItemManager:get_item_obejct("functionUnlock"):open_fun_do(true)
	self.close_effect_id = self.current_skill_id
	if not self.item_obj.show_atk_panel then
		self.ui:show_atk_panel(not self.item_obj.show_atk_panel)
	end
	print("技能指引",self.current_skill_id)
	if not  self.schedule_show then
		self.schedule_show = Schedule(handler(self, function()
			local data = self.filled_list[self.current_skill_id]
			LuaItemManager:get_item_obejct("functionUnlock"):unlock_skill(data.tb.icon,data.obj,data.obj.transform.position,data.tb.name)
			self.schedule_show:stop()
			self.schedule_show = nil 
			end), 0.1)
	end
end
--苏醒锁定技能
function AttackPanel:wake_up_lock()
	local data_unlock = ConfigMgr:get_config("skill_unlock")
	local level = LuaItemManager:get_item_obejct("game"):getLevel()
	for i=1,5 do
		if data_unlock[i].open_level > level  then
			self.filled_list[i].unlock:SetActive(true)
			self.filled_list[i].unlock_state = false
			if i~=5 then
				self.filled_list[i].unlock_text.text = data_unlock[i].open_level .."级"
			else
				self.filled_list[i].unlock_text.text =gf_localize_string("名将技")
				self.filled_list[i].obj:SetActive(false)
				self.filled_list[i].effect3:SetActive(false)
			end
		elseif self.filled_list[i].unlock_state == false then
			self.filled_list[i].unlock:SetActive(false)
			if i == 5 then  --XP技能
				self.filled_list[i].effect3:SetActive(true)
				self.filled_list[i].obj:SetActive(true)
			else
				self.filled_list[i].effect1:SetActive(true)
				self.open_time = 0
				self.filled_list[i].countdown1 =Schedule(handler(self, function()
						self.open_time = self.open_time +1
						self.filled_list[i].effect1:SetActive(false)
						LuaItemManager:get_item_obejct("functionUnlock"):open_fun_over()
						self.filled_list[i].countdown1:stop()
				end), 0.5)
			end
			self.filled_list[i].unlock_state = true
		end
	end
	self:next_unluck()
end

function AttackPanel:next_unluck()
	self.current_skill_unlock = nil
	for i=1,5 do
		if not self.filled_list[i].unlock_state then
			self.current_skill_unlock  = ConfigMgr:get_config("skill_unlock")[i].open_level
			self.current_skill_id = i
			return
		end
	end
end
--初始血瓶
function AttackPanel:init_potionBtn()
	local blood_id = LuaItemManager:get_item_obejct("game").role_info.immedProtoId
	self.cur_potion_time = LuaItemManager:get_item_obejct("game").role_info.immedHpTime
	print("初始化血瓶",self.cur_potion_time)
	local now_time = Net:get_server_time_s()
	local ct  = self.cur_potion_time-now_time
	if ct<=0 then
		self.coolpotion = false
	else
		self.coolpotion = true
	end
	print("血包",blood_id)
	if blood_id == 0 then 
		self:potion_exchange()
	else
		self:update_potionBtn(blood_id)
	end
end
--更新血瓶
function AttackPanel:update_potionBtn(protoId)
	local count = LuaItemManager:get_item_obejct("bag"):get_item_count(protoId,ServerEnum.BAG_TYPE.NORMAL)
	-- if count == 0  then
	-- 	-- self:potion_exchange()
	-- else
		self.cur_potion = protoId
		local cur_blood_tb = ConfigMgr:get_config("item")[protoId]
		gf_setImageTexture(self.filled_list["potionBtn"].icon,cur_blood_tb.icon)
		gf_setImageTexture(self.filled_list["potionBtn"].filled,cur_blood_tb.icon)
		self.filled_list["potionBtn"].count.text = count
	-- end

end
--使用血瓶
function AttackPanel:use_potion(protoId,ty)
	local tb =  LuaItemManager:get_item_obejct("bag"):get_item_for_protoId(protoId,ServerEnum.BAG_TYPE.NORMAL)
	if tb == nil then
		-- gf_create_quick_buy(protoId,1)
		if ty == nil then
			gf_create_quick_buy_by_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.IMMED_ADD_HP_ITEM,1)
		end
	elseif tb.num >0 then
		self.usepotion = true
		self.useprotoId = tb.protoId
		LuaItemManager:get_item_obejct("bag"):use_item_c2s(tb.guid,1,tb.protoId)
	else
		if ty == nil then
			gf_create_quick_buy_by_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.IMMED_ADD_HP_ITEM,1)
		end
	end
end
--更换血瓶
function AttackPanel:potion_exchange()
	local bag = LuaItemManager:get_item_obejct("bag")
	local sortFunc = function(a, b)
		if a.data.item_level ~= b.data.item_level then
       		return a.data.item_level < b.data.item_level
       	else
       		return a.data.bind < b.data.bind
       	end
    end
    local tb =  bag:get_item_for_type(ServerEnum.ITEM_TYPE.PROP,ServerEnum.PROP_TYPE.IMMED_ADD_HP_ITEM,ServerEnum.BAG_TYPE.NORMAL)
	print("血包1",tb)
	gf_print_table(tb,"血包2")
	if #tb == 0 then
		local data = ConfigMgr:get_config("item")
		for k,v in pairs(data) do
			if v.type ==ServerEnum.ITEM_TYPE.PROP and v.sub_type ==ServerEnum.PROP_TYPE.IMMED_ADD_HP_ITEM and v.item_level == 3 then
				gf_setImageTexture(self.filled_list["potionBtn"].icon,v.icon)
				gf_setImageTexture(self.filled_list["potionBtn"].filled,v.icon)
				self.filled_list["potionBtn"].count.text = 0
				self.cur_potion = v.code
				self.cur_no_potion = true
				break
			end
		end
	else
		table.sort(tb,sortFunc)
		gf_setImageTexture(self.filled_list["potionBtn"].icon,tb[1].data.icon)
		gf_setImageTexture(self.filled_list["potionBtn"].filled,tb[1].data.icon)
		self.filled_list["potionBtn"].count.text = tb[1].item.num
		self.cur_potion = tb[1].data.code
	end
end

return AttackPanel
