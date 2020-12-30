--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 09:57:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")

local AstrolabeView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "xingpan.u3d") -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function AstrolabeView:on_asset_load(key,asset)
end

function AstrolabeView:init_ui()
	self.top_toggle = {}
	self.task_list = {}

	self.open_system = 0
	self.cur_select_index = 1
	self.is_get_reward = false
	self.text_reward = self.refer:Get(3)
	self.text_amount = self.refer:Get(4)
	self.top_toggle_content = self.refer:Get(8)
	self.task_content = self.refer:Get(1)
	self.img_total_can_get = self.refer:Get(9)
	self.img_total_no_reach = self.refer:Get(10)
	self.btn_total_get_award = self.refer:Get(5)
	self.btn_total_get_award:SetActive(false)

	self.get_text = self.refer:Get(11)
	self.get_over = self.refer:Get(12)

	self.xingpan_beijin = self.refer:Get(13)
	self.xingpan_effect = self.refer:Get(14)
	local function top_update(scroll_rect_item,index,data_item)
		local button = scroll_rect_item:Get(2)
		local text = scroll_rect_item:Get(1)
		local h_text = scroll_rect_item:Get(3)
		if index == self.cur_select_index then
			scroll_rect_item:GetComponent("UnityEngine.UI.Button").interactable = false
			button.gameObject:SetActive(true)
		else
			scroll_rect_item:GetComponent("UnityEngine.UI.Button").interactable = true
			button.gameObject:SetActive(false)
		end
		if index <= self.open_system then
			local str = ConfigMgr:get_config("astrolabe_system")[index].name
			text.text = str
			h_text.text = str
			scroll_rect_item.name = "top" .. index
		else
			scroll_rect_item:GetComponent("UnityEngine.UI.Button").interactable = false
			text.text = "???"
			h_text.text = "???"
			scroll_rect_item.name = "top" .. index
		end

		local red_point = scroll_rect_item:Get(4)
		local has_red = LuaItemManager:get_item_obejct("astrolabe"):get_red(index)
		if has_red == true then
			red_point:SetActive(true)
		else
			red_point:SetActive(false)
		end
	end

	local function task_update(scroll_rect_item,index,data_item)
		local title = scroll_rect_item:Get(4)
		local text_amount = scroll_rect_item:Get(5)
		text_amount.gameObject:SetActive(false)
		local reward1 = scroll_rect_item:Get(8)
		local reward2 = scroll_rect_item:Get(9)
		local reward_icon_list = {reward1,reward2}
		local img_can_get = scroll_rect_item:Get(1)
		local img_no_reach = scroll_rect_item:Get(2)
		local button = scroll_rect_item:Get(12)

		local get_text = scroll_rect_item:Get(13)
		local get_over = scroll_rect_item:Get(3)

		local monster_item1 = scroll_rect_item:Get(15)
		local monster_item2 = scroll_rect_item:Get(16)
		local count = monster_item1:Get(2)
		count.text = ""
		count = monster_item2:Get(2)
		count.text = ""
		local monster_icon_list = {monster_item1,monster_item2}
		local monster_item_image1 = scroll_rect_item:Get(17)
		local monster_item_image2 = scroll_rect_item:Get(18)
		local monster_icon_list_image = {monster_item_image1,monster_item_image2}
		local target = ConfigMgr:get_config("astrolabe")[data_item.code].target
		if data_item.schedule < target then
			img_can_get:SetActive(false)
			img_no_reach:SetActive(true)
			button.gameObject:SetActive(false)
		else
			img_no_reach:SetActive(false)
			if data_item.rewarded == true then
				img_can_get:SetActive(false)
				get_over:SetActive(true)
				get_text:SetActive(false)
				button.interactable = false
			else
				img_can_get:SetActive(true)
				get_over:SetActive(false)
				get_text:SetActive(true)
				button.interactable = true
			end
			button.gameObject:SetActive(true)
		end
		button.name = "get_reward" .. data_item.code
		local str = ""
		local disc = ConfigMgr:get_config("astrolabe")[data_item.code].disc
		local c = gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
		if string.find(disc,"(%%d/%%d)") then
			disc = string.gsub(disc,"%(%%d/%%d%)","<color="..c..">(%%d/%%d)</color>")
			str = string.format(disc,math.min(data_item.schedule,target),target)
		else
			str = string.format("%s<color="..c..">(%d/%d)</color>",disc,math.min(data_item.schedule,target),target)
		end
		title.text = str

		local reward_list = ConfigMgr:get_config("astrolabe")[data_item.code].reward
		for i,v in ipairs(reward_icon_list) do
			if reward_list[i] ~= nil then
				v.gameObject:SetActive(true)
				local item_back = v:Get(1)
				local color_img = item_back:GetComponent(UnityEngine_UI_Image)
				local item_icon_img = v:Get(2)
				if reward_list[i][1] < 100 then
					gf_set_money_ico(item_icon_img,reward_list[i][1],color_img,true)
					item_back.name = ""
				else
					gf_set_item( reward_list[i][1], item_icon_img, color_img)
					item_back.name = "reward" .. reward_list[i][1]
				end

				local count = v:Get(3)
				local str = ""
				if 10000 <= reward_list[i][2] then
					str = math.floor(reward_list[i][2] / 10000) .. gf_localize_string("万")
				end
				count.text = tostring(str)
			else
				v.gameObject:SetActive(false)
			end
		end

		local btn_go = scroll_rect_item:Get(14)
		btn_go.name = "btnGo" .. data_item.code

		local equip_text = scroll_rect_item:Get(19)

		local icon_list = ConfigMgr:get_config("astrolabe")[data_item.code].icon

		if icon_list ~= nil then
			equip_text.gameObject:SetActive(true)
		else
			equip_text.gameObject:SetActive(false)
		end
		if ConfigMgr:get_config("astrolabe")[data_item.code].event ~= 1 then
			btn_go.gameObject:SetActive(false)
		else
			btn_go.gameObject:SetActive(true)
		end

		icon_list = icon_list or {}
		for i,v in ipairs(monster_icon_list) do
			if icon_list[i] ~= nil then
				v.gameObject:SetActive(true)
				local item_icon_img = v:Get(1)
				gf_set_item( icon_list[i][1], item_icon_img, monster_icon_list_image[i],icon_list[i][2],icon_list[i][3])
				gf_set_click_prop_tips(v.gameObject,icon_list[i][1],icon_list[i][2],icon_list[i][3])
			else
				v.gameObject:SetActive(false)
			end
		end
	end
	self.top_toggle_content.onItemRender = top_update
	self.task_content.onItemRender = task_update

	self.top_toggle_content.data = self.top_toggle
	self.task_content.data = self.task_list

	--[[local list = {
						{code = 1010101,schedule = 40000,rewarded = true},
						{code = 1010201,schedule = 40000,rewarded = 0},
						{code = 1010301,schedule = 40000,rewarded = 0},
						{code = 1010401,schedule = 40000,rewarded = 0},
						{code = 1010501,schedule = 40000,rewarded = 0},
						{code = 1010601,schedule = 40000,rewarded = 0},
						{code = 1010701,schedule = 40000,rewarded = 0},
					}
	local test_data = {list = list,systemRewarded = false,openSystem = 2}
	gf_send_and_receive(test_data, "task", "GetAstrolabeScheduleR")]]
	gf_setImageTexture(self.xingpan_beijin,ConfigMgr:get_config("astrolabe_system")[1].bg)
	gf_setImageTexture(self.xingpan_effect,ConfigMgr:get_config("astrolabe_system")[1].effect)
	self.text_reward.text = ""
	self.text_amount.text = ""
	--Net:send({system = 1},"task","GetAstrolabeSchedule")
	self.cur_select_index = LuaItemManager:get_item_obejct("astrolabe"):get_red_system()
	Net:send({system = self.cur_select_index},"task","GetAstrolabeSchedule")
end

function AstrolabeView:on_click( item_obj, obj, arg )
	local event_name = obj.name
	if string.find(event_name,"top") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"top","")
		index = tonumber(index)
		local pre_index = self.cur_select_index
		self.cur_select_index = index
		self.top_toggle_content:Refresh(self.cur_select_index - 1,self.cur_select_index - 1)
		self.top_toggle_content:Refresh(pre_index - 1,pre_index - 1)

		--[[local test_data = {[1] = {
									{code = 1010101,schedule = 40000,rewarded = true},
									{code = 1010201,schedule = 40000,rewarded = 0},
									{code = 1010301,schedule = 40000,rewarded = 0},
									{code = 1010401,schedule = 40000,rewarded = 0},
									{code = 1010501,schedule = 40000,rewarded = 0},
									{code = 1010601,schedule = 40000,rewarded = 0},
									{code = 1010701,schedule = 40000,rewarded = 0},
								},
							[2] = {
									{code = 1020101,schedule = 0,rewarded = 0},
									{code = 1020201,schedule = 0,rewarded = 0},
									{code = 1020301,schedule = 0,rewarded = 0},
									{code = 1020401,schedule = 0,rewarded = 0},
									{code = 1020501,schedule = 0,rewarded = 0},
									{code = 1020601,schedule = 0,rewarded = 0},
									{code = 1020701,schedule = 0,rewarded = 0},
							},
							[3] = {
									{code = 1030101,schedule = 0,rewarded = 0},
									{code = 1030201,schedule = 0,rewarded = 0},
									{code = 1030301,schedule = 0,rewarded = 0},
									{code = 1030401,schedule = 0,rewarded = 0},
									{code = 1030501,schedule = 0,rewarded = 0},
									{code = 1030601,schedule = 0,rewarded = 0},
							},
						}
		local data = {list = test_data[self.cur_select_index],systemRewarded = false,openSystem = 2}
		gf_send_and_receive(data, "task", "GetAstrolabeScheduleR")]]
		gf_setImageTexture(self.xingpan_beijin,ConfigMgr:get_config("astrolabe_system")[self.cur_select_index].bg)
		gf_setImageTexture(self.xingpan_effect,ConfigMgr:get_config("astrolabe_system")[self.cur_select_index].effect)
		Net:send({system = self.cur_select_index},"task","GetAstrolabeSchedule")
	elseif string.find(event_name,"get_reward") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local code = string.gsub(event_name,"get_reward","")
		code = tonumber(code)
		print("GetAstrolabeReward",code)
		local sid = Net:set_sid_param(code)
		Net:send({code = code},"task","GetAstrolabeReward",sid)
	elseif string.find(event_name,"btnGetPassSkill") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"btnGetPassSkill","")
		index = tonumber(index)
		local sid = Net:set_sid_param(index)
		Net:send({system = index},"task","GetAstrolabeSkill",sid)
	elseif string.find(event_name,"btnGo") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"btnGo","")
		index = tonumber(index)
		local map_id = gf_getItemObject("battle"):get_map_id()
		local map_list = ConfigMgr:get_config("astrolabe")[index].mapid
		local find_index
		for i,v in ipairs(map_list) do
			if v == map_id then
				find_index = i
				break
			end
		end
		if find_index == nil then		--表示不在这地图上
			find_index = math.random(1,#map_list)
		end
		local boss_id =  ConfigMgr:get_config("astrolabe")[index].condition[find_index] 
		gf_getItemObject("boss"):move_to_boss( boss_id )
	elseif event_name == "btnClose" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
	end
end
		
function AstrolabeView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function AstrolabeView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function AstrolabeView:on_showed()
	self:register()
	self:init_ui()
end

function AstrolabeView:on_hided( )
	self:cancel_register()
	--self:dispose()
end

function AstrolabeView:refresh_bottom()
	local target = #self.task_list
	local schedule = 0
	for i,v in ipairs(self.task_list) do
		local target = ConfigMgr:get_config("astrolabe")[v.code].target
		if target <= v.schedule then
			schedule = schedule + 1
		end
	end

	if schedule < target then
		self.btn_total_get_award:SetActive(false)
		self.img_total_can_get:SetActive(false)
		self.img_total_no_reach:SetActive(true)
	else
		self.btn_total_get_award:SetActive(true)
		if self.is_get_reward == true then
			self.btn_total_get_award:GetComponent("UnityEngine.UI.Button").interactable = false
			self.img_total_can_get:SetActive(false)
			self.img_total_no_reach:SetActive(false)
			self.get_text.gameObject:SetActive(false)
			self.get_over:SetActive(true)
		else
			self.btn_total_get_award:GetComponent("UnityEngine.UI.Button").interactable = true
			self.img_total_can_get:SetActive(true)
			self.img_total_no_reach:SetActive(false)
			self.get_text.gameObject:SetActive(true)
			self.get_over:SetActive(false)
		end
	end
	self.btn_total_get_award:GetComponent("UnityEngine.UI.Button").name = "btnGetPassSkill" .. self.cur_select_index
end

function AstrolabeView:show_page(index)
	self.task_content.data = self.task_list
	self.task_content:Refresh(0,#self.task_list - 1)
	self.task_content:ScrollTo(0)

	self:refresh_bottom()

	local res = ConfigMgr:get_config("astrolabe_system")[index].bg
	gf_setImageTexture(self.xingpan_beijin,res)
	gf_setImageTexture(self.xingpan_effect,ConfigMgr:get_config("astrolabe_system")[index].effect)
end

function AstrolabeView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetAstrolabeScheduleR") then
			print("GetAstrolabeScheduleR")
			gf_print_table(msg)
			if self.open_system == 0 then
				self.open_system = msg.openSystem
				self.top_toggle = {}
				for i = 1,self.open_system do
					table.insert(self.top_toggle,i)
				end
				if ConfigMgr:get_config("astrolabe_system")[self.open_system + 1] ~= nil then
					table.insert(self.top_toggle,self.open_system + 1)
				end
				self.top_toggle_content.data = self.top_toggle
				self.top_toggle_content:Refresh(0,#self.top_toggle - 1)
			end
			self.is_get_reward = msg.systemRewarded
			local is_cur_page = false
			if msg.list[1] ~= nil then
				local system = ConfigMgr:get_config("astrolabe")[msg.list[1].code].system
				if system == self.cur_select_index then
					is_cur_page = true
				end
			end
			if is_cur_page == true then
				self.task_list = {}
				local finish_count = 0
				for i,v in ipairs(msg.list) do
					local target = ConfigMgr:get_config("astrolabe")[v.code].target
					if target <= v.schedule then
						finish_count = finish_count + 1
					end
					table.insert(self.task_list,gf_deep_copy(v))
				end
				local function sort(a,b)
					return a.code <b.code
				end
				table.sort(self.task_list,sort)
				self:show_page(self.cur_select_index)

				local skill_id = ConfigMgr:get_config("astrolabe_system")[self.cur_select_index].skill
				local skill_name = ""
				local reward_schdule = ""
				local c = gf_get_text_color(ClientEnum.SET_GM_COLOR.GM_INTERFACE_ADD)
				if skill_id ~= nil then
					skill_name = ConfigMgr:get_config("skill")[skill_id].name
				end
				self.text_reward.text = skill_name
				self.text_amount.text = string.format("<color="..c..">".."%d/%d".."</color>",finish_count,#self.task_list)
			end
		elseif id2 == Net:get_id2("task", "GetAstrolabeRewardR") then
			print("GetAstrolabeRewardR")
			if msg.err == 0 then
				print("GetAstrolabeRewardR2",sid)
				gf_print_table(msg)
				local code = unpack(Net:get_sid_param(sid))
				for i,v in ipairs(self.task_list) do
					if code == v.code then
						v.rewarded = true
						self.task_content:Refresh(i - 1,i - 1)
						self:refresh_bottom()
						break
					end
				end
				self.top_toggle_content:Refresh(-1,-1)
				--[[local is_get_all_reward = false
				local get_count = 0
				for i,v in ipairs(self.task_list) do
					if v.rewarded == true then
						get_count = get_count + 1
					else
						break
					end
				end
				if is_get_all_reward == true then
					local system = ConfigMgr:get_config("astrolabe")[code].system
					if system == self.open_system then
						table.insert(self.top_toggle,self.open_system + 1,self.open_system + 1)
						self.top_toggle_content:Refresh(0,#self.top_toggle - 1)
					end
				end]]
			end
		elseif id2 == Net:get_id2("task", "GetAstrolabeSkillR") then
			print("GetAstrolabeSkillR")
			if msg.err == 0 then
				local code = unpack(Net:get_sid_param(sid))
				if code == self.cur_select_index then
					self.is_get_reward = true
					self:refresh_bottom()
				end
				self.top_toggle_content:Refresh(-1,-1)
			else
			end
		end
	end
end

-- 释放资源
function AstrolabeView:dispose()	
	self:cancel_register()
    self._base.dispose(self)
end

return AstrolabeView

