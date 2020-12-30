--[[--
--
-- @Author:LiYunFei
-- @DateTime:2017-03-25 15:39:05
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Screen = UnityEngine.Screen

local SkillView=class(Asset,function(self,item_obj)
	self:set_bg_visible(true)
    Asset._ctor(self, "skill.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
    self.select_item = nil
    self.select_pass_item = nil
end)

-- 资源加载完成
function SkillView:on_asset_load(key,asset)
	self.select_index = 1
	self:init_ui()
	self.item_index = nil
	self.item_pass_index = nil
	self:refresh(self.item_obj.skill_list)
	self.item_obj:get_skill_list_c2c()
	self.init = true
end

--初始化UI
function SkillView:init_ui()
	self.is_init = true
	
	self.skill_type_1_sel = self.refer:Get(5)
	self.skill_type_2_sel = self.refer:Get(6)
	self.skill_type_1 = self.refer:Get(9)
	self.skill_type_2 = self.refer:Get(10)
	--self.skill_type_2.gameObject:SetActive(false)
	self.active_skill_obj = self.refer:Get(7)
	self.passive_skill_obj = self.refer:Get(8)

	self.scroll_table = self.active_skill_obj:GetComponentInChildren("Hugula.UGUIExtend.ScrollRectTable")
	self.scroll_table.onItemRender = handler(self, self.update_item)

	-- self.cur_skill_img = LuaHelper.FindChild(self.root, "image_sprite_currentskill"):GetComponent(UnityEngine_UI_Image)
	-- self.cur_skill_txt = LuaHelper.FindChild(self.root, "txt_name_currentskill"):GetComponent("UnityEngine.UI.Text")
	self.cur_dec_txt = LuaHelper.FindChild(self.active_skill_obj, "txt_description_currentskill"):GetComponent("UnityEngine.UI.Text")
	self.cur_level_txt = LuaHelper.FindChild(self.active_skill_obj, "txt_level_currentskill"):GetComponent("UnityEngine.UI.Text")
	self.next_level_txt = LuaHelper.FindChild(self.active_skill_obj, "txt_next_level"):GetComponent("UnityEngine.UI.Text")
	self.cur_level_dec_txt = LuaHelper.FindChild(self.active_skill_obj, "txt_power_left"):GetComponent("UnityEngine.UI.Text")
	self.next_level_dec_txt = LuaHelper.FindChild(self.active_skill_obj, "txt_power_right"):GetComponent("UnityEngine.UI.Text")

	self.limit_obj = LuaHelper.FindChild(self.active_skill_obj, "txt_ch_levelup")
	self.limit_obj:SetActive(false)
	self.limit_txt = self.limit_obj:GetComponent("UnityEngine.UI.Text")

	self.open = LuaHelper.FindChild(self.active_skill_obj, "open")
	self.close = LuaHelper.FindChild(self.active_skill_obj, "close")

	self.close_tips_txt = LuaHelper.FindChild(self.close, "closeTipsTxt"):GetComponent("UnityEngine.UI.Text")
	self.close_level_txt = LuaHelper.FindChild(self.close, "closeLevelTxt"):GetComponent("UnityEngine.UI.Text")
	self.close_content_txt = LuaHelper.FindChild(self.close, "closeLevelContentTxt"):GetComponent("UnityEngine.UI.Text")

	--消耗
	self.consume_txt = self.refer:Get("txt_consume")
	-- 拥有
	self.money_txt = self.refer:Get("txt_money")
	-- 左边金钱图标
	self.money_icon_l = self.refer:Get("money_icon_1")
	-- 右边金钱图标
	self.money_icon_r = self.refer:Get("money_icon_2")

	self.cur_lv_icon = self.refer:Get(11)
	self.next_lv_icon = self.refer:Get(12)

	self.image_center = self.refer:Get(13)
	self.image_center1 = self.refer:Get(14)
	self.upgrade_text = self.refer:Get(15)

	local component = self.passive_skill_obj:GetComponent("ReferGameObjects")
	self.passive_skill_scroll = component:Get(1)
	self.passive_skill_scroll.onItemRender = handler(self,self.update_pass_skill_item)
	self.passive_skill_name = component:Get(2)
	self.passive_skill_img = component:Get(3)
	self.passive_skill_effect_txt = component:Get(4)
	self.passive_skill_away_txt = component:Get(5)

	self.passive_skill_list = {}
	local data = ConfigMgr:get_config("astrolabe_system")
	for k,v in pairs(data) do
		if v.skill ~= nil then
			self.passive_skill_list[v.skill] = ConfigMgr:get_config("skill")[v.skill]
		end
	end

end

function SkillView:update_right(data)
	local next_data = ConfigMgr:get_config("skill")[data.code+1]
	-- gf_setImageTexture(self.cur_skill_img, data.icon)
	-- self.cur_skill_txt.text = data.name
	self.cur_dec_txt.text = data.desc
	self.cur_level_txt.text = data.level
	self.next_level_txt.text = data.level+1
	self.cur_level_dec_txt.text = self:get_level_dec(data)
	self.next_level_dec_txt.text = self:get_level_dec(next_data)
	self.limit_obj:SetActive(not data.is_can_up)

	local position = self.cur_level_dec_txt.gameObject.transform.localPosition

	if data.open == ClientEnum.SKILL_STATE.LOCK then
		self:change_to_close(true)
		self.close_tips_txt.text = string.format(gf_localize_string("%d级可学习得，努力升级吧！"), data.limited_level)
		self.cur_lv_icon:SetActive(true)
		self.next_lv_icon:SetActive(true)

		self.image_center:SetActive(true)
		self.image_center1:SetActive(true)
		self.upgrade_text.text = gf_localize_string("升级效果")
		position.x = -141.64
		-- self.cur_level_dec_txt.alignment = UnityEngine.TextAnchor.UpperLeft
		self.cur_level_dec_txt.gameObject.transform.localPosition = position
	else
		if next_data then
			self.limit_txt.text = string.format(gf_localize_string("角色等级%d级可升级"), next_data.limited_level)
			self.cur_lv_icon:SetActive(true)
			self.next_lv_icon:SetActive(true)

			self.image_center:SetActive(true)
			self.image_center1:SetActive(true)
			self.upgrade_text.text = gf_localize_string("升级效果")
			position.x = -141.64
			--self.cur_level_dec_txt.alignment = UnityEngine.TextAnchor.UpperLeft
			self.cur_level_dec_txt.gameObject.transform.localPosition = position
		else
			self.limit_txt.text = gf_localize_string("不可升级")

			self.cur_lv_icon:SetActive(false)
			self.next_lv_icon:SetActive(false)

			self.image_center:SetActive(false)
			self.image_center1:SetActive(false)
			self.upgrade_text.text = gf_localize_string("技能效果")
			position.x = 0
			--[[UnityEngine.TextAnchor.UpperCenter
			UnityEngine.TextAnchor.UpperLeft]]
			self.cur_level_dec_txt.alignment = UnityEngine.TextAnchor.UpperCenter
			self.cur_level_dec_txt.gameObject.transform.localPosition = position
		end
		self:change_to_close(false)
	end

	if next_data then
		self:update_money(next_data.learn_cost)
	else
		self:update_money()
	end
end

function SkillView:change_to_close( close )
	self.close:SetActive(close)
	self.open:SetActive(not close)
end

-- 刷新金钱
function SkillView:update_money( data )
	if data then
		data = data[1]
		gf_set_money_ico(self.money_icon_l, data[1])
		self.consume_txt.text = data[2]

		gf_set_money_ico(self.money_icon_r, data[1])
		self.money_txt.text = gf_format_count(gf_getItemObject("game"):get_money(data[1]))
	else
		self.consume_txt.text = 0
	end
end

function SkillView:get_level_dec( data )
	if not data then
		return ""
	end

	local id = math.floor(data.code/1000)
	local d = ConfigMgr:get_config("skillTips")[id]
	if not d then
		return ""
	end
	
	local str = ""
	local index = 1
	for i=1,4 do
		local dec = d["dec_"..i]
		if dec then
			local value
			if data.effect_type[index] == ServerEnum.SKILL_EFFECT.PROB_DAMAGE then -- 百分比伤害
				value = (data.effect_value[index]/100).."%"

			elseif data.effect_type[index] == ServerEnum.SKILL_EFFECT.VALUE_DAMAGE then -- 具体值伤害
				value = data.effect_value[index]

			elseif data.effect_type[index] == ServerEnum.SKILL_EFFECT.BUFF then -- buff
				value = ConfigMgr:get_config("buff")[data.effect_value[index]].duration/1000

			elseif data.effect_type[index] == ServerEnum.SKILL_EFFECT.STEAL_HEALTH then -- 生命窃取

			end
			if value ~= nil then
				str = str..string.format(dec, value).."\n"
			end
			index = index + 1
		end
	end
	return str
end

function SkillView:refresh(data)
	if self.select_index == 1 then
		local info = {}
		for i,v in ipairs(data) do
			if ConfigMgr:get_config("skill")[v.code].trigger_type ~= 2 then
				table.insert(info,v)
			end
		end
		table.remove(info, ServerEnum.SKILL_POS.NORMAL_1) -- 去掉普通攻击
		table.remove(info, ServerEnum.SKILL_POS.NORMAL_1) -- 去掉普通攻击
		table.remove(info, ServerEnum.SKILL_POS.NORMAL_1) -- 去掉普通攻击
		if self.item_obj.skill_index ~= nil and self.item_obj.skill_index <= #info then
			self.item_index = self.item_obj.skill_index
			self.item_obj.skill_index = nil
		end
		self.scroll_table.data = info
		self.scroll_table:Refresh(-1,-1) --显示列表
	else
		local info = {}
		for i,v in ipairs(data) do
			if ConfigMgr:get_config("skill")[v.code].trigger_type == 2 then
				table.insert(info,v)
			end
		end
		for k,v in pairs(self.passive_skill_list) do
			local index = 0
			for i,vv in ipairs(info) do
				if k == vv.code then
					index = i
					break
				end
			end
			if index == 0 then
				local temp = gf_deep_copy(v)
				temp.open = ClientEnum.SKILL_STATE.LOCK
				table.insert(info,temp)
			end
		end
		local function sort(a,b)
			local a_is_open = 1
			local b_is_open = 1
			if a.open == ClientEnum.SKILL_STATE.LOCK then
				a_is_open = 0
			end
			if b.open == ClientEnum.SKILL_STATE.LOCK then
				b_is_open = 0
			end
			if a_is_open ~= b_is_open then
				return a_is_open > b_is_open
			end
			return a.code < b.code
		end
		table.sort(info,sort)
		self.passive_skill_scroll.data = info
		self.passive_skill_scroll:Refresh(-1,-1) --显示列表
	end
end

function SkillView:update_item( item, index, data )
	gf_setImageTexture(item:Get(1), data.icon)
	item:Get(2).text = data.name -- 名字
	item:Get(3).text = data.level -- 等级

	-- 是否可以升级
	item:Get(6):SetActive(data.is_can_up)

	-- 是否解锁
	if data.open == ClientEnum.SKILL_STATE.OPEN then
		item:Get(4):SetActive(false)
	elseif data.open == ClientEnum.SKILL_STATE.LOCK then
		item:Get(4):SetActive(true)
		item:Get(6):SetActive(false)
		item:Get(5).text = string.format(gf_localize_string("%d级学习得"), data.limited_level)
	end

	local next_data = ConfigMgr:get_config("skill")[data.code + 1]
	if next_data ~= nil then
		next_data = next_data.learn_cost[1]
		local money = gf_getItemObject("game"):get_money(next_data[1])

		if money < next_data[2] then
			item:Get(6):SetActive(false)
		end
	end

	-- 选中框
	--if not self.select_item or self.select_item == item then
	if not self.item_index or self.item_index == index then
		self.item_index = index 
		self:select_skill(item, true)
	else
		item:Get(7):SetActive(false)
	end
	item.name = string.format("skillItem%d",index)
	if data.is_play_effect == true then
		self:show_up_level_effect(item)
	end
	data.is_play_effect = false
end

function SkillView:update_pass_skill_item( item, index, data )
	gf_setImageTexture(item:Get(1), data.icon)
--[[
超级法术
<color=#55A23DFF><size=20>七煞星盘2阶段</size></color>]]
	local pos = self:get_passive_skill_index(data.code)
	local name = string.format(gf_localize_string("%s\n<color=#55A23DFF><size=20>七煞星盘%d阶段</size></color>"),data.name,pos)
	item:Get(2).text = name -- 名字

	local skill_lock = item:Get(3)
	if data.open == ClientEnum.SKILL_STATE.LOCK then
		skill_lock:SetActive(true)
	else
		skill_lock:SetActive(false)
	end

	--if not self.select_pass_item or self.select_pass_item == item then
	if not self.item_pass_index or self.item_pass_index == index then
		self.item_pass_index = index
		self:select_pass_skill(item)
	else
		item:Get(4):SetActive(false)
	end
	item.name = string.format("passSkillItem%d",index)
end

function SkillView:select_skill( item, force )
	if self.select_item == item and not force then
		return
	end
	
	--[[if self.select_item then
		self.select_item:Get(7):SetActive(false)
	end]]
	item:Get(7):SetActive(true)
	self.select_item = item

	self:update_right(item.data)
end

function SkillView:select_pass_skill(item)
	local data = item.data
	--[[self.passive_skill_name = component:Get(2)
	self.passive_skill_img = component:Get(3)
	self.passive_skill_effect_txt = component:Get(4)
	self.passive_skill_away_txt = component:Get(5)]]
	--[[if self.select_pass_item then
		self.select_pass_item:Get(4):SetActive(false)
	end]]
	item:Get(4):SetActive(true)
	self.select_pass_item = item
	self.passive_skill_name.text = data.name
	gf_setImageTexture(self.passive_skill_img, data.icon)
	self.passive_skill_effect_txt.text = ConfigMgr:get_config("skill")[data.code].desc--self:get_level_dec( data )

	local index = self:get_passive_skill_index(data.code)
	local get_away = gf_localize_string("完成七煞星盘第%d阶段【%s】所有目标可获得")
	local str = string.format(get_away,index,self.passive_skill_list[data.code].name)
	self.passive_skill_away_txt.text = str
end
-- 显示升级特效
function SkillView:show_up_level_effect(item)
	item:Get(8):SetActive(false)   
    item:Get(8):SetActive(true)
    local delay_fn = function()
    	item:Get(8):SetActive(false)
    end
    delay(delay_fn,1)
end

--注册事件
function SkillView:register()
    self.item_obj:register_event("on_click", handler(self, self.on_click))
end

--点击事件
function SkillView:on_click(item_obj, obj, arg)
	local cmd = not Seven.PublicFun.IsNull(obj) and obj.name or ""
	if string.find(cmd,"skillItem") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local index = string.gsub(cmd,"skillItem","")
		index = tonumber(index)
		--self:select_skill(arg)
		if self.item_index ~= index then
			local last_index = self.item_index
			self.item_index = index
			self.scroll_table:Refresh(last_index-1,last_index-1)
			self.scroll_table:Refresh(self.item_index-1,self.item_index-1)
		end
	elseif string.find(cmd,"passSkillItem") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local index = string.gsub(cmd,"passSkillItem","")
		index = tonumber(index)
		--self:select_pass_skill(arg)
		if self.item_pass_index ~= index then
			local last_index = self.item_pass_index
			self.item_pass_index = index
			self.passive_skill_scroll:Refresh(last_index-1,last_index-1)
			self.passive_skill_scroll:Refresh(self.item_pass_index-1,self.item_pass_index-1)
		end
	elseif cmd == "btn_one_upgrade" then -- 升级
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		if not self.select_item.data.is_can_up then
			gf_message_tips(gf_localize_string("不可升级"), Vector2(UnityEngine.Screen.width/2, 200))
			return
		end
		print("btn_one_upgrade",self.select_item.data.pos_type)
		self.item_obj:skill_level_up_c2s(self.select_item.data.pos_type)

	elseif cmd == "btn_all_upgrade" then -- 全部升级
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		local can_up_list = {}
		local learn_cost = {}
		local level = LuaItemManager:get_item_obejct("game"):getLevel()
		local is_all_full_lv = true 		--是否都升到满级
		local is_lv_not_enough = true		--是否等级都不够
		local is_one_can_up = false
		for i,v in ipairs(self.scroll_table.data) do
			if ConfigMgr:get_config("skill")[v.code].trigger_type ~= 2 then
				local cur_code = v.code
				if ConfigMgr:get_config("skill")[cur_code+1] ~= nil then
					is_all_full_lv = false
					if ConfigMgr:get_config("skill")[cur_code+1].limited_level <= level then
						is_lv_not_enough = false
						local data = ConfigMgr:get_config("skill")[cur_code + 1]
						data = data.learn_cost[1]
						local money = gf_getItemObject("game"):get_money(data[1])
						if learn_cost[data[1]] == nil then
							learn_cost[data[1]] = 0
						end
						local left_money = money - learn_cost[data[1]]
						if data[2] <= left_money then
							learn_cost[data[1]] = learn_cost[data[1]] + data[2]
							can_up_list[v.pos_type] = true
							is_one_can_up = true
						else
							break
						end
					end
				end
			end
		end
	
		self.up_list = {}
		for i,v in pairs(can_up_list) do
			table.insert(self.up_list,i)
		end
		if is_all_full_lv == false and is_one_can_up == true and is_lv_not_enough == false then
			self.item_obj:one_key_skill_level_up_c2s()
		elseif is_all_full_lv == true then
			gf_message_tips(gf_localize_string("所有技能已经达到满级"), Vector2(UnityEngine.Screen.width/2, 200))
		elseif is_lv_not_enough == true then
			gf_message_tips(gf_localize_string("等级不足"), Vector2(UnityEngine.Screen.width/2, 200))
		else
			gf_message_tips(gf_localize_string("资源不足"), Vector2(UnityEngine.Screen.width/2, 200))
		end
	elseif cmd == "skillType1" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self.skill_type_1_sel:SetActive(true)
		self.skill_type_2_sel:SetActive(false)
		self.active_skill_obj:SetActive(true)
		self.passive_skill_obj:SetActive(false)
		self.skill_type_1.interactable = false
		self.skill_type_2.interactable = true
		self.select_index = 1
		self.scroll_table:ScrollTo(0)
		self.select_item = nil
		self:refresh(self.item_obj.skill_list)
	elseif cmd == "skillType2" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self.skill_type_1_sel:SetActive(false)
		self.skill_type_2_sel:SetActive(true)
		self.active_skill_obj:SetActive(false)
		self.passive_skill_obj:SetActive(true)
		self.skill_type_1.interactable = true
		self.skill_type_2.interactable = false
		self.select_index = 2
		self:refresh(self.item_obj.skill_list)
	elseif cmd == "btn_add_money" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		gf_create_model_view("moneyTree")
	end
end   

function SkillView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("scene") then
		if id2 == Net:get_id2("scene", "GetSkillListR") then
			if self.up_list ~= nil then
		    	for i,v in ipairs(self.item_obj.skill_list) do
			    	for ii,vv in ipairs(self.up_list or {}) do
			    		if v.pos_type == vv then
							v.is_play_effect = true
							break
						end
			    	end
			    end
			    self.up_list = nil
			end
			self:refresh(self.item_obj.skill_list)

		elseif id2 == Net:get_id2("scene", "SkillLevelUpR") then -- 升级成功
			if msg.err == 0 then
				print("SkillLevelUpR")
				for i,v in ipairs(self.item_obj.skill_list) do
					if v.pos_type == sid then
						v.is_play_effect = true
					end
				end
				self:refresh(self.item_obj.skill_list)
				--self:show_up_level_effect(self.select_item)
	        end
		elseif id2 == Net:get_id2("scene", "LearnSkillR") then -- 学习
			self:refresh(self.item_obj.skill_list)

		end
	end
end 

--进入主UI动画
function SkillView:on_showed()
	self:register()
	if self.init then
		self:refresh(self.item_obj.skill_list)
		self.item_obj:get_skill_list_c2c()
	end
end

function SkillView:on_hided()
	self.item_obj:register_event("on_click", nil)
end

-- 释放资源
function SkillView:dispose()
	self.init = nil
	self.item_obj:register_event("on_click", nil)
    self._base.dispose(self)
end

function SkillView:get_passive_skill_index(skill_id)
	local data = ConfigMgr:get_config("astrolabe_system")
	for i,v in pairs(data) do
		if skill_id == v.skill then
			return i
		end
	end
	return 0
end
return SkillView

