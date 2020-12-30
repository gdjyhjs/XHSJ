--[[--
--
-- @Author:Seven
-- @DateTime:2017-09-05 09:57:38
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3

local AchievementView=class(Asset,function(self,item_obj)
    self:set_bg_visible(true)
    Asset._ctor(self, "achievement.u3d") -- 资源名字全部是小写
    self.item_obj = item_obj
end)

-- 资源加载完成
function AchievementView:on_asset_load(key,asset)
end

function AchievementView:init_ui()
	print("AchievementView:init_ui")
	self.reflect_system = {1,2,3,4,5,6,7}
	local item_obj = LuaItemManager:get_item_obejct("achievement")
	local id = item_obj.id
    item_obj.id = nil
    if id ~= nil then
    	self.system_type = ConfigMgr:get_config("achieve")[id].system
    else
    	self.system_type = 1
    	for i = 1,7 do
			if LuaItemManager:get_item_obejct("achievement"):get_red_point(self.reflect_system[i]) == true then
				self.system_type = self.reflect_system[i]
				break
			end
		end
    end
    self.jump_to_id = id

	self.scroll_view_total = self.refer:Get(8)
	self.scroll_view_sort = self.refer:Get(9)
	self.total_ui = self.refer:Get(10)
	self.sort_ui = self.refer:Get(11)
	self.scroll_view_rect_total = self.refer:Get(26)
	self.scroll_view_rect_sort = self.refer:Get(27)

	self.scroll_view_total.data = {}
	self.scroll_view_sort.data = {}
	local function scroll_view_update(scroll_rect_item,index,data_item)
		local button
		if self.select_index == 1 then
			button = scroll_rect_item:Get(4)
		else
			button = scroll_rect_item:Get(8)
		end
		button.name = "btnReceive" .. data_item.id
		--local str = string.format("(%d/%d)",math.min(data_item.count,data_item.target),data_item.target)

		local have_reached --= scroll_rect_item:Get(7)
		local not_reached --= scroll_rect_item:Get(8)
		local txt_name
		local txt_condition
		if self.select_index == 1 then
			have_reached = scroll_rect_item:Get(7)
			not_reached = scroll_rect_item:Get(8)
			txt_name = scroll_rect_item:Get(5)
			txt_condition = scroll_rect_item:Get(6)

			local txt_achieve = scroll_rect_item:Get(9)
			txt_achieve.text = ConfigMgr:get_config("achieve")[data_item.id].point
		else
			have_reached = scroll_rect_item:Get(11)
			not_reached = scroll_rect_item:Get(12)
			txt_name = scroll_rect_item:Get(9)
			txt_condition = scroll_rect_item:Get(10)

			local txt_achieve = scroll_rect_item:Get(7)
			txt_achieve.text = ConfigMgr:get_config("achieve")[data_item.id].point
		end
		local name = ConfigMgr:get_config("achieve")[data_item.id].name or ""
		txt_name.text = name
		local condition = ConfigMgr:get_config("achieve")[data_item.id].disc
		if string.find(condition,"(%%d/%%d)") then
			condition = string.format(condition,math.min(data_item.count,data_item.target),data_item.target)
		end
		txt_condition.text = condition
		--if data_item.count < data_item.target then
		if not item_obj:is_finished(data_item.count,data_item.target,data_item.id) then
			button.gameObject:SetActive(false)
			have_reached.gameObject:SetActive(false)
			not_reached.gameObject:SetActive(true)
		else
			button.gameObject:SetActive(true)
			if data_item.receive == 1 then
				have_reached.gameObject:SetActive(true)
			else
				have_reached.gameObject:SetActive(false)
			end
			not_reached.gameObject:SetActive(false)
			local component = button.gameObject:GetComponent("UnityEngine.UI.Button")
			if data_item.receive ~= 1 then
				component.interactable = true
				button.gameObject:SetActive(true)
			else
				component.interactable = false
				button.gameObject:SetActive(false)
			end
		end
		local reward_list = ConfigMgr:get_config("achieve")[data_item.id].reward or {}
		for i,v in ipairs(reward_list) do
			local object_type = math.floor(v[1] / 10000000)
			if i == 1 then
				local item_back = scroll_rect_item:Get(1)
				local color_img = item_back:GetComponent(UnityEngine_UI_Image)
				local item_icon_img = scroll_rect_item:Get(2)
				if object_type == require("enum.enum").ITEM_TYPE.BASE then
					gf_set_money_ico(item_icon_img,v[1],color_img,true)
				else
					gf_set_item( v[1], item_icon_img, color_img)
				end
				--gf_set_click_prop_tips(color_img.gameObject,v[1])
				item_back.name = "item" .. v[1]
				local count = scroll_rect_item:Get(3)
				local str = ""
				if 10000 <= v[2] then
					str = tonumber(string.format("%.1f",v[2] / 10000)) .. "万"
				else 
					str = tostring(v[2])
				end
				count.text = str
			else
				if self.select_index ~= 1 then
					local item_back = scroll_rect_item:Get(4)
					local color_img = item_back:GetComponent(UnityEngine_UI_Image)
					local item_icon_img = scroll_rect_item:Get(5)
					if object_type == require("enum.enum").ITEM_TYPE.BASE then
						gf_set_money_ico(item_icon_img,v[1],color_img,true)
					else
						gf_set_item( v[1], item_icon_img, color_img)
					end
					--gf_set_click_prop_tips(color_img.gameObject,v[1])
					item_back.name = "item" .. v[1]

					local count = scroll_rect_item:Get(6)
					local str = ""
					if 10000 <= v[2] then
						str = tonumber(string.format("%.1f",v[2] / 10000)) .. "万"
					else 
						str = tostring(v[2])
					end
					count.text = str
				end
			end
		end
	end
	self.scroll_view_total.onItemRender = scroll_view_update
	self.scroll_view_sort.onItemRender = scroll_view_update

	self.select_index = 1
	if self.system_type ~= nil then
		for i,v in ipairs(self.reflect_system) do
			if v == self.system_type then
				self.select_index = i
				break
			end
		end
	end
	local data = ConfigMgr:get_config("achieve_point")
	for i,v in ipairs(self.reflect_system) do
		local name = data[v].sub_system
		local button = self.refer:Get(i)
		local text = button.transform:FindChild("txtNormal")
		text.gameObject:GetComponent("UnityEngine.UI.Text").text = name

		local select = button.transform:FindChild("select")
		text = select.transform:FindChild("txtSelect")
		text.gameObject:GetComponent("UnityEngine.UI.Text").text = name
	end
	local text_achive = self.refer:Get(28)
	text_achive.text = ""
	--[[self:show_page(self.select_index)]]
	Net:send({ system = self.system_type },"task","GetAchieveList")
	--测试代码
	--[[local item_obj = LuaItemManager:get_item_obejct("achievement")
	local test_data = item_obj.test_data
	local system_type = self.reflect_system[self.select_index]
	gf_send_and_receive(test_data[system_type], "task", "GetAchieveListR")]]

	for i = 1,7 do
		local button = self.refer:Get(i)
		local select = button.transform:FindChild("select")--LuaHelper.FindChild(button.gameObject,"select")
		if i == self.select_index then
			select.gameObject:SetActive(true)
		else
			select.gameObject:SetActive(false)
		end
		if LuaItemManager:get_item_obejct("achievement"):get_red_point(self.reflect_system[i]) == true then
			local red_point = button.transform:FindChild("red_point")
			red_point.gameObject:SetActive(true)
		end
	end

end

function AchievementView:on_click( item_obj, obj, arg )
	local event_name = obj.name
	if string.find(event_name,"achievePage") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local index = string.gsub(event_name,"achievePage","")
		index = tonumber(index)
		--self:show_page(index)
		self.select_index = index
		for i = 1,7 do
			local button = self.refer:Get(i)
			local select = button.transform:FindChild("select")--LuaHelper.FindChild(button.gameObject,"select")
			if i == index then
				select.gameObject:SetActive(true)
			else
				select.gameObject:SetActive(false)
			end
		end
		Net:send({ system = self.reflect_system[self.select_index] },"task","GetAchieveList")
		--测试数据
		--[[local item_obj = LuaItemManager:get_item_obejct("achievement")
		local test_data = item_obj.test_data
		local system_type = self.reflect_system[self.select_index]
		gf_send_and_receive(test_data[system_type], "task", "GetAchieveListR")]]
	elseif string.find(event_name,"btnReceive") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local id = string.gsub(event_name,"btnReceive","")
		id = tonumber(id)
		--测试数据
		Net:send({ code = id},"task","GetAchieveReward")
		--[[local test_data = {}
		test_data.code = id
		test_data.err = 0
		local data = ConfigMgr:get_config("achieve")
		print("sddfskdfjlsdjfsdfsda",id)
		if data[id + 1] ~= nil then
			test_data.nextAchieve = {family = math.floor(id/100),schedule = 60,rewarded = id % 100}
		end
		gf_send_and_receive(test_data, "task", "GetAchieveRewardR")]]
	elseif string.find(event_name,"item") then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		local id = string.gsub(event_name,"item","")
		id = tonumber(id)
		local object_type = math.floor(id / 10000000)
		if object_type ~= require("enum.enum").ITEM_TYPE.BASE then
			gf_getItemObject("itemSys"):common_show_item_info(id)
		end
	elseif event_name == "closeBtn" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN)
		self:dispose()
	end
end
		
function AchievementView:register()
	self.item_obj:register_event("on_click", handler(self, self.on_click))
end

function AchievementView:cancel_register()
	self.item_obj:register_event("on_click", nil)
end

function AchievementView:on_showed()
	self:register()
	self:init_ui()
end

function AchievementView:on_hided( )
	self:cancel_register()
	--self:dispose()
end

function AchievementView:show_page(index,idNeedToTop)
	self.select_index = index
	local item_obj = LuaItemManager:get_item_obejct("achievement")
	if index == 1 then
		self.total_ui:SetActive(true)
		self.sort_ui:SetActive(false)
		self.scroll_view_total.data = item_obj:get_data(self.reflect_system[index])
		self.scroll_view_sort.data = {}
		self.scroll_view_total:Refresh(0,#self.scroll_view_total.data - 1)
		self.scroll_view_sort:Refresh(0,0)
		self:refresh_page1()
	else
		self.total_ui:SetActive(false)
		self.sort_ui:SetActive(true)
		self.scroll_view_total.data = {}
		self.scroll_view_sort.data = item_obj:get_data(self.reflect_system[index])
		self.scroll_view_total:Refresh(0,0)
		self.scroll_view_sort:Refresh(0,#self.scroll_view_sort.data - 1)
	end
	if idNeedToTop == true then
		self.scroll_view_rect_sort:GetComponent("UnityEngine.UI.ScrollRect").verticalNormalizedPosition = 1
		self.scroll_view_rect_total:GetComponent("UnityEngine.UI.ScrollRect").verticalNormalizedPosition = 1
		--self.scroll_view_total:ScrollTo(0)
		--self.scroll_view_sort:ScrollTo(0)
	elseif self.jump_to_id ~= nil then
		--[[local data = item_obj:get_data(self.reflect_system[index])
		local index = 1
		for i,v in ipairs(data) do
			if self.jump_to_id == v.id then
				index = i
				break
			end
		end
		self:show_item_to_mid(index - 1)]]
		self.scroll_view_rect_sort:GetComponent("UnityEngine.UI.ScrollRect").verticalNormalizedPosition = 1
		self.scroll_view_rect_total:GetComponent("UnityEngine.UI.ScrollRect").verticalNormalizedPosition = 1
		--self.scroll_view_total:ScrollTo(0)
		--self.scroll_view_sort:ScrollTo(0)
		self.jump_to_id = nil
	end
end

function AchievementView:show_item_to_mid(index)
	if self.select_index == 1 then
		self.scroll_view_total:ScrollTo(index - 1)
	else
		self.scroll_view_sort:ScrollTo(index - 2)
	end
end

function AchievementView:refresh_page1()
	local image_list = {}
	for i = 1,7,1 do
		table.insert(image_list,self.refer:Get(11 + i))
	end
	local text_list = {}
	for i = 1,7,1 do
		table.insert(text_list,self.refer:Get(18 + i))
	end
	local name_list = {}
	for i = 1,7,1 do
		table.insert(name_list,self.refer:Get(28 + i))
	end
	local item_obj = LuaItemManager:get_item_obejct("achievement")
	local total_count = 0
	local total_target = 0
	for i,v in ipairs(self.reflect_system) do
		local count,target = item_obj:get_process(v)
		total_count = total_count + count
		total_target = total_target + target
	end
	local data = ConfigMgr:get_config("achieve_point")
	for i,v in ipairs(self.reflect_system) do
		if i ~= 1 then
			local count,target = item_obj:get_process(v)
			local percent = 0
			if target ~= 0 then
				percent = count / target
			end
			local object = image_list[i]
			local text = text_list[i]
			object.fillAmount = percent
			text.text = string.format("(%d/%d)",count,target)
			name_list[i].text = data[v].sub_system
		else
			local percent = 0
			if total_target ~= 0 then
				percent = total_count / total_target
			end
			local object = image_list[i]
			local text = text_list[i]
			object.fillAmount = percent
			text.text = string.format("(%d/%d)",total_count,total_target)
			name_list[i].text = gf_localize_string("成就总览")
		end
	end
end

function AchievementView:on_receive( msg, id1, id2, sid )
	if id1 == Net:get_id1("task") then
		if id2 == Net:get_id2("task", "GetAchieveRewardR") then
			local id =  msg.code
			local system = ConfigMgr:get_config("achieve")[id].system
			if self.reflect_system[self.select_index] == system then
				self:show_page(self.select_index)
			end
		elseif id2 == Net:get_id2("task", "GetAchieveListR") then
			if self.reflect_system[self.select_index] == msg.system then
				if self.jump_to_id ~= nil then
					self:show_page(self.select_index)
					self.jump_to_id = nil
				else
					self:show_page(self.select_index,true)
				end
			end
		end
	end
	if id1 == ClientProto.ShowHotPoint then
		if msg.btn_id == ClientEnum.MAIN_UI_BTN.ACHIEVEMENR then
			for i = 1,7 do
				local button = self.refer:Get(i)
				if LuaItemManager:get_item_obejct("achievement"):get_red_point(self.reflect_system[i]) == true then
					local red_point = button.transform:FindChild("red_point")
					red_point.gameObject:SetActive(true)
				else
					local red_point = button.transform:FindChild("red_point")
					red_point.gameObject:SetActive(false)
				end
			end
		end
	end
end

-- 释放资源
function AchievementView:dispose()	
	self:cancel_register()
    self._base.dispose(self)
end

return AchievementView

