--[[--
--官职界面
-- @Author:Seven
-- @DateTime:2017-07-17 14:47:06
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local Enum = require("enum.enum")
local OfficerPositionView=class(Asset,function(self,item_obj)
    Asset._ctor(self, "officer_position.u3d") -- 资源名字全部是小写
    self.item_obj=item_obj
end)

-- 资源加载完成
function OfficerPositionView:on_asset_load(key,asset)
	-- self:set_bg_visible(true)
	self.property = ConfigMgr:get_config("propertyname")
	self.title =ConfigMgr:get_config("title") 
	self:init_ui()
	-- self:init_info()
end

function OfficerPositionView:init_ui()
	self.is_init = true
	self.left = self.refer:Get("left")
	self.right = self.refer:Get("right")
	self:init_left_position()
	self:init_right_position()
	self:update_view()
	-- self:refresh_left(self.item_obj.officer_left_data)
	-- self:refresh_right(self.item_obj.officer_right_data)
	-- local num_left = #self.item_obj.officer_left_data - self.item_obj.current_left.grade
	-- self.scroll_left_table:ScrollTo(num_left)
	-- local num_right = #self.item_obj.officer_right_data-self.item_obj.current_right.grade
	-- self.scroll_right_table:ScrollTo(num_right)
	-- self.t=Schedule(handler(self,self.countdown),1)
	-- self.current_time_s = os.date("%S",__NOW)
	-- self:current_residue_time()
end

-- function OfficerPositionView:init_info()
-- 	self.left:Get("txt_renown").text=gf_format_count(LuaItemManager:get_item_obejct("game"):get_money( Enum.BASE_RES.FAME ))
-- 	self.right:Get("txt_renown").text = gf_format_count(LuaItemManager:get_item_obejct("game"):get_money( Enum.BASE_RES.FEATS ))

-- end

function OfficerPositionView:register()
	self.item_obj:register_event("officerPosition_view_on_click",handler(self,self.on_click))
end

function OfficerPositionView:on_click(item_obj,obj,arg)
	local  cmd  = obj.name 
	if cmd == "get_btn_left" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:get_office_reward_c2s(Enum.POSITION_TYPE.CIVIL)
	elseif cmd == "get_btn_right" then
		Sound:play(ClientEnum.SOUND_KEY.COMMON_BTN) -- 通用按钮点击音效
		self.item_obj:get_office_reward_c2s(Enum.POSITION_TYPE.MILITARY)
	elseif cmd == "btnHelp" then
		gf_show_doubt(1151)
	end
end

----------------------------------------------------------左边文官------------------------------------------------------------

--选择
function OfficerPositionView:init_left_position()
	local tb = self.item_obj.current_left
	self:init_property(self.left:Get("cur"),tb)
	self.left:Get("cur"):Get(1).text = tb.name

	local data =  ConfigMgr:get_config("officerPosition")
	local next_code = tb.next_code
	if next_code == 0 then
		next_code = tb.code
	end
	self.left:Get("next"):Get(1).text = data[next_code].name
	self:init_property(self.left:Get("next"),data[next_code])
	for i=1,3 do
		if i<=#tb.award then
			local obj = self.left:Get("left_item"..i)
			obj.gameObject:SetActive(true)
			local code = ConfigMgr:get_config("base_res")[tb.award[i][1]].item_code
			gf_set_item(code,obj:Get("icon"..i),obj:Get("bg"..i))
			gf_set_click_prop_tips(obj.gameObject,code)
			if tb.award[i][2] == 0 then
				tb.award[i][2] = ""
			end
			obj:Get("count"..i).text = tb.award[i][2]
		else
			self.left:Get("left_item"..i).gameObject:SetActive(false)
		end
	end
	self:update_fame(tb,data[next_code])
end

function OfficerPositionView:update_fame(tb,next_tb)
	local Game = LuaItemManager:get_item_obejct("game")
	local cur_fame = Game:get_money(ServerEnum.BASE_RES.FAME)
	self.left:Get("txt_renown").text = cur_fame.."/"..next_tb.officer_value
	if next_tb.officer_value == tb.officer_value then
		self.left:Get("slider_image").value = 1
	else
		self.left:Get("slider_image").value = (cur_fame-tb.officer_value)/(next_tb.officer_value-tb.officer_value)
	end
end

------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------右边武官------------------------------------------------------------

--选择
function OfficerPositionView:init_right_position()
	local tb = self.item_obj.current_right
	self:init_property(self.right:Get("cur"),tb)
	self.right:Get("cur"):Get(1).text = tb.name

	local data =  ConfigMgr:get_config("officerPosition")
	local next_code = tb.next_code
	if next_code == 0 then
		next_code = tb.code
	end
	self.right:Get("next"):Get(1).text = data[next_code].name
	self:init_property(self.right:Get("next"),data[next_code])
	for i=1,3 do
		if i<=#tb.award then
			local obj = self.right:Get("right_item"..i)
			obj.gameObject:SetActive(true)
			local code = ConfigMgr:get_config("base_res")[tb.award[i][1]].item_code
			gf_set_item(code,obj:Get("icon"..i),obj:Get("bg"..i))
			gf_set_click_prop_tips(obj.gameObject,code)
			if tb.award[i][2] == 0 then
				tb.award[i][2] = ""
			end
			obj:Get("count"..i).text = tb.award[i][2]
		else
			self.right:Get("right_item"..i).gameObject:SetActive(false)
		end
	end
	self:update_feats(tb,data[next_code])
end

function OfficerPositionView:update_feats(tb,next_tb)
	local Game = LuaItemManager:get_item_obejct("game") 
	local cur_feats = Game:get_money(ServerEnum.BASE_RES.FEATS)
	self.right:Get("txt_renown").text = cur_feats.."/"..next_tb.officer_value
	self.right:Get("slider_image").value = (cur_feats-tb.officer_value)/(next_tb.officer_value-tb.officer_value)
end


------------------------------------------------------------------------------------------------------------------------------
function OfficerPositionView:init_property(item,tb)
	local amount = tb.attribute
	for i=1,6 do
		if i<=#amount then
			item:Get("attribute"..i):SetActive(true)
			item:Get("attribute_name_"..i).text = self.property[amount[i][1]].name
			item:Get("attribute_value_"..i).text = "+".. amount[i][2]
		else
			item:Get("attribute"..i):SetActive(false)
		end
	end
end

function OfficerPositionView:update_view()
	if self.item_obj.left_award then
		self.left:Get("get_over"):SetActive(true)
		self.left:Get(9):SetActive(false)
	else
		self.left:Get("get_over"):SetActive(false)
		self.left:Get(9):SetActive(true)
	end
	if self.item_obj.right_award then
		self.right:Get("get_over"):SetActive(true)
		self.right:Get(9):SetActive(false)
	else
		self.right:Get("get_over"):SetActive(false)
		self.right:Get(9):SetActive(true)
	end
	if self.item_obj.current_right.grade == 0 then
		self.right:Get(8):SetActive(false)
	else
		self.right:Get(8):SetActive(true)
	end
	if self.item_obj.current_left.grade == 0 then
		self.left:Get(8):SetActive(false)
	else
		self.left:Get(8):SetActive(true)
	end
end


function OfficerPositionView:on_showed()
	self:register()
	if self.is_init then
	-- 	-- self:update_view()
	-- 	self:init_info()
	-- 	self:register()
	-- 	-- self.t=Schedule(handler(self,self.countdown),1)
	-- 	-- self.current_time_s = os.date("%S",__NOW)
	-- 	-- self:current_residue_time()
	self:init_left_position()
	self:init_right_position()
	self:update_view()
	end
end


function OfficerPositionView:on_hided()
	-- self.t:stop()
	self.item_obj:register_event("officerPosition_view_on_click",nil)
end
-- 释放资源
function OfficerPositionView:dispose()
	self.is_init = false
	self.item_obj:register_event("officerPosition_view_on_click",nil)
    self._base.dispose(self)
end

return OfficerPositionView

