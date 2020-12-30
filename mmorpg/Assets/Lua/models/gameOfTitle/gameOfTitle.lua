--[[--
--称号数据类
-- @Author:lyj
-- @DateTime:2017-06-20 11:30:00
--]]

local LuaHelper = LuaHelper
local Vector3 = UnityEngine.Vector3
local PlayerPrefs = UnityEngine.PlayerPrefs
local GetTitle =require("models.gameOfTitle.getTitle")
local TitleExpiredTip =require("models.gameOfTitle.titleExpiredTip")
local TitleChangeTip =require("models.gameOfTitle.titleChangeTip")
local GameOfTitle = LuaItemManager:get_item_obejct("gameOfTitle")
--UI资源
GameOfTitle.assets=
{
    View("gameOfTitleView", GameOfTitle) 
}
GameOfTitle.priority = ClientEnum.PRIORITY.LOADING
--点击事件
function GameOfTitle:on_click(obj,arg)
	-- self:call_event("gameOfTitle_view_on_click", false, obj, arg)
	-- return true
end

--每次显示时候调用
function GameOfTitle:on_showed()
end

--初始化函数只会调用一次
function GameOfTitle:initialize()
	
end

function GameOfTitle:is_redpoint()
	return self.title_red_point
end

function GameOfTitle:init()
	print("初始化称号开启")
	self:init_information()
	self.title_num = 0
	self.show_get_title = true
	self.left_tb={}
	self.cur_killwill = 0
end

function GameOfTitle:init_red_point()
	local role_id = LuaItemManager:get_item_obejct("game").role_id
	local s = PlayerPrefs.GetInt("Title"..role_id,0)
	print("称号11",s)
	if s == 0 then
		self.title_red_point = false
	else
		self.title_red_point = true
	end
end

--初始化信息
function GameOfTitle:init_information()
	self.title_data= {}
	local data =  ConfigMgr:get_config("title") 
	
	for k,v in pairs(data) do
		self.title_data[#self.title_data+1] = copy(data[k])    --不改变原来配置表
	end
	for k,v in pairs(self.title_data) do
			v.title_gain = false
			v.title_equip = false
			v.valid_time = 0
			v.red_point = false
	end
	self.property_data ={}
	local p_data = ConfigMgr:get_config("propertyname") 
	for k,v in pairs(p_data) do
		self.property_data[#self.property_data+1] = copy(p_data[k])    --不改变原来配置表
	end
	for k,v in pairs(self.property_data) do
		v.value = 0
	end

	local sortFunc = function(a,b)
		return a.code < b.code
    end
    table.sort(self.title_data,sortFunc)
end

--获取分类称号
function GameOfTitle:classify_title(tp)
	print("获取分类称号",tp)
	local tb ={}
	local t_tb = {}
	if tp == ClientEnum.TITLE_TYPE.SELF then
		tb = self:self_have_title()
		return tb
	end
	-- gf_print_table(self.title_data,"称号列表")
	local data = self:recently_title_info()
	for k,v in pairs(self.title_data) do
		if v.show_area == tp then
			tb[#tb+1] = v
		end
	end
	if tp == ClientEnum.TITLE_TYPE.CUT_WILL then
		index = nil
		local t_id = 0
		local t_data = nil
		for k,v in pairs(tb) do
			if v.title_gain and v.code > t_id then
				t_id = v.code
				t_data = v
				index = k
			end
		end
		if index then
			t_tb[#t_tb+1] = t_data
			self.cur_killwill = t_data.code
			table.remove(tb,index)
		end
		for k,v in pairs(tb) do --后找未激活的
			if not v.title_gain then
				t_tb[#t_tb+1] = v
			end
		end
		for k,v in pairs(tb) do --已激活的
			if v.title_gain then
				t_tb[#t_tb+1] = v
			end
		end
	else
		local index = nil
		if self.title_red_point then  --红点的
			if data then
				for k,v in pairs(tb) do
					if v.code == data.code then
						t_tb[1] = v
						index = k
					end
				end
			end
		end
		if index then
			table.remove(tb,index)
		end
		local now_time = Net:get_server_time_s()
		for k,v in pairs(tb) do --已激活的
			if v.title_gain then
				if v.valid_time>=now_time or  v.valid_time==0 then
					t_tb[#t_tb+1] = v
				end
			end
		end
		for k,v in pairs(tb) do --后找未激活的
			if not v.title_gain then
				t_tb[#t_tb+1] = v
			end
		end
		for k,v in pairs(tb) do
			if v.title_gain then
				if v.valid_time<now_time and v.valid_time~=0 then
					t_tb[#t_tb+1] = v
				end
			end
		end
	end
	return t_tb
end

function GameOfTitle:self_have_title()
	local now_time = Net:get_server_time_s()
	local data = ConfigMgr:get_config("title_show")
	local tb = {}
	for kk,vv in pairs(data) do  --特例排序
		for k,v in pairs(self.title_data) do
			if vv.code == v.code and v.title_gain then
				if v.valid_time>=now_time or  v.valid_time==0 then
					tb[#tb+1] = v
				end
			end
		end
	end
	local tb_2= {}
	for k,v in pairs(self.title_data) do --
		if v.title_gain and v.show_area ~= ClientEnum.TITLE_TYPE.CUT_WILL and not data[v.code] then
			if v.valid_time>=now_time or  v.valid_time==0 then
				tb_2[#tb_2+1] = v
			end
		end
	end
	local sortFunc = function(a,b)
		if a.show_area == b.show_area then
			return a.show_order < b.show_order
		else
			return a.show_area < b.show_area
		end
    end
    table.sort(tb_2,sortFunc)
    for k,v in pairs(tb_2) do
    	table.insert(tb,v)
    end
    local t_id = 0
    local t_data = nil
    for k,v in pairs(self.title_data) do
		if v.title_gain and v.show_area == ClientEnum.TITLE_TYPE.CUT_WILL and v.code > t_id then
			t_id = v.code
			t_data = v
		end
	end
	if t_data then
		self.cur_killwill = t_data.code
    	table.insert(tb,t_data)
	end
	for k,v in pairs(self.title_data) do
		if v.title_gain and v.show_area == ClientEnum.TITLE_TYPE.CUT_WILL then
			if t_data and v.code ~=t_data.code then
				table.insert(tb,v)
			end
		end
	end
	for k,v in pairs(self.title_data) do
		if v.valid_time<now_time and v.valid_time~=0 then
			table.insert(tb,v)
		end
	end
	return tb
end

--称号激活数量
function GameOfTitle:get_title_amount()
	local all = 0
	local title_num = 0
	for k,v in pairs(self.title_data) do
		if v.title_gain then
			title_num = title_num + 1
		end
		all = all + 1
	end
	self.title_num = title_num
	return title_num,all
end

function GameOfTitle:get_recently_title()
	local now_time = Net:get_server_time_s()
	local index = 0
	local code = 0
	for k,v in pairs(self.title_data) do
		if v.title_gain and v.time > index  then
			if v.valid_time and v.valid_time>=now_time then
				index = v.time
				code = v.code
			elseif v.valid_time == 0 then
				index = v.time
				code = v.code
			end
		end
	end
	self:set_recently_title(code)	
end

function GameOfTitle:on_receive(msg,id1,id2,sid)
	if(id1 == Net:get_id1("scene")) then
		if id2 == Net:get_id2("scene","GetTitleListR")  then --获取称号
			gf_print_table(msg,"称号1")
			gf_print_table(msg,"wtf receive GetTitleListR")
			self:init()
			self:get_title_list_s2c(msg.titles)
			self:get_recently_title()
			self:init_red_point()
			if msg.newCode ~=nil then --称号获得和改变
				self:get_titles(msg.newCode)
			end
			if msg.expiredCode ~=nil then
				self:title_overdue(msg)--称号过期
			end
		elseif id2 == Net:get_id2("scene","UpdateTitleInfoR")  then -- 新称号推送
			gf_print_table(msg,"称号2")
			self:update_new_title_s2c(msg)
		elseif id2 == Net:get_id2("scene","TakeonTitleR")  then -- 穿戴称号
			gf_print_table(msg,"称号3")
			if msg.err == 0 then
				self:take_on_title_s2c(msg.code)
			end
			gf_mask_show(false)
		elseif id2 == Net:get_id2("scene","CancelTitleRedPointR")  then -- 红点点击
			gf_print_table(msg,"称号4")
			if msg.code ~=0 then
				self:cancel_title_red_point_s2c(msg.code)
			end
		end
	end
end
--请求获取称号列表
function GameOfTitle:get_title_list_c2s()
	print("称号列表协议发送")
	Net:send({},"scene","GetTitleList")
end
--获取称号列表
function GameOfTitle:get_title_list_s2c(msg)
	self:equip_title()--第一次获取装备称号的信息
	if not msg or #msg ==0 then
		return
	end
	self.title_list = msg --id+时间戳的表（有排序获取最近的称号）
	local data = {}
	for i=1,#msg do
		for k,v in pairs(self.title_data) do
			if v.code == msg[i].code then
				print("获得称号列表",msg[i].code)
				print("获得称号列表T",msg[i].time)
				v.time = msg[i].time
				v.title_gain = true
				if msg[i].redPoint == 1 then --红点
					v.red_point = true
				end
				if v.type == 2 then
					v.valid_time = msg[i].validTime
				end
			end
		end
		-- --计算属性
		-- local attribute = data.attribute
		-- for i=1,#attribute do
		-- 	self.property_data[attribute[i][1]].value = self.property_data[attribute[i][1]].value + attribute[i][2]
		-- end
		self:math_property()
	end
	self:math_power(self.property_data)
end

--新称号推送
function GameOfTitle:update_new_title_s2c(msg)
	if msg.newTitle ~= nil and msg.delCode ~= nil then--称号改变
			local data = self:get_tb_data(msg.newTitle.code)
			print("称号改变")
			local title = msg.delCode
			for k,v in pairs(self.title_data) do
				if v.code == msg.delCode and v.title_gain then
					-- v.title_gain=false
					v.red_point = false
					v.title_equip = false
					-- self.title_change_state = data.step > v.step --判断升(t)还是降(f)
				end
				if v.code == msg.newTitle.code then
					v.title_gain=true
					if title == self.equip_title_id then --是否当前装备的
						self.equip_title_id = msg.newTitle.code
						v.title_equip = true
						self:update_obj_title()
					else
						v.red_point = true --红点
					end

				end
			end
			if title == self.recently_title_id then
				self:set_recently_title(msg.newTitle.code,false)
			end
			self.title_upgrade1 = title
			self.title_upgrade2 = msg.newTitle.code
			-- TitleChangeTip(self)
		-- 获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
		Sound:play(ClientEnum.SOUND_KEY.GET_ITEMS)
	elseif msg.newTitle == nil then --称号过期
			print("称号过期")
			self:title_overdue(msg)
	else --获得新称号
			-- print("获得称号")
			self:get_title(msg)
		-- 获得道具、装备、称号、材料、升VIP等时的音效（同时获得几样物品时，仅播放一次）
		Sound:play(ClientEnum.SOUND_KEY.GET_ITEMS)
	end
	self:math_property()
end
--称号过期
function GameOfTitle:title_overdue(msg)
	local data = self:get_tb_data(msg.expiredCode)
	-- data.title_gain = false
	data.red_point = false --红点
	self.overdue_title = msg.expiredCode
	if msg.expiredCode == self.recently_title_id then --最近的情况
		self:get_recently_title()
	end 
	if msg.expiredCode == self.equip_title_id then--装备的情况
		self.equip_title_id = 0
		self:update_obj_title()
		gf_message_tips("<color=".. ConfigMgr:get_config("color")[data.color_limit+1].color ..">"..data.name.."</color>称号已过期")
	end
	if data.end_ui_type == 1 then
		TitleExpiredTip(self)
	end
end

--多称号获取需要显示的 
function GameOfTitle:get_titles(t_id)
	-- for i=1,#msg do
	-- 	if msg[i].delCode == nil then --获得称号
			local data = self:get_tb_data(t_id)    
			if data.open_type == 1 then
				local t = "获得<color=".. ConfigMgr:get_config("color")[data.color_limit+1].color ..">"..data.name.."</color>称号"
				LuaItemManager:get_item_obejct("floatTextSys").assets[1]:add_leftbottom_broadcast(t)
				return
			elseif data.open_type == 2 then
				self.get_titles_list[#self.get_titles_list+1] = t_id
			end
	-- 	else --称号发生改变
	-- 		self.change_titles_list[#self.change_titles_list] = {msg.code,msg.delCode}
	-- 	end
	-- end
	GetTitle(self)
end
--称号获取
function GameOfTitle:get_title(msg)
	local tit_tb = self:get_tb_data(msg.newTitle.code)
	print("获得称号",tit_tb.name)
	if msg.newTitle.validTime ~= nil then
		tit_tb.valid_time = msg.newTitle.validTime
	end
	tit_tb.title_gain = true
	tit_tb.time = msg.newTitle.time
	self:set_recently_title(msg.newTitle.code,true) --最近获得
	tit_tb.red_point = true --红点
	if tit_tb.open_type == 2 then 
		self.get_titles_list = {msg.newTitle.code}
		GetTitle(self)
	elseif tit_tb.open_type == 1 then 
		local c = tit_tb.color_limit
		local t = "获得<color=".. ConfigMgr:get_config("color")[c+1].color ..">"..tit_tb.name.."</color>称号"
		gf_message_tips(t)
	end
end

--穿戴或卸下称号
function GameOfTitle:take_on_title_c2s(t_id)
	Net:send({code = t_id},"scene","TakeonTitle")
end
function GameOfTitle:take_on_title_s2c(t_id)
	local data = self:get_tb_data(t_id)
	if data.title_equip then --卸下
		data.title_equip = false
		self.equip_title_id = 0
		self:update_obj_title()
 	else--装备
 		data.title_equip = true
 		data.red_point = false
 		if self.equip_title_id ~= 0 then
 			print("当前装备id为",self.equip_title_id)
 			local tb = self:get_tb_data(self.equip_title_id)
 			tb.title_equip =false
 		end
 		if self.recently_title_id == t_id then -- 取消当前红点
 			self:set_recently_title(t_id,false)
 		end
 		self.equip_title_id = t_id
 		self:update_obj_title()
	end
	if self.show_get_title then
		self:title_left_red()
	else
		self.show_get_title = true
	end
end
--红点点击
function GameOfTitle:cancel_title_red_point_c2s(t_id)
	-- Net:send({code = t_id},"scene","CancelTitleRedPoint")
end
function GameOfTitle:cancel_title_red_point_s2c(t_id)
	local data = self:get_tb_data(t_id)
	data.red_point = false 
	self.assets[1]:update_title()
	self:title_left_red()
	self.assets[1]:init_red()
	if not self:is_redpoint() then --没有红点就通知关闭1级页签
		Net:receive({show=false,module=ClientEnum.MODULE_TYPE.PLAYER_INFO,a=5}, ClientProto.UIRedPoint)
	end
end

--登录获取当前装备称号
function GameOfTitle:equip_title()
	self.equip_title_id = LuaItemManager:get_item_obejct("game").role_info.title
	print("登录获取称号",self.equip_title_id)
	if self.equip_title_id  == 0 then
		return
	end
	for k,v in pairs(self.title_data) do
		if v.code == self.equip_title_id then 
			v.title_equip = true
			return
		end
	end
end

--装备称号信息
function GameOfTitle:equip_title_info()
	if self.equip_title_id == 0 then
		return
	end
	for k,v in pairs(self.title_data) do
		if v.code == self.equip_title_id then 
			return v
		end
	end
	return
end
--获取当前装备称号id(0-没有装备称号)
function GameOfTitle:get_equip_title()
	return self.equip_title_id
end

--登录获取最近称号
function GameOfTitle:set_recently_title(tid,ty)
	self.recently_title_id = tid
	if ty ~=nil then
		self.title_red_point = ty
		local role_id = LuaItemManager:get_item_obejct("game").role_id
		local index = 0
		if self.title_red_point then
			index = 1
		end 
		PlayerPrefs.SetInt("Title"..role_id,index)
		print("称号111",index)
		Net:receive({show=ty,module=ClientEnum.MODULE_TYPE.PLAYER_INFO,a=5}, ClientProto.UIRedPoint)
	end
end
--最近称号信息
function GameOfTitle:recently_title_info()
	if self.recently_title_id == nil then return end
	for k,v in pairs(self.title_data or {}) do
		if v.code == self.recently_title_id then 
			return v
		end
	end
	return
end


--根据id获取值
function GameOfTitle:get_tb_data(t_id)
	for k,v in pairs(self.title_data) do
		if v.code == t_id then 
			return v
		end
	end
	return
end



--计算总属性属性
function GameOfTitle:math_property()
	--清空
	for k,v in pairs(self.property_data) do
		v.value = 0
	end
	for k,v in pairs(self.title_data) do
		if v.title_gain then
			-- for i=1,#(v.attribute) do
			-- 	self.property_data[v.attribute[i][1]].value = self.property_data[v.attribute[i][1]].value + v.attribute[i][2]
			-- end
			for kk,vv in pairs(v.attribute) do
				-- self.property_data[vv[1]].value = self.property_data[vv[1]].value + vv[2]
				for kkk,vvv in pairs(self.property_data) do
					if vvv.property_type == vv[1] then
						vvv.value = vvv.value + vv[2]
					end
				end
			end
		end
	end
	self:math_power(self.property_data)
end
--计算称号战力
function GameOfTitle:math_power(data)
	local power = 0
    -- for i=bi,data do
    --     local attrV = data[i].value or 0
    --     local key = player_power_coefficient_idx[i]
    --     local coeff = player_power_coefficient[key]
    --     power = power + attrV * coeff
    -- end
    for k,v in pairs(data) do
    	power = power + v.value * v.conefficient*0.0001
    end
    self.title_power = math.ceil(power)
end

--红点左边显示
function GameOfTitle:title_left_red()

	for k,v in pairs(self.title_data) do
		if v.red_point and v.title_gain then
			if #self.left_tb==0 then
				self.left_tb[1] = v.show_area
			end
			local rt = true
			for i=1, #self.left_tb do
				if v.show_area == self.left_tb[i] then
					rt = false
				end
			end
			if rt then
				self.left_tb[#self.left_tb+1] = v.show_area
			end
		end
	end
end



--设置称号
function GameOfTitle:set_title_name()
	print("设置称号",self.equip_title_id)
	local t= self:equip_title_info()
	if  not t  then 	
		return gf_localize_string("暂无")
	else
		return t.name
	end 
end
--更新称号
function GameOfTitle:update_obj_title()
	Net:receive({title_id = self.equip_title_id }, ClientProto.TitleChange)
end

function GameOfTitle:get_groud_up(t_tp)
	local index = 0
	for k,v in pairs(self.title_data) do
		if v.group == t_tp and v.title_gain and v.step>index then
			index = v.step
		end
	end
	return index
end
















